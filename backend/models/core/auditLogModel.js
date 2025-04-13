const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/core/shardingService');

const auditLogSchema = new mongoose.Schema({
  // 操作类型
  action: {
    type: String,
    required: true,
    enum: [
      // 数据访问操作
      'dataAccess', 'dataModify', 'dataDelete', 
      
      // 用户和权限相关
      'userLogin', 'userLogout', 'userRegister', 'userUpdate',
      'passwordChange', 'passwordReset', 'roleChange',
      'accessGrant', 'accessRevoke', 
      
      // 认证相关
      'authSuccess', 'authFailure', 'sessionExpired',
      'twoFactorEnabled', 'twoFactorDisabled', 'twoFactorAuth',
      
      // 管理操作
      'adminLogin', 'adminAction', 'configChange',
      'userLock', 'userUnlock', 'accountDeactivate',
      
      // 验证和审核
      'nutritionistVerify', 'merchantVerify', 'contentModerate',
      
      // 业务操作
      'orderCreate', 'orderUpdate', 'orderCancel', 'paymentProcess',
      'refundProcess', 'healthDataUpload', 'aiRecommendation',
      
      // 系统事件
      'systemError', 'securityAlert', 'apiCall', 'exportData'
    ]
  },
  // 操作描述
  description: {
    type: String,
    required: true
  },
  // 操作执行者
  actor: {
    type: {
      type: String,
      enum: ['user', 'admin', 'system', 'api'],
      required: true
    },
    id: {
      type: mongoose.Schema.Types.ObjectId,
      required: function() {
        return this.actor.type !== 'system';
      },
      refPath: 'actor.model'
    },
    model: {
      type: String,
      enum: ['User', 'Admin', 'ApiClient'],
      required: function() {
        return this.actor.type !== 'system';
      },
      default: function() {
        if (this.actor.type === 'user') return 'User';
        if (this.actor.type === 'admin') return 'Admin';
        if (this.actor.type === 'api') return 'ApiClient';
        return null;
      }
    },
    name: {
      type: String
    }
  },
  // 资源信息（被操作的对象）
  resource: {
    type: {
      type: String,
      enum: [
        'user', 'nutritionProfile', 'healthData', 'order', 
        'dish', 'merchant', 'store', 'nutritionist', 'payment',
        'refund', 'systemConfig', 'forumPost', 'forumComment',
        'accessControl', 'sensitiveData'
      ],
      required: true
    },
    id: {
      type: mongoose.Schema.Types.ObjectId
    },
    name: {
      type: String
    },
    ownerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    }
  },
  // 记录操作前后的数据（用于敏感操作）
  dataSnapshot: {
    before: {
      type: Map,
      of: mongoose.Schema.Types.Mixed
    },
    after: {
      type: Map,
      of: mongoose.Schema.Types.Mixed
    },
    changedFields: [String]
  },
  // 操作结果
  result: {
    status: {
      type: String,
      enum: ['success', 'failure', 'warning', 'info'],
      required: true
    },
    message: {
      type: String
    },
    errorCode: {
      type: String
    },
    errorDetails: {
      type: String
    }
  },
  // 操作参数（不含敏感数据）
  parameters: {
    type: Map,
    of: mongoose.Schema.Types.Mixed
  },
  // 操作环境
  context: {
    ipAddress: {
      type: String
    },
    userAgent: {
      type: String
    },
    deviceInfo: {
      type: String
    },
    location: {
      type: String
    },
    sessionId: {
      type: String
    },
    requestId: {
      type: String
    }
  },
  // 敏感度分级
  sensitivityLevel: {
    type: Number,
    enum: [1, 2, 3], // 1=高敏感, 2=中敏感, 3=低敏感
    default: 3
  },
  // 操作时间
  createdAt: {
    type: Date,
    default: Date.now,
    index: true
  },
  // 数据保留策略
  retentionPolicy: {
    type: String,
    enum: ['standard', 'extended', 'permanent'],
    default: 'standard'
  },
  // 添加TTL索引，根据不同保留策略自动过期
  // 增加用于计算过期时间的expiryDate字段
  expiryDate: {
    type: Date
  }
}, {
  timestamps: false, // 不使用默认timestamps，使用自定义createdAt字段
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 创建索引用于高效查询
auditLogSchema.index({ 'actor.id': 1, 'actor.type': 1 });
auditLogSchema.index({ 'resource.id': 1, 'resource.type': 1 });
auditLogSchema.index({ 'resource.ownerId': 1 });
auditLogSchema.index({ action: 1 });
auditLogSchema.index({ 'result.status': 1 });
auditLogSchema.index({ sensitivityLevel: 1 });
auditLogSchema.index({ createdAt: 1 });
auditLogSchema.index({ 'context.ipAddress': 1 });

// 为标准保留期限的日志添加TTL索引 (365天)
auditLogSchema.index({ expiryDate: 1 }, { expireAfterSeconds: 0 });

// 添加复合索引优化常见查询
auditLogSchema.index({ action: 1, createdAt: -1 });
auditLogSchema.index({ sensitivityLevel: 1, createdAt: -1 });
auditLogSchema.index({ 'actor.id': 1, action: 1, createdAt: -1 });
auditLogSchema.index({ 'resource.type': 1, 'result.status': 1, createdAt: -1 });

// 部分索引，仅对高敏感度操作创建索引，优化安全审计查询
auditLogSchema.index(
  { 'actor.id': 1, createdAt: -1 },
  { partialFilterExpression: { sensitivityLevel: 1 } }
);

// 添加虚拟字段
auditLogSchema.virtual('isSensitive').get(function() {
  return this.sensitivityLevel === 1;
});

auditLogSchema.virtual('daysUntilExpiry').get(function() {
  if (!this.expiryDate || this.retentionPolicy === 'permanent') return null;
  
  const now = new Date();
  const diffTime = this.expiryDate - now;
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
});

auditLogSchema.virtual('actionCategory').get(function() {
  const actionCategories = {
    dataAccess: 'data', dataModify: 'data', dataDelete: 'data',
    userLogin: 'auth', userLogout: 'auth', userRegister: 'auth', 
    passwordChange: 'auth', passwordReset: 'auth',
    adminLogin: 'admin', adminAction: 'admin', configChange: 'admin',
    orderCreate: 'business', orderUpdate: 'business', orderCancel: 'business',
    paymentProcess: 'business', refundProcess: 'business',
    systemError: 'system', securityAlert: 'security'
  };
  
  return actionCategories[this.action] || 'other';
});

// 更新前自动设置过期时间
auditLogSchema.pre('save', function(next) {
  if (this.isNew) {
    // 根据保留策略设置过期日期
    const now = new Date();
    if (this.retentionPolicy === 'standard') {
      // 标准保留期 - 1年
      this.expiryDate = new Date(now.setFullYear(now.getFullYear() + 1));
    } else if (this.retentionPolicy === 'extended') {
      // 扩展保留期 - 5年
      this.expiryDate = new Date(now.setFullYear(now.getFullYear() + 5));
    }
    // 永久保留的不设置过期日期
    
    // 确保创建时间已设置
    if (!this.createdAt) {
      this.createdAt = new Date();
    }
    
    // 根据操作类型自动设置敏感度
    if (!this.sensitivityLevel) {
      const highSensitivityActions = ['passwordChange', 'passwordReset', 'dataDelete', 'adminAction', 'systemError', 'securityAlert'];
      const mediumSensitivityActions = ['userLogin', 'userLogout', 'roleChange', 'accessGrant', 'accessRevoke', 'dataModify'];
      
      if (highSensitivityActions.includes(this.action)) {
        this.sensitivityLevel = 1;
      } else if (mediumSensitivityActions.includes(this.action)) {
        this.sensitivityLevel = 2;
      } else {
        this.sensitivityLevel = 3;
      }
    }
  }
  next();
});

// 静态方法：记录用户登录
auditLogSchema.statics.logUserLogin = async function(userId, username, isSuccess, ipAddress, userAgent, details = {}) {
  const log = new this({
    action: 'userLogin',
    description: isSuccess ? `用户 ${username} 登录成功` : `用户 ${username} 登录失败`,
    actor: {
      type: 'user',
      id: userId,
      model: 'User',
      name: username
    },
    resource: {
      type: 'user',
      id: userId,
      name: username
    },
    result: {
      status: isSuccess ? 'success' : 'failure',
      message: isSuccess ? '登录成功' : '登录失败',
      errorCode: details.errorCode,
      errorDetails: details.errorDetails
    },
    context: {
      ipAddress: ipAddress,
      userAgent: userAgent,
      sessionId: details.sessionId
    },
    sensitivityLevel: 2
  });
  
  return await log.save();
};

// 静态方法：记录数据访问
auditLogSchema.statics.logDataAccess = async function(actorId, actorType, actorName, resourceType, resourceId, resourceName, isSuccess, ipAddress, details = {}) {
  const log = new this({
    action: 'dataAccess',
    description: `${actorType} ${actorName} 访问了 ${resourceType} ${resourceName || resourceId}`,
    actor: {
      type: actorType,
      id: actorId,
      model: actorType === 'user' ? 'User' : (actorType === 'admin' ? 'Admin' : 'ApiClient'),
      name: actorName
    },
    resource: {
      type: resourceType,
      id: resourceId,
      name: resourceName,
      ownerId: details.ownerId
    },
    result: {
      status: isSuccess ? 'success' : 'failure',
      message: isSuccess ? '访问成功' : '访问失败',
      errorCode: details.errorCode,
      errorDetails: details.errorDetails
    },
    parameters: details.parameters,
    context: {
      ipAddress: ipAddress,
      userAgent: details.userAgent,
      sessionId: details.sessionId,
      requestId: details.requestId
    },
    sensitivityLevel: details.sensitivityLevel || 3
  });
  
  return await log.save();
};

// 静态方法：记录数据修改
auditLogSchema.statics.logDataModify = async function(actorId, actorType, actorName, resourceType, resourceId, resourceName, dataBefore, dataAfter, isSuccess, ipAddress, details = {}) {
  // 计算哪些字段发生了变化
  const changedFields = [];
  if (dataBefore && dataAfter) {
    const allKeys = new Set([...Object.keys(dataBefore), ...Object.keys(dataAfter)]);
    for (const key of allKeys) {
      if (JSON.stringify(dataBefore[key]) !== JSON.stringify(dataAfter[key])) {
        changedFields.push(key);
      }
    }
  }
  
  const log = new this({
    action: 'dataModify',
    description: `${actorType} ${actorName} 修改了 ${resourceType} ${resourceName || resourceId}`,
    actor: {
      type: actorType,
      id: actorId,
      model: actorType === 'user' ? 'User' : (actorType === 'admin' ? 'Admin' : 'ApiClient'),
      name: actorName
    },
    resource: {
      type: resourceType,
      id: resourceId,
      name: resourceName,
      ownerId: details.ownerId
    },
    dataSnapshot: {
      before: dataBefore,
      after: dataAfter,
      changedFields: changedFields
    },
    result: {
      status: isSuccess ? 'success' : 'failure',
      message: isSuccess ? '修改成功' : '修改失败',
      errorCode: details.errorCode,
      errorDetails: details.errorDetails
    },
    parameters: details.parameters,
    context: {
      ipAddress: ipAddress,
      userAgent: details.userAgent,
      sessionId: details.sessionId,
      requestId: details.requestId
    },
    sensitivityLevel: details.sensitivityLevel || 2
  });
  
  return await log.save();
};

// 静态方法：记录管理员操作
auditLogSchema.statics.logAdminAction = async function(adminId, adminName, action, resourceType, resourceId, resourceName, details = {}) {
  const log = new this({
    action: 'adminAction',
    description: `管理员 ${adminName} 执行了操作: ${action} 于 ${resourceType} ${resourceName || resourceId}`,
    actor: {
      type: 'admin',
      id: adminId,
      model: 'Admin',
      name: adminName
    },
    resource: {
      type: resourceType,
      id: resourceId,
      name: resourceName,
      ownerId: details.ownerId
    },
    dataSnapshot: {
      before: details.dataBefore,
      after: details.dataAfter,
      changedFields: details.changedFields
    },
    result: {
      status: details.status || 'success',
      message: details.message || '操作成功',
      errorCode: details.errorCode,
      errorDetails: details.errorDetails
    },
    parameters: details.parameters,
    context: {
      ipAddress: details.ipAddress,
      userAgent: details.userAgent,
      sessionId: details.sessionId,
      requestId: details.requestId
    },
    sensitivityLevel: 1, // 管理员操作为高敏感度
    retentionPolicy: 'extended' // 管理员操作保留更长时间
  });
  
  return await log.save();
};

// 静态方法：记录系统错误
auditLogSchema.statics.logSystemError = async function(errorCode, errorMessage, stackTrace, context = {}) {
  const log = new this({
    action: 'systemError',
    description: `系统错误: ${errorMessage}`,
    actor: {
      type: 'system',
      name: 'system'
    },
    resource: {
      type: 'systemConfig',
      name: 'system'
    },
    result: {
      status: 'failure',
      message: errorMessage,
      errorCode: errorCode,
      errorDetails: stackTrace
    },
    context: {
      ipAddress: context.ipAddress,
      userAgent: context.userAgent,
      sessionId: context.sessionId,
      requestId: context.requestId
    },
    sensitivityLevel: 2,
    retentionPolicy: 'extended'
  });
  
  return await log.save();
};

// 静态方法：记录安全警报
auditLogSchema.statics.logSecurityAlert = async function(alertType, severity, description, ipAddress, userId, details = {}) {
  const log = new this({
    action: 'securityAlert',
    description: `安全警报 [${severity}]: ${description}`,
    actor: {
      type: userId ? 'user' : 'system',
      id: userId,
      model: userId ? 'User' : undefined,
      name: details.username || 'system'
    },
    resource: {
      type: 'sensitiveData',
      id: userId,
      ownerId: userId
    },
    result: {
      status: 'warning',
      message: `${alertType}安全警报: ${description}`,
      errorCode: details.errorCode
    },
    parameters: {
      alertType: alertType,
      severity: severity
    },
    context: {
      ipAddress: ipAddress,
      userAgent: details.userAgent,
      deviceInfo: details.deviceInfo,
      location: details.location
    },
    sensitivityLevel: 1, // 安全警报为高敏感度
    retentionPolicy: 'permanent' // 安全警报永久保存
  });
  
  return await log.save();
};

// 静态方法：查询用户活动历史
auditLogSchema.statics.getUserActivityHistory = function(userId, startDate = null, endDate = null, actions = null, limit = 100) {
  const query = { 'actor.id': userId };
  
  if (startDate || endDate) {
    query.createdAt = {};
    if (startDate) query.createdAt.$gte = new Date(startDate);
    if (endDate) query.createdAt.$lte = new Date(endDate);
  }
  
  if (actions && Array.isArray(actions) && actions.length > 0) {
    query.action = { $in: actions };
  }
  
  return this.find(query)
    .sort({ createdAt: -1 })
    .limit(limit);
};

// 静态方法：查询资源访问历史
auditLogSchema.statics.getResourceAccessHistory = function(resourceType, resourceId, startDate = null, endDate = null, limit = 100) {
  const query = { 
    'resource.type': resourceType, 
    'resource.id': resourceId 
  };
  
  if (startDate || endDate) {
    query.createdAt = {};
    if (startDate) query.createdAt.$gte = new Date(startDate);
    if (endDate) query.createdAt.$lte = new Date(endDate);
  }
  
  return this.find(query)
    .sort({ createdAt: -1 })
    .limit(limit);
};

// 静态方法：查询安全事件
auditLogSchema.statics.getSecurityEvents = function(startDate = null, endDate = null, severity = null, limit = 100) {
  const query = { 
    action: { $in: ['securityAlert', 'authFailure', 'systemError'] }
  };
  
  if (startDate || endDate) {
    query.createdAt = {};
    if (startDate) query.createdAt.$gte = new Date(startDate);
    if (endDate) query.createdAt.$lte = new Date(endDate);
  }
  
  if (severity) {
    query['parameters.severity'] = severity;
  }
  
  return this.find(query)
    .sort({ createdAt: -1 })
    .limit(limit);
};

// 静态方法：清理过期日志（手动触发）
auditLogSchema.statics.cleanExpiredLogs = async function() {
  const now = new Date();
  return await this.deleteMany({
    expiryDate: { $lt: now },
    retentionPolicy: { $ne: 'permanent' }
  });
};

// 使用ModelFactory创建支持读写分离和分片的审计日志模型
const AuditLog = ModelFactory.createModel('AuditLog', auditLogSchema);

// 添加分片支持
// 由于审计日志数据量大，按时间和用户ID进行分片
AuditLog.getShardKey = function(doc) {
  if (doc.actor && doc.actor.id) {
    // 基于用户ID和日期进行分片
    const dateStr = doc.createdAt ? 
      new Date(doc.createdAt).toISOString().substring(0, 7) : // YYYY-MM
      new Date().toISOString().substring(0, 7);
    
    return `${doc.actor.id}-${dateStr}`;
  }
  
  // 如果没有用户ID，仅基于日期分片
  const dateStr = doc.createdAt ? 
    new Date(doc.createdAt).toISOString().substring(0, 7) : // YYYY-MM
    new Date().toISOString().substring(0, 7);
  
  return `system-${dateStr}`;
};

module.exports = AuditLog; 