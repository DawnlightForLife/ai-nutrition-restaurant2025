import 'package:flutter/material.dart';
import '../../domain/entities/dish_entity.dart';

class DishFilterDrawer extends StatefulWidget {
  final DishCategory? selectedCategory;
  final List<String> selectedTags;
  final bool showOnlyAvailable;
  final Function(DishCategory?, List<String>, bool) onFilterChanged;

  const DishFilterDrawer({
    Key? key,
    this.selectedCategory,
    required this.selectedTags,
    required this.showOnlyAvailable,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  State<DishFilterDrawer> createState() => _DishFilterDrawerState();
}

class _DishFilterDrawerState extends State<DishFilterDrawer> {
  late DishCategory? _selectedCategory;
  late List<String> _selectedTags;
  late bool _showOnlyAvailable;

  // 常见标签列表
  final List<String> _commonTags = [
    '招牌',
    '特色',
    '新品',
    '热销',
    '素食',
    '无麸质',
    '低糖',
    '低脂',
    '高蛋白',
    '儿童友好',
    '经典',
    '创新',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _selectedTags = List.from(widget.selectedTags);
    _showOnlyAvailable = widget.showOnlyAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 顶部拖拽指示器
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // 标题栏
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  '筛选条件',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: const Text('清除全部'),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // 筛选内容
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 分类筛选
                _buildCategorySection(),
                
                const SizedBox(height: 24),
                
                // 标签筛选
                _buildTagsSection(),
                
                const SizedBox(height: 24),
                
                // 可用性筛选
                _buildAvailabilitySection(),
                
                const SizedBox(height: 24),
                
                // 辣度筛选
                _buildSpicyLevelSection(),
              ],
            ),
          ),
          
          // 底部按钮
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
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
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '菜品分类',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: DishCategory.values.map((category) {
            final isSelected = _selectedCategory == category;
            return FilterChip(
              label: Text(category.displayName),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category : null;
                });
              },
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '标签',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _commonTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTags.add(tag);
                  } else {
                    _selectedTags.remove(tag);
                  }
                });
              },
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '可用性',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('仅显示可用菜品'),
          subtitle: const Text('隐藏已下架的菜品'),
          value: _showOnlyAvailable,
          onChanged: (value) {
            setState(() {
              _showOnlyAvailable = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildSpicyLevelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '辣度',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: SpicyLevel.values.map((level) {
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (level != SpicyLevel.none)
                    Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: _getSpicyColor(level),
                    ),
                  if (level != SpicyLevel.none) const SizedBox(width: 4),
                  Text(level.displayName),
                ],
              ),
              selected: false, // We'll implement spicy level filtering later
              onSelected: (selected) {
                // TODO: Implement spicy level filtering
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getSpicyColor(SpicyLevel level) {
    switch (level) {
      case SpicyLevel.mild:
        return Colors.orange[300]!;
      case SpicyLevel.medium:
        return Colors.orange[600]!;
      case SpicyLevel.hot:
        return Colors.red[600]!;
      case SpicyLevel.veryHot:
        return Colors.red[800]!;
      default:
        return Colors.grey;
    }
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedTags.clear();
      _showOnlyAvailable = false;
    });
  }

  void _applyFilters() {
    widget.onFilterChanged(_selectedCategory, _selectedTags, _showOnlyAvailable);
    Navigator.of(context).pop();
  }
}