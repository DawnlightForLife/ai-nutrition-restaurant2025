import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/search_suggestion.dart';
import '../../domain/entities/search_result.dart';

/// 搜索本地数据源接口
abstract class SearchLocalDataSource {
  Future<List<SearchHistoryItem>> getSearchHistory();
  Future<void> saveSearchHistory(SearchHistoryItem historyItem);
  Future<void> clearSearchHistory();
  Future<void> deleteSearchHistory(String keyword);
}

/// 搜索本地数据源实现
class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final SharedPreferences _prefs;
  static const String _searchHistoryKey = 'search_history';
  static const int _maxHistoryItems = 20;
  
  const SearchLocalDataSourceImpl(this._prefs);
  
  @override
  Future<List<SearchHistoryItem>> getSearchHistory() async {
    try {
      final historyJson = _prefs.getStringList(_searchHistoryKey) ?? [];
      final historyItems = historyJson
          .map((json) => _parseHistoryItem(json))
          .where((item) => item != null)
          .cast<SearchHistoryItem>()
          .toList();
      
      // 按搜索时间降序排列
      historyItems.sort((a, b) => b.searchTime.compareTo(a.searchTime));
      
      return historyItems;
    } catch (e) {
      return [];
    }
  }
  
  @override
  Future<void> saveSearchHistory(SearchHistoryItem historyItem) async {
    try {
      final currentHistory = await getSearchHistory();
      
      // 移除已存在的相同关键词
      currentHistory.removeWhere((item) => item.keyword == historyItem.keyword);
      
      // 添加新的搜索记录到开头
      currentHistory.insert(0, historyItem);
      
      // 限制历史记录数量
      if (currentHistory.length > _maxHistoryItems) {
        currentHistory.removeRange(_maxHistoryItems, currentHistory.length);
      }
      
      // 保存到本地存储
      final historyJson = currentHistory
          .map((item) => _serializeHistoryItem(item))
          .toList();
      
      await _prefs.setStringList(_searchHistoryKey, historyJson);
    } catch (e) {
      // 忽略保存错误
    }
  }
  
  @override
  Future<void> clearSearchHistory() async {
    try {
      await _prefs.remove(_searchHistoryKey);
    } catch (e) {
      // 忽略清理错误
    }
  }
  
  @override
  Future<void> deleteSearchHistory(String keyword) async {
    try {
      final currentHistory = await getSearchHistory();
      currentHistory.removeWhere((item) => item.keyword == keyword);
      
      final historyJson = currentHistory
          .map((item) => _serializeHistoryItem(item))
          .toList();
      
      await _prefs.setStringList(_searchHistoryKey, historyJson);
    } catch (e) {
      // 忽略删除错误
    }
  }
  
  /// 序列化搜索历史项
  String _serializeHistoryItem(SearchHistoryItem item) {
    return jsonEncode({
      'keyword': item.keyword,
      'searchTime': item.searchTime.toIso8601String(),
      'resultType': item.resultType?.name,
      'resultCount': item.resultCount,
    });
  }
  
  /// 解析搜索历史项
  SearchHistoryItem? _parseHistoryItem(String json) {
    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      return SearchHistoryItem(
        keyword: data['keyword'] as String,
        searchTime: DateTime.parse(data['searchTime'] as String),
        resultType: data['resultType'] != null 
            ? _parseResultType(data['resultType'] as String)
            : null,
        resultCount: data['resultCount'] as int?,
      );
    } catch (e) {
      return null;
    }
  }
  
  /// 解析搜索结果类型
  SearchResultType? _parseResultType(String type) {
    switch (type) {
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
        return null;
    }
  }
}