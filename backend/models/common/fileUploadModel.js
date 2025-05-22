/**
 * 文件上传模型
 * 用于记录和管理系统中的文件上传
 * @module models/file/fileUploadModel
 */

const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/database/shardingService');
const crypto = require('crypto');

// 定义文件上传模型
const fileUploadSchema = new mongoose.Schema({
  // 基本文件信息
  fileName: {
    type: String,
    required: true,
    trim: true,
    description: '文件名称'
  },
  originalName: {
    type: String,
    required: true,
    description: '原始文件名'
  },
  fileType: {
    type: String,
    enum: [
      'image',           // 图片
      'document',        // 文档
      'video',           // 视频
      'audio',           // 音频
      'spreadsheet',     // 电子表格
      'presentation',    // 演示文稿
      'archive',         // 压缩包
      'code',            // 代码文件
      'pdf',             // PDF文件
      'data',            // 数据文件
      'other'            // 其他类型
    ],
    required: true,
    description: '文件类型'
  },
  mimeType: {
    type: String,
    required: true,
    description: '文件MIME类型'
  },
  extension: {
    type: String,
    trim: true,
    lowercase: true,
    description: '文件扩展名'
  },
  size: {
    type: Number,
    required: true,
    min: 0,
    description: '文件大小(bytes)'
  },
  
  // 存储信息
  storage: {
    provider: {
      type: String,
      enum: ['local', 's3', 'oss', 'cos', 'obs', 'gcs', 'azure', 'custom'],
      default: 'local',
      description: '存储提供商'
    },
    bucket: {
      type: String,
      description: '存储桶/容器名称'
    },
    key: {
      type: String,
      required: true,
      description: '存储键/路径'
    },
    region: {
      type: String,
      description: '存储区域'
    },
    url: {
      type: String,
      required: true,
      description: '文件访问URL'
    },
    cdnUrl: {
      type: String,
      description: 'CDN加速URL'
    },
    metadata: {
      type: mongoose.Schema.Types.Mixed,
      description: '存储元数据'
    }
  },
  
  // 所有者和使用信息
  owner: {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      description: '上传用户ID'
    },
    userType: {
      type: String,
      enum: ['user', 'merchant', 'admin', 'system'],
      default: 'user',
      description: '用户类型'
    },
    ipAddress: {
      type: String,
      description: '上传IP'
    },
    userAgent: {
      type: String,
      description: '上传用户代理'
    }
  },
  
  // 使用目的和关联
  purpose: {
    type: String,
    enum: [
      'profile',         // 个人资料
      'product',         // 产品图片
      'message',         // 消息附件
      'post',            // 帖子附件
      'comment',         // 评论附件
      'receipt',         // 票据凭证
      'menu',            // 菜单图片
      'nutrition',       // 营养信息
      'report',          // 报表文件
      'backup',          // 备份文件
      'import',          // 导入文件
      'export',          // 导出文件
      'merchant',        // 商家相关
      'other'            // 其他用途
    ],
    default: 'other',
    description: '文件用途'
  },
  relatedEntityType: {
    type: String,
    description: '关联实体类型'
  },
  relatedEntityId: {
    type: mongoose.Schema.Types.ObjectId,
    description: '关联实体ID'
  },
  
  // 文件元数据
  metadata: {
    // 图片特有元数据
    image: {
      width: Number,        // 宽度
      height: Number,       // 高度
      format: String,       // 格式
      hasAlpha: Boolean,    // 是否有透明通道
      orientation: Number,  // EXIF方向
      isAnimated: Boolean,  // 是否为动画图片
      colorSpace: String,   // 色彩空间
    },
    // 视频特有元数据
    video: {
      width: Number,        // 宽度
      height: Number,       // 高度
      duration: Number,     // 时长(秒)
      bitrate: Number,      // 比特率
      fps: Number,          // 帧率
      codec: String,        // 编码格式
    },
    // 音频特有元数据
    audio: {
      duration: Number,     // 时长(秒)
      bitrate: Number,      // 比特率
      sampleRate: Number,   // 采样率
      channels: Number,     // 声道数
      codec: String,        // 编码格式
    },
    // 文档特有元数据
    document: {
      pageCount: Number,    // 页数
      wordCount: Number,    // 字数
      author: String,       // 作者
      title: String,        // 标题
      subject: String,      // 主题
      keywords: [String],   // 关键词
      creationDate: Date,   // 创建日期
    },
    // 通用元数据
    common: {
      description: String,                // 描述
      tags: [String],                     // 标签
      customFields: mongoose.Schema.Types.Mixed, // 自定义字段
      createdWithApp: String,             // 创建应用
      lastModifiedBy: String,             // 最后修改者
    }
  },
  
  // 处理信息
  processing: {
    isProcessed: {
      type: Boolean,
      default: false,
      description: '是否已处理'
    },
    status: {
      type: String,
      enum: ['pending', 'processing', 'completed', 'failed'],
      default: 'pending',
      description: '处理状态'
    },
    operations: [{
      name: {
        type: String,
        description: '操作名称'
      },
      status: {
        type: String,
        enum: ['pending', 'completed', 'failed'],
        description: '操作状态'
      },
      startTime: {
        type: Date,
        description: '开始时间'
      },
      endTime: {
        type: Date,
        description: '结束时间'
      },
      result: {
        type: mongoose.Schema.Types.Mixed,
        description: '操作结果'
      },
      error: {
        type: String,
        description: '错误信息'
      }
    }],
    completedAt: {
      type: Date,
      description: '处理完成时间'
    }
  },
  
  // 衍生文件
  derivatives: [{
    type: {
      type: String,
      enum: ['thumbnail', 'preview', 'compressed', 'converted', 'optimized', 'watermarked', 'cropped'],
      description: '衍生文件类型'
    },
    fileName: {
      type: String,
      description: '衍生文件名'
    },
    fileSize: {
      type: Number,
      description: '衍生文件大小'
    },
    mimeType: {
      type: String,
      description: '衍生文件MIME类型'
    },
    width: {
      type: Number,
      description: '衍生文件宽度(如适用)'
    },
    height: {
      type: Number,
      description: '衍生文件高度(如适用)'
    },
    url: {
      type: String,
      description: '衍生文件URL'
    },
    metadata: {
      type: mongoose.Schema.Types.Mixed,
      description: '衍生文件元数据'
    }
  }],
  
  // 安全与访问控制
  security: {
    isPublic: {
      type: Boolean,
      default: false,
      description: '是否公开访问'
    },
    accessControl: {
      type: String,
      enum: ['public', 'restricted', 'private'],
      default: 'private',
      description: '访问控制级别'
    },
    allowedUsers: [{
      userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        description: '允许访问的用户ID'
      },
      permissions: {
        type: String,
        enum: ['read', 'write', 'delete', 'all'],
        default: 'read',
        description: '权限类型'
      }
    }],
    allowedRoles: [{
      type: String,
      description: '允许访问的角色'
    }],
    password: {
      type: String,
      description: '访问密码(散列值)'
    },
    expiresAt: {
      type: Date,
      description: '访问过期时间'
    },
    hasBeenScanned: {
      type: Boolean,
      default: false,
      description: '是否已进行安全扫描'
    },
    scanResult: {
      status: {
        type: String,
        enum: ['clean', 'suspicious', 'infected', 'unknown'],
        description: '扫描结果状态'
      },
      scanTime: {
        type: Date,
        description: '扫描时间'
      },
      threats: [{
        type: String,
        description: '发现的威胁'
      }],
      scanEngine: {
        type: String,
        description: '扫描引擎'
      }
    },
    checksum: {
      algorithm: {
        type: String,
        enum: ['md5', 'sha1', 'sha256', 'sha512'],
        default: 'sha256',
        description: '校验和算法'
      },
      value: {
        type: String,
        description: '校验和值'
      }
    }
  },
  
  // 统计与状态
  stats: {
    downloadCount: {
      type: Number,
      default: 0,
      description: '下载次数'
    },
    viewCount: {
      type: Number,
      default: 0,
      description: '查看次数'
    },
    lastAccessed: {
      type: Date,
      description: '最后访问时间'
    }
  },
  status: {
    type: String,
    enum: ['active', 'deleted', 'processing', 'quarantined', 'archived'],
    default: 'active',
    description: '文件状态'
  },
  
  // 生命周期管理
  lifecycle: {
    retentionPolicy: {
      type: String,
      enum: ['permanent', 'temporary', 'policy-based'],
      default: 'permanent',
      description: '保留策略'
    },
    scheduledDeletion: {
      type: Date,
      description: '计划删除时间'
    },
    archiveAfter: {
      type: Date,
      description: '归档时间'
    },
    archivedAt: {
      type: Date,
      description: '实际归档时间'
    },
    deletedAt: {
      type: Date,
      description: '删除时间'
    },
    deletedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      description: '删除用户'
    }
  }
}, {
  timestamps: true,
  collection: 'fileUploads',
  versionKey: false
});

// 创建索引
fileUploadSchema.index({ 'owner.userId': 1, createdAt: -1 });
fileUploadSchema.index({ fileType: 1, status: 1 });
fileUploadSchema.index({ mimeType: 1 });
fileUploadSchema.index({ 'storage.key': 1 }, { unique: true });
fileUploadSchema.index({ 'security.accessControl': 1 });
fileUploadSchema.index({ purpose: 1, 'owner.userId': 1 });
fileUploadSchema.index({ relatedEntityType: 1, relatedEntityId: 1 });
fileUploadSchema.index({ 'lifecycle.scheduledDeletion': 1 });
fileUploadSchema.index({ 'security.checksum.value': 1 });
fileUploadSchema.index({ fileName: 'text', originalName: 'text', 'metadata.common.description': 'text', 'metadata.common.tags': 'text' });

// 添加虚拟字段
fileUploadSchema.virtual('isImage').get(function() {
  return this.fileType === 'image';
});

fileUploadSchema.virtual('isVideo').get(function() {
  return this.fileType === 'video';
});

fileUploadSchema.virtual('isDocument').get(function() {
  return this.fileType === 'document' || this.fileType === 'pdf';
});

fileUploadSchema.virtual('formattedSize').get(function() {
  const bytes = this.size;
  if (bytes < 1024) return bytes + ' B';
  if (bytes < 1048576) return (bytes / 1024).toFixed(2) + ' KB';
  if (bytes < 1073741824) return (bytes / 1048576).toFixed(2) + ' MB';
  return (bytes / 1073741824).toFixed(2) + ' GB';
});

fileUploadSchema.virtual('thumbnailUrl').get(function() {
  if (this.derivatives && this.derivatives.length > 0) {
    const thumbnail = this.derivatives.find(d => d.type === 'thumbnail');
    if (thumbnail) return thumbnail.url;
  }
  return null;
});

// 实例方法
// 记录下载
fileUploadSchema.methods.recordDownload = async function() {
  this.stats.downloadCount += 1;
  this.stats.lastAccessed = new Date();
  return await this.save();
};

// 记录查看
fileUploadSchema.methods.recordView = async function() {
  this.stats.viewCount += 1;
  this.stats.lastAccessed = new Date();
  return await this.save();
};

// 添加衍生文件
fileUploadSchema.methods.addDerivative = async function(derivative) {
  if (!derivative || !derivative.type || !derivative.url) {
    throw new Error('衍生文件信息不完整');
  }
  
  // 检查是否已存在同类型衍生文件
  const existingIndex = this.derivatives.findIndex(d => d.type === derivative.type);
  if (existingIndex >= 0) {
    // 更新已有衍生文件
    this.derivatives[existingIndex] = { ...this.derivatives[existingIndex], ...derivative };
  } else {
    // 添加新衍生文件
    this.derivatives.push(derivative);
  }
  
  return await this.save();
};

// 设置文件处理状态
fileUploadSchema.methods.setProcessingStatus = async function(status, operationResult = null) {
  if (!['pending', 'processing', 'completed', 'failed'].includes(status)) {
    throw new Error('无效的处理状态');
  }
  
  this.processing.status = status;
  
  if (status === 'completed') {
    this.processing.isProcessed = true;
    this.processing.completedAt = new Date();
  }
  
  if (operationResult) {
    const operation = {
      name: operationResult.name,
      status: operationResult.status || 'completed',
      startTime: operationResult.startTime || new Date(),
      endTime: new Date(),
      result: operationResult.result,
      error: operationResult.error
    };
    
    this.processing.operations.push(operation);
  }
  
  return await this.save();
};

// 软删除文件
fileUploadSchema.methods.softDelete = async function(userId) {
  this.status = 'deleted';
  this.lifecycle.deletedAt = new Date();
  this.lifecycle.deletedBy = userId;
  return await this.save();
};

// 将文件归档
fileUploadSchema.methods.archive = async function() {
  this.status = 'archived';
  this.lifecycle.archivedAt = new Date();
  return await this.save();
};

// 更新文件访问控制
fileUploadSchema.methods.updateAccessControl = async function(accessControl, options = {}) {
  this.security.accessControl = accessControl;
  
  if (options.isPublic !== undefined) {
    this.security.isPublic = options.isPublic;
  }
  
  if (options.allowedUsers) {
    this.security.allowedUsers = options.allowedUsers;
  }
  
  if (options.allowedRoles) {
    this.security.allowedRoles = options.allowedRoles;
  }
  
  if (options.expiresAt) {
    this.security.expiresAt = options.expiresAt;
  }
  
  if (options.password) {
    // 散列密码
    const salt = crypto.randomBytes(16).toString('hex');
    const hash = crypto.pbkdf2Sync(options.password, salt, 1000, 64, 'sha512').toString('hex');
    this.security.password = `${salt}:${hash}`;
  }
  
  return await this.save();
};

// 检查访问密码
fileUploadSchema.methods.checkPassword = function(password) {
  if (!this.security.password) return true;
  
  const [salt, storedHash] = this.security.password.split(':');
  const hash = crypto.pbkdf2Sync(password, salt, 1000, 64, 'sha512').toString('hex');
  return storedHash === hash;
};

// 静态方法
// 按类型查找文件
fileUploadSchema.statics.findByType = function(fileType, options = {}) {
  const { limit = 20, skip = 0, sort = 'createdAt', owner = null } = options;
  
  const query = { 
    fileType, 
    status: { $ne: 'deleted' } 
  };
  
  if (owner) {
    query['owner.userId'] = owner;
  }
  
  return this.find(query)
    .sort({ [sort]: -1 })
    .skip(skip)
    .limit(limit);
};

// 查找用户文件
fileUploadSchema.statics.findByUser = function(userId, options = {}) {
  const { fileType, purpose, limit = 20, skip = 0, sort = 'createdAt' } = options;
  
  const query = { 
    'owner.userId': userId,
    status: { $ne: 'deleted' }
  };
  
  if (fileType) {
    query.fileType = fileType;
  }
  
  if (purpose) {
    query.purpose = purpose;
  }
  
  return this.find(query)
    .sort({ [sort]: -1 })
    .skip(skip)
    .limit(limit);
};

// 查找实体相关文件
fileUploadSchema.statics.findByRelatedEntity = function(entityType, entityId) {
  return this.find({ 
    relatedEntityType: entityType, 
    relatedEntityId: entityId,
    status: { $ne: 'deleted' }
  });
};

// 查找重复文件
fileUploadSchema.statics.findDuplicates = async function(checksum, algorithm = 'sha256') {
  return this.find({ 
    'security.checksum.algorithm': algorithm,
    'security.checksum.value': checksum,
    status: { $ne: 'deleted' }
  });
};

// 查找需要清理的文件
fileUploadSchema.statics.findExpiredFiles = function() {
  const now = new Date();
  
  return this.find({
    $or: [
      { 'lifecycle.scheduledDeletion': { $lte: now } },
      { 'security.expiresAt': { $lte: now, $exists: true } }
    ],
    status: { $ne: 'deleted' }
  });
};

// 前置钩子 - 自动生成文件校验和
fileUploadSchema.pre('save', function(next) {
  // 仅在新创建时生成校验和字段
  if (this.isNew && !this.security.checksum.value && this.storage.key) {
    this.security.checksum = {
      algorithm: 'sha256',
      value: crypto.createHash('sha256')
        .update(this.storage.key + this.size + (this.originalName || ''))
        .digest('hex')
    };
  }
  
  next();
});

// 使用ModelFactory创建模型
const FileUpload = ModelFactory.createModel('FileUpload', fileUploadSchema);

// 添加分片支持的保存方法
const originalSave = FileUpload.prototype.save;
FileUpload.prototype.save = async function(options) {
  if (shardingService.config && shardingService.config.enabled && 
      shardingService.config.strategies.FileUpload) {
    // 使用文件类型作为分片键
    const shardKey = this.fileType || 'other';
    const shardCollection = shardingService.getShardName('FileUpload', shardKey);
    console.log(`将文件上传记录保存到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = FileUpload; 