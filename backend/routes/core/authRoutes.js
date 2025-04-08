/**
 * 认证相关路由
 * 处理用户认证过程中的各种请求，如注册、登录、密码重置等
 * @module routes/core/authRoutes
 */
const express = require('express');
const router = express.Router();
const { 
  createAuth, 
  login, 
  sendVerificationCode, 
  updateAuth, 
  verifyToken 
} = require('../../controllers/core/authController');

// 用户注册
router.post('/register', createAuth);

// 用户登录
router.post('/login', login);

// 发送验证码
router.post('/send-code', sendVerificationCode);

// 重置密码
router.post('/reset-password', updateAuth);

// 验证令牌
router.get('/verify-token', verifyToken);

module.exports = router; 