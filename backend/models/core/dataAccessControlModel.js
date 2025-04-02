const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/shardingService');

const dataAccessControlSchema = new mongoose.Schema({
  // 授予权限的主体
  principal: {
    // 主体类型（用户、角色、应用）
    type: {
      type: String,
      enum: ['user', 'role', 'application'],
      required: true
    },
    // 主体ID
    id: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      refPath: 'principal.type_ref'
    },
    // 主体引用的模型
    type_ref: {
      type: String,
      required: true,
      enum: ['User', 'UserRole', 'ApiClient'],
      default: function() {
        switch(this.principal.type) {
          case 'user': return 'User';
          case 'role': return 'UserRole';
          case 'application': return 'ApiClient';
          default: return 'User';
        }
      }
    }
  },
  // 被授权的资源
  resource: {
    // 资源类型
    type: {
      type: String,
      enum: [
        'user_profile', 
        'health_data', 
        'nutrition_profile', 
        'order', 
        'dish', 
        'merchant', 
        'store', 
        'nutritionist', 
        'forum_post',
        'payment',
        'admin_dashboard',
        'system_config'
      ],
      required: true
    },
    // 资源标识符（特定资源ID）
    id: {
      type: mongoose.Schema.Types.ObjectId,
      // 如果为null，表示对该类型的所有资源授权
      default: null
    },
    // 资源所有者ID
    owner_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    }
  },
  // 允许的操作
  permissions: [{
    type: String,
    enum: ['read', 'write', 'delete', 'execute', 'all'],
    required: true
  }],
  // 访问条件（存储为JSON对象）
  conditions: {
    type: Map,
    of: mongoose.Schema.Types.Mixed,
    default: {}
  },
  // 可访问的敏感度级别（1=高, 2=中, 3=低）
  sensitivity_level_access: {
    type: Number,
    min: 1,
    max: 3,
    default: 3
  },
  // 有效期
  valid_from: {
    type: Date,
    default: Date.now
  },
  valid_until: {
    type: Date,
    // null表示永不过期
    default: null
  },
  // 授权来源
  granted_by: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  // 授权原因
  grant_reason: {
    type: String
  },
  // 是否由用户主动授权
  user_initiated: {
    type: Boolean,
    default: false
  },
  // 授权是否已被撤销
  is_revoked: {
    type: Boolean,
    default: false
  },
  revoked_at: {
    type: Date
  },
  revoked_by: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  revoke_reason: {
    type: String
  },
  // 授权记录
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: { createdAt: 'created_at', updatedAt: 'updated_at' },
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 创建索引
dataAccessControlSchema.index({ 'principal.type': 1, 'principal.id': 1 });
dataAccessControlSchema.index({ 'resource.type': 1, 'resource.id': 1 });
dataAccessControlSchema.index({ 'resource.owner_id': 1 });
dataAccessControlSchema.index({ valid_until: 1 });
dataAccessControlSchema.index({ is_revoked: 1 });
// 添加组合索引，用于权限检查查询
dataAccessControlSchema.index({ 
  'principal.type': 1, 
  'principal.id': 1, 
  'resource.type': 1, 
  is_revoked: 1, 
  valid_from: 1, 
  valid_until: 1 
});
// 添加敏感度级别索引，用于按敏感度过滤
dataAccessControlSchema.index({ sensitivity_level_access: 1 });
// 添加创建时间索引，用于审计和清理
dataAccessControlSchema.index({ created_at: -1 });

// 添加复合索引以优化常见查询
dataAccessControlSchema.index({ 
  'resource.owner_id': 1,
  'resource.type': 1, 
  is_revoked: 1
});

// 添加时间范围和授权查询的复合索引
dataAccessControlSchema.index({ 
  valid_from: 1,
  valid_until: 1, 
  granted_by: 1
});

// 添加虚拟字段
dataAccessControlSchema.virtual('is_valid').get(function() {
  return this.isValid();
});

dataAccessControlSchema.virtual('days_until_expiry').get(function() {
  if (!this.valid_until) return null;
  
  const now = new Date();
  const diffTime = this.valid_until - now;
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  
  return diffDays > 0 ? diffDays : 0;
});

dataAccessControlSchema.virtual('principal_name').get(function() {
  // 需要填充数据才能使用
  if (this.populated('principal.id')) {
    const principal = this.populated('principal.id');
    
    if (this.principal.type === 'user' && principal) {
      return principal.full_name || principal.username || principal.email;
    } else if (this.principal.type === 'role' && principal) {
      return principal.name;
    } else if (this.principal.type === 'application' && principal) {
      return principal.name;
    }
  }
  
  return `${this.principal.type}-${this.principal.id}`;
});

dataAccessControlSchema.virtual('resource_name').get(function() {
  // 需要填充数据才能使用
  if (this.populated('resource.id')) {
    const resource = this.populated('resource.id');
    if (resource && resource.name) {
      return resource.name;
    }
  }
  
  return `${this.resource.type}-${this.resource.id || 'all'}`;
});

// 检查特定权限
dataAccessControlSchema.methods.hasPermission = function(permission) {
  return this.permissions.includes(permission) || this.permissions.includes('all');
};

// 更新前中间件 - 取消timestamps，使用自定义逻辑
dataAccessControlSchema.pre('save', function(next) {
  // 更新时间由timestamps处理
  
  // 添加额外的验证逻辑
  if (this.is_revoked && !this.revoked_at) {
    this.revoked_at = new Date();
  }
  
  // 确保permissions不包含重复项
  if (this.permissions && Array.isArray(this.permissions)) {
    this.permissions = [...new Set(this.permissions)];
    
    // 如果包含'all'，移除其他权限
    if (this.permissions.includes('all')) {
      this.permissions = ['all'];
    }
  }
  
  next();
});

// 扩展isValid方法，支持检查特定操作
dataAccessControlSchema.methods.isValidForOperation = function(operation) {
  if (!this.isValid()) return false;
  return this.hasPermission(operation);
};

// 检查权限是否过期
dataAccessControlSchema.methods.isExpired = function() {
  const now = new Date();
  return this.valid_until && this.valid_until <= now;
};

// 撤销权限
dataAccessControlSchema.methods.revoke = async function(revokedBy, reason) {
  if (this.is_revoked) return false;
  
  this.is_revoked = true;
  this.revoked_at = new Date();
  this.revoked_by = revokedBy;
  this.revoke_reason = reason;
  
  await this.save();
  
  // 清除相关缓存
  if (global.cacheService) {
    const cacheKey = this.constructor.generateCacheKey(
      this.principal.type, 
      this.principal.id, 
      this.resource.type, 
      this.resource.id
    );
    await global.cacheService.del(cacheKey);
  }
  
  return true;
};

// 扩展权限
dataAccessControlSchema.methods.extendValidity = async function(newValidUntil) {
  if (this.is_revoked || this.isExpired()) return false;
  
  const oldValidUntil = this.valid_until;
  this.valid_until = newValidUntil;
  await this.save();
  
  // 清除相关缓存
  if (global.cacheService) {
    const cacheKey = this.constructor.generateCacheKey(
      this.principal.type, 
      this.principal.id, 
      this.resource.type, 
      this.resource.id
    );
    await global.cacheService.del(cacheKey);
  }
  
  return true;
};

// 更新权限
dataAccessControlSchema.methods.updatePermissions = async function(newPermissions) {
  if (this.is_revoked || this.isExpired()) return false;
  
  this.permissions = newPermissions;
  await this.save();
  
  // 清除相关缓存
  if (global.cacheService) {
    const cacheKey = this.constructor.generateCacheKey(
      this.principal.type, 
      this.principal.id, 
      this.resource.type, 
      this.resource.id
    );
    await global.cacheService.del(cacheKey);
  }
  
  return true;
};

// 生成缓存键
dataAccessControlSchema.statics.generateCacheKey = function(principalType, principalId, resourceType, resourceId) {
  return `access:${principalType}:${principalId}:${resourceType}:${resourceId || 'all'}`;
};

// 静态方法：检查主体是否有对资源的指定操作权限
dataAccessControlSchema.statics.checkAccess = async function(principalType, principalId, resourceType, resourceId, operation, context = {}) {
  // 先尝试从缓存获取
  let hasAccess = false;
  
  if (global.cacheService) {
    const cacheKey = this.generateCacheKey(principalType, principalId, resourceType, resourceId);
    const cachedPermissions = await global.cacheService.get(cacheKey);
    
    if (cachedPermissions) {
      // 检查缓存的权限是否包含请求的操作
      if (cachedPermissions.includes(operation) || cachedPermissions.includes('all')) {
        return true;
      }
      
      // 如果缓存存在但不包含权限，则说明没有权限
      return false;
    }
  }
  
  // 缓存未命中，从数据库查询
  const now = new Date();
  
  // 查找有效的访问控制记录
  const accessControls = await this.find({
    'principal.type': principalType,
    'principal.id': principalId,
    'resource.type': resourceType,
    is_revoked: false,
    valid_from: { $lte: now },
    $or: [
      { valid_until: null },
      { valid_until: { $gt: now } }
    ]
  }).sort({ sensitivity_level_access: 1 }); // 优先使用可访问高敏感级别的权限
  
  if (accessControls.length === 0) return false;
  
  // 检查是否有全局权限或特定资源权限
  const allPermissions = new Set();
  
  hasAccess = accessControls.some(ac => {
    // 收集所有权限
    ac.permissions.forEach(perm => allPermissions.add(perm));
    
    // 检查操作权限
    if (!ac.permissions.includes(operation) && !ac.permissions.includes('all')) {
      return false;
    }
    
    // 检查资源ID是否匹配
    if (resourceId && ac.resource.id && !ac.resource.id.equals(resourceId)) {
      return false;
    }
    
    // 检查条件
    if (ac.conditions.size > 0) {
      for (const [key, value] of ac.conditions.entries()) {
        if (context[key] !== value) return false;
      }
    }
    
    return true;
  });
  
  // 缓存权限结果
  if (global.cacheService) {
    const cacheKey = this.generateCacheKey(principalType, principalId, resourceType, resourceId);
    const permissionsArray = Array.from(allPermissions);
    
    // 权限缓存5分钟
    await global.cacheService.set(cacheKey, permissionsArray, 300);
  }
  
  return hasAccess;
};

// 清除指定主体和资源的权限缓存
dataAccessControlSchema.statics.clearAccessCache = async function(principalType, principalId, resourceType, resourceId) {
  if (global.cacheService) {
    const cacheKey = this.generateCacheKey(principalType, principalId, resourceType, resourceId);
    await global.cacheService.del(cacheKey);
  }
};

// 静态方法：授予临时访问权限
dataAccessControlSchema.statics.grantTemporaryAccess = async function(options) {
  const {
    principalType, principalId, 
    resourceType, resourceId, resourceOwnerId,
    permissions, validUntil, grantedBy, reason, conditions = {}
  } = options;
  
  const accessControl = new this({
    principal: {
      type: principalType,
      id: principalId
    },
    resource: {
      type: resourceType,
      id: resourceId,
      owner_id: resourceOwnerId
    },
    permissions,
    conditions,
    valid_until: validUntil,
    granted_by: grantedBy,
    grant_reason: reason,
    user_initiated: true
  });
  
  const savedAccess = await accessControl.save();
  
  // 清除相关缓存
  await this.clearAccessCache(principalType, principalId, resourceType, resourceId);
  
  return savedAccess;
};

// 静态方法：撤销访问权限
dataAccessControlSchema.statics.revokeAccess = async function(id, revokedBy, reason) {
  const accessControl = await this.findById(id);
  if (!accessControl) return null;
  
  const updatedAccess = await this.findByIdAndUpdate(id, {
    is_revoked: true,
    revoked_at: Date.now(),
    revoked_by: revokedBy,
    revoke_reason: reason,
    updated_at: Date.now()
  }, { new: true });
  
  // 清除相关缓存
  await this.clearAccessCache(
    accessControl.principal.type,
    accessControl.principal.id,
    accessControl.resource.type,
    accessControl.resource.id
  );
  
  return updatedAccess;
};

// 添加静态方法：创建资源的完全访问权限
dataAccessControlSchema.statics.grantFullAccess = async function(principalType, principalId, resourceType, resourceId, grantedBy, options = {}) {
  const { 
    validUntil = null, 
    reason = '授予完全访问权限', 
    userInitiated = false,
    conditions = {},
    sensitivity_level = 1
  } = options;
  
  const accessControl = new this({
    principal: {
      type: principalType,
      id: principalId
    },
    resource: {
      type: resourceType,
      id: resourceId,
      owner_id: options.owner_id
    },
    permissions: ['all'],
    conditions: conditions,
    sensitivity_level_access: sensitivity_level,
    valid_from: new Date(),
    valid_until: validUntil,
    granted_by: grantedBy,
    grant_reason: reason,
    user_initiated: userInitiated
  });
  
  await accessControl.save();
  return accessControl;
};

// 添加静态方法：批量创建访问权限
dataAccessControlSchema.statics.batchGrant = async function(grants) {
  const result = {
    success: [],
    failed: []
  };
  
  for (const grant of grants) {
    try {
      const { 
        principalType, principalId, 
        resourceType, resourceId, 
        permissions, grantedBy, 
        options = {} 
      } = grant;
      
      const accessControl = new this({
        principal: {
          type: principalType,
          id: principalId
        },
        resource: {
          type: resourceType,
          id: resourceId,
          owner_id: options.owner_id
        },
        permissions: permissions,
        conditions: options.conditions || {},
        sensitivity_level_access: options.sensitivity_level || 3,
        valid_from: options.validFrom || new Date(),
        valid_until: options.validUntil || null,
        granted_by: grantedBy,
        grant_reason: options.reason || '批量授权',
        user_initiated: options.userInitiated || false
      });
      
      await accessControl.save();
      result.success.push({
        principal: `${principalType}-${principalId}`,
        resource: `${resourceType}-${resourceId || 'all'}`,
        id: accessControl._id
      });
    } catch (error) {
      result.failed.push({
        principal: `${grant.principalType}-${grant.principalId}`,
        resource: `${grant.resourceType}-${grant.resourceId || 'all'}`,
        error: error.message
      });
    }
  }
  
  return result;
};

// 添加静态方法：查找用户对特定类型资源的所有权限
dataAccessControlSchema.statics.findUserPermissionsForResourceType = async function(userId, resourceType) {
  const now = new Date();
  
  return this.find({
    'principal.type': 'user',
    'principal.id': userId,
    'resource.type': resourceType,
    is_revoked: false,
    valid_from: { $lte: now },
    $or: [
      { valid_until: null },
      { valid_until: { $gt: now } }
    ]
  })
  .sort({ created_at: -1 })
  .populate('resource.id')
  .populate('resource.owner_id', 'username email full_name');
};

// 添加静态方法：查找资源的所有授权
dataAccessControlSchema.statics.findResourcePermissions = async function(resourceType, resourceId) {
  const now = new Date();
  
  return this.find({
    'resource.type': resourceType,
    'resource.id': resourceId,
    is_revoked: false,
    valid_from: { $lte: now },
    $or: [
      { valid_until: null },
      { valid_until: { $gt: now } }
    ]
  })
  .sort({ created_at: -1 })
  .populate('principal.id')
  .populate('granted_by', 'username email full_name');
};

// 添加静态方法：查找用户创建的所有授权
dataAccessControlSchema.statics.findGrantsByUser = async function(userId) {
  return this.find({
    granted_by: userId
  })
  .sort({ created_at: -1 })
  .populate('principal.id')
  .populate('resource.id')
  .populate('resource.owner_id', 'username email full_name');
};

// 添加静态方法：查找即将过期的授权
dataAccessControlSchema.statics.findExpiringGrants = async function(daysThreshold = 7) {
  const now = new Date();
  const thresholdDate = new Date(now.getTime() + (daysThreshold * 24 * 60 * 60 * 1000));
  
  return this.find({
    is_revoked: false,
    valid_until: { 
      $ne: null,
      $gt: now, 
      $lte: thresholdDate 
    }
  })
  .sort({ valid_until: 1 })
  .populate('principal.id')
  .populate('resource.id')
  .populate('granted_by', 'username email full_name');
};

// 添加静态方法：批量取消授权
dataAccessControlSchema.statics.batchRevoke = async function(grantIds, revokedBy, reason = '批量撤销') {
  const result = {
    success: [],
    failed: []
  };
  
  for (const grantId of grantIds) {
    try {
      const grant = await this.findById(grantId);
      if (!grant) {
        result.failed.push({
          id: grantId,
          error: '未找到授权记录'
        });
        continue;
      }
      
      if (grant.is_revoked) {
        result.failed.push({
          id: grantId,
          error: '授权记录已被撤销'
        });
        continue;
      }
      
      const success = await grant.revoke(revokedBy, reason);
      if (success) {
        result.success.push({
          id: grantId,
          principal: `${grant.principal.type}-${grant.principal.id}`,
          resource: `${grant.resource.type}-${grant.resource.id || 'all'}`
        });
      } else {
        result.failed.push({
          id: grantId,
          error: '撤销失败'
        });
      }
    } catch (error) {
      result.failed.push({
        id: grantId,
        error: error.message
      });
    }
  }
  
  return result;
};

// 添加静态方法：清理过期的权限记录（不删除，只标记为撤销）
dataAccessControlSchema.statics.cleanupExpiredGrants = async function() {
  const now = new Date();
  
  const expiredGrants = await this.find({
    is_revoked: false,
    valid_until: { $ne: null, $lt: now }
  });
  
  let revokedCount = 0;
  for (const grant of expiredGrants) {
    await grant.revoke(null, '自动撤销：授权已过期');
    revokedCount++;
  }
  
  return { revokedCount };
};

// 添加静态方法：验证针对资源的多项操作权限
dataAccessControlSchema.statics.validateMultipleOperations = async function(principalType, principalId, operations = []) {
  /*
  operations格式：[
    { resourceType: 'user_profile', resourceId: '123', operation: 'read' },
    { resourceType: 'order', resourceId: '456', operation: 'write' }
  ]
  */
  
  const results = [];
  
  for (const op of operations) {
    const { resourceType, resourceId, operation, context = {} } = op;
    const hasAccess = await this.checkAccess(
      principalType,
      principalId,
      resourceType,
      resourceId,
      operation,
      context
    );
    
    results.push({
      resourceType,
      resourceId,
      operation,
      hasAccess
    });
  }
  
  return results;
};

// 使用ModelFactory创建支持读写分离的数据访问控制模型
const DataAccessControl = ModelFactory.model('DataAccessControl', dataAccessControlSchema);

// 添加分片支持的保存方法
const originalSave = DataAccessControl.prototype.save;
DataAccessControl.prototype.save = async function(options) {
  if (shardingService.config && shardingService.config.enabled && 
      shardingService.config.strategies.DataAccessControl) {
    // 数据访问控制根据主体ID分片
    const shardKey = this.principal.id.toString();
    const shardCollection = shardingService.getShardName('DataAccessControl', shardKey);
    console.log(`将数据访问控制保存到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = DataAccessControl; 