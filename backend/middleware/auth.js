/****
 * ✅ 模块名：auth.js（认证中间件统一入口）
 * ✅ 命名风格统一（camelCase）
 * ✅ 功能概览：
 *   - 兼容旧版导入方式：auth() 返回 authenticateUser 中间件
 *   - 集中导出所有认证相关中间件（auth、authorize、checkPermission）
 * ✅ 模块组成：
 *   - ./auth/authMiddleware → 用户身份认证（JWT）
 *   - ./auth/roleMiddleware → 角色校验（如 admin、merchant 等）
 *   - ./auth/permissionMiddleware → 权限校验（基于 RBAC）
 * ✅ 向后兼容：
 *   - 支持 const { auth } = require('middleware/auth') 老版本用法
 */

const authMiddleware = require('./auth/authMiddleware');
const roleMiddleware = require('./auth/roleMiddleware');
const permissionMiddleware = require('./auth/permissionMiddleware');

// 向后兼容中间件引用方式，返回 authenticateUser 函数
const auth = () => {
  return authMiddleware.authenticateUser;
};

// 导出统一认证相关中间件集合
module.exports = {
  auth,
  authorize: roleMiddleware,
  checkPermission: permissionMiddleware
};