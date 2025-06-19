/**
 * 库存管理路由
 * 处理食材库存的增删改查、预警、自动补货等
 */

const express = require('express');
const router = express.Router();
const inventoryController = require('../../controllers/merchant/inventoryController');
const { authenticateUser } = require('../../middleware/auth/authMiddleware');
const requireRole = require('../../middleware/auth/roleMiddleware');
const { validationMiddleware } = require('../../middleware/validation/validationMiddleware');
const { body, param } = require('express-validator');

// 应用认证中间件
router.use(authenticateUser);
router.use(requireRole(['store_manager', 'admin', 'super_admin']));

// 创建库存验证规则
const createInventoryValidation = [
  body('name').notEmpty().withMessage('食材名称不能为空'),
  body('chineseName').notEmpty().withMessage('中文名称不能为空'),
  body('category').notEmpty().withMessage('食材类别不能为空'),
  body('minThreshold').isFloat({ min: 0 }).withMessage('最低库存阈值必须是非负数'),
  body('maxCapacity').isFloat({ min: 0 }).withMessage('最大库存容量必须是非负数'),
  body('initialStock.quantity').optional().isFloat({ min: 0 }).withMessage('初始库存数量必须是非负数'),
  body('initialStock.purchasePrice').optional().isFloat({ min: 0 }).withMessage('采购价格必须是非负数'),
  validationMiddleware
];

// 入库验证规则
const addStockValidation = [
  param('inventoryId').isMongoId().withMessage('无效的库存ID'),
  body('batchNumber').notEmpty().withMessage('批次号不能为空'),
  body('quantity').isFloat({ min: 0.01 }).withMessage('入库数量必须大于0'),
  body('unit').notEmpty().withMessage('单位不能为空'),
  body('expiryDate').isISO8601().withMessage('过期日期格式无效'),
  body('purchasePrice').isFloat({ min: 0 }).withMessage('采购价格必须是非负数'),
  validationMiddleware
];

// 出库验证规则
const consumeStockValidation = [
  param('inventoryId').isMongoId().withMessage('无效的库存ID'),
  body('quantity').isFloat({ min: 0.01 }).withMessage('出库数量必须大于0'),
  body('reason').optional().isString().withMessage('出库原因必须是字符串'),
  validationMiddleware
];

// 库存路由

/**
 * @route GET /api/merchant/inventory
 * @desc 获取库存列表
 * @access Private (Merchant)
 */
router.get('/', inventoryController.getInventoryList);

/**
 * @route GET /api/merchant/inventory/:inventoryId
 * @desc 获取库存详情
 * @access Private (Merchant)
 */
router.get('/:inventoryId',
  param('inventoryId').isMongoId().withMessage('无效的库存ID'),
  validationMiddleware,
  inventoryController.getInventoryById
);

/**
 * @route POST /api/merchant/inventory
 * @desc 创建库存记录
 * @access Private (Merchant)
 */
router.post('/', createInventoryValidation, inventoryController.createInventory);

/**
 * @route POST /api/merchant/inventory/:inventoryId/stock
 * @desc 入库操作
 * @access Private (Merchant)
 */
router.post('/:inventoryId/stock', addStockValidation, inventoryController.addStock);

/**
 * @route PUT /api/merchant/inventory/:inventoryId/consume
 * @desc 出库操作
 * @access Private (Merchant)
 */
router.put('/:inventoryId/consume', consumeStockValidation, inventoryController.consumeStock);

/**
 * @route GET /api/merchant/inventory/alerts/list
 * @desc 获取库存预警
 * @access Private (Merchant)
 */
router.get('/alerts/list', inventoryController.getInventoryAlerts);

/**
 * @route DELETE /api/merchant/inventory/:inventoryId/expired
 * @desc 清理过期库存
 * @access Private (Merchant)
 */
router.delete('/:inventoryId/expired',
  param('inventoryId').isMongoId().withMessage('无效的库存ID'),
  validationMiddleware,
  inventoryController.removeExpiredStock
);

/**
 * @route GET /api/merchant/inventory/analytics/report
 * @desc 获取库存分析报告
 * @access Private (Merchant)
 */
router.get('/analytics/report', inventoryController.getInventoryAnalytics);

/**
 * @route PUT /api/merchant/inventory/:inventoryId/settings
 * @desc 更新库存设置
 * @access Private (Merchant)
 */
router.put('/:inventoryId/settings',
  param('inventoryId').isMongoId().withMessage('无效的库存ID'),
  body('minThreshold').optional().isFloat({ min: 0 }).withMessage('最低库存阈值必须是非负数'),
  body('maxCapacity').optional().isFloat({ min: 0 }).withMessage('最大库存容量必须是非负数'),
  validationMiddleware,
  inventoryController.updateInventorySettings
);

module.exports = router;