import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../providers/order_provider.dart';
import '../widgets/order_card.dart';
import '../../domain/entities/order_entity.dart';
import '../../services/realtime_order_service.dart';

/// 生产队列页面V2 - 支持实时更新
class ProductionQueuePageV2 extends ConsumerStatefulWidget {
  final String storeId;

  const ProductionQueuePageV2({
    Key? key,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<ProductionQueuePageV2> createState() => _ProductionQueuePageV2State();
}

class _ProductionQueuePageV2State extends ConsumerState<ProductionQueuePageV2> 
    with WidgetsBindingObserver {
  late RealtimeOrderService _realtimeService;
  StreamSubscription<OrderUpdateEvent>? _orderUpdateSubscription;
  bool _isHighFrequencyMode = false;
  
  // 动画控制器
  final Map<String, GlobalKey<_AnimatedOrderCardState>> _orderCardKeys = {};
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // 初始化实时服务
    _realtimeService = ref.read(realtimeOrderServiceProvider(widget.storeId));
    
    // 订阅订单更新事件
    _subscribeToOrderUpdates();
    
    // 启动实时监听
    _realtimeService.startListening(highFrequency: _isHighFrequencyMode);
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _orderUpdateSubscription?.cancel();
    _realtimeService.stopListening();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // 应用恢复时重新启动监听
        _realtimeService.startListening(highFrequency: _isHighFrequencyMode);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        // 应用暂停时停止监听
        _realtimeService.stopListening();
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
  }
  
  void _subscribeToOrderUpdates() {
    _orderUpdateSubscription = _realtimeService.orderUpdateStream.listen((event) {
      switch (event.type) {
        case OrderUpdateEventType.newOrder:
          _handleNewOrder(event.order!);
          break;
        case OrderUpdateEventType.orderUpdated:
          _handleOrderUpdate(event.order!);
          break;
        case OrderUpdateEventType.error:
          _handleError(event.error!);
          break;
      }
    });
  }
  
  void _handleNewOrder(OrderEntity order) {
    // 播放新订单提醒音
    OrderSoundAlertService().playNewOrderSound();
    
    // 显示新订单通知
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('新订单 #${order.orderNumber}'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: '查看',
            onPressed: () {
              // 跳转到订单详情
            },
          ),
        ),
      );
    }
    
    // 触发动画效果
    final key = _orderCardKeys[order.id];
    key?.currentState?.animateHighlight();
  }
  
  void _handleOrderUpdate(OrderEntity order) {
    // 如果订单完成，播放提醒音
    if (order.status == OrderStatus.ready.value) {
      OrderSoundAlertService().playOrderCompleteSound();
    }
    
    // 触发更新动画
    final key = _orderCardKeys[order.id];
    key?.currentState?.animateUpdate();
  }
  
  void _handleError(String error) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('连接错误: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final queueAsync = ref.watch(productionQueueProvider(widget.storeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('制作队列'),
        actions: [
          // 实时状态指示器
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Chip(
              avatar: Icon(
                Icons.circle,
                size: 12,
                color: _isHighFrequencyMode ? Colors.green : Colors.orange,
              ),
              label: Text(_isHighFrequencyMode ? '高频更新' : '正常更新'),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
          ),
          
          // 高频模式切换
          IconButton(
            icon: Icon(
              _isHighFrequencyMode ? Icons.speed : Icons.timer,
              color: _isHighFrequencyMode ? Colors.green : null,
            ),
            tooltip: _isHighFrequencyMode ? '切换到正常模式' : '切换到高频模式',
            onPressed: () {
              setState(() {
                _isHighFrequencyMode = !_isHighFrequencyMode;
              });
              
              // 重启监听服务
              _realtimeService.stopListening();
              _realtimeService.startListening(highFrequency: _isHighFrequencyMode);
            },
          ),
          
          // 手动刷新
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _realtimeService.refresh();
              ref.read(productionQueueProvider(widget.storeId).notifier).refreshProductionQueue();
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
                // 统计信息（带动画）
                _buildAnimatedStats(context, queue),
                
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
                        OrderStatus.preparing,
                      ),
                      
                      // 制作中
                      _buildOrderList(
                        context,
                        ref,
                        queue.preparingOrders,
                        '暂无制作中订单',
                        OrderStatus.ready,
                      ),
                      
                      // 已完成
                      _buildOrderList(
                        context,
                        ref,
                        queue.readyOrders,
                        '暂无已完成订单',
                        null, // 根据订单类型决定下一状态
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
                  ref.read(productionQueueProvider(widget.storeId).notifier).refreshProductionQueue();
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAnimatedStats(BuildContext context, ProductionQueueEntity queue) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _AnimatedStatCard(
            label: '待制作',
            value: queue.pendingOrders.length,
            icon: Icons.pending_actions,
            color: Colors.orange,
          ),
          _AnimatedStatCard(
            label: '制作中',
            value: queue.preparingOrders.length,
            icon: Icons.restaurant,
            color: Colors.blue,
          ),
          _AnimatedStatCard(
            label: '已完成',
            value: queue.readyOrders.length,
            icon: Icons.check_circle,
            color: Colors.green,
          ),
          _AnimatedStatCard(
            label: '平均用时',
            value: queue.averagePrepTime.toInt(),
            suffix: '分',
            icon: Icons.timer,
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(
    BuildContext context,
    WidgetRef ref,
    List<OrderEntity> orders,
    String emptyMessage,
    OrderStatus? nextStatus,
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
        await ref.read(productionQueueProvider(widget.storeId).notifier).refreshProductionQueue();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final key = GlobalKey<_AnimatedOrderCardState>();
          _orderCardKeys[order.id] = key;
          
          return _AnimatedOrderCard(
            key: key,
            order: order,
            onStatusUpdate: () {
              if (nextStatus != null) {
                _updateOrderStatus(context, ref, order, nextStatus);
              } else {
                // 根据订单类型决定下一状态
                final status = order.orderType == OrderType.delivery 
                    ? OrderStatus.delivering 
                    : OrderStatus.completed;
                _updateOrderStatus(context, ref, order, status);
              }
            },
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
    final orderListParams = OrderListParams(
      storeId: widget.storeId,
    );
    
    final success = await ref
        .read(orderListProvider(orderListParams).notifier)
        .updateOrderStatus(order.id, newStatus.value);
    
    if (success) {
      // 刷新制作队列
      ref.read(productionQueueProvider(widget.storeId).notifier).refreshProductionQueue();
      
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

/// 动画统计卡片
class _AnimatedStatCard extends StatelessWidget {
  final String label;
  final int value;
  final String? suffix;
  final IconData icon;
  final Color color;

  const _AnimatedStatCard({
    Key? key,
    required this.label,
    required this.value,
    this.suffix,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: const Duration(milliseconds: 500),
      builder: (context, animatedValue, child) {
        return Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 4),
            Text(
              '$animatedValue${suffix ?? ''}',
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
      },
    );
  }
}

/// 动画订单卡片
class _AnimatedOrderCard extends StatefulWidget {
  final OrderEntity order;
  final VoidCallback onStatusUpdate;

  const _AnimatedOrderCard({
    Key? key,
    required this.order,
    required this.onStatusUpdate,
  }) : super(key: key);

  @override
  State<_AnimatedOrderCard> createState() => _AnimatedOrderCardState();
}

class _AnimatedOrderCardState extends State<_AnimatedOrderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.green.withOpacity(0.2),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void animateHighlight() {
    _animationController.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _animationController.reverse();
        }
      });
    });
  }
  
  void animateUpdate() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: _colorAnimation.value,
              borderRadius: BorderRadius.circular(8),
            ),
            child: OrderCard(
              order: widget.order,
              onStatusUpdate: (_) => widget.onStatusUpdate(),
            ),
          ),
        );
      },
    );
  }
}