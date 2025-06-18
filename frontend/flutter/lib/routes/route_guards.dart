import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../core/constants/permissions.dart';
import 'route_names.dart';

/// 路由守卫
/// 用于检查路由访问权限
class RouteGuards {
  /// 需要登录的路由
  static const Set<String> authRequiredRoutes = {
    RouteNames.main,
    RouteNames.nutritionProfileList,
    RouteNames.nutritionProfileDetail,
    RouteNames.nutritionProfileEditor,
    RouteNames.aiChat,
    RouteNames.cart,
    RouteNames.orderConfirm,
    RouteNames.payment,
    RouteNames.profile,
    RouteNames.settings,
    RouteNames.addressManager,
    RouteNames.notificationCenter,
    RouteNames.favorites,
    RouteNames.myPosts,
    RouteNames.nutritionistMain,
    RouteNames.merchantMain,
    RouteNames.employeeEntry,
    RouteNames.membership,
    RouteNames.pointsMall,
  };

  /// 营养师专属路由
  static const Set<String> nutritionistOnlyRoutes = {
    RouteNames.nutritionistMain,
    RouteNames.consultationMarket,
    RouteNames.clientList,
    RouteNames.clientDetail,
  };

  /// 商家专属路由
  static const Set<String> merchantOnlyRoutes = {
    RouteNames.merchantMain,
    RouteNames.dishManagement,
    RouteNames.dishEditor,
    RouteNames.inventory,
    RouteNames.businessStats,
  };

  /// 员工专属路由
  static const Set<String> employeeOnlyRoutes = {
    RouteNames.employeeEntry,
    RouteNames.quickOrder,
    RouteNames.buildProfile,
  };

  /// 检查路由权限
  static bool canAccess(String routeName, WidgetRef ref) {
    final authState = ref.read(authStateProvider);

    // 检查是否需要登录
    if (authRequiredRoutes.contains(routeName) && !authState.isAuthenticated) {
      return false;
    }

    // 如果未登录但不需要登录，允许访问
    if (!authState.isAuthenticated) {
      return true;
    }

    final user = authState.user;
    if (user == null) return false;

    // 检查营养师权限
    if (nutritionistOnlyRoutes.contains(routeName)) {
      return _hasNutritionistPermissions(user);
    }

    // 检查商家权限
    if (merchantOnlyRoutes.contains(routeName)) {
      return _hasMerchantPermissions(user);
    }

    // 检查员工权限
    if (employeeOnlyRoutes.contains(routeName)) {
      return _hasEmployeePermissions(user);
    }

    return true;
  }

  /// 检查是否有营养师权限
  static bool _hasNutritionistPermissions(dynamic user) {
    if (PermissionChecker.isNutritionist(user.role)) return true;
    
    // 检查特殊权限
    final permissions = _getUserPermissions(user);
    return PermissionChecker.hasAnyPermission(permissions, [
      Permissions.nutritionistRead,
      Permissions.consultationManage,
    ]);
  }

  /// 检查是否有商家权限
  static bool _hasMerchantPermissions(dynamic user) {
    if (PermissionChecker.isMerchant(user.role)) return true;
    
    // 检查特殊权限
    final permissions = _getUserPermissions(user);
    return PermissionChecker.hasAnyPermission(permissions, [
      Permissions.merchantRead,
      Permissions.dishRead,
      Permissions.inventoryRead,
    ]);
  }

  /// 检查是否有员工权限
  static bool _hasEmployeePermissions(dynamic user) {
    if (PermissionChecker.isMerchant(user.role)) return true;
    
    // 检查特殊权限
    final permissions = _getUserPermissions(user);
    return PermissionChecker.hasAnyPermission(permissions, [
      Permissions.orderRead,
      Permissions.dishRead,
    ]);
  }
  
  /// 获取用户权限列表
  static List<String> _getUserPermissions(dynamic user) {
    final userPermissions = user.permissions as List<dynamic>?;
    final permissions = userPermissions?.cast<String>() ?? <String>[];
    
    // 合并角色权限和特殊权限
    return RolePermissions.getUserPermissions(user.role, permissions);
  }

  /// 获取重定向路由
  static String? getRedirectRoute(String routeName, WidgetRef ref) {
    if (!canAccess(routeName, ref)) {
      final authState = ref.read(authStateProvider);
      if (!authState.isAuthenticated) {
        return RouteNames.login;
      }
      // 如果已登录但无权限，返回主页
      return RouteNames.main;
    }
    return null;
  }
}

/// 路由观察者
/// 用于跟踪路由变化
class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logRoute('Push', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logRoute('Pop', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logRoute('Replace', newRoute, oldRoute);
  }

  void _logRoute(String action, Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final routeName = route?.settings.name ?? 'unknown';
    final previousRouteName = previousRoute?.settings.name ?? 'none';
    debugPrint('Route $action: $previousRouteName -> $routeName');
  }
}