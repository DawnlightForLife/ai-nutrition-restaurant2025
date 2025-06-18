import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/permissions.dart';
import '../../../../core/widgets/permission_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// 菜品管理页面
class DishManagementPage extends ConsumerStatefulWidget {
  const DishManagementPage({super.key});

  @override
  ConsumerState<DishManagementPage> createState() => _DishManagementPageState();
}

class _DishManagementPageState extends ConsumerState<DishManagementPage>
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
              onPressed: () {
                _showAddDishDialog();
              },
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
                      _buildCategoryChip('mainCourse', '主菜'),
                      _buildCategoryChip('appetizer', '开胃菜'),
                      _buildCategoryChip('soup', '汤类'),
                      _buildCategoryChip('dessert', '甜品'),
                      _buildCategoryChip('beverage', '饮品'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 菜品列表
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDishList('all'),
                _buildDishList('bestsellers'),
                _buildDishList('low_stock'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: PermissionWidget(
        requiredPermissions: const [Permissions.dishWrite],
        child: FloatingActionButton(
          onPressed: () {
            _showAddDishDialog();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
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
  
  Widget _buildDishList(String type) {
    // 模拟菜品数据
    final dishes = _getMockDishes(type);
    
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
        // TODO: 实现刷新逻辑
        await Future.delayed(const Duration(seconds: 1));
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
  
  Widget _buildDishCard(Map<String, dynamic> dish) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showDishDetail(dish);
        },
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
                child: dish['imageUrl'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          dish['imageUrl'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.grey,
                            );
                          },
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
                            dish['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (dish['isAvailable'] == false)
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
                      dish['description'] ?? '',
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
                          '¥${dish['price']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        if (dish['discountPrice'] != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '¥${dish['discountPrice']}',
                            style: const TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (dish['stock'] != null) ...[
                          Icon(
                            Icons.inventory,
                            size: 16,
                            color: dish['stock'] < 10 ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '库存: ${dish['stock']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: dish['stock'] < 10 ? Colors.red : Colors.grey,
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
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _editDish(dish);
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
                },
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
                      leading: Icon(dish['isAvailable'] ? Icons.visibility_off : Icons.visibility),
                      title: Text(dish['isAvailable'] ? '下架' : '上架'),
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
  
  List<Map<String, dynamic>> _getMockDishes(String type) {
    final allDishes = [
      {
        'id': '1',
        'name': '宫保鸡丁',
        'description': '经典川菜，鸡肉鲜嫩，花生香脆',
        'price': 28.0,
        'discountPrice': 25.0,
        'category': 'mainCourse',
        'stock': 15,
        'isAvailable': true,
        'sales': 120,
      },
      {
        'id': '2',
        'name': '麻婆豆腐',
        'description': '麻辣鲜香，豆腐嫩滑',
        'price': 22.0,
        'category': 'mainCourse',
        'stock': 8,
        'isAvailable': true,
        'sales': 95,
      },
      {
        'id': '3',
        'name': '青椒肉丝',
        'description': '清爽下饭，营养丰富',
        'price': 25.0,
        'category': 'mainCourse',
        'stock': 20,
        'isAvailable': false,
        'sales': 80,
      },
      {
        'id': '4',
        'name': '西红柿鸡蛋汤',
        'description': '酸甜可口，营养丰富',
        'price': 12.0,
        'category': 'soup',
        'stock': 5,
        'isAvailable': true,
        'sales': 60,
      },
      {
        'id': '5',
        'name': '红烧肉',
        'description': '肥而不腻，入口即化',
        'price': 35.0,
        'category': 'mainCourse',
        'stock': 12,
        'isAvailable': true,
        'sales': 140,
      },
    ];
    
    switch (type) {
      case 'bestsellers':
        return allDishes.where((dish) => dish['sales'] > 100).toList();
      case 'low_stock':
        return allDishes.where((dish) => dish['stock'] < 10).toList();
      default:
        return allDishes
            .where((dish) => 
                (_selectedCategory == 'all' || dish['category'] == _selectedCategory) &&
                (_searchQuery.isEmpty || 
                 dish['name'].toLowerCase().contains(_searchQuery.toLowerCase())))
            .toList();
    }
  }
  
  void _showAddDishDialog() {
    Navigator.of(context).pushNamed('/dishes/create');
  }
  
  void _showDishDetail(Map<String, dynamic> dish) {
    Navigator.of(context).pushNamed('/dishes/${dish['id']}');
  }
  
  void _editDish(Map<String, dynamic> dish) {
    Navigator.of(context).pushNamed('/dishes/${dish['id']}/edit');
  }
  
  void _toggleDishAvailability(Map<String, dynamic> dish) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dish['isAvailable'] ? '下架菜品' : '上架菜品'),
        content: Text('确定要${dish['isAvailable'] ? '下架' : '上架'}「${dish['name']}」吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              // TODO: 实现上架/下架逻辑
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('「${dish['name']}」已${dish['isAvailable'] ? '下架' : '上架'}'),
                ),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
  
  void _deleteDish(Map<String, dynamic> dish) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除菜品'),
        content: Text('确定要删除「${dish['name']}」吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              // TODO: 实现删除逻辑
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('「${dish['name']}」已删除'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
  
  void _duplicateDish(Map<String, dynamic> dish) {
    // TODO: 实现复制菜品逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('「${dish['name']}」已复制'),
      ),
    );
  }
  
  void _showBatchUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('批量更新价格'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: '价格调整百分比',
                hintText: '例如：10 表示涨价10%，-5 表示降价5%',
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
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
            onPressed: () {
              // TODO: 实现批量更新逻辑
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('价格批量更新成功'),
                ),
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
      const SnackBar(
        content: Text('菜品数据导出中...'),
      ),
    );
  }
  
  void _importDishes() {
    // TODO: 实现导入逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('请选择要导入的文件'),
      ),
    );
  }
}