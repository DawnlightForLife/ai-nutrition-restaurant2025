/**
 * 聊天消息管理控制器
 * 处理咨询聊天消息的增删改查
 */

const Consultation = require('../../models/consult/consultationModel');
const Nutritionist = require('../../models/nutrition/nutritionistModel');
const User = require('../../models/user/userModel');
const { responseHelper } = require('../../utils');
const consultationChatWebSocketService = require('../../services/websocket/consultationChatWebSocketService');

/**
 * 获取聊天消息列表
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Promise<void>}
 */
const getChatMessageList = async (req, res) => {
  try {
    const { consultationId } = req.params;
    const { page = 1, limit = 50 } = req.query;
    
    // 获取咨询信息
    const consultation = await Consultation.findById(consultationId)
      .populate('userId', 'username nickname avatar')
      .populate('nutritionistId', 'name avatar');
    
    if (!consultation) {
      return responseHelper.error(res, { message: '咨询不存在' }, 404);
    }
    
    // 检查权限
    const userId = req.user._id.toString();
    const isUser = consultation.userId._id.toString() === userId;
    const isNutritionist = req.user.role === 'nutritionist' && 
      await checkIsNutritionist(userId, consultation.nutritionistId._id);
    
    if (!isUser && !isNutritionist && req.user.role !== 'admin') {
      return responseHelper.error(res, { message: '无权查看消息' }, 403);
    }
    
    // 计算分页
    const skip = (parseInt(page) - 1) * parseInt(limit);
    const messages = consultation.messages
      .slice()
      .reverse()
      .slice(skip, skip + parseInt(limit))
      .reverse();
    
    // 格式化消息
    const formattedMessages = await formatMessages(messages, consultation);
    
    // 标记消息为已读
    if (isUser || isNutritionist) {
      await markMessagesAsReadInternal(consultation, userId, isUser ? 'user' : 'nutritionist');
    }
    
    return responseHelper.success(res, {
      messages: formattedMessages,
      pagination: {
        total: consultation.messages.length,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(consultation.messages.length / parseInt(limit))
      },
      consultation: {
        id: consultation._id,
        topic: consultation.topic,
        status: consultation.status,
        user: consultation.userId,
        nutritionist: consultation.nutritionistId
      }
    });
    
  } catch (error) {
    console.error('获取聊天消息失败:', error);
    return responseHelper.error(res, error);
  }
};

/**
 * 发送聊天消息
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Promise<void>}
 */
const sendChatMessage = async (req, res) => {
  try {
    const { consultationId } = req.params;
    const { content, messageType = 'text', attachments = [] } = req.body;
    
    if (!content || content.trim() === '') {
      return responseHelper.error(res, { message: '消息内容不能为空' }, 400);
    }
    
    // 获取咨询信息
    const consultation = await Consultation.findById(consultationId);
    if (!consultation) {
      return responseHelper.error(res, { message: '咨询不存在' }, 404);
    }
    
    // 检查咨询状态
    if (['completed', 'cancelled'].includes(consultation.status)) {
      return responseHelper.error(res, { message: '咨询已结束，无法发送消息' }, 400);
    }
    
    // 检查权限
    const userId = req.user._id.toString();
    const isUser = consultation.userId.toString() === userId;
    const isNutritionist = req.user.role === 'nutritionist' && 
      await checkIsNutritionist(userId, consultation.nutritionistId);
    
    if (!isUser && !isNutritionist) {
      return responseHelper.error(res, { message: '无权发送消息' }, 403);
    }
    
    // 创建消息
    const senderType = isUser ? 'user' : 'nutritionist';
    const message = {
      senderType,
      senderId: userId,
      messageType,
      content: content.trim(),
      mediaUrl: attachments[0]?.url || null,
      sentAt: new Date(),
      isRead: false
    };
    
    // 保存消息
    consultation.messages.push(message);
    
    // 更新咨询状态
    if (consultation.status === 'pending' || consultation.status === 'scheduled') {
      consultation.status = 'inProgress';
      if (!consultation.startTime) {
        consultation.startTime = new Date();
      }
    }
    
    await consultation.save();
    
    // 获取保存后的消息
    const savedMessage = consultation.messages[consultation.messages.length - 1];
    
    // 格式化返回消息
    const formattedMessage = await formatSingleMessage(savedMessage, consultation, isUser);
    
    // 通过WebSocket广播消息（如果WebSocket服务可用）
    try {
      if (consultationChatWebSocketService) {
        const roomName = `consultation-${consultationId}`;
        consultationChatWebSocketService.io?.of('/consultation-chat').to(roomName).emit('new-message', formattedMessage);
      }
    } catch (wsError) {
      console.error('WebSocket广播失败:', wsError);
    }
    
    return responseHelper.success(res, formattedMessage, '消息发送成功');
    
  } catch (error) {
    console.error('发送聊天消息失败:', error);
    return responseHelper.error(res, error);
  }
};

/**
 * 标记消息已读
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Promise<void>}
 */
const markMessagesAsRead = async (req, res) => {
  try {
    const { consultationId } = req.params;
    const { messageIds } = req.body;
    
    const consultation = await Consultation.findById(consultationId);
    if (!consultation) {
      return responseHelper.error(res, { message: '咨询不存在' }, 404);
    }
    
    // 检查权限
    const userId = req.user._id.toString();
    const isUser = consultation.userId.toString() === userId;
    const isNutritionist = req.user.role === 'nutritionist' && 
      await checkIsNutritionist(userId, consultation.nutritionistId);
    
    if (!isUser && !isNutritionist) {
      return responseHelper.error(res, { message: '无权操作' }, 403);
    }
    
    // 更新已读状态
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
      
      // 通过WebSocket通知
      try {
        if (consultationChatWebSocketService) {
          const roomName = `consultation-${consultationId}`;
          consultationChatWebSocketService.io?.of('/consultation-chat').to(roomName).emit('messages-read', {
            consultationId,
            messageIds,
            readBy: userId,
            timestamp: new Date()
          });
        }
      } catch (wsError) {
        console.error('WebSocket通知失败:', wsError);
      }
    }
    
    return responseHelper.success(res, { updated }, '标记已读成功');
    
  } catch (error) {
    console.error('标记已读失败:', error);
    return responseHelper.error(res, error);
  }
};

/**
 * 删除消息
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Promise<void>}
 */
const deleteMessage = async (req, res) => {
  try {
    const { consultationId, messageId } = req.params;
    
    const consultation = await Consultation.findById(consultationId);
    if (!consultation) {
      return responseHelper.error(res, { message: '咨询不存在' }, 404);
    }
    
    // 查找消息
    const messageIndex = consultation.messages.findIndex(
      msg => msg._id.toString() === messageId
    );
    
    if (messageIndex === -1) {
      return responseHelper.error(res, { message: '消息不存在' }, 404);
    }
    
    const message = consultation.messages[messageIndex];
    
    // 检查权限（只能删除自己的消息）
    const userId = req.user._id.toString();
    if (message.senderId.toString() !== userId && req.user.role !== 'admin') {
      return responseHelper.error(res, { message: '无权删除此消息' }, 403);
    }
    
    // 标记为已删除（软删除）
    message.content = '[消息已删除]';
    message.deleted = true;
    message.deletedAt = new Date();
    
    await consultation.save();
    
    return responseHelper.success(res, null, '消息删除成功');
    
  } catch (error) {
    console.error('删除消息失败:', error);
    return responseHelper.error(res, error);
  }
};

// 辅助函数

/**
 * 检查用户是否是指定的营养师
 */
async function checkIsNutritionist(userId, nutritionistId) {
  const nutritionist = await Nutritionist.findById(nutritionistId);
  return nutritionist && nutritionist.userId.toString() === userId;
}

/**
 * 格式化消息列表
 */
async function formatMessages(messages, consultation) {
  const formattedMessages = [];
  
  for (const msg of messages) {
    const isUser = msg.senderType === 'user';
    const formattedMsg = await formatSingleMessage(msg, consultation, isUser);
    formattedMessages.push(formattedMsg);
  }
  
  return formattedMessages;
}

/**
 * 格式化单条消息
 */
async function formatSingleMessage(message, consultation, isUser) {
  let sender = null;
  
  if (isUser) {
    sender = consultation.userId;
  } else if (message.senderType === 'nutritionist') {
    sender = consultation.nutritionistId;
  }
  
  return {
    id: message._id,
    consultationId: consultation._id,
    senderType: message.senderType,
    senderId: isUser ? consultation.userId._id : consultation.nutritionistId._id,
    senderName: isUser ? (consultation.userId.nickname || consultation.userId.username) : consultation.nutritionistId.name,
    senderAvatar: isUser ? consultation.userId.avatar : consultation.nutritionistId.avatar,
    content: message.content,
    messageType: message.messageType,
    mediaUrl: message.mediaUrl,
    sentAt: message.sentAt,
    isRead: message.isRead,
    deleted: message.deleted || false
  };
}

/**
 * 内部函数：标记消息为已读
 */
async function markMessagesAsReadInternal(consultation, userId, readerType) {
  let hasUnread = false;
  
  consultation.messages.forEach(msg => {
    if (msg.senderType !== readerType && !msg.isRead) {
      msg.isRead = true;
      hasUnread = true;
    }
  });
  
  if (hasUnread) {
    await consultation.save();
  }
}

// 导出控制器方法
module.exports = {
  getChatMessageList,
  sendChatMessage,
  markMessagesAsRead,
  deleteMessage
};
