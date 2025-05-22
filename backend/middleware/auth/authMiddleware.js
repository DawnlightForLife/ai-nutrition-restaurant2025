/**
 * ✅ 命名风格统一（camelCase）
 * ✅ 支持普通用户身份验证与管理员权限控制
 * ✅ 所有返回结构统一为 { success, message, ... }
 * ✅ 使用 JWT 进行身份验证
 * ✅ 已兼容 userId 字段（为 decoded.id 设置 userId 别名）
 */

const jwt = require('jsonwebtoken');
require('dotenv').config();

// JWT密钥，从环境变量获取
const JWT_SECRET = process.env.JWT_SECRET || 'smart_nutrition_restaurant_secret';

/**
 * 身份验证中间件
 * 用于保护需要登录访问的接口
 * 验证并解析JWT令牌，将用户信息附加到请求对象
 */
// NOTE: authenticateUser 可用于任何需要身份验证的接口
const authenticateUser = (req, res, next) => {
  console.log('[AUTH DEBUG] 开始处理令牌验证');
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
    
    // 将用户信息附加到请求对象，并确保id字段可以被正确读取
    console.log('[AUTH DEBUG] 令牌验证成功，用户ID:', decoded.id);
    req.user = {
      ...decoded,
      // 确保兼容前端期望的userId字段
      userId: decoded.id
    };
    
    // 继续下一步处理
    next();
  } catch (error) {
    console.error('[AUTH ERROR] 令牌验证失败:', error.name, error.message);
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ success: false, message: '令牌已过期，请重新登录' });
    } else if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({ success: false, message: '无效的令牌签名' });
    }
    return res.status(401).json({ success: false, message: '无效的身份验证令牌' });
  }
};

// 兼容性别名
const authenticate = authenticateUser;

/**
 * 管理员权限验证中间件
 * 用于保护需要管理员权限的接口
 * 先进行身份验证，然后检查用户是否有管理员角色
 */
// NOTE: requireAdmin 中嵌套调用 authenticateUser，确保身份再检查管理员权限
const requireAdmin = (req, res, next) => {
  // 先验证用户是否已登录
  authenticateUser(req, res, () => {
    // 检查用户是否是管理员
    if (req.user && (req.user.role === 'admin' || req.user.isAdmin)) {
      next();
    } else {
      return res.status(403).json({ 
        success: false, 
        message: '需要管理员权限' 
      });
    }
  });
};

// TODO: 支持刷新令牌机制（Refresh Token）
// TODO: 增加用户状态检查（如 isActive）防止封禁用户访问
// TODO: 可集成日志记录（如验证失败原因）

module.exports = { 
  authenticateUser,
  authenticate,
  requireAdmin
}; 