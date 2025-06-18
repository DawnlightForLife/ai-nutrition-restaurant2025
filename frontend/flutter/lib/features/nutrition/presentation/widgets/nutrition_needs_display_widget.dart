/**
 * 营养需求显示组件
 * 展示分析出的营养需求详情
 */

import 'package:flutter/material.dart';
import '../../domain/entities/nutrition_ordering.dart';

class NutritionNeedsDisplayWidget extends StatelessWidget {
  final NutritionNeedsAnalysis analysis;
  final bool showActions;

  const NutritionNeedsDisplayWidget({
    super.key,
    required this.analysis,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnalysisHeader(),
        const SizedBox(height: 16),
        _buildMetabolismCards(),
        const SizedBox(height: 16),
        _buildNutritionDetails(),
        if (showActions) ...[
          const SizedBox(height: 20),
          _buildActionSection(),
        ],
      ],
    );
  }

  Widget _buildAnalysisHeader() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Colors.blue.shade600,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  '个性化营养分析报告',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '分析时间: ${_formatDateTime(analysis.calculatedAt)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            if (analysis.validUntil != null) ...[
              const SizedBox(height: 4),
              Text(
                '有效期至: ${_formatDateTime(analysis.validUntil)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetabolismCards() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: '基础代谢率',
            subtitle: 'BMR',
            value: analysis.bmr.toStringAsFixed(0),
            unit: 'kcal/天',
            icon: Icons.local_fire_department,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: '总消耗量',
            subtitle: 'TDEE',
            value: analysis.tdee.toStringAsFixed(0),
            unit: 'kcal/天',
            icon: Icons.directions_run,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String subtitle,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionDetails() {
    final dailyNeeds = analysis.dailyNeeds;
    if (dailyNeeds == null || dailyNeeds.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text('暂无详细营养需求数据'),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '每日营养需求分解',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            _buildNutritionList(dailyNeeds),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionList(Map<String, dynamic> dailyNeeds) {
    final nutrients = [
      {'key': 'calories', 'name': '热量', 'unit': 'kcal', 'color': Colors.red},
      {'key': 'protein', 'name': '蛋白质', 'unit': 'g', 'color': Colors.orange},
      {'key': 'carbohydrates', 'name': '碳水化合物', 'unit': 'g', 'color': Colors.green},
      {'key': 'fat', 'name': '脂肪', 'unit': 'g', 'color': Colors.blue},
      {'key': 'fiber', 'name': '膳食纤维', 'unit': 'g', 'color': Colors.brown},
    ];

    return Column(
      children: nutrients.map((nutrient) {
        final value = dailyNeeds[nutrient['key']] as num? ?? 0;
        return _buildNutrientRow(
          name: nutrient['name'] as String,
          value: value.toDouble(),
          unit: nutrient['unit'] as String,
          color: nutrient['color'] as Color,
        );
      }).toList(),
    );
  }

  Widget _buildNutrientRow({
    required String name,
    required double value,
    required String unit,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            '${value.toStringAsFixed(1)} $unit',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '下一步行动',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: 开始营养定制
                    },
                    icon: const Icon(Icons.restaurant_menu),
                    label: const Text('开始营养定制'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: 导出报告
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('导出报告'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade700,
                      side: BorderSide(color: Colors.blue.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '未知';
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}