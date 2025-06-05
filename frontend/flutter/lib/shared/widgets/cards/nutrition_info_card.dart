import 'package:flutter/material.dart';

/// 营养信息展示卡片
class NutritionInfoCard extends StatelessWidget {
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double? fiber;
  final double? sodium;
  final bool showDetails;
  
  const NutritionInfoCard({
    super.key,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.fiber,
    this.sodium,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '营养成分',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${calories.toStringAsFixed(0)} 千卡',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (showDetails) ...[
              const SizedBox(height: 16),
              _buildNutrientRow('蛋白质', protein, 'g', Colors.blue),
              const SizedBox(height: 8),
              _buildNutrientRow('脂肪', fat, 'g', Colors.orange),
              const SizedBox(height: 8),
              _buildNutrientRow('碳水化合物', carbs, 'g', Colors.green),
              if (fiber != null) ...[
                const SizedBox(height: 8),
                _buildNutrientRow('膳食纤维', fiber!, 'g', Colors.brown),
              ],
              if (sodium != null) ...[
                const SizedBox(height: 8),
                _buildNutrientRow('钠', sodium!, 'mg', Colors.purple),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRow(String label, double value, String unit, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Text(
          '${value.toStringAsFixed(1)}$unit',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}