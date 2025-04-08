import 'package:flutter/material.dart';

/// 论坛评论模型
/// 
/// 定义了论坛帖子评论的数据结构，包含评论内容、作者信息、点赞数据等
/// 支持评论嵌套回复功能，通过parentId字段标识回复关系
class Comment {
  /// 评论唯一标识符
  final String id;
  
  /// 评论所属帖子的ID
  final String postId;
  
  /// 评论内容
  final String content;
  
  /// 评论作者的用户ID
  final String authorId;
  
  /// 评论作者的用户名
  final String authorName;
  
  /// 评论作者的头像URL，可为空
  final String? authorAvatar;
  
  /// 评论创建时间
  final DateTime createdAt;
  
  /// 评论获得的点赞数量
  final int likeCount;
  
  /// 当前用户是否已点赞该评论
  final bool isLiked;
  
  /// 父评论ID，用于评论回复功能
  /// 如果是直接评论帖子，则为null
  /// 如果是回复其他评论，则存储被回复评论的ID
  final String? parentId;

  /// 构造函数
  /// 
  /// @param id 评论ID，必须提供
  /// @param postId 所属帖子ID，必须提供
  /// @param content 评论内容，必须提供
  /// @param authorId 作者ID，必须提供
  /// @param authorName 作者名称，必须提供
  /// @param authorAvatar 作者头像URL，可选
  /// @param createdAt 创建时间，必须提供
  /// @param likeCount 点赞数，默认为0
  /// @param isLiked 当前用户是否点赞，默认为false
  /// @param parentId 父评论ID，用于回复功能，可选
  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.createdAt,
    this.likeCount = 0,
    this.isLiked = false,
    this.parentId,
  });

  /// 从JSON创建评论实例
  /// 
  /// 将API返回的JSON数据转换为Comment对象
  /// 处理可能缺失的字段并设置默认值
  /// 
  /// @param json 包含评论数据的Map
  /// @return 根据JSON数据创建的Comment对象
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      content: json['content'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorAvatar: json['authorAvatar'],
      createdAt: DateTime.parse(json['createdAt']),
      likeCount: json['likeCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      parentId: json['parentId'],
    );
  }

  /// 转换为JSON
  /// 
  /// 将Comment对象序列化为可用于API请求或本地存储的Map
  /// 确保所有字段都正确编码，包括日期时间字段的ISO格式转换
  /// 
  /// @return 表示Comment对象的Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'createdAt': createdAt.toIso8601String(),
      'likeCount': likeCount,
      'isLiked': isLiked,
      'parentId': parentId,
    };
  }

  /// 创建更新后的评论实例
  /// 
  /// 基于当前评论创建一个新的Comment对象，可选择性地更新特定字段
  /// 遵循不可变设计模式，返回一个新对象而不是修改现有对象
  /// 
  /// @param id 新的评论ID（可选）
  /// @param postId 新的帖子ID（可选）
  /// @param content 新的内容（可选）
  /// @param authorId 新的作者ID（可选）
  /// @param authorName 新的作者名称（可选）
  /// @param authorAvatar 新的作者头像（可选）
  /// @param createdAt 新的创建时间（可选）
  /// @param likeCount 新的点赞数（可选）
  /// @param isLiked 新的点赞状态（可选）
  /// @param parentId 新的父评论ID（可选）
  /// @return 更新后的新Comment对象
  Comment copyWith({
    String? id,
    String? postId,
    String? content,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    DateTime? createdAt,
    int? likeCount,
    bool? isLiked,
    String? parentId,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      parentId: parentId ?? this.parentId,
    );
  }
}
