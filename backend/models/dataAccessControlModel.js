const mongoose = require('mongoose');
const ModelFactory = require('./modelFactory');
const { shardingService } = require('../services/shardingService');

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

// 更新前自动更新时间
dataAccessControlSchema.pre('save', function(next) {
  this.updated_at = Date.now();
  next();
});

// 检查权限是否有效
dataAccessControlSchema.methods.isValid = function() {
  const now = new Date();
  return !this.is_revoked &&
         this.valid_from <= now &&
         (this.valid_until === null || this.valid_until > now);
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

// 使用ModelFactory创建支持读写分离的模型
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