import 'package:flutter/material.dart';

/// 论坛帖子模型
/// 
/// 定义了论坛帖子的数据结构，包含帖子的基本信息、作者信息、统计数据等
/// 实现了序列化和反序列化方法，支持数据持久化和网络传输
class Post {
  /// 帖子唯一标识符
  final String id;
  
  /// 帖子标题
  final String title;
  
  /// 帖子内容正文
  final String content;
  
  /// 作者用户ID
  final String authorId;
  
  /// 作者用户名
  final String authorName;
  
  /// 作者头像URL，可为空
  final String? authorAvatar;
  
  /// 帖子创建时间
  final DateTime createdAt;
  
  /// 帖子最后更新时间
  final DateTime updatedAt;
  
  /// 帖子获得的点赞数量
  final int likeCount;
  
  /// 帖子的评论数量
  final int commentCount;
  
  /// 帖子的标签列表
  final List<String> tags;
  
  /// 当前用户是否已点赞该帖子
  final bool isLiked;

  /// 构造函数
  /// 
  /// @param id 帖子ID，必须提供
  /// @param title 帖子标题，必须提供
  /// @param content 帖子内容，必须提供
  /// @param authorId 作者ID，必须提供
  /// @param authorName 作者名称，必须提供
  /// @param authorAvatar 作者头像URL，可选
  /// @param createdAt 创建时间，必须提供
  /// @param updatedAt 更新时间，必须提供
  /// @param likeCount 点赞数，默认为0
  /// @param commentCount 评论数，默认为0
  /// @param tags 标签列表，默认为空列表
  /// @param isLiked 当前用户是否点赞，默认为false
  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.createdAt,
    required this.updatedAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.tags = const [],
    this.isLiked = false,
  });

  /// 从JSON创建帖子实例
  /// 
  /// 将API返回的JSON数据转换为Post对象
  /// 处理可能缺失的字段并设置默认值
  /// 
  /// @param json 包含帖子数据的Map
  /// @return 根据JSON数据创建的Post对象
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorAvatar: json['authorAvatar'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      isLiked: json['isLiked'] ?? false,
    );
  }

  /// 转换为JSON
  /// 
  /// 将Post对象序列化为可用于API请求或本地存储的Map
  /// 确保所有字段都正确编码，包括日期时间字段的ISO格式转换
  /// 
  /// @return 表示Post对象的Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'likeCount': likeCount,
      'commentCount': commentCount,
      'tags': tags,
      'isLiked': isLiked,
    };
  }

  /// 创建更新后的帖子实例
  /// 
  /// 基于当前帖子创建一个新的Post对象，可选择性地更新特定字段
  /// 遵循不可变设计模式，返回一个新对象而不是修改现有对象
  /// 
  /// @param id 新的帖子ID（可选）
  /// @param title 新的标题（可选）
  /// @param content 新的内容（可选）
  /// @param authorId 新的作者ID（可选）
  /// @param authorName 新的作者名称（可选）
  /// @param authorAvatar 新的作者头像（可选）
  /// @param createdAt 新的创建时间（可选）
  /// @param updatedAt 新的更新时间（可选）
  /// @param likeCount 新的点赞数（可选）
  /// @param commentCount 新的评论数（可选）
  /// @param tags 新的标签列表（可选）
  /// @param isLiked 新的点赞状态（可选）
  /// @return 更新后的新Post对象
  Post copyWith({
    String? id,
    String? title,
    String? content,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likeCount,
    int? commentCount,
    List<String>? tags,
    bool? isLiked,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      tags: tags ?? this.tags,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
