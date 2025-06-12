/// 路由名称常量定义
class RouteNames {
  // 认证相关
  static const String splash = '/';
  static const String login = '/login';
  static const String verification = '/verification';
  static const String onboarding = '/onboarding';
  
  // 主导航
  static const String main = '/main';
  static const String home = '/home';
  static const String search = '/search';
  static const String recommendation = '/recommendation';
  static const String forum = '/forum';
  static const String order = '/order';
  static const String profile = '/profile';
  
  // 营养档案
  static const String nutritionProfileList = '/nutrition/profiles';
  static const String nutritionProfileDetail = '/nutrition/profile';
  static const String nutritionProfileEditor = '/nutrition/profile/edit';
  
  // AI推荐
  static const String aiChat = '/ai/chat';
  static const String aiResult = '/ai/result';
  static const String recommendationList = '/recommendations';
  static const String recommendationDetail = '/recommendation/detail';
  
  // 订单流程
  static const String cart = '/cart';
  static const String orderConfirm = '/order/confirm';
  static const String payment = '/payment';
  static const String paymentResult = '/payment/result';
  static const String orderDetail = '/order/detail';
  static const String deliveryTracking = '/delivery/tracking';
  static const String pickupCode = '/pickup/code';
  
  // 商家相关
  static const String storeDisplay = '/store';
  static const String dishDetail = '/dish';
  
  // 用户中心
  static const String settings = '/settings';
  static const String accountSecurity = '/account/security';
  static const String addressManager = '/addresses';
  static const String addressEditor = '/address/edit';
  static const String notificationCenter = '/notifications';
  static const String helpCenter = '/help';
  static const String favorites = '/favorites';
  
  // 论坛
  static const String forumPostDetail = '/forum/post';
  static const String createPost = '/forum/create';
  static const String myPosts = '/forum/my-posts';
  
  
  // 营养师端
  static const String nutritionistMain = '/nutritionist';
  static const String consultationChat = '/consultation/chat';
  static const String consultationMarket = '/consultation/market';
  static const String clientList = '/nutritionist/clients';
  static const String clientDetail = '/nutritionist/client';
  
  // 营养师认证
  static const String nutritionistCertification = '/nutritionist/certification';
  static const String nutritionistCertificationStatus = '/nutritionist/certification/status';
  static const String nutritionistCertificationEdit = '/nutritionist/certification/edit';
  
  // 商家端
  static const String merchantMain = '/merchant';
  static const String merchantApplication = '/merchant/application';
  static const String merchantApplicationStatus = '/merchant/application-status';
  static const String dishManagement = '/merchant/dishes';
  static const String dishEditor = '/merchant/dish/edit';
  static const String inventory = '/merchant/inventory';
  static const String businessStats = '/merchant/stats';
  
  // 员工端
  static const String employeeEntry = '/employee';
  static const String quickOrder = '/employee/order';
  static const String buildProfile = '/employee/profile';
  
  // 会员与活动
  static const String membership = '/membership';
  static const String pointsMall = '/points';
  static const String couponCenter = '/coupons';
  static const String flashSale = '/flash-sale';
  static const String groupBuy = '/group-buy';
  
  // 管理后台
  static const String adminDashboard = '/admin/dashboard';
  static const String adminLogin = '/admin/login';
  static const String adminVerification = '/admin/verification';
  static const String permissionManagement = '/admin/permission-management';
  static const String systemConfig = '/admin/system-config';
  static const String merchantApproval = '/admin/merchant-approval';
  static const String merchantDetail = '/admin/merchant/detail';
  static const String merchantStats = '/admin/merchant-stats';
  static const String nutritionistStats = '/admin/nutritionist-stats';
  static const String adminManagement = '/admin/admin-management';
}