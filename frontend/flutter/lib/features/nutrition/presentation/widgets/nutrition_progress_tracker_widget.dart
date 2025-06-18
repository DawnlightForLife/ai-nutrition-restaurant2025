/// 营养进度追踪组件
/// 显示当前营养摄入进度

import 'package:flutter/material.dart';
import '../../domain/entities/nutrition_ordering.dart';

class NutritionProgressTrackerWidget extends StatelessWidget {
  final Map<String, double> targetIntake;
  final Map<String, double> currentIntake;
  final List<OrderingSelection> selections;
  final NutritionBalanceAnalysis? balanceAnalysis;
  final Function(int index) onSelectionRemoved;
  final Function(int index, double amount) onAmountChanged;

  const NutritionProgressTrackerWidget({
    super.key,
    required this.targetIntake,
    required this.currentIntake,
    required this.selections,
    this.balanceAnalysis,
    required this.onSelectionRemoved,
    required this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressSummary(),
          const SizedBox(height: 16),
          _buildSelectionsList(),
          const SizedBox(height: 16),
          _buildNutritionProgress(),
        ],
      ),
    );
  }

  Widget _buildProgressSummary() {
    final progress = _calculateOverallProgress();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '营养目标达成度',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress / 100),
            const SizedBox(height: 4),
            Text('${progress.toStringAsFixed(1)}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionsList() {
    if (selections.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.restaurant_outlined, size: 48, color: Colors.grey),
                const SizedBox(height: 8),
                Text('暂无选择的食材', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('已选择的食材', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...selections.asMap().entries.map((entry) {
          final index = entry.key;
          final selection = entry.value;
          return Card(
            child: ListTile(
              title: Text(selection.ingredientName),
              subtitle: Text('${selection.amount}${selection.unit} · ${selection.cookingMethodName ?? "生食"}'),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: () => onSelectionRemoved(index),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildNutritionProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('营养素进度', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...targetIntake.entries.map((entry) {
          final nutrient = entry.key;
          final target = entry.value;
          final current = currentIntake[nutrient] ?? 0.0;
          final progress = target > 0 ? (current / target * 100).clamp(0.0, 200.0) : 0.0;
          
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(_getNutrientDisplayName(nutrient)),
                      const Spacer(),
                      Text('${current.toStringAsFixed(1)}/${target.toStringAsFixed(1)}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: (progress / 100).clamp(0.0, 1.0),
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(progress)),
                  ),
                  const SizedBox(height: 4),
                  Text('${progress.toStringAsFixed(0)}%', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  double _calculateOverallProgress() {
    if (targetIntake.isEmpty) return 0.0;
    
    double totalProgress = 0.0;
    int count = 0;
    
    for (final entry in targetIntake.entries) {
      final target = entry.value;
      final current = currentIntake[entry.key] ?? 0.0;
      if (target > 0) {
        totalProgress += (current / target * 100).clamp(0.0, 100.0);
        count++;
      }
    }
    
    return count > 0 ? totalProgress / count : 0.0;
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

  Color _getProgressColor(double progress) {
    if (progress < 50) return Colors.red;
    if (progress < 80) return Colors.orange;
    if (progress <= 120) return Colors.green;
    return Colors.red; // 过量也用红色
  }
}