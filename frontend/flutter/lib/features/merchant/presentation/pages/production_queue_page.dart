import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';
import '../widgets/order_card.dart';
import '../../domain/entities/order_entity.dart';

class ProductionQueuePage extends ConsumerWidget {
  final String storeId;

  const ProductionQueuePage({
    Key? key,
    required this.storeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueAsync = ref.watch(productionQueueProvider(storeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('制作队列'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(productionQueueProvider(storeId).notifier).refreshProductionQueue();
            },
          ),
        ],
      ),
      body: queueAsync.when(
        data: (queue) {
          if (queue == null) {
            return const Center(child: Text('暂无数据'));
          }

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                // 统计信息
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        context,
                        '待制作',
                        queue.pendingOrders.length.toString(),
                        Icons.pending_actions,
                        Colors.orange,
                      ),
                      _buildStatCard(
                        context,
                        '制作中',
                        queue.preparingOrders.length.toString(),
                        Icons.restaurant,
                        Colors.blue,
                      ),
                      _buildStatCard(
                        context,
                        '已完成',
                        queue.readyOrders.length.toString(),
                        Icons.check_circle,
                        Colors.green,
                      ),
                      _buildStatCard(
                        context,
                        '平均用时',
                        '${queue.averagePrepTime.toStringAsFixed(0)}分',
                        Icons.timer,
                        Colors.purple,
                      ),
                    ],
                  ),
                ),
                
                // Tab栏
                const TabBar(
                  tabs: [
                    Tab(text: '待制作'),
                    Tab(text: '制作中'),
                    Tab(text: '已完成'),
                  ],
                ),
                
                // Tab内容
                Expanded(
                  child: TabBarView(
                    children: [
                      // 待制作
                      _buildOrderList(
                        context,
                        ref,
                        queue.pendingOrders,
                        '暂无待制作订单',
                        (order) => _updateOrderStatus(context, ref, order, OrderStatus.preparing),
                      ),
                      
                      // 制作中
                      _buildOrderList(
                        context,
                        ref,
                        queue.preparingOrders,
                        '暂无制作中订单',
                        (order) => _updateOrderStatus(context, ref, order, OrderStatus.ready),
                      ),
                      
                      // 已完成
                      _buildOrderList(
                        context,
                        ref,
                        queue.readyOrders,
                        '暂无已完成订单',
                        (order) => _updateOrderStatus(
                          context,
                          ref,
                          order,
                          order.orderType == OrderType.delivery 
                              ? OrderStatus.delivering 
                              : OrderStatus.completed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                  ref.read(productionQueueProvider(storeId).notifier).refreshProductionQueue();
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderList(
    BuildContext context,
    WidgetRef ref,
    List<OrderEntity> orders,
    String emptyMessage,
    Function(OrderEntity) onStatusUpdate,
  ) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(productionQueueProvider(storeId).notifier).refreshProductionQueue();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(
            order: order,
            onStatusUpdate: (newStatus) => onStatusUpdate(order),
          );
        },
      ),
    );
  }

  Future<void> _updateOrderStatus(
    BuildContext context,
    WidgetRef ref,
    OrderEntity order,
    OrderStatus newStatus,
  ) async {
    // 创建用于获取订单列表的参数
    final orderListParams = OrderListParams(
      storeId: storeId,
    );
    
    final success = await ref
        .read(orderListProvider(orderListParams).notifier)
        .updateOrderStatus(order.id, newStatus.value);
    
    if (success) {
      // 刷新制作队列
      ref.read(productionQueueProvider(storeId).notifier).refreshProductionQueue();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('订单 ${order.orderNumber} 状态已更新为"${newStatus.displayName}"'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('状态更新失败'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}