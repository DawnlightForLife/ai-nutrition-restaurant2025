/**
 * 食材分类网格组件
 * 以网格形式展示食材列表
 */

import 'package:flutter/material.dart';
import '../../domain/entities/nutrition_ordering.dart';

class IngredientCategoryGridWidget extends StatelessWidget {
  final List<IngredientNutrition> ingredients;
  final Function(IngredientNutrition) onIngredientTap;
  final String selectedCategory;

  const IngredientCategoryGridWidget({
    super.key,
    required this.ingredients,
    required this.onIngredientTap,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          return _buildIngredientCard(ingredients[index]);
        },
      ),
    );
  }

  Widget _buildIngredientCard(IngredientNutrition ingredient) {
    return GestureDetector(
      onTap: () => onIngredientTap(ingredient),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 食材图片占位符
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _getCategoryColor(ingredient.category).withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getCategoryIcon(ingredient.category),
                      size: 40,
                      color: _getCategoryColor(ingredient.category),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(ingredient.category).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getCategoryDisplayName(ingredient.category),
                        style: TextStyle(
                          fontSize: 10,
                          color: _getCategoryColor(ingredient.category),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 食材信息
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ingredient.chineseName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ingredient.name,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    _buildNutritionDensityBadge(ingredient.nutritionDensity),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionDensityBadge(Map<String, String>? nutritionDensity) {
    final overall = nutritionDensity?['overall'] ?? 'moderate';
    final config = _getNutritionDensityConfig(overall);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: config['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: config['color'].withOpacity(0.3)),
      ),
      child: Text(
        config['label'],
        style: TextStyle(
          fontSize: 9,
          color: config['color'],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    const colors = {
      'meat': Colors.red,
      'poultry': Colors.orange,
      'seafood': Colors.blue,
      'eggs': Colors.yellow,
      'dairy': Colors.lightBlue,
      'legumes': Colors.brown,
      'nuts_seeds': Colors.amber,
      'grains': Colors.deepOrange,
      'tubers': Colors.purple,
      'fruits': Colors.pink,
      'oils': Colors.lime,
      'vegetables': Colors.green,
      'herbs_spices': Colors.teal,
      'mushrooms': Colors.grey,
      'beverages': Colors.cyan,
      'condiments': Colors.indigo,
      'supplements': Colors.deepPurple,
    };
    return colors[category] ?? Colors.grey;
  }

  IconData _getCategoryIcon(String category) {
    const icons = {
      'meat': Icons.lunch_dining,
      'poultry': Icons.egg_alt,
      'seafood': Icons.set_meal,
      'eggs': Icons.egg,
      'dairy': Icons.water_drop,
      'legumes': Icons.circle,
      'nuts_seeds': Icons.grain,
      'grains': Icons.grass,
      'tubers': Icons.circle_outlined,
      'fruits': Icons.apple,
      'oils': Icons.opacity,
      'vegetables': Icons.eco,
      'herbs_spices': Icons.local_florist,
      'mushrooms': Icons.park,
      'beverages': Icons.local_drink,
      'condiments': Icons.colorize,
      'supplements': Icons.medical_services,
    };
    return icons[category] ?? Icons.restaurant;
  }

  String _getCategoryDisplayName(String category) {
    const names = {
      'meat': '肉类',
      'poultry': '禽类',
      'seafood': '海鲜',
      'eggs': '蛋类',
      'dairy': '乳制品',
      'legumes': '豆类',
      'nuts_seeds': '坚果',
      'grains': '谷物',
      'tubers': '薯类',
      'fruits': '水果',
      'oils': '油脂',
      'vegetables': '蔬菜',
      'herbs_spices': '香料',
      'mushrooms': '菌类',
      'beverages': '饮品',
      'condiments': '调料',
      'supplements': '补充剂',
    };
    return names[category] ?? category;
  }

  Map<String, dynamic> _getNutritionDensityConfig(String density) {
    switch (density) {
      case 'very_high':
        return {'color': Colors.green, 'label': '极高'};
      case 'high':
        return {'color': Colors.lightGreen, 'label': '高'};
      case 'moderate':
        return {'color': Colors.orange, 'label': '中等'};
      case 'low':
        return {'color': Colors.red, 'label': '低'};
      case 'very_low':
        return {'color': Colors.grey, 'label': '极低'};
      default:
        return {'color': Colors.grey, 'label': '未知'};
    }
  }
}