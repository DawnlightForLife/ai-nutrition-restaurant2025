/**
 * ✅ 命名风格统一（camelCase）
 * ✅ 返回结构统一为 { success, message }
 * ✅ 支持单角色或多角色判断
 * ✅ 用户角色通过 req.user.role 提取
 * ✅ 建议 future: 支持多角色账户（如 req.user.roles 为数组）
 * ✅ 建议 future: 接入 RBAC 模型 + 动态角色权限缓存
 */

const { hasRolePermission } = require('../../config/permissions');

/**
 * 角色验证中间件
 * 用于检查用户是否具有特定角色
 * @param {string|string[]} requiredRoles - 需要的角色名称或角色列表
 * @returns {Function} Express中间件函数
 */
const requireRole = (requiredRoles) => {
  return (req, res, next) => {
    try {
      // 确保用户已通过身份验证
      if (!req.user) {
        return res.status(401).json({
          success: false,
          message: '需要身份验证'
        });
      }

      // 获取用户角色
      const userRole = req.user.role;
      
      if (!userRole) {
        return res.status(403).json({
          success: false,
          message: '用户没有分配角色'
        });
      }
      
      // 使用新的权限检查系统
      if (!hasRolePermission(userRole, requiredRoles)) {
        return res.status(403).json({
          success: false,
          message: `权限不足，需要以下角色之一: ${Array.isArray(requiredRoles) ? requiredRoles.join(', ') : requiredRoles}`
        });
      }
      
      // 用户具有所需角色，继续处理
      next();
    } catch (error) {
      console.error('角色验证错误:', error);
      res.status(500).json({
        success: false,
        message: '服务器错误'
      });
    }
  };
};

module.exports = requireRole;