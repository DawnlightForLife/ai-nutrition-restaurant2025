/**
 * 营养覆盖度图表组件
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/merchant_inventory.dart';

class NutritionCoverageChart extends StatelessWidget {
  final NutritionMenuAnalysis? nutritionAnalysis;
  final VoidCallback onGenerateAnalysis;

  const NutritionCoverageChart({
    super.key,
    this.nutritionAnalysis,
    required this.onGenerateAnalysis,
  });

  @override
  Widget build(BuildContext context) {
    if (nutritionAnalysis == null) {
      return _buildEmptyState(context);
    }

    final coverage = nutritionAnalysis!.nutritionElementCoverage;
    final chartData = _prepareChartData(coverage);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '营养元素覆盖分析',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: onGenerateAnalysis,
                  tooltip: '重新分析',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RadarChart(
                RadarChartData(
                  radarBorderData: const BorderSide(color: Colors.grey),
                  radarBackgroundColor: Colors.transparent,
                  tickBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                  gridBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                  tickCount: 5,
                  titleTextStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                  dataSets: [
                    RadarDataSet(
                      fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      borderColor: Theme.of(context).colorScheme.primary,
                      borderWidth: 2,
                      dataEntries: chartData,
                    ),
                  ],
                  getTitle: (index, angle) {
                    final titles = [
                      '蛋白质',
                      '碳水化合物',
                      '脂肪',
                      '维生素',
                      '矿物质',
                      '膳食纤维',
                    ];
                    return RadarChartTitle(
                      text: titles[index % titles.length],
                      angle: 0,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '暂无营养分析数据',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onGenerateAnalysis,
              icon: const Icon(Icons.play_arrow),
              label: const Text('生成营养分析'),
            ),
          ],
        ),
      ),
    );
  }

  List<RadarEntry> _prepareChartData(Map<String, double> coverage) {
    // 提取主要营养元素的覆盖度数据
    final mainElements = [
      'protein',
      'carbohydrate',
      'fat',
      'vitamin',
      'mineral',
      'fiber',
    ];

    return mainElements.map((element) {
      final value = coverage[element] ?? 0.0;
      return RadarEntry(value: value * 100); // 转换为百分比
    }).toList();
  }

  Widget _buildLegend(BuildContext context) {
    final missing = nutritionAnalysis!.missingNutritionElements;
    final overrepresented = nutritionAnalysis!.overrepresentedElements;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (missing.isNotEmpty) ...[
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '缺失元素: ${missing.join(', ')}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        if (overrepresented.isNotEmpty) ...[
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '过量元素: ${overrepresented.join(', ')}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ],
    );
  }
}