const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3001;

// 中间件
app.use(cors());
app.use(express.json());

// 模拟验证码存储（实际应用应使用Redis等）
const codeStore = new Map();

// 健康检查
app.get('/api/ping', (req, res) => {
  res.json({
    success: true,
    message: 'pong',
    timestamp: new Date().toISOString()
  });
});

// 发送验证码接口
app.post('/api/auth/send-code', (req, res) => {
  console.log('收到发送验证码请求:', req.body);
  const { phone } = req.body;
  
  if (!phone) {
    return res.status(400).json({
      success: false,
      message: '手机号不能为空'
    });
  }
  
  // 生成6位验证码
  const code = Math.floor(100000 + Math.random() * 900000).toString();
  
  // 存储验证码（5分钟有效期）
  codeStore.set(phone, {
    code,
    expiry: Date.now() + 5 * 60 * 1000
  });
  
  console.log(`为手机号 ${phone} 生成验证码: ${code}`);
  
  res.json({
    success: true,
    message: '验证码已发送'
  });
});

// 验证码登录接口
app.post('/api/auth/login-with-code', (req, res) => {
  console.log('收到验证码登录请求:', req.body);
  const { phone, code } = req.body;
  
  if (!phone || !code) {
    return res.status(400).json({
      success: false,
      message: '手机号和验证码不能为空'
    });
  }
  
  const storedData = codeStore.get(phone);
  
  if (!storedData) {
    return res.status(400).json({
      success: false,
      message: '验证码不存在或已过期'
    });
  }
  
  if (Date.now() > storedData.expiry) {
    codeStore.delete(phone);
    return res.status(400).json({
      success: false,
      message: '验证码已过期'
    });
  }
  
  if (storedData.code !== code) {
    return res.status(400).json({
      success: false,
      message: '验证码错误'
    });
  }
  
  // 验证成功，删除验证码
  codeStore.delete(phone);
  
  // 模拟用户数据
  const user = {
    userId: 'user_' + Date.now(),
    phone: phone,
    username: `用户${phone.slice(-4)}`,
    nickname: `元气用户${phone.slice(-4)}`,
    role: 'customer',
    profileCompleted: Math.random() > 0.5, // 随机决定是否需要完善资料
    autoRegistered: true,
    userType: 'customer'
  };
  
  const token = 'mock_token_' + Date.now();
  
  console.log(`用户 ${phone} 登录成功`);
  
  res.json({
    success: true,
    message: '登录成功',
    token: token,
    user: user
  });
});

// 密码登录接口
app.post('/api/auth/login', (req, res) => {
  console.log('收到密码登录请求:', req.body);
  const { phone, password } = req.body;
  
  if (!phone || !password) {
    return res.status(400).json({
      success: false,
      message: '手机号和密码不能为空'
    });
  }
  
  // 简单的模拟验证
  if (password === '123456') {
    const user = {
      userId: 'user_' + Date.now(),
      phone: phone,
      username: `用户${phone.slice(-4)}`,
      nickname: `元气用户${phone.slice(-4)}`,
      role: 'customer',
      profileCompleted: true,
      autoRegistered: false,
      userType: 'customer'
    };
    
    const token = 'mock_token_' + Date.now();
    
    console.log(`用户 ${phone} 密码登录成功`);
    
    res.json({
      success: true,
      message: '登录成功',
      token: token,
      user: user
    });
  } else {
    res.status(400).json({
      success: false,
      message: '密码错误'
    });
  }
});

// 验证Token
app.get('/api/auth/verify-token', (req, res) => {
  const token = req.headers.authorization?.split(' ')[1];
  
  if (!token || !token.startsWith('mock_token_')) {
    return res.status(401).json({
      success: false,
      message: 'Token无效'
    });
  }
  
  res.json({
    success: true,
    message: 'Token有效'
  });
});

// 启动服务器
app.listen(PORT, '0.0.0.0', () => {
  console.log(`模拟后端服务器运行在 http://0.0.0.0:${PORT}`);
  console.log(`健康检查: http://localhost:${PORT}/api/ping`);
  console.log('支持的接口:');
  console.log('- POST /api/auth/send-code');
  console.log('- POST /api/auth/login-with-code');
  console.log('- POST /api/auth/login');
  console.log('- GET /api/auth/verify-token');
});