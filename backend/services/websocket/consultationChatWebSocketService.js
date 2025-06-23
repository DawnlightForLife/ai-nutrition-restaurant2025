const Consultation = require('../../models/consult/consultationModel');
const Nutritionist = require('../../models/nutrition/nutritionistModel');
const User = require('../../models/user/userModel');
const jwt = require('jsonwebtoken');

class ConsultationChatWebSocketService {
  constructor() {
    this.io = null;
    this.connectedClients = new Map();
    this.consultationRooms = new Map();
    this.typingStatus = new Map();
  }

  initialize(io) {
    this.io = io;
    
    // 创建咨询聊天命名空间
    const chatNamespace = io.of('/consultation-chat');
    
    chatNamespace.on('connection', async (socket) => {
      console.log('客户端连接到咨询聊天:', socket.id);
      
      // 验证用户身份
      const token = socket.handshake.auth.token;
      if (!token) {
        socket.emit('error', { message: '未授权访问' });
        socket.disconnect();
        return;
      }
      
      try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const userId = decoded.id;
        const userRole = decoded.role;
        
        // 保存客户端连接信息
        this.connectedClients.set(socket.id, {
          userId,
          userRole,
          socket
        });
        
        // 处理加入咨询房间
        socket.on('join-consultation', async (data) => {
          await this.handleJoinConsultation(socket, userId, userRole, data);
        });
        
        // 处理发送消息
        socket.on('send-message', async (data) => {
          await this.handleSendMessage(socket, userId, userRole, data);
        });
        
        // 处理正在输入状态
        socket.on('typing', async (data) => {
          await this.handleTyping(socket, userId, data);
        });
        
        // 处理停止输入
        socket.on('stop-typing', async (data) => {
          await this.handleStopTyping(socket, userId, data);
        });
        
        // 处理标记已读
        socket.on('mark-read', async (data) => {
          await this.handleMarkRead(socket, userId, data);
        });
        
        // 处理离开咨询
        socket.on('leave-consultation', async (data) => {
          await this.handleLeaveConsultation(socket, userId, data);
        });
        
        // 处理断开连接
        socket.on('disconnect', () => {
          this.handleDisconnect(socket);
        });
        
      } catch (error) {
        console.error('验证失败:', error);
        socket.emit('error', { message: '验证失败' });
        socket.disconnect();
      }
    });
  }
  
  // 处理加入咨询房间
  async handleJoinConsultation(socket, userId, userRole, data) {
    const { consultationId } = data;
    
    try {
      // 验证用户是否有权限访问该咨询
      const consultation = await Consultation.findById(consultationId)
        .populate('userId', 'username nickname avatar')
        .populate('nutritionistId', 'name avatar');
        
      if (!consultation) {
        socket.emit('error', { message: '咨询不存在' });
        return;
      }
      
      // 检查权限
      const isUser = consultation.userId._id.toString() === userId;
      const isNutritionist = userRole === 'nutritionist' && 
        await this.isUserNutritionist(userId, consultation.nutritionistId._id);
      
      if (!isUser && !isNutritionist) {
        socket.emit('error', { message: '无权访问此咨询' });
        return;
      }
      
      // 加入房间
      const roomName = `consultation-${consultationId}`;
      socket.join(roomName);
      
      // 记录房间信息
      if (!this.consultationRooms.has(consultationId)) {
        this.consultationRooms.set(consultationId, new Set());
      }
      this.consultationRooms.get(consultationId).add(socket.id);
      
      // 发送咨询信息和历史消息
      socket.emit('consultation-joined', {
        consultation: {
          id: consultation._id,
          topic: consultation.topic,
          status: consultation.status,
          user: consultation.userId,
          nutritionist: consultation.nutritionistId
        },
        messages: consultation.messages.slice(-50) // 最近50条消息
      });
      
      // 通知其他用户有人加入
      socket.to(roomName).emit('user-joined', {
        userId,
        userRole,
        timestamp: new Date()
      });
      
      // 更新咨询状态（如果需要）
      if (consultation.status === 'scheduled' && isNutritionist) {
        consultation.status = 'inProgress';
        consultation.startTime = new Date();
        await consultation.save();
        
        // 通知状态变更
        this.io.of('/consultation-chat').to(roomName).emit('consultation-status-changed', {
          consultationId,
          status: 'inProgress',
          startTime: consultation.startTime
        });
      }
      
    } catch (error) {
      console.error('加入咨询失败:', error);
      socket.emit('error', { message: '加入咨询失败' });
    }
  }
  
  // 处理发送消息
  async handleSendMessage(socket, userId, userRole, data) {
    const { consultationId, content, messageType = 'text', attachments = [] } = data;
    
    try {
      // 获取咨询信息
      const consultation = await Consultation.findById(consultationId);
      if (!consultation) {
        socket.emit('error', { message: '咨询不存在' });
        return;
      }
      
      // 验证权限
      const isUser = consultation.userId.toString() === userId;
      const isNutritionist = userRole === 'nutritionist' && 
        await this.isUserNutritionist(userId, consultation.nutritionistId);
      
      if (!isUser && !isNutritionist) {
        socket.emit('error', { message: '无权发送消息' });
        return;
      }
      
      // 创建消息
      const senderType = isUser ? 'user' : 'nutritionist';
      const message = {
        senderType,
        senderId: userId,
        messageType,
        content,
        mediaUrl: attachments[0]?.url || null,
        sentAt: new Date(),
        isRead: false
      };
      
      // 保存消息到咨询记录
      consultation.messages.push(message);
      await consultation.save();
      
      // 获取发送者信息
      const sender = isUser 
        ? await User.findById(userId).select('username nickname avatar')
        : await Nutritionist.findById(consultation.nutritionistId).select('name avatar');
      
      // 广播消息到房间
      const roomName = `consultation-${consultationId}`;
      const messageData = {
        id: consultation.messages[consultation.messages.length - 1]._id,
        consultationId,
        senderType,
        senderId: isUser ? userId : consultation.nutritionistId,
        senderName: isUser ? (sender.nickname || sender.username) : sender.name,
        senderAvatar: sender.avatar,
        content,
        messageType,
        attachments,
        sentAt: message.sentAt,
        isRead: false
      };
      
      this.io.of('/consultation-chat').to(roomName).emit('new-message', messageData);
      
      // 发送推送通知（如果接收方离线）
      await this.sendPushNotification(consultation, messageData, isUser);
      
    } catch (error) {
      console.error('发送消息失败:', error);
      socket.emit('error', { message: '发送消息失败' });
    }
  }
  
  // 处理正在输入状态
  async handleTyping(socket, userId, data) {
    const { consultationId } = data;
    const roomName = `consultation-${consultationId}`;
    
    // 记录输入状态
    const typingKey = `${consultationId}-${userId}`;
    this.typingStatus.set(typingKey, {
      userId,
      timestamp: Date.now()
    });
    
    // 广播输入状态
    socket.to(roomName).emit('user-typing', {
      consultationId,
      userId,
      timestamp: new Date()
    });
    
    // 3秒后自动清除输入状态
    setTimeout(() => {
      const status = this.typingStatus.get(typingKey);
      if (status && Date.now() - status.timestamp >= 3000) {
        this.typingStatus.delete(typingKey);
        socket.to(roomName).emit('user-stop-typing', {
          consultationId,
          userId
        });
      }
    }, 3000);
  }
  
  // 处理停止输入
  async handleStopTyping(socket, userId, data) {
    const { consultationId } = data;
    const roomName = `consultation-${consultationId}`;
    
    // 清除输入状态
    const typingKey = `${consultationId}-${userId}`;
    this.typingStatus.delete(typingKey);
    
    // 广播停止输入
    socket.to(roomName).emit('user-stop-typing', {
      consultationId,
      userId
    });
  }
  
  // 处理标记已读
  async handleMarkRead(socket, userId, data) {
    const { consultationId, messageIds } = data;
    
    try {
      const consultation = await Consultation.findById(consultationId);
      if (!consultation) return;
      
      // 更新消息已读状态
      let updated = false;
      consultation.messages.forEach(msg => {
        if (messageIds.includes(msg._id.toString()) && 
            msg.senderId.toString() !== userId && 
            !msg.isRead) {
          msg.isRead = true;
          updated = true;
        }
      });
      
      if (updated) {
        await consultation.save();
        
        // 通知发送者消息已读
        const roomName = `consultation-${consultationId}`;
        socket.to(roomName).emit('messages-read', {
          consultationId,
          messageIds,
          readBy: userId,
          timestamp: new Date()
        });
      }
      
    } catch (error) {
      console.error('标记已读失败:', error);
    }
  }
  
  // 处理离开咨询
  async handleLeaveConsultation(socket, userId, data) {
    const { consultationId } = data;
    const roomName = `consultation-${consultationId}`;
    
    // 离开房间
    socket.leave(roomName);
    
    // 更新房间信息
    if (this.consultationRooms.has(consultationId)) {
      this.consultationRooms.get(consultationId).delete(socket.id);
      if (this.consultationRooms.get(consultationId).size === 0) {
        this.consultationRooms.delete(consultationId);
      }
    }
    
    // 通知其他用户
    socket.to(roomName).emit('user-left', {
      userId,
      timestamp: new Date()
    });
  }
  
  // 处理断开连接
  handleDisconnect(socket) {
    console.log('客户端断开连接:', socket.id);
    
    // 清理连接信息
    const clientInfo = this.connectedClients.get(socket.id);
    if (clientInfo) {
      // 清理所有相关的输入状态
      for (const [key, value] of this.typingStatus.entries()) {
        if (value.userId === clientInfo.userId) {
          this.typingStatus.delete(key);
        }
      }
    }
    
    this.connectedClients.delete(socket.id);
    
    // 从所有房间中移除
    for (const [consultationId, sockets] of this.consultationRooms.entries()) {
      if (sockets.has(socket.id)) {
        sockets.delete(socket.id);
        if (sockets.size === 0) {
          this.consultationRooms.delete(consultationId);
        }
      }
    }
  }
  
  // 检查用户是否是指定的营养师
  async isUserNutritionist(userId, nutritionistId) {
    const nutritionist = await Nutritionist.findById(nutritionistId);
    return nutritionist && nutritionist.userId.toString() === userId;
  }
  
  // 发送推送通知
  async sendPushNotification(consultation, message, isFromUser) {
    // TODO: 实现推送通知逻辑
    // 这里可以集成第三方推送服务，如极光推送、个推等
    const recipientId = isFromUser ? consultation.nutritionistId : consultation.userId;
    console.log(`发送推送通知给用户: ${recipientId}`);
  }
  
  // 广播系统消息
  async broadcastSystemMessage(consultationId, content) {
    const roomName = `consultation-${consultationId}`;
    this.io.of('/consultation-chat').to(roomName).emit('system-message', {
      consultationId,
      content,
      timestamp: new Date()
    });
  }
  
  // 结束咨询
  async endConsultation(consultationId, endedBy) {
    const roomName = `consultation-${consultationId}`;
    
    // 通知所有用户咨询已结束
    this.io.of('/consultation-chat').to(roomName).emit('consultation-ended', {
      consultationId,
      endedBy,
      timestamp: new Date()
    });
    
    // 清理房间
    this.consultationRooms.delete(consultationId);
  }
}

module.exports = new ConsultationChatWebSocketService();