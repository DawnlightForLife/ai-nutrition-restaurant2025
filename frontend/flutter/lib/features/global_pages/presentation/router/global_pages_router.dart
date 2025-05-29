import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';

/// Global Pages 模块路由配置
class GlobalPagesRouter {
  /// 获取 Global Pages 模块的所有路由
  static List<AutoRoute> get routes => [
    // 关于页面
    AutoRoute(
      page: AboutRoute.page,
      path: '/about',
    ),
    
    // 隐私政策页面
    AutoRoute(
      page: PrivacyPolicyRoute.page,
      path: '/privacy-policy',
    ),
    
    // 初始启动页
    AutoRoute(
      page: SplashRoute.page,
      path: '/',
      initial: true,
    ),
  ];
  
  /// 路由名称常量
  static const String aboutPath = '/about';
  static const String privacyPolicyPath = '/privacy-policy';
  static const String splashPath = '/';
}