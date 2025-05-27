import 'package:auto_route/auto_route.dart';

import '../di/service_locator.dart';
import '../../domain/abstractions/services/i_auth_service.dart';
import 'app_router.dart';

/// 认证守卫 - 保护需要登录的页面
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authService = getIt<IAuthService>();
    
    if (authService.isLoggedIn) {
      // 用户已登录，允许导航
      resolver.next();
    } else {
      // 用户未登录，重定向到登录页面
      router.replaceAll([const LoginRoute()]);
    }
  }
}

/// 访客守卫 - 已登录用户不能访问的页面（如登录、注册页面）
class GuestGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authService = getIt<IAuthService>();
    
    if (!authService.isLoggedIn) {
      // 用户未登录，允许访问
      resolver.next();
    } else {
      // 用户已登录，重定向到首页
      router.replaceAll([const HomeRoute()]);
    }
  }
}

/// 首次启动守卫 - 检查是否需要显示引导页面
class OnboardingGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    // 这里可以检查SharedPreferences中的首次启动标记
    // 简化实现，假设总是需要引导
    resolver.next();
  }
}