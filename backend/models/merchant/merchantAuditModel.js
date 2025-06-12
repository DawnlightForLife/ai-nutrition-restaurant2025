/**
 * 商家审核历史模型
 * 记录商家审核的完整历史，包括每次审核的详细信息
 * @module models/merchant/merchantAuditModel
 */

const mongoose = require('mongoose');

const merchantAuditSchema = new mongoose.Schema({
  // 商家ID
  merchantId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Merchant',
    required: true,
    index: true,
    description: '关联的商家ID'
  },
  
  // 用户ID
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    description: '商家所属用户ID'
  },
  
  // 审核类型
  auditType: {
    type: String,
    enum: ['initial_registration', 'resubmission', 'periodic_review', 'complaint_review'],
    required: true,
    description: '审核类型：初次注册、重新提交、定期审查、投诉审查'
  },
  
  // 审核状态
  auditStatus: {
    type: String,
    enum: ['pending', 'approved', 'rejected', 'cancelled'],
    required: true,
    description: '审核状态'
  },
  
  // 审核人信息
  auditor: {
    adminId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Admin',
      description: '审核管理员ID'
    },
    adminName: {
      type: String,
      description: '审核管理员姓名'
    },
    auditTime: {
      type: Date,
      description: '审核时间'
    }
  },
  
  // 审核详情
  auditDetails: {
    // 审核项目
    auditItems: [{
      category: {
        type: String,
        enum: ['business_license', 'identity', 'address', 'contact', 'qualification', 'other'],
        description: '审核类别'
      },
      itemName: {
        type: String,
        description: '审核项目名称'
      },
      status: {
        type: String,
        enum: ['pass', 'fail', 'pending'],
        description: '该项审核状态'
      },
      comment: {
        type: String,
        description: '审核备注'
      },
      evidence: [{
        type: String,
        description: '相关证据文件URL'
      }]
    }],
    
    // 总体评分
    overallScore: {
      type: Number,
      min: 0,
      max: 100,
      description: '总体审核评分'
    },
    
    // 风险评估
    riskLevel: {
      type: String,
      enum: ['low', 'medium', 'high'],
      description: '风险等级'
    }
  },
  
  // 审核结果
  auditResult: {
    // 审核决定
    decision: {
      type: String,
      enum: ['approved', 'rejected', 'conditional_approval'],
      description: '审核决定'
    },
    
    // 拒绝原因
    rejectionReason: {
      type: String,
      description: '拒绝原因详细说明'
    },
    
    // 改进建议
    suggestions: [{
      category: String,
      suggestion: String,
      priority: {
        type: String,
        enum: ['high', 'medium', 'low']
      }
    }],
    
    // 条件批准要求
    conditions: [{
      requirement: String,
      deadline: Date,
      status: {
        type: String,
        enum: ['pending', 'completed', 'overdue'],
        default: 'pending'
      }
    }]
  },
  
  // 提交的商家数据快照
  merchantDataSnapshot: {
    type: mongoose.Schema.Types.Mixed,
    description: '提交时的商家数据快照'
  },
  
  // 文档和附件
  documents: [{
    name: String,
    type: String,
    url: String,
    uploadTime: Date,
    verificationStatus: {
      type: String,
      enum: ['pending', 'verified', 'rejected'],
      default: 'pending'
    }
  }],
  
  // 审核时间线
  timeline: [{
    action: String,
    actor: String,
    timestamp: Date,
    details: String
  }],
  
  // 沟通记录
  communications: [{
    type: {
      type: String,
      enum: ['email', 'sms', 'phone', 'system_message']
    },
    direction: {
      type: String,
      enum: ['inbound', 'outbound']
    },
    content: String,
    timestamp: Date,
    sender: String,
    recipient: String
  }],
  
  // 系统字段
  createdAt: {
    type: Date,
    default: Date.now,
    description: '创建时间'
  },
  
  updatedAt: {
    type: Date,
    default: Date.now,
    description: '更新时间'
  },
  
  // 版本控制
  version: {
    type: Number,
    default: 1,
    description: '审核记录版本号'
  },
  
  // 审核周期
  auditCycle: {
    startTime: Date,
    endTime: Date,
    duration: Number, // 审核耗时（分钟）
    description: '审核周期信息'
  },
  
  // 质量控制
  qualityControl: {
    reviewedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Admin',
      description: '质检员ID'
    },
    qualityScore: {
      type: Number,
      min: 0,
      max: 10,
      description: '审核质量评分'
    },
    feedback: {
      type: String,
      description: '质检反馈'
    }
  }
}, {
  timestamps: true,
  versionKey: false
});

// 创建复合索引
merchantAuditSchema.index({ merchantId: 1, auditType: 1, createdAt: -1 });
merchantAuditSchema.index({ 'auditor.adminId': 1, createdAt: -1 });
merchantAuditSchema.index({ auditStatus: 1, createdAt: -1 });

// 更新时间中间件
merchantAuditSchema.pre('save', function(next) {
  this.updatedAt = new Date();
  next();
});

// 实例方法：添加时间线记录
merchantAuditSchema.methods.addTimelineEntry = function(action, actor, details) {
  this.timeline.push({
    action,
    actor,
    timestamp: new Date(),
    details
  });
};

// 实例方法：添加沟通记录
merchantAuditSchema.methods.addCommunication = function(type, direction, content, sender, recipient) {
  this.communications.push({
    type,
    direction,
    content,
    timestamp: new Date(),
    sender,
    recipient
  });
};

// 静态方法：根据商家ID获取审核历史
merchantAuditSchema.statics.getAuditHistory = function(merchantId, options = {}) {
  const { limit = 10, skip = 0, auditType, auditStatus } = options;
  
  const query = { merchantId };
  if (auditType) query.auditType = auditType;
  if (auditStatus) query.auditStatus = auditStatus;
  
  return this.find(query)
    .populate('auditor.adminId', 'username email')
    .sort({ createdAt: -1 })
    .limit(limit)
    .skip(skip);
};

// 静态方法：获取审核统计
merchantAuditSchema.statics.getAuditStats = function(timeRange = {}) {
  const matchStage = {};
  
  if (timeRange.start || timeRange.end) {
    matchStage.createdAt = {};
    if (timeRange.start) matchStage.createdAt.$gte = timeRange.start;
    if (timeRange.end) matchStage.createdAt.$lte = timeRange.end;
  }
  
  return this.aggregate([
    { $match: matchStage },
    {
      $group: {
        _id: {
          status: '$auditStatus',
          type: '$auditType'
        },
        count: { $sum: 1 },
        avgDuration: { $avg: '$auditCycle.duration' }
      }
    },
    {
      $group: {
        _id: '$_id.status',
        total: { $sum: '$count' },
        types: {
          $push: {
            type: '$_id.type',
            count: '$count',
            avgDuration: '$avgDuration'
          }
        }
      }
    }
  ]);
};

const MerchantAudit = mongoose.model('MerchantAudit', merchantAuditSchema);

module.exports = MerchantAudit;