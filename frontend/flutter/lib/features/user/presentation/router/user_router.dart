import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/guards.dart';

/// User 模块路由配置
class UserRouter {
  /// 获取 User 模块的所有路由
  static List<AutoRoute> get routes => [
    // 用户主页
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
      guards: [AuthGuard()],
    ),
    
    // 用户个人资料页
    AutoRoute(
      page: ProfileRoute.page,
      path: '/profile',
      guards: [AuthGuard()],
    ),
    
    // 着陆页（未登录用户）
    AutoRoute(
      page: LandingRoute.page,
      path: '/landing',
    ),
    
    // 用户列表（管理功能）
    AutoRoute(
      page: UserListRoute.page,
      path: '/users',
      guards: [AuthGuard()],
    ),
  ];
  
  /// 路由名称常量
  static const String homePath = '/home';
  static const String profilePath = '/profile';
  static const String landingPath = '/landing';
  static const String userListPath = '/users';
}