import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/guards.dart';

/// Recommendation 模块路由配置
class RecommendationRouter {
  /// 获取 Recommendation 模块的所有路由
  static List<AutoRoute> get routes => [
    // 推荐列表
    AutoRoute(
      page: RecommendationListRoute.page,
      path: '/recommendations',
      guards: [AuthGuard()],
    ),
    
    // 推荐详情
    AutoRoute(
      page: RecommendationDetailRoute.page,
      path: '/recommendation/:id',
      guards: [AuthGuard()],
    ),
    
    // 推荐反馈
    AutoRoute(
      page: RecommendationFeedbackRoute.page,
      path: '/recommendation/:id/feedback',
      guards: [AuthGuard()],
    ),
  ];
  
  /// 路由名称常量
  static const String listPath = '/recommendations';
  static const String detailPath = '/recommendation';
  static const String feedbackPath = '/recommendation/:id/feedback';
  
  /// 便捷方法：生成推荐详情路径
  static String detailPathWithId(String id) => '$detailPath/$id';
  
  /// 便捷方法：生成推荐反馈路径
  static String feedbackPathWithId(String id) => '/recommendation/$id/feedback';
}