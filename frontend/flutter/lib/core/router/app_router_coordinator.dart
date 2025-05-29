/// 应用级路由协调器
/// 
/// 负责统一协调各个模块的路由注册和管理
/// 解决集中化路由管理的问题，支持模块化路由注册
library;

import 'package:auto_route/auto_route.dart';
import '../../features/auth/presentation/router/auth_router.dart';
import '../../features/user/presentation/router/user_router.dart';
import '../../features/nutrition/presentation/router/nutrition_router.dart';
import '../../features/order/presentation/router/order_router.dart';
import '../../features/recommendation/presentation/router/recommendation_router.dart';
import '../../features/consultation/presentation/router/consultation_router.dart';
import '../../features/forum/presentation/router/forum_router.dart';
import '../../features/merchant/presentation/router/merchant_router.dart';
import '../../features/admin/presentation/router/admin_router.dart';
import '../../features/employee/presentation/router/employee_router.dart';
import '../../features/global_pages/presentation/router/global_pages_router.dart';

/// 应用路由协调器
/// 
/// 提供模块化的路由注册和管理机制
/// 避免在单一文件中集中管理所有路由配置
class AppRouterCoordinator {
  const AppRouterCoordinator._();

  /// 获取所有模块的路由配置
  static List<AutoRoute> get routes => [
    // 认证模块路由
    ...AuthRouter.routes,
    
    // 用户模块路由
    ...UserRouter.routes,
    
    // 营养模块路由
    ...NutritionRouter.routes,
    
    // 订单模块路由
    ...OrderRouter.routes,
    
    // AI推荐模块路由
    ...RecommendationRouter.routes,
    
    // 咨询模块路由
    ...ConsultationRouter.routes,
    
    // 论坛模块路由
    ...ForumRouter.routes,
    
    // 商家模块路由
    ...MerchantRouter.routes,
    
    // 管理员模块路由
    ...AdminRouter.routes,
    
    // 员工模块路由
    ...EmployeeRouter.routes,
    
    // 全局页面路由
    ...GlobalPagesRouter.routes,
  ];

  /// 获取路由守卫列表
  static List<AutoRouteGuard> get guards => [
    // TODO: 添加认证守卫
    // AuthGuard(),
    
    // TODO: 添加权限守卫
    // RoleGuard(),
    
    // TODO: 添加其他路由守卫
  ];

  /// 获取路由中间件列表
  static List<NavigationMiddleware> get middlewares => [
    // TODO: 添加导航中间件
    // AnalyticsMiddleware(),
    // LoggingMiddleware(),
  ];

  /// 初始化路由配置
  static void initialize() {
    // TODO: 执行路由初始化逻辑
    // 例如：注册深度链接处理器、设置路由日志等
  }

  /// 清理路由配置
  static void dispose() {
    // TODO: 执行路由清理逻辑
    // 例如：取消深度链接监听、清理路由缓存等
  }
}

/// 导航中间件接口
abstract class NavigationMiddleware {
  /// 在导航前执行
  Future<void> onNavigating(String route, Map<String, dynamic>? params);
  
  /// 在导航后执行
  Future<void> onNavigated(String route, Map<String, dynamic>? params);
}