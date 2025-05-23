/**
 * 授权中间件
 * 用于检查用户是否具有特定角色或权限
 * 提供两个主要功能：
 * 1. authorize(roles) - 检查用户是否具有特定角色
 * 2. checkPermission(permissions) - 检查用户是否具有特定权限
 * @module middleware/security/authorizationMiddleware
 */

const { AppError } = require('../../utils/errors/appError');
const logger = require('../../utils/logger/winstonLogger');
const { userRoleService } = require('../../services');

/**
 * 角色授权中间件
 * 检查用户是否具有特定角色
 * @param {string|string[]} roles - 需要的角色名称或角色列表
 * @returns {Function} Express中间件函数
 */
const authorize = (roles) => {
  // 确保参数始终为数组
  const requiredRoles = Array.isArray(roles) ? roles : [roles];

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

      // 特殊角色：超级管理员总是有所有权限
      if (userRole === 'superadmin') {
        return next();
      }
      
      // 检查用户是否具有所需角色
      if (!requiredRoles.includes(userRole)) {
        logger.warn(`授权失败 - 用户ID: ${req.user.id}, 角色: ${userRole}, 需要角色: ${requiredRoles.join(', ')}`);
        return res.status(403).json({
          success: false,
          message: '权限不足，需要更高级别的角色'
        });
      }
      
      // 用户具有所需角色，继续处理
      next();
    } catch (error) {
      logger.error('角色授权错误:', { error, userId: req.user?.id, path: req.originalUrl });
      return res.status(500).json({
        success: false,
        message: '服务器错误'
      });
    }
  };
};

/**
 * 权限检查中间件
 * 检查用户是否具有特定权限
 * @param {string|string[]} permissions - 需要的权限名称或权限列表
 * @returns {Function} Express中间件函数
 */
const checkPermission = (permissions) => {
  // 确保参数始终为数组
  const requiredPermissions = Array.isArray(permissions) ? permissions : [permissions];

  return async (req, res, next) => {
    try {
      // 确保用户已通过身份验证
      if (!req.user) {
        return res.status(401).json({
          success: false,
          message: '需要身份验证'
        });
      }

      const userId = req.user.id;
      const userRole = req.user.role;
      
      // 特殊角色：超级管理员总是有所有权限
      if (userRole === 'superadmin') {
        return next();
      }
      
      // 使用角色服务获取用户权限
      const userPermissions = await userRoleService.getUserPermissions(userId);
      
      // 验证用户是否拥有所需的所有权限
      const hasAllPermissions = requiredPermissions.every(permission => 
        userPermissions.includes(permission)
      );
      
      if (!hasAllPermissions) {
        logger.warn(`权限检查失败 - 用户ID: ${userId}, 角色: ${userRole}, 需要权限: ${requiredPermissions.join(', ')}`);
        return res.status(403).json({
          success: false,
          message: '权限不足，无法执行此操作'
        });
      }
      
      // 用户具有所需权限，继续处理
      next();
    } catch (error) {
      logger.error('权限检查错误:', { error, userId: req.user?.id, path: req.originalUrl });
      return res.status(500).json({
        success: false,
        message: '服务器错误'
      });
    }
  };
};

/**
 * 资源所有者验证中间件
 * 检查请求者是否为资源所有者
 * @param {Function} getResourceOwnerIdFn - 从请求中获取资源所有者ID的函数
 * @returns {Function} Express中间件函数
 */
const checkResourceOwner = (getResourceOwnerIdFn) => {
  return async (req, res, next) => {
    try {
      // 确保用户已通过身份验证
      if (!req.user) {
        return res.status(401).json({
          success: false,
          message: '需要身份验证'
        });
      }

      const userId = req.user.id;
      const userRole = req.user.role;
      
      // 特殊角色：管理员和超级管理员可以访问所有资源
      if (userRole === 'admin' || userRole === 'superadmin') {
        return next();
      }
      
      // 获取资源所有者ID
      const ownerId = await getResourceOwnerIdFn(req);
      
      // 验证用户是否为资源所有者
      if (ownerId && ownerId.toString() === userId.toString()) {
        return next();
      }
      
      logger.warn(`资源所有者验证失败 - 用户ID: ${userId}, 资源所有者ID: ${ownerId}`);
      return res.status(403).json({
        success: false,
        message: '权限不足，您不是此资源的所有者'
      });
    } catch (error) {
      logger.error('资源所有者验证错误:', { error, userId: req.user?.id, path: req.originalUrl });
      return res.status(500).json({
        success: false,
        message: '服务器错误'
      });
    }
  };
};

module.exports = {
  authorize,
  checkPermission,
  checkResourceOwner
}; 