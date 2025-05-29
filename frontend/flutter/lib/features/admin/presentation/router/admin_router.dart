import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/guards.dart';
import '../../../../shared/enums/user_role.dart';

/// Admin 模块路由配置
class AdminRouter {
  /// 获取 Admin 模块的所有路由
  static List<AutoRoute> get routes => [
    // 管理员仪表板
    AutoRoute(
      page: AdminDashboardRoute.page,
      path: '/admin/dashboard',
      guards: [AuthGuard(), RoleGuard([UserRole.admin])],
    ),
    
    // 管理员列表
    AutoRoute(
      page: AdminListRoute.page,
      path: '/admin/list',
      guards: [AuthGuard(), RoleGuard([UserRole.admin])],
    ),
  ];
  
  /// 路由名称常量
  static const String dashboardPath = '/admin/dashboard';
  static const String listPath = '/admin/list';
}