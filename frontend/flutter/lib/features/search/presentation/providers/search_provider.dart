import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/search_query.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/entities/search_suggestion.dart';
import '../../domain/usecases/search_usecase.dart';
import '../../domain/usecases/get_search_suggestions_usecase.dart';
import '../../domain/usecases/manage_search_history_usecase.dart';

/// 搜索状态
class SearchState {
  final List<SearchResult> results;
  final List<SearchSuggestion> suggestions;
  final List<SearchHistoryItem> history;
  final List<String> hotKeywords;
  final bool isLoading;
  final bool isSuggestionLoading;
  final String? error;
  final SearchQuery? currentQuery;
  final bool hasMore;
  final int currentPage;
  
  const SearchState({
    this.results = const [],
    this.suggestions = const [],
    this.history = const [],
    this.hotKeywords = const [],
    this.isLoading = false,
    this.isSuggestionLoading = false,
    this.error,
    this.currentQuery,
    this.hasMore = true,
    this.currentPage = 1,
  });
  
  SearchState copyWith({
    List<SearchResult>? results,
    List<SearchSuggestion>? suggestions,
    List<SearchHistoryItem>? history,
    List<String>? hotKeywords,
    bool? isLoading,
    bool? isSuggestionLoading,
    String? error,
    SearchQuery? currentQuery,
    bool? hasMore,
    int? currentPage,
  }) {
    return SearchState(
      results: results ?? this.results,
      suggestions: suggestions ?? this.suggestions,
      history: history ?? this.history,
      hotKeywords: hotKeywords ?? this.hotKeywords,
      isLoading: isLoading ?? this.isLoading,
      isSuggestionLoading: isSuggestionLoading ?? this.isSuggestionLoading,
      error: error,
      currentQuery: currentQuery ?? this.currentQuery,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// 搜索状态通知器
class SearchNotifier extends StateNotifier<SearchState> {
  final SearchUseCase _searchUseCase;
  final GetSearchSuggestionsUseCase _getSuggestionsUseCase;
  final ManageSearchHistoryUseCase _manageHistoryUseCase;
  
  SearchNotifier(
    this._searchUseCase,
    this._getSuggestionsUseCase,
    this._manageHistoryUseCase,
  ) : super(const SearchState()) {
    _loadInitialData();
  }
  
  /// 加载初始数据
  Future<void> _loadInitialData() async {
    try {
      final history = await _manageHistoryUseCase.getHistory();
      final suggestions = await _getSuggestionsUseCase.call('');
      
      state = state.copyWith(
        history: history,
        suggestions: suggestions,
      );
    } catch (e) {
      state = state.copyWith(error: '加载初始数据失败: $e');
    }
  }
  
  /// 执行搜索
  Future<void> search(String keyword, {
    List<SearchResultType>? types,
    String? category,
    SearchSortType sortType = SearchSortType.relevance,
    bool isNewSearch = true,
  }) async {
    if (keyword.trim().isEmpty) {
      state = state.copyWith(
        results: [],
        currentQuery: null,
        hasMore: true,
        currentPage: 1,
      );
      return;
    }
    
    final query = SearchQuery(
      keyword: keyword.trim(),
      types: types,
      category: category,
      sortType: sortType,
      page: isNewSearch ? 1 : state.currentPage + 1,
    );
    
    if (isNewSearch) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentQuery: query,
        currentPage: 1,
        hasMore: true,
      );
    } else {
      state = state.copyWith(isLoading: true);
    }
    
    try {
      final results = await _searchUseCase.call(query);
      
      if (isNewSearch) {
        state = state.copyWith(
          results: results,
          isLoading: false,
          hasMore: results.length >= query.pageSize,
        );
      } else {
        state = state.copyWith(
          results: [...state.results, ...results],
          isLoading: false,
          currentPage: state.currentPage + 1,
          hasMore: results.length >= query.pageSize,
        );
      }
      
      // 刷新搜索历史
      await _refreshHistory();
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '搜索失败: $e',
      );
    }
  }
  
  /// 加载更多搜索结果
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading || state.currentQuery == null) {
      return;
    }
    
    await search(
      state.currentQuery!.keyword,
      types: state.currentQuery!.types,
      category: state.currentQuery!.category,
      sortType: state.currentQuery!.sortType,
      isNewSearch: false,
    );
  }
  
  /// 获取搜索建议
  Future<void> getSuggestions(String keyword) async {
    state = state.copyWith(isSuggestionLoading: true);
    
    try {
      final suggestions = await _getSuggestionsUseCase.call(keyword);
      state = state.copyWith(
        suggestions: suggestions,
        isSuggestionLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isSuggestionLoading: false,
        error: '获取搜索建议失败: $e',
      );
    }
  }
  
  /// 清空搜索结果
  void clearResults() {
    state = state.copyWith(
      results: [],
      currentQuery: null,
      hasMore: true,
      currentPage: 1,
    );
  }
  
  /// 刷新搜索历史
  Future<void> _refreshHistory() async {
    try {
      final history = await _manageHistoryUseCase.getHistory();
      state = state.copyWith(history: history);
    } catch (e) {
      // 忽略刷新历史失败
    }
  }
  
  /// 清空搜索历史
  Future<void> clearHistory() async {
    try {
      await _manageHistoryUseCase.clearHistory();
      state = state.copyWith(history: []);
    } catch (e) {
      state = state.copyWith(error: '清空搜索历史失败: $e');
    }
  }
  
  /// 删除单个搜索历史
  Future<void> deleteHistoryItem(String keyword) async {
    try {
      await _manageHistoryUseCase.deleteHistoryItem(keyword);
      await _refreshHistory();
    } catch (e) {
      state = state.copyWith(error: '删除搜索历史失败: $e');
    }
  }
  
  /// 清除错误状态
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// 依赖提供者
final searchUseCaseProvider = Provider<SearchUseCase>((ref) {
  throw UnimplementedError('SearchUseCase not implemented');
});

final getSuggestionsUseCaseProvider = Provider<GetSearchSuggestionsUseCase>((ref) {
  throw UnimplementedError('GetSearchSuggestionsUseCase not implemented');
});

final manageHistoryUseCaseProvider = Provider<ManageSearchHistoryUseCase>((ref) {
  throw UnimplementedError('ManageSearchHistoryUseCase not implemented');
});

// 测试用搜索provider
final testSearchProvider = StateNotifierProvider<TestSearchNotifier, SearchState>((ref) {
  return TestSearchNotifier();
});

/// 测试用搜索通知器
class TestSearchNotifier extends StateNotifier<SearchState> {
  TestSearchNotifier() : super(_createTestState());
  
  static SearchState _createTestState() {
    return SearchState(
      results: [
        SearchResult(
          id: '1',
          title: '番茄炒蛋',
          description: '经典家常菜，营养丰富',
          type: SearchResultType.dish,
          imageUrl: null,
          relevanceScore: 4.5,
          tags: ['家常菜', '低脂', '高蛋白'],
          data: {
            'price': 18.0,
            'calories': 120,
          },
        ),
        SearchResult(
          id: '2',
          title: '麻婆豆腐',
          description: '四川名菜，麻辣鲜香',
          type: SearchResultType.dish,
          imageUrl: null,
          relevanceScore: 4.2,
          tags: ['川菜', '素食', '辣'],
          data: {
            'price': 22.0,
            'calories': 200,
          },
        ),
      ],
      suggestions: [
        SearchSuggestion(
          text: '番茄',
          type: SearchSuggestionType.autoComplete,
          count: 25,
        ),
        SearchSuggestion(
          text: '炒蛋',
          type: SearchSuggestionType.autoComplete,
          count: 18,
        ),
      ],
      history: [
        SearchHistoryItem(
          keyword: '蛋白质',
          searchTime: DateTime.now().subtract(const Duration(hours: 2)),
          resultType: SearchResultType.dish,
          resultCount: 12,
        ),
        SearchHistoryItem(
          keyword: '低脂',
          searchTime: DateTime.now().subtract(const Duration(days: 1)),
          resultType: SearchResultType.dish,
          resultCount: 8,
        ),
      ],
      hotKeywords: ['减脂餐', '高蛋白', '素食', '川菜', '家常菜'],
    );
  }
  
  void search(String keyword, {
    List<SearchResultType>? types,
    String? category,
    SearchSortType? sortType,
    bool isNewSearch = true,
  }) {
    // 模拟搜索延迟
    state = state.copyWith(isLoading: true);
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final filtered = _createTestState().results.where((result) {
          return result.title.contains(keyword) || 
                 (result.description?.contains(keyword) ?? false) ||
                 (result.tags?.any((tag) => tag.contains(keyword)) ?? false);
        }).toList();
        
        state = state.copyWith(
          results: filtered,
          isLoading: false,
          currentQuery: SearchQuery(
            keyword: keyword,
            types: types,
            category: category,
            sortType: sortType ?? SearchSortType.relevance,
          ),
        );
      }
    });
  }
  
  void getSuggestions(String keyword) {
    if (keyword.isEmpty) {
      state = state.copyWith(suggestions: []);
      return;
    }
    
    final suggestions = _createTestState().suggestions.where((s) {
      return s.text.contains(keyword);
    }).toList();
    
    state = state.copyWith(suggestions: suggestions);
  }
  
  void clearResults() {
    state = state.copyWith(results: [], currentQuery: null);
  }
  
  void loadMore() {
    // 测试provider中暂不实现loadMore
  }
}

// 导出用于测试的搜索provider别名
final searchProvider = testSearchProvider;