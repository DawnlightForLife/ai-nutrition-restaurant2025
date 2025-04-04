import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/core/auth_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/error_message.dart';

class OrdersPage extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = true;
  String? _errorMessage;
  final List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // 模拟加载订单
    await Future.delayed(const Duration(seconds: 1));

    try {
      // 这里只是示例数据，实际应用中需要通过API获取数据
      final demoOrders = [
        {
          'id': 'ORD12345',
          'date': DateTime.now().subtract(const Duration(days: 2)),
          'status': 'delivered',
          'total': 89.99,
          'items': [
            {'name': '健康蔬菜沙拉', 'quantity': 1, 'price': 35.99},
            {'name': '低脂烤鸡', 'quantity': 1, 'price': 54.00},
          ],
        },
        {
          'id': 'ORD12346',
          'date': DateTime.now().subtract(const Duration(days: 7)),
          'status': 'delivered',
          'total': 67.50,
          'items': [
            {'name': '全麦面包', 'quantity': 2, 'price': 15.50},
            {'name': '水果拼盘', 'quantity': 1, 'price': 36.50},
          ],
        },
        {
          'id': 'ORD12347',
          'date': DateTime.now().subtract(const Duration(days: 14)),
          'status': 'delivered',
          'total': 120.00,
          'items': [
            {'name': '高蛋白套餐', 'quantity': 1, 'price': 120.00},
          ],
        },
      ];

      setState(() {
        _orders.clear();
        _orders.addAll(demoOrders);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '加载订单失败：$e';
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return '待处理';
      case 'processing':
        return '处理中';
      case 'shipped':
        return '已发货';
      case 'delivered':
        return '已送达';
      case 'cancelled':
        return '已取消';
      default:
        return '未知';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.amber;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.orange;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (!authProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('我的订单'),
        ),
        body: const Center(
          child: Text('请先登录'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的订单'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator(message: '加载订单中...')
          : _errorMessage != null
              ? ErrorMessage(
                  message: _errorMessage!,
                  onRetry: _loadOrders,
                )
              : _orders.isEmpty
                  ? const Center(
                      child: Text('暂无订单记录'),
                    )
                  : ListView.builder(
                      itemCount: _orders.length,
                      itemBuilder: (ctx, index) {
                        final order = _orders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: ExpansionTile(
                            title: Text(
                              '订单号: ${order['id']}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text('日期: ${_formatDate(order['date'])}'),
                                Row(
                                  children: [
                                    Text('状态: '),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(order['status']),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _getStatusText(order['status']),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Text(
                              '￥${order['total'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            children: [
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '订单详情',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...List.generate(
                                      (order['items'] as List).length,
                                      (itemIndex) {
                                        final item = order['items'][itemIndex];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${item['name']} x${item['quantity']}'),
                                              Text('￥${item['price'].toStringAsFixed(2)}'),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          '总计',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '￥${order['total'].toStringAsFixed(2)}',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          // 查看订单详情
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('订单详情功能尚未实现'),
                                            ),
                                          );
                                        },
                                        child: const Text('查看详情'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
} 