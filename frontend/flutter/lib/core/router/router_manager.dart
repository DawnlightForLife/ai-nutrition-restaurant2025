import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_router.dart';

/// 路由管理器
/// 提供统一的路由导航接口，简化路由操作
class RouterManager {
  final AppRouter _router;
  
  RouterManager(this._router);
  
  /// 获取当前路由上下文
  BuildContext get context => _router.navigatorKey.currentContext!;
  
  /// 导航到指定路径
  Future<T?> navigateTo<T>(String path, {Object? args}) {
    return _router.pushNamed<T>(path, arguments: args);
  }
  
  /// 替换当前路由
  Future<T?> replaceTo<T>(String path, {Object? args}) {
    return _router.replaceNamed<T>(path, arguments: args);
  }
  
  /// 导航到指定路由并清空栈
  Future<T?> navigateToAndClearStack<T>(String path, {Object? args}) {
    _router.removeUntil((route) => false);
    return _router.pushNamed<T>(path, arguments: args);
  }
  
  /// 返回上一页
  void goBack<T>([T? result]) {
    _router.maybePop<T>(result);
  }
  
  /// 返回到根路由
  void popToRoot() {
    _router.popUntilRoot();
  }
  
  /// 检查是否可以返回
  bool canGoBack() {
    return _router.canPop();
  }
  
  /// 导航到登录页（清空栈）
  Future<void> navigateToLogin() {
    return navigateToAndClearStack('/login');
  }
  
  /// 导航到主页（清空栈）
  Future<void> navigateToHome() {
    return navigateToAndClearStack('/home');
  }
  
  /// 根据用户角色导航到对应的仪表板
  Future<void> navigateToDashboard(String role) {
    switch (role) {
      case 'merchant':
        return navigateTo('/merchant/dashboard');
      case 'nutritionist':
        return navigateTo('/nutritionist/dashboard');
      case 'employee':
        return navigateTo('/employee/workspace');
      case 'admin':
        return navigateTo('/admin/dashboard');
      default:
        return navigateTo('/home');
    }
  }
}

/// RouterManager Provider
final routerManagerProvider = Provider<RouterManager>((ref) {
  // 这里应该从应用的主路由获取
  // 暂时抛出异常，需要在应用启动时配置
  throw UnimplementedError('请在应用启动时配置 RouterManager');
});