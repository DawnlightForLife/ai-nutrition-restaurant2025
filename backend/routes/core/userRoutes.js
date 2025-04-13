const express = require('express');
const router = express.Router();
const { createUser, getUserList, getUserById, updateUser, deleteUser } = require('../../controllers/core/userController');
const authMiddleware = require('../../middleware/auth/authMiddleware');

/**
 * 用户相关路由
 */

// 创建用户
router.post('/', createUser);

// 获取用户列表
router.get('/', getUserList);

// 获取用户信息 (当前登录用户)
router.get('/profile', authMiddleware.authenticate, (req, res) => {
  // 从认证中间件中获取用户ID
  const userId = req.user.id;
  
  // 重定向到获取单个用户详情的处理函数
  req.params.id = userId;
  getUserById(req, res);
});

// 更新用户信息 (当前登录用户)
router.put('/profile', authMiddleware.authenticate, (req, res) => {
  // 从认证中间件中获取用户ID
  const userId = req.user.id;
  
  // 重定向到更新用户的处理函数
  req.params.id = userId;
  updateUser(req, res);
});

// 获取单个用户详情
router.get('/:id', getUserById);

// 更新用户
router.put('/:id', updateUser);

// 删除用户
router.delete('/:id', deleteUser);

module.exports = router; 