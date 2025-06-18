/**
 * 商家菜品管理路由
 * 包含创建、获取、更新、删除菜品的接口
 * @module routes/merchant/dishRoutes
 */

const express = require('express');
const router = express.Router();
const { body, param } = require('express-validator');
const { authenticateUser } = require('../../middleware/auth/authMiddleware');
const { permissionMiddleware } = require('../../middleware/auth/permissionMiddleware');
const requireRole = require('../../middleware/auth/roleMiddleware');
const { BASE_PERMISSIONS } = require('../../constants/permissions');
const { 
  createDish, 
  getDishList, 
  getDishById, 
  updateDish, 
  deleteDish,
  batchUpdatePrices,
  getBestSellers,
  getLowStockDishes
} = require('../../controllers/merchant/dishController');

// 应用身份验证中间件到所有路由
router.use(authenticateUser);

// 检查用户是否有商家相关角色
router.use(requireRole(['store_manager', 'store_staff']));

// 菜品创建验证规则
const createDishValidation = [
  body('name').notEmpty().withMessage('菜品名称不能为空'),
  body('description').optional().isLength({ max: 500 }).withMessage('描述不能超过500字符'),
  body('category').notEmpty().withMessage('菜品分类不能为空'),
  body('price').isFloat({ min: 0 }).withMessage('价格必须是大于等于0的数字'),
  body('discountPrice').optional().isFloat({ min: 0 }).withMessage('折扣价格必须是大于等于0的数字'),
  body('preparationTime').optional().isInt({ min: 0 }).withMessage('制作时间必须是大于等于0的整数'),
  body('spicyLevel').optional().isInt({ min: 0, max: 5 }).withMessage('辣度等级必须在0-5之间')
];

// 菜品更新验证规则
const updateDishValidation = [
  param('dishId').isMongoId().withMessage('无效的菜品ID'),
  body('name').optional().notEmpty().withMessage('菜品名称不能为空'),
  body('description').optional().isLength({ max: 500 }).withMessage('描述不能超过500字符'),
  body('price').optional().isFloat({ min: 0 }).withMessage('价格必须是大于等于0的数字'),
  body('discountPrice').optional().isFloat({ min: 0 }).withMessage('折扣价格必须是大于等于0的数字'),
  body('preparationTime').optional().isInt({ min: 0 }).withMessage('制作时间必须是大于等于0的整数'),
  body('spicyLevel').optional().isInt({ min: 0, max: 5 }).withMessage('辣度等级必须在0-5之间')
];

// [POST] 创建菜品
router.post('/', 
  permissionMiddleware(BASE_PERMISSIONS.DISH_WRITE),
  createDishValidation,
  createDish
);

// [GET] 获取菜品列表
router.get('/', 
  permissionMiddleware(BASE_PERMISSIONS.DISH_READ),
  getDishList
);

// [GET] 获取热销菜品
router.get('/bestsellers',
  permissionMiddleware(BASE_PERMISSIONS.DISH_READ),
  getBestSellers
);

// [GET] 获取库存预警菜品
router.get('/low-stock',
  permissionMiddleware(BASE_PERMISSIONS.INVENTORY_READ),
  getLowStockDishes
);

// [GET] 获取指定菜品详情
router.get('/:dishId', 
  permissionMiddleware(BASE_PERMISSIONS.DISH_READ),
  param('dishId').isMongoId().withMessage('无效的菜品ID'),
  getDishById
);

// [PUT] 更新指定菜品
router.put('/:dishId', 
  permissionMiddleware(BASE_PERMISSIONS.DISH_WRITE),
  updateDishValidation,
  updateDish
);

// [DELETE] 删除指定菜品
router.delete('/:dishId', 
  permissionMiddleware(BASE_PERMISSIONS.DISH_DELETE),
  param('dishId').isMongoId().withMessage('无效的菜品ID'),
  deleteDish
);

// [POST] 批量更新菜品价格
router.post('/batch/update-prices',
  permissionMiddleware(BASE_PERMISSIONS.DISH_MANAGE),
  [
    body('percentage').isFloat().withMessage('价格调整百分比必须是数字'),
    body('category').optional().notEmpty().withMessage('分类不能为空'),
    body('dishIds').optional().isArray().withMessage('菜品ID列表必须是数组')
  ],
  batchUpdatePrices
);

module.exports = router;