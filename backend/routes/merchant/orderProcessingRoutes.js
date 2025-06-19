/**
 * 订单处理路由
 * 处理商家端订单管理、状态更新、制作流程追踪等
 */

const express = require('express');
const router = express.Router();
const orderController = require('../../controllers/merchant/orderProcessingController');
const { authenticateUser } = require('../../middleware/auth/authMiddleware');
const requireRole = require('../../middleware/auth/roleMiddleware');
const { validationMiddleware } = require('../../middleware/validation/validationMiddleware');
const { body, param } = require('express-validator');

// 应用认证中间件
router.use(authenticateUser);
router.use(requireRole(['store_manager', 'admin', 'super_admin']));

// 更新订单状态验证规则
const updateOrderStatusValidation = [
  param('orderId').isMongoId().withMessage('无效的订单ID'),
  body('status').isIn([
    'pending', 'confirmed', 'preparing', 'ready', 
    'in_delivery', 'delivered', 'completed', 'cancelled'
  ]).withMessage('无效的订单状态'),
  body('reason').optional().isString().withMessage('操作原因必须是字符串'),
  body('estimatedTime').optional().isInt({ min: 1 }).withMessage('预计时间必须是正整数（分钟）'),
  validationMiddleware
];

// 批量更新验证规则
const batchUpdateValidation = [
  body('orderIds').isArray({ min: 1 }).withMessage('请选择要操作的订单'),
  body('orderIds.*').isMongoId().withMessage('订单ID格式无效'),
  body('status').isIn([
    'confirmed', 'preparing', 'ready', 'cancelled'
  ]).withMessage('无效的订单状态'),
  body('reason').optional().isString().withMessage('操作原因必须是字符串'),
  validationMiddleware
];

// 制作进度更新验证规则
const updateProductionProgressValidation = [
  param('orderId').isMongoId().withMessage('无效的订单ID'),
  body('step').isIn(['cooking', 'plating']).withMessage('无效的制作步骤'),
  body('progress').isIn(['pending', 'in_progress', 'completed']).withMessage('无效的进度状态'),
  body('notes').optional().isString().withMessage('备注必须是字符串'),
  validationMiddleware
];

// 订单处理路由

/**
 * @route GET /api/merchant/orders
 * @desc 获取商家订单列表
 * @access Private (Merchant)
 */
router.get('/', orderController.getOrderList);

/**
 * @route GET /api/merchant/orders/:orderId
 * @desc 获取订单详情
 * @access Private (Merchant)
 */
router.get('/:orderId',
  param('orderId').isMongoId().withMessage('无效的订单ID'),
  validationMiddleware,
  orderController.getOrderById
);

/**
 * @route PUT /api/merchant/orders/:orderId/status
 * @desc 更新订单状态
 * @access Private (Merchant)
 */
router.put('/:orderId/status', updateOrderStatusValidation, orderController.updateOrderStatus);

/**
 * @route PUT /api/merchant/orders/batch/status
 * @desc 批量更新订单状态
 * @access Private (Merchant)
 */
router.put('/batch/status', batchUpdateValidation, orderController.batchUpdateOrderStatus);

/**
 * @route GET /api/merchant/orders/production/queue
 * @desc 获取生产队列
 * @access Private (Merchant)
 */
router.get('/production/queue', orderController.getProductionQueue);

/**
 * @route GET /api/merchant/orders/delivery/management
 * @desc 获取配送管理
 * @access Private (Merchant)
 */
router.get('/delivery/management', orderController.getDeliveryManagement);

/**
 * @route PUT /api/merchant/orders/:orderId/production
 * @desc 更新订单制作进度
 * @access Private (Merchant)
 */
router.put('/:orderId/production', updateProductionProgressValidation, orderController.updateProductionProgress);

/**
 * @route POST /api/merchant/orders/:orderId/assign-driver
 * @desc 分配配送员
 * @access Private (Merchant)
 */
router.post('/:orderId/assign-driver',
  param('orderId').isMongoId().withMessage('无效的订单ID'),
  validationMiddleware,
  orderController.assignDeliveryDriver
);

/**
 * @route GET /api/merchant/orders/delivery/drivers
 * @desc 获取配送员列表
 * @access Private (Merchant)
 */
router.get('/delivery/drivers', orderController.getDeliveryDrivers);

/**
 * @route GET /api/merchant/orders/:orderId/delivery/route
 * @desc 获取配送路线
 * @access Private (Merchant)
 */
router.get('/:orderId/delivery/route',
  param('orderId').isMongoId().withMessage('无效的订单ID'),
  validationMiddleware,
  orderController.getDeliveryRoute
);

/**
 * @route POST /api/merchant/orders/batch/assign-delivery
 * @desc 批量分配配送订单
 * @access Private (Merchant)
 */
router.post('/batch/assign-delivery',
  body('orderIds').isArray({ min: 1 }).withMessage('请选择要分配的订单'),
  body('orderIds.*').isMongoId().withMessage('订单ID格式无效'),
  validationMiddleware,
  orderController.batchAssignOrders
);

/**
 * @route GET /api/merchant/orders/analytics/report
 * @desc 获取订单分析报告
 * @access Private (Merchant)
 */
router.get('/analytics/report', orderController.getOrderAnalytics);

module.exports = router;