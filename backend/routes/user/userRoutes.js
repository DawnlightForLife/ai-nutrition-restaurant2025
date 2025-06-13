/**
 * 用户管理路由
 * 包含用户的创建、查询、更新、删除等接口
 * @module routes/core/userRoutes
 */

const express = require('express');
const router = express.Router();
const { createUser, getUserList, getUserById, updateUser, deleteUser } = require('../../controllers/user/userController');
const { checkHasPassword, setPassword, changePassword, resetPassword } = require('../../controllers/user/passwordController');
const authMiddleware = require('../../middleware/auth/authMiddleware');
const { optionalUploadAvatar } = require('../../middleware/upload/uploadMiddleware');

// [POST] 创建用户
router.post('/', createUser);

// [GET] 获取所有用户列表
router.get('/', getUserList);

// [GET] 获取当前登录用户信息
router.get('/profile', authMiddleware.authenticate, (req, res) => {
  const userId = req.user.id;
  req.params.id = userId;
  getUserById(req, res);
});

// [PUT] 更新当前登录用户信息
router.put('/profile', authMiddleware.authenticate, optionalUploadAvatar, (req, res) => {
  const userId = req.user.id;
  req.params.id = userId;
  updateUser(req, res);
});

// 密码管理相关路由
// [GET] 检查用户是否设置了密码
router.get('/has-password', authMiddleware.authenticate, checkHasPassword);

// [POST] 设置密码（新用户首次设置）
router.post('/set-password', authMiddleware.authenticate, setPassword);

// [POST] 修改密码（已有密码的用户）
router.post('/change-password', authMiddleware.authenticate, changePassword);

// [POST] 通过验证码重置密码（无需认证）
router.post('/reset-password', resetPassword);

// [GET] 获取指定 ID 的用户详情
router.get('/:id', getUserById);

// [PUT] 更新指定 ID 的用户信息
router.put('/:id', updateUser);

// [DELETE] 删除指定 ID 的用户
router.delete('/:id', deleteUser);

module.exports = router;