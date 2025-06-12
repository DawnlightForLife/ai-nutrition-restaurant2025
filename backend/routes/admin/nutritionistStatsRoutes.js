const express = require('express');
const router = express.Router();
const nutritionistStatsController = require('../../controllers/admin/nutritionistStatsController');
const { authenticateUser, requireAdmin } = require('../../middleware/auth/authMiddleware');

// 所有路由都需要管理员权限
router.use(authenticateUser);
router.use(requireAdmin);

// 获取营养师总体概况
router.get('/overview', nutritionistStatsController.getOverviewStats);

// 获取咨询服务数据
router.get('/consultation-stats', nutritionistStatsController.getConsultationStats);

// 获取营养推荐行为分析
router.get('/recommendation-stats', nutritionistStatsController.getRecommendationStats);

// 获取收入与分成统计
router.get('/income-stats', nutritionistStatsController.getIncomeStats);

// 获取营养师排行榜
router.get('/ranking', nutritionistStatsController.getNutritionistRanking);

// 获取营养师详细信息
router.get('/:nutritionistId/detail', nutritionistStatsController.getNutritionistDetail);

module.exports = router;