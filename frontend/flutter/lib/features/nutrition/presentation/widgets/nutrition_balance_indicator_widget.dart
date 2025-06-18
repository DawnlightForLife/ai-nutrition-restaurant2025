/**
 * 营养平衡指示器组件
 * 显示当前营养摄入的整体平衡状态
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/nutrition_ordering.dart';

class NutritionBalanceIndicatorWidget extends StatelessWidget {
  final NutritionBalanceAnalysis? analysis;
  final NutritionScore? score;

  const NutritionBalanceIndicatorWidget({
    super.key,
    this.analysis,
    this.score,
  });

  @override
  Widget build(BuildContext context) {
    if (analysis == null && score == null) {
      return _buildEmptyState();
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题和总体评分
            _buildHeader(),
            
            const SizedBox(height: 16),
            
            // 平衡指示器圆环图
            Row(
              children: [
                // 圆环图
                SizedBox(
                  width: 120,
                  height: 120,
                  child: _buildBalanceChart(),
                ),
                
                const SizedBox(width: 24),
                
                // 详细指标
                Expanded(
                  child: _buildMetrics(),
                ),
              ],
            ),
            
            if (analysis != null && analysis!.gaps.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildGapsIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              Icons.track_changes_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              '营养平衡分析',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '选择营养目标后将显示平衡状态',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final overallScore = score?.overall ?? analysis?.overallMatch ?? 0.0;
    
    return Row(
      children: [
        Icon(
          Icons.track_changes,
          color: Colors.green.shade600,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          '营养平衡状态',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade800,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getScoreColor(overallScore).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getScoreColor(overallScore).withOpacity(0.3),
            ),
          ),
          child: Text(
            '${overallScore.toStringAsFixed(1)}分',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _getScoreColor(overallScore),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceChart() {
    final overallScore = score?.overall ?? analysis?.overallMatch ?? 0.0;
    final adequacy = score?.adequacy ?? 0.0;
    final balance = score?.balance ?? 0.0;
    final moderation = score?.moderation ?? 0.0;

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 30,
        sections: [
          PieChartSectionData(
            value: adequacy,
            color: Colors.blue.shade400,
            title: '充足性',
            radius: 25,
            titleStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: balance,
            color: Colors.green.shade400,
            title: '平衡性',
            radius: 25,
            titleStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: moderation,
            color: Colors.orange.shade400,
            title: '适度性',
            radius: 25,
            titleStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: 100 - adequacy - balance - moderation,
            color: Colors.grey.shade300,
            title: '',
            radius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics() {
    final adequacy = score?.adequacy ?? 0.0;
    final balance = score?.balance ?? 0.0;
    final moderation = score?.moderation ?? 0.0;
    final variety = score?.variety ?? 0.0;

    return Column(
      children: [
        _buildMetricRow('营养充足性', adequacy, Colors.blue.shade400),
        _buildMetricRow('营养平衡性', balance, Colors.green.shade400),
        _buildMetricRow('摄入适度性', moderation, Colors.orange.shade400),
        _buildMetricRow('营养多样性', variety, Colors.purple.shade400),
      ],
    );
  }

  Widget _buildMetricRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Text(
            '${value.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGapsIndicator() {
    final gaps = analysis!.gaps;
    final majorGaps = gaps.where((gap) => gap.gapAmount > 0).take(3).toList();

    if (majorGaps.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '营养摄入均衡，无明显缺口',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_outlined,
                color: Colors.orange.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '主要营养缺口',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...majorGaps.map((gap) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Text(
                  '• ${_getElementDisplayName(gap.element)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade700,
                  ),
                ),
                const Spacer(),
                Text(
                  '缺少 ${gap.gapAmount.toStringAsFixed(1)} ${gap.unit}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getElementDisplayName(String element) {
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
    return displayNames[element] ?? element;
  }
}