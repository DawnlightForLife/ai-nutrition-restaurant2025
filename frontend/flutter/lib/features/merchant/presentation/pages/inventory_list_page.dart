import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/inventory_provider.dart';
import '../widgets/inventory_card.dart';
import '../widgets/inventory_alert_badge.dart';
import '../widgets/inventory_filter_bar.dart';
import '../../domain/entities/inventory_entity.dart';

class InventoryListPage extends ConsumerStatefulWidget {
  final String merchantId;

  const InventoryListPage({
    Key? key,
    required this.merchantId,
  }) : super(key: key);

  @override
  ConsumerState<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends ConsumerState<InventoryListPage> {
  String _searchQuery = '';
  String _statusFilter = 'all'; // all, low_stock, expiring, expired
  String _categoryFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final inventoriesAsync = ref.watch(inventoryListProvider(widget.merchantId));
    final alertsAsync = ref.watch(inventoryAlertsProvider(widget.merchantId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('库存管理'),
        actions: [
          // 预警徽章
          alertsAsync.when(
            data: (alerts) => InventoryAlertBadge(
              alertCount: alerts.where((alert) => !alert.isRead).length,
              onTap: () => _showAlertsBottomSheet(context, alerts),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(inventoryListProvider(widget.merchantId).notifier).refreshInventories();
              ref.read(inventoryAlertsProvider(widget.merchantId).notifier).refreshAlerts();
            },
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => _navigateToAnalytics(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索和筛选栏
          InventoryFilterBar(
            searchQuery: _searchQuery,
            statusFilter: _statusFilter,
            categoryFilter: _categoryFilter,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
            onStatusFilterChanged: (filter) {
              setState(() {
                _statusFilter = filter;
              });
            },
            onCategoryFilterChanged: (filter) {
              setState(() {
                _categoryFilter = filter;
              });
            },
          ),
          
          // 库存列表
          Expanded(
            child: inventoriesAsync.when(
              data: (inventories) {
                final filteredInventories = _filterInventories(inventories);
                
                if (filteredInventories.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(inventoryListProvider(widget.merchantId).notifier).refreshInventories();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredInventories.length,
                    itemBuilder: (context, index) {
                      final inventory = filteredInventories[index];
                      return InventoryCard(
                        inventory: inventory,
                        onTap: () => _navigateToInventoryDetail(inventory.id),
                        onAddStock: () => _showAddStockDialog(inventory),
                        onConsumeStock: () => _showConsumeStockDialog(inventory),
                        onRemoveExpired: inventory.hasExpired 
                          ? () => _removeExpiredStock(inventory) 
                          : null,
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
                        ref.read(inventoryListProvider(widget.merchantId).notifier).refreshInventories();
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreateInventory(),
        icon: const Icon(Icons.add),
        label: const Text('添加库存'),
      ),
    );
  }

  List<InventoryEntity> _filterInventories(List<InventoryEntity> inventories) {
    return inventories.where((inventory) {
      // 搜索过滤
      if (_searchQuery.isNotEmpty && 
          !inventory.ingredientName.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }

      // 状态过滤
      switch (_statusFilter) {
        case 'low_stock':
          if (!inventory.isLowStock) return false;
          break;
        case 'expiring':
          if (!inventory.hasExpiringSoon) return false;
          break;
        case 'expired':
          if (!inventory.hasExpired) return false;
          break;
      }

      // 分类过滤
      if (_categoryFilter != 'all' && inventory.status != _categoryFilter) {
        return false;
      }

      return true;
    }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '暂无库存项目',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击下方按钮添加库存项目',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showAlertsBottomSheet(BuildContext context, List<InventoryAlert> alerts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '库存预警',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        _getAlertIcon(alert.type),
                        color: _getAlertColor(alert.severity),
                      ),
                      title: Text(alert.message),
                      subtitle: Text(
                        '${alert.type.displayName} • ${alert.createdAt?.toString().split(' ')[0] ?? ''}',
                      ),
                      trailing: alert.isRead ? null : Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAlertIcon(InventoryAlertType type) {
    switch (type) {
      case InventoryAlertType.lowStock:
        return Icons.inventory;
      case InventoryAlertType.expiryWarning:
        return Icons.schedule;
      case InventoryAlertType.expired:
        return Icons.dangerous;
      case InventoryAlertType.qualityIssue:
        return Icons.warning;
      case InventoryAlertType.autoReorder:
        return Icons.shopping_cart;
      case InventoryAlertType.stockOut:
        return Icons.error;
    }
  }

  Color _getAlertColor(InventoryAlertSeverity severity) {
    switch (severity) {
      case InventoryAlertSeverity.low:
        return Colors.blue;
      case InventoryAlertSeverity.medium:
        return Colors.orange;
      case InventoryAlertSeverity.high:
        return Colors.red;
      case InventoryAlertSeverity.critical:
        return Colors.red[900]!;
    }
  }

  void _showAddStockDialog(InventoryEntity inventory) {
    // TODO: 实现添加库存对话框
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('添加 ${inventory.ingredientName} 库存')),
    );
  }

  void _showConsumeStockDialog(InventoryEntity inventory) {
    // TODO: 实现消耗库存对话框
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('消耗 ${inventory.ingredientName} 库存')),
    );
  }

  Future<void> _removeExpiredStock(InventoryEntity inventory) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('移除过期库存'),
        content: Text('确定要移除 "${inventory.ingredientName}" 的过期库存吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('移除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref
          .read(inventoryListProvider(widget.merchantId).notifier)
          .removeExpiredStock(inventory.id);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已移除 "${inventory.ingredientName}" 的过期库存')),
        );
      }
    }
  }

  void _navigateToInventoryDetail(String inventoryId) {
    context.push('/merchant/${widget.merchantId}/inventory/$inventoryId');
  }

  void _navigateToCreateInventory() {
    context.push('/merchant/${widget.merchantId}/inventory/create');
  }

  void _navigateToAnalytics() {
    context.push('/merchant/${widget.merchantId}/inventory/analytics');
  }
}