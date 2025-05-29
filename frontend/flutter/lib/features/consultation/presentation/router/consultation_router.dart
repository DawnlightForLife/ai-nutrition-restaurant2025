import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/guards.dart';

/// Consultation 模块路由配置
class ConsultationRouter {
  /// 获取 Consultation 模块的所有路由
  static List<AutoRoute> get routes => [
    // 咨询列表
    AutoRoute(
      page: ConsultationListRoute.page,
      path: '/consultations',
      guards: [AuthGuard()],
    ),
  ];
  
  /// 路由名称常量
  static const String listPath = '/consultations';
}