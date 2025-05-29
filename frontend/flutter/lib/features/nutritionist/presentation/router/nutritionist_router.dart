import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/guards.dart';
import '../../../../shared/enums/user_role.dart';

/// Nutritionist 模块路由配置
class NutritionistRouter {
  /// 获取 Nutritionist 模块的所有路由
  static List<AutoRoute> get routes => [
    // 营养师仪表板
    AutoRoute(
      page: NutritionistDashboardRoute.page,
      path: '/nutritionist/dashboard',
      guards: [AuthGuard(), RoleGuard([UserRole.nutritionist])],
    ),
    
    // 营养师列表
    AutoRoute(
      page: NutritionistListRoute.page,
      path: '/nutritionist/list',
      guards: [AuthGuard()],
    ),
  ];
  
  /// 路由名称常量
  static const String dashboardPath = '/nutritionist/dashboard';
  static const String listPath = '/nutritionist/list';
}