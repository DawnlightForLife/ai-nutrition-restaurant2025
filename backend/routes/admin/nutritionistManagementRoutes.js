const express = require('express');
const router = express.Router();
const { body, param, query } = require('express-validator');

const nutritionistManagementController = require('../../controllers/admin/nutritionistManagementController');
const { auth } = require('../../middleware/auth');
const { permissionMiddleware } = require('../../middleware/auth/permissionMiddleware');

// 权限常量
const PERMISSIONS = {
  READ: 'admin.nutritionist.read',
  WRITE: 'admin.nutritionist.write',
  DELETE: 'admin.nutritionist.delete',
  EXPORT: 'admin.nutritionist.export'
};

// 应用认证中间件
router.use(auth());

/**
 * @swagger
 * /api/admin/nutritionist-management:
 *   get:
 *     summary: 获取营养师列表
 *     tags: [Admin - Nutritionist Management]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           default: 1
 *         description: 页码
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 20
 *         description: 每页数量
 *       - in: query
 *         name: status
 *         schema:
 *           type: string
 *           enum: [active, inactive, suspended, pendingVerification]
 *         description: 营养师状态
 *       - in: query
 *         name: verificationStatus
 *         schema:
 *           type: string
 *           enum: [pending, approved, rejected]
 *         description: 审核状态
 *       - in: query
 *         name: specialization
 *         schema:
 *           type: string
 *         description: 专业领域
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         description: 搜索关键词
 *       - in: query
 *         name: sortBy
 *         schema:
 *           type: string
 *           default: createdAt
 *         description: 排序字段
 *       - in: query
 *         name: sortOrder
 *         schema:
 *           type: string
 *           enum: [asc, desc]
 *           default: desc
 *         description: 排序方向
 *     responses:
 *       200:
 *         description: 获取成功
 *       401:
 *         description: 未授权
 *       403:
 *         description: 权限不足
 */
router.get('/',
  permissionMiddleware(PERMISSIONS.READ),
  [
    query('page').optional().isInt({ min: 1 }).withMessage('页码必须为正整数'),
    query('limit').optional().isInt({ min: 1, max: 100 }).withMessage('每页数量必须在1-100之间'),
    query('status').optional().isIn(['active', 'inactive', 'suspended', 'pendingVerification']),
    query('verificationStatus').optional().isIn(['pending', 'approved', 'rejected']),
    query('search').optional().isLength({ min: 1, max: 50 }).withMessage('搜索关键词长度1-50字符'),
    query('sortBy').optional().isIn(['createdAt', 'updatedAt', 'personalInfo.realName', 'ratings.averageRating', 'onlineStatus.lastActiveAt']),
    query('sortOrder').optional().isIn(['asc', 'desc'])
  ],
  nutritionistManagementController.getNutritionists
);

/**
 * @swagger
 * /api/admin/nutritionist-management/overview:
 *   get:
 *     summary: 获取营养师管理概览统计
 *     tags: [Admin - Nutritionist Management]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: 获取成功
 */
router.get('/overview',
  permissionMiddleware(PERMISSIONS.READ),
  nutritionistManagementController.getManagementOverview
);

/**
 * @swagger
 * /api/admin/nutritionist-management/search:
 *   get:
 *     summary: 快速搜索营养师
 *     tags: [Admin - Nutritionist Management]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: q
 *         required: true
 *         schema:
 *           type: string
 *         description: 搜索关键词
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 10
 *         description: 结果数量限制
 *     responses:
 *       200:
 *         description: 搜索成功
 */
router.get('/search',
  permissionMiddleware(PERMISSIONS.READ),
  [
    query('q').notEmpty().isLength({ min: 2, max: 50 }).withMessage('搜索关键词长度2-50字符'),
    query('limit').optional().isInt({ min: 1, max: 50 }).withMessage('结果数量限制1-50')
  ],
  nutritionistManagementController.searchNutritionists
);

/**
 * @swagger
 * /api/admin/nutritionist-management/export:
 *   get:
 *     summary: 导出营养师数据
 *     tags: [Admin - Nutritionist Management]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: format
 *         schema:
 *           type: string
 *           enum: [csv, json]
 *           default: csv
 *         description: 导出格式
 *       - in: query
 *         name: status
 *         schema:
 *           type: string
 *         description: 筛选状态
 *       - in: query
 *         name: verificationStatus
 *         schema:
 *           type: string
 *         description: 筛选审核状态
 *     responses:
 *       200:
 *         description: 导出成功
 */
router.get('/export',
  permissionMiddleware(PERMISSIONS.EXPORT),
  [
    query('format').optional().isIn(['csv', 'json']),
    query('status').optional().isIn(['active', 'inactive', 'suspended', 'pendingVerification']),
    query('verificationStatus').optional().isIn(['pending', 'approved', 'rejected'])
  ],
  nutritionistManagementController.exportNutritionists
);

/**
 * @swagger
 * /api/admin/nutritionist-management/{id}:
 *   get:
 *     summary: 获取营养师详细信息
 *     tags: [Admin - Nutritionist Management]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: 营养师ID
 *     responses:
 *       200:
 *         description: 获取成功
 *       404:
 *         description: 营养师不存在
 */
router.get('/:id',
  permissionMiddleware(PERMISSIONS.READ),
  [
    param('id').isMongoId().withMessage('营养师ID格式无效')
  ],
  nutritionistManagementController.getNutritionist
);

/**
 * @swagger
 * /api/admin/nutritionist-management/{id}/status:
 *   put:
 *     summary: 更新营养师状态
 *     tags: [Admin - Nutritionist Management]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: 营养师ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               status:
 *                 type: string
 *                 enum: [active, inactive, suspended, pendingVerification]
 *                 description: 新状态
 *               reason:
 *                 type: string
 *                 description: 变更原因
 *             required:
 *               - status
 *     responses:
 *       200:
 *         description: 更新成功
 *       404:
 *         description: 营养师不存在
 */
router.put('/:id/status',
  permissionMiddleware(PERMISSIONS.WRITE),
  [
    param('id').isMongoId().withMessage('营养师ID格式无效'),
    body('status').isIn(['active', 'inactive', 'suspended', 'pendingVerification']).withMessage('状态值无效'),
    body('reason').optional().isLength({ min: 1, max: 200 }).withMessage('变更原因长度1-200字符')
  ],
  nutritionistManagementController.updateNutritionistStatus
);

/**
 * @swagger
 * /api/admin/nutritionist-management/batch:
 *   post:
 *     summary: 批量操作营养师
 *     tags: [Admin - Nutritionist Management]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nutritionistIds:
 *                 type: array
 *                 items:
 *                   type: string
 *                 description: 营养师ID列表
 *               action:
 *                 type: string
 *                 enum: [updateStatus, setOffline, resetPassword]
 *                 description: 操作类型
 *               data:
 *                 type: object
 *                 description: 操作数据
 *             required:
 *               - nutritionistIds
 *               - action
 *     responses:
 *       200:
 *         description: 批量操作成功
 */
router.post('/batch',
  permissionMiddleware(PERMISSIONS.WRITE),
  [
    body('nutritionistIds').isArray({ min: 1 }).withMessage('请选择要操作的营养师'),
    body('nutritionistIds.*').isMongoId().withMessage('营养师ID格式无效'),
    body('action').isIn(['updateStatus', 'setOffline', 'resetPassword']).withMessage('操作类型无效'),
    body('data').optional().isObject().withMessage('操作数据必须为对象'),
    // 状态更新时的验证
    body('data.status').if(body('action').equals('updateStatus'))
      .isIn(['active', 'inactive', 'suspended', 'pendingVerification'])
      .withMessage('状态值无效'),
    body('data.reason').if(body('action').equals('updateStatus'))
      .optional().isLength({ min: 1, max: 200 }).withMessage('变更原因长度1-200字符')
  ],
  nutritionistManagementController.batchUpdateNutritionists
);

module.exports = router;