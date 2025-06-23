const express = require('express');
const router = express.Router();

/**
 * 路由注册中心
 * 集中管理所有模块的路由挂载路径
 * 每个模块按功能分类挂载子路由
 * @module routes/index
 */

// =================== Core 模块 ===================
router.use('/app-config', require('./core/appConfigRoutes'));
router.use('/audit-logs', require('./core/auditLogRoutes'));
router.use('/system-config', require('./core/systemConfigRoutes'));

// =================== User 模块 ===================
router.use('/auth', require('./user/authRoutes'));
router.use('/users', require('./user/userRoutes'));
router.use('/admin', require('./user/adminRoutes'));
router.use('/permissions', require('./user/permissionRoutes'));
router.use('/user-permissions', require('./user/userPermissionRoutes'));
router.use('/oauth', require('./user/oauthRoutes'));
router.use('/sms', require('./user/smsRoutes'));
router.use('/guest-profiles', require('./user/guestProfileRoutes'));
router.use('/points', require('./user/pointsRoutes'));

// =================== Forum 模块 ===================
router.use('/forum-posts', require('./forum/forumPostRoutes'));
router.use('/forum-comments', require('./forum/forumCommentRoutes'));
router.use('/forum-tags', require('./forum/forumTagRoutes'));

// =================== Nutrition 模块 ===================
// 营养档案相关
router.use('/nutrition/nutrition-profiles', require('./nutrition/nutritionProfileRoutes'));
router.use('/nutrition/nutrition-profiles-extended', require('./nutrition/nutritionProfileExtendedRoutes'));
router.use('/nutrition/constants', require('./nutrition/nutritionConstantsRoutes'));

// 营养元素系统v2 - 新增
router.use('/nutrition/elements', require('./nutrition/nutritionElementRoutes'));

// AI推荐和营养师
router.use('/ai-recommendations', require('./nutrition/aiRecommendationRoutes'));
router.use('/nutritionists', require('./nutrition/nutritionistRoutes'));
router.use('/nutritionist-certification', require('./nutrition/nutritionistCertificationRoutes'));
router.use('/nutritionist-clients', require('./nutrition/nutritionistClientRoutes'));
router.use('/nutritionist-stats', require('./nutrition/nutritionistStatsRoutes'));

// 营养师工作台
router.use('/nutritionist/workbench', require('./nutritionist/workbenchRoutes'));

// 用户偏好和计划
router.use('/favorites', require('./nutrition/favoriteRoutes'));
router.use('/dietary-preferences', require('./nutrition/dietaryPreferenceRoutes'));
router.use('/nutrition-plans', require('./nutrition/nutritionPlanRoutes'));

// =================== Merchant 模块 ===================
router.use('/merchants', require('./merchant/merchantRoutes'));
router.use('/stores', require('./merchant/storeRoutes'));
router.use('/dishes', require('./merchant/dishRoutes'));
router.use('/merchant-stats', require('./merchant/merchantStatsRoutes'));
router.use('/promotions', require('./merchant/promotionRoutes'));

// =================== 增强商家管理功能 ===================
router.use('/merchant/dishes-enhanced', require('./merchant/dishRoutesEnhanced'));
router.use('/merchant/inventory', require('./merchant/inventoryRoutes'));
router.use('/merchant/orders', require('./merchant/orderProcessingRoutes'));

// =================== Restaurant 模块 ===================
router.use('/', require('./restaurant/restaurantRoutes'));

// =================== Order 模块 ===================
router.use('/orders', require('./order/orderRoutes'));
router.use('/consultation-orders', require('./order/consultationOrderRoutes'));
router.use('/subscriptions', require('./order/subscriptionRoutes'));
router.use('/payments', require('./order/paymentRoutes'));
router.use('/pickup-codes', require('./order/pickupCodeRoutes'));

// =================== Consult 模块 ===================
router.use('/consultations', require('./consult/consultationRoutes'));
router.use('/consultations', require('./consult/consultationMarketRoutes'));
router.use('/chat-messages', require('./consult/chatMessageRoutes'));

// =================== Notification 模块 ===================
router.use('/notifications', require('./notification/notificationRoutes'));
router.use('/user-notification-status', require('./notification/userNotificationStatusRoutes'));

// =================== Security 模块 ===================
router.use('/access-track', require('./security/accessTrackRoutes'));
router.use('/content-reports', require('./security/contentReportRoutes'));

// =================== Analytics 模块 ===================
router.use('/usage-logs', require('./analytics/usageLogRoutes'));
router.use('/export-tasks', require('./analytics/exportTaskRoutes'));

// =================== Feedback 模块 ===================
router.use('/feedback', require('./feedback/feedbackRoutes'));

// =================== Common 模块 ===================
router.use('/file-uploads', require('./common/fileUploadRoutes'));
router.use('/sessions', require('./common/sessionRoutes'));


// =================== 其他模块 ===================

// =================== Admin 模块 ===================
router.use('/admin/nutritionist-certification-review', require('./admin/nutritionistCertificationReviewRoutes'));
router.use('/admin/nutritionist-management', require('./admin/nutritionistManagementRoutes'));
router.use('/admin/user-permissions', require('./admin/userPermissionRoutes'));
router.use('/admin/merchant-stats', require('./admin/merchantStatsRoutes'));
router.use('/admin/nutritionist-stats', require('./admin/nutritionistStatsRoutes'));

// =================== Dev 工具模块（仅开发环境启用） ===================
if (process.env.NODE_ENV === 'development') {
  router.use('/dev/schema-admin', require('./dev/schemaAdminRoutes'));
  router.use('/dev/schema-explorer', require('./dev/schemaExplorerRoutes'));
  router.use('/dev/schema-visualization', require('./dev/schemaVisualizationRoutes'));
  router.use('/dev/model-hot-update', require('./dev/modelHotUpdateRoutes'));
  router.use('/dev/auth', require('./dev/devAuthRoutes'));
}

module.exports = router;
