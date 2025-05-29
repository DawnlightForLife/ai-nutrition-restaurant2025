/// 路由路径常量索引
/// 集中管理所有模块的路由路径，避免硬编码
class RoutePaths {
  // Auth 模块
  static const String login = '/login';
  static const String register = '/register';
  static const String verification = '/verification';
  static const String resetPassword = '/reset-password';
  static const String profileCompletion = '/profile-completion';
  
  // User 模块
  static const String home = '/home';
  static const String profile = '/profile';
  static const String landing = '/landing';
  static const String userList = '/users';
  
  // Nutrition 模块
  static const String nutritionProfiles = '/nutrition/profiles';
  static const String nutritionProfile = '/nutrition/profile';
  static const String nutritionAiChat = '/nutrition/ai-chat';
  static const String nutritionAiResult = '/nutrition/ai-result';
  static const String nutritionRecommendation = '/nutrition/recommendation';
  
  // Merchant 模块
  static const String merchantDashboard = '/merchant/dashboard';
  static const String merchantList = '/merchant/list';
  
  // Nutritionist 模块
  static const String nutritionistDashboard = '/nutritionist/dashboard';
  static const String nutritionistList = '/nutritionist/list';
  
  // Admin 模块
  static const String adminDashboard = '/admin/dashboard';
  static const String adminList = '/admin/list';
  
  // Employee 模块
  static const String employeeWorkspace = '/employee/workspace';
  
  // Forum 模块
  static const String forum = '/forum';
  static const String forumPosts = '/forum/posts';
  static const String forumPost = '/forum/post';
  static const String forumCreatePost = '/forum/create-post';
  
  // Order 模块
  static const String orders = '/orders';
  
  // Recommendation 模块
  static const String recommendations = '/recommendations';
  static const String recommendation = '/recommendation';
  
  // Consultation 模块
  static const String consultations = '/consultations';
  
  // Global Pages
  static const String splash = '/';
  static const String about = '/about';
  static const String privacyPolicy = '/privacy-policy';
}