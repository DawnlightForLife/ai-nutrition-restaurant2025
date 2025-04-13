const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const shardAccessService = require('../../services/core/shardAccessService');

/**
 * 消息提醒模型 - 处理系统通知、未读状态、关联对象等
 * @version v2.3.0
 * @author AI营养餐厅项目组
 * @description 该模型用于存储用户相关的所有通知消息
 */

// 定义消息提醒模型的结构
const notificationSchema = new mongoose.Schema({
  // 基本字段
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true,
    sensitivity_level: 2  // 中度敏感数据
  },
  type: {
    type: String,
    required: true,
    enum: [
      'system', 'order', 'payment', 'health', 'reminder',
      'forum', 'promotion', 'security', 'subscription', 'recommendation',
      'alert'
    ],
    default: 'system',
    index: true,
    sensitivity_level: 3  // 低度敏感数据
  },
  title: {
    type: String,
    required: true,
    trim: true,
    maxlength: 100,
    sensitivity_level: 3  // 低度敏感数据
  },
  content: {
    type: String,
    required: true,
    trim: true,
    maxlength: 1000,
    sensitivity_level: 3  // 低度敏感数据
  },
  
  // 状态跟踪
  isRead: {
    type: Boolean,
    default: false,
    index: true,
    sensitivity_level: 3  // 低度敏感数据
  },
  readAt: {
    type: Date,
    default: null,
    sensitivity_level: 3  // 低度敏感数据
  },
  
  // 关联对象信息
  relatedObject: {
    objectType: {
      type: String,
      enum: [
        'order', 'dish', 'merchant', 'forum_post', 'forum_comment',
        'subscription', 'health_data', 'nutritionist', 'store', 'system'
      ],
      sensitivity_level: 3  // 低度敏感数据
    },
    objectId: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'relatedObject.objectType',
      sensitivity_level: 3  // 低度敏感数据
    }
  },
  
  // 元数据 - 扩展通知内容
  metadata: {
    source: {
      type: String,
      default: 'system'
    },
    category: {
      type: String
    },
    additionalData: mongoose.Schema.Types.Mixed,
    tags: [String]
  },
  
  // 通知配置
  priority: {
    type: String,
    enum: ['low', 'medium', 'high', 'critical'],
    default: 'medium',
    sensitivity_level: 3  // 低度敏感数据
  },
  deliveryChannels: [{
    type: String,
    enum: ['app', 'sms', 'email', 'wechat'],
    default: ['app'],
    sensitivity_level: 3  // 低度敏感数据
  }],
  
  // 推送状态
  pushStatus: {
    isPushed: {
      type: Boolean,
      default: false,
      sensitivity_level: 3  // 低度敏感数据
    },
    pushAttemptedAt: {
      type: Date,
      default: null,
      sensitivity_level: 3  // 低度敏感数据
    },
    pushSuccess: {
      type: Boolean,
      default: false,
      sensitivity_level: 3  // 低度敏感数据
    },
    pushError: {
      type: String,
      default: '',
      sensitivity_level: 3  // 低度敏感数据
    }
  },
  
  // 重定向URL
  redirectUrl: {
    type: String,
    default: '',
    sensitivity_level: 3  // 低度敏感数据
  },
  
  // 发送时间
  sentAt: {
    type: Date,
    default: Date.now,
    sensitivity_level: 3  // 低度敏感数据
  },
  
  // 过期时间
  expiresAt: {
    type: Date,
    default: function() {
      // 默认30天后过期
      const now = new Date();
      return new Date(now.setDate(now.getDate() + 30));
    },
    index: true,
    sensitivity_level: 3  // 低度敏感数据
  }
}, {
  timestamps: true,
  collection: 'notifications',
  versionKey: false
});

// 索引设置
notificationSchema.index({ userId: 1, createdAt: -1 }); // 查询用户最近通知
notificationSchema.index({ userId: 1, isRead: 1 }); // 查询未读通知
notificationSchema.index({ userId: 1, type: 1 }); // 按类型查询通知
notificationSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 }); // TTL索引，自动删除过期通知

// 静态方法：批量标记为已读
notificationSchema.statics.markAsRead = async function(userId, notificationIds) {
  if (!notificationIds || notificationIds.length === 0) {
    return await this.updateMany(
      { userId: userId, isRead: false },
      { $set: { isRead: true, readAt: new Date() } }
    );
  }
  
  return await this.updateMany(
    { 
      userId: userId,
      _id: { $in: notificationIds },
      isRead: false
    },
    { $set: { isRead: true, readAt: new Date() } }
  );
};

// 静态方法：获取未读通知数
notificationSchema.statics.getUnreadCount = async function(userId) {
  return await this.countDocuments({ userId: userId, isRead: false });
};

// 静态方法：获取按类型分组的未读数量
notificationSchema.statics.getUnreadCountByType = async function(userId) {
  return await this.aggregate([
    { $match: { userId: mongoose.Types.ObjectId(userId), isRead: false } },
    { $group: { _id: '$type', count: { $sum: 1 } } },
    { $project: { type: '$_id', count: 1, _id: 0 } }
  ]);
};

// 钩子：保存前的数据验证和处理
notificationSchema.pre('save', async function(next) {
  // 确保deliveryChannels至少有一个渠道
  if (!this.deliveryChannels || this.deliveryChannels.length === 0) {
    this.deliveryChannels = ['app'];
  }
  
  // 如果推送状态为成功，确保已推送标志为true
  if (this.pushStatus.pushSuccess) {
    this.pushStatus.isPushed = true;
  }
  
  next();
});

// 设置分片键（如果使用分片集群）
notificationSchema.set('shardKey', {
  userId: 1
});

// 使用ModelFactory创建模型
const Notification = ModelFactory.createModel('Notification', notificationSchema);

// 导出模型
module.exports = Notification; 