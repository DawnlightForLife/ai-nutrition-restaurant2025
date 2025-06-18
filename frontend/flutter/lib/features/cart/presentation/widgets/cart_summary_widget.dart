/**
 * 购物车结算摘要组件
 */

import 'package:flutter/material.dart';
import '../../domain/entities/nutrition_cart.dart';

class CartSummaryWidget extends StatelessWidget {
  final NutritionCart cart;
  final NutritionBalanceAnalysis? analysis;
  final bool isUpdating;
  final VoidCallback onCheckout;

  const CartSummaryWidget({
    super.key,
    required this.cart,
    this.analysis,
    required this.isUpdating,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 营养快览
              if (analysis != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getNutritionStatusColor(analysis!.overallScore).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getNutritionStatusColor(analysis!.overallScore).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getNutritionStatusIcon(analysis!.overallScore),
                        color: _getNutritionStatusColor(analysis!.overallScore),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '营养评分: ${analysis!.overallScore.toStringAsFixed(1)}/10',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getNutritionStatusColor(analysis!.overallScore),
                              ),
                            ),
                            Text(
                              _getNutritionStatusText(analysis!.overallScore),
                              style: TextStyle(
                                fontSize: 12,
                                color: _getNutritionStatusColor(analysis!.overallScore),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${cart.totalCalories} 卡路里',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // 价格摘要
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '共 ${cart.items.length} 件商品',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          if (cart.totalWeight > 0) ...[
                            Text(
                              ' • ${cart.totalWeight.toStringAsFixed(1)}kg',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            '合计: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '¥${cart.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      if (cart.discountAmount > 0) ...[
                        const SizedBox(height: 2),
                        Text(
                          '已优惠 ¥${cart.discountAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ],
                  ),
                  ElevatedButton(
                    onPressed: isUpdating ? null : onCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: isUpdating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            '去结算',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),

              // 营养警告
              if (analysis != null && analysis!.warnings.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange[700], size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          analysis!.warnings.first,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getNutritionStatusColor(double score) {
    if (score >= 8.0) return Colors.green;
    if (score >= 6.0) return Colors.orange;
    return Colors.red;
  }

  IconData _getNutritionStatusIcon(double score) {
    if (score >= 8.0) return Icons.check_circle;
    if (score >= 6.0) return Icons.warning;
    return Icons.error;
  }

  String _getNutritionStatusText(double score) {
    if (score >= 8.0) return '营养均衡';
    if (score >= 6.0) return '可以改善';
    return '需要调整';
  }
}