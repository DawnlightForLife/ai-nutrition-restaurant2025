import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/entities/search_query.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/search_suggestions_list.dart';
import '../widgets/search_results_list.dart';
import '../widgets/search_filters.dart';
import '../providers/search_provider.dart';

/// 搜索页面
class SearchPage extends ConsumerStatefulWidget {
  final String? initialQuery;
  
  const SearchPage({
    super.key,
    this.initialQuery,
  });
  
  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  
  List<SearchResultType>? _selectedTypes;
  String? _selectedCategory;
  SearchSortType _sortType = SearchSortType.relevance;
  
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _searchFocusNode = FocusNode();
    
    // 如果有初始查询，立即搜索
    if (widget.initialQuery?.isNotEmpty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performSearch(widget.initialQuery!);
      });
    } else {
      // 否则聚焦搜索框
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.requestFocus();
      });
    }
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
  
  /// 处理搜索输入变化
  void _onSearchInputChanged(String keyword) {
    if (keyword.trim().isEmpty) {
      // 清空搜索结果和建议
      ref.read(searchProvider.notifier).clearResults();
    } else {
      // 获取搜索建议
      ref.read(searchProvider.notifier).getSuggestions(keyword.trim());
    }
  }
  
  /// 执行搜索
  void _performSearch(String keyword) {
    if (keyword.trim().isEmpty) return;
    
    final searchNotifier = ref.read(searchProvider.notifier);
    searchNotifier.search(
      keyword,
      types: _selectedTypes,
      category: _selectedCategory,
      sortType: _sortType,
    );
    
    // 失去焦点
    _searchFocusNode.unfocus();
  }
  
  /// 处理搜索建议选择
  void _onSuggestionSelected(String suggestion) {
    _searchController.text = suggestion;
    _performSearch(suggestion);
  }
  
  /// 处理搜索结果点击
  void _onResultTap(SearchResult result) {
    // 根据结果类型导航到对应页面
    switch (result.type) {
      case SearchResultType.dish:
        // TODO: 导航到菜品详情页
        // ref.read(appNavigatorProvider).pushNamed('/dish/${result.id}');
        break;
      case SearchResultType.merchant:
        // TODO: 导航到商家详情页
        // ref.read(appNavigatorProvider).pushNamed('/merchant/${result.id}');
        break;
      case SearchResultType.post:
        // TODO: 导航到帖子详情页
        // ref.read(appNavigatorProvider).pushNamed('/forum/post/${result.id}');
        break;
      case SearchResultType.nutritionist:
        // TODO: 导航到营养师详情页
        // ref.read(appNavigatorProvider).pushNamed('/nutritionist/${result.id}');
        break;
      default:
        // 显示详情对话框或进入通用详情页
        _showResultDetail(result);
    }
  }
  
  /// 显示搜索结果详情
  void _showResultDetail(SearchResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(result.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result.subtitle != null) ...[
              Text(
                result.subtitle!,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
            ],
            if (result.description != null) ...[
              Text(result.description!),
              const SizedBox(height: 8),
            ],
            Text(
              '类型: ${result.type.displayName}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (result.category != null) ...[
              const SizedBox(height: 4),
              Text(
                '分类: ${result.category}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (result.tags?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                children: result.tags!
                    .map((tag) => Chip(
                          label: Text(tag),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
  
  /// 处理筛选器变化
  void _onFiltersChanged({
    List<SearchResultType>? types,
    String? category,
    SearchSortType? sortType,
  }) {
    setState(() {
      _selectedTypes = types;
      _selectedCategory = category;
      _sortType = sortType ?? _sortType;
    });
    
    // 如果当前有搜索内容，重新搜索
    if (_searchController.text.trim().isNotEmpty) {
      _performSearch(_searchController.text);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchState = ref.watch(searchProvider);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: SearchAppBar(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onSearch: _performSearch,
        onSuggestionSelected: _onSuggestionSelected,
        onChanged: _onSearchInputChanged,
      ),
      body: Column(
        children: [
          // 搜索筛选器
          SearchFilters(
            selectedTypes: _selectedTypes,
            selectedCategory: _selectedCategory,
            sortType: _sortType,
            onFiltersChanged: _onFiltersChanged,
          ),
          
          // 搜索内容区域
          Expanded(
            child: _buildSearchContent(),
          ),
        ],
      ),
    );
  }
  
  /// 构建搜索内容
  Widget _buildSearchContent() {
    final searchState = ref.watch(searchProvider);
    
    if (searchState.currentQuery == null) {
      // 显示搜索建议
      return SearchSuggestionsList(
        suggestions: searchState.suggestions,
        history: searchState.history,
        hotKeywords: searchState.hotKeywords,
        onSuggestionSelected: _onSuggestionSelected,
      );
    } else {
      // 显示搜索结果
      return SearchResultsList(
        results: searchState.results,
        isLoading: searchState.isLoading,
        hasMore: searchState.hasMore,
        error: searchState.error,
        onResultTap: _onResultTap,
        onLoadMore: () => ref.read(searchProvider.notifier).loadMore(),
      );
    }
  }
}