const Nutritionist = require('../../models/nutrition/nutritionistModel');
const jwt = require('jsonwebtoken');
const logger = require('../../config/modules/logger');

class NutritionistStatusWebSocketService {
  constructor() {
    this.io = null;
    this.connectedNutritionists = new Map(); // nutritionistId -> { socket, userId, status }
    this.userConnections = new Map(); // userId -> Set of socket ids
    this.statusUpdateTimers = new Map(); // nutritionistId -> timer
  }

  initialize(io) {
    this.io = io;
    
    // 创建营养师状态命名空间
    const statusNamespace = io.of('/nutritionist-status');
    
    statusNamespace.on('connection', async (socket) => {
      console.log('营养师状态连接:', socket.id);
      
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
        
        // 查找营养师信息
        const nutritionist = await Nutritionist.findOne({ userId });
        if (!nutritionist && userRole === 'nutritionist') {
          socket.emit('error', { message: '未找到营养师信息' });
          socket.disconnect();
          return;
        }
        
        // 保存连接信息
        if (nutritionist) {
          this.connectedNutritionists.set(nutritionist._id.toString(), {
            socket,
            userId,
            nutritionistId: nutritionist._id.toString(),
            status: nutritionist.onlineStatus
          });
        }
        
        // 维护用户连接映射
        if (!this.userConnections.has(userId)) {
          this.userConnections.set(userId, new Set());
        }
        this.userConnections.get(userId).add(socket.id);
        
        socket.userId = userId;
        socket.userRole = userRole;
        socket.nutritionistId = nutritionist ? nutritionist._id.toString() : null;
        
        // 处理营养师上线
        socket.on('go-online', async (data) => {
          await this.handleGoOnline(socket, data);
        });
        
        // 处理营养师下线
        socket.on('go-offline', async () => {
          await this.handleGoOffline(socket);
        });
        
        // 处理状态更新
        socket.on('update-status', async (data) => {
          await this.handleUpdateStatus(socket, data);
        });
        
        // 处理心跳
        socket.on('heartbeat', async () => {
          await this.handleHeartbeat(socket);
        });
        
        // 订阅营养师状态更新
        socket.on('subscribe-nutritionist-status', (nutritionistIds) => {
          this.handleSubscribeStatus(socket, nutritionistIds);
        });
        
        // 取消订阅
        socket.on('unsubscribe-nutritionist-status', (nutritionistIds) => {
          this.handleUnsubscribeStatus(socket, nutritionistIds);
        });
        
        // 处理断开连接
        socket.on('disconnect', () => {
          this.handleDisconnect(socket);
        });
        
        // 发送当前状态给客户端
        if (nutritionist) {
          socket.emit('status-initialized', {
            nutritionistId: nutritionist._id,
            status: nutritionist.onlineStatus
          });
        }
        
      } catch (error) {
        console.error('营养师状态WebSocket验证失败:', error);
        socket.emit('error', { message: '验证失败' });
        socket.disconnect();
      }
    });
  }
  
  // 处理营养师上线
  async handleGoOnline(socket, data) {
    if (!socket.nutritionistId) {
      socket.emit('error', { message: '非营养师用户无法上线' });
      return;
    }
    
    try {
      const { statusMessage, availableConsultationTypes } = data;
      
      const nutritionist = await Nutritionist.findById(socket.nutritionistId);
      if (!nutritionist) {
        socket.emit('error', { message: '营养师信息不存在' });
        return;
      }
      
      // 更新在线状态
      await nutritionist.updateOnlineStatus({
        isOnline: true,
        isAvailable: true,
        statusMessage,
        availableConsultationTypes
      });
      
      // 更新连接信息
      const connectionInfo = this.connectedNutritionists.get(socket.nutritionistId);
      if (connectionInfo) {
        connectionInfo.status = nutritionist.onlineStatus;
      }
      
      // 广播状态变更
      this.broadcastStatusChange(socket.nutritionistId, {
        isOnline: true,
        isAvailable: true,
        statusMessage,
        availableConsultationTypes,
        lastActiveAt: new Date()
      });
      
      socket.emit('online-success', {
        nutritionistId: socket.nutritionistId,
        status: nutritionist.onlineStatus
      });
      
      logger.info('营养师上线', { nutritionistId: socket.nutritionistId, userId: socket.userId });
      
    } catch (error) {
      console.error('营养师上线失败:', error);
      socket.emit('error', { message: '上线失败' });
    }
  }
  
  // 处理营养师下线
  async handleGoOffline(socket) {
    if (!socket.nutritionistId) {
      return;
    }
    
    try {
      const nutritionist = await Nutritionist.findById(socket.nutritionistId);
      if (!nutritionist) {
        return;
      }
      
      // 更新离线状态
      await nutritionist.updateOnlineStatus({
        isOnline: false,
        isAvailable: false
      });
      
      // 清除定时器
      if (this.statusUpdateTimers.has(socket.nutritionistId)) {
        clearTimeout(this.statusUpdateTimers.get(socket.nutritionistId));
        this.statusUpdateTimers.delete(socket.nutritionistId);
      }
      
      // 广播状态变更
      this.broadcastStatusChange(socket.nutritionistId, {
        isOnline: false,
        isAvailable: false,
        lastActiveAt: new Date()
      });
      
      socket.emit('offline-success', {
        nutritionistId: socket.nutritionistId
      });
      
      logger.info('营养师下线', { nutritionistId: socket.nutritionistId, userId: socket.userId });
      
    } catch (error) {
      console.error('营养师下线失败:', error);
      socket.emit('error', { message: '下线失败' });
    }
  }
  
  // 处理状态更新
  async handleUpdateStatus(socket, data) {
    if (!socket.nutritionistId) {
      socket.emit('error', { message: '非营养师用户无法更新状态' });
      return;
    }
    
    try {
      const { isAvailable, statusMessage, availableConsultationTypes } = data;
      
      const nutritionist = await Nutritionist.findById(socket.nutritionistId);
      if (!nutritionist) {
        socket.emit('error', { message: '营养师信息不存在' });
        return;
      }
      
      // 更新状态
      await nutritionist.updateOnlineStatus({
        isAvailable,
        statusMessage,
        availableConsultationTypes
      });
      
      // 广播状态变更
      this.broadcastStatusChange(socket.nutritionistId, {
        isAvailable,
        statusMessage,
        availableConsultationTypes,
        lastActiveAt: new Date()
      });
      
      socket.emit('status-updated', {
        nutritionistId: socket.nutritionistId,
        status: nutritionist.onlineStatus
      });
      
    } catch (error) {
      console.error('更新营养师状态失败:', error);
      socket.emit('error', { message: '状态更新失败' });
    }
  }
  
  // 处理心跳
  async handleHeartbeat(socket) {
    if (!socket.nutritionistId) {
      return;
    }
    
    try {
      // 更新最后活跃时间
      await Nutritionist.updateLastActive(socket.nutritionistId);
      
      socket.emit('heartbeat-ack', {
        timestamp: new Date()
      });
      
      // 设置下次心跳检测
      this.scheduleHeartbeatCheck(socket.nutritionistId);
      
    } catch (error) {
      console.error('心跳处理失败:', error);
    }
  }
  
  // 订阅营养师状态
  handleSubscribeStatus(socket, nutritionistIds) {
    if (!Array.isArray(nutritionistIds)) {
      socket.emit('error', { message: '无效的营养师ID列表' });
      return;
    }
    
    nutritionistIds.forEach(id => {
      socket.join(`nutritionist-status-${id}`);
    });
    
    socket.emit('subscribed', { nutritionistIds });
  }
  
  // 取消订阅营养师状态
  handleUnsubscribeStatus(socket, nutritionistIds) {
    if (!Array.isArray(nutritionistIds)) {
      return;
    }
    
    nutritionistIds.forEach(id => {
      socket.leave(`nutritionist-status-${id}`);
    });
    
    socket.emit('unsubscribed', { nutritionistIds });
  }
  
  // 处理断开连接
  handleDisconnect(socket) {
    console.log('营养师状态连接断开:', socket.id);
    
    // 清理连接信息
    if (socket.nutritionistId) {
      this.connectedNutritionists.delete(socket.nutritionistId);
      
      // 设置延迟下线（30秒后自动下线，除非重新连接）
      setTimeout(async () => {
        if (!this.connectedNutritionists.has(socket.nutritionistId)) {
          try {
            const nutritionist = await Nutritionist.findById(socket.nutritionistId);
            if (nutritionist && nutritionist.onlineStatus.isOnline) {
              await nutritionist.updateOnlineStatus({
                isOnline: false,
                isAvailable: false
              });
              
              this.broadcastStatusChange(socket.nutritionistId, {
                isOnline: false,
                isAvailable: false,
                lastActiveAt: new Date()
              });
              
              logger.info('营养师自动下线', { nutritionistId: socket.nutritionistId });
            }
          } catch (error) {
            console.error('自动下线失败:', error);
          }
        }
      }, 30000); // 30秒延迟
    }
    
    // 清理用户连接映射
    if (socket.userId) {
      const userSockets = this.userConnections.get(socket.userId);
      if (userSockets) {
        userSockets.delete(socket.id);
        if (userSockets.size === 0) {
          this.userConnections.delete(socket.userId);
        }
      }
    }
    
    // 清理定时器
    if (socket.nutritionistId && this.statusUpdateTimers.has(socket.nutritionistId)) {
      clearTimeout(this.statusUpdateTimers.get(socket.nutritionistId));
      this.statusUpdateTimers.delete(socket.nutritionistId);
    }
  }
  
  // 广播状态变更
  broadcastStatusChange(nutritionistId, statusUpdate) {
    const roomName = `nutritionist-status-${nutritionistId}`;
    
    this.io.of('/nutritionist-status').to(roomName).emit('status-changed', {
      nutritionistId,
      statusUpdate,
      timestamp: new Date()
    });
    
    // 同时通知咨询相关的其他命名空间
    if (this.io.of('/consultation-chat')) {
      this.io.of('/consultation-chat').emit('nutritionist-status-changed', {
        nutritionistId,
        statusUpdate,
        timestamp: new Date()
      });
    }
  }
  
  // 调度心跳检测
  scheduleHeartbeatCheck(nutritionistId) {
    // 清除现有定时器
    if (this.statusUpdateTimers.has(nutritionistId)) {
      clearTimeout(this.statusUpdateTimers.get(nutritionistId));
    }
    
    // 设置新的定时器（5分钟后检查）
    const timer = setTimeout(async () => {
      const connection = this.connectedNutritionists.get(nutritionistId);
      if (connection) {
        // 发送心跳检测
        connection.socket.emit('heartbeat-request');
        
        // 如果10秒内没有响应，标记为离线
        setTimeout(async () => {
          if (this.connectedNutritionists.has(nutritionistId)) {
            try {
              const nutritionist = await Nutritionist.findById(nutritionistId);
              if (nutritionist) {
                await nutritionist.updateOnlineStatus({
                  isOnline: false,
                  isAvailable: false
                });
                
                this.broadcastStatusChange(nutritionistId, {
                  isOnline: false,
                  isAvailable: false,
                  lastActiveAt: new Date()
                });
                
                logger.warn('营养师心跳超时，自动下线', { nutritionistId });
              }
            } catch (error) {
              console.error('心跳超时处理失败:', error);
            }
          }
        }, 10000);
      }
    }, 300000); // 5分钟
    
    this.statusUpdateTimers.set(nutritionistId, timer);
  }
  
  // 获取在线营养师统计
  async getOnlineStats() {
    try {
      const onlineCount = await Nutritionist.countDocuments({
        'onlineStatus.isOnline': true,
        'verification.verificationStatus': 'approved',
        status: 'active'
      });
      
      const availableCount = await Nutritionist.countDocuments({
        'onlineStatus.isOnline': true,
        'onlineStatus.isAvailable': true,
        'verification.verificationStatus': 'approved',
        status: 'active'
      });
      
      return {
        online: onlineCount,
        available: availableCount,
        connections: this.connectedNutritionists.size
      };
    } catch (error) {
      console.error('获取在线统计失败:', error);
      return { online: 0, available: 0, connections: 0 };
    }
  }
  
  // 强制营养师下线（管理员功能）
  async forceOffline(nutritionistId, reason = '管理员操作') {
    try {
      const nutritionist = await Nutritionist.findById(nutritionistId);
      if (!nutritionist) {
        return { success: false, message: '营养师不存在' };
      }
      
      await nutritionist.updateOnlineStatus({
        isOnline: false,
        isAvailable: false,
        statusMessage: `已下线: ${reason}`
      });
      
      // 断开连接
      const connection = this.connectedNutritionists.get(nutritionistId);
      if (connection) {
        connection.socket.emit('force-offline', { reason });
        connection.socket.disconnect();
      }
      
      this.broadcastStatusChange(nutritionistId, {
        isOnline: false,
        isAvailable: false,
        statusMessage: `已下线: ${reason}`,
        lastActiveAt: new Date()
      });
      
      logger.info('营养师被强制下线', { nutritionistId, reason });
      
      return { success: true, message: '营养师已下线' };
    } catch (error) {
      console.error('强制下线失败:', error);
      return { success: false, message: '操作失败' };
    }
  }
}

module.exports = new NutritionistStatusWebSocketService();