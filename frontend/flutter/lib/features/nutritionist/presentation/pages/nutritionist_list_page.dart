import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/nutritionist_providers.dart';
import '../widgets/nutritionist_card.dart';
import '../widgets/nutritionist_filter_bar.dart';
import '../../domain/entities/nutritionist.dart';
import '../../domain/entities/nutritionist_filter.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

/// 营养师列表页面（用户查看）
class NutritionistListPage extends ConsumerStatefulWidget {
  const NutritionistListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NutritionistListPage> createState() => _NutritionistListPageState();
}

class _NutritionistListPageState extends ConsumerState<NutritionistListPage> {
  NutritionistFilter _currentFilter = const NutritionistFilter();
  List<Nutritionist> _filteredNutritionists = [];
  bool _isFilterExpanded = false;

  @override
  void initState() {
    super.initState();
    // 加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nutritionistListProvider.notifier).loadNutritionists();
    });
  }

  void _onFilterChanged(NutritionistFilter filter) {
    setState(() {
      _currentFilter = filter;
    });
    _applyFilters();
  }

  void _applyFilters() {
    final nutritionists = ref.read(nutritionistListProvider).maybeWhen(
      loaded: (data) => data,
      orElse: () => <Nutritionist>[],
    );

    setState(() {
      _filteredNutritionists = _filterNutritionists(nutritionists, _currentFilter);
    });
  }

  List<Nutritionist> _filterNutritionists(
    List<Nutritionist> nutritionists,
    NutritionistFilter filter,
  ) {
    var filtered = nutritionists.where((nutritionist) {
      // 搜索关键词
      if (filter.searchKeyword != null && filter.searchKeyword!.isNotEmpty) {
        final keyword = filter.searchKeyword!.toLowerCase();
        if (!nutritionist.name.toLowerCase().contains(keyword) &&
            !nutritionist.specialtiesText.toLowerCase().contains(keyword)) {
          return false;
        }
      }

      // 在线状态
      if (filter.onlineOnly && !nutritionist.isOnline) {
        return false;
      }

      // 认证状态
      if (filter.verifiedOnly && !nutritionist.isVerified) {
        return false;
      }

      // 高评分（4.0以上）
      if (filter.highRatingOnly && nutritionist.rating < 4.0) {
        return false;
      }

      // 专业领域
      if (filter.specialties != null && filter.specialties!.isNotEmpty) {
        if (!filter.specialties!.any((s) => nutritionist.specialties.contains(s))) {
          return false;
        }
      }

      // 咨询类型
      if (filter.consultationTypes != null && filter.consultationTypes!.isNotEmpty) {
        if (!filter.consultationTypes!.any((t) => nutritionist.availableConsultationTypes.contains(t))) {
          return false;
        }
      }

      // 价格范围
      if (filter.minPrice != null && nutritionist.consultationFee < filter.minPrice!) {
        return false;
      }
      if (filter.maxPrice != null && nutritionist.consultationFee > filter.maxPrice!) {
        return false;
      }

      return true;
    }).toList();

    // 排序
    switch (filter.sortBy) {
      case NutritionistSortBy.rating:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case NutritionistSortBy.price:
        filtered.sort((a, b) => a.consultationFee.compareTo(b.consultationFee));
        break;
      case NutritionistSortBy.consultationCount:
        filtered.sort((a, b) => b.consultationCount.compareTo(a.consultationCount));
        break;
      case NutritionistSortBy.experience:
        filtered.sort((a, b) => b.experienceYears.compareTo(a.experienceYears));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final nutritionistState = ref.watch(nutritionistListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('营养师'),
        actions: [
          IconButton(
            icon: Icon(
              _isFilterExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onPressed: () {
              setState(() {
                _isFilterExpanded = !_isFilterExpanded;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 筛选栏
          if (_isFilterExpanded)
            SizedBox(
              height: 200, // 给筛选栏一个固定高度
              child: NutritionistFilterBar(
                onFilterChanged: _onFilterChanged,
                initialFilter: _currentFilter,
              ),
            ),

          // 简化筛选栏（始终显示）
          if (!_isFilterExpanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFilterExpanded = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '搜索营养师',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 活跃筛选指示器
                  if (!_currentFilter.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.filter_alt,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '已筛选',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

          // 营养师列表
          Expanded(
            child: nutritionistState.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryOrange,
                ),
              ),
              loaded: (nutritionists) {
                // 当数据加载完成时，应用筛选
                if (_filteredNutritionists.isEmpty && nutritionists.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _applyFilters();
                  });
                }

                final displayList = _filteredNutritionists.isNotEmpty 
                    ? _filteredNutritionists 
                    : nutritionists;

                if (displayList.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(nutritionistListProvider.notifier).loadNutritionists();
                    _applyFilters();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final nutritionist = displayList[index];
                      return NutritionistCard(
                        nutritionist: nutritionist,
                        onTap: () => _navigateToNutritionistDetail(nutritionist),
                        onBookConsultation: () => _bookConsultation(nutritionist),
                      );
                    },
                  ),
                );
              },
              empty: () => _buildEmptyState(),
              error: (message) => _buildErrorState(message),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            _currentFilter.isEmpty ? '暂无营养师' : '没有符合条件的营养师',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentFilter.isEmpty 
                ? '请稍后再试' 
                : '试试调整筛选条件',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (!_currentFilter.isEmpty) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentFilter = const NutritionistFilter();
                  _isFilterExpanded = false;
                });
                _applyFilters();
              },
              child: const Text('清除筛选'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            '加载失败',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(nutritionistListProvider.notifier).loadNutritionists();
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '排序方式',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 16),
            ...NutritionistSortBy.values.map((sortBy) {
              return ListTile(
                title: Text(sortBy.displayName),
                leading: Radio<NutritionistSortBy>(
                  value: sortBy,
                  groupValue: _currentFilter.sortBy,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _currentFilter = _currentFilter.copyWith(sortBy: value);
                      });
                      _applyFilters();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _navigateToNutritionistDetail(Nutritionist nutritionist) {
    Navigator.pushNamed(
      context,
      '/nutritionist/detail',
      arguments: nutritionist.id,
    );
  }


  void _bookConsultation(Nutritionist nutritionist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('预约咨询'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('营养师：${nutritionist.name}'),
            const SizedBox(height: 8),
            Text('咨询费用：¥${nutritionist.consultationFee.toStringAsFixed(0)}/次'),
            const SizedBox(height: 8),
            Text('服务方式：${_getServiceTypes(nutritionist)}'),
            const SizedBox(height: 8),
            Text('语言：${nutritionist.languages.join('、')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // 跳转到详情页面进行预约
              _navigateToNutritionistDetail(nutritionist);
            },
            child: const Text('查看详情'),
          ),
        ],
      ),
    );
  }

  /// 获取服务方式描述
  String _getServiceTypes(Nutritionist nutritionist) {
    final types = <String>[];
    if (nutritionist.isOnlineAvailable) {
      types.add('在线咨询');
    }
    if (nutritionist.isInPersonAvailable) {
      types.add('线下咨询');
    }
    return types.isEmpty ? '暂无' : types.join('、');
  }
}

/// 向后兼容的营养师列表页面
@Deprecated('Use NutritionistListPage instead')
class UnutritionistListPage extends NutritionistListPage {
  const UnutritionistListPage({Key? key}) : super(key: key);
}