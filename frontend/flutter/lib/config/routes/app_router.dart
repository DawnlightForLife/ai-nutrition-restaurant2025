import 'package:flutter/material.dart';

/// 应用路由配置（临时版本）
/// 
/// 待auto_route代码生成后替换为正式版本
class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/splash':
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Splash Screen'),
            ),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('404 - Page not found'),
            ),
          ),
        );
    }
  }
}