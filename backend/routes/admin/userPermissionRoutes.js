const express = require('express');
const router = express.Router();
const userPermissionController = require('../../controllers/admin/userPermissionController');
const authMiddleware = require('../../middleware/auth');
const roleMiddleware = require('../../middleware/auth/roleMiddleware');

// 所有路由都需要管理员权限
router.use(authMiddleware);
router.use(roleMiddleware(['admin', 'super_admin']));

// 获取已授权用户列表
router.get('/authorized', userPermissionController.getAuthorizedUsers);

// 搜索用户
router.get('/search', userPermissionController.searchUsers);

// 获取权限历史记录
router.get('/history', userPermissionController.getPermissionHistory);

// 获取用户权限历史记录
router.get('/:userId/history', userPermissionController.getUserPermissionHistory);

// 授权用户
router.post('/:userId/permissions', userPermissionController.grantPermission);

// 撤销权限
router.delete('/:userId/permissions/:permissionType', userPermissionController.revokePermission);

module.exports = router;