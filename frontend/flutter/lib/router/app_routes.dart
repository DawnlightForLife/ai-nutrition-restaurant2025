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

/**
 * 应用路由配置
 *
 * 定义应用中所有页面的路由映射关系，提供统一的路由管理。
 * 包含静态路由表、动态路由生成逻辑和404页面处理。
 */
class AppRoutes {
  /**
   * 路由名称常量
   * 
   * 集中定义所有路由路径，便于代码中使用和维护
   */
  // 基础路由
  static const String splash = '/';             // 启动屏幕
  static const String login = '/login';         // 登录页面
  static const String register = '/register';   // 注册页面
  static const String forgotPassword = '/forgot-password'; // 忘记密码页面
  static const String resetPassword = '/reset-password';   // 重置密码页面
  static const String main = '/main';           // 主页面(包含底部导航栏)
  
  // 论坛模块路由
  static const String forum = '/forum';               // 论坛首页
  static const String forumPostDetail = '/forum/post'; // 论坛帖子详情页
  static const String forumNewPost = '/forum/new';    // 发布新帖子页面

  // 营养档案模块路由
  static const String healthProfiles = '/health-profiles'; // 营养档案列表页面
  static const String healthForm = '/health-form';         // 营养档案表单页面(新建/编辑)

  /**
   * 静态路由表
   * 
   * 定义不需要动态参数的路由映射关系
   * 这些路由可以直接通过Navigator.pushNamed(context, routeName)访问
   * 
   * @return {Map<String, WidgetBuilder>} 路由路径到页面构建器的映射
   */
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),         // 启动屏幕
    login: (context) => const LoginPage(),             // 登录页面
    register: (context) => const RegisterPage(),       // 注册页面
    forgotPassword: (context) => const VerifyCodePage(), // 验证码页面(忘记密码流程)
    resetPassword: (context) => const ResetPasswordPage(), // 重置密码页面
    main: (context) => const MainPage(),               // 主页面
    
    // 论坛路由
    forum: (context) => const ForumHomePage(),         // 论坛首页
    forumNewPost: (context) => const ForumNewPostPage(), // 创建新帖子页面
    
    // 营养档案路由
    healthProfiles: (context) => const HealthProfilesPage(), // 营养档案列表页面
  };
  
  /**
   * 处理未知路由(404页面)
   * 
   * 当导航到未定义的路由时，会调用此方法
   * 返回一个友好的错误页面，提示用户页面不存在，并提供返回首页的选项
   * 
   * @param {RouteSettings} settings 路由设置对象
   * @return {Route<dynamic>} 页面不存在的错误路由
   */
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
                  // 导航回首页
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
  
  /**
   * 动态路由生成器
   * 
   * 处理需要传递参数的路由，根据路由名称和参数构建相应的页面
   * 主要用于以下场景:
   * 1. 需要传递复杂参数的页面
   * 2. 需要根据参数条件动态决定显示内容的页面
   * 3. 需要传递非基本类型参数的页面
   * 
   * @param {RouteSettings} settings 路由设置对象，包含路由名称和参数
   * @return {Route<dynamic>?} 动态生成的路由，如果不需要处理则返回null
   */
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // 处理论坛帖子详情页路由
    if (settings.name == forumPostDetail) {
      // 从arguments中提取帖子ID
      final args = settings.arguments as Map<String, dynamic>?;
      final postId = args?['postId'] as String? ?? '';
      
      // 创建帖子详情页路由
      return MaterialPageRoute(
        builder: (context) => ForumPostDetail(postId: postId),
        settings: settings, // 保留原始路由设置
      );
    }
    
    // 处理营养档案表单页路由
    if (settings.name == healthForm) {
      // 从arguments中提取营养档案数据和查看模式标志
      final args = settings.arguments as Map<String, dynamic>?;
      final profile = args?['profile']; // 营养档案数据，用于编辑模式
      final viewOnly = args?['viewOnly'] as bool? ?? false; // 是否只读模式
      
      // 创建营养档案表单页路由
      return MaterialPageRoute(
        builder: (context) {
          // 传递参数给HealthFormPage
          return HealthFormPage(
            profile: profile,    // 传递档案数据(新建时为null)
            viewOnly: viewOnly,  // 是否为只读模式
          );
        },
        settings: settings, // 保留原始路由设置
      );
    }
    
    // 如果不是需要特殊处理的路由，返回null，让Flutter使用routes表中的定义
    return null;
  }
}
