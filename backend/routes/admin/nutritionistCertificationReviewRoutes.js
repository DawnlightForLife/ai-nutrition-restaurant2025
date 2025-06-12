const express = require('express');
const router = express.Router();
const nutritionistCertificationReviewController = require('../../controllers/admin/nutritionistCertificationReviewController');
const { authenticate: authMiddleware } = require('../../middleware/auth/authMiddleware');
const roleMiddleware = require('../../middleware/auth/roleMiddleware');
const { validateBody } = require('../../middleware/validation/requestValidationMiddleware');
const Joi = require('joi');

// 审核决定验证规则
const reviewDecisionSchema = Joi.object({
  decision: Joi.string().valid('approved', 'rejected', 'needsRevision').required(),
  reviewNotes: Joi.string().max(1000).optional(),
  reviewerId: Joi.string().required()
});

// 批量审核验证规则
const batchReviewSchema = Joi.object({
  applicationIds: Joi.array().items(Joi.string()).min(1).max(50).required(),
  decision: Joi.string().valid('approved', 'rejected', 'needsRevision').required(),
  reviewNotes: Joi.string().max(1000).optional(),
  reviewerId: Joi.string().required()
});

// 优先级更新验证规则
const priorityUpdateSchema = Joi.object({
  priority: Joi.string().valid('low', 'normal', 'high', 'urgent').required()
});

// 审核员分配验证规则
const reviewerAssignSchema = Joi.object({
  reviewerId: Joi.string().required()
});

/**
 * @swagger
 * components:
 *   schemas:
 *     ReviewDecision:
 *       type: object
 *       required:
 *         - decision
 *         - reviewerId
 *       properties:
 *         decision:
 *           type: string
 *           enum: [approved, rejected, needsRevision]
 *           description: 审核决定
 *         reviewNotes:
 *           type: string
 *           maxLength: 1000
 *           description: 审核备注
 *         reviewerId:
 *           type: string
 *           description: 审核员ID
 *
 *     BatchReviewRequest:
 *       type: object
 *       required:
 *         - applicationIds
 *         - decision
 *         - reviewerId
 *       properties:
 *         applicationIds:
 *           type: array
 *           items:
 *             type: string
 *           minItems: 1
 *           maxItems: 50
 *           description: 申请ID列表
 *         decision:
 *           type: string
 *           enum: [approved, rejected, needsRevision]
 *           description: 审核决定
 *         reviewNotes:
 *           type: string
 *           maxLength: 1000
 *           description: 审核备注
 *         reviewerId:
 *           type: string
 *           description: 审核员ID
 */

/**
 * @swagger
 * /admin/nutritionist-certification-review/pending:
 *   get:
 *     summary: 获取待审核申请列表
 *     tags: [Admin - Nutritionist Certification Review]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *         description: 页码
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 20
 *         description: 每页条数
 *       - in: query
 *         name: status
 *         schema:
 *           type: string
 *           enum: [pending, inReview, approved, rejected, needsRevision]
 *         description: 申请状态筛选
 *       - in: query
 *         name: certificationLevel
 *         schema:
 *           type: string
 *         description: 认证级别筛选
 *       - in: query
 *         name: specialization
 *         schema:
 *           type: string
 *         description: 专业领域筛选
 *       - in: query
 *         name: sort
 *         schema:
 *           type: string
 *         description: 排序规则
 *     responses:
 *       200:
 *         description: 获取成功
 */
router.get('/pending', 
  authMiddleware, 
  roleMiddleware(['admin', 'superAdmin']), 
  nutritionistCertificationReviewController.getPendingApplications
);

/**
 * @swagger
 * /admin/nutritionist-certification-review/applications/{applicationId}:
 *   get:
 *     summary: 获取申请详情
 *     tags: [Admin - Nutritionist Certification Review]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: applicationId
 *         required: true
 *         schema:
 *           type: string
 *         description: 申请ID
 *     responses:
 *       200:
 *         description: 获取成功
 *       404:
 *         description: 申请不存在
 */
router.get('/applications/:applicationId', 
  authMiddleware, 
  roleMiddleware(['admin', 'superAdmin']), 
  nutritionistCertificationReviewController.getApplicationDetail
);

/**
 * @swagger
 * /admin/nutritionist-certification-review/applications/{applicationId}/review:
 *   post:
 *     summary: 审核申请
 *     tags: [Admin - Nutritionist Certification Review]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: applicationId
 *         required: true
 *         schema:
 *           type: string
 *         description: 申请ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/ReviewDecision'
 *     responses:
 *       200:
 *         description: 审核成功
 *       400:
 *         description: 请求参数错误
 *       404:
 *         description: 申请不存在
 */
router.post('/applications/:applicationId/review', 
  authMiddleware, 
  roleMiddleware(['admin', 'superAdmin']),
  validateBody(reviewDecisionSchema),
  nutritionistCertificationReviewController.reviewApplication
);

/**
 * @swagger
 * /admin/nutritionist-certification-review/batch-review:
 *   post:
 *     summary: 批量审核申请
 *     tags: [Admin - Nutritionist Certification Review]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/BatchReviewRequest'
 *     responses:
 *       200:
 *         description: 批量审核成功
 *       400:
 *         description: 请求参数错误
 */
router.post('/batch-review', 
  authMiddleware, 
  roleMiddleware(['admin', 'superAdmin']),
  validateBody(batchReviewSchema),
  nutritionistCertificationReviewController.batchReview
);

/**
 * @swagger
 * /admin/nutritionist-certification-review/statistics:
 *   get:
 *     summary: 获取审核统计
 *     tags: [Admin - Nutritionist Certification Review]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: dateFrom
 *         schema:
 *           type: string
 *           format: date
 *         description: 开始日期
 *       - in: query
 *         name: dateTo
 *         schema:
 *           type: string
 *           format: date
 *         description: 结束日期
 *       - in: query
 *         name: reviewerId
 *         schema:
 *           type: string
 *         description: 审核员ID
 *     responses:
 *       200:
 *         description: 获取成功
 */
router.get('/statistics', 
  authMiddleware, 
  roleMiddleware(['admin', 'superAdmin']), 
  nutritionistCertificationReviewController.getReviewStatistics
);

/**
 * @swagger
 * /admin/nutritionist-certification-review/applications/{applicationId}/history:
 *   get:
 *     summary: 获取申请审核历史
 *     tags: [Admin - Nutritionist Certification Review]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: applicationId
 *         required: true
 *         schema:
 *           type: string
 *         description: 申请ID
 *     responses:
 *       200:
 *         description: 获取成功
 *       404:
 *         description: 申请不存在
 */
router.get('/applications/:applicationId/history', 
  authMiddleware, 
  roleMiddleware(['admin', 'superAdmin']), 
  nutritionistCertificationReviewController.getReviewHistory
);

/**
 * @swagger
 * /admin/nutritionist-certification-review/applications/{applicationId}/priority:
 *   put:
 *     summary: 更新申请优先级
 *     tags: [Admin - Nutritionist Certification Review]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: applicationId
 *         required: true
 *         schema:
 *           type: string
 *         description: 申请ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - priority
 *             properties:
 *               priority:
 *                 type: string
 *                 enum: [low, normal, high, urgent]
 *     responses:
 *       200:
 *         description: 更新成功
 *       400:
 *         description: 请求参数错误
 */
router.put('/applications/:applicationId/priority', 
  authMiddleware, 
  roleMiddleware(['admin', 'superAdmin']),
  validateBody(priorityUpdateSchema),
  nutritionistCertificationReviewController.updateApplicationPriority
);

/**
 * @swagger
 * /admin/nutritionist-certification-review/applications/{applicationId}/assign:
 *   put:
 *     summary: 分配审核员
 *     tags: [Admin - Nutritionist Certification Review]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: applicationId
 *         required: true
 *         schema:
 *           type: string
 *         description: 申请ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - reviewerId
 *             properties:
 *               reviewerId:
 *                 type: string
 *                 description: 审核员ID
 *     responses:
 *       200:
 *         description: 分配成功
 *       400:
 *         description: 请求参数错误
 */
router.put('/applications/:applicationId/assign', 
  authMiddleware, 
  roleMiddleware(['admin', 'superAdmin']),
  validateBody(reviewerAssignSchema),
  nutritionistCertificationReviewController.assignReviewer
);

module.exports = router;