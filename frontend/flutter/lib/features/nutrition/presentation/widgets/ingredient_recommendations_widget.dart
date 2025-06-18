/// 食材推荐组件
/// 显示AI推荐的食材

import 'package:flutter/material.dart';
import '../../domain/entities/nutrition_ordering.dart';

class IngredientRecommendationsWidget extends StatelessWidget {
  final List<IngredientRecommendation> recommendations;
  final Function(IngredientNutrition) onIngredientSelected;

  const IngredientRecommendationsWidget({
    super.key,
    required this.recommendations,
    required this.onIngredientSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          ...recommendations.map((recommendation) => 
            _buildRecommendationCard(recommendation)
          ).toList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.psychology, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI智能推荐',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '基于您的营养缺口，为您推荐最适合的食材',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(IngredientRecommendation recommendation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Text(
                    '缺少 ${_getNutrientDisplayName(recommendation.nutrient)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${recommendation.gap.toStringAsFixed(1)} ${recommendation.unit}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '推荐食材',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            ...recommendation.recommendedIngredients.map((ingredient) =>
              _buildIngredientItem(ingredient)
            ).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientItem(RecommendedIngredient ingredient) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.grey.shade50,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(ingredient.category),
          child: Icon(
            _getCategoryIcon(ingredient.category),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(ingredient.name),
        subtitle: Text(
          '${ingredient.category} · 营养密度: ${ingredient.nutritionDensity}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${ingredient.nutrientContent.toStringAsFixed(1)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '建议${ingredient.estimatedServing.toStringAsFixed(0)}g',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
          ],
        ),
        onTap: () {
          // 转换为IngredientNutrition对象
          final ingredientNutrition = IngredientNutrition(
            id: ingredient.id,
            name: ingredient.name,
            chineseName: ingredient.name,
            category: ingredient.category,
            servingSize: ingredient.servingSize,
          );
          onIngredientSelected(ingredientNutrition);
        },
      ),
    );
  }

  String _getNutrientDisplayName(String nutrient) {
    const displayNames = {
      'protein': '蛋白质',
      'carbohydrates': '碳水化合物',
      'fat': '脂肪',
      'fiber': '膳食纤维',
      'vitamin_c': '维生素C',
      'vitamin_d': '维生素D',
      'calcium': '钙',
      'iron': '铁',
      'potassium': '钾',
      'sodium': '钠',
    };
    return displayNames[nutrient] ?? nutrient;
  }

  Color _getCategoryColor(String category) {
    const colors = {
      'meat': Colors.red,
      'vegetables': Colors.green,
      'fruits': Colors.orange,
      'dairy': Colors.blue,
      'grains': Colors.brown,
    };
    return colors[category] ?? Colors.grey;
  }

  IconData _getCategoryIcon(String category) {
    const icons = {
      'meat': Icons.lunch_dining,
      'vegetables': Icons.eco,
      'fruits': Icons.apple,
      'dairy': Icons.water_drop,
      'grains': Icons.grain,
    };
    return icons[category] ?? Icons.restaurant;
  }
}