import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ai_nutrition_restaurant/presentation/components/charts/base/base_chart.dart';
import 'package:ai_nutrition_restaurant/presentation/components/charts/base/chart_config.dart';

/// Data model for nutrition pie chart
class NutritionData {
  final String name;
  final double value;
  final Color? color;
  final String? unit;
  
  const NutritionData({
    required this.name,
    required this.value,
    this.color,
    this.unit = 'g',
  });
}

/// Pie chart for displaying nutrition breakdown
class NutritionPieChart extends BaseChart {
  final List<NutritionData> data;
  final bool showPercentage;
  final double centerRadius;
  
  const NutritionPieChart({
    Key? key,
    required this.data,
    required ChartConfig config,
    String? title,
    this.showPercentage = true,
    this.centerRadius = 40,
  }) : super(
    key: key,
    config: config,
    title: title,
  );
  
  @override
  Widget buildChart(BuildContext context) {
    if (data.isEmpty) {
      return BaseChart.empty(
        message: 'No nutrition data available',
        config: config,
      );
    }
    
    final total = data.fold<double>(0, (sum, item) => sum + item.value);
    
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          enabled: config.showTooltip,
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            // Handle touch events if needed
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: centerRadius,
        sections: _buildSections(total),
      ),
      swapAnimationDuration: config.animationDuration,
      swapAnimationCurve: Curves.easeInOut,
    );
  }
  
  List<PieChartSectionData> _buildSections(double total) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final percentage = (item.value / total * 100);
      
      return PieChartSectionData(
        color: item.color ?? config.theme.palette[index % config.theme.palette.length],
        value: item.value,
        title: showPercentage ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: 80,
        titleStyle: config.theme.tooltipStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        badgeWidget: config.showTooltip ? _buildBadge(item) : null,
        badgePositionPercentageOffset: 1.3,
      );
    }).toList();
  }
  
  Widget _buildBadge(NutritionData item) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: config.theme.backgroundColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.name,
            style: config.theme.labelStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${item.value.toStringAsFixed(1)}${item.unit}',
            style: config.theme.labelStyle.copyWith(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Create default legend for nutrition data
  static Widget defaultLegend(List<NutritionData> data, ChartConfig config) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final color = item.color ?? config.theme.palette[index % config.theme.palette.length];
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              item.name,
              style: config.theme.labelStyle,
            ),
          ],
        );
      }).toList(),
    );
  }
}