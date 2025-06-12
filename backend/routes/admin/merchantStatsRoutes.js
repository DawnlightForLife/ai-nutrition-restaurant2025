const express = require('express');
const router = express.Router();
const merchantStatsController = require('../../controllers/admin/merchantStatsController');
const { authenticateUser, requireAdmin } = require('../../middleware/auth/authMiddleware');

// 所有路由都需要管理员权限
router.use(authenticateUser);
router.use(requireAdmin);

/**
 * 加盟商统计管理路由
 * 提供加盟商相关的统计数据和管理功能
 */

// 获取加盟商统计概览
router.get('/overview', merchantStatsController.getMerchantOverview);

// 获取加盟商列表（带统计数据）
router.get('/list', merchantStatsController.getMerchantList);

// 获取加盟商详细统计
router.get('/:merchantId/stats', merchantStatsController.getMerchantStats);

// 获取加盟商排行榜
router.get('/ranking', merchantStatsController.getMerchantRanking);

module.exports = router;