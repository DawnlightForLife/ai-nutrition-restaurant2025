import 'dart:convert';
import 'package:flutter/material.dart';

import '../../models/forum/post.dart';
import '../../models/forum/comment.dart';
import '../core/api_service.dart';
import '../../common/constants/api_constants.dart';

/// 论坛服务类
///
/// 提供论坛相关API交互功能
/// 负责与后端API通信，处理网络请求和响应数据的转换
class ForumService {
  /// API服务实例，用于发送HTTP请求
  final ApiService _apiService;

  /// 构造函数
  /// 
  /// @param apiService API服务实例
  ForumService(this._apiService);

  /// 获取论坛帖子列表
  ///
  /// 从服务器获取分页的帖子列表，支持多种筛选条件
  /// 
  /// @param page 页码，从1开始
  /// @param limit 每页数量
  /// @param tag 可选，按标签筛选
  /// @param userId 可选，按用户筛选
  /// @param token 用户令牌，可为空（未登录用户也可浏览）
  /// @return 包含帖子列表及分页信息的Map
  Future<Map<String, dynamic>> getPosts({
    required int page,
    int limit = 10,
    String? tag,
    String? userId,
    String? token,
  }) async {
    // 构建查询参数
    final Map<String, dynamic> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    // 添加可选的筛选条件
    if (tag != null) {
      queryParams['tag'] = tag;
    }

    if (userId != null) {
      queryParams['userId'] = userId;
    }

    // 发送GET请求获取帖子列表
    final response = await _apiService.get(
      ApiConstants.forumPost,
      queryParams: queryParams,
      token: token,
    );

    // 处理响应数据，将JSON转换为模型对象
    final List<dynamic> postData = response['posts'];
    final List<Post> posts = postData.map((data) => Post.fromJson(data)).toList();

    // 返回标准化的结果，包含帖子列表和分页信息
    return {
      'posts': posts,
      'total': response['total'],
      'page': response['page'],
      'totalPages': response['totalPages'],
    };
  }

  /// 获取帖子详情
  ///
  /// 根据帖子ID获取单个帖子的完整信息
  ///
  /// @param postId 帖子ID
  /// @param token 用户令牌，可选
  /// @return 帖子详情对象
  Future<Post> getPostDetail({
    required String postId,
    String? token,
  }) async {
    // 发送GET请求获取帖子详情
    final response = await _apiService.get(
      '${ApiConstants.forumPost}/$postId',
      token: token,
    );

    // 将响应数据转换为帖子模型对象
    return Post.fromJson(response);
  }

  /// 创建新帖子
  ///
  /// 将用户创建的帖子内容发送到服务器
  ///
  /// @param title 帖子标题
  /// @param content 帖子内容
  /// @param tags 帖子标签列表
  /// @param token 用户令牌，必须提供（需要登录）
  /// @return 创建成功的帖子对象
  Future<Post> createPost({
    required String title,
    required String content,
    List<String> tags = const [],
    required String token,
  }) async {
    // 发送POST请求创建帖子
    final response = await _apiService.post(
      ApiConstants.forumPost,
      data: {
        'title': title,
        'content': content,
        'tags': tags,
      },
      token: token,
    );

    // 将响应数据转换为帖子模型对象
    return Post.fromJson(response);
  }

  /// 更新帖子
  ///
  /// 更新现有帖子的内容或元数据
  ///
  /// @param postId 要更新的帖子ID
  /// @param title 新标题（可选）
  /// @param content 新内容（可选）
  /// @param tags 新标签列表（可选）
  /// @param token 用户令牌，必须提供（需要登录）
  /// @return 更新后的帖子对象
  Future<Post> updatePost({
    required String postId,
    String? title,
    String? content,
    List<String>? tags,
    required String token,
  }) async {
    // 构建更新数据，只包含需要更新的字段
    final Map<String, dynamic> data = {};

    if (title != null) data['title'] = title;
    if (content != null) data['content'] = content;
    if (tags != null) data['tags'] = tags;

    // 发送PUT请求更新帖子
    final response = await _apiService.put(
      '${ApiConstants.forumPost}/$postId',
      data: data,
      token: token,
    );

    // 将响应数据转换为帖子模型对象
    return Post.fromJson(response);
  }

  /// 删除帖子
  ///
  /// 从服务器永久删除指定帖子
  ///
  /// @param postId 要删除的帖子ID
  /// @param token 用户令牌，必须提供（需要登录）
  /// @return 操作是否成功
  Future<bool> deletePost({
    required String postId,
    required String token,
  }) async {
    // 发送DELETE请求删除帖子
    await _apiService.delete(
      '${ApiConstants.forumPost}/$postId',
      token: token,
    );

    // 删除成功返回true
    return true;
  }

  /// 获取帖子评论
  ///
  /// 获取某个帖子下的所有评论
  ///
  /// @param postId 帖子ID
  /// @param token 用户令牌，可选
  /// @return 评论列表
  Future<List<Comment>> getComments({
    required String postId,
    String? token,
  }) async {
    // 发送GET请求获取评论列表
    final response = await _apiService.get(
      '${ApiConstants.forumPost}/$postId/comments',
      token: token,
    );

    // 将响应数据转换为评论模型对象列表
    final List<dynamic> commentData = response['comments'];
    return commentData.map((data) => Comment.fromJson(data)).toList();
  }

  /// 添加评论
  ///
  /// 向指定帖子添加新评论
  ///
  /// @param postId 帖子ID
  /// @param content 评论内容
  /// @param token 用户令牌，必须提供（需要登录）
  /// @return 创建成功的评论对象
  Future<Comment> addComment({
    required String postId,
    required String content,
    required String token,
    String? parentId,
  }) async {
    // 发送POST请求添加评论
    final response = await _apiService.post(
      '${ApiConstants.forumPost}/$postId/comments',
      data: {
        'content': content,
        'parent_comment_id': parentId,
      },
      token: token,
    );

    // 将响应数据转换为评论模型对象
    return Comment.fromJson(response['comment']);
  }

  /// 删除评论
  ///
  /// 从服务器永久删除指定评论
  ///
  /// @param postId 帖子ID
  /// @param commentId 评论ID
  /// @param token 用户令牌，必须提供（需要登录）
  /// @return 操作是否成功
  Future<bool> deleteComment({
    required String postId,
    required String commentId,
    required String token,
  }) async {
    // 发送DELETE请求删除评论
    await _apiService.delete(
      '${ApiConstants.forumPost}/$postId/comments/$commentId',
      token: token,
    );

    // 删除成功返回true
    return true;
  }

  /// 点赞/取消点赞帖子
  ///
  /// 切换帖子的点赞状态
  ///
  /// @param postId 帖子ID
  /// @param token 用户令牌，必须提供（需要登录）
  /// @return 更新后的点赞状态
  Future<bool> toggleLikePost({
    required String postId,
    required String token,
  }) async {
    // 发送POST请求切换点赞状态
    final response = await _apiService.post(
      '${ApiConstants.forumPost}/$postId/like',
      token: token,
    );

    // 返回更新后的点赞状态
    return response['liked'] ?? false;
  }

  /// 点赞/取消点赞评论
  ///
  /// 切换评论的点赞状态
  ///
  /// @param postId 帖子ID
  /// @param commentId 评论ID
  /// @param token 用户令牌，必须提供（需要登录）
  /// @return 更新后的点赞状态
  Future<bool> toggleLikeComment({
    required String postId,
    required String commentId,
    required String token,
  }) async {
    // 发送POST请求切换评论点赞状态
    final response = await _apiService.post(
      '${ApiConstants.forumPost}/$postId/comments/$commentId/like',
      token: token,
    );

    // 返回更新后的点赞状态
    return response['liked'] ?? false;
  }
}
