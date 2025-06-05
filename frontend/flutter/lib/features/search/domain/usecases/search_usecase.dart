import '../../../../core/base/use_case.dart';
import '../entities/search_query.dart';
import '../entities/search_result.dart';
import '../entities/search_suggestion.dart';
import '../repositories/search_repository.dart';

/// 搜索用例
class SearchUseCase implements UseCase<List<SearchResult>, SearchQuery> {
  final SearchRepository _repository;
  
  const SearchUseCase(this._repository);
  
  @override
  Future<List<SearchResult>> call(SearchQuery params) async {
    // 验证搜索关键词
    if (params.keyword.trim().isEmpty) {
      return [];
    }
    
    // 执行搜索
    final results = await _repository.search(params);
    
    // 保存搜索历史
    await _repository.saveSearchHistory(
      SearchHistoryItem(
        keyword: params.keyword.trim(),
        searchTime: DateTime.now(),
        resultCount: results.length,
      ),
    );
    
    // 上报搜索行为
    await _repository.reportSearchBehavior(
      keyword: params.keyword.trim(),
      resultType: params.types?.isNotEmpty == true ? params.types!.first : null,
      resultCount: results.length,
    );
    
    return results;
  }
}