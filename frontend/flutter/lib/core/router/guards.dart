import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/domain/enums/user_role.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'app_router.dart';

/// 认证守卫
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final container = ProviderContainer();
    final isAuthenticated = container.read(authStateProvider).isAuthenticated;
    
    if (isAuthenticated) {
      resolver.next(true);
    } else {
      router.push(const LoginRoute());
    }
  }
}

/// 角色权限守卫
class RoleGuard extends AutoRouteGuard {
  final List<UserRole> requiredRoles;
  
  RoleGuard(this.requiredRoles);
  
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final container = ProviderContainer();
    final authState = container.read(authStateProvider);
    
    if (!authState.isAuthenticated) {
      router.push(const LoginRoute());
      return;
    }
    
    final user = authState.user;
    if (user == null) {
      resolver.next(false);
      return;
    }
    
    // 检查用户是否有任一所需角色
    final hasRequiredRole = requiredRoles.any((role) => user.hasRole(role));
    
    if (hasRequiredRole) {
      resolver.next(true);
    } else {
      // 没有权限，返回首页
      router.push(const HomeRoute());
    }
  }
}