const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

/**
 * 权限变更历史模型
 * 记录所有权限操作的历史记录，用于审计和追踪
 */
const permissionHistorySchema = new mongoose.Schema({
  // 目标用户ID
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  
  // 权限类型
  permissionType: {
    type: String,
    enum: ['merchant', 'nutritionist'],
    required: true
  },
  
  // 操作类型
  action: {
    type: String,
    enum: ['grant', 'revoke', 'apply', 'approve', 'reject'],
    required: true
  },
  
  // 操作者ID（管理员或用户本人）
  operatorId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  
  // 操作者类型
  operatorType: {
    type: String,
    enum: ['admin', 'user', 'system'],
    default: 'admin'
  },
  
  // 操作原因/备注
  reason: {
    type: String,
    default: ''
  },
  
  // 相关的权限记录ID
  permissionRecordId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'UserPermission'
  },
  
  // 操作前状态
  previousStatus: {
    type: String,
    enum: ['pending', 'approved', 'rejected', 'revoked', 'none']
  },
  
  // 操作后状态
  newStatus: {
    type: String,
    enum: ['pending', 'approved', 'rejected', 'revoked', 'none']
  },
  
  // 操作详情
  details: {
    // IP地址
    ipAddress: String,
    // 用户代理
    userAgent: String,
    // 操作平台
    platform: {
      type: String,
      enum: ['web', 'mobile', 'api', 'system'],
      default: 'web'
    }
  },
  
  // 元数据
  metadata: {
    type: mongoose.Schema.Types.Mixed,
    default: {}
  }
}, {
  timestamps: true
});

// 索引
permissionHistorySchema.index({ userId: 1, createdAt: -1 });
permissionHistorySchema.index({ operatorId: 1, createdAt: -1 });
permissionHistorySchema.index({ permissionType: 1, action: 1 });
permissionHistorySchema.index({ action: 1, createdAt: -1 });

// 静态方法：记录权限操作
permissionHistorySchema.statics.recordAction = async function(data) {
  const {
    userId,
    permissionType,
    action,
    operatorId,
    reason = '',
    permissionRecordId = null,
    previousStatus = 'none',
    newStatus = 'none',
    operatorType = 'admin',
    details = {},
    metadata = {}
  } = data;
  
  const record = new this({
    userId,
    permissionType,
    action,
    operatorId,
    operatorType,
    reason,
    permissionRecordId,
    previousStatus,
    newStatus,
    details,
    metadata
  });
  
  return record.save();
};

// 静态方法：获取用户权限历史
permissionHistorySchema.statics.getUserHistory = async function(userId, options = {}) {
  const {
    permissionType = null,
    action = null,
    page = 1,
    limit = 20
  } = options;
  
  const query = { userId };
  if (permissionType) query.permissionType = permissionType;
  if (action) query.action = action;
  
  const skip = (page - 1) * limit;
  
  const [records, total] = await Promise.all([
    this.find(query)
      .populate('operatorId', 'nickname realName')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit)
      .lean(),
    this.countDocuments(query)
  ]);
  
  return {
    records,
    pagination: {
      total,
      page,
      limit,
      hasMore: skip + records.length < total
    }
  };
};

// 静态方法：获取权限操作统计
permissionHistorySchema.statics.getActionStats = async function(timeRange = {}) {
  const { startDate = null, endDate = null } = timeRange;
  
  const matchStage = {};
  if (startDate || endDate) {
    matchStage.createdAt = {};
    if (startDate) matchStage.createdAt.$gte = new Date(startDate);
    if (endDate) matchStage.createdAt.$lte = new Date(endDate);
  }
  
  const pipeline = [
    { $match: matchStage },
    {
      $group: {
        _id: {
          action: '$action',
          permissionType: '$permissionType'
        },
        count: { $sum: 1 },
        latestAction: { $max: '$createdAt' }
      }
    },
    {
      $group: {
        _id: '$_id.permissionType',
        actions: {
          $push: {
            action: '$_id.action',
            count: '$count',
            latestAction: '$latestAction'
          }
        },
        totalActions: { $sum: '$count' }
      }
    }
  ];
  
  return this.aggregate(pipeline);
};

// 实例方法：格式化显示
permissionHistorySchema.methods.getDisplayInfo = function() {
  const actionMap = {
    grant: '授予权限',
    revoke: '撤销权限',
    apply: '申请权限',
    approve: '批准权限',
    reject: '拒绝权限'
  };
  
  const permissionMap = {
    merchant: '加盟商',
    nutritionist: '营养师'
  };
  
  return {
    action: actionMap[this.action] || this.action,
    permission: permissionMap[this.permissionType] || this.permissionType,
    time: this.createdAt,
    reason: this.reason
  };
};

// 使用ModelFactory创建模型
const PermissionHistory = ModelFactory.createModel('PermissionHistory', permissionHistorySchema);

module.exports = PermissionHistory;