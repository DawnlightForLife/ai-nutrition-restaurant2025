const express = require('express');
const router = express.Router();
const { createAdmin, getAdminList, getAdminById, updateAdmin, deleteAdmin } = require('../../controllers/core/adminController');

/**
 * 管理员相关路由
 */

// 创建管理员
router.post('/', createAdmin);

// 获取管理员列表
router.get('/', getAdminList);

// 获取单个管理员详情
router.get('/:id', getAdminById);

// 更新管理员
router.put('/:id', updateAdmin);

// 删除管理员
router.delete('/:id', deleteAdmin);

module.exports = router; 