import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/dish_provider.dart';
import '../widgets/dish_card.dart';
import '../widgets/dish_search_bar.dart';
import '../widgets/dish_filter_drawer.dart';
import '../../domain/entities/dish_entity.dart';

class DishListPage extends ConsumerStatefulWidget {
  final String merchantId;

  const DishListPage({
    Key? key,
    required this.merchantId,
  }) : super(key: key);

  @override
  ConsumerState<DishListPage> createState() => _DishListPageState();
}

class _DishListPageState extends ConsumerState<DishListPage> {
  String _searchQuery = '';
  DishCategory? _selectedCategory;
  List<String> _selectedTags = [];
  bool _showOnlyAvailable = false;

  @override
  Widget build(BuildContext context) {
    final dishesAsync = ref.watch(dishesProvider(widget.merchantId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('菜品管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(dishesProvider(widget.merchantId).notifier).refreshDishes();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDrawer(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索栏
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DishSearchBar(
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          
          // 筛选标签显示
          if (_selectedCategory != null || _selectedTags.isNotEmpty || _showOnlyAvailable)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _getFilterChips().length,
                itemBuilder: (context, index) {
                  return _getFilterChips()[index];
                },
              ),
            ),

          // 菜品列表
          Expanded(
            child: dishesAsync.when(
              data: (dishes) {
                final filteredDishes = _filterDishes(dishes);
                
                if (filteredDishes.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('暂无菜品', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(dishesProvider(widget.merchantId).notifier).refreshDishes();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredDishes.length,
                    itemBuilder: (context, index) {
                      final dish = filteredDishes[index];
                      return DishCard(
                        dish: dish,
                        onTap: () => _navigateToDishDetail(dish.id),
                        onEdit: () => _navigateToDishEdit(dish.id),
                        onDelete: () => _showDeleteConfirmation(dish),
                        onToggleAvailability: () => _toggleDishAvailability(dish),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('加载失败: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(dishesProvider(widget.merchantId).notifier).refreshDishes();
                      },
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToDishCreate(),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<DishEntity> _filterDishes(List<DishEntity> dishes) {
    return dishes.where((dish) {
      // 搜索过滤
      if (_searchQuery.isNotEmpty && 
          !dish.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !dish.description.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }

      // 分类过滤
      if (_selectedCategory != null && dish.category != _selectedCategory!.value) {
        return false;
      }

      // 标签过滤
      if (_selectedTags.isNotEmpty && !_selectedTags.any((tag) => dish.tags.contains(tag))) {
        return false;
      }

      // 可用性过滤
      if (_showOnlyAvailable && !dish.isAvailable) {
        return false;
      }

      return true;
    }).toList();
  }

  List<Widget> _getFilterChips() {
    List<Widget> chips = [];

    if (_selectedCategory != null) {
      chips.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Chip(
            label: Text(_selectedCategory!.displayName),
            onDeleted: () {
              setState(() {
                _selectedCategory = null;
              });
            },
          ),
        ),
      );
    }

    for (String tag in _selectedTags) {
      chips.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Chip(
            label: Text(tag),
            onDeleted: () {
              setState(() {
                _selectedTags.remove(tag);
              });
            },
          ),
        ),
      );
    }

    if (_showOnlyAvailable) {
      chips.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Chip(
            label: const Text('仅显示可用'),
            onDeleted: () {
              setState(() {
                _showOnlyAvailable = false;
              });
            },
          ),
        ),
      );
    }

    return chips;
  }

  void _showFilterDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DishFilterDrawer(
        selectedCategory: _selectedCategory,
        selectedTags: _selectedTags,
        showOnlyAvailable: _showOnlyAvailable,
        onFilterChanged: (category, tags, showOnlyAvailable) {
          setState(() {
            _selectedCategory = category;
            _selectedTags = tags;
            _showOnlyAvailable = showOnlyAvailable;
          });
        },
      ),
    );
  }

  void _navigateToDishDetail(String dishId) {
    context.push('/merchant/${widget.merchantId}/dishes/$dishId');
  }

  void _navigateToDishEdit(String dishId) {
    context.push('/merchant/${widget.merchantId}/dishes/$dishId/edit');
  }

  void _navigateToDishCreate() {
    context.push('/merchant/${widget.merchantId}/dishes/create');
  }

  Future<void> _showDeleteConfirmation(DishEntity dish) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除菜品 "${dish.name}" 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref
          .read(dishesProvider(widget.merchantId).notifier)
          .deleteDish(dish.id);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('菜品 "${dish.name}" 已删除')),
        );
      }
    }
  }

  Future<void> _toggleDishAvailability(DishEntity dish) async {
    // This would require implementing an update method in the provider
    // For now, we'll navigate to edit page
    _navigateToDishEdit(dish.id);
  }
}