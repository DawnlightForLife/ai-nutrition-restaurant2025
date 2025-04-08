/// API常量类
///
/// 包含应用中所有的API路径常量，便于统一管理和修改
class ApiConstants {
  // 基础URL
  static const String baseUrl = 'https://api.nutritionapp.com/api';

  // 认证相关
  static const String auth = '/auth';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // 用户相关
  static const String users = '/users';
  static const String user = '/users';
  static const String userProfile = '/users/profile';
  static const String userPreferences = '/users/preferences';
  static const String userNotifications = '/users/notifications';

  // 论坛相关
  static const String forumPost = '/forum/posts';
  static const String forumComment = '/forum/comments';
  static const String forumCategory = '/forum/categories';
  static const String forumTag = '/forum/tags';

  // 营养师相关
  static const String nutritionist = '/nutritionists';
  static const String nutritionistAvailability = '/nutritionists/availability';
  static const String nutritionistReviews = '/nutritionists/reviews';

  // 咨询相关
  static const String consultation = '/consultations';
  static const String consultationTopics = '/consultations/topics';
  static const String userConsultations = '/consultations/user';
  static const String consult = '/consultations'; // 兼容旧代码
  
  // 营养相关
  static const String nutritionPlan = '/nutrition/plans';
  static const String nutritionGoal = '/nutrition/goals';
  static const String nutritionProfile = '/nutrition/profiles';
  static const String nutritionRecommendation = '/nutrition/recommendations';
  static const String recommendation = '/nutrition/recommendations'; // 兼容旧代码

  // 健康相关
  static const String healthData = '/health/data';
  static const String healthMetrics = '/health/metrics';
  static const String healthGoals = '/health/goals';
  static const String healthActivities = '/health/activities';

  // 商家相关
  static const String merchant = '/merchants';
  static const String store = '/stores';
  static const String product = '/products';
  static const String dish = '/dishes';
  static const String category = '/categories';
  
  // 订单相关
  static const String order = '/orders';
  static const String payment = '/payments';
  static const String delivery = '/deliveries';
  static const String cart = '/cart';
  
  // 搜索相关
  static const String search = '/search';
  static const String filter = '/filter';
  
  // 评价相关
  static const String review = '/reviews';
  static const String rating = '/ratings';
  
  // 收藏相关
  static const String favorite = '/favorites';
  static const String bookmark = '/bookmarks';

  // 系统相关
  static const String config = '/config';
  static const String version = '/version';
  static const String feedback = '/feedback';
  static const String support = '/support';
  
  // AI相关
  static const String aiAnalysis = '/ai/analysis';
}
