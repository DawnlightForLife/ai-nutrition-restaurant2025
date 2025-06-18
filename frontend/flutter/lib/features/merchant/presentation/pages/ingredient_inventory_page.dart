/**
 * 食材库存管理页面
 * 基于营养元素的食材库存管理界面
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/merchant_inventory.dart';
import '../providers/merchant_inventory_provider.dart';
import '../widgets/ingredient_inventory_item_widget.dart';
import '../widgets/ingredient_filter_widget.dart';
import '../widgets/batch_operation_bar.dart';

class IngredientInventoryPage extends ConsumerStatefulWidget {
  final String merchantId;

  const IngredientInventoryPage({
    super.key,
    required this.merchantId,
  });

  @override
  ConsumerState<IngredientInventoryPage> createState() =>
      _IngredientInventoryPageState();
}

class _IngredientInventoryPageState
    extends ConsumerState<IngredientInventoryPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isSelectionMode = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(merchantInventoryProvider(widget.merchantId));
    final inventoryNotifier = ref.read(merchantInventoryProvider(widget.merchantId).notifier);
    final filteredIngredients = inventoryNotifier.filteredIngredients;

    return Scaffold(
      appBar: AppBar(
        title: const Text('食材库存管理'),
        actions: [
          if (!_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _showSearchDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterBottomSheet(context),
            ),
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: () {
                setState(() => _isSelectionMode = true);
              },
            ),
          ] else ...[
            TextButton(
              onPressed: () {
                inventoryNotifier.selectAllIngredients();
              },
              child: const Text('全选'),
            ),
            TextButton(
              onPressed: () {
                setState(() => _isSelectionMode = false);
                inventoryNotifier.clearSelection();
              },
              child: const Text('取消'),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // 筛选标签
          if (inventoryState.selectedCategory != null ||
              inventoryState.showLowStockOnly ||
              inventoryState.showAvailableOnly)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                children: [
                  if (inventoryState.selectedCategory != null)
                    Chip(
                      label: Text('分类: ${inventoryState.selectedCategory}'),
                      onDeleted: () => inventoryNotifier.updateCategoryFilter(null),
                    ),
                  if (inventoryState.showLowStockOnly)
                    Chip(
                      label: const Text('仅显示低库存'),
                      onDeleted: () => inventoryNotifier.toggleLowStockFilter(),
                    ),
                  if (inventoryState.showAvailableOnly)
                    Chip(
                      label: const Text('仅显示可用'),
                      onDeleted: () => inventoryNotifier.toggleAvailableFilter(),
                    ),
                ],
              ),
            ),

          // 食材列表
          Expanded(
            child: inventoryState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => inventoryNotifier.loadIngredientInventory(),
                    child: filteredIngredients.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(bottom: 80),
                            itemCount: filteredIngredients.length,
                            itemBuilder: (context, index) {
                              final ingredient = filteredIngredients[index];
                              final isSelected = inventoryState.selectedIngredientIds
                                  .contains(ingredient.id);

                              return IngredientInventoryItemWidget(
                                ingredient: ingredient,
                                isSelectionMode: _isSelectionMode,
                                isSelected: isSelected,
                                onTap: () {
                                  if (_isSelectionMode) {
                                    inventoryNotifier.toggleIngredientSelection(
                                      ingredient.id,
                                    );
                                  } else {
                                    _showIngredientDetails(context, ingredient);
                                  }
                                },
                                onUpdateStock: (newStock) {
                                  _updateIngredientStock(ingredient, newStock);
                                },
                                onQuickRestock: () {
                                  _quickRestock(ingredient);
                                },
                              );
                            },
                          ),
                  ),
          ),

          // 批量操作栏
          if (_isSelectionMode && inventoryState.selectedIngredientIds.isNotEmpty)
            BatchOperationBar(
              selectedCount: inventoryState.selectedIngredientIds.length,
              onBatchUpdate: () => _showBatchUpdateDialog(context),
              onBatchDelete: () => _confirmBatchDelete(context),
              onExport: () => _exportSelectedIngredients(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddIngredient(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '暂无食材库存',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击下方按钮添加食材',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final inventoryNotifier = ref.read(merchantInventoryProvider(widget.merchantId).notifier);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('搜索食材'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '输入食材名称',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            inventoryNotifier.updateSearchQuery(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              inventoryNotifier.updateSearchQuery('');
              Navigator.of(context).pop();
            },
            child: const Text('清除'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => IngredientFilterWidget(
        merchantId: widget.merchantId,
        onApplyFilters: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showIngredientDetails(BuildContext context, IngredientInventoryItem ingredient) {
    Navigator.of(context).pushNamed(
      '/merchant/inventory/ingredient-details',
      arguments: {
        'merchantId': widget.merchantId,
        'ingredient': ingredient,
      },
    );
  }

  void _updateIngredientStock(IngredientInventoryItem ingredient, double newStock) {
    final inventoryNotifier = ref.read(merchantInventoryProvider(widget.merchantId).notifier);
    final updatedIngredient = ingredient.copyWith(
      currentStock: newStock,
      availableStock: newStock - ingredient.reservedStock,
    );
    
    inventoryNotifier.updateIngredientInventory(updatedIngredient);
    context.showSuccessSnackBar('库存已更新');
  }

  void _quickRestock(IngredientInventoryItem ingredient) {
    final inventoryNotifier = ref.read(merchantInventoryProvider(widget.merchantId).notifier);
    
    // 快速补货到最大容量
    final restockAmount = ingredient.maxCapacity - ingredient.currentStock;
    final transaction = InventoryTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ingredientId: ingredient.id,
      type: 'restock',
      quantity: restockAmount,
      unit: ingredient.unit,
      reason: '快速补货',
      costPerUnit: ingredient.costPerUnit,
      operatorId: 'current_user', // TODO: 从用户状态获取
      timestamp: DateTime.now(),
      stockBefore: ingredient.currentStock,
      stockAfter: ingredient.maxCapacity,
    );
    
    inventoryNotifier.recordInventoryTransaction(transaction);
    
    final updatedIngredient = ingredient.copyWith(
      currentStock: ingredient.maxCapacity,
      availableStock: ingredient.maxCapacity - ingredient.reservedStock,
      lastRestockDate: DateTime.now(),
    );
    
    inventoryNotifier.updateIngredientInventory(updatedIngredient);
    context.showSuccessSnackBar('已补货至最大容量');
  }

  void _showBatchUpdateDialog(BuildContext context) {
    // TODO: 实现批量更新对话框
    context.showInfoSnackBar('批量更新功能开发中...');
  }

  void _confirmBatchDelete(BuildContext context) {
    final selectedCount = ref.read(merchantInventoryProvider(widget.merchantId))
        .selectedIngredientIds.length;
    
    context.showConfirmDialog(
      title: '确认删除',
      message: '确定要删除选中的 $selectedCount 个食材吗？',
    ).then((confirmed) {
      if (confirmed) {
        // TODO: 实现批量删除
        context.showInfoSnackBar('批量删除功能开发中...');
      }
    });
  }

  void _exportSelectedIngredients() {
    // TODO: 实现导出功能
    context.showInfoSnackBar('导出功能开发中...');
  }

  void _navigateToAddIngredient(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/merchant/inventory/add-ingredient',
      arguments: {
        'merchantId': widget.merchantId,
      },
    );
  }
}