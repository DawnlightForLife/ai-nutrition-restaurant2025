module.exports = {
  // core
  adminService: require('./core/adminService'),
  auditLogService: require('./core/auditLogService'),
  oauthService: require('./core/oauthService'),
  userRoleService: require('./core/userRoleService'),
  userService: require('./core/userService'),

  // forum
  forumPostService: require('./forum/forumPostService'),
  forumCommentService: require('./forum/forumCommentService'),

  // health
  nutritionProfileService: require('./health/nutritionProfileService'),
  healthDataService: require('./health/healthDataService'),
  healthMetricsService: require('./health/healthMetricsService'),
  healthGoalService: require('./health/healthGoalService'),
  dietaryPreferenceService: require('./health/dietaryPreferenceService'),

  // merchant
  merchantService: require('./merchant/merchantService'),
  storeService: require('./merchant/storeService'),
  storeDishService: require('./merchant/storeDishService'),
  merchantStatsService: require('./merchant/merchantStatsService'),
  dishService: require('./merchant/dishService'),

  // misc
  notificationService: require('./misc/notificationService'),
  appConfigService: require('./misc/appConfigService'),
  dataAccessControlService: require('./misc/dataAccessControlService'),

  // nutrition
  aiRecommendationService: require('./nutrition/aiRecommendationService'),
  nutritionistService: require('./nutrition/nutritionistService'),
  userFavoriteService: require('./nutrition/userFavoriteService'),
  nutritionPlanService: require('./nutrition/nutritionPlanService'),

  // order
  orderService: require('./order/orderService'),
  subscriptionService: require('./order/subscriptionService'),
  consultationService: require('./order/consultationService'),
};