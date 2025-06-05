/// 搜索结果实体
class SearchResult {
  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final String? imageUrl;
  final SearchResultType type;
  final String? url;
  final Map<String, dynamic>? data;
  final double? relevanceScore;
  final String? category;
  final List<String>? tags;
  
  const SearchResult({
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
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResult &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type;
  
  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}

/// 搜索结果类型枚举
enum SearchResultType {
  dish,          // 菜品
  merchant,      // 商家
  post,          // 帖子
  tag,           // 标签
  nutritionist, // 营养师
  promotion,    // 促销活动
  recipe,       // 食谱
}

/// 搜索结果类型扩展
extension SearchResultTypeExtension on SearchResultType {
  String get displayName {
    switch (this) {
      case SearchResultType.dish:
        return '菜品';
      case SearchResultType.merchant:
        return '商家';
      case SearchResultType.post:
        return '帖子';
      case SearchResultType.tag:
        return '标签';
      case SearchResultType.nutritionist:
        return '营养师';
      case SearchResultType.promotion:
        return '促销';
      case SearchResultType.recipe:
        return '食谱';
    }
  }
  
  String get icon {
    switch (this) {
      case SearchResultType.dish:
        return '🍽️';
      case SearchResultType.merchant:
        return '🏪';
      case SearchResultType.post:
        return '📝';
      case SearchResultType.tag:
        return '🏷️';
      case SearchResultType.nutritionist:
        return '👩‍⚕️';
      case SearchResultType.promotion:
        return '🎁';
      case SearchResultType.recipe:
        return '📄';
    }
  }
}