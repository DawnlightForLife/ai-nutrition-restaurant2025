const jwt = require('jsonwebtoken');

/**
 * 验证JWT令牌的中间件
 */
const authenticateToken = (req, res, next) => {
  try {
    // 从请求头获取token
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    
    if (!token) {
      return res.status(401).json({
        success: false,
        message: '未提供访问令牌'
      });
    }
    
    // 验证token
    jwt.verify(token, process.env.JWT_SECRET || 'your_secret_key_here', (err, user) => {
      if (err) {
        return res.status(403).json({
          success: false,
          message: '访问令牌无效或已过期'
        });
      }
      
      // 将用户信息添加到请求对象
      req.user = user;
      next();
    });
  } catch (error) {
    console.error('Token验证错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

module.exports = {
  authenticateToken
}; 