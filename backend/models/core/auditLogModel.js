const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/shardingService');

const auditLogSchema = new mongoose.Schema({
  // 操作类型
  action: {
    type: String,
    required: true,
    enum: [
      // 数据访问操作
      'data_access', 'data_modify', 'data_delete', 
      
      // 用户和权限相关
      'user_login', 'user_logout', 'user_register', 'user_update',
      'password_change', 'password_reset', 'role_change',
      'access_grant', 'access_revoke', 
      
      // 认证相关
      'auth_success', 'auth_failure', 'session_expired',
      'two_factor_enabled', 'two_factor_disabled', 'two_factor_auth',
      
      // 管理操作
      'admin_login', 'admin_action', 'config_change',
      'user_lock', 'user_unlock', 'account_deactivate',
      
      // 验证和审核
      'nutritionist_verify', 'merchant_verify', 'content_moderate',
      
      // 业务操作
      'order_create', 'order_update', 'order_cancel', 'payment_process',
      'refund_process', 'health_data_upload', 'ai_recommendation',
      
      // 系统事件
      'system_error', 'security_alert', 'api_call', 'export_data'
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
        'user', 'nutrition_profile', 'health_data', 'order', 
        'dish', 'merchant', 'store', 'nutritionist', 'payment',
        'refund', 'system_config', 'forum_post', 'forum_comment',
        'access_control', 'sensitive_data'
      ],
      required: true
    },
    id: {
      type: mongoose.Schema.Types.ObjectId
    },
    name: {
      type: String
    },
    owner_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    }
  },
  // 记录操作前后的数据（用于敏感操作）
  data_snapshot: {
    before: {
      type: Map,
      of: mongoose.Schema.Types.Mixed
    },
    after: {
      type: Map,
      of: mongoose.Schema.Types.Mixed
    },
    changed_fields: [String]
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
    error_code: {
      type: String
    },
    error_details: {
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
    ip_address: {
      type: String
    },
    user_agent: {
      type: String
    },
    device_info: {
      type: String
    },
    location: {
      type: String
    },
    session_id: {
      type: String
    },
    request_id: {
      type: String
    }
  },
  // 敏感度分级
  sensitivity_level: {
    type: Number,
    enum: [1, 2, 3], // 1=高敏感, 2=中敏感, 3=低敏感
    default: 3
  },
  // 操作时间
  created_at: {
    type: Date,
    default: Date.now,
    index: true
  },
  // 数据保留策略
  retention_policy: {
    type: String,
    enum: ['standard', 'extended', 'permanent'],
    default: 'standard'
  },
  // 添加TTL索引，根据不同保留策略自动过期
  // 增加用于计算过期时间的expiry_date字段
  expiry_date: {
    type: Date
  }
}, {
  timestamps: false, // 不使用默认timestamps，使用自定义created_at字段
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 创建索引用于高效查询
auditLogSchema.index({ 'actor.id': 1, 'actor.type': 1 });
auditLogSchema.index({ 'resource.id': 1, 'resource.type': 1 });
auditLogSchema.index({ 'resource.owner_id': 1 });
auditLogSchema.index({ action: 1 });
auditLogSchema.index({ 'result.status': 1 });
auditLogSchema.index({ sensitivity_level: 1 });
auditLogSchema.index({ created_at: 1 });
auditLogSchema.index({ 'context.ip_address': 1 });

// 为标准保留期限的日志添加TTL索引 (365天)
auditLogSchema.index({ expiry_date: 1 }, { expireAfterSeconds: 0 });

// 添加复合索引优化常见查询
auditLogSchema.index({ action: 1, created_at: -1 });
auditLogSchema.index({ sensitivity_level: 1, created_at: -1 });
auditLogSchema.index({ 'actor.id': 1, action: 1, created_at: -1 });
auditLogSchema.index({ 'resource.type': 1, 'result.status': 1, created_at: -1 });

// 部分索引，仅对高敏感度操作创建索引，优化安全审计查询
auditLogSchema.index(
  { 'actor.id': 1, created_at: -1 },
  { partialFilterExpression: { sensitivity_level: 1 } }
);

// 添加虚拟字段
auditLogSchema.virtual('is_sensitive').get(function() {
  return this.sensitivity_level === 1;
});

auditLogSchema.virtual('days_until_expiry').get(function() {
  if (!this.expiry_date || this.retention_policy === 'permanent') return null;
  
  const now = new Date();
  const diffTime = this.expiry_date - now;
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
});

auditLogSchema.virtual('action_category').get(function() {
  const actionCategories = {
    data_access: 'data', data_modify: 'data', data_delete: 'data',
    user_login: 'auth', user_logout: 'auth', user_register: 'auth', 
    password_change: 'auth', password_reset: 'auth',
    admin_login: 'admin', admin_action: 'admin', config_change: 'admin',
    order_create: 'business', order_update: 'business', order_cancel: 'business',
    payment_process: 'business', refund_process: 'business',
    system_error: 'system', security_alert: 'security'
  };
  
  return actionCategories[this.action] || 'other';
});

// 更新前自动设置过期时间
auditLogSchema.pre('save', function(next) {
  if (this.isNew) {
    // 根据保留策略设置过期日期
    const now = new Date();
    if (this.retention_policy === 'standard') {
      // 标准保留期 - 1年
      this.expiry_date = new Date(now.setFullYear(now.getFullYear() + 1));
    } else if (this.retention_policy === 'extended') {
      // 扩展保留期 - 5年
      this.expiry_date = new Date(now.setFullYear(now.getFullYear() + 5));
    }
    // 永久保留的不设置过期日期
    
    // 确保创建时间已设置
    if (!this.created_at) {
      this.created_at = new Date();
    }
    
    // 根据操作类型自动设置敏感度
    if (!this.sensitivity_level) {
      const highSensitivityActions = ['password_change', 'password_reset', 'data_delete', 'admin_action', 'system_error', 'security_alert'];
      const mediumSensitivityActions = ['user_login', 'user_logout', 'role_change', 'access_grant', 'access_revoke', 'data_modify'];
      
      if (highSensitivityActions.includes(this.action)) {
        this.sensitivity_level = 1;
      } else if (mediumSensitivityActions.includes(this.action)) {
        this.sensitivity_level = 2;
      } else {
        this.sensitivity_level = 3;
      }
    }
  }
  next();
});

// 静态方法：记录用户登录
auditLogSchema.statics.logUserLogin = async function(userId, username, isSuccess, ipAddress, userAgent, details = {}) {
  const log = new this({
    action: 'user_login',
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
      error_code: details.error_code,
      error_details: details.error_details
    },
    context: {
      ip_address: ipAddress,
      user_agent: userAgent,
      session_id: details.session_id
    },
    sensitivity_level: 2
  });
  
  return await log.save();
};

// 静态方法：记录数据访问
auditLogSchema.statics.logDataAccess = async function(actorId, actorType, actorName, resourceType, resourceId, resourceName, isSuccess, ipAddress, details = {}) {
  const log = new this({
    action: 'data_access',
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
      owner_id: details.owner_id
    },
    result: {
      status: isSuccess ? 'success' : 'failure',
      message: isSuccess ? '访问成功' : '访问失败',
      error_code: details.error_code,
      error_details: details.error_details
    },
    parameters: details.parameters,
    context: {
      ip_address: ipAddress,
      user_agent: details.user_agent,
      session_id: details.session_id,
      request_id: details.request_id
    },
    sensitivity_level: details.sensitivity_level || 3
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
    action: 'data_modify',
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
      owner_id: details.owner_id
    },
    data_snapshot: {
      before: dataBefore,
      after: dataAfter,
      changed_fields: changedFields
    },
    result: {
      status: isSuccess ? 'success' : 'failure',
      message: isSuccess ? '修改成功' : '修改失败',
      error_code: details.error_code,
      error_details: details.error_details
    },
    parameters: details.parameters,
    context: {
      ip_address: ipAddress,
      user_agent: details.user_agent,
      session_id: details.session_id,
      request_id: details.request_id
    },
    sensitivity_level: details.sensitivity_level || 2
  });
  
  return await log.save();
};

// 静态方法：记录管理员操作
auditLogSchema.statics.logAdminAction = async function(adminId, adminName, action, resourceType, resourceId, resourceName, details = {}) {
  const log = new this({
    action: 'admin_action',
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
      owner_id: details.owner_id
    },
    data_snapshot: {
      before: details.dataBefore,
      after: details.dataAfter,
      changed_fields: details.changedFields
    },
    result: {
      status: details.status || 'success',
      message: details.message || '操作成功',
      error_code: details.error_code,
      error_details: details.error_details
    },
    parameters: details.parameters,
    context: {
      ip_address: details.ipAddress,
      user_agent: details.userAgent,
      session_id: details.sessionId,
      request_id: details.requestId
    },
    sensitivity_level: 1, // 管理员操作为高敏感度
    retention_policy: 'extended' // 管理员操作保留更长时间
  });
  
  return await log.save();
};

// 静态方法：记录系统错误
auditLogSchema.statics.logSystemError = async function(errorCode, errorMessage, stackTrace, context = {}) {
  const log = new this({
    action: 'system_error',
    description: `系统错误: ${errorMessage}`,
    actor: {
      type: 'system',
      name: 'system'
    },
    resource: {
      type: 'system_config',
      name: 'system'
    },
    result: {
      status: 'failure',
      message: errorMessage,
      error_code: errorCode,
      error_details: stackTrace
    },
    context: {
      ip_address: context.ipAddress,
      user_agent: context.userAgent,
      session_id: context.sessionId,
      request_id: context.requestId
    },
    sensitivity_level: 2,
    retention_policy: 'extended'
  });
  
  return await log.save();
};

// 静态方法：记录安全警报
auditLogSchema.statics.logSecurityAlert = async function(alertType, severity, description, ipAddress, userId, details = {}) {
  const log = new this({
    action: 'security_alert',
    description: `安全警报 [${severity}]: ${description}`,
    actor: {
      type: userId ? 'user' : 'system',
      id: userId,
      model: userId ? 'User' : undefined,
      name: details.username || 'system'
    },
    resource: {
      type: 'sensitive_data',
      id: userId,
      owner_id: userId
    },
    result: {
      status: 'warning',
      message: `${alertType}安全警报: ${description}`,
      error_code: details.error_code
    },
    parameters: {
      alert_type: alertType,
      severity: severity
    },
    context: {
      ip_address: ipAddress,
      user_agent: details.userAgent,
      device_info: details.deviceInfo,
      location: details.location
    },
    sensitivity_level: 1, // 安全警报为高敏感度
    retention_policy: 'permanent' // 安全警报永久保存
  });
  
  return await log.save();
};

// 静态方法：查询用户活动历史
auditLogSchema.statics.getUserActivityHistory = function(userId, startDate = null, endDate = null, actions = null, limit = 100) {
  const query = { 'actor.id': userId };
  
  if (startDate || endDate) {
    query.created_at = {};
    if (startDate) query.created_at.$gte = new Date(startDate);
    if (endDate) query.created_at.$lte = new Date(endDate);
  }
  
  if (actions && Array.isArray(actions) && actions.length > 0) {
    query.action = { $in: actions };
  }
  
  return this.find(query)
    .sort({ created_at: -1 })
    .limit(limit);
};

// 静态方法：查询资源访问历史
auditLogSchema.statics.getResourceAccessHistory = function(resourceType, resourceId, startDate = null, endDate = null, limit = 100) {
  const query = { 
    'resource.type': resourceType, 
    'resource.id': resourceId 
  };
  
  if (startDate || endDate) {
    query.created_at = {};
    if (startDate) query.created_at.$gte = new Date(startDate);
    if (endDate) query.created_at.$lte = new Date(endDate);
  }
  
  return this.find(query)
    .sort({ created_at: -1 })
    .limit(limit);
};

// 静态方法：查询安全事件
auditLogSchema.statics.getSecurityEvents = function(startDate = null, endDate = null, severity = null, limit = 100) {
  const query = { 
    action: { $in: ['security_alert', 'auth_failure', 'system_error'] }
  };
  
  if (startDate || endDate) {
    query.created_at = {};
    if (startDate) query.created_at.$gte = new Date(startDate);
    if (endDate) query.created_at.$lte = new Date(endDate);
  }
  
  if (severity) {
    query['parameters.severity'] = severity;
  }
  
  return this.find(query)
    .sort({ created_at: -1 })
    .limit(limit);
};

// 静态方法：清理过期日志（手动触发）
auditLogSchema.statics.cleanExpiredLogs = async function() {
  const now = new Date();
  return await this.deleteMany({
    expiry_date: { $lt: now },
    retention_policy: { $ne: 'permanent' }
  });
};

// 使用ModelFactory创建支持读写分离和分片的审计日志模型
const AuditLog = ModelFactory.model('AuditLog', auditLogSchema);

// 添加分片支持
// 由于审计日志数据量大，按时间和用户ID进行分片
AuditLog.getShardKey = function(doc) {
  if (doc.actor && doc.actor.id) {
    // 基于用户ID和日期进行分片
    const dateStr = doc.created_at ? 
      new Date(doc.created_at).toISOString().substring(0, 7) : // YYYY-MM
      new Date().toISOString().substring(0, 7);
    
    return `${doc.actor.id}-${dateStr}`;
  }
  
  // 如果没有用户ID，仅基于日期分片
  const dateStr = doc.created_at ? 
    new Date(doc.created_at).toISOString().substring(0, 7) : // YYYY-MM
    new Date().toISOString().substring(0, 7);
  
  return `system-${dateStr}`;
};

module.exports = AuditLog; 