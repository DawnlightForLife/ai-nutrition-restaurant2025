import '../../models/forum/post.dart';
import '../../models/forum/comment.dart';
import '../../services/forum/forum_service.dart';
import '../../services/core/auth_service.dart';
import 'package:flutter/material.dart';

/// 论坛数据仓库
///
/// 管理论坛相关数据和API交互，处理缓存逻辑
/// 负责在服务层和状态管理层之间提供数据交互，并实现本地缓存策略
class ForumRepository {
  /// 论坛服务实例，负责与API交互
  final ForumService _forumService;
  
  /// 认证服务实例，用于获取用户令牌
  final AuthService _authService;

  /// 本地缓存
  /// 存储已获取的帖子列表，避免重复请求提高性能
  List<Post> _cachedPosts = [];
  
  /// 帖子评论缓存映射表
  /// 键为帖子ID，值为该帖子的评论列表
  Map<String, List<Comment>> _cachedComments = {};

  /// 构造函数
  /// 
  /// @param forumService 论坛服务实例
  /// @param authService 认证服务实例
  ForumRepository(this._forumService, this._authService);

  /// 获取当前用户token
  /// 
  /// 从认证服务获取当前用户的访问令牌
  /// @return 用户令牌，未登录时为null
  String? _getToken() {
    return _authService.getCurrentToken();
  }

  /// 获取帖子列表
  ///
  /// 从服务器获取帖子列表并更新本地缓存
  /// 支持分页、标签筛选和用户筛选
  /// 
  /// @param page 请求的页码
  /// @param limit 每页数量限制
  /// @param tag 标签筛选
  /// @param userId 作者ID筛选
  /// @param forceRefresh 是否强制刷新，忽略缓存
  /// @return 包含帖子列表和分页信息的Map
  Future<Map<String, dynamic>> getPosts({
    required int page,
    int limit = 10,
    String? tag,
    String? userId,
    bool forceRefresh = false,
  }) async {
    // 获取token，可能为空（未登录用户也可以浏览帖子）
    final token = _getToken();
    
    // 调用服务层获取数据
    final result = await _forumService.getPosts(
      page: page,
      limit: limit,
      tag: tag,
      userId: userId,
      token: token,
    );
    
    // 更新本地缓存
    final List<Post> posts = result['posts'];
    
    if (page == 1) {
      // 如果是第一页，直接替换缓存
      _cachedPosts = List.from(posts);
    } else {
      // 如果是加载更多，合并新数据到缓存，避免重复
      final Set<String> existingIds = _cachedPosts.map((post) => post.id).toSet();
      _cachedPosts.addAll(posts.where((post) => !existingIds.contains(post.id)));
    }
    
    return result;
  }

  /// 获取帖子详情
  ///
  /// 根据帖子ID获取完整的帖子内容
  /// 优先使用缓存，提高性能
  ///
  /// @param postId 帖子ID
  /// @param forceRefresh 是否强制从服务器刷新
  /// @return 帖子详情
  Future<Post> getPostDetail({
    required String postId,
    bool forceRefresh = false,
  }) async {
    // 优先使用缓存策略：如果不是强制刷新且缓存中有该帖子，则从缓存返回
    if (!forceRefresh) {
      final cachedPost = _cachedPosts.firstWhere(
        (post) => post.id == postId,
        orElse: () => Post(
          id: '',
          title: '',
          content: '',
          authorId: '',
          authorName: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      
      // 如果找到有效缓存，直接返回
      if (cachedPost.id.isNotEmpty) {
        return cachedPost;
      }
    }

    // 从服务器获取最新数据
    final token = _getToken();
    final post = await _forumService.getPostDetail(
      postId: postId,
      token: token,
    );
    
    // 更新缓存
    final index = _cachedPosts.indexWhere((item) => item.id == postId);
    if (index >= 0) {
      // 更新现有缓存条目
      _cachedPosts[index] = post;
    } else {
      // 添加新条目到缓存
      _cachedPosts.add(post);
    }
    
    return post;
  }

  /// 创建新帖子
  ///
  /// 将新帖子内容发送到服务器并更新本地缓存
  /// 需要用户登录才能创建帖子
  ///
  /// @param title 帖子标题
  /// @param content 帖子内容
  /// @param tags 帖子标签列表
  /// @return 创建成功的帖子对象
  /// @throws Exception 当用户未登录时
  Future<Post> createPost({
    required String title,
    required String content,
    List<String> tags = const [],
  }) async {
    // 验证用户登录状态
    final token = _getToken();
    if (token == null) {
      throw Exception('用户未登录，无法创建帖子');
    }
    
    // 调用服务层创建帖子
    final post = await _forumService.createPost(
      title: title,
      content: content,
      tags: tags,
      token: token,
    );
    
    // 将新帖子添加到缓存的首位
    _cachedPosts.insert(0, post);
    
    return post;
  }

  /// 更新帖子
  ///
  /// 更新服务器和本地缓存中的帖子内容
  /// 需要用户登录才能更新帖子
  ///
  /// @param postId 要更新的帖子ID
  /// @param title 新标题（可选）
  /// @param content 新内容（可选）
  /// @param tags 新标签列表（可选）
  /// @return 更新后的帖子对象
  /// @throws Exception 当用户未登录时
  Future<Post> updatePost({
    required String postId,
    String? title,
    String? content,
    List<String>? tags,
  }) async {
    // 验证用户登录状态
    final token = _getToken();
    if (token == null) {
      throw Exception('用户未登录，无法更新帖子');
    }
    
    // 调用服务层更新帖子
    final post = await _forumService.updatePost(
      postId: postId,
      title: title,
      content: content,
      tags: tags,
      token: token,
    );
    
    // 更新本地缓存
    final index = _cachedPosts.indexWhere((item) => item.id == postId);
    if (index >= 0) {
      _cachedPosts[index] = post;
    }
    
    return post;
  }

  /// 删除帖子
  ///
  /// 从服务器和本地缓存中删除帖子
  /// 需要用户登录才能删除帖子
  ///
  /// @param postId 要删除的帖子ID
  /// @return 操作是否成功
  /// @throws Exception 当用户未登录时
  Future<bool> deletePost({
    required String postId,
  }) async {
    // 验证用户登录状态
    final token = _getToken();
    if (token == null) {
      throw Exception('用户未登录，无法删除帖子');
    }
    
    // 调用服务层删除帖子
    final result = await _forumService.deletePost(
      postId: postId,
      token: token,
    );
    
    // 从本地缓存中移除
    _cachedPosts.removeWhere((post) => post.id == postId);
    _cachedComments.remove(postId);
    
    return result;
  }

  /// 获取帖子评论
  ///
  /// 获取某个帖子的所有评论并更新缓存
  ///
  /// @param postId 帖子ID
  /// @param forceRefresh 是否强制从服务器刷新
  /// @return 评论列表
  Future<List<Comment>> getComments({
    required String postId,
    bool forceRefresh = false,
  }) async {
    // 优先使用缓存策略：如果不是强制刷新且缓存中有该帖子的评论，则从缓存返回
    if (!forceRefresh && _cachedComments.containsKey(postId)) {
      return _cachedComments[postId]!;
    }

    // 从服务器获取最新评论
    final token = _getToken();
    final comments = await _forumService.getComments(
      postId: postId,
      token: token,
    );
    
    // 更新缓存
    _cachedComments[postId] = comments;
    
    return comments;
  }

  /// 添加评论
  ///
  /// 向帖子添加新评论并更新缓存
  /// 需要用户登录才能添加评论
  ///
  /// @param postId 帖子ID
  /// @param content 评论内容
  /// @param parentId 父评论ID（用于回复功能，可选）
  /// @return 创建的评论对象
  /// @throws Exception 当用户未登录时
  Future<Comment> addComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    // 验证用户登录状态
    final token = _getToken();
    if (token == null) {
      throw Exception('用户未登录，无法添加评论');
    }
    
    // 调用服务层添加评论
    final comment = await _forumService.addComment(
      postId: postId,
      content: content,
      parentId: parentId,
      token: token,
    );
    
    // 更新评论缓存
    if (_cachedComments.containsKey(postId)) {
      _cachedComments[postId]!.add(comment);
    }
    
    // 更新帖子的评论计数
    final postIndex = _cachedPosts.indexWhere((post) => post.id == postId);
    if (postIndex >= 0) {
      final post = _cachedPosts[postIndex];
      _cachedPosts[postIndex] = post.copyWith(
        commentCount: post.commentCount + 1,
      );
    }
    
    return comment;
  }

  /// 删除评论
  ///
  /// 从帖子中删除评论并更新缓存
  /// 需要用户登录才能删除评论
  ///
  /// @param postId 帖子ID
  /// @param commentId 评论ID
  /// @return 操作是否成功
  /// @throws Exception 当用户未登录时
  Future<bool> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    // 验证用户登录状态
    final token = _getToken();
    if (token == null) {
      throw Exception('用户未登录，无法删除评论');
    }
    
    // 调用服务层删除评论
    final result = await _forumService.deleteComment(
      postId: postId,
      commentId: commentId,
      token: token,
    );
    
    // 从缓存中移除评论
    if (_cachedComments.containsKey(postId)) {
      _cachedComments[postId]!.removeWhere((comment) => comment.id == commentId);
    }
    
    // 更新帖子的评论计数
    final postIndex = _cachedPosts.indexWhere((post) => post.id == postId);
    if (postIndex >= 0) {
      final post = _cachedPosts[postIndex];
      _cachedPosts[postIndex] = post.copyWith(
        commentCount: post.commentCount - 1,
      );
    }
    
    return result;
  }

  /// 切换帖子点赞状态
  ///
  /// 对帖子进行点赞或取消点赞，并更新缓存
  /// 需要用户登录才能点赞
  ///
  /// @param postId 帖子ID
  /// @return 新的点赞状态（true=已点赞，false=已取消点赞）
  /// @throws Exception 当用户未登录时
  Future<bool> toggleLikePost({
    required String postId,
  }) async {
    // 验证用户登录状态
    final token = _getToken();
    if (token == null) {
      throw Exception('用户未登录，无法点赞');
    }
    
    // 调用服务层切换点赞状态
    final isLiked = await _forumService.toggleLikePost(
      postId: postId,
      token: token,
    );
    
    // 更新缓存中的帖子点赞状态和数量
    final postIndex = _cachedPosts.indexWhere((post) => post.id == postId);
    if (postIndex >= 0) {
      final post = _cachedPosts[postIndex];
      _cachedPosts[postIndex] = post.copyWith(
        isLiked: isLiked,
        likeCount: isLiked ? post.likeCount + 1 : post.likeCount - 1,
      );
    }
    
    return isLiked;
  }

  /// 切换评论点赞状态
  ///
  /// 对评论进行点赞或取消点赞，并更新缓存
  /// 需要用户登录才能点赞评论
  ///
  /// @param postId 帖子ID
  /// @param commentId 评论ID
  /// @return 新的点赞状态（true=已点赞，false=已取消点赞）
  /// @throws Exception 当用户未登录时
  Future<bool> toggleLikeComment({
    required String postId,
    required String commentId,
  }) async {
    // 验证用户登录状态
    final token = _getToken();
    if (token == null) {
      throw Exception('用户未登录，无法点赞');
    }
    
    // 调用服务层切换评论点赞状态
    final isLiked = await _forumService.toggleLikeComment(
      postId: postId,
      commentId: commentId,
      token: token,
    );
    
    // 更新缓存中的评论点赞状态和数量
    if (_cachedComments.containsKey(postId)) {
      final commentIndex = _cachedComments[postId]!.indexWhere((comment) => comment.id == commentId);
      if (commentIndex >= 0) {
        final comment = _cachedComments[postId]![commentIndex];
        _cachedComments[postId]![commentIndex] = comment.copyWith(
          isLiked: isLiked,
          likeCount: isLiked ? comment.likeCount + 1 : comment.likeCount - 1,
        );
      }
    }
    
    return isLiked;
  }

  /// 清除缓存
  ///
  /// 清空所有本地缓存的帖子和评论数据
  /// 通常在用户登出或需要强制刷新所有数据时使用
  void clearCache() {
    _cachedPosts = [];
    _cachedComments = {};
  }
}
