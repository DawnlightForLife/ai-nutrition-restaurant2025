import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/guards.dart';

/// Nutrition 模块路由配置
class NutritionRouter {
  /// 获取 Nutrition 模块的所有路由
  static List<AutoRoute> get routes => [
    // 营养档案列表
    AutoRoute(
      page: NutritionProfileListRoute.page,
      path: '/nutrition/profiles',
      guards: [AuthGuard()],
    ),
    
    // 营养档案管理（新建/编辑）
    AutoRoute(
      page: NutritionProfileManagementRoute.page,
      path: '/nutrition/profile/:id',
      guards: [AuthGuard()],
    ),
    
    // 营养档案详情
    AutoRoute(
      page: NutritionProfileDetailRoute.page,
      path: '/nutrition/profile-detail/:id',
      guards: [AuthGuard()],
    ),
    
    // AI推荐聊天
    AutoRoute(
      page: AiRecommendationChatRoute.page,
      path: '/nutrition/ai-chat',
      guards: [AuthGuard()],
    ),
    
    // AI推荐结果
    AutoRoute(
      page: AiRecommendationResultRoute.page,
      path: '/nutrition/ai-result/:recommendationId',
      guards: [AuthGuard()],
    ),
    
    // 推荐入口页
    AutoRoute(
      page: RecommendationEntryRoute.page,
      path: '/nutrition/recommendation',
      guards: [AuthGuard()],
    ),
  ];
  
  /// 路由名称常量
  static const String profilesPath = '/nutrition/profiles';
  static const String profileManagementPath = '/nutrition/profile';
  static const String profileDetailPath = '/nutrition/profile-detail';
  static const String aiChatPath = '/nutrition/ai-chat';
  static const String aiResultPath = '/nutrition/ai-result';
  static const String recommendationPath = '/nutrition/recommendation';
  
  /// 便捷方法：生成档案管理路径
  static String profileManagementPathWithId(String id) => '$profileManagementPath/$id';
  
  /// 便捷方法：生成档案详情路径
  static String profileDetailPathWithId(String id) => '$profileDetailPath/$id';
  
  /// 便捷方法：生成AI结果路径
  static String aiResultPathWithId(String recommendationId) => '$aiResultPath/$recommendationId';
}