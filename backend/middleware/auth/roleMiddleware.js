/**
 * 角色验证中间件
 * 用于检查用户是否具有特定角色
 * @param {string|string[]} requiredRoles - 需要的角色名称或角色列表
 * @returns {Function} Express中间件函数
 */
const roleMiddleware = (requiredRoles) => {
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
      res.status(500).json({
        success: false,
        message: '服务器错误'
      });
    }
  };
};

module.exports = roleMiddleware; 