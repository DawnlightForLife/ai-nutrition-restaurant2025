/**
 * 权限常量定义
 * 定义系统中所有可用的权限
 */

// 基础权限
const BASE_PERMISSIONS = {
  // 用户相关
  USER_READ: 'user:read',
  USER_WRITE: 'user:write',
  USER_DELETE: 'user:delete',
  
  // 商家相关
  MERCHANT_READ: 'merchant:read',
  MERCHANT_WRITE: 'merchant:write',
  MERCHANT_DELETE: 'merchant:delete',
  MERCHANT_MANAGE: 'merchant:manage',
  
  // 菜品相关
  DISH_READ: 'dish:read',
  DISH_WRITE: 'dish:write',
  DISH_DELETE: 'dish:delete',
  DISH_MANAGE: 'dish:manage',
  
  // 库存相关
  INVENTORY_READ: 'inventory:read',
  INVENTORY_WRITE: 'inventory:write',
  INVENTORY_DELETE: 'inventory:delete',
  INVENTORY_MANAGE: 'inventory:manage',
  
  // 订单相关
  ORDER_READ: 'order:read',
  ORDER_WRITE: 'order:write',
  ORDER_DELETE: 'order:delete',
  ORDER_MANAGE: 'order:manage',
  
  // 营养师相关
  NUTRITIONIST_READ: 'nutritionist:read',
  NUTRITIONIST_WRITE: 'nutritionist:write',
  NUTRITIONIST_MANAGE: 'nutritionist:manage',
  
  // 咨询相关
  CONSULTATION_READ: 'consultation:read',
  CONSULTATION_WRITE: 'consultation:write',
  CONSULTATION_MANAGE: 'consultation:manage',
  
  // 管理员相关
  ADMIN_READ: 'admin:read',
  ADMIN_WRITE: 'admin:write',
  ADMIN_MANAGE: 'admin:manage',
  
  // 系统相关
  SYSTEM_CONFIG: 'system:config',
  SYSTEM_MONITOR: 'system:monitor',
  SYSTEM_BACKUP: 'system:backup',
  
  // 报表统计
  STATS_VIEW: 'stats:view',
  STATS_EXPORT: 'stats:export',
  
  // 用户权限管理
  PERMISSION_GRANT: 'permission:grant',
  PERMISSION_REVOKE: 'permission:revoke',
  PERMISSION_VIEW: 'permission:view'
};

// 角色权限映射
const ROLE_PERMISSIONS = {
  // 顾客权限
  customer: [
    BASE_PERMISSIONS.USER_READ,
    BASE_PERMISSIONS.MERCHANT_READ,
    BASE_PERMISSIONS.DISH_READ,
    BASE_PERMISSIONS.ORDER_READ,
    BASE_PERMISSIONS.ORDER_WRITE,
    BASE_PERMISSIONS.CONSULTATION_READ,
    BASE_PERMISSIONS.CONSULTATION_WRITE
  ],
  
  // 店长权限
  store_manager: [
    BASE_PERMISSIONS.USER_READ,
    BASE_PERMISSIONS.MERCHANT_READ,
    BASE_PERMISSIONS.MERCHANT_WRITE,
    BASE_PERMISSIONS.MERCHANT_MANAGE,
    BASE_PERMISSIONS.DISH_READ,
    BASE_PERMISSIONS.DISH_WRITE,
    BASE_PERMISSIONS.DISH_DELETE,
    BASE_PERMISSIONS.DISH_MANAGE,
    BASE_PERMISSIONS.INVENTORY_READ,
    BASE_PERMISSIONS.INVENTORY_WRITE,
    BASE_PERMISSIONS.INVENTORY_DELETE,
    BASE_PERMISSIONS.INVENTORY_MANAGE,
    BASE_PERMISSIONS.ORDER_READ,
    BASE_PERMISSIONS.ORDER_WRITE,
    BASE_PERMISSIONS.ORDER_MANAGE,
    BASE_PERMISSIONS.STATS_VIEW,
    BASE_PERMISSIONS.STATS_EXPORT
  ],
  
  // 店员权限
  store_staff: [
    BASE_PERMISSIONS.USER_READ,
    BASE_PERMISSIONS.MERCHANT_READ,
    BASE_PERMISSIONS.DISH_READ,
    BASE_PERMISSIONS.DISH_WRITE,
    BASE_PERMISSIONS.INVENTORY_READ,
    BASE_PERMISSIONS.INVENTORY_WRITE,
    BASE_PERMISSIONS.ORDER_READ,
    BASE_PERMISSIONS.ORDER_WRITE,
    BASE_PERMISSIONS.STATS_VIEW
  ],
  
  // 营养师权限
  nutritionist: [
    BASE_PERMISSIONS.USER_READ,
    BASE_PERMISSIONS.MERCHANT_READ,
    BASE_PERMISSIONS.DISH_READ,
    BASE_PERMISSIONS.NUTRITIONIST_READ,
    BASE_PERMISSIONS.NUTRITIONIST_WRITE,
    BASE_PERMISSIONS.NUTRITIONIST_MANAGE,
    BASE_PERMISSIONS.CONSULTATION_READ,
    BASE_PERMISSIONS.CONSULTATION_WRITE,
    BASE_PERMISSIONS.CONSULTATION_MANAGE,
    BASE_PERMISSIONS.STATS_VIEW
  ],
  
  // 区域经理权限
  area_manager: [
    BASE_PERMISSIONS.USER_READ,
    BASE_PERMISSIONS.MERCHANT_READ,
    BASE_PERMISSIONS.MERCHANT_WRITE,
    BASE_PERMISSIONS.MERCHANT_MANAGE,
    BASE_PERMISSIONS.DISH_READ,
    BASE_PERMISSIONS.DISH_WRITE,
    BASE_PERMISSIONS.DISH_MANAGE,
    BASE_PERMISSIONS.INVENTORY_READ,
    BASE_PERMISSIONS.INVENTORY_MANAGE,
    BASE_PERMISSIONS.ORDER_READ,
    BASE_PERMISSIONS.ORDER_MANAGE,
    BASE_PERMISSIONS.NUTRITIONIST_READ,
    BASE_PERMISSIONS.NUTRITIONIST_MANAGE,
    BASE_PERMISSIONS.STATS_VIEW,
    BASE_PERMISSIONS.STATS_EXPORT,
    BASE_PERMISSIONS.PERMISSION_VIEW
  ],
  
  // 管理员权限
  admin: [
    ...Object.values(BASE_PERMISSIONS).filter(p => !p.includes('system:'))
  ],
  
  // 超级管理员权限
  super_admin: Object.values(BASE_PERMISSIONS),
  
  // 系统权限（用于内部API调用）
  system: Object.values(BASE_PERMISSIONS)
};

// 资源权限映射（用于细粒度控制）
const RESOURCE_PERMISSIONS = {
  // 用户只能操作自己的资源
  own_data: {
    check: (user, resource) => {
      return user._id.toString() === resource.userId?.toString() || 
             user._id.toString() === resource._id?.toString();
    }
  },
  
  // 商家只能操作自己店的资源
  store_data: {
    check: (user, resource) => {
      return user.franchiseStoreId?.toString() === resource.storeId?.toString() ||
             user.franchiseStoreId?.toString() === resource.franchiseStoreId?.toString();
    }
  },
  
  // 区域经理可以操作管理的店铺
  managed_stores: {
    check: (user, resource) => {
      return user.managedStores?.some(storeId => 
        storeId.toString() === resource.storeId?.toString() ||
        storeId.toString() === resource.franchiseStoreId?.toString()
      );
    }
  }
};

// 获取角色权限
const getRolePermissions = (role) => {
  return ROLE_PERMISSIONS[role] || [];
};

// 检查用户是否有特定权限
const hasPermission = (userPermissions, requiredPermission) => {
  return userPermissions.includes(requiredPermission);
};

// 检查用户是否有任一权限
const hasAnyPermission = (userPermissions, requiredPermissions) => {
  return requiredPermissions.some(permission => userPermissions.includes(permission));
};

// 检查用户是否有所有权限
const hasAllPermissions = (userPermissions, requiredPermissions) => {
  return requiredPermissions.every(permission => userPermissions.includes(permission));
};

// 检查资源权限
const checkResourcePermission = (user, resource, permissionType) => {
  const resourcePermission = RESOURCE_PERMISSIONS[permissionType];
  if (!resourcePermission) return true; // 如果没有定义资源权限，默认允许
  
  return resourcePermission.check(user, resource);
};

module.exports = {
  BASE_PERMISSIONS,
  ROLE_PERMISSIONS,
  RESOURCE_PERMISSIONS,
  getRolePermissions,
  hasPermission,
  hasAnyPermission,
  hasAllPermissions,
  checkResourcePermission
};