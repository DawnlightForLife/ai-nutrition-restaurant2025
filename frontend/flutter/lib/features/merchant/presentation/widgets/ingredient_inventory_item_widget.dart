/**
 * 食材库存项组件
 */

import 'package:flutter/material.dart';
import '../../domain/entities/merchant_inventory.dart';

class IngredientInventoryItemWidget extends StatelessWidget {
  final IngredientInventoryItem ingredient;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final Function(double) onUpdateStock;
  final VoidCallback onQuickRestock;

  const IngredientInventoryItemWidget({
    super.key,
    required this.ingredient,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onUpdateStock,
    required this.onQuickRestock,
  });

  @override
  Widget build(BuildContext context) {
    final stockPercentage = ingredient.currentStock / ingredient.maxCapacity;
    final isLowStock = ingredient.currentStock <= ingredient.minThreshold;
    final isOutOfStock = ingredient.currentStock <= 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isSelectionMode)
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) => onTap(),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                ingredient.chineseName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildStatusChip(isLowStock, isOutOfStock),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${ingredient.name} · ${ingredient.category}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '库存: ${ingredient.currentStock.toStringAsFixed(1)} ${ingredient.unit}',
                              style: TextStyle(
                                color: isLowStock ? Colors.orange : null,
                                fontWeight:
                                    isLowStock ? FontWeight.bold : null,
                              ),
                            ),
                            Text(
                              '最大: ${ingredient.maxCapacity.toStringAsFixed(1)} ${ingredient.unit}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: stockPercentage,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getStockColor(stockPercentage, isLowStock),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isSelectionMode) ...[
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: onQuickRestock,
                      tooltip: '快速补货',
                      color: Colors.orange,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(
                    icon: Icons.attach_money,
                    label: '成本',
                    value: '¥${ingredient.costPerUnit.toStringAsFixed(2)}/${ingredient.unit}',
                  ),
                  _buildInfoItem(
                    icon: Icons.sell,
                    label: '售价',
                    value: '¥${ingredient.sellingPricePerUnit.toStringAsFixed(2)}/${ingredient.unit}',
                  ),
                  if (ingredient.expiryDate != null)
                    _buildInfoItem(
                      icon: Icons.schedule,
                      label: '过期',
                      value: _formatExpiryDate(ingredient.expiryDate!),
                      isWarning: _isExpiringSoon(ingredient.expiryDate!),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isLowStock, bool isOutOfStock) {
    if (isOutOfStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          '缺货',
          style: TextStyle(
            fontSize: 12,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (isLowStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          '低库存',
          style: TextStyle(
            fontSize: 12,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          '充足',
          style: TextStyle(
            fontSize: 12,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    bool isWarning = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isWarning ? Colors.orange : Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isWarning ? Colors.orange : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStockColor(double percentage, bool isLowStock) {
    if (percentage <= 0) return Colors.red;
    if (isLowStock) return Colors.orange;
    if (percentage >= 0.8) return Colors.green;
    return Colors.blue;
  }

  String _formatExpiryDate(DateTime date) {
    final days = date.difference(DateTime.now()).inDays;
    if (days < 0) return '已过期';
    if (days == 0) return '今天';
    if (days == 1) return '明天';
    if (days <= 7) return '$days天';
    return '${date.month}/${date.day}';
  }

  bool _isExpiringSoon(DateTime date) {
    final days = date.difference(DateTime.now()).inDays;
    return days <= 3;
  }
}