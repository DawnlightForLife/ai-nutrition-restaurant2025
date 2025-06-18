/**
 * 商家库存管理仪表板页面
 * 革命性的营养元素驱动库存管理界面
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/merchant_inventory.dart';
import '../providers/merchant_inventory_provider.dart';
import '../widgets/inventory_stats_card.dart';
import '../widgets/inventory_alerts_widget.dart';
import '../widgets/nutrition_coverage_chart.dart';
import '../widgets/quick_actions_widget.dart';

class MerchantInventoryDashboardPage extends ConsumerStatefulWidget {
  final String merchantId;

  const MerchantInventoryDashboardPage({
    super.key,
    required this.merchantId,
  });

  @override
  ConsumerState<MerchantInventoryDashboardPage> createState() =>
      _MerchantInventoryDashboardPageState();
}

class _MerchantInventoryDashboardPageState
    extends ConsumerState<MerchantInventoryDashboardPage> {
  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(merchantInventoryProvider(widget.merchantId));
    final inventoryNotifier = ref.read(merchantInventoryProvider(widget.merchantId).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('营养库存管理中心'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () => _showNutritionAnalysis(context),
            tooltip: '营养分析',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _navigateToAlerts(context),
            tooltip: '库存预警',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => inventoryNotifier.loadIngredientInventory(),
            tooltip: '刷新',
          ),
        ],
      ),
      body: inventoryState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  inventoryNotifier.loadIngredientInventory(),
                  inventoryNotifier.loadInventoryAlerts(),
                ]);
              },
              child: CustomScrollView(
                slivers: [
                  // 库存统计卡片
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildStatsSection(inventoryState, inventoryNotifier),
                    ),
                  ),

                  // 快速操作
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: QuickActionsWidget(
                        merchantId: widget.merchantId,
                        onIngredientManagement: () => _navigateToIngredients(context),
                        onDishManagement: () => _navigateToDishes(context),
                        onRestockSuggestions: () => _showRestockSuggestions(context),
                        onNutritionAnalysis: () => _showNutritionAnalysis(context),
                      ),
                    ),
                  ),

                  // 库存预警
                  if (inventoryState.alerts.isNotEmpty) ...[
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          '库存预警',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        height: 150,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: InventoryAlertsWidget(
                          alerts: inventoryState.alerts.take(5).toList(),
                          onAlertTap: (alert) => _handleAlert(context, alert),
                          onViewAll: () => _navigateToAlerts(context),
                        ),
                      ),
                    ),
                  ],

                  // 营养覆盖度图表
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '营养元素覆盖度',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 300,
                            child: NutritionCoverageChart(
                              nutritionAnalysis: inventoryState.nutritionAnalysis,
                              onGenerateAnalysis: () async {
                                await inventoryNotifier.generateNutritionAnalysis();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 低库存食材
                  if (_getLowStockIngredients(inventoryState).isNotEmpty) ...[
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          '低库存食材',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final ingredient = _getLowStockIngredients(inventoryState)[index];
                          return _buildLowStockItem(ingredient);
                        },
                        childCount: _getLowStockIngredients(inventoryState).length,
                      ),
                    ),
                  ],

                  const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddIngredientDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('添加食材'),
      ),
    );
  }

  Widget _buildStatsSection(
    MerchantInventoryState state,
    MerchantInventoryNotifier notifier,
  ) {
    final stats = notifier.inventoryStats;
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        InventoryStatsCard(
          title: '总食材',
          value: stats['totalIngredients'].toString(),
          icon: Icons.inventory_2_outlined,
          color: Colors.blue,
          trend: '+5%',
        ),
        InventoryStatsCard(
          title: '低库存',
          value: stats['lowStockCount'].toString(),
          icon: Icons.warning_amber_outlined,
          color: Colors.orange,
          trend: stats['lowStockCount'] > 0 ? '需补货' : '库存充足',
        ),
        InventoryStatsCard(
          title: '库存价值',
          value: '¥${stats['totalValue'].toStringAsFixed(2)}',
          icon: Icons.attach_money,
          color: Colors.green,
          trend: '+12%',
        ),
        InventoryStatsCard(
          title: '缺货',
          value: stats['outOfStockCount'].toString(),
          icon: Icons.remove_shopping_cart_outlined,
          color: Colors.red,
          trend: stats['outOfStockCount'] > 0 ? '紧急' : '正常',
        ),
      ],
    );
  }

  Widget _buildLowStockItem(IngredientInventoryItem ingredient) {
    final stockPercentage = ingredient.currentStock / ingredient.maxCapacity;
    final isOutOfStock = ingredient.currentStock <= 0;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOutOfStock ? Colors.red : Colors.orange,
          child: Icon(
            isOutOfStock ? Icons.error_outline : Icons.warning_amber_outlined,
            color: Colors.white,
          ),
        ),
        title: Text(ingredient.chineseName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '当前库存: ${ingredient.currentStock} ${ingredient.unit} / ${ingredient.maxCapacity} ${ingredient.unit}',
              style: TextStyle(
                color: isOutOfStock ? Colors.red : null,
              ),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: stockPercentage,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutOfStock ? Colors.red : Colors.orange,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () => _showRestockDialog(context, ingredient),
        ),
      ),
    );
  }

  List<IngredientInventoryItem> _getLowStockIngredients(
    MerchantInventoryState state,
  ) {
    return state.ingredients
        .where((ingredient) => ingredient.currentStock <= ingredient.minThreshold)
        .toList()
      ..sort((a, b) => a.currentStock.compareTo(b.currentStock));
  }

  void _navigateToIngredients(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/merchant/inventory/ingredients',
      arguments: {
        'merchantId': widget.merchantId,
      },
    );
  }

  void _navigateToDishes(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/merchant/inventory/dishes',
      arguments: {
        'merchantId': widget.merchantId,
      },
    );
  }

  void _navigateToAlerts(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/merchant/inventory/alerts',
      arguments: {
        'merchantId': widget.merchantId,
      },
    );
  }

  void _showRestockSuggestions(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/merchant/inventory/restock-suggestions',
      arguments: {
        'merchantId': widget.merchantId,
      },
    );
  }

  void _showNutritionAnalysis(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/merchant/inventory/nutrition-analysis',
      arguments: {
        'merchantId': widget.merchantId,
      },
    );
  }

  void _handleAlert(BuildContext context, InventoryAlert alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('库存预警: ${alert.ingredientName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alert.message),
            const SizedBox(height: 16),
            Text('严重程度: ${alert.severity}'),
            if (alert.currentStock != null)
              Text('当前库存: ${alert.currentStock}'),
            if (alert.expiryDate != null)
              Text('过期时间: ${alert.expiryDate}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (alert.alertType == 'low_stock') {
                _showRestockDialog(context, null);
              }
            },
            child: const Text('处理'),
          ),
        ],
      ),
    );
  }

  void _showRestockDialog(BuildContext context, IngredientInventoryItem? ingredient) {
    // TODO: 实现补货对话框
    context.showInfoSnackBar('补货功能开发中...');
  }

  void _showAddIngredientDialog(BuildContext context) {
    // TODO: 实现添加食材对话框
    context.showInfoSnackBar('添加食材功能开发中...');
  }
}