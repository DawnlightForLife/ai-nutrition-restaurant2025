import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/search_filter_model.dart';
import '../providers/search_filter_provider.dart';

/// 快速过滤标签组件
class QuickFilterTags extends ConsumerWidget {
  final bool showTitle;
  final EdgeInsets? padding;
  
  const QuickFilterTags({
    Key? key,
    this.showTitle = true,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(searchFilterProvider).filter;
    final tags = QuickFilterTag.defaultTags;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle) ...[
            Row(
              children: [
                Text(
                  '快速筛选',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 8),
                if (currentFilter.hasActiveFilters)
                  GestureDetector(
                    onTap: () {
                      ref.read(searchFilterProvider.notifier).clearAllFilters();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '清除',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              final isActive = _isTagActive(tag, currentFilter);
              
              return FilterTag(
                tag: tag,
                isActive: isActive,
                onTap: () {
                  ref.read(searchFilterProvider.notifier).applyQuickFilter(tag);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  bool _isTagActive(QuickFilterTag tag, SearchFilterModel currentFilter) {
    // 检查标签是否与当前过滤器匹配
    switch (tag.id) {
      case 'primary':
        return currentFilter.showPrimaryOnly;
      case 'high_completion':
        return currentFilter.minCompletionPercentage != null && 
               currentFilter.minCompletionPercentage! >= 80;
      case 'weight_loss':
        return currentFilter.healthGoalFilters.contains('lose_weight');
      case 'muscle_gain':
        return currentFilter.healthGoalFilters.contains('gain_muscle');
      case 'female':
        return currentFilter.genderFilters.contains('female');
      case 'male':
        return currentFilter.genderFilters.contains('male');
      case 'recent':
        return currentFilter.sortOption == ProfileSortOption.createdDate &&
               currentFilter.sortDescending;
      case 'active':
        return currentFilter.sortOption == ProfileSortOption.lastActiveDate &&
               currentFilter.sortDescending;
      default:
        return false;
    }
  }
}

/// 单个过滤标签组件
class FilterTag extends StatelessWidget {
  final QuickFilterTag tag;
  final bool isActive;
  final VoidCallback onTap;
  
  const FilterTag({
    Key? key,
    required this.tag,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? tag.color.withOpacity(0.15) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? tag.color : Colors.grey[300]!,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              tag.icon,
              size: 16,
              color: isActive ? tag.color : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              tag.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? tag.color : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 档案统计信息组件
class ProfileStatsBar extends ConsumerWidget {
  const ProfileStatsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(profileStatsProvider);
    final hasActiveFilters = ref.watch(hasActiveFiltersProvider);
    
    if (stats.isEmpty || stats['total'] == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasActiveFilters ? Colors.blue[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasActiveFilters ? Colors.blue[200]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            hasActiveFilters ? Icons.filter_list : Icons.info_outline,
            size: 16,
            color: hasActiveFilters ? Colors.blue[600] : Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              hasActiveFilters 
                  ? '找到 ${stats['total']} 个匹配的档案'
                  : '共 ${stats['total']} 个档案',
              style: TextStyle(
                fontSize: 13,
                color: hasActiveFilters ? Colors.blue[700] : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (stats['avgCompletion'] != null && stats['avgCompletion'] > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getCompletionColor(stats['avgCompletion']).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '平均完整度 ${stats['avgCompletion'].toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 11,
                  color: _getCompletionColor(stats['avgCompletion']),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getCompletionColor(double completion) {
    if (completion >= 80) return Colors.green;
    if (completion >= 60) return Colors.orange;
    return Colors.red;
  }
}