const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const ModelFactory = require('../modelFactory');
const cacheManager = require('../../services/cache/cacheManager');
const { evaluateCondition } = require('../../utils/access/conditionEvaluator');
const { shardingService } = require('../../services/database/shardingService');

// 数据访问控制模式定义
const dataAccessControlSchema = new Schema({
  // 访问主体（用户、组、角色等）
  principal: {
    type: {
      type: String,
      required: true,
      enum: ['user', 'group', 'role', 'service', 'system'],
      description: '访问主体类型，如 user、group、role、service、system'
    },
    id: {
      type: Schema.Types.ObjectId,
      required: true,
      refPath: 'principal.type',
      description: '访问主体的唯一标识ID',
      sensitivityLevel: 2
    }
  },
  
  // 访问资源（实体、文档等）
  resource: {
    type: {
      type: String,
      required: true,
      description: '资源类型，如 user_profile、order、document 等'
    },
    id: {
      type: Schema.Types.ObjectId,
      required: false,
      refPath: 'resource.type',
      description: '资源的唯一标识ID',
      sensitivityLevel: 2
    },
    ownerId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: false,
      description: '资源所有者的用户ID'
    }
  },
  
  // 权限列表（读、写、删除等）
  permissions: [{
    type: String,
    required: true,
    description: '权限操作列表，如 read、write、delete 等',
    sensitivityLevel: 3
  }],
  
  // 权限条件（如时间范围、IP限制等）
  conditions: {
    type: Schema.Types.Mixed,
    default: {},
    description: '访问权限附加条件，如时间、IP、地域等'
  },
  
  // 敏感度级别访问（1-最高，5-最低）
  sensitivityLevelAccess: {
    type: Number,
    default: 3,
    min: 1,
    max: 5,
    description: '访问权限的敏感度级别，1为最高，5为最低'
  },
  
  // 权限有效期
  validFrom: {
    type: Date,
    default: Date.now,
    description: '权限授权生效时间'
  },
  validUntil: {
    type: Date,
    default: null,
    description: '权限授权失效时间，null 表示永久有效'
  },
  
  // 授权信息
  grantedBy: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: false,
    description: '授权操作人用户ID'
  },
  grantReason: {
    type: String,
    default: '标准授权',
    description: '授权原因说明'
  },
  userInitiated: {
    type: Boolean,
    default: false,
    description: '是否用户主动发起授权'
  },
  
  // 撤销信息
  isRevoked: {
    type: Boolean,
    default: false,
    description: '权限是否已被撤销'
  },
  revokedAt: {
    type: Date,
    default: null,
    description: '权限撤销时间'
  },
  revokedBy: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    default: null,
    description: '撤销操作人用户ID'
  },
  revokeReason: {
    type: String,
    default: null,
    description: '撤销原因说明'
  },
  
  // 最后访问时间
  lastAccessedAt: {
    type: Date,
    default: null,
    description: '最近一次访问的时间'
  },
  accessCount: {
    type: Number,
    default: 0,
    description: '被访问的累计次数'
  }
}, { timestamps: true });

// 为提高查询性能添加索引
dataAccessControlSchema.index({ 'principal.type': 1, 'principal.id': 1 });
dataAccessControlSchema.index({ 'resource.type': 1, 'resource.id': 1 });
dataAccessControlSchema.index({ isRevoked: 1 });
dataAccessControlSchema.index({ validFrom: 1, validUntil: 1 });

// 复合索引用于权限查询
dataAccessControlSchema.index({
  'principal.type': 1,
  'principal.id': 1,
  'resource.type': 1,
  'resource.id': 1,
  isRevoked: 1
});

// 添加针对有效期的索引
dataAccessControlSchema.index({ validUntil: 1, isRevoked: 1 });

// 缓存设置
const CACHE_TTL = 300; // 缓存有效期5分钟
const ACCESS_CACHE_PREFIX = 'access_control:';

// 虚拟字段：是否有效
dataAccessControlSchema.virtual('isValid').get(function() {
  const now = new Date();
  return (
    !this.isRevoked && 
    this.validFrom <= now && 
    (this.validUntil === null || this.validUntil > now)
  );
});

// 虚拟字段：过期状态
dataAccessControlSchema.virtual('expiryStatus').get(function() {
  if (this.isRevoked) return 'revoked';
  if (!this.validUntil) return 'permanent';
  
  const now = new Date();
  const daysUntilExpiry = (this.validUntil - now) / (1000 * 60 * 60 * 24);
  
  if (daysUntilExpiry < 0) return 'expired';
  if (daysUntilExpiry < 7) return 'expiring_soon';
  return 'active';
});

// 方法：检查指定权限
dataAccessControlSchema.methods.hasPermission = function(permission) {
  return this.permissions.includes(permission) || this.permissions.includes('all');
};

// 方法：检查是否过期
dataAccessControlSchema.methods.isExpired = function() {
  if (this.validUntil === null) return false;
  return new Date() > this.validUntil;
};

// 方法：撤销权限
dataAccessControlSchema.methods.revoke = async function(revokedBy, reason) {
  if (this.isRevoked) return false;
  
  this.isRevoked = true;
  this.revokedAt = new Date();
  this.revokedBy = revokedBy;
  this.revokeReason = reason || '手动撤销';
  
  await this.save();
  
  // 清除相关缓存
  await this.constructor.clearAccessCache(
    this.principal.type,
    this.principal.id,
    this.resource.type,
    this.resource.id
  );
  
  return true;
};

// 方法：延长有效期
dataAccessControlSchema.methods.extendValidity = async function(newValidUntil, updatedBy, reason) {
  if (this.isRevoked) return false;
  
  this.validUntil = newValidUntil;
  this.grantedBy = updatedBy || this.grantedBy;
  this.grantReason = reason || '延长权限有效期';
  
  await this.save();
  
  // 清除相关缓存
  await this.constructor.clearAccessCache(
    this.principal.type,
    this.principal.id,
    this.resource.type,
    this.resource.id
  );
  
  return true;
};

// 方法：记录访问
dataAccessControlSchema.methods.recordAccess = async function() {
  this.lastAccessedAt = new Date();
  this.accessCount += 1;
  await this.save();
};

// 方法：评估条件
dataAccessControlSchema.methods.evaluateConditions = function(context = {}) {
  // 如果没有条件，则通过
  if (!this.conditions || Object.keys(this.conditions).length === 0) {
    return true;
  }
  
  // 评估所有条件
  return evaluateCondition(this.conditions, context);
};

// 静态方法：检查访问权限
dataAccessControlSchema.statics.checkAccess = async function(principalType, principalId, resourceType, resourceId, permission, context = {}) {
  // 首先检查缓存
  const cacheKey = `${ACCESS_CACHE_PREFIX}${principalType}:${principalId}:${resourceType}:${resourceId}:${permission}`;
  const cachedResult = await cacheManager.get(cacheKey);
  
  if (cachedResult !== null) {
    return cachedResult === 'true';
  }
  
  const now = new Date();
  
  // 查找匹配的权限记录
  const accessControls = await this.find({
    'principal.type': principalType,
    'principal.id': principalId,
    'resource.type': resourceType,
    $or: [
      { 'resource.id': resourceId },
      { 'resource.id': null } // 支持通配符资源ID
    ],
    isRevoked: false,
    validFrom: { $lte: now },
    $or: [
      { validUntil: null },
      { validUntil: { $gt: now } }
    ]
  });
  
  // 检查是否有匹配的权限
  let hasAccess = false;
  let matchedControl = null;
  
  for (const control of accessControls) {
    if (control.hasPermission(permission) && control.evaluateConditions(context)) {
      hasAccess = true;
      matchedControl = control;
      break;
    }
  }
  
  // 如果找到匹配的权限记录，记录访问
  if (hasAccess && matchedControl) {
    // 使用非阻塞方式记录访问，不等待完成
    matchedControl.recordAccess().catch(err => console.error('记录访问失败:', err));
  }
  
  // 缓存结果
  await cacheManager.set(cacheKey, hasAccess.toString(), CACHE_TTL);
  
  return hasAccess;
};

// 静态方法：清除访问缓存
dataAccessControlSchema.statics.clearAccessCache = async function(principalType, principalId, resourceType, resourceId) {
  const pattern = `${ACCESS_CACHE_PREFIX}${principalType}:${principalId}:${resourceType}:${resourceId}:*`;
  await cacheManager.deletePattern(pattern);
};

// 静态方法：批量检查权限
dataAccessControlSchema.statics.batchCheckAccess = async function(checks) {
  const results = {};
  
  for (const check of checks) {
    const { principalType, principalId, resourceType, resourceId, permission, context = {} } = check;
    const key = `${principalType}:${principalId}:${resourceType}:${resourceId}:${permission}`;
    
    results[key] = await this.checkAccess(
      principalType,
      principalId,
      resourceType,
      resourceId,
      permission,
      context
    );
  }
  
  return results;
};

// 静态方法：授予临时访问权限
dataAccessControlSchema.statics.grantTemporaryAccess = async function(principalType, principalId, resourceType, resourceId, permissions, durationHours, grantedBy, options = {}) {
  const now = new Date();
  const validUntil = new Date(now.getTime() + (durationHours * 60 * 60 * 1000));
  
  const accessControl = new this({
    principal: {
      type: principalType,
      id: principalId
    },
    resource: {
      type: resourceType,
      id: resourceId,
      ownerId: options.ownerId
    },
    permissions: permissions,
    conditions: options.conditions || {},
    sensitivityLevelAccess: options.sensitivityLevel || 3,
    validFrom: now,
    validUntil: validUntil,
    grantedBy: grantedBy,
    grantReason: options.reason || '临时授权',
    userInitiated: options.userInitiated || false
  });
  
  await accessControl.save();
  return accessControl;
};

// 静态方法：撤销访问权限
dataAccessControlSchema.statics.revokeAccess = async function(id, revokedBy, reason) {
  const accessControl = await this.findById(id);
  if (!accessControl) return null;
  
  const updatedAccess = await this.findByIdAndUpdate(id, {
    isRevoked: true,
    revokedAt: Date.now(),
    revokedBy: revokedBy,
    revokeReason: reason
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
    sensitivityLevel = 1
  } = options;
  
  const accessControl = new this({
    principal: {
      type: principalType,
      id: principalId
    },
    resource: {
      type: resourceType,
      id: resourceId,
      ownerId: options.ownerId
    },
    permissions: ['all'],
    conditions: conditions,
    sensitivityLevelAccess: sensitivityLevel,
    validFrom: new Date(),
    validUntil: validUntil,
    grantedBy: grantedBy,
    grantReason: reason,
    userInitiated: userInitiated
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
          ownerId: options.ownerId
        },
        permissions: permissions,
        conditions: options.conditions || {},
        sensitivityLevelAccess: options.sensitivityLevel || 3,
        validFrom: options.validFrom || new Date(),
        validUntil: options.validUntil || null,
        grantedBy: grantedBy,
        grantReason: options.reason || '批量授权',
        userInitiated: options.userInitiated || false
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
    isRevoked: false,
    validFrom: { $lte: now },
    $or: [
      { validUntil: null },
      { validUntil: { $gt: now } }
    ]
  })
  .sort({ createdAt: -1 })
  .populate('resource.id')
  .populate('resource.ownerId', 'username email full_name');
};

// 添加静态方法：查找资源的所有授权
dataAccessControlSchema.statics.findResourcePermissions = async function(resourceType, resourceId) {
  const now = new Date();
  
  return this.find({
    'resource.type': resourceType,
    'resource.id': resourceId,
    isRevoked: false,
    validFrom: { $lte: now },
    $or: [
      { validUntil: null },
      { validUntil: { $gt: now } }
    ]
  })
  .sort({ createdAt: -1 })
  .populate('principal.id')
  .populate('grantedBy', 'username email full_name');
};

// 添加静态方法：查找用户创建的所有授权
dataAccessControlSchema.statics.findGrantsByUser = async function(userId) {
  return this.find({
    grantedBy: userId
  })
  .sort({ createdAt: -1 })
  .populate('principal.id')
  .populate('resource.id')
  .populate('resource.ownerId', 'username email full_name');
};

// 添加静态方法：查找即将过期的授权
dataAccessControlSchema.statics.findExpiringGrants = async function(daysThreshold = 7) {
  const now = new Date();
  const thresholdDate = new Date(now.getTime() + (daysThreshold * 24 * 60 * 60 * 1000));
  
  return this.find({
    isRevoked: false,
    validUntil: { 
      $ne: null,
      $gt: now, 
      $lte: thresholdDate 
    }
  })
  .sort({ validUntil: 1 })
  .populate('principal.id')
  .populate('resource.id')
  .populate('grantedBy', 'username email full_name');
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
      
      if (grant.isRevoked) {
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
    isRevoked: false,
    validUntil: { $ne: null, $lt: now }
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
const DataAccessControl = ModelFactory.createModel('DataAccessControl', dataAccessControlSchema);

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