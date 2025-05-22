const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const shardAccessService = require('../../services/database/shardAccessService');

/**
 * 用户通知状态模型 - 跟踪用户的通知偏好和统计数据
 * @version v1.0.0
 * @author AI营养餐厅项目组
 * @description 该模型用于存储用户的通知偏好设置、已读状态和通知统计数据
 */

const userNotificationStatusSchema = new mongoose.Schema({
  // 用户信息
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true,
    index: true,
    sensitivityLevel: 2, // 中度敏感数据
    description: '用户ID'
  },
  
  // 通知偏好设置
  preferences: {
    // 通知开关 - 按类型
    enabledTypes: {
      system: {
        type: Boolean,
        default: true,
        description: '是否接收系统通知'
      },
      order: {
        type: Boolean,
        default: true,
        description: '是否接收订单通知'
      },
      payment: {
        type: Boolean,
        default: true,
        description: '是否接收支付通知'
      },
      health: {
        type: Boolean,
        default: true,
        description: '是否接收健康通知'
      },
      reminder: {
        type: Boolean,
        default: true,
        description: '是否接收提醒通知'
      },
      forum: {
        type: Boolean,
        default: true,
        description: '是否接收论坛通知'
      },
      promotion: {
        type: Boolean,
        default: true,
        description: '是否接收促销通知'
      },
      security: {
        type: Boolean,
        default: true,
        description: '是否接收安全通知'
      },
      subscription: {
        type: Boolean,
        default: true,
        description: '是否接收订阅通知'
      },
      recommendation: {
        type: Boolean,
        default: true,
        description: '是否接收推荐通知'
      },
      alert: {
        type: Boolean,
        default: true,
        description: '是否接收警报通知'
      }
    },
    
    // 通知渠道偏好 - 按类型
    channelPreferences: {
      system: {
        app: { type: Boolean, default: true },
        sms: { type: Boolean, default: false },
        email: { type: Boolean, default: true },
        wechat: { type: Boolean, default: true }
      },
      order: {
        app: { type: Boolean, default: true },
        sms: { type: Boolean, default: true },
        email: { type: Boolean, default: true },
        wechat: { type: Boolean, default: true }
      },
      payment: {
        app: { type: Boolean, default: true },
        sms: { type: Boolean, default: true },
        email: { type: Boolean, default: true },
        wechat: { type: Boolean, default: true }
      },
      health: {
        app: { type: Boolean, default: true },
        sms: { type: Boolean, default: false },
        email: { type: Boolean, default: true },
        wechat: { type: Boolean, default: true }
      },
      reminder: {
        app: { type: Boolean, default: true },
        sms: { type: Boolean, default: false },
        email: { type: Boolean, default: false },
        wechat: { type: Boolean, default: true }
      },
      forum: {
        app: { type: Boolean, default: true },
        sms: { type: Boolean, default: false },
        email: { type: Boolean, default: false },
        wechat: { type: Boolean, default: false }
      },
      promotion: {
        app: { type: Boolean, default: true },
        sms: { type: Boolean, default: false },
        email: { type: Boolean, default: true },
        wechat: { type: Boolean, default: false }
      },
      security: {
        app: { type: Boolean, default: true },
        sms: { type: Boolean, default: true },
        email: { type: Boolean, default: true },
        wechat: { type: Boolean, default: true }
      },
      subscription: {
        app: { type: Boolean, default: true },
        sms: { type: Boolean, default: false },
        email: { type: Boolean, default: true },
        wechat: { type: Boolean, default: false }
      },
      recommendation: {
        app: { type: Boolean, default: true },
        sms: { type: Boolean, default: false },
        email: { type: Boolean, default: false },
        wechat: { type: Boolean, default: false }
      },
      alert: {
        app: { type: Boolean, default: true },
        sms: { type: Boolean, default: true },
        email: { type: Boolean, default: true },
        wechat: { type: Boolean, default: true }
      }
    },
    
    // 免打扰时间段
    doNotDisturbSettings: {
      enabled: {
        type: Boolean,
        default: false,
        description: '是否启用免打扰模式'
      },
      startTime: {
        type: String,
        default: '22:00',
        description: '免打扰开始时间（HH:MM格式）'
      },
      endTime: {
        type: String,
        default: '07:00',
        description: '免打扰结束时间（HH:MM格式）'
      },
      exceptTypes: [{
        type: String,
        enum: ['security', 'alert', 'order', 'payment'],
        description: '免打扰例外的通知类型（这些类型的通知即使在免打扰时段也会发送）'
      }],
      exceptPriorities: [{
        type: String,
        enum: ['high', 'critical'],
        description: '免打扰例外的优先级（这些优先级的通知即使在免打扰时段也会发送）'
      }]
    },
    
    // 推送设备信息
    deviceSettings: {
      pushToken: {
        type: String,
        description: '最新的推送令牌',
        sensitivityLevel: 1 // 高度敏感数据
      },
      deviceType: {
        type: String,
        enum: ['ios', 'android', 'web', 'unknown'],
        default: 'unknown',
        description: '设备类型'
      },
      lastUpdated: {
        type: Date,
        default: Date.now,
        description: '设备信息最后更新时间'
      }
    },
    
    // 批量操作设置
    batchSettings: {
      deliveryFrequency: {
        type: String,
        enum: ['immediate', 'hourly', 'daily', 'weekly'],
        default: 'immediate',
        description: '通知投递频率'
      },
      digestEnabled: {
        type: Boolean,
        default: false,
        description: '是否启用摘要通知'
      },
      digestFrequency: {
        type: String,
        enum: ['daily', 'weekly'],
        default: 'daily',
        description: '摘要通知频率'
      },
      digestTime: {
        type: String,
        default: '09:00',
        description: '摘要通知发送时间（HH:MM格式）'
      }
    }
  },
  
  // 通知统计数据
  statistics: {
    // 未读计数
    unreadCounts: {
      total: {
        type: Number,
        default: 0,
        description: '总未读数量'
      },
      byType: {
        system: { type: Number, default: 0 },
        order: { type: Number, default: 0 },
        payment: { type: Number, default: 0 },
        health: { type: Number, default: 0 },
        reminder: { type: Number, default: 0 },
        forum: { type: Number, default: 0 },
        promotion: { type: Number, default: 0 },
        security: { type: Number, default: 0 },
        subscription: { type: Number, default: 0 },
        recommendation: { type: Number, default: 0 },
        alert: { type: Number, default: 0 }
      }
    },
    
    // 互动统计
    interactionStats: {
      totalReceived: {
        type: Number,
        default: 0,
        description: '总计收到的通知数量'
      },
      totalRead: {
        type: Number,
        default: 0,
        description: '已读的通知数量'
      },
      totalClicked: {
        type: Number,
        default: 0,
        description: '被点击的通知数量'
      },
      readRate: {
        type: Number,
        default: 0,
        description: '通知阅读率（百分比）'
      },
      clickRate: {
        type: Number,
        default: 0,
        description: '通知点击率（百分比）'
      },
      averageReadTime: {
        type: Number,
        default: 0,
        description: '平均读取时间（秒）'
      }
    },
    
    // 阅读历史记录 - 最近10个已读通知记录
    recentReadHistory: [{
      notificationId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Notification',
        description: '通知ID'
      },
      readAt: {
        type: Date,
        description: '阅读时间'
      },
      notificationType: {
        type: String,
        description: '通知类型'
      },
      title: {
        type: String,
        description: '通知标题'
      }
    }],
    
    // 最后更新时间
    lastUpdated: {
      type: Date,
      default: Date.now,
      description: '统计数据最后更新时间'
    }
  },
  
  // 最后同步时间（用于移动设备同步）
  lastSyncTime: {
    type: Date,
    default: Date.now,
    description: '最后同步时间'
  }
}, {
  timestamps: true,
  collection: 'userNotificationStatus',
  versionKey: false
});

// 索引设置
userNotificationStatusSchema.index({ userId: 1 }, { unique: true });
userNotificationStatusSchema.index({ 'statistics.lastUpdated': -1 });
userNotificationStatusSchema.index({ lastSyncTime: -1 });

// 静态方法：更新用户未读通知计数
userNotificationStatusSchema.statics.updateUnreadCounts = async function(userId) {
  try {
    // 获取最新的未读计数
    const Notification = mongoose.model('Notification');
    const unreadByType = await Notification.aggregate([
      { $match: { userId: mongoose.Types.ObjectId(userId), isRead: false, isArchived: false } },
      { $group: { _id: '$type', count: { $sum: 1 } } }
    ]);
    
    // 初始化所有类型的计数为0
    const unreadCounts = {
      total: 0,
      byType: {
        system: 0, order: 0, payment: 0, health: 0, reminder: 0,
        forum: 0, promotion: 0, security: 0, subscription: 0, recommendation: 0, alert: 0
      }
    };
    
    // 更新计数
    unreadByType.forEach(item => {
      if (unreadCounts.byType.hasOwnProperty(item._id)) {
        unreadCounts.byType[item._id] = item.count;
        unreadCounts.total += item.count;
      }
    });
    
    // 更新用户通知状态
    await this.findOneAndUpdate(
      { userId },
      { 
        $set: { 
          'statistics.unreadCounts': unreadCounts,
          'statistics.lastUpdated': new Date()
        }
      },
      { upsert: true }
    );
    
    return unreadCounts;
  } catch (error) {
    console.error('更新未读通知计数失败:', error);
    throw error;
  }
};

// 静态方法：记录通知已读
userNotificationStatusSchema.statics.recordNotificationRead = async function(userId, notification) {
  try {
    const updateData = {
      $inc: {
        'statistics.interactionStats.totalRead': 1
      },
      $set: {
        'statistics.lastUpdated': new Date()
      }
    };
    
    // 添加到最近阅读历史
    updateData.$push = {
      'statistics.recentReadHistory': {
        $each: [{
          notificationId: notification._id,
          readAt: new Date(),
          notificationType: notification.type,
          title: notification.title
        }],
        $slice: -10 // 只保留最近10条记录
      }
    };
    
    // 计算阅读率
    updateData.$set['statistics.interactionStats.readRate'] = 
      await this.calculateReadRate(userId);
    
    // 更新数据库
    await this.findOneAndUpdate(
      { userId },
      updateData,
      { upsert: true }
    );
    
    // 更新未读计数
    await this.updateUnreadCounts(userId);
  } catch (error) {
    console.error('记录通知已读失败:', error);
    throw error;
  }
};

// 静态方法：记录通知点击
userNotificationStatusSchema.statics.recordNotificationClicked = async function(userId, notificationId) {
  try {
    // 增加点击计数并计算点击率
    const userStatus = await this.findOne({ userId });
    
    if (!userStatus) {
      throw new Error('用户通知状态不存在');
    }
    
    const totalReceived = userStatus.statistics.interactionStats.totalReceived;
    const totalClicked = userStatus.statistics.interactionStats.totalClicked + 1;
    const clickRate = totalReceived > 0 ? (totalClicked / totalReceived) * 100 : 0;
    
    await this.updateOne(
      { userId },
      { 
        $inc: { 'statistics.interactionStats.totalClicked': 1 },
        $set: { 
          'statistics.interactionStats.clickRate': clickRate,
          'statistics.lastUpdated': new Date()
        }
      }
    );
  } catch (error) {
    console.error('记录通知点击失败:', error);
    throw error;
  }
};

// 静态方法：计算阅读率
userNotificationStatusSchema.statics.calculateReadRate = async function(userId) {
  try {
    const userStatus = await this.findOne({ userId });
    
    if (!userStatus) {
      return 0;
    }
    
    const totalReceived = userStatus.statistics.interactionStats.totalReceived;
    const totalRead = userStatus.statistics.interactionStats.totalRead + 1; // 加1是因为当前正在记录的已读
    
    return totalReceived > 0 ? (totalRead / totalReceived) * 100 : 0;
  } catch (error) {
    console.error('计算阅读率失败:', error);
    return 0;
  }
};

// 实例方法：获取用户的通知偏好设置
userNotificationStatusSchema.methods.getDeliveryPreference = function(notificationType, channel) {
  // 首先检查该类型是否启用
  if (!this.preferences.enabledTypes[notificationType]) {
    return false;
  }
  
  // 然后检查该类型的特定渠道是否启用
  if (this.preferences.channelPreferences[notificationType] && 
      this.preferences.channelPreferences[notificationType][channel] !== undefined) {
    return this.preferences.channelPreferences[notificationType][channel];
  }
  
  // 默认返回true（如果没有特定设置）
  return true;
};

// 实例方法：检查是否在免打扰时间内
userNotificationStatusSchema.methods.isInDoNotDisturbPeriod = function(notificationType, priority) {
  if (!this.preferences.doNotDisturbSettings.enabled) {
    return false;
  }
  
  // 检查是否为免打扰例外类型
  if (this.preferences.doNotDisturbSettings.exceptTypes.includes(notificationType)) {
    return false;
  }
  
  // 检查是否为免打扰例外优先级
  if (this.preferences.doNotDisturbSettings.exceptPriorities.includes(priority)) {
    return false;
  }
  
  // 获取当前时间
  const now = new Date();
  const currentTime = now.getHours().toString().padStart(2, '0') + ':' + 
                     now.getMinutes().toString().padStart(2, '0');
  
  // 解析免打扰时间
  const startTime = this.preferences.doNotDisturbSettings.startTime;
  const endTime = this.preferences.doNotDisturbSettings.endTime;
  
  // 检查是否在免打扰时间内
  if (startTime <= endTime) {
    // 简单情况：开始时间小于结束时间
    return currentTime >= startTime && currentTime <= endTime;
  } else {
    // 复杂情况：开始时间大于结束时间（跨午夜）
    return currentTime >= startTime || currentTime <= endTime;
  }
};

// 使用ModelFactory创建模型
const UserNotificationStatus = ModelFactory.createModel('UserNotificationStatus', userNotificationStatusSchema);

// 导出模型
module.exports = UserNotificationStatus; 