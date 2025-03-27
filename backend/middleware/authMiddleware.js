const jwt = require('jsonwebtoken');
require('dotenv').config();

// JWT密钥，从环境变量获取
const JWT_SECRET = process.env.JWT_SECRET || 'smart_nutrition_restaurant_secret';

const authMiddleware = (req, res, next) => {
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
    
    // 将用户信息附加到请求对象
    console.log('[AUTH DEBUG] 令牌验证成功，用户ID:', decoded.userId);
    req.user = decoded;
    
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

module.exports = authMiddleware; 