import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/guards.dart';

/// Forum 模块路由配置
class ForumRouter {
  /// 获取 Forum 模块的所有路由
  static List<AutoRoute> get routes => [
    // 论坛首页
    AutoRoute(
      page: ForumHomeRoute.page,
      path: '/forum',
      guards: [AuthGuard()],
    ),
    
    // 帖子列表
    AutoRoute(
      page: ForumPostListRoute.page,
      path: '/forum/posts',
      guards: [AuthGuard()],
    ),
    
    // 帖子详情
    AutoRoute(
      page: ForumPostDetailRoute.page,
      path: '/forum/post/:postId',
      guards: [AuthGuard()],
    ),
    
    // 创建帖子
    AutoRoute(
      page: CreatePostRoute.page,
      path: '/forum/create-post',
      guards: [AuthGuard()],
    ),
  ];
  
  /// 路由名称常量
  static const String homePath = '/forum';
  static const String postListPath = '/forum/posts';
  static const String postDetailPath = '/forum/post';
  static const String createPostPath = '/forum/create-post';
  
  /// 便捷方法：生成帖子详情路径
  static String postDetailPathWithId(String postId) => '$postDetailPath/$postId';
}