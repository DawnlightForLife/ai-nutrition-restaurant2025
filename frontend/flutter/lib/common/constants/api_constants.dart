// =================================================================
// API路径常量类
// =================================================================
// 本文件定义了应用中所有API请求的路径常量，以便统一管理和修改。
//
// API路径命名规范:
// 1. 常量名应使用驼峰命名法，且应该是描述性的（如：userProfile, nutritionPlans）
// 2. 常量名通常使用复数形式表示集合资源，除非表示单一特定资源
// 3. 路径应与后端路由保持完全一致，参考backend/routes/index.js和各模块路由文件
//
// API路径格式规范:
// 1. 所有API路径常量必须以'/'开头
// 2. 不要在路径中包含'/api'前缀，它将由ApiService自动添加
// 3. 路径必须与后端路由匹配，确保使用'-'而不是'_'作为路径中的单词分隔符
// 4. 不同版本的API应使用单独的常量（如：v1UserProfile, v2UserProfile）
//
// 使用规范:
// 1. 直接使用常量: ApiService.get(ApiConstants.users)
// 2. 参数拼接: ApiService.get(ApiConstants.users + '/' + userId)
// 3. 禁止硬编码路径: ❌ ApiService.get('/users/' + userId)
// 4. 新增API请求时，必须在此文件中添加相应的常量
// 5. 若需要废弃某一路径，请使用@Deprecated注解并保留旧常量
// 6. 使用兼容性路径时应优先尝试标准路径，失败后再尝试兼容路径
//
// 项目API命名空间结构:
// - /auth/*: 认证相关API
// - /users/*: 用户相关API
// - /forum-posts/*, /forum-comments/*: 论坛相关API
// - /nutrition-profiles/*, /health-data/*: 健康档案相关API
// - /merchants/*, /stores/*, /dishes/*: 商家相关API
// - /orders/*, /consultations/*: 订单和咨询相关API
// =================================================================

/// API常量类
///
/// 包含应用中所有的API路径常量，便于统一管理和修改
/// 使用规范：
/// 1. 所有API路径常量必须以'/'开头
/// 2. 不要在路径中包含'/api'前缀，它将由ApiService自动添加
/// 3. 在需要拼接ID的地方，直接拼接即可，如: ApiConstants.users + '/' + userId
class ApiConstants {
  // 基础URL（仅供参考，实际由ApiService使用配置的baseUrl）
  static const String baseUrlReference = 'http://10.0.2.2:8080/api';

  // ======== 认证相关 ========
  static const String auth = '/auth';
  static const String login = '/auth/login';
  static const String loginWithCode = '/auth/login-with-code';
  static const String loginWithCodeLegacy = '/auth/login/code'; // 兼容旧版前端路径
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String verifyToken = '/auth/verify-token';
  static const String sendCode = '/auth/send-code';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // ======== 用户相关 ========
  static const String users = '/users';
  static const String userProfile = '/users/profile';
  static const String userPreferences = '/users/preferences';
  static const String userNotifications = '/users/notifications';

  // ======== 论坛相关 ========
  static const String forumPosts = '/forum-posts';
  static const String forumComments = '/forum-comments';
  static const String forumCategories = '/forum/categories';
  static const String forumTags = '/forum/tags';

  // ======== 营养师相关 ========
  static const String nutritionists = '/nutritionists';
  static const String nutritionistAvailability = '/nutritionists/availability';
  static const String nutritionistReviews = '/nutritionists/reviews';

  // ======== 咨询相关 ========
  static const String consultations = '/consultations';
  static const String consultationTopics = '/consultations/topics';
  static const String userConsultations = '/consultations/user';

  // ======== 营养相关 ========
  static const String nutritionPlans = '/nutrition/plans';
  static const String nutritionGoals = '/nutrition/goals';
  static const String nutritionProfiles = '/health/nutrition-profiles';
  static const String aiRecommendations = '/ai-recommendations';

  // ======== 健康相关 ========
  static const String healthData = '/health-data';
  static const String healthMetrics = '/health/metrics';
  static const String healthGoals = '/health/goals';
  static const String healthActivities = '/health/activities';

  // ======== 商家相关 ========
  static const String merchants = '/merchants';
  static const String stores = '/stores';
  static const String products = '/products';
  static const String dishes = '/dishes';
  static const String categories = '/categories';
  static const String merchantStats = '/merchant-stats';

  // ======== 订单相关 ========
  static const String orders = '/orders';
  static const String payments = '/payments';
  static const String deliveries = '/deliveries';
  static const String cart = '/cart';
  static const String subscriptions = '/subscriptions';

  // ======== 搜索相关 ========
  static const String search = '/search';
  static const String filter = '/filter';

  // ======== 评价相关 ========
  static const String reviews = '/reviews';
  static const String ratings = '/ratings';

  // ======== 收藏相关 ========
  static const String favorites = '/favorites';
  static const String bookmarks = '/bookmarks';

  // ======== 系统相关 ========
  static const String appConfig = '/app-config';
  static const String notifications = '/notifications';
  static const String version = '/version';
  static const String feedback = '/feedback';
  static const String support = '/support';

  // ======== AI相关 ========
  static const String aiAnalysis = '/ai/analysis';

  // ======== 审计相关 ========
  static const String auditLogs = '/audit-logs';

  // ======== 兼容旧代码的别名（不要在新代码中使用）========
  // 以下常量仅用于兼容旧代码，新代码请使用上面的标准常量
  @Deprecated('请使用forumPosts')
  static const String forumPost = forumPosts;

  @Deprecated('请使用forumComments')
  static const String forumComment = forumComments;

  @Deprecated('请使用consultations')
  static const String consult = consultations;

  @Deprecated('请使用aiRecommendations')
  static const String recommendation = aiRecommendations;

  @Deprecated('请使用nutritionProfiles')
  static const String nutritionProfile = nutritionProfiles;

  @Deprecated('请使用users')
  static const String user = users;

  @Deprecated('请使用merchants')
  static const String merchant = merchants;

  @Deprecated('请使用stores')
  static const String store = stores;

  @Deprecated('请使用products')
  static const String product = products;

  @Deprecated('请使用dishes')
  static const String dish = dishes;

  @Deprecated('请使用categories')
  static const String category = categories;

  @Deprecated('请使用orders')
  static const String order = orders;

  @Deprecated('请使用nutritionists')
  static const String nutritionist = nutritionists;

  @Deprecated('请使用nutritionPlans')
  static const String nutritionPlan = nutritionPlans;

  @Deprecated('请使用nutritionGoals')
  static const String nutritionGoal = nutritionGoals;

  @Deprecated('请使用aiRecommendations')
  static const String nutritionRecommendation = aiRecommendations;
}
