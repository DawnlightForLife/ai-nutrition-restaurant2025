import '../../domain/entities/search_result.dart';

/// 搜索结果数据模型
class SearchResultModel {
  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final String? imageUrl;
  final String type;
  final String? url;
  final Map<String, dynamic>? data;
  final double? relevanceScore;
  final String? category;
  final List<String>? tags;
  
  const SearchResultModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    this.imageUrl,
    required this.type,
    this.url,
    this.data,
    this.relevanceScore,
    this.category,
    this.tags,
  });
  
  /// 从JSON创建模型
  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      subtitle: json['subtitle']?.toString(),
      description: json['description']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      type: (json['type'] ?? 'dish').toString(),
      url: json['url']?.toString(),
      data: json['data'] as Map<String, dynamic>?,
      relevanceScore: (json['relevanceScore'] as num?)?.toDouble(),
      category: json['category']?.toString(),
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
  
  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'imageUrl': imageUrl,
      'type': type,
      'url': url,
      'data': data,
      'relevanceScore': relevanceScore,
      'category': category,
      'tags': tags,
    };
  }
  
  /// 转换为领域实体
  SearchResult toEntity() {
    return SearchResult(
      id: id,
      title: title,
      subtitle: subtitle,
      description: description,
      imageUrl: imageUrl,
      type: _mapStringToResultType(type),
      url: url,
      data: data,
      relevanceScore: relevanceScore,
      category: category,
      tags: tags,
    );
  }
  
  /// 字符串转搜索结果类型
  SearchResultType _mapStringToResultType(String typeString) {
    switch (typeString.toLowerCase()) {
      case 'dish':
        return SearchResultType.dish;
      case 'merchant':
        return SearchResultType.merchant;
      case 'post':
        return SearchResultType.post;
      case 'tag':
        return SearchResultType.tag;
      case 'nutritionist':
        return SearchResultType.nutritionist;
      case 'promotion':
        return SearchResultType.promotion;
      case 'recipe':
        return SearchResultType.recipe;
      default:
        return SearchResultType.dish;
    }
  }
}