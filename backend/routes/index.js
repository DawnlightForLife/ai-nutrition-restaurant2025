const express = require('express');
const router = express.Router();

/**
 * 路由注册中心
 * 集中管理所有模块的路由
 */

// Core
router.use('/auth', require('./core/authRoutes'));
router.use('/users', require('./core/userRoutes'));
router.use('/admin', require('./core/adminRoutes'));
router.use('/permissions', require('./core/permissionRoutes'));

// Forum
router.use('/forum-posts', require('./forum/forumPostRoutes'));
router.use('/forum-comments', require('./forum/forumCommentRoutes'));

// Health
router.use('/nutrition-profiles', require('./health/nutritionProfileRoutes'));
router.use('/health-data', require('./health/healthDataRoutes'));

// Merchant
router.use('/merchants', require('./merchant/merchantRoutes'));
router.use('/stores', require('./merchant/storeRoutes'));
router.use('/dishes', require('./merchant/dishRoutes'));
router.use('/merchant-stats', require('./merchant/merchantStatsRoutes'));

// Misc
router.use('/notifications', require('./misc/notificationRoutes'));
router.use('/app-config', require('./misc/appConfigRoutes'));

// Nutrition
router.use('/ai-recommendations', require('./nutrition/aiRecommendationRoutes'));
router.use('/nutritionists', require('./nutrition/nutritionistRoutes'));
router.use('/favorites', require('./nutrition/favoriteRoutes'));

// Order
router.use('/orders', require('./order/orderRoutes'));
router.use('/consultations', require('./order/consultationRoutes'));
router.use('/subscriptions', require('./order/subscriptionRoutes'));

// Audit
router.use('/audit-logs', require('./audit/auditLogRoutes'));

module.exports = router;
