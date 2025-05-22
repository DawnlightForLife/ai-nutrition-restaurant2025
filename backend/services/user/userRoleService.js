/**
 * 用户角色服务模块（userRoleService）
 * 预留用户多角色系统逻辑扩展，例如切换、授权、校验、默认角色判断等
 * 可扩展支持：营养师 / 商家 / 管理员 / 普通用户等复合身份逻辑
 * 当前为空结构，后续可由 authProvider / routeGuard 等模块调用
 * @module services/core/userRoleService
 */

const UserRole = require('../../models/user/userRoleModel');

const userRoleService = {
  /**
   * 获取用户的所有角色
   * @param {String} userId
   * @returns {Promise<Array<String>>}
   */
  async getUserRoles(userId) {
    // TODO: 查询 userRoleModel 获取角色列表
    return [];
  },

  /**
   * 判断用户是否具备某个角色
   * @param {String} userId
   * @param {String} role
   * @returns {Promise<Boolean>}
   */
  async hasRole(userId, role) {
    // TODO: 判断用户是否有指定角色
    return false;
  },

  /**
   * 设置用户当前激活角色
   * @param {String} userId
   * @param {String} role
   * @returns {Promise<void>}
   */
  async setActiveRole(userId, role) {
    // TODO: 更新当前激活角色字段
  },

  /**
   * 获取用户当前激活角色
   * @param {String} userId
   * @returns {Promise<String>}
   */
  async getActiveRole(userId) {
    // TODO: 返回当前激活角色
    return 'user';
  }
};

module.exports = userRoleService; 