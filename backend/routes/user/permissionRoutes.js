/**
 * 权限管理路由模块
 * 提供权限的创建、查询、更新与删除接口
 * @module routes/user/permissionRoutes
 */

const express = require('express')
const router = express.Router();
const { createPermission, getPermissionList, getPermissionById, updatePermission, deletePermission } = require('../../controllers/user/permissionController');

// [POST] 创建权限
router.post('/', createPermission);

// [GET] 获取权限列表
router.get('/', getPermissionList);

// [GET] 获取单个权限详情
router.get('/:id', getPermissionById);

// [PUT] 更新权限
router.put('/:id', updatePermission);

// [DELETE] 删除权限
router.delete('/:id', deletePermission);

module.exports = router;