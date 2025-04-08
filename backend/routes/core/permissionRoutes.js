const express = require('express');
const router = express.Router();
const { createPermission, getPermissionList, getPermissionById, updatePermission, deletePermission } = require('../../controllers/core/permissionController');

/**
 * 权限相关路由
 */

// 创建权限
router.post('/', createPermission);

// 获取权限列表
router.get('/', getPermissionList);

// 获取单个权限详情
router.get('/:id', getPermissionById);

// 更新权限
router.put('/:id', updatePermission);

// 删除权限
router.delete('/:id', deletePermission);

module.exports = router;