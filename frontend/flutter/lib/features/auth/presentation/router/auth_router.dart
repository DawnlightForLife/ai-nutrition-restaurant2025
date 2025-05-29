import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';

/// Auth 模块路由配置
class AuthRouter {
  /// 获取 Auth 模块的所有路由
  static List<AutoRoute> get routes => [
    // 登录页面
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
    ),
    
    // 注册页面
    AutoRoute(
      page: RegisterRoute.page,
      path: '/register',
    ),
    
    // 验证码页面
    AutoRoute(
      page: VerificationCodeRoute.page,
      path: '/verification',
    ),
    
    // 重置密码页面
    AutoRoute(
      page: ResetPasswordRoute.page,
      path: '/reset-password',
    ),
    
    // 资料完善页面
    AutoRoute(
      page: ProfileCompletionRoute.page,
      path: '/profile-completion',
    ),
  ];
  
  /// 路由名称常量，便于其他模块引用
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String verificationPath = '/verification';
  static const String resetPasswordPath = '/reset-password';
  static const String profileCompletionPath = '/profile-completion';
}