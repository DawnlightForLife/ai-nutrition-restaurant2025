/**
 * 管理员管理路由模块
 * 提供创建、查询、更新、删除管理员账户的接口
 */

const express = require('express');
const router = express.Router();
const { createAdmin, getAdminList, getAdminById, updateAdmin, deleteAdmin } = require('../../controllers/user/adminController');

// [POST] 创建管理员
router.post('/', createAdmin);

// [GET] 获取管理员列表
router.get('/', getAdminList);

// [GET] 获取指定 ID 的管理员详情
router.get('/:id', getAdminById);

// [PUT] 更新指定 ID 的管理员信息
router.put('/:id', updateAdmin);

// [DELETE] 删除指定 ID 的管理员
router.delete('/:id', deleteAdmin);

module.exports = router;