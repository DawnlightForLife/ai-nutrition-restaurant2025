/**
 * 权限配置和映射
 * 定义角色与权限的对应关系
 */

// 角色层级定义（数字越大权限越高）
const ROLE_HIERARCHY = {
  'customer': 1,
  'user': 1,
  'store_staff': 2,
  'store_manager': 3,
  'merchant': 3,
  'nutritionist': 3,
  'admin': 4,
  'super_admin': 5
};

// 角色到功能权限的映射
const ROLE_PERMISSIONS = {
  'super_admin': ['*'], // 超级管理员拥有所有权限
  'admin': [
    'merchant:read', 'merchant:write', 'merchant:delete',
    'dish:read', 'dish:write', 'dish:delete',
    'inventory:read', 'inventory:write', 'inventory:delete',
    'order:read', 'order:write', 'order:delete',
    'user:read', 'user:write', 'user:delete',
    'system:config', 'system:monitor'
  ],
  'store_manager': [
    'merchant:read', 'merchant:write', // 商家管理员自动拥有商家权限
    'dish:read', 'dish:write', 'dish:delete',
    'inventory:read', 'inventory:write', 'inventory:delete',
    'order:read', 'order:write', 'order:delete'
  ],
  'merchant': [
    'merchant:read', 'merchant:write', // 商家角色自动拥有商家权限
    'dish:read', 'dish:write', 'dish:delete',
    'inventory:read', 'inventory:write', 'inventory:delete',
    'order:read', 'order:write', 'order:delete'
  ],
  'nutritionist': [
    'nutritionist:read', 'nutritionist:write', // 营养师角色自动拥有营养师权限
    'nutrition:read', 'nutrition:write',
    'consult:read', 'consult:write'
  ],
  'store_staff': [
    'dish:read',
    'inventory:read',
    'order:read', 'order:write'
  ],
  'customer': [
    'order:read'
  ],
  'user': [
    'order:read'
  ]
};

/**
 * 检查角色是否有足够权限
 * @param {string} userRole 用户角色
 * @param {string|Array} requiredRoles 需要的角色
 * @returns {boolean} 是否有权限
 */
function hasRolePermission(userRole, requiredRoles) {
  const roles = Array.isArray(requiredRoles) ? requiredRoles : [requiredRoles];
  
  // 超级管理员拥有所有权限
  if (userRole === 'super_admin') {
    return true;
  }
  
  // 直接角色匹配
  if (roles.includes(userRole)) {
    return true;
  }
  
  // 角色层级检查：高级角色可以访问低级角色的功能
  const userLevel = ROLE_HIERARCHY[userRole] || 0;
  return roles.some(role => {
    const requiredLevel = ROLE_HIERARCHY[role] || 0;
    return userLevel >= requiredLevel;
  });
}

/**
 * 检查功能权限
 * @param {string} userRole 用户角色
 * @param {string} permission 功能权限（如 'dish:write'）
 * @returns {boolean} 是否有权限
 */
function hasFeaturePermission(userRole, permission) {
  const userPermissions = ROLE_PERMISSIONS[userRole] || [];
  
  // 检查是否有通配符权限
  if (userPermissions.includes('*')) {
    return true;
  }
  
  // 检查具体权限
  return userPermissions.includes(permission);
}

/**
 * 获取用户所有权限
 * @param {string} userRole 用户角色
 * @returns {Array} 权限列表
 */
function getUserPermissions(userRole) {
  return ROLE_PERMISSIONS[userRole] || [];
}

module.exports = {
  ROLE_HIERARCHY,
  ROLE_PERMISSIONS,
  hasRolePermission,
  hasFeaturePermission,
  getUserPermissions
};