/**
 * 营养平衡分析面板
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/nutrition_cart.dart';

class NutritionBalancePanel extends StatelessWidget {
  final NutritionBalanceAnalysis? analysis;
  final NutritionCart? cart;
  final Map<String, double> nutritionGoals;
  final bool isAnalyzing;
  final VoidCallback onAnalyze;
  final VoidCallback onSetGoals;
  final Function(Map<String, double>) onOptimizeCart;

  const NutritionBalancePanel({
    super.key,
    this.analysis,
    this.cart,
    required this.nutritionGoals,
    required this.isAnalyzing,
    required this.onAnalyze,
    required this.onSetGoals,
    required this.onOptimizeCart,
  });

  @override
  Widget build(BuildContext context) {
    if (cart == null || cart!.items.isEmpty) {
      return _buildEmptyState(context);
    }

    if (analysis == null) {
      return _buildAnalysisPrompt(context);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 总体评分卡片
          _buildOverallScoreCard(context),
          const SizedBox(height: 16),
          
          // 宏量营养素分析
          _buildMacronutrientAnalysis(context),
          const SizedBox(height: 16),
          
          // 营养元素雷达图
          _buildNutritionRadarChart(context),
          const SizedBox(height: 16),
          
          // 营养建议
          _buildNutritionSuggestions(context),
          const SizedBox(height: 16),
          
          // 优化建议
          _buildOptimizationSuggestions(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '购物车为空',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '添加商品后即可查看营养分析',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 80,
            color: Colors.blue[300],
          ),
          const SizedBox(height: 16),
          const Text(
            '分析购物车营养成分',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '了解您的营养摄入是否均衡',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: isAnalyzing ? null : onAnalyze,
            icon: isAnalyzing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow),
            label: Text(isAnalyzing ? '分析中...' : '开始分析'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallScoreCard(BuildContext context) {
    final score = analysis!.overallScore;
    final status = analysis!.overallStatus;
    final scoreColor = _getScoreColor(score);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '营养平衡评分',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: isAnalyzing ? null : onAnalyze,
                  icon: isAnalyzing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh, size: 16),
                  label: const Text('重新分析'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${score.toStringAsFixed(1)}/10',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                      ),
                      Text(
                        _getStatusText(status),
                        style: TextStyle(
                          fontSize: 16,
                          color: scoreColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: score / 10,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                  ),
                ),
              ],
            ),
            if (analysis!.warnings.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.orange[700], size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          '营养提醒',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...analysis!.warnings.map((warning) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• $warning'),
                    )),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMacronutrientAnalysis(BuildContext context) {
    final macro = analysis!.macroBalance;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '宏量营养素分析',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMacroBar('蛋白质', macro.proteinCurrent, macro.proteinTarget, Colors.blue),
            const SizedBox(height: 12),
            _buildMacroBar('碳水化合物', macro.carbCurrent, macro.carbTarget, Colors.orange),
            const SizedBox(height: 12),
            _buildMacroBar('脂肪', macro.fatCurrent, macro.fatTarget, Colors.purple),
            if (macro.adjustmentSuggestions.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          '调整建议',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...macro.adjustmentSuggestions.map((suggestion) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• $suggestion'),
                    )),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMacroBar(String name, double current, double target, Color color) {
    final percentage = target > 0 ? (current / target).clamp(0.0, 1.5) : 0.0;
    final isExcessive = percentage > 1.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(
              '${current.toStringAsFixed(1)}g / ${target.toStringAsFixed(1)}g',
              style: TextStyle(
                color: isExcessive ? Colors.red : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage.clamp(0.0, 1.0),
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            isExcessive ? Colors.red : color,
          ),
        ),
        if (isExcessive)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '超出目标 ${((percentage - 1.0) * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 10,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNutritionRadarChart(BuildContext context) {
    final elementData = analysis!.elementAnalysis;
    if (elementData.isEmpty) return const SizedBox.shrink();

    // 取前6个最重要的营养元素
    final importantElements = elementData.entries.take(6).toList();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '营养元素达成度',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: RadarChart(
                RadarChartData(
                  radarBorderData: const BorderSide(color: Colors.grey),
                  radarBackgroundColor: Colors.transparent,
                  tickBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                  gridBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                  tickCount: 5,
                  titleTextStyle: const TextStyle(fontSize: 12),
                  dataSets: [
                    RadarDataSet(
                      fillColor: Colors.blue.withOpacity(0.2),
                      borderColor: Colors.blue,
                      borderWidth: 2,
                      dataEntries: importantElements.map((entry) {
                        return RadarEntry(
                          value: (entry.value.completionRate * 100).clamp(0.0, 100.0),
                        );
                      }).toList(),
                    ),
                  ],
                  getTitle: (index, angle) {
                    if (index < importantElements.length) {
                      return RadarChartTitle(
                        text: importantElements[index].value.elementName,
                        angle: 0,
                      );
                    }
                    return const RadarChartTitle(text: '');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionSuggestions(BuildContext context) {
    if (analysis!.improvements.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '营养改善建议',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...analysis!.improvements.map((improvement) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(improvement)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildOptimizationSuggestions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '智能优化',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '让AI帮您优化购物车，达到更好的营养平衡',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildOptimizationChip('营养均衡', {'balance': 1.0}),
                _buildOptimizationChip('减少热量', {'calories': -0.2}),
                _buildOptimizationChip('增加蛋白质', {'protein': 0.3}),
                _buildOptimizationChip('控制脂肪', {'fat': -0.1}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptimizationChip(String label, Map<String, double> priorities) {
    return ActionChip(
      label: Text(label),
      onPressed: () => onOptimizeCart(priorities),
      avatar: const Icon(Icons.auto_fix_high, size: 16),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 8.0) return Colors.green;
    if (score >= 6.0) return Colors.orange;
    return Colors.red;
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'excellent':
        return '营养极佳';
      case 'good':
        return '营养良好';
      case 'fair':
        return '尚可改善';
      case 'poor':
        return '需要调整';
      default:
        return '一般';
    }
  }
}