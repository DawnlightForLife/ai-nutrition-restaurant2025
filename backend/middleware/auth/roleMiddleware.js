/**
 * ✅ 命名风格统一（camelCase）
 * ✅ 返回结构统一为 { success, message }
 * ✅ 支持单角色或多角色判断
 * ✅ 用户角色通过 req.user.role 提取
 * ✅ 建议 future: 支持多角色账户（如 req.user.roles 为数组）
 * ✅ 建议 future: 接入 RBAC 模型 + 动态角色权限缓存
 */

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
      
      // NOTE: current implementation assumes single role per user
      // TODO: 若未来用户支持多角色（req.user.roles = []），此处应改为 some() 判断
      
      // 检查用户是否具有所需角色
      const roles = Array.isArray(requiredRoles) ? requiredRoles : [requiredRoles];
      
      if (!roles.includes(userRole)) {
        return res.status(403).json({
          success: false,
          message: '权限不足，需要更高级别的角色'
        });
      }
      
      // 用户具有所需角色，继续处理
      next();
    } catch (error) {
      console.error('角色验证错误:', error);
      // TODO: 可记录角色验证失败日志（用户ID + 请求路径 + 时间）
      res.status(500).json({
        success: false,
        message: '服务器错误'
      });
    }
  };
};

module.exports = requireRole;