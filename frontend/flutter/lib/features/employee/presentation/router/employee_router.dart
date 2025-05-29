import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/guards.dart';
import '../../../../shared/enums/user_role.dart';

/// Employee 模块路由配置
class EmployeeRouter {
  /// 获取 Employee 模块的所有路由
  static List<AutoRoute> get routes => [
    // 员工工作台
    AutoRoute(
      page: EmployeeWorkspaceRoute.page,
      path: '/employee/workspace',
      guards: [AuthGuard(), RoleGuard([UserRole.employee])],
    ),
  ];
  
  /// 路由名称常量
  static const String workspacePath = '/employee/workspace';
}