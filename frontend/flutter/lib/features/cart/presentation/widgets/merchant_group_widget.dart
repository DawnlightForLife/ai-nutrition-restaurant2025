/**
 * 商家分组组件
 */

import 'package:flutter/material.dart';
import '../../domain/entities/nutrition_cart.dart';
import 'cart_item_widget.dart';

class MerchantGroupWidget extends StatelessWidget {
  final String merchantId;
  final String merchantName;
  final List<NutritionCartItem> items;
  final Function(String, double) onItemQuantityChanged;
  final Function(String) onItemRemoved;
  final bool isUpdating;
  final Map<String, bool> itemUpdatingStatus;

  const MerchantGroupWidget({
    super.key,
    required this.merchantId,
    required this.merchantName,
    required this.items,
    required this.onItemQuantityChanged,
    required this.onItemRemoved,
    required this.isUpdating,
    required this.itemUpdatingStatus,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = items.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 商家头部
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.store,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    merchantName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '¥${subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          
          // 商品列表
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: items.map((item) {
                final isItemUpdating = itemUpdatingStatus[item.id] ?? false;
                
                return CartItemWidget(
                  item: item,
                  onQuantityChanged: (quantity) {
                    onItemQuantityChanged(item.id, quantity);
                  },
                  onRemove: () {
                    onItemRemoved(item.id);
                  },
                  isUpdating: isItemUpdating,
                );
              }).toList(),
            ),
          ),
          
          // 配送费和其他费用
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '商品小计',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      '¥${subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '配送费',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      subtotal >= 30 ? '免配送费' : '¥3.00',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: subtotal >= 30 ? Colors.green : null,
                      ),
                    ),
                  ],
                ),
                if (subtotal < 30) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '再购买¥${(30 - subtotal).toStringAsFixed(2)}即可免配送费',
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}