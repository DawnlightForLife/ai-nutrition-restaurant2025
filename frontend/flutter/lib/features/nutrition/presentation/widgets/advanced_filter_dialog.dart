import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/search_filter_model.dart';
import '../providers/search_filter_provider.dart';

/// 高级过滤对话框
class AdvancedFilterDialog extends ConsumerStatefulWidget {
  const AdvancedFilterDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<AdvancedFilterDialog> createState() => _AdvancedFilterDialogState();
}

class _AdvancedFilterDialogState extends ConsumerState<AdvancedFilterDialog> {
  late SearchFilterModel _tempFilter;
  RangeValues? _completionRange;
  DateTimeRange? _createdDateRange;

  @override
  void initState() {
    super.initState();
    _tempFilter = ref.read(searchFilterProvider).filter;
    
    // 初始化完成度范围
    if (_tempFilter.minCompletionPercentage != null || _tempFilter.maxCompletionPercentage != null) {
      _completionRange = RangeValues(
        _tempFilter.minCompletionPercentage?.toDouble() ?? 0,
        _tempFilter.maxCompletionPercentage?.toDouble() ?? 100,
      );
    }
    
    _createdDateRange = _tempFilter.createdDateRange;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // 标题栏
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Icon(Icons.tune, color: theme.primaryColor),
                  const SizedBox(width: 12),
                  Text(
                    '高级筛选',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // 过滤选项
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGenderFilter(),
                    const SizedBox(height: 24),
                    _buildAgeGroupFilter(),
                    const SizedBox(height: 24),
                    _buildHealthGoalFilter(),
                    const SizedBox(height: 24),
                    _buildActivityLevelFilter(),
                    const SizedBox(height: 24),
                    _buildCompletionRangeFilter(),
                    const SizedBox(height: 24),
                    _buildDateRangeFilter(),
                    const SizedBox(height: 24),
                    _buildSortingOptions(),
                    const SizedBox(height: 24),
                    _buildToggleOptions(),
                  ],
                ),
              ),
            ),
            
            // 底部按钮
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetFilters,
                      child: const Text('重置'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      child: const Text('应用筛选'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderFilter() {
    return _buildFilterSection(
      title: '性别',
      icon: Icons.people,
      child: Wrap(
        spacing: 8,
        children: ['male', 'female'].map((gender) {
          final isSelected = _tempFilter.genderFilters.contains(gender);
          return FilterChip(
            label: Text(gender == 'male' ? '男性' : '女性'),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                final newFilters = Set<String>.from(_tempFilter.genderFilters);
                if (selected) {
                  newFilters.add(gender);
                } else {
                  newFilters.remove(gender);
                }
                _tempFilter = _tempFilter.copyWith(genderFilters: newFilters);
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAgeGroupFilter() {
    final ageGroups = ['18-25', '26-35', '36-45', '46-55', '56-65', '65+'];
    
    return _buildFilterSection(
      title: '年龄组',
      icon: Icons.cake,
      child: Wrap(
        spacing: 8,
        children: ageGroups.map((ageGroup) {
          final isSelected = _tempFilter.ageGroupFilters.contains(ageGroup);
          return FilterChip(
            label: Text(ageGroup),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                final newFilters = Set<String>.from(_tempFilter.ageGroupFilters);
                if (selected) {
                  newFilters.add(ageGroup);
                } else {
                  newFilters.remove(ageGroup);
                }
                _tempFilter = _tempFilter.copyWith(ageGroupFilters: newFilters);
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHealthGoalFilter() {
    final healthGoals = [
      {'key': 'lose_weight', 'label': '减重'},
      {'key': 'gain_muscle', 'label': '增肌'},
      {'key': 'maintain_weight', 'label': '保持体重'},
      {'key': 'improve_health', 'label': '改善健康'},
      {'key': 'manage_diabetes', 'label': '糖尿病管理'},
      {'key': 'sports_nutrition', 'label': '运动营养'},
    ];
    
    return _buildFilterSection(
      title: '健康目标',
      icon: Icons.flag,
      child: Wrap(
        spacing: 8,
        children: healthGoals.map((goal) {
          final isSelected = _tempFilter.healthGoalFilters.contains(goal['key']);
          return FilterChip(
            label: Text(goal['label']!),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                final newFilters = Set<String>.from(_tempFilter.healthGoalFilters);
                if (selected) {
                  newFilters.add(goal['key']!);
                } else {
                  newFilters.remove(goal['key']!);
                }
                _tempFilter = _tempFilter.copyWith(healthGoalFilters: newFilters);
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActivityLevelFilter() {
    final activityLevels = [
      {'key': 'sedentary', 'label': '久坐'},
      {'key': 'lightly_active', 'label': '轻度活跃'},
      {'key': 'moderately_active', 'label': '中度活跃'},
      {'key': 'very_active', 'label': '高度活跃'},
      {'key': 'extremely_active', 'label': '极度活跃'},
    ];
    
    return _buildFilterSection(
      title: '活动水平',
      icon: Icons.directions_run,
      child: Wrap(
        spacing: 8,
        children: activityLevels.map((level) {
          final isSelected = _tempFilter.activityLevelFilters.contains(level['key']);
          return FilterChip(
            label: Text(level['label']!),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                final newFilters = Set<String>.from(_tempFilter.activityLevelFilters);
                if (selected) {
                  newFilters.add(level['key']!);
                } else {
                  newFilters.remove(level['key']!);
                }
                _tempFilter = _tempFilter.copyWith(activityLevelFilters: newFilters);
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCompletionRangeFilter() {
    return _buildFilterSection(
      title: '完成度范围',
      icon: Icons.percent,
      child: Column(
        children: [
          RangeSlider(
            values: _completionRange ?? const RangeValues(0, 100),
            min: 0,
            max: 100,
            divisions: 10,
            labels: RangeLabels(
              '${(_completionRange?.start ?? 0).round()}%',
              '${(_completionRange?.end ?? 100).round()}%',
            ),
            onChanged: (values) {
              setState(() {
                _completionRange = values;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(_completionRange?.start ?? 0).round()}%'),
              Text('${(_completionRange?.end ?? 100).round()}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeFilter() {
    return _buildFilterSection(
      title: '创建日期',
      icon: Icons.date_range,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _selectDateRange,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _createdDateRange != null
                    ? '${_formatDate(_createdDateRange!.start)} - ${_formatDate(_createdDateRange!.end)}'
                    : '选择日期范围',
              ),
            ),
          ),
          if (_createdDateRange != null)
            IconButton(
              onPressed: () {
                setState(() {
                  _createdDateRange = null;
                });
              },
              icon: const Icon(Icons.clear),
            ),
        ],
      ),
    );
  }

  Widget _buildSortingOptions() {
    return _buildFilterSection(
      title: '排序方式',
      icon: Icons.sort,
      child: Column(
        children: [
          DropdownButtonFormField<ProfileSortOption>(
            value: _tempFilter.sortOption,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: ProfileSortOption.values.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option.displayName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _tempFilter = _tempFilter.copyWith(sortOption: value);
                });
              }
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('降序'),
                  value: true,
                  groupValue: _tempFilter.sortDescending,
                  onChanged: (value) {
                    setState(() {
                      _tempFilter = _tempFilter.copyWith(sortDescending: value);
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('升序'),
                  value: false,
                  groupValue: _tempFilter.sortDescending,
                  onChanged: (value) {
                    setState(() {
                      _tempFilter = _tempFilter.copyWith(sortDescending: value);
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOptions() {
    return _buildFilterSection(
      title: '其他选项',
      icon: Icons.settings,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('只显示主要档案'),
            value: _tempFilter.showPrimaryOnly,
            onChanged: (value) {
              setState(() {
                _tempFilter = _tempFilter.copyWith(showPrimaryOnly: value);
              });
            },
          ),
          SwitchListTile(
            title: const Text('显示已归档档案'),
            value: _tempFilter.showArchivedProfiles,
            onChanged: (value) {
              setState(() {
                _tempFilter = _tempFilter.copyWith(showArchivedProfiles: value);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _createdDateRange,
    );
    
    if (picked != null) {
      setState(() {
        _createdDateRange = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  void _resetFilters() {
    setState(() {
      _tempFilter = const SearchFilterModel();
      _completionRange = null;
      _createdDateRange = null;
    });
  }

  void _applyFilters() {
    // 应用完成度范围
    if (_completionRange != null) {
      _tempFilter = _tempFilter.copyWith(
        minCompletionPercentage: _completionRange!.start.round(),
        maxCompletionPercentage: _completionRange!.end.round(),
      );
    }
    
    // 应用日期范围
    _tempFilter = _tempFilter.copyWith(createdDateRange: _createdDateRange);
    
    // 更新过滤器
    ref.read(searchFilterProvider.notifier).applyFilter(_tempFilter);
    
    Navigator.of(context).pop();
  }
}