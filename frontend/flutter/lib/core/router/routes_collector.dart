/// 路由收集器
/// 
/// 统一收集各模块的路由配置
library;

import 'package:auto_route/auto_route.dart';

// 导入各模块路由
import '../../features/auth/presentation/router/auth_router.dart';
import '../../features/user/presentation/router/user_router.dart';
import '../../features/nutrition/presentation/router/nutrition_router.dart';
import '../../features/order/presentation/router/order_router.dart';
import '../../features/recommendation/presentation/router/recommendation_router.dart';
import '../../features/consultation/presentation/router/consultation_router.dart';
import '../../features/forum/presentation/router/forum_router.dart';
import '../../features/merchant/presentation/router/merchant_router.dart';
import '../../features/admin/presentation/router/admin_router.dart';
import '../../features/nutritionist/presentation/router/nutritionist_router.dart';
import '../../features/employee/presentation/router/employee_router.dart';
import '../../features/global_pages/presentation/router/global_pages_router.dart';

/// 路由收集器
/// 
/// 将各模块的路由暴露为统一的变量，供主路由使用
class RoutesCollector {
  RoutesCollector._();

  /// 认证模块路由
  static final authRoutes = AuthRouter.routes;

  /// 用户模块路由
  static final userRoutes = UserRouter.routes;

  /// 营养模块路由
  static final nutritionRoutes = NutritionRouter.routes;

  /// 订单模块路由
  static final orderRoutes = OrderRouter.routes;

  /// 推荐模块路由
  static final recommendationRoutes = RecommendationRouter.routes;

  /// 咨询模块路由
  static final consultationRoutes = ConsultationRouter.routes;

  /// 论坛模块路由
  static final forumRoutes = ForumRouter.routes;

  /// 商家模块路由
  static final merchantRoutes = MerchantRouter.routes;

  /// 管理员模块路由
  static final adminRoutes = AdminRouter.routes;

  /// 营养师模块路由
  static final nutritionistRoutes = NutritionistRouter.routes;

  /// 员工模块路由
  static final employeeRoutes = EmployeeRouter.routes;

  /// 全局页面路由
  static final globalRoutes = GlobalPagesRouter.routes;

  /// 获取所有路由（扁平化）
  static List<AutoRoute> get allRoutes => [
    ...authRoutes,
    ...userRoutes,
    ...nutritionRoutes,
    ...orderRoutes,
    ...recommendationRoutes,
    ...consultationRoutes,
    ...forumRoutes,
    ...merchantRoutes,
    ...adminRoutes,
    ...nutritionistRoutes,
    ...employeeRoutes,
    ...globalRoutes,
  ];

  /// 获取所有路由（分组）
  static Map<String, List<AutoRoute>> get groupedRoutes => {
    'auth': authRoutes,
    'user': userRoutes,
    'nutrition': nutritionRoutes,
    'order': orderRoutes,
    'recommendation': recommendationRoutes,
    'consultation': consultationRoutes,
    'forum': forumRoutes,
    'merchant': merchantRoutes,
    'admin': adminRoutes,
    'nutritionist': nutritionistRoutes,
    'employee': employeeRoutes,
    'global': globalRoutes,
  };
}