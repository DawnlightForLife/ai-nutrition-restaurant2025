const express = require('express');
const router = express.Router();
const { createUser, getUserList, getUserById, updateUser, deleteUser } = require('../../controllers/core/userController');

/**
 * 用户相关路由
 */

// 创建用户
router.post('/', createUser);

// 获取用户列表
router.get('/', getUserList);

// 获取单个用户详情
router.get('/:id', getUserById);

// 更新用户
router.put('/:id', updateUser);

// 删除用户
router.delete('/:id', deleteUser);

module.exports = router; 