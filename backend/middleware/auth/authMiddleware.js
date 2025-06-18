/**
 * 增强的身份验证中间件
 * ✅ 命名风格统一（camelCase）
 * ✅ 支持普通用户身份验证与管理员权限控制
 * ✅ 所有返回结构统一为 { success, message, ... }
 * ✅ 使用 JWT 进行身份验证
 * ✅ 自动从数据库获取用户信息和权限
 * ✅ 支持权限缓存提升性能
 */

const jwt = require('jsonwebtoken');
const permissionCacheService = require('../../services/permissions/permissionCacheService');
require('dotenv').config();

// JWT密钥，从环境变量获取
const JWT_SECRET = process.env.JWT_SECRET || 'smart_nutrition_restaurant_secret';

// 懒加载模型避免循环依赖
let User, UserPermission;

/**
 * 增强的身份验证中间件
 * 用于保护需要登录访问的接口
 * 验证JWT令牌，从数据库获取用户信息和权限
 * 支持权限缓存提升性能
 */
const authenticateUser = async (req, res, next) => {
  console.log('[AUTH DEBUG] 开始处理令牌验证');
  
  // 懒加载模型
  if (!User) {
    try {
      User = require('../../models/user/userModel');
      UserPermission = require('../../models/user/userPermissionModel');
    } catch (error) {
      console.error('[AUTH ERROR] 模型加载失败:', error);
      return res.status(500).json({ success: false, message: '服务器内部错误' });
    }
  }
  
  // 从请求头获取token
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    console.log('[AUTH ERROR] 未提供Authorization头或格式不正确:', authHeader);
    return res.status(401).json({ success: false, message: '未提供身份验证令牌' });
  }
  
  // 获取JWT令牌
  const token = authHeader.split(' ')[1];
  console.log('[AUTH DEBUG] 提取到令牌，长度:', token.length);
  
  try {
    // 验证令牌
    console.log('[AUTH DEBUG] 使用密钥验证令牌:', JWT_SECRET.substring(0, 3) + '...');
    const decoded = jwt.verify(token, JWT_SECRET);
    
    console.log('[AUTH DEBUG] 令牌验证成功，用户ID:', decoded.id);
    
    // 从数据库获取用户完整信息
    const user = await User.findById(decoded.id)
      .select('-password -verification.code -reset_code') // 排除敏感信息
      .lean();
    
    if (!user) {
      console.log('[AUTH ERROR] 用户不存在:', decoded.id);
      return res.status(401).json({ success: false, message: '用户不存在' });
    }
    
    // 检查用户状态
    if (user.accountStatus !== 'active') {
      console.log('[AUTH ERROR] 用户已被停用:', decoded.id, '状态:', user.accountStatus);
      return res.status(401).json({ success: false, message: '账户已被停用' });
    }
    
    // 获取用户特殊权限
    const userSpecialPermissions = await UserPermission.getUserPermissions(user._id);
    
    // 使用缓存服务获取合并后的权限
    const allPermissions = permissionCacheService.getUserPermissions(
      user._id.toString(),
      user.role,
      userSpecialPermissions
    );
    
    // 将用户信息和权限附加到请求对象
    req.user = {
      _id: user._id,
      id: user._id, // 保持向后兼容
      userId: user._id, // 保持向后兼容
      phone: user.phone,
      email: user.email,
      nickname: user.nickname,
      realName: user.realName,
      role: user.role,
      franchiseStoreId: user.franchiseStoreId,
      managedStores: user.managedStores,
      permissions: allPermissions,
      isActive: user.accountStatus === 'active',
      accountStatus: user.accountStatus,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt
    };
    
    console.log('[AUTH DEBUG] 用户信息和权限设置完成，角色:', user.role, '权限数量:', allPermissions.length);
    
    // 继续下一步处理
    next();
  } catch (error) {
    console.error('[AUTH ERROR] 令牌验证失败:', error.name, error.message);
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ success: false, message: '令牌已过期，请重新登录' });
    } else if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({ success: false, message: '无效的令牌签名' });
    } else if (error.name === 'CastError') {
      return res.status(401).json({ success: false, message: '无效的用户ID' });
    }
    return res.status(401).json({ success: false, message: '身份验证失败' });
  }
};

// 兼容性别名
const authenticate = authenticateUser;
const requireAuth = authenticateUser; // 添加兼容性别名，用于路由中的requireAuth调用

/**
 * 管理员权限验证中间件
 * 用于保护需要管理员权限的接口
 * 先进行身份验证，然后检查用户是否有管理员角色
 */
// NOTE: requireAdmin 中嵌套调用 authenticateUser，确保身份再检查管理员权限
const requireAdmin = (req, res, next) => {
  // 先验证用户是否已登录
  authenticateUser(req, res, () => {
    // 检查用户是否是管理员（包括多种管理员角色）
    const adminRoles = ['admin', 'super_admin', 'area_manager'];
    if (req.user && (adminRoles.includes(req.user.role) || req.user.isAdmin)) {
      console.log('[AUTH DEBUG] 管理员权限验证通过, 用户角色:', req.user.role);
      next();
    } else {
      console.log('[AUTH ERROR] 管理员权限验证失败, 用户角色:', req.user.role);
      return res.status(403).json({ 
        success: false, 
        message: '需要管理员权限' 
      });
    }
  });
};

// 兼容性别名
const isAdmin = requireAdmin; // 添加兼容性别名，用于路由中的isAdmin调用

// TODO: 支持刷新令牌机制（Refresh Token）
// TODO: 增加用户状态检查（如 isActive）防止封禁用户访问
// TODO: 可集成日志记录（如验证失败原因）

module.exports = { 
  authenticateUser,
  authenticate,
  requireAdmin,
  requireAuth,  // 导出requireAuth别名
  isAdmin       // 导出isAdmin别名
}; 