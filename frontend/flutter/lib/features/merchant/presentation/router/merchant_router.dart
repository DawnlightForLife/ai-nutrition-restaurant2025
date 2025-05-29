import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/guards.dart';
import '../../../../shared/enums/user_role.dart';

/// Merchant 模块路由配置
class MerchantRouter {
  /// 获取 Merchant 模块的所有路由
  static List<AutoRoute> get routes => [
    // 商家仪表板
    AutoRoute(
      page: MerchantDashboardRoute.page,
      path: '/merchant/dashboard',
      guards: [AuthGuard(), RoleGuard([UserRole.merchant])],
    ),
    
    // 商家列表
    AutoRoute(
      page: MerchantListRoute.page,
      path: '/merchant/list',
      guards: [AuthGuard()],
    ),
  ];
  
  /// 路由名称常量
  static const String dashboardPath = '/merchant/dashboard';
  static const String listPath = '/merchant/list';
}