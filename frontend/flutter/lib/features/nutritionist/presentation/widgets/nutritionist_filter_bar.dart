import 'package:flutter/material.dart';
import '../../domain/enums/specialization_area.dart';
import '../../domain/entities/nutritionist.dart';
import '../../domain/entities/nutritionist_filter.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

class NutritionistFilterBar extends StatefulWidget {
  final Function(NutritionistFilter) onFilterChanged;
  final NutritionistFilter initialFilter;

  const NutritionistFilterBar({
    Key? key,
    required this.onFilterChanged,
    this.initialFilter = const NutritionistFilter(),
  }) : super(key: key);

  @override
  State<NutritionistFilterBar> createState() => _NutritionistFilterBarState();
}

class _NutritionistFilterBarState extends State<NutritionistFilterBar> {
  late NutritionistFilter _currentFilter;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter;
    _searchController.text = _currentFilter.searchKeyword ?? '';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilter() {
    widget.onFilterChanged(_currentFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 搜索框
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '搜索营养师姓名或专业领域',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _currentFilter = _currentFilter.copyWith(
                          searchKeyword: null,
                        );
                        _updateFilter();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _currentFilter = _currentFilter.copyWith(
                  searchKeyword: value.isEmpty ? null : value,
                );
              });
              _updateFilter();
            },
          ),
          
          const SizedBox(height: 16),
          
          // 快速筛选按钮
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip(
                  label: '全部',
                  isSelected: _currentFilter.isEmpty,
                  onTap: () {
                    setState(() {
                      _currentFilter = const NutritionistFilter();
                      _searchController.clear();
                    });
                    _updateFilter();
                  },
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: '在线',
                  isSelected: _currentFilter.onlineOnly,
                  onTap: () {
                    setState(() {
                      _currentFilter = _currentFilter.copyWith(
                        onlineOnly: !_currentFilter.onlineOnly,
                      );
                    });
                    _updateFilter();
                  },
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: '已认证',
                  isSelected: _currentFilter.verifiedOnly,
                  onTap: () {
                    setState(() {
                      _currentFilter = _currentFilter.copyWith(
                        verifiedOnly: !_currentFilter.verifiedOnly,
                      );
                    });
                    _updateFilter();
                  },
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: '高评分',
                  isSelected: _currentFilter.highRatingOnly,
                  onTap: () {
                    setState(() {
                      _currentFilter = _currentFilter.copyWith(
                        highRatingOnly: !_currentFilter.highRatingOnly,
                      );
                    });
                    _updateFilter();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}