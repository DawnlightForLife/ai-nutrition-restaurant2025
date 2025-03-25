const jwt = require('jsonwebtoken');

// JWT密钥，实际项目中应该放在环境变量中
const JWT_SECRET = 'smart_nutrition_restaurant_secret';

const authMiddleware = (req, res, next) => {
  // 从请求头获取token
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ success: false, message: '未提供身份验证令牌' });
  }
  
  // 获取JWT令牌
  const token = authHeader.split(' ')[1];
  
  try {
    // 验证令牌
    const decoded = jwt.verify(token, JWT_SECRET);
    
    // 将用户信息附加到请求对象
    req.user = decoded;
    
    // 继续下一步处理
    next();
  } catch (error) {
    console.error('令牌验证失败:', error);
    return res.status(401).json({ success: false, message: '无效的身份验证令牌' });
  }
};

module.exports = authMiddleware; 