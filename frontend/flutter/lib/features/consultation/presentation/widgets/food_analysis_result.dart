import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FoodAnalysisResult extends StatelessWidget {
  final Map<String, dynamic> analysisData;

  const FoodAnalysisResult({
    Key? key,
    required this.analysisData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI分析结果',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 食物识别结果
        _buildFoodIdentification(),
        
        const SizedBox(height: 16),
        
        // 营养成分分析
        _buildNutritionAnalysis(),
        
        const SizedBox(height: 16),
        
        // 健康评分
        _buildHealthScore(),
        
        const SizedBox(height: 16),
        
        // 建议和提示
        _buildRecommendations(),
      ],
    );
  }

  Widget _buildFoodIdentification() {
    final foodName = analysisData['foodName'] ?? '未识别的食物';
    final confidence = (analysisData['confidence'] ?? 0.0) * 100;
    final ingredients = analysisData['ingredients'] as List<dynamic>? ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.restaurant, color: Colors.orange),
                const SizedBox(width: 8),
                const Text(
                  '食物识别',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: Text(
                    foodName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getConfidenceColor(confidence),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${confidence.toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            if (ingredients.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                '主要食材：',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: ingredients.map((ingredient) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Text(
                      ingredient.toString(),
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionAnalysis() {
    final nutrition = analysisData['nutrition'] as Map<String, dynamic>? ?? {};
    final calories = nutrition['calories']?.toDouble() ?? 0.0;
    final protein = nutrition['protein']?.toDouble() ?? 0.0;
    final carbs = nutrition['carbohydrates']?.toDouble() ?? 0.0;
    final fat = nutrition['fat']?.toDouble() ?? 0.0;
    final fiber = nutrition['fiber']?.toDouble() ?? 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  '营养成分分析',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 卡路里显示
            Center(
              child: Column(
                children: [
                  Text(
                    '${calories.toInt()}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const Text(
                    '千卡 (kcal)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 营养成分饼图
            SizedBox(
              height: 150,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: protein * 4, // 蛋白质 1g = 4kcal
                      color: Colors.red[300],
                      title: '蛋白质\n${protein.toInt()}g',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: carbs * 4, // 碳水化合物 1g = 4kcal
                      color: Colors.blue[300],
                      title: '碳水\n${carbs.toInt()}g',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: fat * 9, // 脂肪 1g = 9kcal
                      color: Colors.yellow[600],
                      title: '脂肪\n${fat.toInt()}g',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  centerSpaceRadius: 0,
                  sectionsSpace: 2,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 其他营养成分
            if (fiber > 0)
              _buildNutrientRow('膳食纤维', '${fiber.toInt()}g', Icons.grass),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthScore() {
    final healthScore = (analysisData['healthScore'] ?? 0.0) * 100;
    final scoreColor = _getScoreColor(healthScore);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.health_and_safety, color: Colors.purple),
                const SizedBox(width: 8),
                const Text(
                  '健康评分',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: healthScore / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${healthScore.toInt()}/100',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Text(
              _getScoreDescription(healthScore),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    final recommendations = analysisData['recommendations'] as List<dynamic>? ?? [];
    
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.amber),
                const SizedBox(width: 8),
                const Text(
                  '营养建议',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            ...recommendations.map((rec) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 6, right: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber[600],
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        rec.toString(),
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

  Widget _buildNutrientRow(String name, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(name),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 80) return Colors.green;
    if (confidence >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getScoreDescription(double score) {
    if (score >= 80) return '营养均衡，很健康的食物选择！';
    if (score >= 60) return '营养尚可，可以适量食用';
    return '营养价值较低，建议搭配其他食物';
  }
}