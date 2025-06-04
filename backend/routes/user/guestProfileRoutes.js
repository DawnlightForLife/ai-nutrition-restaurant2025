const express = require('express');
const router = express.Router();
const guestProfileController = require('../../controllers/user/guestProfileController');
const { authenticateUser } = require('../../middleware/auth/authMiddleware');
const roleMiddleware = require('../../middleware/auth/roleMiddleware');
// const validationMiddleware = require('../../middleware/validation/validationMiddleware'); // TODO: 实现验证中间件
const { createDynamicLimiter } = require('../../middleware/security/rateLimitMiddleware');

/**
 * 游客档案路由配置
 */

// 创建游客档案 - 只有营养师和管理员可以创建
router.post('/',
  authenticateUser,
  roleMiddleware(['nutritionist', 'admin']),
  createDynamicLimiter({ windowMs: 15 * 60 * 1000, max: 50 }), // 15分钟内最多50次
  // validationMiddleware.validateGuestProfileCreation, // TODO: 添加验证中间件
  guestProfileController.createGuestProfile
);

// 通过游客ID获取档案详情
router.get('/:guestId',
  authenticateUser,
  roleMiddleware(['nutritionist', 'admin']),
  // validationMiddleware.validateObjectId('guestId'), // TODO: 添加验证中间件
  guestProfileController.getGuestProfile
);

// 更新游客档案
router.put('/:guestId',
  authenticateUser,
  roleMiddleware(['nutritionist', 'admin']),
  // validationMiddleware.validateObjectId('guestId'), // TODO: 添加验证中间件
  // validationMiddleware.validateGuestProfileUpdate, // TODO: 添加验证中间件
  guestProfileController.updateGuestProfile
);

// 删除游客档案
router.delete('/:guestId',
  authenticateUser,
  roleMiddleware(['nutritionist', 'admin']),
  // validationMiddleware.validateObjectId('guestId'), // TODO: 添加验证中间件
  guestProfileController.deleteGuestProfile
);

// 通过绑定令牌获取档案（公开接口，用于用户注册流程）
router.get('/token/:token',
  createDynamicLimiter({ windowMs: 15 * 60 * 1000, max: 100 }), // 15分钟内最多100次
  // validationMiddleware.validateBindingToken, // TODO: 添加验证中间件
  guestProfileController.getProfileByToken
);

// 绑定游客档案到用户账号
router.post('/token/:token/bind',
  authenticateUser,
  createDynamicLimiter({ windowMs: 15 * 60 * 1000, max: 20 }), // 15分钟内最多20次
  // validationMiddleware.validateBindingToken, // TODO: 添加验证中间件
  // validationMiddleware.validateUserBinding, // TODO: 添加验证中间件
  guestProfileController.bindToUser
);

// 获取营养师创建的游客档案列表
router.get('/nutritionist/profiles',
  authenticateUser,
  roleMiddleware(['nutritionist', 'admin']),
  // validationMiddleware.validatePaginationParams, // TODO: 添加验证中间件
  guestProfileController.getNutritionistProfiles
);

// 获取游客档案统计
router.get('/stats/overview',
  authenticateUser,
  roleMiddleware(['nutritionist', 'admin']),
  guestProfileController.getProfileStats
);

// 批量创建游客档案（管理员功能）
router.post('/batch/create',
  authenticateUser,
  roleMiddleware(['admin']),
  createDynamicLimiter({ windowMs: 60 * 60 * 1000, max: 5 }), // 1小时内最多5次
  // validationMiddleware.validateBatchGuestProfileCreation, // TODO: 添加验证中间件
  guestProfileController.batchCreateProfiles
);

// 导出游客档案数据
router.get('/export/data',
  authenticateUser,
  roleMiddleware(['nutritionist', 'admin']),
  createDynamicLimiter({ windowMs: 60 * 60 * 1000, max: 10 }), // 1小时内最多10次
  // validationMiddleware.validateExportParams, // TODO: 添加验证中间件
  guestProfileController.exportProfiles
);

module.exports = router;