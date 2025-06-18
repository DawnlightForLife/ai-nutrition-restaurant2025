/**
 * 食材筛选组件
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/merchant_inventory_provider.dart';

class IngredientFilterWidget extends ConsumerWidget {
  final String merchantId;
  final VoidCallback onApplyFilters;

  const IngredientFilterWidget({
    super.key,
    required this.merchantId,
    required this.onApplyFilters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryState = ref.watch(merchantInventoryProvider(merchantId));
    final inventoryNotifier = ref.read(merchantInventoryProvider(merchantId).notifier);

    // 获取所有分类
    final categories = _extractCategories(inventoryState);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '筛选条件',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  inventoryNotifier.updateCategoryFilter(null);
                  inventoryNotifier.toggleLowStockFilter();
                  inventoryNotifier.toggleAvailableFilter();
                },
                child: const Text('重置'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 分类筛选
          const Text(
            '食材分类',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((category) {
              final isSelected = inventoryState.selectedCategory == category;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  inventoryNotifier.updateCategoryFilter(
                    selected ? category : null,
                  );
                },
              );
            }).toList(),
          ),
          
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          // 状态筛选
          const Text(
            '库存状态',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          CheckboxListTile(
            value: inventoryState.showLowStockOnly,
            onChanged: (_) => inventoryNotifier.toggleLowStockFilter(),
            title: const Text('仅显示低库存'),
            subtitle: const Text('库存量低于最小阈值的食材'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          
          CheckboxListTile(
            value: inventoryState.showAvailableOnly,
            onChanged: (_) => inventoryNotifier.toggleAvailableFilter(),
            title: const Text('仅显示可用'),
            subtitle: const Text('可供点餐的食材'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          
          const SizedBox(height: 24),
          
          // 应用按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onApplyFilters,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('应用筛选'),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Set<String> _extractCategories(MerchantInventoryState state) {
    return state.ingredients
        .map((ingredient) => ingredient.category)
        .toSet();
  }
}