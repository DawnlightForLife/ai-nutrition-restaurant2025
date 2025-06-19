import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientSelector extends ConsumerStatefulWidget {
  final List<String>? initialIngredients;
  final Function(List<String>) onIngredientsChanged;

  const IngredientSelector({
    Key? key,
    this.initialIngredients,
    required this.onIngredientsChanged,
  }) : super(key: key);

  @override
  ConsumerState<IngredientSelector> createState() => _IngredientSelectorState();
}

class _IngredientSelectorState extends ConsumerState<IngredientSelector> {
  late List<String> _selectedIngredients;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customIngredientController = TextEditingController();

  // 常见食材列表（实际应从后端获取）
  final List<String> _commonIngredients = [
    '鸡肉', '猪肉', '牛肉', '羊肉', '鱼肉', '虾', '蟹', '贝类',
    '土豆', '西红柿', '黄瓜', '白菜', '生菜', '胡萝卜', '洋葱', '大蒜',
    '青椒', '红椒', '茄子', '豆腐', '鸡蛋', '牛奶', '芝士', '黄油',
    '面粉', '大米', '面条', '盐', '糖', '生抽', '老抽', '醋',
    '料酒', '花椒', '八角', '桂皮', '香叶', '辣椒', '姜', '葱',
  ];

  List<String> _filteredIngredients = [];

  @override
  void initState() {
    super.initState();
    _selectedIngredients = List.from(widget.initialIngredients ?? []);
    _filteredIngredients = List.from(_commonIngredients);
    _searchController.addListener(_filterIngredients);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customIngredientController.dispose();
    super.dispose();
  }

  void _filterIngredients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredIngredients = List.from(_commonIngredients);
      } else {
        _filteredIngredients = _commonIngredients
            .where((ingredient) => ingredient.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _toggleIngredient(String ingredient) {
    setState(() {
      if (_selectedIngredients.contains(ingredient)) {
        _selectedIngredients.remove(ingredient);
      } else {
        _selectedIngredients.add(ingredient);
      }
    });
    widget.onIngredientsChanged(_selectedIngredients);
  }

  void _addCustomIngredient() {
    final ingredient = _customIngredientController.text.trim();
    if (ingredient.isNotEmpty && !_selectedIngredients.contains(ingredient)) {
      setState(() {
        _selectedIngredients.add(ingredient);
      });
      widget.onIngredientsChanged(_selectedIngredients);
      _customIngredientController.clear();
      
      // 收起键盘
      FocusScope.of(context).unfocus();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已添加食材：$ingredient'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _showIngredientDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '选择食材',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('完成'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Search bar
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: '搜索食材',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Ingredient list
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Custom ingredient input
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _customIngredientController,
                                  decoration: const InputDecoration(
                                    hintText: '添加自定义食材',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  onSubmitted: (_) => _addCustomIngredient(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: _addCustomIngredient,
                                icon: const Icon(Icons.add_circle),
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Common ingredients
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _filteredIngredients.map((ingredient) {
                              final isSelected = _selectedIngredients.contains(ingredient);
                              return FilterChip(
                                label: Text(ingredient),
                                selected: isSelected,
                                onSelected: (_) {
                                  setModalState(() {
                                    _toggleIngredient(ingredient);
                                  });
                                  setState(() {}); // Update parent state
                                },
                                backgroundColor: Colors.grey[200],
                                selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                                checkmarkColor: Theme.of(context).primaryColor,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected ingredients
        if (_selectedIngredients.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedIngredients.map((ingredient) {
              return Chip(
                label: Text(ingredient),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _toggleIngredient(ingredient),
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],
        
        // Add ingredient button
        OutlinedButton.icon(
          onPressed: _showIngredientDialog,
          icon: const Icon(Icons.add),
          label: Text(
            _selectedIngredients.isEmpty
                ? '添加食材'
                : '添加更多食材 (${_selectedIngredients.length})',
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }
}