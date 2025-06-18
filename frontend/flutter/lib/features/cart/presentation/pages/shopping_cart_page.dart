import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 购物车页面
class ShoppingCartPage extends ConsumerStatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  ConsumerState<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends ConsumerState<ShoppingCartPage> {
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }
  
  void _loadCartItems() {
    setState(() {
      _isLoading = true;
    });
    
    // 模拟加载购物车数据
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _cartItems = _getMockCartItems();
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('购物车'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('购物车'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                '购物车是空的',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '去逛逛，挑选一些美味的菜品吧',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/menu');
          },
          icon: const Icon(Icons.restaurant_menu),
          label: const Text('去点餐'),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车 (${_cartItems.length})'),
        actions: [
          TextButton(
            onPressed: _clearCart,
            child: const Text(
              '清空',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 购物车商品列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return _buildCartItem(item, index);
              },
            ),
          ),
          
          // 底部结算栏
          _buildCheckoutBar(),
        ],
      ),
    );
  }
  
  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 商品图片
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
              ),
              child: item['imageUrl'] != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item['imageUrl'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image,
                            size: 30,
                            color: Colors.grey,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.image,
                      size: 30,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(width: 12),
            
            // 商品信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (item['name'] as String?) ?? 'Unknown Item',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if ((item['specifications'] as Map<String, dynamic>?) != null && (item['specifications'] as Map<String, dynamic>).isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatSpecifications((item['specifications'] as Map<String, dynamic>?) ?? {}),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '¥${((item['price'] as num?) ?? 0).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      if ((item['originalPrice'] as num?) != null && (item['originalPrice'] as num) > (item['price'] as num)) ...[
                        const SizedBox(width: 8),
                        Text(
                          '¥${((item['originalPrice'] as num?) ?? 0).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // 数量控制
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => _decreaseQuantity(index),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.remove,
                          size: 16,
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 32,
                      alignment: Alignment.center,
                      child: Text(
                        '${(item['quantity'] as int?) ?? 1}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _increaseQuantity(index),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '小计: ¥${(((item['price'] as num?) ?? 0) * ((item['quantity'] as int?) ?? 1)).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCheckoutBar() {
    final totalAmount = _calculateTotal();
    final totalQuantity = _calculateTotalQuantity();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 总价信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '共 $totalQuantity 件商品',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      '合计: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '¥${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 结算按钮
          SizedBox(
            width: 120,
            height: 48,
            child: ElevatedButton(
              onPressed: totalAmount > 0 ? _checkout : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '去结算',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatSpecifications(Map<String, dynamic> specs) {
    return specs.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ');
  }
  
  double _calculateTotal() {
    return _cartItems.fold(0.0, (sum, item) => sum + (((item['price'] as num?) ?? 0) * ((item['quantity'] as int?) ?? 1)));
  }
  
  int _calculateTotalQuantity() {
    return _cartItems.fold(0, (sum, item) => sum + ((item['quantity'] as int?) ?? 1));
  }
  
  void _increaseQuantity(int index) {
    setState(() {
      _cartItems[index]['quantity'] = ((_cartItems[index]['quantity'] as int?) ?? 1) + 1;
    });
    _updateCartItem(_cartItems[index]);
  }
  
  void _decreaseQuantity(int index) {
    if (((_cartItems[index]['quantity'] as int?) ?? 1) > 1) {
      setState(() {
        _cartItems[index]['quantity'] = ((_cartItems[index]['quantity'] as int?) ?? 1) - 1;
      });
      _updateCartItem(_cartItems[index]);
    } else {
      _removeItem(index);
    }
  }
  
  void _removeItem(int index) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('移除商品'),
        content: Text('确定要从购物车中移除「${(_cartItems[index]['name'] as String?) ?? 'Unknown Item'}」吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _cartItems.removeAt(index);
              });
              Navigator.pop(context);
              _syncCart();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('移除'),
          ),
        ],
      ),
    );
  }
  
  void _clearCart() {
    if (_cartItems.isEmpty) return;
    
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空购物车'),
        content: const Text('确定要清空购物车中的所有商品吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _cartItems.clear();
              });
              Navigator.pop(context);
              _syncCart();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('清空'),
          ),
        ],
      ),
    );
  }
  
  void _updateCartItem(Map<String, dynamic> item) {
    // TODO(dev): Call API to update cart item
    _syncCart();
  }
  
  void _syncCart() {
    // TODO(dev): Call API to sync cart to backend
  }
  
  void _checkout() {
    if (_cartItems.isEmpty) return;
    
    // 跳转到订单确认页面
    Navigator.pushNamed(
      context,
      '/checkout',
      arguments: {
        'cartItems': _cartItems,
        'totalAmount': _calculateTotal(),
        'totalQuantity': _calculateTotalQuantity(),
      },
    );
  }
  
  List<Map<String, dynamic>> _getMockCartItems() {
    return [
      {
        'id': '1',
        'dishId': 'dish_1',
        'name': '宫保鸡丁',
        'price': 28.0,
        'originalPrice': 32.0,
        'quantity': 2,
        'specifications': {
          '口味': '中辣',
          '分量': '标准',
        },
        'imageUrl': null,
      },
      {
        'id': '2',
        'dishId': 'dish_2',
        'name': '麻婆豆腐',
        'price': 22.0,
        'quantity': 1,
        'specifications': {
          '口味': '微辣',
        },
        'imageUrl': null,
      },
      {
        'id': '3',
        'dishId': 'dish_3',
        'name': '西红柿鸡蛋汤',
        'price': 12.0,
        'quantity': 1,
        'specifications': <String, dynamic>{},
        'imageUrl': null,
      },
    ];
  }
}