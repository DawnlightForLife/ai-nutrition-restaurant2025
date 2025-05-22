// controllers/index.js
// 控制器统一出口

/**
 * 所有控制器的统一出口
 * 按照模块进行分组，方便在应用中进行统一引用
 * @module controllers
 */
// 注意：module.exports 中不能重复定义同一模块名，如 nutrition，否则前者会被后者覆盖
module.exports = {
  // 核心功能控制器
  core: {
    appConfigController: require('./core/appConfigController'),
    auditLogController: require('./core/auditLogController'),
  },
  
  // 用户相关控制器
  user: {
    adminController: require('./user/adminController'),
    authController: require('./user/authController'),
    oauthController: require('./user/oauthController'),
    permissionController: require('./user/permissionController'),
    smsController: require('./user/smsController'),
    userController: require('./user/userController'),
  },
  
  // 论坛相关控制器
  forum: {
    forumPostController: require('./forum/forumPostController'),
    forumCommentController: require('./forum/forumCommentController'),
    forumTagController: require('./forum/forumTagController'),
  },
  
  // 营养相关控制器
  nutrition: {
    nutritionProfileController: require('./nutrition/nutritionProfileController'),
    aiRecommendationController: require('./nutrition/aiRecommendationController'),
    nutritionistController: require('./nutrition/nutritionistController'),
    favoriteController: require('./nutrition/favoriteController'),
    dietaryPreferenceController: require('./nutrition/dietaryPreferenceController'),
    nutritionPlanController: require('./nutrition/nutritionPlanController'),
  },
  
  // 商家相关控制器
  merchant: {
    merchantController: require('./merchant/merchantController'),
    storeController: require('./merchant/storeController'),
    dishController: require('./merchant/dishController'),
    merchantStatsController: require('./merchant/merchantStatsController'),
    promotionController: require('./merchant/promotionController'),
  },
  
  // 订单相关控制器
  order: {
    orderController: require('./order/orderController'),
    consultationOrderController: require('./order/consultationOrderController'),
    subscriptionController: require('./order/subscriptionController'),
    paymentController: require('./order/paymentController'),
  },
  
  // 咨询相关控制器
  consult: {
    consultationController: require('./consult/consultationController'),
    chatMessageController: require('./consult/chatMessageController'),
  },
  
  // 通知相关控制器
  notification: {
    notificationController: require('./notification/notificationController'),
    userNotificationStatusController: require('./notification/userNotificationStatusController'),
  },
  
  // 安全相关控制器
  security: {
    accessTrackController: require('./security/accessTrackController'),
  },
  
  // 分析相关控制器
  analytics: {
    usageLogController: require('./analytics/usageLogController'),
    exportTaskController: require('./analytics/exportTaskController'),
  },
  
  // 反馈相关控制器
  feedback: {
    feedbackController: require('./feedback/feedbackController'),
  },
  
  // 通用功能控制器
  common: {
    fileUploadController: require('./common/fileUploadController'),
    sessionController: require('./common/sessionController'),
  },
};
