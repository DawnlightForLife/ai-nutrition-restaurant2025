/**
 * 营养元素分类组件
 * 显示特定分类下的营养元素，支持目标调整
 */

import 'package:flutter/material.dart';
import '../../domain/entities/nutrition_ordering.dart';

class NutritionElementCategoryWidget extends StatelessWidget {
  final String category;
  final List<NutritionElement> elements;
  final Map<String, double> targetIntake;
  final Map<String, double> currentIntake;
  final Function(String element, double target) onTargetChanged;

  const NutritionElementCategoryWidget({
    super.key,
    required this.category,
    required this.elements,
    required this.targetIntake,
    required this.currentIntake,
    required this.onTargetChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: elements.map((element) => 
        _buildElementCard(context, element)
      ).toList(),
    );
  }

  Widget _buildElementCard(BuildContext context, NutritionElement element) {
    final target = targetIntake[element.name] ?? 0.0;
    final current = currentIntake[element.name] ?? 0.0;
    final percentage = target > 0 ? (current / target * 100).clamp(0.0, 200.0) : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 元素标题和重要性
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        element.chineseName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        element.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildImportanceBadge(element.importance),
              ],
            ),

            if (element.healthBenefits.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildHealthBenefits(element.healthBenefits),
            ],

            const SizedBox(height: 16),

            // 目标调整滑块
            _buildTargetSlider(element, target),

            const SizedBox(height: 12),

            // 当前摄入状态
            _buildIntakeStatus(element, target, current, percentage),

            if (element.functions.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildFunctionTags(element.functions),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImportanceBadge(String importance) {
    final config = _getImportanceConfig(importance);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: config['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config['color'].withOpacity(0.3)),
      ),
      child: Text(
        config['label'],
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: config['color'],
        ),
      ),
    );
  }

  Widget _buildHealthBenefits(List<String> benefits) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.health_and_safety_outlined,
                size: 14,
                color: Colors.blue.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                '健康益处',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            benefits.take(2).join('、'),
            style: TextStyle(
              fontSize: 11,
              color: Colors.blue.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetSlider(NutritionElement element, double target) {
    final recommendedIntake = _getRecommendedIntake(element);
    final minValue = recommendedIntake['min'] ?? 0.0;
    final maxValue = recommendedIntake['max'] ?? (recommendedIntake['rda'] ?? 100.0) * 2;
    final rdaValue = recommendedIntake['rda'] ?? 50.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '目标摄入量',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const Spacer(),
            Text(
              '${target.toStringAsFixed(1)} ${element.unit}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: target.clamp(minValue, maxValue),
          min: minValue,
          max: maxValue,
          divisions: 100,
          onChanged: (value) {
            onTargetChanged(element.name, value);
          },
        ),
        Row(
          children: [
            Text(
              '${minValue.toStringAsFixed(0)} ${element.unit}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Text(
                'RDA: ${rdaValue.toStringAsFixed(0)}${element.unit}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.orange.shade700,
                ),
              ),
            ),
            const Spacer(),
            Text(
              '${maxValue.toStringAsFixed(0)} ${element.unit}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIntakeStatus(NutritionElement element, double target, double current, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '当前摄入',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const Spacer(),
            Text(
              '${current.toStringAsFixed(1)} ${element.unit}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _getIntakeStatusColor(percentage),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(${percentage.toStringAsFixed(0)}%)',
              style: TextStyle(
                fontSize: 12,
                color: _getIntakeStatusColor(percentage),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: (percentage / 100).clamp(0.0, 1.0),
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getIntakeStatusColor(percentage),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _getIntakeStatusText(percentage),
          style: TextStyle(
            fontSize: 10,
            color: _getIntakeStatusColor(percentage),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFunctionTags(List<String> functions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '主要功能',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: functions.take(4).map((function) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Text(
              _getFunctionDisplayName(function),
              style: TextStyle(
                fontSize: 10,
                color: Colors.green.shade700,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Map<String, dynamic> _getImportanceConfig(String importance) {
    switch (importance) {
      case 'essential':
        return {'color': Colors.red, 'label': '必需'};
      case 'important':
        return {'color': Colors.orange, 'label': '重要'};
      case 'beneficial':
        return {'color': Colors.green, 'label': '有益'};
      case 'optional':
        return {'color': Colors.grey, 'label': '可选'};
      default:
        return {'color': Colors.grey, 'label': '未知'};
    }
  }

  Map<String, double> _getRecommendedIntake(NutritionElement element) {
    // 简化的推荐摄入量获取
    // 实际应用中应该从element.recommendedIntake中根据用户性别年龄获取
    const defaultIntakes = {
      'protein': {'min': 50.0, 'rda': 75.0, 'max': 150.0},
      'carbohydrates': {'min': 100.0, 'rda': 200.0, 'max': 400.0},
      'fat': {'min': 20.0, 'rda': 50.0, 'max': 100.0},
      'fiber': {'min': 15.0, 'rda': 25.0, 'max': 50.0},
      'vitamin_c': {'min': 50.0, 'rda': 90.0, 'max': 2000.0},
      'calcium': {'min': 500.0, 'rda': 1000.0, 'max': 2500.0},
      'iron': {'min': 5.0, 'rda': 18.0, 'max': 45.0},
    };

    return Map<String, double>.from(
      defaultIntakes[element.name] ?? {'min': 0.0, 'rda': 50.0, 'max': 100.0}
    );
  }

  Color _getIntakeStatusColor(double percentage) {
    if (percentage < 50) return Colors.red;
    if (percentage < 80) return Colors.orange;
    if (percentage <= 120) return Colors.green;
    return Colors.red; // 过量
  }

  String _getIntakeStatusText(double percentage) {
    if (percentage < 50) return '严重不足';
    if (percentage < 80) return '不足';
    if (percentage <= 120) return '充足';
    return '过量';
  }

  String _getFunctionDisplayName(String function) {
    const displayNames = {
      'energy_metabolism': '能量代谢',
      'immune_function': '免疫功能',
      'bone_health': '骨骼健康',
      'cardiovascular': '心血管健康',
      'cognitive_function': '认知功能',
      'muscle_function': '肌肉功能',
      'skin_health': '皮肤健康',
      'digestive_health': '消化健康',
      'antioxidant_protection': '抗氧化',
      'hormone_regulation': '激素调节',
      'blood_sugar_control': '血糖控制',
      'weight_management': '体重管理',
    };
    return displayNames[function] ?? function;
  }
}