/**
 * 数据导出任务模型
 * 用于记录和管理数据导出任务
 * @module models/export/exportTaskModel
 */

const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/database/shardingService');

// 定义数据导出任务模型
const exportTaskSchema = new mongoose.Schema({
  // 用户信息
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true,
    description: '创建导出任务的用户ID'
  },
  
  // 任务信息
  taskName: {
    type: String,
    required: true,
    description: '导出任务名称'
  },
  taskType: {
    type: String,
    required: true,
    enum: [
      'userProfile',         // 用户档案导出
      'nutritionData',       // 营养数据导出
      'orderHistory',        // 订单历史导出
      'merchantReport',      // 商家报表导出
      'salesAnalytics',      // 销售分析导出
      'forumActivity',       // 论坛活动导出
      'nutritionAnalysis',   // 营养分析导出
      'customReport',        // 自定义报表导出
      'systemBackup',        // 系统备份导出
      'auditLog'             // 审计日志导出
    ],
    index: true,
    description: '导出任务类型'
  },
  
  // 导出配置
  exportConfig: {
    dataRange: {
      startDate: {
        type: Date,
        description: '数据范围开始日期'
      },
      endDate: {
        type: Date,
        description: '数据范围结束日期'
      }
    },
    filters: {
      type: mongoose.Schema.Types.Mixed,
      description: '自定义过滤条件'
    },
    format: {
      type: String,
      enum: ['csv', 'excel', 'pdf', 'json', 'xml'],
      default: 'excel',
      description: '导出文件格式'
    },
    includedFields: [{
      type: String,
      description: '包含的字段列表'
    }],
    excludedFields: [{
      type: String,
      description: '排除的字段列表'
    }],
    sortBy: {
      field: {
        type: String,
        description: '排序字段'
      },
      order: {
        type: String,
        enum: ['asc', 'desc'],
        default: 'asc',
        description: '排序方向'
      }
    },
    limit: {
      type: Number,
      description: '导出记录数量限制'
    }
  },
  
  // 处理状态
  status: {
    type: String,
    enum: ['pending', 'processing', 'completed', 'failed', 'cancelled'],
    default: 'pending',
    index: true,
    description: '任务状态'
  },
  progress: {
    current: {
      type: Number,
      default: 0,
      description: '当前处理进度'
    },
    total: {
      type: Number,
      default: 0,
      description: '总记录数'
    },
    percentage: {
      type: Number,
      default: 0,
      description: '完成百分比'
    }
  },
  
  // 结果信息
  result: {
    fileUrl: {
      type: String,
      description: '导出文件URL'
    },
    fileName: {
      type: String,
      description: '导出文件名'
    },
    fileSize: {
      type: Number,
      description: '导出文件大小(bytes)'
    },
    recordCount: {
      type: Number,
      description: '导出记录总数'
    },
    generatedAt: {
      type: Date,
      description: '文件生成时间'
    },
    expiresAt: {
      type: Date,
      description: '文件过期时间'
    }
  },
  
  // 错误信息
  error: {
    code: {
      type: String,
      description: '错误代码'
    },
    message: {
      type: String,
      description: '错误信息'
    },
    details: {
      type: mongoose.Schema.Types.Mixed,
      description: '详细错误信息'
    },
    occurredAt: {
      type: Date,
      description: '错误发生时间'
    }
  },
  
  // 处理信息
  processingInfo: {
    startedAt: {
      type: Date,
      description: '处理开始时间'
    },
    completedAt: {
      type: Date,
      description: '处理完成时间'
    },
    duration: {
      type: Number,
      description: '处理时长(秒)'
    },
    workerId: {
      type: String,
      description: '处理工作节点ID'
    },
    attempts: {
      type: Number,
      default: 0,
      description: '尝试次数'
    },
    lastAttemptAt: {
      type: Date,
      description: '最后尝试时间'
    }
  },
  
  // 任务相关设置
  settings: {
    priority: {
      type: Number,
      default: 5,
      min: 1,
      max: 10,
      description: '任务优先级(1-10)'
    },
    notifyOnCompletion: {
      type: Boolean,
      default: true,
      description: '完成时是否通知'
    },
    notificationEmail: {
      type: String,
      description: '通知邮箱'
    },
    isScheduled: {
      type: Boolean,
      default: false,
      description: '是否为计划任务'
    },
    scheduleConfig: {
      frequency: {
        type: String,
        enum: ['once', 'daily', 'weekly', 'monthly'],
        description: '计划频率'
      },
      dayOfWeek: {
        type: Number,
        min: 0,
        max: 6,
        description: '周几执行(0-6)'
      },
      dayOfMonth: {
        type: Number,
        min: 1,
        max: 31,
        description: '每月几号执行(1-31)'
      },
      time: {
        type: String,
        description: '执行时间(HH:MM格式)'
      },
      nextRunTime: {
        type: Date,
        description: '下次执行时间'
      }
    }
  },
  
  // 安全与审计
  security: {
    accessLevel: {
      type: String,
      enum: ['user', 'admin', 'system'],
      default: 'user',
      description: '访问级别'
    },
    isEncrypted: {
      type: Boolean,
      default: false,
      description: '是否加密'
    },
    encryptionType: {
      type: String,
      enum: ['none', 'aes256', 'rsa'],
      default: 'none',
      description: '加密类型'
    },
    passwordProtected: {
      type: Boolean,
      default: false,
      description: '是否密码保护'
    },
    accessList: [{
      userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        description: '有权限访问的用户ID'
      },
      permission: {
        type: String,
        enum: ['read', 'download', 'manage'],
        description: '权限类型'
      }
    }],
    ipAddress: {
      type: String,
      description: '创建任务的IP地址'
    }
  }
}, {
  timestamps: true,
  collection: 'exportTasks',
  versionKey: false
});

// 创建索引
exportTaskSchema.index({ userId: 1, createdAt: -1 });
exportTaskSchema.index({ taskType: 1, status: 1 });
exportTaskSchema.index({ 'result.expiresAt': 1 });
exportTaskSchema.index({ status: 1, 'settings.priority': -1, createdAt: 1 });
exportTaskSchema.index({ 'settings.isScheduled': 1, 'settings.scheduleConfig.nextRunTime': 1 });

// 添加虚拟字段
exportTaskSchema.virtual('isCompleted').get(function() {
  return this.status === 'completed';
});

exportTaskSchema.virtual('durationInSeconds').get(function() {
  if (this.processingInfo.startedAt && this.processingInfo.completedAt) {
    return Math.round((this.processingInfo.completedAt - this.processingInfo.startedAt) / 1000);
  }
  return null;
});

exportTaskSchema.virtual('isExpired').get(function() {
  if (this.result.expiresAt) {
    return new Date() > this.result.expiresAt;
  }
  return false;
});

// 实例方法
// 更新进度
exportTaskSchema.methods.updateProgress = async function(current, total) {
  this.status = 'processing';
  this.progress.current = current;
  this.progress.total = total;
  this.progress.percentage = total > 0 ? Math.round((current / total) * 100) : 0;
  
  if (!this.processingInfo.startedAt) {
    this.processingInfo.startedAt = new Date();
  }
  
  return await this.save();
};

// 完成任务
exportTaskSchema.methods.complete = async function(result) {
  this.status = 'completed';
  this.progress.current = this.progress.total;
  this.progress.percentage = 100;
  
  if (result) {
    this.result = { ...this.result, ...result };
  }
  
  this.processingInfo.completedAt = new Date();
  this.processingInfo.duration = Math.round(
    (this.processingInfo.completedAt - this.processingInfo.startedAt) / 1000
  );
  
  return await this.save();
};

// 标记失败
exportTaskSchema.methods.fail = async function(error) {
  this.status = 'failed';
  
  if (error) {
    this.error = {
      code: error.code || 'EXPORT_FAILED',
      message: error.message || '导出任务失败',
      details: error.details || error,
      occurredAt: new Date()
    };
  }
  
  this.processingInfo.attempts += 1;
  this.processingInfo.lastAttemptAt = new Date();
  
  return await this.save();
};

// 取消任务
exportTaskSchema.methods.cancel = async function(reason) {
  if (this.status === 'completed') {
    throw new Error('已完成的任务无法取消');
  }
  
  this.status = 'cancelled';
  if (reason) {
    this.error = {
      code: 'EXPORT_CANCELLED',
      message: reason,
      occurredAt: new Date()
    };
  }
  
  return await this.save();
};

// 重试任务
exportTaskSchema.methods.retry = async function() {
  if (this.status !== 'failed' && this.status !== 'cancelled') {
    throw new Error('只有失败或取消的任务可以重试');
  }
  
  this.status = 'pending';
  this.progress.current = 0;
  this.progress.percentage = 0;
  this.error = {};
  
  return await this.save();
};

// 更新计划任务下次执行时间
exportTaskSchema.methods.updateNextScheduledRun = async function() {
  if (!this.settings.isScheduled) {
    return this;
  }
  
  const now = new Date();
  let nextRun = new Date();
  
  switch (this.settings.scheduleConfig.frequency) {
    case 'daily':
      // 下一天的同一时间
      nextRun.setDate(nextRun.getDate() + 1);
      break;
    case 'weekly':
      // 下一周的同一天
      nextRun.setDate(nextRun.getDate() + 7);
      break;
    case 'monthly':
      // 下个月的同一天
      nextRun.setMonth(nextRun.getMonth() + 1);
      break;
    default:
      // 一次性任务不更新
      return this;
  }
  
  // 设置指定的时间
  if (this.settings.scheduleConfig.time) {
    const [hours, minutes] = this.settings.scheduleConfig.time.split(':').map(Number);
    nextRun.setHours(hours, minutes, 0, 0);
  }
  
  this.settings.scheduleConfig.nextRunTime = nextRun;
  return await this.save();
};

// 静态方法
// 获取待处理任务
exportTaskSchema.statics.getPendingTasks = function(limit = 10) {
  return this.find({ status: 'pending' })
    .sort({ 'settings.priority': -1, createdAt: 1 })
    .limit(limit);
};

// 获取用户的导出任务
exportTaskSchema.statics.getUserTasks = function(userId, options = {}) {
  const { status, limit = 20, skip = 0, sort = 'createdAt' } = options;
  
  const query = { userId };
  if (status) {
    query.status = status;
  }
  
  return this.find(query)
    .sort({ [sort]: -1 })
    .skip(skip)
    .limit(limit);
};

// 获取计划导出任务
exportTaskSchema.statics.getScheduledTasksDue = function() {
  const now = new Date();
  
  return this.find({
    'settings.isScheduled': true,
    'settings.scheduleConfig.nextRunTime': { $lte: now },
    status: 'completed' // 只查找已完成的任务进行下次调度
  });
};

// 清理过期文件
exportTaskSchema.statics.cleanupExpiredExports = async function() {
  const now = new Date();
  
  const expiredExports = await this.find({
    'result.expiresAt': { $lt: now },
    'result.fileUrl': { $exists: true, $ne: null }
  });
  
  // 在实际实现中，这里应该有文件系统清理代码
  
  const updateResult = await this.updateMany(
    { 'result.expiresAt': { $lt: now } },
    { $unset: { 'result.fileUrl': 1 } }
  );
  
  return {
    processed: expiredExports.length,
    updated: updateResult.nModified
  };
};

// 前置钩子 - 设置过期时间
exportTaskSchema.pre('save', function(next) {
  // 如果状态变为已完成，且没有设置过期时间，设置默认7天后过期
  if (this.isModified('status') && this.status === 'completed' && !this.result.expiresAt) {
    const now = new Date();
    this.result.expiresAt = new Date(now.getTime() + (7 * 24 * 60 * 60 * 1000));
  }
  next();
});

// 使用ModelFactory创建模型
const ExportTask = ModelFactory.createModel('ExportTask', exportTaskSchema);

// 添加分片支持的保存方法
const originalSave = ExportTask.prototype.save;
ExportTask.prototype.save = async function(options) {
  if (shardingService.config && shardingService.config.enabled && 
      shardingService.config.strategies.ExportTask) {
    // 使用任务创建年月作为分片键
    const date = this.createdAt || new Date();
    const month = date.getMonth() + 1;
    const year = date.getFullYear();
    const shardKey = `${year}-${month.toString().padStart(2, '0')}`;
    
    const shardCollection = shardingService.getShardName('ExportTask', shardKey);
    console.log(`将导出任务保存到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = ExportTask; 