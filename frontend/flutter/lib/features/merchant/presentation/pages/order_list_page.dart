import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/order_provider.dart';
import '../widgets/order_card.dart';
import '../widgets/order_filter_bar.dart';
import '../widgets/order_status_tabs.dart';
import '../../domain/entities/order_entity.dart';

class OrderListPage extends ConsumerStatefulWidget {
  final String merchantId;
  final String? storeId;

  const OrderListPage({
    Key? key,
    required this.merchantId,
    this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends ConsumerState<OrderListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<OrderStatus?> _statusTabs = [
    null, // 全部
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.preparing,
    OrderStatus.ready,
    OrderStatus.completed,
    OrderStatus.cancelled,
  ];

  final List<String> _tabTitles = [
    '全部',
    '待确认',
    '已确认',
    '制作中',
    '已完成',
    '已送达',
    '已取消',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      final selectedStatus = _statusTabs[_tabController.index];
      ref.read(orderFilterProvider.notifier).updateFilter(
        status: selectedStatus,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(orderFilterProvider);
    final orderListParams = OrderListParams(
      merchantId: widget.merchantId,
      storeId: widget.storeId,
      status: filterState.status?.value,
      startDate: filterState.startDate,
      endDate: filterState.endDate,
    );
    final ordersAsync = ref.watch(orderListProvider(orderListParams));

    return Scaffold(
      appBar: AppBar(
        title: const Text('订单管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(orderListProvider(orderListParams).notifier).refreshOrders();
            },
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => _navigateToAnalytics(),
          ),
          IconButton(
            icon: const Icon(Icons.kitchen),
            onPressed: () => _navigateToProductionQueue(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabTitles.map((title) {
            final index = _tabTitles.indexOf(title);
            final status = _statusTabs[index];
            
            return Tab(
              child: ordersAsync.when(
                data: (orders) {
                  final count = status == null 
                    ? orders.length 
                    : orders.where((o) => o.status == status).length;
                  
                  return Row(
                    children: [
                      Text(title),
                      if (count > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: status?.color ?? Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
                loading: () => Text(title),
                error: (_, __) => Text(title),
              ),
            );
          }).toList(),
        ),
      ),
      body: Column(
        children: [
          // 筛选栏
          OrderFilterBar(
            onFilterChanged: () {
              // 筛选变化会自动触发订单列表更新
            },
          ),
          
          // 订单列表
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _statusTabs.map((status) {
                return ordersAsync.when(
                  data: (orders) {
                    final filteredOrders = _filterOrders(orders, status, filterState);
                    
                    if (filteredOrders.isEmpty) {
                      return _buildEmptyState(status);
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await ref.read(orderListProvider(orderListParams).notifier).refreshOrders();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return OrderCard(
                            order: order,
                            onTap: () => _navigateToOrderDetail(order.id),
                            onStatusUpdate: (newStatus) => _updateOrderStatus(order, newStatus),
                            onBatchSelect: (selected) => _handleBatchSelect(order, selected),
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
                            ref.read(orderListProvider(orderListParams).notifier).refreshOrders();
                          },
                          child: const Text('重试'),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildBatchActionButton(),
    );
  }

  List<OrderEntity> _filterOrders(List<OrderEntity> orders, OrderStatus? status, OrderFilterState filterState) {
    var filteredOrders = orders;
    
    // 按状态筛选
    if (status != null) {
      filteredOrders = filteredOrders.where((order) => order.status == status).toList();
    }
    
    // 按搜索关键词筛选
    if (filterState.searchQuery.isNotEmpty) {
      final query = filterState.searchQuery.toLowerCase();
      filteredOrders = filteredOrders.where((order) =>
        order.orderNumber.toLowerCase().contains(query) ||
        order.customerName.toLowerCase().contains(query) ||
        order.customerPhone.contains(query)
      ).toList();
    }
    
    // 按订单类型筛选
    if (filterState.orderType != null) {
      filteredOrders = filteredOrders.where((order) => order.orderType == filterState.orderType).toList();
    }
    
    // 按支付状态筛选
    if (filterState.paymentStatus != null) {
      filteredOrders = filteredOrders.where((order) => order.paymentStatus == filterState.paymentStatus).toList();
    }
    
    // 按时间排序（最新的在前）
    filteredOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return filteredOrders;
  }

  Widget _buildEmptyState(OrderStatus? status) {
    final statusName = status?.displayName ?? '订单';
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '暂无$statusName',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          if (status == OrderStatus.pending)
            Text(
              '新订单将实时显示在这里',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
        ],
      ),
    );
  }

  Widget? _buildBatchActionButton() {
    // TODO: 实现批量操作功能
    return null;
  }

  Future<void> _updateOrderStatus(OrderEntity order, OrderStatus newStatus) async {
    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认更新订单状态'),
        content: Text('确定要将订单 ${order.orderNumber} 的状态更新为"${newStatus.displayName}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确认'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final filterState = ref.read(orderFilterProvider);
      final orderListParams = OrderListParams(
        merchantId: widget.merchantId,
        storeId: widget.storeId,
        status: filterState.status?.value,
        startDate: filterState.startDate,
        endDate: filterState.endDate,
      );
      
      final success = await ref
          .read(orderListProvider(orderListParams).notifier)
          .updateOrderStatus(order.id, newStatus.value);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('订单状态已更新为"${newStatus.displayName}"')),
        );
      }
    }
  }

  void _handleBatchSelect(OrderEntity order, bool selected) {
    // TODO: 实现批量选择功能
  }

  void _navigateToOrderDetail(String orderId) {
    context.push('/merchant/${widget.merchantId}/orders/$orderId');
  }

  void _navigateToAnalytics() {
    context.push('/merchant/${widget.merchantId}/orders/analytics');
  }

  void _navigateToProductionQueue() {
    context.push('/merchant/${widget.merchantId}/orders/production');
  }
}