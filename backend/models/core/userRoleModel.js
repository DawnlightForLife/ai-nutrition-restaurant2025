const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/shardingService');

const userRoleSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  description: {
    type: String,
    required: true
  },
  permissions: [{
    resource: {
      type: String,
      required: true,
      enum: [
        'users', 'profiles', 'health_data', 'orders', 
        'merchants', 'nutritionists', 'dishes', 'recommendations',
        'subscriptions', 'payments', 'reviews', 'consultations',
        'forum_posts', 'notifications', 'reports', 'settings'
      ]
    },
    actions: [{
      type: String,
      required: true,
      enum: ['create', 'read', 'update', 'delete', 'manage']
    }]
  }],
  is_system_role: {
    type: Boolean,
    default: false
  },
  is_active: {
    type: Boolean,
    default: true
  },
  priority: {
    type: Number,
    default: 0
  },
  created_by: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Admin'
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 添加索引
userRoleSchema.index({ name: 1 }, { unique: true });
userRoleSchema.index({ is_system_role: 1 });
userRoleSchema.index({ is_active: 1 });
userRoleSchema.index({ priority: 1 });

// 实例方法
userRoleSchema.methods.hasPermission = function(resource, action) {
  // 查找给定资源的权限
  const resourcePermission = this.permissions.find(p => p.resource === resource);
  if (!resourcePermission) return false;
  
  // 检查该资源是否有指定的操作权限
  return resourcePermission.actions.includes(action) || resourcePermission.actions.includes('manage');
};

userRoleSchema.methods.addPermission = function(resource, actions) {
  // 确保actions是数组
  if (!Array.isArray(actions)) {
    actions = [actions];
  }
  
  // 查找该资源是否已有权限
  const existingPermission = this.permissions.find(p => p.resource === resource);
  
  if (existingPermission) {
    // 合并并去重新的操作权限
    const uniqueActions = new Set([...existingPermission.actions, ...actions]);
    existingPermission.actions = Array.from(uniqueActions);
  } else {
    // 添加新的资源权限
    this.permissions.push({
      resource,
      actions
    });
  }
};

userRoleSchema.methods.removePermission = function(resource, actions) {
  // 查找该资源的权限
  const resourceIndex = this.permissions.findIndex(p => p.resource === resource);
  if (resourceIndex === -1) return;
  
  // 如果未指定actions，则删除整个资源权限
  if (!actions) {
    this.permissions.splice(resourceIndex, 1);
    return;
  }
  
  // 确保actions是数组
  if (!Array.isArray(actions)) {
    actions = [actions];
  }
  
  // 过滤掉指定的操作权限
  this.permissions[resourceIndex].actions = this.permissions[resourceIndex].actions
    .filter(action => !actions.includes(action));
    
  // 如果没有操作权限了，则删除整个资源权限
  if (this.permissions[resourceIndex].actions.length === 0) {
    this.permissions.splice(resourceIndex, 1);
  }
};

// 静态方法
userRoleSchema.statics.findByName = function(name) {
  return this.findOne({ name });
};

userRoleSchema.statics.findSystemRoles = function() {
  return this.find({ is_system_role: true, is_active: true });
};

userRoleSchema.statics.findCustomRoles = function() {
  return this.find({ is_system_role: false, is_active: true });
};

// 为常见角色创建初始化方法
userRoleSchema.statics.initializeDefaultRoles = async function() {
  const defaultRoles = [
    {
      name: 'admin',
      description: '系统管理员，拥有全部权限',
      permissions: [
        {
          resource: 'users',
          actions: ['create', 'read', 'update', 'delete', 'manage']
        },
        {
          resource: 'merchants',
          actions: ['create', 'read', 'update', 'delete', 'manage']
        },
        // ... 其他所有资源权限
      ],
      is_system_role: true,
      priority: 100
    },
    {
      name: 'user',
      description: '普通用户，基本权限',
      permissions: [
        {
          resource: 'profiles',
          actions: ['create', 'read', 'update', 'delete']
        },
        {
          resource: 'health_data',
          actions: ['create', 'read', 'update', 'delete']
        },
        {
          resource: 'orders',
          actions: ['create', 'read', 'update']
        },
        {
          resource: 'forum_posts',
          actions: ['create', 'read', 'update', 'delete']
        }
      ],
      is_system_role: true,
      priority: 10
    },
    {
      name: 'nutritionist',
      description: '营养师，专业服务权限',
      permissions: [
        {
          resource: 'consultations',
          actions: ['create', 'read', 'update']
        },
        {
          resource: 'recommendations',
          actions: ['create', 'read', 'update']
        },
        {
          resource: 'health_data',
          actions: ['read']
        }
      ],
      is_system_role: true,
      priority: 30
    },
    {
      name: 'merchant',
      description: '商家，商品和订单管理权限',
      permissions: [
        {
          resource: 'dishes',
          actions: ['create', 'read', 'update', 'delete']
        },
        {
          resource: 'orders',
          actions: ['read', 'update']
        },
        {
          resource: 'reviews',
          actions: ['read', 'update']
        }
      ],
      is_system_role: true,
      priority: 20
    }
  ];
  
  // 批量插入或更新默认角色
  for (const role of defaultRoles) {
    await this.findOneAndUpdate(
      { name: role.name },
      role,
      { upsert: true, new: true }
    );
  }
};

// 使用ModelFactory创建支持读写分离的模型
const UserRole = ModelFactory.model('UserRole', userRoleSchema);

// 由于角色数据量少且重要，不进行分片，但可以加入缓存
// 添加角色缓存支持
UserRole.getWithCache = async function(roleName) {
  if (global.cacheService) {
    // 尝试从缓存获取
    const cacheKey = `role:${roleName}`;
    const cachedRole = await global.cacheService.get(cacheKey);
    
    if (cachedRole) {
      return cachedRole;
    }
    
    // 缓存未命中，从数据库获取
    const role = await this.findOne({ name: roleName });
    
    if (role) {
      // 设置缓存，10分钟过期
      await global.cacheService.set(cacheKey, role.toObject(), 600);
    }
    
    return role;
  } else {
    // 没有缓存服务，直接查询数据库
    return this.findOne({ name: roleName });
  }
};

// 清除角色缓存
UserRole.clearCache = async function(roleName) {
  if (global.cacheService) {
    const cacheKey = `role:${roleName}`;
    await global.cacheService.del(cacheKey);
  }
};

module.exports = UserRole; 