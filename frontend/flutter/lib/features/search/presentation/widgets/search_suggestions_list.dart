import 'package:flutter/material.dart';
import '../../domain/entities/search_suggestion.dart';

/// 搜索建议列表
class SearchSuggestionsList extends StatelessWidget {
  final List<SearchSuggestion> suggestions;
  final List<SearchHistoryItem> history;
  final List<String> hotKeywords;
  final Function(String) onSuggestionSelected;
  final VoidCallback? onClearHistory;
  
  const SearchSuggestionsList({
    super.key,
    required this.suggestions,
    required this.history,
    required this.hotKeywords,
    required this.onSuggestionSelected,
    this.onClearHistory,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 搜索历史
          if (history.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              '搜索历史',
              Icons.history,
              action: TextButton(
                onPressed: onClearHistory,
                child: const Text('清空'),
              ),
            ),
            const SizedBox(height: 8),
            ...history.take(5).map((item) => _buildHistoryItem(context, item)),
            const SizedBox(height: 24),
          ],
          
          // 热门搜索
          if (hotKeywords.isNotEmpty) ...[
            _buildSectionHeader(context, '热门搜索', Icons.trending_up),
            const SizedBox(height: 12),
            _buildHotKeywordsGrid(context),
            const SizedBox(height: 24),
          ],
          
          // 搜索建议
          if (suggestions.isNotEmpty) ...[
            _buildSectionHeader(context, '搜索建议', Icons.lightbulb_outline),
            const SizedBox(height: 8),
            ...suggestions.map((suggestion) => _buildSuggestionItem(context, suggestion)),
          ],
        ],
      ),
    );
  }
  
  /// 构建区域标题
  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    Widget? action,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (action != null) action,
      ],
    );
  }
  
  /// 构建搜索历史项
  Widget _buildHistoryItem(BuildContext context, SearchHistoryItem item) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () => onSuggestionSelected(item.keyword),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(
              Icons.history,
              size: 18,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.keyword,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            if (item.resultCount != null) ...[
              Text(
                '${item.resultCount}个结果',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.call_made,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建热门关键词网格
  Widget _buildHotKeywordsGrid(BuildContext context) {
    final theme = Theme.of(context);
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: hotKeywords.map((keyword) {
        return InkWell(
          onTap: () => onSuggestionSelected(keyword),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Text(
              keyword,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  /// 构建搜索建议项
  Widget _buildSuggestionItem(BuildContext context, SearchSuggestion suggestion) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () => onSuggestionSelected(suggestion.text),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(
              _getSuggestionIcon(suggestion.type),
              size: 18,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.text,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (suggestion.description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      suggestion.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (suggestion.count != null) ...[
              Text(
                '${suggestion.count}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.call_made,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 获取建议类型图标
  IconData _getSuggestionIcon(SearchSuggestionType type) {
    switch (type) {
      case SearchSuggestionType.history:
        return Icons.history;
      case SearchSuggestionType.hotKeyword:
        return Icons.trending_up;
      case SearchSuggestionType.autoComplete:
        return Icons.search;
      case SearchSuggestionType.category:
        return Icons.category;
      case SearchSuggestionType.tag:
        return Icons.label;
    }
  }
}