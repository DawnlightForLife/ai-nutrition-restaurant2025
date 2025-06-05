import 'search_result.dart';

/// 搜索查询实体
class SearchQuery {
  final String keyword;
  final List<SearchResultType>? types;
  final String? category;
  final List<String>? tags;
  final SearchSortType sortType;
  final int page;
  final int pageSize;
  final Map<String, dynamic>? filters;
  
  const SearchQuery({
    required this.keyword,
    this.types,
    this.category,
    this.tags,
    this.sortType = SearchSortType.relevance,
    this.page = 1,
    this.pageSize = 20,
    this.filters,
  });
  
  SearchQuery copyWith({
    String? keyword,
    List<SearchResultType>? types,
    String? category,
    List<String>? tags,
    SearchSortType? sortType,
    int? page,
    int? pageSize,
    Map<String, dynamic>? filters,
  }) {
    return SearchQuery(
      keyword: keyword ?? this.keyword,
      types: types ?? this.types,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      sortType: sortType ?? this.sortType,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      filters: filters ?? this.filters,
    );
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchQuery &&
          runtimeType == other.runtimeType &&
          keyword == other.keyword &&
          types == other.types &&
          category == other.category &&
          tags == other.tags &&
          sortType == other.sortType &&
          page == other.page &&
          pageSize == other.pageSize;
  
  @override
  int get hashCode =>
      keyword.hashCode ^
      types.hashCode ^
      category.hashCode ^
      tags.hashCode ^
      sortType.hashCode ^
      page.hashCode ^
      pageSize.hashCode;
}

/// 搜索排序类型
enum SearchSortType {
  relevance,    // 相关度
  newest,       // 最新
  popular,      // 最热门
  rating,       // 评分
  price,        // 价格
  distance,     // 距离
}

/// 搜索排序类型扩展
extension SearchSortTypeExtension on SearchSortType {
  String get displayName {
    switch (this) {
      case SearchSortType.relevance:
        return '相关度';
      case SearchSortType.newest:
        return '最新';
      case SearchSortType.popular:
        return '最热门';
      case SearchSortType.rating:
        return '评分';
      case SearchSortType.price:
        return '价格';
      case SearchSortType.distance:
        return '距离';
    }
  }
}