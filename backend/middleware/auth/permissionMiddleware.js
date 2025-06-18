/**
 * 增强的权限校验中间件
 * 支持基于角色的权限控制(RBAC)和资源级权限控制
 * ✅ 命名风格统一（camelCase）
 * ✅ 中间件函数返回标准结构 { success, message }
 * ✅ 支持传入单个权限字符串或权限数组
 * ✅ 支持资源权限检查和动态权限计算
 */

const { 
  getRolePermissions, 
  hasPermission, 
  hasAnyPermission, 
  hasAllPermissions,
  checkResourcePermission 
} = require('../../constants/permissions');
const permissionCacheService = require('../../services/permissions/permissionCacheService');
const { auditLogger } = require('../security/auditMiddleware');

/**
 * 基础权限校验中间件
 * @param {string|string[]} requiredPermissions - 单个权限或权限数组
 * @param {object} options - 配置选项
 * @param {string} options.mode - 权限检查模式: 'all'(需要所有权限) 或 'any'(需要任一权限)
 * @param {string} options.resourceType - 资源类型，用于资源权限检查
 * @returns {Function} Express 中间件函数
 * 
 * 示例：
 * router.get('/admin', permissionMiddleware(['admin:read', 'admin:write']), handler)
 * router.get('/dishes', permissionMiddleware('dish:read', { resourceType: 'store_data' }), handler)
 */
const permissionMiddleware = (requiredPermissions, options = {}) => {
  return (req, res, next) => {
    try {
      // 确保用户已通过身份验证
      if (!req.user) {
        return res.status(401).json({
          success: false,
          message: '需要身份验证'
        });
      }

      // 使用缓存服务获取用户权限
      const allPermissions = permissionCacheService.getUserPermissions(
        req.user._id.toString(),
        req.user.role,
        req.user.permissions || []
      );
      
      // 检查是否具有所需权限
      const permissions = Array.isArray(requiredPermissions) 
        ? requiredPermissions 
        : [requiredPermissions];
      
      const { mode = 'all' } = options;
      
      let hasRequiredPermission = false;
      if (mode === 'any') {
        hasRequiredPermission = hasAnyPermission(allPermissions, permissions);
      } else {
        hasRequiredPermission = hasAllPermissions(allPermissions, permissions);
      }
      
      if (!hasRequiredPermission) {
        // 记录权限验证失败（用于审计）
        console.warn(`权限验证失败 - 用户: ${req.user._id}, 角色: ${req.user.role}, 需要权限: ${permissions.join(',')}, 用户权限: ${allPermissions.join(',')}`);
        
        // 异步记录审计日志
        setImmediate(() => {
          auditLogger.logPermissionDenied(req, permissions, allPermissions);
        });
        
        return res.status(403).json({
          success: false,
          message: '权限不足，无法执行此操作',
          code: 'INSUFFICIENT_PERMISSIONS',
          requiredPermissions: permissions
        });
      }
      
      // 将计算后的权限附加到请求对象，供后续使用
      req.userPermissions = allPermissions;
      
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

/**
 * 资源权限校验中间件
 * 用于检查用户是否有权访问特定资源
 * @param {string} resourceType - 资源权限类型
 * @param {function} resourceExtractor - 从请求中提取资源的函数
 * @returns {Function} Express 中间件函数
 */
const resourcePermissionMiddleware = (resourceType, resourceExtractor) => {
  return async (req, res, next) => {
    try {
      if (!req.user) {
        return res.status(401).json({
          success: false,
          message: '需要身份验证'
        });
      }

      // 提取资源信息
      let resource;
      if (typeof resourceExtractor === 'function') {
        resource = await resourceExtractor(req);
      } else {
        // 默认从请求参数中提取
        resource = { 
          userId: req.params.userId || req.body.userId,
          storeId: req.params.storeId || req.body.storeId,
          franchiseStoreId: req.params.franchiseStoreId || req.body.franchiseStoreId
        };
      }

      // 检查资源权限
      const hasResourcePermission = checkResourcePermission(req.user, resource, resourceType);
      
      if (!hasResourcePermission) {
        console.warn(`资源权限验证失败 - 用户: ${req.user._id}, 资源类型: ${resourceType}, 资源: ${JSON.stringify(resource)}`);
        
        return res.status(403).json({
          success: false,
          message: '无权访问此资源',
          code: 'RESOURCE_ACCESS_DENIED'
        });
      }
      
      next();
    } catch (error) {
      console.error('资源权限验证错误:', error);
      res.status(500).json({
        success: false,
        message: '服务器错误'
      });
    }
  };
};

module.exports = {
  permissionMiddleware,
  resourcePermissionMiddleware
}; 