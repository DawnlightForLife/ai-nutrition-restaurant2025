/**
 * ✅ 命名风格统一（camelCase）
 * ✅ 中间件函数返回标准结构 { success, message }
 * ✅ 支持传入单个权限字符串或权限数组
 * ✅ 用户权限通过 req.user.permissions 提取
 * ✅ 建议 future: 支持 RBAC 权限等级与动态权限同步机制
 */

/**
 * 权限校验中间件
 * @param {string|string[]} requiredPermissions - 单个权限或权限数组
 * @returns {Function} Express 中间件函数
 * 
 * 示例：
 * router.get('/admin', permissionMiddleware(['admin:read', 'admin:write']), handler)
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
        // TODO: 后续可将权限验证失败记录至审计日志系统
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