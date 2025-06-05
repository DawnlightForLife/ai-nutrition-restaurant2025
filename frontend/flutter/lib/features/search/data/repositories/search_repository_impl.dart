import '../../domain/entities/search_query.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/entities/search_suggestion.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_datasource.dart';
import '../datasources/search_local_datasource.dart';

/// 搜索仓储实现
class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;
  final SearchLocalDataSource _localDataSource;
  
  const SearchRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );
  
  @override
  Future<List<SearchResult>> search(SearchQuery query) async {
    try {
      final results = await _remoteDataSource.search(query);
      return results.map((model) => model.toEntity()).toList();
    } catch (e) {
      // TODO: 使用日志系统替代print
      return [];
    }
  }
  
  @override
  Future<List<SearchSuggestion>> getSuggestions(String keyword) async {
    try {
      final suggestions = await _remoteDataSource.getSuggestions(keyword);
      return suggestions.map((model) => model.toEntity()).toList();
    } catch (e) {
      // TODO: 使用日志系统替代print
      return [];
    }
  }
  
  @override
  Future<List<String>> getHotKeywords() async {
    try {
      return await _remoteDataSource.getHotKeywords();
    } catch (e) {
      // TODO: 使用日志系统替代print
      return [];
    }
  }
  
  @override
  Future<List<SearchHistoryItem>> getSearchHistory() async {
    try {
      return await _localDataSource.getSearchHistory();
    } catch (e) {
      // TODO: 使用日志系统替代print
      return [];
    }
  }
  
  @override
  Future<void> saveSearchHistory(SearchHistoryItem historyItem) async {
    try {
      await _localDataSource.saveSearchHistory(historyItem);
    } catch (e) {
      // TODO: 使用日志系统替代print
    }
  }
  
  @override
  Future<void> clearSearchHistory() async {
    try {
      await _localDataSource.clearSearchHistory();
    } catch (e) {
      // TODO: 使用日志系统替代print
    }
  }
  
  @override
  Future<void> deleteSearchHistory(String keyword) async {
    try {
      await _localDataSource.deleteSearchHistory(keyword);
    } catch (e) {
      // TODO: 使用日志系统替代print
    }
  }
  
  @override
  Future<List<String>> getSearchTrends() async {
    try {
      return await _remoteDataSource.getSearchTrends();
    } catch (e) {
      // TODO: 使用日志系统替代print
      return [];
    }
  }
  
  @override
  Future<void> reportSearchBehavior({
    required String keyword,
    required SearchResultType? resultType,
    int? resultCount,
    int? clickPosition,
    String? clickedItemId,
  }) async {
    try {
      await _remoteDataSource.reportSearchBehavior(
        keyword: keyword,
        resultType: resultType?.toString().split('.').last,
        resultCount: resultCount,
        clickPosition: clickPosition,
        clickedItemId: clickedItemId,
      );
    } catch (e) {
      // TODO: 使用日志系统替代print
    }
  }
  
  @override
  Future<List<String>> getCategorySuggestions() async {
    try {
      return await _remoteDataSource.getCategorySuggestions();
    } catch (e) {
      // TODO: 使用日志系统替代print
      return [];
    }
  }
  
  @override
  Future<List<String>> getTagSuggestions() async {
    try {
      return await _remoteDataSource.getTagSuggestions();
    } catch (e) {
      // TODO: 使用日志系统替代print
      return [];
    }
  }
}