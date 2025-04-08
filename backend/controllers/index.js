// controllers/index.js
// 控制器统一出口

/**
 * 所有控制器的统一出口
 * 按照模块进行分组，方便在应用中进行统一引用
 * @module controllers
 */
module.exports = {
  core: {
    authController: require('./core/authController'),
    userController: require('./core/userController'),
    adminController: require('./core/adminController'),
    permissionController: require('./core/permissionController'),
  },
  forum: {
    forumPostController: require('./forum/forumPostController'),
    forumCommentController: require('./forum/forumCommentController'),
  },
  health: {
    nutritionProfileController: require('./health/nutritionProfileController'),
    healthDataController: require('./health/healthDataController'),
  },
  merchant: {
    merchantController: require('./merchant/merchantController'),
    storeController: require('./merchant/storeController'),
    dishController: require('./merchant/dishController'),
    merchantStatsController: require('./merchant/merchantStatsController'),
  },
  misc: {
    notificationController: require('./misc/notificationController'),
    appConfigController: require('./misc/appConfigController'),
  },
  nutrition: {
    aiRecommendationController: require('./nutrition/aiRecommendationController'),
    nutritionistController: require('./nutrition/nutritionistController'),
    favoriteController: require('./nutrition/favoriteController'),
  },
  order: {
    orderController: require('./order/orderController'),
    consultationController: require('./order/consultationController'),
    subscriptionController: require('./order/subscriptionController'),
  },
  audit: {
    auditLogController: require('./audit/auditLogController'),
  },
};
