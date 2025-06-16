import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/search_filter_model.dart';
import '../providers/search_filter_provider.dart';

/// 档案搜索栏组件
class ProfileSearchBar extends ConsumerStatefulWidget {
  final VoidCallback? onFilterPressed;
  final VoidCallback? onAdvancedFilter;
  final bool showFilterButton;
  
  const ProfileSearchBar({
    Key? key,
    this.onFilterPressed,
    this.onAdvancedFilter,
    this.showFilterButton = true,
  }) : super(key: key);

  @override
  ConsumerState<ProfileSearchBar> createState() => _ProfileSearchBarState();
}

class _ProfileSearchBarState extends ConsumerState<ProfileSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasActiveFilters = ref.watch(hasActiveFiltersProvider);
    final activeFilterCount = ref.watch(activeFilterCountProvider);
    final suggestions = ref.watch(searchSuggestionsProvider);
    final isSearching = ref.watch(searchFilterProvider).isSearching;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // 搜索图标
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ),
              
              // 搜索输入框
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: '搜索档案名称、健康目标...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (value) {
                    ref.read(searchFilterProvider.notifier).updateSearchQuery(value);
                  },
                  onSubmitted: (value) {
                    _focusNode.unfocus();
                  },
                ),
              ),
              
              // 清除按钮
              if (isSearching)
                IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  color: Colors.grey[400],
                  onPressed: () {
                    _controller.clear();
                    ref.read(searchFilterProvider.notifier).clearSearch();
                  },
                ),
              
              // 过滤按钮
              if (widget.showFilterButton)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.tune,
                          color: hasActiveFilters ? theme.primaryColor : Colors.grey[400],
                          size: 20,
                        ),
                        onPressed: widget.onAdvancedFilter ?? widget.onFilterPressed,
                      ),
                      
                      // 过滤器计数徽章
                      if (hasActiveFilters)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '$activeFilterCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        
        // 搜索建议
        if (_showSuggestions && suggestions.isNotEmpty)
          _buildSuggestions(context, suggestions),
      ],
    );
  }

  Widget _buildSuggestions(BuildContext context, List<SearchSuggestion> suggestions) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: suggestions.map((suggestion) {
          return ListTile(
            dense: true,
            leading: suggestion.icon != null
                ? Icon(
                    suggestion.icon!,
                    size: 18,
                    color: Colors.grey[600],
                  )
                : null,
            title: Text(
              suggestion.text,
              style: const TextStyle(fontSize: 14),
            ),
            subtitle: suggestion.subtitle != null
                ? Text(
                    suggestion.subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  )
                : null,
            trailing: const Icon(
              Icons.call_made,
              size: 14,
              color: Colors.grey,
            ),
            onTap: () {
              _controller.text = suggestion.text;
              ref.read(searchFilterProvider.notifier).applySuggestion(suggestion);
              _focusNode.unfocus();
            },
          );
        }).toList(),
      ),
    );
  }
}