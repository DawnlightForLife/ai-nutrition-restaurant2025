const express = require('express');
const router = express.Router();
const { createAuth, getAuthList, getAuthById, updateAuth, deleteAuth } = require('../../controllers/core/authController');

/**
 * 认证相关路由
 */

// 创建认证信息
router.post('/', createAuth);

// 获取认证信息列表
router.get('/', getAuthList);

// 获取单个认证信息详情
router.get('/:id', getAuthById);

// 更新认证信息
router.put('/:id', updateAuth);

// 删除认证信息
router.delete('/:id', deleteAuth);

module.exports = router; 