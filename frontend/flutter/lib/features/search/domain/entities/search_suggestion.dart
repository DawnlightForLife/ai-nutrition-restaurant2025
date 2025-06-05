import 'search_result.dart';

/// 搜索建议实体
class SearchSuggestion {
  final String text;
  final SearchSuggestionType type;
  final int? count;
  final String? description;
  final String? imageUrl;
  final Map<String, dynamic>? data;
  
  const SearchSuggestion({
    required this.text,
    required this.type,
    this.count,
    this.description,
    this.imageUrl,
    this.data,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchSuggestion &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          type == other.type;
  
  @override
  int get hashCode => text.hashCode ^ type.hashCode;
}

/// 搜索建议类型
enum SearchSuggestionType {
  history,      // 历史搜索
  hotKeyword,   // 热门关键词
  autoComplete, // 自动完成
  category,     // 分类建议
  tag,          // 标签建议
}

/// 搜索建议类型扩展
extension SearchSuggestionTypeExtension on SearchSuggestionType {
  String get displayName {
    switch (this) {
      case SearchSuggestionType.history:
        return '历史搜索';
      case SearchSuggestionType.hotKeyword:
        return '热门搜索';
      case SearchSuggestionType.autoComplete:
        return '搜索建议';
      case SearchSuggestionType.category:
        return '分类';
      case SearchSuggestionType.tag:
        return '标签';
    }
  }
}

/// 搜索历史项
class SearchHistoryItem {
  final String keyword;
  final DateTime searchTime;
  final SearchResultType? resultType;
  final int? resultCount;
  
  const SearchHistoryItem({
    required this.keyword,
    required this.searchTime,
    this.resultType,
    this.resultCount,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchHistoryItem &&
          runtimeType == other.runtimeType &&
          keyword == other.keyword;
  
  @override
  int get hashCode => keyword.hashCode;
}