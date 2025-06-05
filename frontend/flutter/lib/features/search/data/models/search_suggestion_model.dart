import '../../domain/entities/search_suggestion.dart';

/// 搜索建议数据模型
class SearchSuggestionModel {
  final String text;
  final String type;
  final int? count;
  final String? description;
  final String? imageUrl;
  final Map<String, dynamic>? data;
  
  const SearchSuggestionModel({
    required this.text,
    required this.type,
    this.count,
    this.description,
    this.imageUrl,
    this.data,
  });
  
  /// 从JSON创建模型
  factory SearchSuggestionModel.fromJson(Map<String, dynamic> json) {
    return SearchSuggestionModel(
      text: (json['text'] ?? '').toString(),
      type: (json['type'] ?? 'autoComplete').toString(),
      count: json['count'] as int?,
      description: json['description']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      data: json['data'] as Map<String, dynamic>?,
    );
  }
  
  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type,
      'count': count,
      'description': description,
      'imageUrl': imageUrl,
      'data': data,
    };
  }
  
  /// 转换为领域实体
  SearchSuggestion toEntity() {
    return SearchSuggestion(
      text: text,
      type: _mapStringToSuggestionType(type),
      count: count,
      description: description,
      imageUrl: imageUrl,
      data: data,
    );
  }
  
  /// 字符串转搜索建议类型
  SearchSuggestionType _mapStringToSuggestionType(String typeString) {
    switch (typeString.toLowerCase()) {
      case 'history':
        return SearchSuggestionType.history;
      case 'hotkeyword':
        return SearchSuggestionType.hotKeyword;
      case 'autocomplete':
        return SearchSuggestionType.autoComplete;
      case 'category':
        return SearchSuggestionType.category;
      case 'tag':
        return SearchSuggestionType.tag;
      default:
        return SearchSuggestionType.autoComplete;
    }
  }
}