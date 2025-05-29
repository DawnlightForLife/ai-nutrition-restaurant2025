/// 论坛模块统一业务门面
/// 
/// 聚合论坛相关的所有用例和业务逻辑
library;

import 'package:dartz/dartz.dart';
import '../../domain/entities/forum.dart';
import '../../domain/usecases/get_forums_usecase.dart';

/// 论坛业务门面
class ForumFacade {
  const ForumFacade({
    required this.getForumsUseCase,
  });

  final GetForumsUseCase getForumsUseCase;

  /// 获取帖子列表
  Future<Either<ForumFailure, List<ForumPost>>> getForumPosts({
    String? categoryId,
    String? tag,
    SortType? sortType,
    int? limit,
    int? offset,
  }) async {
    // TODO: 实现获取帖子列表的业务逻辑
    throw UnimplementedError('getForumPosts 待实现');
  }

  /// 创建新帖子
  Future<Either<ForumFailure, ForumPost>> createPost({
    required String userId,
    required String title,
    required String content,
    List<String>? tags,
    List<String>? imageUrls,
  }) async {
    // TODO: 实现创建帖子的业务逻辑
    throw UnimplementedError('createPost 待实现');
  }

  /// 回复帖子
  Future<Either<ForumFailure, ForumComment>> replyPost({
    required String postId,
    required String userId,
    required String content,
    String? parentCommentId,
  }) async {
    // TODO: 实现回复帖子的业务逻辑
    throw UnimplementedError('replyPost 待实现');
  }

  /// 点赞/取消点赞
  Future<Either<ForumFailure, void>> toggleLike({
    required String postId,
    required String userId,
  }) async {
    // TODO: 实现点赞功能的业务逻辑
    throw UnimplementedError('toggleLike 待实现');
  }

  /// 搜索帖子
  Future<Either<ForumFailure, List<ForumPost>>> searchPosts({
    required String keyword,
    SearchScope? scope,
  }) async {
    // TODO: 实现搜索帖子的业务逻辑
    throw UnimplementedError('searchPosts 待实现');
  }

  /// 获取热门标签
  Future<Either<ForumFailure, List<ForumTag>>> getHotTags({
    int limit = 10,
  }) async {
    // TODO: 实现获取热门标签的业务逻辑
    throw UnimplementedError('getHotTags 待实现');
  }
}

/// 论坛业务失败类型
abstract class ForumFailure {}

/// 论坛帖子
abstract class ForumPost {}

/// 论坛评论
abstract class ForumComment {}

/// 论坛标签
abstract class ForumTag {}

/// 排序类型
enum SortType {
  latest,
  hottest,
  mostCommented,
}

/// 搜索范围
enum SearchScope {
  title,
  content,
  all,
}