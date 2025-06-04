const mongoose = require('mongoose');
const { Schema, ObjectId } = mongoose;

const contentReportSchema = new Schema({
  // 举报类型
  reportType: {
    type: String,
    enum: [
      'inappropriate_content',  // 不当内容
      'spam',                  // 垃圾信息
      'harassment',            // 骚扰
      'hate_speech',           // 仇恨言论
      'violence',              // 暴力内容
      'adult_content',         // 成人内容
      'copyright',             // 版权侵犯
      'misinformation',        // 虚假信息
      'privacy_violation',     // 隐私侵犯
      'illegal_activity',      // 违法活动
      'other'                  // 其他
    ],
    required: true,
    index: true
  },
  
  // 被举报的内容信息
  reportedContent: {
    // 内容类型
    contentType: {
      type: String,
      enum: ['forum_post', 'forum_comment', 'review', 'user_profile', 'dish_description', 'store_info', 'chat_message'],
      required: true,
      index: true
    },
    
    // 内容ID
    contentId: {
      type: ObjectId,
      required: true,
      index: true
    },
    
    // 内容标题/摘要
    contentTitle: String,
    
    // 内容详情（快照）
    contentSnapshot: {
      text: String,
      images: [String],
      metadata: Schema.Types.Mixed
    },
    
    // 内容创建者
    contentAuthorId: {
      type: ObjectId,
      ref: 'User',
      required: true,
      index: true
    },
    
    // 内容创建时间
    contentCreatedAt: Date
  },
  
  // 举报者信息
  reporter: {
    userId: {
      type: ObjectId,
      ref: 'User',
      required: true,
      index: true
    },
    
    // 举报者IP地址
    ipAddress: String,
    
    // 设备信息
    deviceInfo: {
      userAgent: String,
      deviceType: String,
      platform: String
    },
    
    // 是否匿名举报
    isAnonymous: {
      type: Boolean,
      default: false
    }
  },
  
  // 举报详情
  reportDetails: {
    // 举报原因描述
    reason: {
      type: String,
      required: true,
      maxlength: 1000
    },
    
    // 具体的问题描述
    description: {
      type: String,
      maxlength: 2000
    },
    
    // 相关截图或证据
    evidence: {
      screenshots: [String],
      attachments: [String]
    },
    
    // 举报的严重程度
    severity: {
      type: String,
      enum: ['low', 'medium', 'high', 'critical'],
      default: 'medium'
    }
  },
  
  // 处理状态
  status: {
    type: String,
    enum: ['pending', 'reviewing', 'resolved', 'rejected', 'escalated'],
    default: 'pending',
    index: true
  },
  
  // 处理信息
  processing: {
    // 分配的审核员
    assignedTo: {
      type: ObjectId,
      ref: 'User'
    },
    
    // 分配时间
    assignedAt: Date,
    
    // 开始处理时间
    startedAt: Date,
    
    // 完成处理时间
    completedAt: Date,
    
    // 处理结果
    result: {
      type: String,
      enum: ['no_action', 'content_warning', 'content_hidden', 'content_removed', 'user_warned', 'user_suspended', 'user_banned'],
      index: true
    },
    
    // 处理说明
    resultReason: String,
    
    // 处理备注
    processingNotes: String,
    
    // 是否需要上级审核
    requiresEscalation: {
      type: Boolean,
      default: false
    }
  },
  
  // 自动检测信息
  autoDetection: {
    // 是否由自动系统检测
    isAutoDetected: {
      type: Boolean,
      default: false
    },
    
    // 检测算法/模型
    detectionModel: String,
    
    // 置信度分数
    confidenceScore: {
      type: Number,
      min: 0,
      max: 1
    },
    
    // 检测到的问题类型
    detectedIssues: [String],
    
    // 检测结果详情
    detectionDetails: Schema.Types.Mixed
  },
  
  // 相关举报
  relatedReports: [{
    reportId: { type: ObjectId, ref: 'ContentReport' },
    similarity: Number, // 相似度分数
    reason: String     // 关联原因
  }],
  
  // 处理历史
  history: [{
    action: {
      type: String,
      enum: ['created', 'assigned', 'status_changed', 'escalated', 'resolved', 'note_added']
    },
    timestamp: { type: Date, default: Date.now },
    operator: { type: ObjectId, ref: 'User' },
    details: String,
    oldValue: String,
    newValue: String
  }],
  
  // 优先级
  priority: {
    type: String,
    enum: ['low', 'normal', 'high', 'urgent'],
    default: 'normal',
    index: true
  },
  
  // 标签
  tags: [String],
  
  // 地理位置信息
  location: {
    country: String,
    region: String,
    city: String,
    latitude: Number,
    longitude: Number
  },
  
  // 是否已删除
  isDeleted: {
    type: Boolean,
    default: false
  },
  
  // 删除信息
  deletion: {
    deletedAt: Date,
    deletedBy: { type: ObjectId, ref: 'User' },
    reason: String
  }
}, {
  timestamps: true,
  collection: 'content_reports'
});

// 复合索引优化
contentReportSchema.index({ status: 1, priority: -1, createdAt: -1 });
contentReportSchema.index({ 'reportedContent.contentType': 1, 'reportedContent.contentId': 1 });
contentReportSchema.index({ 'reportedContent.contentAuthorId': 1, status: 1 });
contentReportSchema.index({ 'reporter.userId': 1, createdAt: -1 });
contentReportSchema.index({ 'processing.assignedTo': 1, status: 1 });
contentReportSchema.index({ reportType: 1, status: 1, createdAt: -1 });

// 创建举报记录
contentReportSchema.statics.createReport = async function(reportData) {
  const {
    reportType,
    contentType,
    contentId,
    reporterId,
    reason,
    description,
    severity = 'medium',
    ipAddress,
    deviceInfo
  } = reportData;
  
  // 获取被举报内容的详细信息
  const contentSnapshot = await this.getContentSnapshot(contentType, contentId);
  
  const report = new this({
    reportType,
    reportedContent: {
      contentType,
      contentId,
      contentTitle: contentSnapshot.title,
      contentSnapshot: contentSnapshot.snapshot,
      contentAuthorId: contentSnapshot.authorId,
      contentCreatedAt: contentSnapshot.createdAt
    },
    reporter: {
      userId: reporterId,
      ipAddress,
      deviceInfo
    },
    reportDetails: {
      reason,
      description,
      severity
    },
    history: [{
      action: 'created',
      operator: reporterId,
      details: '举报创建'
    }]
  });
  
  // 检查是否有相似的举报
  await report.findSimilarReports();
  
  // 自动分配优先级
  await report.calculatePriority();
  
  return await report.save();
};

// 获取内容快照
contentReportSchema.statics.getContentSnapshot = async function(contentType, contentId) {
  let model, content;
  
  switch (contentType) {
    case 'forum_post':
      model = mongoose.model('ForumPost');
      content = await model.findById(contentId).populate('authorId', 'username');
      return {
        title: content?.title || '',
        snapshot: {
          text: content?.content || '',
          images: content?.images || []
        },
        authorId: content?.authorId?._id,
        createdAt: content?.createdAt
      };
      
    case 'forum_comment':
      model = mongoose.model('ForumComment');
      content = await model.findById(contentId).populate('authorId', 'username');
      return {
        title: '评论',
        snapshot: {
          text: content?.content || ''
        },
        authorId: content?.authorId?._id,
        createdAt: content?.createdAt
      };
      
    case 'review':
      model = mongoose.model('Review');
      content = await model.findById(contentId).populate('userId', 'username');
      return {
        title: '用户评价',
        snapshot: {
          text: content?.comment || '',
          images: content?.images || []
        },
        authorId: content?.userId?._id,
        createdAt: content?.createdAt
      };
      
    default:
      return {
        title: '未知内容',
        snapshot: { text: '' },
        authorId: null,
        createdAt: null
      };
  }
};

// 查找相似举报
contentReportSchema.methods.findSimilarReports = async function() {
  const similarReports = await this.constructor.find({
    'reportedContent.contentId': this.reportedContent.contentId,
    'reportedContent.contentType': this.reportedContent.contentType,
    _id: { $ne: this._id },
    status: { $in: ['pending', 'reviewing'] }
  }).limit(5);
  
  this.relatedReports = similarReports.map(report => ({
    reportId: report._id,
    similarity: 1.0, // 相同内容的相似度为1
    reason: '相同内容的其他举报'
  }));
};

// 计算优先级
contentReportSchema.methods.calculatePriority = async function() {
  let priorityScore = 0;
  
  // 基于举报类型的优先级
  const typeScores = {
    'violence': 3,
    'hate_speech': 3,
    'illegal_activity': 3,
    'adult_content': 2,
    'harassment': 2,
    'inappropriate_content': 1,
    'spam': 1,
    'other': 0
  };
  
  priorityScore += typeScores[this.reportType] || 0;
  
  // 基于严重程度的优先级
  const severityScores = {
    'critical': 3,
    'high': 2,
    'medium': 1,
    'low': 0
  };
  
  priorityScore += severityScores[this.reportDetails.severity] || 0;
  
  // 基于相关举报数量的优先级
  if (this.relatedReports.length > 0) {
    priorityScore += Math.min(this.relatedReports.length, 3);
  }
  
  // 设置优先级
  if (priorityScore >= 6) {
    this.priority = 'urgent';
  } else if (priorityScore >= 4) {
    this.priority = 'high';
  } else if (priorityScore >= 2) {
    this.priority = 'normal';
  } else {
    this.priority = 'low';
  }
};

// 分配审核员
contentReportSchema.methods.assignTo = async function(assigneeId, assignerId) {
  this.processing.assignedTo = assigneeId;
  this.processing.assignedAt = new Date();
  this.status = 'reviewing';
  
  this.history.push({
    action: 'assigned',
    operator: assignerId,
    details: `分配给审核员: ${assigneeId}`,
    newValue: assigneeId.toString()
  });
  
  return await this.save();
};

// 开始处理
contentReportSchema.methods.startProcessing = async function(processerId) {
  this.processing.startedAt = new Date();
  this.status = 'reviewing';
  
  this.history.push({
    action: 'status_changed',
    operator: processerId,
    details: '开始处理举报',
    oldValue: this.status,
    newValue: 'reviewing'
  });
  
  return await this.save();
};

// 解决举报
contentReportSchema.methods.resolve = async function(result, resultReason, processerId, processingNotes) {
  this.processing.result = result;
  this.processing.resultReason = resultReason;
  this.processing.processingNotes = processingNotes;
  this.processing.completedAt = new Date();
  this.status = 'resolved';
  
  this.history.push({
    action: 'resolved',
    operator: processerId,
    details: `举报已解决: ${result}`,
    newValue: result
  });
  
  return await this.save();
};

// 升级举报
contentReportSchema.methods.escalate = async function(reason, operatorId) {
  this.processing.requiresEscalation = true;
  this.status = 'escalated';
  this.priority = this.priority === 'urgent' ? 'urgent' : 'high';
  
  this.history.push({
    action: 'escalated',
    operator: operatorId,
    details: `举报已升级: ${reason}`,
    newValue: 'escalated'
  });
  
  return await this.save();
};

// 获取处理统计
contentReportSchema.statics.getProcessingStats = async function(options = {}) {
  const { startDate, endDate, assigneeId, reportType } = options;
  
  const matchConditions = {};
  
  if (startDate || endDate) {
    matchConditions.createdAt = {};
    if (startDate) matchConditions.createdAt.$gte = new Date(startDate);
    if (endDate) matchConditions.createdAt.$lte = new Date(endDate);
  }
  
  if (assigneeId) {
    matchConditions['processing.assignedTo'] = new mongoose.Types.ObjectId(assigneeId);
  }
  
  if (reportType) {
    matchConditions.reportType = reportType;
  }
  
  const stats = await this.aggregate([
    { $match: matchConditions },
    {
      $group: {
        _id: {
          status: '$status',
          result: '$processing.result'
        },
        count: { $sum: 1 },
        avgProcessingTime: {
          $avg: {
            $cond: [
              { $and: ['$processing.startedAt', '$processing.completedAt'] },
              { $subtract: ['$processing.completedAt', '$processing.startedAt'] },
              null
            ]
          }
        }
      }
    }
  ]);
  
  return stats;
};

// 添加处理备注
contentReportSchema.methods.addNote = async function(note, operatorId) {
  const currentNotes = this.processing.processingNotes || '';
  this.processing.processingNotes = currentNotes ? 
    `${currentNotes}\n[${new Date().toISOString()}] ${note}` : 
    `[${new Date().toISOString()}] ${note}`;
  
  this.history.push({
    action: 'note_added',
    operator: operatorId,
    details: note
  });
  
  return await this.save();
};

// 自动过期处理
contentReportSchema.pre('save', function(next) {
  // 如果举报超过30天未处理，自动标记为低优先级
  if (this.status === 'pending') {
    const daysSinceCreated = Math.floor((Date.now() - this.createdAt.getTime()) / (1000 * 60 * 60 * 24));
    if (daysSinceCreated > 30 && this.priority !== 'low') {
      this.priority = 'low';
    }
  }
  
  next();
});

module.exports = mongoose.model('ContentReport', contentReportSchema);