const express = require('express');
const router = express.Router();
const pointsController = require('../../controllers/user/pointsController');
const { authenticateUser } = require('../../middleware/auth/authMiddleware');
const roleMiddleware = require('../../middleware/auth/roleMiddleware');
// const validationMiddleware = require('../../middleware/validation/validationMiddleware'); // TODO: 实现验证中间件
const { createDynamicLimiter, defaultLimiter } = require('../../middleware/security/rateLimitMiddleware');

/**
 * 积分系统路由配置
 */

// 获取当前用户积分余额
router.get('/balance',
  authenticateUser,
  pointsController.getCurrentBalance
);

// 用户签到获取积分
router.post('/checkin',
  authenticateUser,
  createDynamicLimiter({ windowMs: 24 * 60 * 60 * 1000, max: 1 }), // 每天只能签到1次
  pointsController.checkinPoints
);

// 使用积分
router.post('/spend',
  authenticateUser,
  createDynamicLimiter({ windowMs: 1 * 60 * 1000, max: 20 }), // 1分钟内最多20次
  // validationMiddleware.validatePointsSpend,
  pointsController.spendPoints
);

// 积分兑换预览
router.post('/redemption/preview',
  authenticateUser,
  // validationMiddleware.validateRedemptionPreview,
  pointsController.previewRedemption
);

// 获取用户积分历史
router.get('/history/:userId',
  authenticateUser,
  // validationMiddleware.validateObjectId('userId'),
  // validationMiddleware.validatePaginationParams,
  pointsController.getPointsHistory
);

// 获取用户积分统计
router.get('/stats/:userId',
  authenticateUser,
  // validationMiddleware.validateObjectId('userId'),
  pointsController.getPointsStats
);

// 导出用户积分数据
router.get('/export/:userId',
  authenticateUser,
  // validationMiddleware.validateObjectId('userId'),
  createDynamicLimiter({ windowMs: 60 * 60 * 1000, max: 10 }), // 1小时内最多10次
  // validationMiddleware.validateExportParams,
  pointsController.exportPointsData
);

// 获取积分排行榜
router.get('/leaderboard',
  authenticateUser,
  // validationMiddleware.validateLeaderboardParams,
  pointsController.getPointsLeaderboard
);

// ============ 管理员功能 ============

// 处理订单积分（内部调用或管理员手动触发）
router.post('/admin/process-order/:orderId',
  authenticateUser,
  roleMiddleware(['admin', 'system']),
  // validationMiddleware.validateObjectId('orderId'),
  pointsController.processOrderPoints
);

// 管理员调整用户积分
router.post('/admin/adjust/:userId',
  authenticateUser,
  roleMiddleware(['admin']),
  // validationMiddleware.validateObjectId('userId'),
  // validationMiddleware.validatePointsAdjustment,
  createDynamicLimiter({ windowMs: 5 * 60 * 1000, max: 50 }), // 5分钟内最多50次
  pointsController.adjustPoints
);

// 批量处理订单积分
router.post('/admin/batch/process-orders',
  authenticateUser,
  roleMiddleware(['admin']),
  createDynamicLimiter({ windowMs: 60 * 60 * 1000, max: 10 }), // 1小时内最多10次
  // validationMiddleware.validateBatchOrderProcessing,
  pointsController.batchProcessOrderPoints
);

// 处理过期积分（定时任务）
router.post('/admin/process-expired',
  authenticateUser,
  roleMiddleware(['admin']),
  createDynamicLimiter({ windowMs: 60 * 60 * 1000, max: 5 }), // 1小时内最多5次
  pointsController.processExpiredPoints
);

// ============ 积分规则管理 ============

// 创建积分规则
router.post('/rules',
  authenticateUser,
  roleMiddleware(['admin']),
  // validationMiddleware.validatePointsRuleCreation,
  pointsController.createPointsRule
);

// 获取积分规则列表
router.get('/rules',
  authenticateUser,
  roleMiddleware(['admin', 'nutritionist', 'store_manager']),
  // validationMiddleware.validatePaginationParams,
  pointsController.getPointsRules
);

// 更新积分规则
router.put('/rules/:ruleId',
  authenticateUser,
  roleMiddleware(['admin']),
  // validationMiddleware.validateObjectId('ruleId'),
  // validationMiddleware.validatePointsRuleUpdate,
  pointsController.updatePointsRule
);

// 删除积分规则
router.delete('/rules/:ruleId',
  authenticateUser,
  roleMiddleware(['admin']),
  // validationMiddleware.validateObjectId('ruleId'),
  (req, res) => {
    // 这里需要添加删除规则的控制器方法
    res.status(501).json({ message: '功能开发中' });
  }
);

// 获取积分规则详情
router.get('/rules/:ruleId',
  authenticateUser,
  roleMiddleware(['admin', 'nutritionist', 'store_manager']),
  // validationMiddleware.validateObjectId('ruleId'),
  (req, res) => {
    // 这里需要添加获取规则详情的控制器方法
    res.status(501).json({ message: '功能开发中' });
  }
);

// 启用/禁用积分规则
router.patch('/rules/:ruleId/status',
  authenticateUser,
  roleMiddleware(['admin']),
  // validationMiddleware.validateObjectId('ruleId'),
  // validationMiddleware.validateRuleStatusUpdate,
  (req, res) => {
    // 这里需要添加更新规则状态的控制器方法
    res.status(501).json({ message: '功能开发中' });
  }
);

// 获取积分规则使用报告
router.get('/rules/reports/usage',
  authenticateUser,
  roleMiddleware(['admin']),
  // validationMiddleware.validateReportParams,
  (req, res) => {
    // 这里需要添加获取规则使用报告的控制器方法
    res.status(501).json({ message: '功能开发中' });
  }
);

module.exports = router;