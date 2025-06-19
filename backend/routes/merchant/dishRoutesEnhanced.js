/**
 * 增强的菜品管理路由
 * 支持完整的CRUD操作、图片上传、营养信息管理等
 */

const express = require('express');
const router = express.Router();
const dishController = require('../../controllers/merchant/dishControllerEnhanced');
const { authenticateUser } = require('../../middleware/auth/authMiddleware');
const requireRole = require('../../middleware/auth/roleMiddleware');
const { validationMiddleware } = require('../../middleware/validation/validationMiddleware');
const { body } = require('express-validator');

// 应用认证中间件
router.use(authenticateUser);
router.use(requireRole(['store_manager', 'admin', 'super_admin']));

// 菜品创建验证规则
const createDishValidation = [
  body('name').notEmpty().withMessage('菜品名称不能为空'),
  body('description').notEmpty().withMessage('菜品描述不能为空'),
  body('category').notEmpty().withMessage('菜品类别不能为空'),
  body('price').isFloat({ min: 0 }).withMessage('价格必须是大于等于0的数字'),
  body('preparationTime').optional().isInt({ min: 0 }).withMessage('制作时间必须是非负整数'),
  body('spicyLevel').optional().isInt({ min: 0, max: 5 }).withMessage('辣度等级必须在0-5之间'),
  validationMiddleware
];

// 菜品更新验证规则
const updateDishValidation = [
  body('name').optional().notEmpty().withMessage('菜品名称不能为空'),
  body('price').optional().isFloat({ min: 0 }).withMessage('价格必须是大于等于0的数字'),
  body('preparationTime').optional().isInt({ min: 0 }).withMessage('制作时间必须是非负整数'),
  body('spicyLevel').optional().isInt({ min: 0, max: 5 }).withMessage('辣度等级必须在0-5之间'),
  validationMiddleware
];

// 菜品路由

/**
 * @route POST /api/merchant/dishes/enhanced
 * @desc 创建菜品（支持图片上传）
 * @access Private (Merchant)
 */
router.post('/', 
  dishController.uploadDishImages,
  createDishValidation,
  dishController.createDish
);

/**
 * @route GET /api/merchant/dishes/enhanced
 * @desc 获取菜品列表（增强版）
 * @access Private (Merchant)
 */
router.get('/', dishController.getDishList);

/**
 * @route GET /api/merchant/dishes/enhanced/:dishId
 * @desc 获取菜品详情
 * @access Private (Merchant)
 */
router.get('/:dishId', dishController.getDishById);

/**
 * @route PUT /api/merchant/dishes/enhanced/:dishId
 * @desc 更新菜品（支持图片上传）
 * @access Private (Merchant)
 */
router.put('/:dishId',
  dishController.uploadDishImages,
  updateDishValidation,
  dishController.updateDish
);

/**
 * @route DELETE /api/merchant/dishes/enhanced/:dishId/images
 * @desc 删除菜品图片
 * @access Private (Merchant)
 */
router.delete('/:dishId/images',
  body('imageUrl').notEmpty().withMessage('图片URL不能为空'),
  validationMiddleware,
  dishController.removeImage
);

/**
 * @route POST /api/merchant/dishes/enhanced/batch
 * @desc 批量操作菜品
 * @access Private (Merchant)
 */
router.post('/batch',
  body('operation').isIn(['updateStatus', 'updatePrice', 'updateCategory', 'delete']).withMessage('无效的操作类型'),
  body('dishIds').isArray({ min: 1 }).withMessage('请选择要操作的菜品'),
  validationMiddleware,
  dishController.batchOperations
);

/**
 * @route GET /api/merchant/dishes/enhanced/analytics/report
 * @desc 获取菜品分析报告
 * @access Private (Merchant)
 */
router.get('/analytics/report', dishController.getDishAnalytics);

module.exports = router;