/**
 * 权限缓存服务
 * 提供用户权限信息的缓存和管理
 */

const NodeCache = require('node-cache');
const { getRolePermissions } = require('../../constants/permissions');

class PermissionCacheService {
  constructor() {
    // 创建权限缓存实例，5分钟过期
    this.cache = new NodeCache({
      stdTTL: 300, // 5分钟
      checkperiod: 60, // 每60秒检查过期项
      useClones: false
    });
    
    console.log('🔒 权限缓存服务已初始化');
  }

  /**
   * 生成用户权限缓存键
   * @param {string} userId - 用户ID
   * @returns {string} 缓存键
   */
  _getUserPermissionKey(userId) {
    return `user_permissions:${userId}`;
  }

  /**
   * 生成角色权限缓存键
   * @param {string} role - 角色名称
   * @returns {string} 缓存键
   */
  _getRolePermissionKey(role) {
    return `role_permissions:${role}`;
  }

  /**
   * 获取用户权限（优先从缓存）
   * @param {string} userId - 用户ID
   * @param {string} role - 用户角色
   * @param {Array} specialPermissions - 用户特殊权限
   * @returns {Array} 用户权限列表
   */
  getUserPermissions(userId, role, specialPermissions = []) {
    const cacheKey = this._getUserPermissionKey(userId);
    
    // 尝试从缓存获取
    let permissions = this.cache.get(cacheKey);
    
    if (!permissions) {
      // 缓存未命中，重新计算
      const rolePermissions = this.getRolePermissions(role);
      permissions = [...new Set([...rolePermissions, ...specialPermissions])];
      
      // 存入缓存
      this.cache.set(cacheKey, permissions);
      
      console.log(`🔒 用户权限已缓存: ${userId}, 权限数量: ${permissions.length}`);
    }
    
    return permissions;
  }

  /**
   * 获取角色权限（优先从缓存）
   * @param {string} role - 角色名称
   * @returns {Array} 角色权限列表
   */
  getRolePermissions(role) {
    const cacheKey = this._getRolePermissionKey(role);
    
    // 尝试从缓存获取
    let permissions = this.cache.get(cacheKey);
    
    if (!permissions) {
      // 缓存未命中，从配置获取
      permissions = getRolePermissions(role);
      
      // 存入缓存（角色权限缓存时间较长）
      this.cache.set(cacheKey, permissions, 3600); // 1小时
      
      console.log(`🔒 角色权限已缓存: ${role}, 权限数量: ${permissions.length}`);
    }
    
    return permissions;
  }

  /**
   * 清除用户权限缓存
   * @param {string} userId - 用户ID
   */
  clearUserPermissions(userId) {
    const cacheKey = this._getUserPermissionKey(userId);
    this.cache.del(cacheKey);
    console.log(`🗑️ 已清除用户权限缓存: ${userId}`);
  }

  /**
   * 清除角色权限缓存
   * @param {string} role - 角色名称
   */
  clearRolePermissions(role) {
    const cacheKey = this._getRolePermissionKey(role);
    this.cache.del(cacheKey);
    console.log(`🗑️ 已清除角色权限缓存: ${role}`);
  }

  /**
   * 批量清除用户权限缓存
   * @param {Array} userIds - 用户ID列表
   */
  clearMultipleUserPermissions(userIds) {
    const keys = userIds.map(userId => this._getUserPermissionKey(userId));
    this.cache.del(keys);
    console.log(`🗑️ 已批量清除用户权限缓存: ${userIds.length} 个用户`);
  }

  /**
   * 清除所有权限缓存
   */
  clearAllPermissions() {
    this.cache.flushAll();
    console.log('🗑️ 已清除所有权限缓存');
  }

  /**
   * 预热权限缓存
   * @param {Array} commonRoles - 常用角色列表
   */
  preloadPermissions(commonRoles = ['customer', 'store_manager', 'store_staff', 'nutritionist']) {
    console.log('🔥 开始预热权限缓存...');
    
    commonRoles.forEach(role => {
      this.getRolePermissions(role);
    });
    
    console.log(`🔥 权限缓存预热完成，已缓存 ${commonRoles.length} 个角色`);
  }

  /**
   * 获取缓存统计信息
   * @returns {Object} 缓存统计
   */
  getCacheStats() {
    const stats = this.cache.getStats();
    return {
      keys: stats.keys,
      hits: stats.hits,
      misses: stats.misses,
      hitRate: stats.hits / (stats.hits + stats.misses) || 0,
      ksize: stats.ksize,
      vsize: stats.vsize
    };
  }

  /**
   * 检查权限（带缓存）
   * @param {string} userId - 用户ID
   * @param {string} role - 用户角色
   * @param {Array} specialPermissions - 特殊权限
   * @param {string|Array} requiredPermissions - 需要的权限
   * @returns {boolean} 是否有权限
   */
  hasPermission(userId, role, specialPermissions, requiredPermissions) {
    const userPermissions = this.getUserPermissions(userId, role, specialPermissions);
    
    if (Array.isArray(requiredPermissions)) {
      return requiredPermissions.every(permission => userPermissions.includes(permission));
    } else {
      return userPermissions.includes(requiredPermissions);
    }
  }

  /**
   * 检查任一权限（带缓存）
   * @param {string} userId - 用户ID
   * @param {string} role - 用户角色
   * @param {Array} specialPermissions - 特殊权限
   * @param {Array} requiredPermissions - 需要的权限列表
   * @returns {boolean} 是否有任一权限
   */
  hasAnyPermission(userId, role, specialPermissions, requiredPermissions) {
    const userPermissions = this.getUserPermissions(userId, role, specialPermissions);
    return requiredPermissions.some(permission => userPermissions.includes(permission));
  }
}

// 创建单例实例
const permissionCacheService = new PermissionCacheService();

// 应用启动时预热缓存
permissionCacheService.preloadPermissions();

module.exports = permissionCacheService;