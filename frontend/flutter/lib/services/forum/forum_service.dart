import 'dart:convert';
import 'package:flutter/material.dart';

import '../../models/forum/post.dart';
import '../../models/forum/comment.dart';
import '../api_service.dart';

/// 论坛服务类
///
/// 提供论坛相关API交互功能
class ForumService {
  final ApiService _apiService;

  ForumService(this._apiService);

  /// 获取论坛帖子列表
  ///
  /// [page] 页码，从1开始
  /// [limit] 每页数量
  /// [tag] 可选，按标签筛选
  /// [userId] 可选，按用户筛选
  Future<Map<String, dynamic>> getPosts({
    required int page,
    int limit = 10,
    String? tag,
    String? userId,
    String? token,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (tag != null) {
      queryParams['tag'] = tag;
    }

    if (userId != null) {
      queryParams['userId'] = userId;
    }

    final response = await _apiService.get(
      '/api/forum/posts',
      queryParams: queryParams,
      token: token,
    );

    // 处理响应数据
    final List<dynamic> postData = response['posts'];
    final List<Post> posts = postData.map((data) => Post.fromJson(data)).toList();

    return {
      'posts': posts,
      'total': response['total'],
      'page': response['page'],
      'totalPages': response['totalPages'],
    };
  }

  /// 获取帖子详情
  Future<Post> getPostDetail({
    required String postId,
    String? token,
  }) async {
    final response = await _apiService.get(
      '/api/forum/posts/$postId',
      token: token,
    );

    return Post.fromJson(response);
  }

  /// 创建新帖子
  Future<Post> createPost({
    required String title,
    required String content,
    List<String> tags = const [],
    required String token,
  }) async {
    final response = await _apiService.post(
      '/api/forum/posts',
      data: {
        'title': title,
        'content': content,
        'tags': tags,
      },
      token: token,
    );

    return Post.fromJson(response);
  }

  /// 更新帖子
  Future<Post> updatePost({
    required String postId,
    String? title,
    String? content,
    List<String>? tags,
    required String token,
  }) async {
    final Map<String, dynamic> data = {};

    if (title != null) data['title'] = title;
    if (content != null) data['content'] = content;
    if (tags != null) data['tags'] = tags;

    final response = await _apiService.put(
      '/api/forum/posts/$postId',
      data: data,
      token: token,
    );

    return Post.fromJson(response);
  }

  /// 删除帖子
  Future<bool> deletePost({
    required String postId,
    required String token,
  }) async {
    await _apiService.delete(
      '/api/forum/posts/$postId',
      token: token,
    );

    return true;
  }

  /// 获取帖子评论
  Future<List<Comment>> getComments({
    required String postId,
    String? token,
  }) async {
    final response = await _apiService.get(
      '/api/forum/posts/$postId/comments',
      token: token,
    );

    final List<dynamic> commentData = response['comments'];
    return commentData.map((data) => Comment.fromJson(data)).toList();
  }

  /// 添加评论
  Future<Comment> addComment({
    required String postId,
    required String content,
    String? parentId,
    required String token,
  }) async {
    final Map<String, dynamic> data = {
      'content': content,
    };

    if (parentId != null) {
      data['parentId'] = parentId;
    }

    final response = await _apiService.post(
      '/api/forum/posts/$postId/comments',
      data: data,
      token: token,
    );

    return Comment.fromJson(response);
  }

  /// 删除评论
  Future<bool> deleteComment({
    required String postId,
    required String commentId,
    required String token,
  }) async {
    await _apiService.delete(
      '/api/forum/posts/$postId/comments/$commentId',
      token: token,
    );

    return true;
  }

  /// 点赞/取消点赞帖子
  Future<bool> toggleLikePost({
    required String postId,
    required String token,
  }) async {
    final response = await _apiService.post(
      '/api/forum/posts/$postId/like',
      token: token,
    );

    return response['liked'] ?? false;
  }

  /// 点赞/取消点赞评论
  Future<bool> toggleLikeComment({
    required String postId,
    required String commentId,
    required String token,
  }) async {
    final response = await _apiService.post(
      '/api/forum/posts/$postId/comments/$commentId/like',
      token: token,
    );

    return response['liked'] ?? false;
  }
}
