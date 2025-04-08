const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const shardAccessService = require('../../services/core/shardAccessService');

/**
 * 消息提醒模型 - 处理系统通知、未读状态、关联对象等
 * @version v2.2.0
 * @author AI营养餐厅项目组
 * @description 该模型用于存储用户相关的所有通知消息
 */

// 定义消息提醒模型的结构
const notificationSchema = new mongoose.Schema({
  // 基本字段
  user_id: {
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
      'forum', 'promotion', 'security', 'subscription', 'recommendation'
    ],
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
  is_read: {
    type: Boolean,
    default: false,
    index: true,
    sensitivity_level: 3  // 低度敏感数据
  },
  read_at: {
    type: Date,
    default: null,
    sensitivity_level: 3  // 低度敏感数据
  },
  
  // 关联对象信息
  related_object: {
    object_type: {
      type: String,
      enum: [
        'order', 'dish', 'merchant', 'forum_post', 'forum_comment',
        'subscription', 'health_data', 'nutritionist', 'store', 'system'
      ],
      sensitivity_level: 3  // 低度敏感数据
    },
    object_id: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'related_object.object_type',
      sensitivity_level: 3  // 低度敏感数据
    }
  },
  
  // 通知配置
  priority: {
    type: String,
    enum: ['low', 'medium', 'high', 'critical'],
    default: 'medium',
    sensitivity_level: 3  // 低度敏感数据
  },
  delivery_channels: [{
    type: String,
    enum: ['app', 'sms', 'email', 'wechat'],
    default: ['app'],
    sensitivity_level: 3  // 低度敏感数据
  }],
  
  // 推送状态
  push_status: {
    is_pushed: {
      type: Boolean,
      default: false,
      sensitivity_level: 3  // 低度敏感数据
    },
    push_attempted_at: {
      type: Date,
      default: null,
      sensitivity_level: 3  // 低度敏感数据
    },
    push_success: {
      type: Boolean,
      default: false,
      sensitivity_level: 3  // 低度敏感数据
    },
    push_error: {
      type: String,
      default: '',
      sensitivity_level: 3  // 低度敏感数据
    }
  },
  
  // 时间追踪
  created_at: {
    type: Date,
    default: Date.now,
    index: true,
    sensitivity_level: 3  // 低度敏感数据
  },
  expires_at: {
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
  timestamps: {
    createdAt: 'created_at',
    updatedAt: 'updated_at'
  },
  collection: 'notifications',
  versionKey: false
});

// 索引设置
notificationSchema.index({ user_id: 1, created_at: -1 }); // 查询用户最近通知
notificationSchema.index({ user_id: 1, is_read: 1 }); // 查询未读通知
notificationSchema.index({ user_id: 1, type: 1 }); // 按类型查询通知
notificationSchema.index({ expires_at: 1 }, { expireAfterSeconds: 0 }); // TTL索引，自动删除过期通知

// 静态方法：批量标记为已读
notificationSchema.statics.markAsRead = async function(userId, notificationIds) {
  if (!notificationIds || notificationIds.length === 0) {
    return await this.updateMany(
      { user_id: userId, is_read: false },
      { $set: { is_read: true, read_at: new Date() } }
    );
  }
  
  return await this.updateMany(
    { 
      user_id: userId,
      _id: { $in: notificationIds },
      is_read: false
    },
    { $set: { is_read: true, read_at: new Date() } }
  );
};

// 静态方法：获取未读通知数
notificationSchema.statics.getUnreadCount = async function(userId) {
  return await this.countDocuments({ user_id: userId, is_read: false });
};

// 静态方法：获取按类型分组的未读数量
notificationSchema.statics.getUnreadCountByType = async function(userId) {
  return await this.aggregate([
    { $match: { user_id: mongoose.Types.ObjectId(userId), is_read: false } },
    { $group: { _id: '$type', count: { $sum: 1 } } },
    { $project: { type: '$_id', count: 1, _id: 0 } }
  ]);
};

// 钩子：保存前的数据验证和处理
notificationSchema.pre('save', async function(next) {
  // 确保delivery_channels至少有一个渠道
  if (!this.delivery_channels || this.delivery_channels.length === 0) {
    this.delivery_channels = ['app'];
  }
  
  // 如果推送状态为成功，确保已推送标志为true
  if (this.push_status.push_success) {
    this.push_status.is_pushed = true;
  }
  
  next();
});

// 设置分片键（如果使用分片集群）
notificationSchema.set('shardKey', {
  user_id: 1
});

// 使用ModelFactory创建模型
const Notification = ModelFactory.createModel('Notification', notificationSchema);

// 导出模型
module.exports = Notification; 