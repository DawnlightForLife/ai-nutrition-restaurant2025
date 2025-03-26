const mongoose = require('mongoose');
const ModelFactory = require('./modelFactory');
const { shardingService } = require('../services/shardingService');

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

// 部分索引，仅对高敏感度操作创建索引，优化安全审计查询
auditLogSchema.index(
  { 'actor.id': 1, created_at: -1 },
  { partialFilterExpression: { sensitivity_level: 1 } }
);

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
auditLogSchema.statics.logDataAccess = async function(options) {
  const {
    actorType, actorId, actorName,
    resourceType, resourceId, resourceName, resourceOwnerId,
    isSuccess, description, ipAddress, userAgent,
    sessionId, accessType, details = {}
  } = options;
  
  const log = new this({
    action: 'data_access',
    description: description || `${actorType} ${actorName} ${accessType} ${resourceType} ${resourceName || resourceId}`,
    actor: {
      type: actorType,
      id: actorId,
      name: actorName
    },
    resource: {
      type: resourceType,
      id: resourceId,
      name: resourceName,
      owner_id: resourceOwnerId
    },
    result: {
      status: isSuccess ? 'success' : 'failure',
      message: isSuccess ? '访问成功' : '访问被拒绝',
      error_code: details.error_code,
      error_details: details.error_details
    },
    parameters: details.parameters,
    context: {
      ip_address: ipAddress,
      user_agent: userAgent,
      session_id: sessionId,
      request_id: details.request_id
    },
    sensitivity_level: 
      (resourceType === 'health_data' || resourceType === 'sensitive_data') ? 1 :
      (resourceType === 'payment' || resourceType === 'user') ? 2 : 3
  });
  
  return await log.save();
};

// 静态方法：记录数据变更
auditLogSchema.statics.logDataChange = async function(options) {
  const {
    actorType, actorId, actorName,
    resourceType, resourceId, resourceName, resourceOwnerId,
    changeType, // 'modify' or 'delete'
    beforeData, afterData, changedFields,
    isSuccess, description, ipAddress, userAgent,
    sessionId, details = {}
  } = options;
  
  const action = changeType === 'delete' ? 'data_delete' : 'data_modify';
  
  const log = new this({
    action,
    description: description || `${actorType} ${actorName} ${changeType === 'delete' ? '删除' : '修改'} ${resourceType} ${resourceName || resourceId}`,
    actor: {
      type: actorType,
      id: actorId,
      name: actorName
    },
    resource: {
      type: resourceType,
      id: resourceId,
      name: resourceName,
      owner_id: resourceOwnerId
    },
    data_snapshot: {
      before: beforeData,
      after: afterData,
      changed_fields: changedFields
    },
    result: {
      status: isSuccess ? 'success' : 'failure',
      message: isSuccess ? '操作成功' : '操作失败',
      error_code: details.error_code,
      error_details: details.error_details
    },
    parameters: details.parameters,
    context: {
      ip_address: ipAddress,
      user_agent: userAgent,
      session_id: sessionId,
      request_id: details.request_id
    },
    sensitivity_level: 
      (resourceType === 'health_data' || resourceType === 'sensitive_data') ? 1 :
      (resourceType === 'payment' || resourceType === 'user') ? 2 : 3,
    retention_policy: 
      (resourceType === 'health_data' || resourceType === 'sensitive_data' || resourceType === 'payment') 
        ? 'permanent' : 'standard'
  });
  
  return await log.save();
};

// 静态方法：记录系统安全事件
auditLogSchema.statics.logSecurityEvent = async function(options) {
  const {
    eventType, // 'security_alert', 'system_error', etc.
    severity, // 'success', 'warning', 'failure'
    description,
    details = {},
    actorType, actorId, actorName,
    resourceType, resourceId, ipAddress
  } = options;
  
  const log = new this({
    action: eventType,
    description,
    actor: {
      type: actorType || 'system',
      id: actorId,
      name: actorName || 'System'
    },
    resource: {
      type: resourceType || 'system_config',
      id: resourceId
    },
    result: {
      status: severity,
      message: description,
      error_code: details.error_code,
      error_details: details.error_details
    },
    parameters: details.parameters,
    context: {
      ip_address: ipAddress,
      request_id: details.request_id
    },
    sensitivity_level: 1,
    retention_policy: 'permanent'
  });
  
  return await log.save();
};

// 使用ModelFactory创建支持读写分离的模型
const AuditLog = ModelFactory.model('AuditLog', auditLogSchema);

// 添加分片支持的保存方法
const originalSave = AuditLog.prototype.save;
AuditLog.prototype.save = async function(options) {
  if (shardingService.config.enabled && 
      shardingService.config.strategies.AuditLog) {
    // 应用时间分片策略，使用创建时间作为分片键
    const shardCollection = shardingService.getShardName('AuditLog', this.created_at);
    console.log(`将审计日志保存到分片: ${shardCollection}`);
    // 在这里可以根据分片集合名称调整模型
  }
  return originalSave.call(this, options);
};

module.exports = AuditLog; 