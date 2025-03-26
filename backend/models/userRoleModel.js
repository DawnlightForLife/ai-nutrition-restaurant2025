const mongoose = require('mongoose');
const ModelFactory = require('./modelFactory');
const { shardingService } = require('../services/shardingService');

const userRoleSchema = new mongoose.Schema({
  role_name: {
    type: String,
    required: true,
    unique: true,
    enum: ['user', 'nutritionist', 'merchant', 'admin', 'super_admin', 'guest', 'content_manager', 'customer_service']
  },
  description: {
    type: String,
    required: true
  },
  permissions: [{
    type: String,
    enum: [
      // 用户资源操作权限
      'view_user_basic', 'view_user_sensitive', 'view_user_critical',
      'edit_user_basic', 'edit_user_sensitive', 'edit_user_critical',
      
      // 健康数据操作权限
      'view_health_data', 'create_health_data', 'edit_health_data', 'delete_health_data',
      
      // 营养档案操作权限
      'view_nutrition_profile', 'create_nutrition_profile', 'edit_nutrition_profile', 'delete_nutrition_profile',
      
      // 订单操作权限
      'view_orders', 'create_order', 'edit_order', 'delete_order', 'cancel_order',
      'process_order', 'complete_order',
      
      // 营养师相关权限
      'apply_nutritionist', 'provide_nutrition_consultation', 'review_ai_recommendation',
      
      // 商家相关权限
      'apply_merchant', 'manage_dishes', 'manage_inventory', 'view_sales_data',
      'manage_store',
      
      // 管理员专用权限
      'approve_verify_nutritionist', 'approve_verify_merchant', 'manage_users',
      'manage_content', 'view_system_stats', 'config_system',
      
      // 社区权限
      'create_post', 'edit_own_post', 'edit_any_post', 'delete_own_post', 'delete_any_post',
      'comment_post', 'edit_own_comment', 'edit_any_comment', 'delete_own_comment', 'delete_any_comment',
      
      // 支付相关
      'process_payment', 'process_refund', 'view_payment_stats',
      
      // 消息和通知
      'send_notification', 'manage_notification_templates',
      
      // 系统API访问权限
      'access_api_basic', 'access_api_advanced', 'access_api_admin'
    ]
  }],
  // 角色访问的数据敏感级别
  data_access_levels: {
    type: Number,
    min: 1,
    max: 3,
    default: 3,
    description: "1=可访问高敏感数据, 2=可访问中敏感数据, 3=仅可访问低敏感数据"
  },
  // 是否为系统内置角色
  is_system_role: {
    type: Boolean,
    default: false
  },
  // 创建和更新时间
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  },
  // 角色创建者（非系统角色才有）
  created_by: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Admin'
  }
});

// 创建索引
userRoleSchema.index({ role_name: 1 }, { unique: true });
userRoleSchema.index({ is_system_role: 1 });
userRoleSchema.index({ data_access_levels: 1 });
userRoleSchema.index({ created_at: -1 });

// 更新前自动更新时间
userRoleSchema.pre('save', function(next) {
  this.updated_at = Date.now();
  next();
});

// 静态方法：检查权限
userRoleSchema.statics.hasPermission = async function(roleName, permission) {
  const role = await this.findOne({ role_name: roleName });
  if (!role) return false;
  return role.permissions.includes(permission);
};

// 实例方法：检查是否拥有某权限
userRoleSchema.methods.hasPermission = function(permission) {
  return this.permissions.includes(permission);
};

// 静态方法：创建基本系统角色
userRoleSchema.statics.createDefaultRoles = async function() {
  const roles = [
    {
      role_name: 'user',
      description: '普通用户',
      permissions: [
        'view_user_basic', 'edit_user_basic',
        'view_health_data', 'create_health_data', 'edit_health_data',
        'view_nutrition_profile', 'create_nutrition_profile', 'edit_nutrition_profile', 'delete_nutrition_profile',
        'view_orders', 'create_order', 'cancel_order',
        'apply_nutritionist', 'apply_merchant',
        'create_post', 'edit_own_post', 'delete_own_post',
        'comment_post', 'edit_own_comment', 'delete_own_comment'
      ],
      data_access_levels: 3,
      is_system_role: true
    },
    {
      role_name: 'nutritionist',
      description: '营养师',
      permissions: [
        'view_user_basic', 'view_health_data',
        'view_nutrition_profile', 'provide_nutrition_consultation',
        'review_ai_recommendation',
        'create_post', 'edit_own_post', 'delete_own_post',
        'comment_post', 'edit_own_comment', 'delete_own_comment'
      ],
      data_access_levels: 2,
      is_system_role: true
    },
    {
      role_name: 'merchant',
      description: '商家',
      permissions: [
        'view_user_basic',
        'manage_dishes', 'manage_inventory', 'view_sales_data',
        'manage_store', 'process_order', 'complete_order',
        'create_post', 'edit_own_post', 'delete_own_post',
        'comment_post', 'edit_own_comment', 'delete_own_comment'
      ],
      data_access_levels: 3,
      is_system_role: true
    },
    {
      role_name: 'admin',
      description: '系统管理员',
      permissions: [
        'view_user_basic', 'view_user_sensitive',
        'edit_user_basic', 'approve_verify_nutritionist', 'approve_verify_merchant',
        'manage_users', 'manage_content', 'view_system_stats', 'process_refund',
        'send_notification', 'manage_notification_templates',
        'delete_any_post', 'delete_any_comment',
        'access_api_basic', 'access_api_advanced'
      ],
      data_access_levels: 2,
      is_system_role: true
    },
    {
      role_name: 'super_admin',
      description: '超级管理员',
      permissions: [
        'view_user_basic', 'view_user_sensitive', 'view_user_critical',
        'edit_user_basic', 'edit_user_sensitive', 'edit_user_critical',
        'view_health_data', 'edit_health_data', 'delete_health_data',
        'approve_verify_nutritionist', 'approve_verify_merchant',
        'manage_users', 'manage_content', 'view_system_stats', 'config_system',
        'process_payment', 'process_refund', 'view_payment_stats',
        'send_notification', 'manage_notification_templates',
        'edit_any_post', 'delete_any_post', 'edit_any_comment', 'delete_any_comment',
        'access_api_basic', 'access_api_advanced', 'access_api_admin'
      ],
      data_access_levels: 1,
      is_system_role: true
    }
  ];

  for (const role of roles) {
    await this.findOneAndUpdate(
      { role_name: role.role_name },
      role,
      { upsert: true, new: true, setDefaultsOnInsert: true }
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
    const role = await this.findOne({ role_name: roleName });
    
    if (role) {
      // 设置缓存，10分钟过期
      await global.cacheService.set(cacheKey, role.toObject(), 600);
    }
    
    return role;
  } else {
    // 没有缓存服务，直接查询数据库
    return this.findOne({ role_name: roleName });
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