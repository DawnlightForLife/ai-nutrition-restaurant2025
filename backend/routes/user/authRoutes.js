/**
 * 认证相关路由
 * 处理用户认证过程中的请求，如登录、验证码、token校验等（已取消注册接口）
 * @module routes/core/authRoutes
 */
const express = require('express');
const router = express.Router();
const { 
  createAuth, 
  login, 
  loginWithCode,
  loginWithCodeLegacy,
  sendVerificationCode, 
  updateAuth, 
  verifyToken 
} = require('../../controllers/user/authController');

// [POST] 用户登录（账号+密码）
router.post('/login', login);

// [POST] 验证码登录（标准路径）
router.post('/login-with-code', loginWithCode);

// [POST] 验证码登录（兼容旧版路径）
router.post('/login/code', loginWithCodeLegacy);

// [POST] 发送验证码
router.post('/send-code', sendVerificationCode);

// [POST] 重置密码
router.post('/reset-password', updateAuth);

// [GET] 校验 token 是否有效
router.get('/verify-token', verifyToken);

module.exports = router;