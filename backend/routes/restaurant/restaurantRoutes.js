/**
 * 餐厅路由
 * @module routes/restaurant/restaurantRoutes
 */

const router = require('express').Router();
const restaurantController = require('../../controllers/restaurant/restaurantController');
const { authenticateUser } = require('../../middleware/auth/authMiddleware');
const roleMiddleware = require('../../middleware/auth/roleMiddleware');
const { permissionMiddleware } = require('../../middleware/auth/permissionMiddleware');
// const { validationMiddleware } = require('../../middleware/validation/validationMiddleware'); // TODO: 实现验证中间件
const { createDynamicLimiter } = require('../../middleware/security/rateLimitMiddleware');

// ========== 餐厅管理路由 ==========

/**
 * @api {post} /api/v1/restaurants 创建餐厅
 * @apiName CreateRestaurant
 * @apiGroup Restaurant
 * @apiPermission merchant_admin
 */
router.post('/restaurants',
  authenticateUser,
  roleMiddleware(['merchant_admin', 'system_admin']),
  // validationMiddleware('restaurant.create'),
  restaurantController.createRestaurant
);

/**
 * @api {get} /api/v1/restaurants/search 搜索餐厅
 * @apiName SearchRestaurants
 * @apiGroup Restaurant
 * @apiPermission public
 */
router.get('/restaurants/search',
  createDynamicLimiter({ windowMs: 60000, max: 100 }),
  restaurantController.searchRestaurants
);

/**
 * @api {get} /api/v1/restaurants/:id 获取餐厅详情
 * @apiName GetRestaurant
 * @apiGroup Restaurant
 * @apiPermission public
 */
router.get('/restaurants/:id',
  restaurantController.getRestaurant
);

/**
 * @api {put} /api/v1/restaurants/:id 更新餐厅信息
 * @apiName UpdateRestaurant
 * @apiGroup Restaurant
 * @apiPermission restaurant_owner
 */
router.put('/restaurants/:id',
  authenticateUser,
  permissionMiddleware('restaurant.update'),
  // validationMiddleware('restaurant.update'),
  restaurantController.updateRestaurant
);

/**
 * @api {post} /api/v1/restaurants/:id/verify 验证餐厅
 * @apiName VerifyRestaurant
 * @apiGroup Restaurant
 * @apiPermission system_admin
 */
router.post('/restaurants/:id/verify',
  authenticateUser,
  roleMiddleware(['system_admin']),
  restaurantController.verifyRestaurant
);

// ========== 分店管理路由 ==========

/**
 * @api {post} /api/v1/restaurants/:restaurantId/branches 创建分店
 * @apiName CreateBranch
 * @apiGroup Branch
 * @apiPermission restaurant_owner
 */
router.post('/restaurants/:restaurantId/branches',
  authenticateUser,
  permissionMiddleware('branch.create'),
  // validationMiddleware('branch.create'),
  restaurantController.createBranch
);

/**
 * @api {get} /api/v1/restaurants/:restaurantId/branches 获取餐厅分店列表
 * @apiName GetRestaurantBranches
 * @apiGroup Branch
 * @apiPermission public
 */
router.get('/restaurants/:restaurantId/branches',
  restaurantController.getRestaurantBranches
);

/**
 * @api {get} /api/v1/branches/nearby 查找附近分店
 * @apiName FindNearbyBranches
 * @apiGroup Branch
 * @apiPermission public
 */
router.get('/branches/nearby',
  createDynamicLimiter({ windowMs: 60000, max: 200 }),
  restaurantController.findNearbyBranches
);

/**
 * @api {get} /api/v1/branches/:id 获取分店详情
 * @apiName GetBranch
 * @apiGroup Branch
 * @apiPermission public
 */
router.get('/branches/:id',
  restaurantController.getBranch
);

/**
 * @api {put} /api/v1/branches/:id 更新分店信息
 * @apiName UpdateBranch
 * @apiGroup Branch
 * @apiPermission branch_manager
 */
router.put('/branches/:id',
  authenticateUser,
  permissionMiddleware('branch.update'),
  // validationMiddleware('branch.update'),
  restaurantController.updateBranch
);

// ========== 桌位管理路由 ==========

/**
 * @api {post} /api/v1/branches/:branchId/tables 创建桌位
 * @apiName CreateTable
 * @apiGroup Table
 * @apiPermission branch_manager
 */
router.post('/branches/:branchId/tables',
  authenticateUser,
  permissionMiddleware('table.create'),
  // validationMiddleware('table.create'),
  restaurantController.createTable
);

/**
 * @api {post} /api/v1/branches/:branchId/tables/batch 批量创建桌位
 * @apiName CreateTables
 * @apiGroup Table
 * @apiPermission branch_manager
 */
router.post('/branches/:branchId/tables/batch',
  authenticateUser,
  permissionMiddleware('table.create'),
  // validationMiddleware('table.createBatch'),
  restaurantController.createTables
);

/**
 * @api {get} /api/v1/branches/:branchId/tables 获取分店桌位列表
 * @apiName GetBranchTables
 * @apiGroup Table
 * @apiPermission public
 */
router.get('/branches/:branchId/tables',
  restaurantController.getBranchTables
);

/**
 * @api {get} /api/v1/tables/:id 获取桌位详情
 * @apiName GetTable
 * @apiGroup Table
 * @apiPermission public
 */
router.get('/tables/:id',
  restaurantController.getTable
);

/**
 * @api {put} /api/v1/tables/:id 更新桌位信息
 * @apiName UpdateTable
 * @apiGroup Table
 * @apiPermission branch_manager
 */
router.put('/tables/:id',
  authenticateUser,
  permissionMiddleware('table.update'),
  // validationMiddleware('table.update'),
  restaurantController.updateTable
);

/**
 * @api {post} /api/v1/tables/:id/occupy 占用桌位
 * @apiName OccupyTable
 * @apiGroup Table
 * @apiPermission branch_staff
 */
router.post('/tables/:id/occupy',
  authenticateUser,
  permissionMiddleware('table.occupy'),
  restaurantController.occupyTable
);

/**
 * @api {post} /api/v1/tables/:id/release 释放桌位
 * @apiName ReleaseTable
 * @apiGroup Table
 * @apiPermission branch_staff
 */
router.post('/tables/:id/release',
  authenticateUser,
  permissionMiddleware('table.release'),
  restaurantController.releaseTable
);

// ========== 设置管理路由 ==========

/**
 * @api {get} /api/v1/restaurants/:restaurantId/settings 获取餐厅设置
 * @apiName GetRestaurantSettings
 * @apiGroup Settings
 * @apiPermission restaurant_owner
 */
router.get('/restaurants/:restaurantId/settings',
  authenticateUser,
  permissionMiddleware('settings.view'),
  restaurantController.getRestaurantSettings
);

/**
 * @api {get} /api/v1/branches/:branchId/settings 获取分店设置
 * @apiName GetBranchSettings
 * @apiGroup Settings
 * @apiPermission branch_manager
 */
router.get('/branches/:branchId/settings',
  authenticateUser,
  permissionMiddleware('settings.view'),
  restaurantController.getBranchSettings
);

/**
 * @api {put} /api/v1/settings/:id 更新设置
 * @apiName UpdateSettings
 * @apiGroup Settings
 * @apiPermission restaurant_owner
 */
router.put('/settings/:id',
  authenticateUser,
  permissionMiddleware('settings.update'),
  // validationMiddleware('settings.update'),
  restaurantController.updateSettings
);

module.exports = router;