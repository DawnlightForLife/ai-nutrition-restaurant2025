import '../../../../core/base/use_case.dart';
import '../entities/search_suggestion.dart';
import '../repositories/search_repository.dart';

/// 管理搜索历史用例
class ManageSearchHistoryUseCase {
  final SearchRepository _repository;
  
  const ManageSearchHistoryUseCase(this._repository);
  
  /// 获取搜索历史
  Future<List<SearchHistoryItem>> getHistory() async {
    return await _repository.getSearchHistory();
  }
  
  /// 清空搜索历史
  Future<void> clearHistory() async {
    await _repository.clearSearchHistory();
  }
  
  /// 删除单个搜索历史
  Future<void> deleteHistoryItem(String keyword) async {
    await _repository.deleteSearchHistory(keyword);
  }
  
  /// 保存搜索历史
  Future<void> saveHistory(SearchHistoryItem item) async {
    await _repository.saveSearchHistory(item);
  }
}