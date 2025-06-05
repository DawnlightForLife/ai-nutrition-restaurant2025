import 'package:flutter/material.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/entities/search_query.dart';

/// 搜索筛选器
class SearchFilters extends StatelessWidget {
  final List<SearchResultType>? selectedTypes;
  final String? selectedCategory;
  final SearchSortType sortType;
  final Function({
    List<SearchResultType>? types,
    String? category,
    SearchSortType? sortType,
  }) onFiltersChanged;
  
  const SearchFilters({
    super.key,
    this.selectedTypes,
    this.selectedCategory,
    required this.sortType,
    required this.onFiltersChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // 类型筛选
            _buildTypeFilter(context),
            const SizedBox(width: 12),
            
            // 分类筛选
            _buildCategoryFilter(context),
            const SizedBox(width: 12),
            
            // 排序筛选
            _buildSortFilter(context),
          ],
        ),
      ),
    );
  }
  
  /// 构建类型筛选
  Widget _buildTypeFilter(BuildContext context) {
    final theme = Theme.of(context);
    final hasSelection = selectedTypes?.isNotEmpty == true;
    
    return InkWell(
      onTap: () => _showTypeFilterDialog(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: hasSelection 
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: hasSelection 
              ? Border.all(color: theme.colorScheme.primary.withOpacity(0.3))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.category,
              size: 16,
              color: hasSelection 
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              hasSelection 
                  ? '类型(${selectedTypes!.length})'
                  : '类型',
              style: theme.textTheme.bodySmall?.copyWith(
                color: hasSelection 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: hasSelection ? FontWeight.w500 : null,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.expand_more,
              size: 16,
              color: hasSelection 
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建分类筛选
  Widget _buildCategoryFilter(BuildContext context) {
    final theme = Theme.of(context);
    final hasSelection = selectedCategory != null;
    
    return InkWell(
      onTap: () => _showCategoryFilterDialog(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: hasSelection 
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: hasSelection 
              ? Border.all(color: theme.colorScheme.primary.withOpacity(0.3))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.label,
              size: 16,
              color: hasSelection 
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              selectedCategory ?? '分类',
              style: theme.textTheme.bodySmall?.copyWith(
                color: hasSelection 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: hasSelection ? FontWeight.w500 : null,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.expand_more,
              size: 16,
              color: hasSelection 
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建排序筛选
  Widget _buildSortFilter(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () => _showSortFilterDialog(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sort,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              sortType.displayName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.expand_more,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
  
  /// 显示类型筛选对话框
  void _showTypeFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _TypeFilterDialog(
        selectedTypes: selectedTypes,
        onTypesChanged: (types) {
          onFiltersChanged(types: types);
        },
      ),
    );
  }
  
  /// 显示分类筛选对话框
  void _showCategoryFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _CategoryFilterDialog(
        selectedCategory: selectedCategory,
        onCategoryChanged: (category) {
          onFiltersChanged(category: category);
        },
      ),
    );
  }
  
  /// 显示排序筛选对话框
  void _showSortFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _SortFilterBottomSheet(
        selectedSort: sortType,
        onSortChanged: (sort) {
          onFiltersChanged(sortType: sort);
        },
      ),
    );
  }
}

/// 类型筛选对话框
class _TypeFilterDialog extends StatefulWidget {
  final List<SearchResultType>? selectedTypes;
  final Function(List<SearchResultType>?) onTypesChanged;
  
  const _TypeFilterDialog({
    required this.selectedTypes,
    required this.onTypesChanged,
  });
  
  @override
  State<_TypeFilterDialog> createState() => _TypeFilterDialogState();
}

class _TypeFilterDialogState extends State<_TypeFilterDialog> {
  late Set<SearchResultType> _selectedTypes;
  
  @override
  void initState() {
    super.initState();
    _selectedTypes = Set.from(widget.selectedTypes ?? []);
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: const Text('选择类型'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: SearchResultType.values.map((type) {
            return CheckboxListTile(
              title: Text('${type.icon} ${type.displayName}'),
              value: _selectedTypes.contains(type),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _selectedTypes.add(type);
                  } else {
                    _selectedTypes.remove(type);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onTypesChanged(null);
            Navigator.of(context).pop();
          },
          child: const Text('清空'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onTypesChanged(
              _selectedTypes.isEmpty ? null : _selectedTypes.toList(),
            );
            Navigator.of(context).pop();
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}

/// 分类筛选对话框
class _CategoryFilterDialog extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategoryChanged;
  
  const _CategoryFilterDialog({
    required this.selectedCategory,
    required this.onCategoryChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    final categories = [
      '川菜', '粤菜', '湘菜', '鲁菜', '苏菜', '浙菜', '闽菜', '徽菜',
      '西餐', '日料', '韩料', '快餐', '小食', '甜品', '饮品',
    ];
    
    return AlertDialog(
      title: const Text('选择分类'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('全部分类'),
              leading: Radio<String?>(
                value: null,
                groupValue: selectedCategory,
                onChanged: (value) {
                  onCategoryChanged(value);
                  Navigator.of(context).pop();
                },
              ),
            ),
            ...categories.map((category) {
              return ListTile(
                title: Text(category),
                leading: Radio<String?>(
                  value: category,
                  groupValue: selectedCategory,
                  onChanged: (value) {
                    onCategoryChanged(value);
                    Navigator.of(context).pop();
                  },
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
      ],
    );
  }
}

/// 排序筛选底部表单
class _SortFilterBottomSheet extends StatelessWidget {
  final SearchSortType selectedSort;
  final Function(SearchSortType) onSortChanged;
  
  const _SortFilterBottomSheet({
    required this.selectedSort,
    required this.onSortChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '排序方式',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...SearchSortType.values.map((sort) {
            return ListTile(
              title: Text(sort.displayName),
              leading: Radio<SearchSortType>(
                value: sort,
                groupValue: selectedSort,
                onChanged: (value) {
                  if (value != null) {
                    onSortChanged(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}