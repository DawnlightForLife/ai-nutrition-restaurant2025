import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'route_names.dart';
import 'route_guards.dart';

// 导入页面
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/verification_code_page.dart';
import '../features/auth/presentation/pages/profile_completion_page.dart';
import '../features/main/presentation/pages/main_page.dart';
import '../features/search/presentation/pages/search_page.dart';
import '../features/cart/presentation/pages/cart_page.dart';
import '../features/global_pages/presentation/pages/placeholder_page.dart';
import '../features/admin/presentation/pages/admin_verification_page.dart';
import '../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../features/admin/presentation/pages/merchant_approval_page.dart';
import '../features/admin/presentation/pages/admin_management_page.dart';
// TODO: 导入其他页面

/// 应用路由配置
class AppRouter {
  static final RouteObserver<PageRoute> observer = AppRouteObserver();

  /// 生成路由
  static Route<dynamic> onGenerateRoute(RouteSettings settings, WidgetRef ref) {
    // 检查路由权限
    final redirectRoute = RouteGuards.getRedirectRoute(settings.name ?? '', ref);
    if (redirectRoute != null) {
      return MaterialPageRoute(
        builder: (_) => Container(), // 临时页面
        settings: RouteSettings(name: redirectRoute),
      );
    }

    // 路由映射
    switch (settings.name) {
      case RouteNames.splash:
        return _buildRoute(const SplashPage(), settings);

      case RouteNames.login:
        return _buildRoute(const LoginPage(), settings);

      case RouteNames.verification:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          VerificationCodePage.legacy(
            phone: args?['phoneNumber'] ?? '',
            isFromLogin: true,
          ),
          settings,
        );

      case RouteNames.main:
        return _buildRoute(const MainPage(), settings);

      case RouteNames.search:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          SearchPage(initialQuery: args?['query']),
          settings,
        );

      case RouteNames.cart:
        return _buildRoute(const CartPage(), settings);

      // 营养档案相关 (临时使用占位页面)
      case RouteNames.nutritionProfileList:
        return _buildRoute(const PlaceholderPage(title: '营养档案'), settings);
        
      case RouteNames.nutritionProfileDetail:
        return _buildRoute(const PlaceholderPage(title: '档案详情'), settings);
        
      case RouteNames.nutritionProfileEditor:
        return _buildRoute(const PlaceholderPage(title: '编辑档案'), settings);

      // AI推荐相关 (临时使用占位页面)
      case RouteNames.aiChat:
        return _buildRoute(const PlaceholderPage(title: 'AI营养师'), settings);
        
      case RouteNames.aiResult:
        return _buildRoute(const PlaceholderPage(title: '推荐结果'), settings);

      // 其他常用页面
      case RouteNames.settings:
        return _buildRoute(const PlaceholderPage(title: '设置'), settings);
        
      case RouteNames.notificationCenter:
        return _buildRoute(const PlaceholderPage(title: '消息通知'), settings);
        
      case RouteNames.addressManager:
        return _buildRoute(const PlaceholderPage(title: '地址管理'), settings);
        
      case RouteNames.helpCenter:
        return _buildRoute(const PlaceholderPage(title: '帮助中心'), settings);

      // 管理员相关路由
      case '/admin/verify':
        return _buildRoute(const AdminVerificationPage(), settings);
        
      case '/admin/dashboard':
        return _buildRoute(const AdminDashboardPage(), settings);
        
      case '/admin/merchant-approval':
        return _buildRoute(const MerchantApprovalPage(), settings);
        
      case '/admin/admin-management':
        return _buildRoute(const AdminManagementPage(), settings);

      // TODO: 添加其他路由

      default:
        return _buildRoute(_buildErrorPage(settings.name), settings);
    }
  }

  /// 构建路由
  static MaterialPageRoute<T> _buildRoute<T>(
    Widget page,
    RouteSettings settings, {
    bool fullscreenDialog = false,
  }) {
    return MaterialPageRoute<T>(
      builder: (_) => page,
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    );
  }

  /// 构建错误页面
  static Widget _buildErrorPage(String? routeName) {
    return Scaffold(
      appBar: AppBar(title: const Text('页面未找到')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('页面未找到: ${routeName ?? '未知路由'}'),
            const SizedBox(height: 16),
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('返回'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 初始路由
  static String get initialRoute => RouteNames.splash;
}

/// 路由参数提取扩展
extension RouteArgumentsExtension on BuildContext {
  /// 获取路由参数
  T? getRouteArguments<T>() {
    final args = ModalRoute.of(this)?.settings.arguments;
    return args as T?;
  }

  /// 获取路由参数（Map类型）
  Map<String, dynamic> getRouteArgumentsAsMap() {
    final args = ModalRoute.of(this)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      return args;
    }
    return {};
  }

  /// 获取特定的路由参数
  T? getRouteArgument<T>(String key) {
    final args = getRouteArgumentsAsMap();
    return args[key] as T?;
  }
}