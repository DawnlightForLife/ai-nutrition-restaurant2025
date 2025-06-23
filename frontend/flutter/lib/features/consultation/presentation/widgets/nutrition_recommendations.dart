import 'package:flutter/material.dart';

class NutritionRecommendations extends StatelessWidget {
  final Map<String, dynamic> recommendationsData;

  const NutritionRecommendations({
    Key? key,
    required this.recommendationsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI智能推荐',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 个性化营养目标
        _buildNutritionGoals(),
        
        const SizedBox(height: 16),
        
        // 推荐食物
        _buildRecommendedFoods(),
        
        const SizedBox(height: 16),
        
        // 应避免的食物
        _buildFoodsToAvoid(),
        
        const SizedBox(height: 16),
        
        // 每日营养计划
        _buildDailyNutritionPlan(),
        
        const SizedBox(height: 16),
        
        // 生活方式建议
        _buildLifestyleTips(),
      ],
    );
  }

  Widget _buildNutritionGoals() {
    final goals = recommendationsData['nutritionGoals'] as Map<String, dynamic>? ?? {};
    final dailyCalories = goals['dailyCalories'] ?? 0;
    final protein = goals['protein'] ?? 0;
    final carbs = goals['carbohydrates'] ?? 0;
    final fat = goals['fat'] ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flag, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  '个性化营养目标',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 每日卡路里目标
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '每日卡路里目标',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$dailyCalories kcal',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // 三大营养素分配
            Row(
              children: [
                Expanded(
                  child: _buildMacroCard('蛋白质', '${protein}g', Colors.red[300]!),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMacroCard('碳水', '${carbs}g', Colors.blue[300]!),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMacroCard('脂肪', '${fat}g', Colors.yellow[600]!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroCard(String name, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedFoods() {
    final recommendedFoods = recommendationsData['recommendedFoods'] as List<dynamic>? ?? [];
    
    if (recommendedFoods.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.thumb_up, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  '推荐食物',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            ...recommendedFoods.map((food) {
              final foodMap = food as Map<String, dynamic>;
              final name = foodMap['name'] ?? '';
              final reason = foodMap['reason'] ?? '';
              final benefits = foodMap['benefits'] as List<dynamic>? ?? [];
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (reason.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        reason,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    if (benefits.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: benefits.map((benefit) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              benefit.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green[700],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodsToAvoid() {
    final foodsToAvoid = recommendationsData['foodsToAvoid'] as List<dynamic>? ?? [];
    
    if (foodsToAvoid.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning, color: Colors.red),
                const SizedBox(width: 8),
                const Text(
                  '应避免的食物',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            ...foodsToAvoid.map((food) {
              final foodMap = food as Map<String, dynamic>;
              final name = foodMap['name'] ?? '';
              final reason = foodMap['reason'] ?? '';
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.block, color: Colors.red[400], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (reason.isNotEmpty)
                            Text(
                              reason,
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
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyNutritionPlan() {
    final mealPlan = recommendationsData['dailyMealPlan'] as Map<String, dynamic>? ?? {};
    
    if (mealPlan.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.schedule, color: Colors.purple),
                const SizedBox(width: 8),
                const Text(
                  '每日营养计划',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            ...['breakfast', 'lunch', 'dinner', 'snacks'].where((meal) => mealPlan.containsKey(meal)).map((meal) {
              final mealData = mealPlan[meal] as Map<String, dynamic>;
              final mealName = _getMealName(meal);
              final foods = mealData['foods'] as List<dynamic>? ?? [];
              final calories = mealData['calories'] ?? 0;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          mealName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$calories kcal',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (foods.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ...foods.map((food) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  food.toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLifestyleTips() {
    final tips = recommendationsData['lifestyleTips'] as List<dynamic>? ?? [];
    
    if (tips.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tips_and_updates, color: Colors.amber),
                const SizedBox(width: 8),
                const Text(
                  '生活方式建议',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            ...tips.map((tip) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb, color: Colors.amber[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _getMealName(String meal) {
    switch (meal) {
      case 'breakfast':
        return '早餐';
      case 'lunch':
        return '午餐';
      case 'dinner':
        return '晚餐';
      case 'snacks':
        return '加餐';
      default:
        return meal;
    }
  }
}