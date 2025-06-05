import '../entities/search_query.dart';
import '../entities/search_result.dart';
import '../entities/search_suggestion.dart';

/// 搜索仓储接口
abstract class SearchRepository {
  /// 执行搜索
  Future<List<SearchResult>> search(SearchQuery query);
  
  /// 获取搜索建议
  Future<List<SearchSuggestion>> getSuggestions(String keyword);
  
  /// 获取热门关键词
  Future<List<String>> getHotKeywords();
  
  /// 获取搜索历史
  Future<List<SearchHistoryItem>> getSearchHistory();
  
  /// 保存搜索历史
  Future<void> saveSearchHistory(SearchHistoryItem historyItem);
  
  /// 清空搜索历史
  Future<void> clearSearchHistory();
  
  /// 删除单个搜索历史
  Future<void> deleteSearchHistory(String keyword);
  
  /// 获取搜索趋势
  Future<List<String>> getSearchTrends();
  
  /// 上报搜索行为
  Future<void> reportSearchBehavior({
    required String keyword,
    required SearchResultType? resultType,
    int? resultCount,
    int? clickPosition,
    String? clickedItemId,
  });
  
  /// 获取分类建议
  Future<List<String>> getCategorySuggestions();
  
  /// 获取标签建议
  Future<List<String>> getTagSuggestions();
}