import '../../models/forum/post.dart';
import '../../models/forum/comment.dart';
import '../../services/forum/forum_service.dart';
import '../../services/core/auth_service.dart';
import 'package:flutter/material.dart';

/// 论坛数据仓库
///
/// 管理论坛相关数据和API交互，处理缓存逻辑
class ForumRepository {
  final ForumService _forumService;
  final AuthService _authService;

  // 可以添加本地缓存
  List<Post> _cachedPosts = [];
  Map<String, List<Comment>> _cachedComments = {};

  ForumRepository(this._forumService, this._authService);

  /// 获取当前用户token
  String? _getToken() {
    return _authService.getCurrentToken();
  }

  /// 获取帖子列表
  ///
  /// [forceRefresh] 是否强制刷新，忽略缓存
  Future<Map<String, dynamic>> getPosts({
    required int page,
    int limit = 10,
    String? tag,
    String? userId,
    bool forceRefresh = false,
  }) async {
    // 获取token，可能为空
    final token = _getToken();
    
    final result = await _forumService.getPosts(
      page: page,
      limit: limit,
      tag: tag,
      userId: userId,
      token: token,
    );
    
    // 更新缓存
    final List<Post> posts = result['posts'];
    
    if (page == 1) {
      _cachedPosts = List.from(posts);
    } else {
      // 合并新数据到缓存
      final Set<String> existingIds = _cachedPosts.map((post) => post.id).toSet();
      _cachedPosts.addAll(posts.where((post) => !existingIds.contains(post.id)));
    }
    
    return result;
  }

  /// 获取帖子详情
  Future<Post> getPostDetail({
    required String postId,
    bool forceRefresh = false,
  }) async {
    // 如果不是强制刷新且缓存中有该帖子，则从缓存返回
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
      
      if (cachedPost.id.isNotEmpty) {
        return cachedPost;
      }
    }

    final token = _getToken();
    final post = await _forumService.getPostDetail(
      postId: postId,
      token: token,
    );
    
    // 更新缓存
    final index = _cachedPosts.indexWhere((item) => item.id == postId);
    if (index >= 0) {
      _cachedPosts[index] = post;
    } else {
      _cachedPosts.add(post);
    }
    
    return post;
  }

  /// 创建新帖子
  Future<Post> createPost({
    required String title,
    required String content,
    List<String> tags = const [],
  }) async {
    final token = _getToken();
    if (token == null) {
      throw Exception('用户未登录，无法创建帖子');
    }
    
    final post = await _forumService.createPost(
      title: title,
      content: content,
      tags: tags,
      token: token,
    );
    
    // 添加到缓存
    _cachedPosts.insert(0, post);
    
    return post;
  }

  /// 更新帖子
  Future<Post> updatePost({
    required String postId,
    String? title,
    String? content,
    List<String>? tags,
  }) async {
    final token = _getToken();
    if (token == null) {
      throw Exception('用户未登录，无法更新帖子');
    }
    
    final post = await _forumService.updatePost(
      postId: postId,
      title: title,
      content: content,
      tags: tags,
      token: token,
    );
    
    // 更新缓存
    final index = _cachedPosts.indexWhere((item) => item.id == postId);
    if (index >= 0) {
      _cachedPosts[index] = post;
    }
    
    return post;
  }

  /// 删除帖子
  Future<bool> deletePost({
    required String postId,
  }) async {
    final token = _getToken();
    if (token == null) {
      throw Exception('用户未登录，无法删除帖子');
    }
    
    final result = await _forumService.deletePost(
      postId: postId,
      token: token,
    );
    
    // 从缓存中移除
    _cachedPosts.removeWhere((post) => post.id == postId);
    _cachedComments.remove(postId);
    
    return result;
  }

  /// 获取帖子评论
  Future<List<Comment>> getComments({
    required String postId,
    bool forceRefresh = false,
  }) async {
    // 如果不是强制刷新且缓存中有该帖子的评论，则从缓存返回
    if (!forceRefresh && _cachedComments.containsKey(postId)) {
      return _cachedComments[postId]!;
    }

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
  Future<Comment> addComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    final token = _getToken();
    if (token == null) {
      throw Exception('用户未登录，无法添加评论');
    }
    
    final comment = await _forumService.addComment(
      postId: postId,
      content: content,
      parentId: parentId,
      token: token,
    );
    
    // 更新缓存
    if (_cachedComments.containsKey(postId)) {
      _cachedComments[postId]!.add(comment);
    }
    
    // 更新帖子的评论数
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
  Future<bool> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    final token = _getToken();
    if (token == null) {
      throw Exception('用户未登录，无法删除评论');
    }
    
    final result = await _forumService.deleteComment(
      postId: postId,
      commentId: commentId,
      token: token,
    );
    
    // 从缓存中移除
    if (_cachedComments.containsKey(postId)) {
      _cachedComments[postId]!.removeWhere((comment) => comment.id == commentId);
    }
    
    // 更新帖子的评论数
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
  Future<bool> toggleLikePost({
    required String postId,
  }) async {
    final token = _getToken();
    if (token == null) {
      throw Exception('用户未登录，无法点赞');
    }
    
    final isLiked = await _forumService.toggleLikePost(
      postId: postId,
      token: token,
    );
    
    // 更新缓存中的帖子点赞状态
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
  Future<bool> toggleLikeComment({
    required String postId,
    required String commentId,
  }) async {
    final token = _getToken();
    if (token == null) {
      throw Exception('用户未登录，无法点赞');
    }
    
    final isLiked = await _forumService.toggleLikeComment(
      postId: postId,
      commentId: commentId,
      token: token,
    );
    
    // 更新缓存中的评论点赞状态
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
  void clearCache() {
    _cachedPosts = [];
    _cachedComments = {};
  }
}
