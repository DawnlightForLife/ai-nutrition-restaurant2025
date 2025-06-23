/// API端点常量定义
class ApiEndpoints {
  // 基础路径 (不包含/api前缀，因为ApiClient的baseUrl已经包含了)
  static const String auth = '/auth';
  static const String users = '/users';
  static const String merchants = '/merchants';
  static const String dishes = '/dishes';
  static const String orders = '/orders';
  static const String nutrition = '/nutrition';
  static const String recommendations = '/recommendations';
  static const String notifications = '/notifications';
  static const String forum = '/forum';
  static const String feedback = '/feedback';
  static const String admin = '/admin';
  static const String nutritionistCertification = '/nutritionist-certification';
  static const String systemConfig = '/system-config';
  
  // 认证相关
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String sendCode = '$auth/send-code';
  static const String verifyCode = '$auth/verify-code';
  static const String refreshToken = '$auth/refresh';
  static const String logout = '$auth/logout';
  static const String me = '$auth/me';
  
  // 用户相关
  static const String userProfile = '$users/profile';
  static const String updateProfile = '$users/profile';
  static const String uploadAvatar = '$users/avatar';
  static const String changePassword = '$users/password';
  
  // 商家相关
  static const String merchantList = merchants;
  static const String merchantStats = '$merchants/stats';
  static const String merchantDetail = '$merchants/{id}';
  static const String merchantVerify = '$merchants/{id}/verify';
  static const String myMerchant = '$merchants/my';
  
  // 菜品相关
  static const String dishList = dishes;
  static const String dishDetail = '$dishes/{id}';
  static const String dishByMerchant = '$dishes/merchant/{merchantId}';
  static const String dishCategories = '$dishes/categories';
  
  // 订单相关
  static const String orderList = orders;
  static const String createOrder = orders;
  static const String orderDetail = '$orders/{id}';
  static const String orderCancel = '$orders/{id}/cancel';
  static const String orderPay = '$orders/{id}/pay';
  static const String orderComplete = '$orders/{id}/complete';
  
  // 营养相关
  static const String nutritionProfiles = '$nutrition/profiles';
  static const String nutritionProfileDetail = '$nutrition/profiles/{id}';
  static const String createNutritionProfile = '$nutrition/profiles';
  static const String updateNutritionProfile = '$nutrition/profiles/{id}';
  static const String deleteNutritionProfile = '$nutrition/profiles/{id}';
  
  // AI推荐相关
  static const String aiRecommend = '$recommendations/ai';
  static const String recommendationHistory = '$recommendations/history';
  static const String recommendationFeedback = '$recommendations/{id}/feedback';
  
  // 通知相关
  static const String notificationList = notifications;
  static const String markNotificationRead = '$notifications/{id}/read';
  static const String markAllNotificationsRead = '$notifications/read-all';
  
  // 营养师认证相关
  static const String nutritionistCertificationApplications = '$nutritionistCertification/applications';
  static const String nutritionistCertificationDetail = '$nutritionistCertification/applications/{id}';
  static const String nutritionistCertificationSubmit = '$nutritionistCertification/applications/{id}/submit';
  static const String nutritionistCertificationResubmit = '$nutritionistCertification/applications/{id}/resubmit';
  static const String nutritionistCertificationConstants = '$nutritionistCertification/constants';

  // 管理员相关
  static const String adminStats = '$admin/stats';
  static const String adminUsers = '$admin/users';
  static const String adminMerchants = '$admin/merchants';
  static const String adminOrders = '$admin/orders';
  static const String adminReports = '$admin/reports';
  static const String adminNutritionistManagement = '$admin/nutritionist-management';
  static const String adminNutritionistStats = '$admin/nutritionist-stats';
  static const String adminCertificationReview = '$admin/nutritionist-certification-review';
  
  // 系统配置相关
  static const String systemConfigPublic = '$systemConfig/public';
  static const String systemConfigCertification = '$systemConfig/certification';
}