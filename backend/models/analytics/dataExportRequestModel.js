/**
 * 数据导出请求模型
 * 支持用户导出个人数据、商家导出业务数据等场景
 * @module models/analytics/dataExportRequestModel
 */

const mongoose = require('mongoose');
const { Schema } = mongoose;

const dataExportRequestSchema = new Schema({
  // 请求基本信息
  requestId: {
    type: String,
    required: true,
    unique: true,
    index: true,
    default: () => `EXPORT_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
  },
  
  // 请求者信息
  requesterId: {
    type: Schema.Types.ObjectId,
    required: true,
    index: true,
    refPath: 'requesterModel'
  },
  
  requesterModel: {
    type: String,
    required: true,
    enum: ['User', 'Admin', 'Merchant'],
    default: 'User'
  },
  
  // 导出类型
  exportType: {
    type: String,
    required: true,
    enum: [
      'personal_data',      // 个人数据导出（GDPR合规）
      'order_history',      // 订单历史
      'nutrition_records',  // 营养记录
      'consultation_history', // 咨询记录
      'merchant_sales',     // 商家销售数据
      'merchant_dishes',    // 商家菜品数据
      'customer_insights',  // 客户洞察
      'financial_report',   // 财务报表
      'inventory_report',   // 库存报表
      'custom'             // 自定义导出
    ],
    index: true
  },
  
  // 导出参数
  parameters: {
    // 时间范围
    dateRange: {
      startDate: Date,
      endDate: Date
    },
    
    // 数据筛选条件
    filters: {
      type: Map,
      of: Schema.Types.Mixed
    },
    
    // 包含的字段
    includedFields: [String],
    
    // 排除的字段（隐私保护）
    excludedFields: [String],
    
    // 导出格式
    format: {
      type: String,
      enum: ['json', 'csv', 'excel', 'pdf'],
      default: 'excel'
    },
    
    // 语言
    language: {
      type: String,
      enum: ['zh-CN', 'en-US'],
      default: 'zh-CN'
    },
    
    // 是否包含敏感信息
    includeSensitive: {
      type: Boolean,
      default: false
    },
    
    // 自定义查询（仅管理员可用）
    customQuery: {
      type: Map,
      of: Schema.Types.Mixed
    }
  },
  
  // 请求状态
  status: {
    type: String,
    required: true,
    enum: ['pending', 'processing', 'completed', 'failed', 'cancelled', 'expired'],
    default: 'pending',
    index: true
  },
  
  // 处理信息
  processingInfo: {
    startedAt: Date,
    completedAt: Date,
    duration: Number, // 处理时长（秒）
    recordCount: Number, // 导出记录数
    fileSize: Number, // 文件大小（字节）
    processingNode: String // 处理节点ID
  },
  
  // 文件信息
  fileInfo: {
    fileName: String,
    filePath: String,
    fileUrl: String,
    mimeType: String,
    checksum: String, // 文件校验和
    encryptionKey: String, // 加密密钥（如果文件被加密）
    expiresAt: Date // 文件过期时间
  },
  
  // 错误信息
  error: {
    code: String,
    message: String,
    details: Schema.Types.Mixed,
    occurredAt: Date
  },
  
  // 审批信息（敏感数据导出需要审批）
  approval: {
    required: {
      type: Boolean,
      default: false
    },
    approvedBy: {
      type: Schema.Types.ObjectId,
      ref: 'Admin'
    },
    approvedAt: Date,
    approvalNote: String,
    rejectionReason: String
  },
  
  // 通知设置
  notification: {
    email: String,
    phone: String,
    notifyOnComplete: {
      type: Boolean,
      default: true
    },
    notifyOnFail: {
      type: Boolean,
      default: true
    },
    notificationsSent: [{
      type: {
        type: String,
        enum: ['email', 'sms', 'push']
      },
      sentAt: Date,
      status: String
    }]
  },
  
  // 安全信息
  security: {
    ipAddress: String,
    userAgent: String,
    accessCount: {
      type: Number,
      default: 0
    },
    lastAccessedAt: Date,
    accessLogs: [{
      accessedAt: Date,
      ipAddress: String,
      userAgent: String,
      action: String // 'download', 'preview', 'delete'
    }]
  },
  
  // 元数据
  metadata: {
    requestSource: {
      type: String,
      enum: ['web', 'app', 'api', 'admin', 'system'],
      default: 'web'
    },
    priority: {
      type: String,
      enum: ['low', 'normal', 'high', 'urgent'],
      default: 'normal'
    },
    tags: [String],
    notes: String,
    relatedRequests: [{
      type: Schema.Types.ObjectId,
      ref: 'DataExportRequest'
    }]
  }
}, {
  timestamps: true,
  collection: 'data_export_requests'
});

// 索引
dataExportRequestSchema.index({ requesterId: 1, createdAt: -1 });
dataExportRequestSchema.index({ status: 1, createdAt: -1 });
dataExportRequestSchema.index({ 'fileInfo.expiresAt': 1 });
dataExportRequestSchema.index({ exportType: 1, status: 1 });

// 虚拟字段 - 是否已过期
dataExportRequestSchema.virtual('isExpired').get(function() {
  return this.fileInfo?.expiresAt && new Date() > this.fileInfo.expiresAt;
});

// 虚拟字段 - 是否可下载
dataExportRequestSchema.virtual('isDownloadable').get(function() {
  return this.status === 'completed' && 
         this.fileInfo?.fileUrl && 
         !this.isExpired;
});

// 实例方法 - 标记为处理中
dataExportRequestSchema.methods.startProcessing = function() {
  this.status = 'processing';
  this.processingInfo.startedAt = new Date();
  return this.save();
};

// 实例方法 - 标记为完成
dataExportRequestSchema.methods.completeProcessing = function(fileInfo, recordCount) {
  const now = new Date();
  this.status = 'completed';
  this.processingInfo.completedAt = now;
  this.processingInfo.duration = Math.floor((now - this.processingInfo.startedAt) / 1000);
  this.processingInfo.recordCount = recordCount || 0;
  this.processingInfo.fileSize = fileInfo.fileSize || 0;
  this.fileInfo = {
    ...fileInfo,
    expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000) // 7天后过期
  };
  return this.save();
};

// 实例方法 - 标记为失败
dataExportRequestSchema.methods.failProcessing = function(error) {
  this.status = 'failed';
  this.error = {
    code: error.code || 'EXPORT_FAILED',
    message: error.message,
    details: error.details,
    occurredAt: new Date()
  };
  return this.save();
};

// 实例方法 - 记录访问
dataExportRequestSchema.methods.logAccess = function(ipAddress, userAgent, action = 'download') {
  this.security.accessCount += 1;
  this.security.lastAccessedAt = new Date();
  this.security.accessLogs.push({
    accessedAt: new Date(),
    ipAddress,
    userAgent,
    action
  });
  
  // 只保留最近100条访问记录
  if (this.security.accessLogs.length > 100) {
    this.security.accessLogs = this.security.accessLogs.slice(-100);
  }
  
  return this.save();
};

// 静态方法 - 清理过期文件
dataExportRequestSchema.statics.cleanupExpiredFiles = async function() {
  const expiredRequests = await this.find({
    status: 'completed',
    'fileInfo.expiresAt': { $lt: new Date() }
  });
  
  for (const request of expiredRequests) {
    // 这里应该调用文件存储服务删除文件
    // await fileStorageService.deleteFile(request.fileInfo.filePath);
    
    request.status = 'expired';
    request.fileInfo.fileUrl = null;
    await request.save();
  }
  
  return expiredRequests.length;
};

// 静态方法 - 获取导出统计
dataExportRequestSchema.statics.getExportStats = async function(requesterId, dateRange) {
  const match = { requesterId };
  
  if (dateRange) {
    match.createdAt = {
      $gte: dateRange.startDate,
      $lte: dateRange.endDate
    };
  }
  
  return this.aggregate([
    { $match: match },
    {
      $group: {
        _id: {
          exportType: '$exportType',
          status: '$status'
        },
        count: { $sum: 1 },
        totalSize: { $sum: '$processingInfo.fileSize' },
        avgDuration: { $avg: '$processingInfo.duration' }
      }
    },
    {
      $group: {
        _id: '$_id.exportType',
        stats: {
          $push: {
            status: '$_id.status',
            count: '$count',
            totalSize: '$totalSize',
            avgDuration: '$avgDuration'
          }
        }
      }
    }
  ]);
};

// 中间件 - 保存前验证
dataExportRequestSchema.pre('save', function(next) {
  // 验证日期范围
  if (this.parameters?.dateRange) {
    if (this.parameters.dateRange.startDate > this.parameters.dateRange.endDate) {
      return next(new Error('Start date must be before end date'));
    }
  }
  
  // 自动设置审批要求
  if (this.exportType === 'personal_data' || 
      this.exportType === 'financial_report' || 
      this.parameters?.includeSensitive) {
    this.approval.required = true;
  }
  
  next();
});

// 转换选项
dataExportRequestSchema.set('toJSON', {
  virtuals: true,
  transform: function(doc, ret) {
    delete ret._id;
    delete ret.__v;
    // 隐藏敏感信息
    if (ret.fileInfo?.encryptionKey) {
      ret.fileInfo.encryptionKey = '***';
    }
    return ret;
  }
});

const DataExportRequest = mongoose.model('DataExportRequest', dataExportRequestSchema);

module.exports = DataExportRequest;