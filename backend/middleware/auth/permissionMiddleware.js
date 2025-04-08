/**
 * 权限控制中间件
 * 用于检查用户是否具有执行特定操作的权限
 * @param {string|string[]} requiredPermissions - 需要的权限名称或权限列表
 * @returns {Function} Express中间件函数
 */
const permissionMiddleware = (requiredPermissions) => {
  return (req, res, next) => {
    try {
      // 确保用户已通过身份验证
      if (!req.user) {
        return res.status(401).json({
          success: false,
          message: '需要身份验证'
        });
      }

      // 获取用户权限列表
      const userPermissions = req.user.permissions || [];
      
      // 检查是否具有所需权限
      const permissions = Array.isArray(requiredPermissions) 
        ? requiredPermissions 
        : [requiredPermissions];
      
      const hasPermission = permissions.every(permission => 
        userPermissions.includes(permission)
      );
      
      if (!hasPermission) {
        return res.status(403).json({
          success: false,
          message: '权限不足，无法执行此操作'
        });
      }
      
      // 用户具有所需权限，继续处理
      next();
    } catch (error) {
      console.error('权限验证错误:', error);
      res.status(500).json({
        success: false,
        message: '服务器错误'
      });
    }
  };
};

module.exports = permissionMiddleware; 