const express = require('express');
const router = express.Router();
const pickupCodeController = require('../../controllers/order/pickupCodeController');
const { authenticateUser } = require('../../middleware/auth/authMiddleware');
const roleMiddleware = require('../../middleware/auth/roleMiddleware');
// const validationMiddleware = require('../../middleware/validation/validationMiddleware'); // TODO: 实现验证中间件
const { createDynamicLimiter, defaultLimiter } = require('../../middleware/security/rateLimitMiddleware');

/**
 * 取餐码路由配置
 */

// 为订单创建取餐码
router.post('/order/:orderId',
  authenticateUser,
  roleMiddleware(['store_staff', 'admin']),
  // validationMiddleware.validateObjectId('orderId'),
  createDynamicLimiter({ windowMs: 15 * 60 * 1000, max: 100 }), // 15分钟内最多100次
  pickupCodeController.createPickupCode
);

// 验证取餐码
router.get('/verify/:code',
  authenticateUser,
  roleMiddleware(['store_staff', 'admin']),
  // validationMiddleware.validatePickupCode,
  createDynamicLimiter({ windowMs: 1 * 60 * 1000, max: 200 }), // 1分钟内最多200次
  pickupCodeController.verifyPickupCode
);

// 使用取餐码（确认取餐）
router.post('/use/:code',
  authenticateUser,
  roleMiddleware(['store_staff', 'admin']),
  // validationMiddleware.validatePickupCode,
  // validationMiddleware.validatePickupCodeUsage,
  createDynamicLimiter({ windowMs: 1 * 60 * 1000, max: 100 }), // 1分钟内最多100次
  pickupCodeController.usePickupCode
);

// 获取门店取餐码列表
router.get('/store/:storeId',
  authenticateUser,
  roleMiddleware(['store_staff', 'store_manager', 'admin']),
  // validationMiddleware.validateObjectId('storeId'),
  // validationMiddleware.validatePaginationParams,
  pickupCodeController.getStorePickupCodes
);

// 取消取餐码
router.patch('/:codeId/cancel',
  authenticateUser,
  roleMiddleware(['store_staff', 'store_manager', 'admin']),
  // validationMiddleware.validateObjectId('codeId'),
  // validationMiddleware.validateCancelReason,
  pickupCodeController.cancelPickupCode
);

// 延长取餐码有效期
router.patch('/:codeId/extend',
  authenticateUser,
  roleMiddleware(['store_staff', 'store_manager', 'admin']),
  // validationMiddleware.validateObjectId('codeId'),
  // validationMiddleware.validateExtensionHours,
  pickupCodeController.extendPickupCode
);

// 获取门店取餐码统计
router.get('/store/:storeId/stats',
  authenticateUser,
  roleMiddleware(['store_staff', 'store_manager', 'admin']),
  // validationMiddleware.validateObjectId('storeId'),
  pickupCodeController.getStoreStats
);

// 批量验证取餐码
router.post('/batch/verify',
  authenticateUser,
  roleMiddleware(['store_staff', 'admin']),
  createDynamicLimiter({ windowMs: 5 * 60 * 1000, max: 20 }), // 5分钟内最多20次
  // validationMiddleware.validateBatchPickupCodeVerification,
  pickupCodeController.batchVerifyPickupCodes
);

// 获取取餐码详情
router.get('/details/:codeId',
  authenticateUser,
  roleMiddleware(['store_staff', 'store_manager', 'admin']),
  // validationMiddleware.validateObjectId('codeId'),
  pickupCodeController.getPickupCodeDetails
);

// 重新发送取餐码通知
router.post('/:codeId/resend-notification',
  authenticateUser,
  roleMiddleware(['store_staff', 'store_manager', 'admin']),
  // validationMiddleware.validateObjectId('codeId'),
  createDynamicLimiter({ windowMs: 15 * 60 * 1000, max: 10 }), // 15分钟内最多10次
  pickupCodeController.resendNotification
);

// 处理过期取餐码（定时任务接口）
router.post('/admin/process-expired',
  authenticateUser,
  roleMiddleware(['admin']),
  createDynamicLimiter({ windowMs: 60 * 60 * 1000, max: 5 }), // 1小时内最多5次
  pickupCodeController.processExpiredCodes
);

// 导出取餐码数据
router.get('/store/:storeId/export',
  authenticateUser,
  roleMiddleware(['store_manager', 'admin']),
  // validationMiddleware.validateObjectId('storeId'),
  createDynamicLimiter({ windowMs: 60 * 60 * 1000, max: 10 }), // 1小时内最多10次
  // validationMiddleware.validateExportParams,
  pickupCodeController.exportPickupCodes
);

module.exports = router;