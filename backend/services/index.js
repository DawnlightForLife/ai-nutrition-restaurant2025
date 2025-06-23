module.exports = {
  // core
  systemConfigService: require('./core/systemConfigService'),
  appConfigService: require('./core/appConfigService'),
  auditLogService: require('./core/auditLogService'),
  
  // user
  userService: require('./user/userService'),
  userRoleService: require('./user/userRoleService'),
  adminService: require('./user/adminService'),
  authService: require('./user/authService'),
  oauthService: require('./user/oauthService'),
  

  // forum
  forumPostService: require('./forum/forumPostService'),
  forumCommentService: require('./forum/forumCommentService'),

  // nutrition
  nutritionProfileService: require('./nutrition/nutritionProfileService'),
  dietaryPreferenceService: require('./nutrition/dietaryPreferenceService'),
  aiRecommendationService: require('./nutrition/aiRecommendationService'),
  nutritionistService: require('./nutrition/nutritionistService'),
  nutritionistClientService: require('./nutrition/nutritionistClientService'),
  nutritionistStatsService: require('./nutrition/nutritionistStatsService'),
  userFavoriteService: require('./nutrition/FavoriteService'),
  nutritionPlanService: require('./nutrition/nutritionPlanService'),
  
  // ai
  aiNutritionService: require('./ai/aiNutritionService'),

  // merchant
  merchantService: require('./merchant/merchantService'),
  storeService: require('./merchant/storeService'),
  storeDishService: require('./merchant/storeDishService'),
  merchantStatsService: require('./merchant/merchantStatsService'),
  dishService: require('./merchant/dishService'),

  // order
  orderService: require('./order/orderService'),
  subscriptionService: require('./order/subscriptionService'),

  // consult
  consultationService: require('./consult/consultationService'),
  consultationMarketService: require('./consult/consultationMarketService'),

  // notification
  notificationService: require('./notification/notificationService'),

  // feedback
  feedbackService: require('./feedback/feedbackService'),

  // promotion
  promotionService: require('./merchant/promotionService'),

  // analytics
  usageLogService: require('./analytics/usageLogService'),
  exportTaskService: require('./analytics/exportTaskService'),

  // security
  accessTrackingService: require('./security/accessTrackService'),
  fieldEncryptionService: require('./security/fieldEncryptionService'),
  dataAccessControlService: require('./security/dataAccessControlService'),

  // core
  appConfigService: require('./core/appConfigService'),
  auditLogService: require('./core/auditLogService'),

  // database
  shardAccessService: require('./database/shardAccessService'),
  shardAdvisorService: require('./database/shardAdvisorService'),
  adaptiveShardingService: require('../services/database/adaptiveShardingService'),
  connectionPoolManager: require('./database/connectionPoolManager'),
  asyncConnectionPoolManager: require('./database/asyncConnectionPoolManager'),
  readConsistencyService: require('./database/readConsistencyService'),
  transactionService: require('./database/transactionService'),
  distributedTransactionService: require('./database/distributedTransactionService'),
  dbProxyService: require('./database/dbProxyService'),

  // cache
  cacheService: require('./cache/cacheService'),
  enhancedCacheService: require('./cache/enhancedCacheService'),
  cacheManager: require('./cache/cacheManager'),

  // model
  dynamicModelLoaderService: require('./model/dynamicModelLoaderService'),
  modelIntegrationService: require('./model/modelIntegrationService'),
  schemaAnalysisService: require('./model/schemaAnalysisService'),
  schemaGuardService: require('./model/schemaGuardService'),
  schemaJsonConverter: require('./model/schemaJsonConverter'),
  schemaTransformer: require('../utils/schema/schemaTransformer'),
  migrationManagerService: require('./model/migrationManagerService'),

  // performance
  dbOptimizationManager: require('./performance/dbOptimizationManager'),
  circuitBreakerService: require('./performance/circuitBreakerService'),
  retryStrategyService: require('./performance/retryStrategyService'),
  batchProcessService: require('./performance/batchProcessService'),
  performanceMonitoringService: require('./performance/performanceMonitoringService'),

  // messaging
  emailService: require('./messaging/emailService'),
  smsService: require('./messaging/smsService'),

  // dev
  schemaDevToolService: require('./dev/schemaDevToolService'),

  // monitoring
  alertSystem: require('./monitoring/alertSystem'),
};