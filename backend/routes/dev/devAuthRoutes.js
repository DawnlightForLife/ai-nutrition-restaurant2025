/**
 * 开发环境认证路由
 * 仅在开发环境可用，用于快速测试不同角色
 */

const express = require('express');
const router = express.Router();
const User = require('../../models/user/userModel');
const jwt = require('jsonwebtoken');
const config = require('../../config');

// 仅在开发环境启用
if (process.env.NODE_ENV !== 'development') {
  module.exports = router;
  return;
}

/**
 * 快速登录 - 开发环境专用
 * POST /dev/quick-login
 */
router.post('/quick-login', async (req, res) => {
  try {
    const { role = 'store_manager', phone = '18888888888' } = req.body;
    
    // 查找或创建用户
    let user = await User.findOne({ phone });
    
    if (!user) {
      // 创建测试用户
      user = new User({
        phone,
        password: 'hashed_password', // 开发环境不需要真实密码
        role,
        nickname: `测试${role}`,
        profileCompleted: true,
        height: 175,
        weight: 70,
        age: 30,
        gender: 'male',
        activityLevel: 'moderate'
      });
      await user.save();
      console.log(`创建测试用户: ${phone}, 角色: ${role}`);
    } else {
      // 更新角色
      user.role = role;
      await user.save();
      console.log(`更新用户角色: ${phone} -> ${role}`);
    }

    // 生成token
    const token = jwt.sign(
      { 
        id: user._id, // 使用 id 字段保持与 authMiddleware 一致
        userId: user._id,
        role: user.role,
        phone: user.phone
      },
      config.jwt.secret,
      { expiresIn: config.jwt.expiresIn }
    );

    res.json({
      success: true,
      message: `已切换到${role}角色`,
      token,
      user: {
        id: user._id,
        phone: user.phone,
        role: user.role,
        nickname: user.nickname,
        profileCompleted: user.profileCompleted
      }
    });

  } catch (error) {
    console.error('快速登录错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
});

/**
 * 获取可用角色列表
 * GET /dev/roles
 */
router.get('/roles', (req, res) => {
  res.json({
    success: true,
    roles: [
      { value: 'user', label: '普通用户' },
      { value: 'store_manager', label: '门店管理员' },
      { value: 'merchant', label: '商家' },
      { value: 'admin', label: '系统管理员' },
      { value: 'nutritionist', label: '营养师' }
    ]
  });
});

console.log('🔧 开发环境认证路由已加载');

module.exports = router;