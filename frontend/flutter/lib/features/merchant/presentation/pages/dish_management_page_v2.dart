import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/permissions.dart';
import '../../../../core/widgets/permission_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/dish_provider.dart';
import '../../domain/entities/dish_entity.dart';
import '../widgets/dish_card.dart';

/// 菜品管理页面V2 - 使用真实API
class DishManagementPageV2 extends ConsumerStatefulWidget {
  final String merchantId;
  
  const DishManagementPageV2({
    super.key,
    required this.merchantId,
  });

  @override
  ConsumerState<DishManagementPageV2> createState() => _DishManagementPageV2State();
}

class _DishManagementPageV2State extends ConsumerState<DishManagementPageV2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedCategory = 'all';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dishesAsync = ref.watch(dishesProvider(widget.merchantId));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('菜品管理'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '全部菜品'),
            Tab(text: '热销菜品'),
            Tab(text: '库存预警'),
          ],
        ),
        actions: [
          PermissionWidget(
            requiredPermissions: const [Permissions.dishWrite],
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _navigateToCreateDish(),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'batch_update':
                  _showBatchUpdateDialog();
                  break;
                case 'export':
                  _exportDishes();
                  break;
                case 'import':
                  _importDishes();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'batch_update',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('批量更新'),
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('导出菜品'),
                ),
              ),
              const PopupMenuItem(
                value: 'import',
                child: ListTile(
                  leading: Icon(Icons.upload),
                  title: Text('导入菜品'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索和筛选栏
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              children: [
                // 搜索框
                TextField(
                  decoration: InputDecoration(
                    hintText: '搜索菜品名称...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                
                // 分类筛选
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('all', '全部'),
                      ...DishCategory.values.map((category) => 
                        _buildCategoryChip(category.value, category.displayName)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 菜品列表
          Expanded(
            child: dishesAsync.when(
              data: (dishes) {
                final filteredDishes = _filterDishes(dishes);
                
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDishList(filteredDishes),
                    _buildDishList(_getHotDishes(filteredDishes)),
                    _buildDishList(_getLowStockDishes(filteredDishes)),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      '加载失败: ${error.toString()}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(dishesProvider(widget.merchantId)),
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: PermissionWidget(
        requiredPermissions: const [Permissions.dishWrite],
        child: FloatingActionButton(
          onPressed: () => _navigateToCreateDish(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
  
  List<DishEntity> _filterDishes(List<DishEntity> dishes) {
    return dishes.where((dish) {
      final matchesCategory = _selectedCategory == 'all' || dish.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty || 
          dish.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          dish.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }
  
  List<DishEntity> _getHotDishes(List<DishEntity> dishes) {
    // TODO: 实际应该根据销量数据判断
    return dishes.where((dish) => dish.tags.contains('hot') || dish.tags.contains('bestseller')).toList();
  }
  
  List<DishEntity> _getLowStockDishes(List<DishEntity> dishes) {
    // TODO: 实际应该根据库存数据判断
    return dishes; // 暂时返回所有菜品
  }
  
  Widget _buildCategoryChip(String category, String label) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        checkmarkColor: Theme.of(context).primaryColor,
      ),
    );
  }
  
  Widget _buildDishList(List<DishEntity> dishes) {
    if (dishes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '暂无菜品',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(dishesProvider(widget.merchantId));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dishes.length,
        itemBuilder: (context, index) {
          final dish = dishes[index];
          return _buildDishCard(dish);
        },
      ),
    );
  }
  
  Widget _buildDishCard(DishEntity dish) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToDishDetail(dish.id),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 菜品图片
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
                child: dish.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: dish.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.image,
                        size: 40,
                        color: Colors.grey,
                      ),
              ),
              const SizedBox(width: 16),
              
              // 菜品信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            dish.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!dish.isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '已下架',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dish.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '¥${dish.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        if (dish.discountedPrice != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '¥${dish.discountedPrice!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                        const Spacer(),
                        // 辣度标识
                        if (dish.spicyLevel > 0) ...[
                          Icon(
                            Icons.local_fire_department,
                            size: 16,
                            color: _getSpicyColor(dish.spicyLevel),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            SpicyLevel.fromLevel(dish.spicyLevel).displayName,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getSpicyColor(dish.spicyLevel),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // 操作按钮
              PopupMenuButton<String>(
                onSelected: (value) => _handleDishAction(value, dish),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('编辑'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'toggle',
                    child: ListTile(
                      leading: Icon(dish.isActive ? Icons.visibility_off : Icons.visibility),
                      title: Text(dish.isActive ? '下架' : '上架'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: ListTile(
                      leading: Icon(Icons.copy),
                      title: Text('复制'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('删除'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getSpicyColor(int level) {
    if (level <= 1) return Colors.orange[300]!;
    if (level <= 3) return Colors.orange[600]!;
    if (level <= 4) return Colors.red[600]!;
    return Colors.red[800]!;
  }
  
  void _navigateToCreateDish() {
    Navigator.of(context).pushNamed(
      '/merchant/dishes/create',
      arguments: {'merchantId': widget.merchantId},
    );
  }
  
  void _navigateToDishDetail(String dishId) {
    Navigator.of(context).pushNamed(
      '/merchant/dishes/detail',
      arguments: {
        'merchantId': widget.merchantId,
        'dishId': dishId,
      },
    );
  }
  
  void _navigateToEditDish(String dishId) {
    Navigator.of(context).pushNamed(
      '/merchant/dishes/edit',
      arguments: {
        'merchantId': widget.merchantId,
        'dishId': dishId,
      },
    );
  }
  
  void _handleDishAction(String action, DishEntity dish) {
    switch (action) {
      case 'edit':
        _navigateToEditDish(dish.id);
        break;
      case 'toggle':
        _toggleDishAvailability(dish);
        break;
      case 'delete':
        _deleteDish(dish);
        break;
      case 'duplicate':
        _duplicateDish(dish);
        break;
    }
  }
  
  void _toggleDishAvailability(DishEntity dish) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dish.isActive ? '下架菜品' : '上架菜品'),
        content: Text('确定要${dish.isActive ? '下架' : '上架'}「${dish.name}」吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // TODO: 调用API更新菜品状态
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('「${dish.name}」已${dish.isActive ? '下架' : '上架'}'),
                ),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
  
  void _deleteDish(DishEntity dish) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除菜品'),
        content: Text('确定要删除「${dish.name}」吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final success = await ref
                  .read(dishesProvider(widget.merchantId).notifier)
                  .deleteDish(dish.id);
                  
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? '「${dish.name}」已删除' : '删除失败'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
  
  void _duplicateDish(DishEntity dish) {
    // TODO: 实现复制菜品逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('「${dish.name}」已复制'),
      ),
    );
  }
  
  void _showBatchUpdateDialog() {
    final percentageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('批量更新价格'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: percentageController,
              decoration: const InputDecoration(
                labelText: '价格调整百分比',
                hintText: '例如：10 表示涨价10%，-5 表示降价5%',
                suffixText: '%',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            ),
            const SizedBox(height: 16),
            const Text(
              '此操作将影响所有可见菜品的价格',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final percentage = double.tryParse(percentageController.text);
              if (percentage == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入有效的百分比')),
                );
                return;
              }
              
              Navigator.pop(context);
              // TODO: 实现批量更新逻辑
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('价格批量更新成功')),
              );
            },
            child: const Text('更新'),
          ),
        ],
      ),
    );
  }
  
  void _exportDishes() {
    // TODO: 实现导出逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('菜品数据导出中...')),
    );
  }
  
  void _importDishes() {
    // TODO: 实现导入逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('请选择要导入的文件')),
    );
  }
}