/**
 * 快速操作组件
 */

import 'package:flutter/material.dart';

class QuickActionsWidget extends StatelessWidget {
  final String merchantId;
  final VoidCallback onIngredientManagement;
  final VoidCallback onDishManagement;
  final VoidCallback onRestockSuggestions;
  final VoidCallback onNutritionAnalysis;

  const QuickActionsWidget({
    super.key,
    required this.merchantId,
    required this.onIngredientManagement,
    required this.onDishManagement,
    required this.onRestockSuggestions,
    required this.onNutritionAnalysis,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '快速操作',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.inventory_2_outlined,
                  label: '食材管理',
                  color: Colors.blue,
                  onTap: onIngredientManagement,
                ),
                _buildActionButton(
                  context,
                  icon: Icons.restaurant_menu,
                  label: '菜品管理',
                  color: Colors.green,
                  onTap: onDishManagement,
                ),
                _buildActionButton(
                  context,
                  icon: Icons.shopping_cart_outlined,
                  label: '补货建议',
                  color: Colors.orange,
                  onTap: onRestockSuggestions,
                ),
                _buildActionButton(
                  context,
                  icon: Icons.analytics_outlined,
                  label: '营养分析',
                  color: Colors.purple,
                  onTap: onNutritionAnalysis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}