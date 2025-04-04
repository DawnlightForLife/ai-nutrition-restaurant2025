import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Assuming 'ai_nutrition_restaurant' is the package name in pubspec.yaml
import '../splash_screen.dart';
import '../screens/user/auth/login_page.dart';
import '../screens/user/auth/register_page.dart';
import '../screens/user/auth/reset_password_page.dart';
import '../screens/user/auth/verify_code_page.dart';
import '../screens/user/main_page.dart';
// 恢复论坛模块导入
import '../screens/user/forum/forum_home_page.dart';
import '../screens/user/forum/forum_post_detail.dart';
import '../screens/user/forum/forum_new_post_page.dart';
// 添加营养档案模块导入
import '../screens/user/health/health_profiles_page.dart';
import '../screens/user/health/health_form_page.dart';
import '../providers/health/health_profile_provider.dart';

/// 应用路由配置
///
/// 定义应用中所有页面的路由映射关系
class AppRoutes {
  /// 路由名常量
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String main = '/main';
  
  // 论坛路由
  static const String forum = '/forum';
  static const String forumPostDetail = '/forum/post';
  static const String forumNewPost = '/forum/new';

  // 营养档案路由
  static const String healthProfiles = '/health-profiles';
  static const String healthForm = '/health-form';

  /// 应用的所有路由
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    forgotPassword: (context) => const VerifyCodePage(),
    resetPassword: (context) => const ResetPasswordPage(),
    main: (context) => const MainPage(),
    
    // 论坛路由
    forum: (context) => const ForumHomePage(),
    forumNewPost: (context) => const ForumNewPostPage(),
    
    // 营养档案路由
    healthProfiles: (context) => const HealthProfilesPage(),
  };
  
  /// 未知路由处理
  static Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('页面不存在'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '找不到请求的页面',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(main);
                },
                child: const Text('返回首页'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 路由生成器，处理需要参数的路由
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == forumPostDetail) {
      // 从arguments中提取帖子ID
      final args = settings.arguments as Map<String, dynamic>?;
      final postId = args?['postId'] as String? ?? '';
      
      return MaterialPageRoute(
        builder: (context) => ForumPostDetail(postId: postId),
        settings: settings,
      );
    }
    
    if (settings.name == healthForm) {
      // 从arguments中提取营养档案数据
      final args = settings.arguments as Map<String, dynamic>?;
      final profile = args?['profile'];
      final viewOnly = args?['viewOnly'] as bool? ?? false;
      
      return MaterialPageRoute(
        builder: (context) {
          // 传递参数给HealthFormPage
          return HealthFormPage(
            profile: profile,
            viewOnly: viewOnly,
          );
        },
        settings: settings,
      );
    }
    
    return null;
  }
}
