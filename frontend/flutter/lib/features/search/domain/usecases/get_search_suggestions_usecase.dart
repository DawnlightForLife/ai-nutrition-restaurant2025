import '../../../../core/base/use_case.dart';
import '../entities/search_suggestion.dart';
import '../repositories/search_repository.dart';

/// 获取搜索建议用例
class GetSearchSuggestionsUseCase implements UseCase<List<SearchSuggestion>, String> {
  final SearchRepository _repository;
  
  const GetSearchSuggestionsUseCase(this._repository);
  
  @override
  Future<List<SearchSuggestion>> call(String keyword) async {
    final suggestions = <SearchSuggestion>[];
    
    if (keyword.trim().isEmpty) {
      // 获取热门关键词
      final hotKeywords = await _repository.getHotKeywords();
      suggestions.addAll(
        hotKeywords.map((keyword) => SearchSuggestion(
          text: keyword,
          type: SearchSuggestionType.hotKeyword,
        )),
      );
      
      // 获取搜索历史
      final history = await _repository.getSearchHistory();
      suggestions.addAll(
        history.take(5).map((item) => SearchSuggestion(
          text: item.keyword,
          type: SearchSuggestionType.history,
          count: item.resultCount,
        )),
      );
    } else {
      // 获取自动完成建议
      final autoComplete = await _repository.getSuggestions(keyword);
      suggestions.addAll(autoComplete);
    }
    
    return suggestions;
  }
}