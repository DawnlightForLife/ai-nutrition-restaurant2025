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
const WechatMiniprogramController = require('../../controllers/user/wechatMiniprogramController');
const { authenticate } = require('../../middleware/auth/authMiddleware');

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

// [POST] 微信小程序登录
router.post('/wechat-miniprogram', WechatMiniprogramController.login);

// [POST] 微信手机号快速登录
router.post('/wechat-phone-login', WechatMiniprogramController.phoneLogin);

// [POST] 绑定手机号
router.post('/bind-phone', authenticate, WechatMiniprogramController.bindPhone);

// [GET] 获取当前用户信息
router.get('/me', authenticate, async (req, res) => {
  try {
    const userId = req.user.id || req.user.userId;
    
    // 从数据库中获取最新的用户信息
    const User = require('../../models/user/userModel');
    const user = await User.findById(userId);
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: '用户不存在'
      });
    }
    
    // 返回最新的用户信息
    res.json({
      success: true,
      user: {
        id: user._id,
        userId: user._id,
        phone: user.phone,
        role: user.role,
        nickname: user.nickname,
        avatarUrl: user.avatarUrl,  // 修复：使用一致的字段名 avatarUrl
        ...req.user // 保留token中的其他信息如iat, exp
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: '获取用户信息失败',
      error: error.message
    });
  }
});

module.exports = router;