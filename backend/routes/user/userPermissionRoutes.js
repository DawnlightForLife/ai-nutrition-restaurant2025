const express = require('express');
const router = express.Router();
const userPermissionController = require('../../controllers/user/userPermissionController');
const { authenticateUser } = require('../../middleware/auth/authMiddleware');
const requireRole = require('../../middleware/auth/roleMiddleware');

// ========== 用户权限相关路由 ==========

/**
 * @swagger
 * /api/user-permissions/apply:
 *   post:
 *     summary: 申请权限
 *     tags: [UserPermissions]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - permissionType
 *               - reason
 *             properties:
 *               permissionType:
 *                 type: string
 *                 enum: [merchant, nutritionist]
 *                 description: 权限类型
 *               reason:
 *                 type: string
 *                 description: 申请原因
 *               contactInfo:
 *                 type: object
 *                 properties:
 *                   phone:
 *                     type: string
 *                   email:
 *                     type: string
 *                   wechat:
 *                     type: string
 *               qualifications:
 *                 type: string
 *                 description: 相关资质描述
 *     responses:
 *       200:
 *         description: 申请成功
 */
router.post('/apply', authenticateUser, userPermissionController.applyPermission);

/**
 * @swagger
 * /api/user-permissions/my:
 *   get:
 *     summary: 获取当前用户的权限状态
 *     tags: [UserPermissions]
 *     security:
 *       - bearerAuth: []
 */
router.get('/my', authenticateUser, userPermissionController.getUserPermissions);

/**
 * @swagger
 * /api/user-permissions/check/{permissionType}:
 *   get:
 *     summary: 检查当前用户是否有特定权限
 *     tags: [UserPermissions]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: permissionType
 *         required: true
 *         schema:
 *           type: string
 *           enum: [merchant, nutritionist]
 */
router.get('/check/:permissionType', authenticateUser, userPermissionController.checkPermission);

// ========== 管理员权限管理路由 ==========

/**
 * @swagger
 * /api/user-permissions/admin/pending:
 *   get:
 *     summary: 获取待审核的权限申请列表
 *     tags: [UserPermissions - Admin]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: permissionType
 *         schema:
 *           type: string
 *           enum: [merchant, nutritionist]
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           default: 1
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 20
 */
router.get('/admin/pending', 
  authenticateUser, 
  requireRole('admin'), 
  userPermissionController.getPendingApplications
);

/**
 * @swagger
 * /api/user-permissions/admin/review/{permissionId}:
 *   put:
 *     summary: 审核权限申请
 *     tags: [UserPermissions - Admin]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: permissionId
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - action
 *             properties:
 *               action:
 *                 type: string
 *                 enum: [approve, reject]
 *               comment:
 *                 type: string
 *                 description: 审核意见
 */
router.put('/admin/review/:permissionId', 
  authenticateUser, 
  requireRole('admin'), 
  userPermissionController.reviewApplication
);

/**
 * @swagger
 * /api/user-permissions/admin/batch-review:
 *   put:
 *     summary: 批量审核权限申请
 *     tags: [UserPermissions - Admin]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - permissionIds
 *               - action
 *             properties:
 *               permissionIds:
 *                 type: array
 *                 items:
 *                   type: string
 *               action:
 *                 type: string
 *                 enum: [approve, reject]
 *               comment:
 *                 type: string
 */
router.put('/admin/batch-review', 
  authenticateUser, 
  requireRole('admin'), 
  userPermissionController.batchReviewApplications
);

/**
 * @swagger
 * /api/user-permissions/admin/revoke/{userId}/{permissionType}:
 *   put:
 *     summary: 撤销用户权限
 *     tags: [UserPermissions - Admin]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 *       - in: path
 *         name: permissionType
 *         required: true
 *         schema:
 *           type: string
 *           enum: [merchant, nutritionist]
 *     requestBody:
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               reason:
 *                 type: string
 *                 description: 撤销原因
 */
router.put('/admin/revoke/:userId/:permissionType', 
  authenticateUser, 
  requireRole('admin'), 
  userPermissionController.revokePermission
);

/**
 * @swagger
 * /api/user-permissions/admin/grant:
 *   post:
 *     summary: 直接授予权限
 *     tags: [UserPermissions - Admin]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - userId
 *               - permissionType
 *             properties:
 *               userId:
 *                 type: string
 *               permissionType:
 *                 type: string
 *                 enum: [merchant, nutritionist]
 *               comment:
 *                 type: string
 *                 description: 授权说明
 */
router.post('/admin/grant', 
  authenticateUser, 
  requireRole('admin'), 
  userPermissionController.grantPermission
);

/**
 * @swagger
 * /api/user-permissions/admin/stats:
 *   get:
 *     summary: 获取权限统计信息
 *     tags: [UserPermissions - Admin]
 *     security:
 *       - bearerAuth: []
 */
router.get('/admin/stats', 
  authenticateUser, 
  requireRole('admin'), 
  userPermissionController.getPermissionStats
);

/**
 * @swagger
 * /api/user-permissions/admin/user/{userId}:
 *   get:
 *     summary: 获取指定用户的权限详情
 *     tags: [UserPermissions - Admin]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 */
router.get('/admin/user/:userId', 
  authenticateUser, 
  requireRole('admin'), 
  userPermissionController.getUserPermissionDetails
);

module.exports = router;