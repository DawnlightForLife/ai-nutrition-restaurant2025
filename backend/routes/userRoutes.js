const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const { 
  loginUser, 
  registerUser, 
  getUserProfile, 
  updateUserInfo,
  updateHealthInfo,
  updateRegionAndPreferences
} = require('../controllers/userController');

const { authenticateToken } = require('../middleware/auth');

// 登录
router.post('/login', loginUser);

// 注册
router.post('/register', registerUser);

// 获取用户资料
router.get('/profile', authenticateToken, getUserProfile);

// 更新用户信息
router.put('/profile', authenticateToken, updateUserInfo);

// 更新健康信息
router.put('/health-info', authenticateToken, updateHealthInfo);

// 更新地区和饮食偏好
router.put('/preferences', authenticateToken, updateRegionAndPreferences);

module.exports = router;
