import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ai_nutrition_restaurant/presentation/components/charts/base/base_chart.dart';
import 'package:ai_nutrition_restaurant/presentation/components/charts/base/chart_config.dart';

/// Data point for nutrition trend
class NutritionTrendPoint {
  final DateTime date;
  final double value;
  final String? label;
  
  const NutritionTrendPoint({
    required this.date,
    required this.value,
    this.label,
  });
}

/// Trend data for a specific nutrient
class NutrientTrendData {
  final String name;
  final List<NutritionTrendPoint> points;
  final Color? color;
  final double? goalValue;
  
  const NutrientTrendData({
    required this.name,
    required this.points,
    this.color,
    this.goalValue,
  });
}

/// Line chart for displaying nutrition trends over time
class NutritionTrendChart extends BaseChart {
  final List<NutrientTrendData> nutrients;
  final DateTimeRange? dateRange;
  final bool showGoalLines;
  final bool showDataPoints;
  
  const NutritionTrendChart({
    Key? key,
    required this.nutrients,
    required ChartConfig config,
    String? title,
    this.dateRange,
    this.showGoalLines = true,
    this.showDataPoints = true,
  }) : super(
    key: key,
    config: config,
    title: title,
  );
  
  @override
  Widget buildChart(BuildContext context) {
    if (nutrients.isEmpty || nutrients.every((n) => n.points.isEmpty)) {
      return BaseChart.empty(
        message: 'No trend data available',
        config: config,
      );
    }
    
    final allDates = nutrients
        .expand((n) => n.points)
        .map((p) => p.date)
        .toList();
    
    final minDate = dateRange?.start ?? 
        allDates.reduce((a, b) => a.isBefore(b) ? a : b);
    final maxDate = dateRange?.end ?? 
        allDates.reduce((a, b) => a.isAfter(b) ? a : b);
    
    final allValues = nutrients
        .expand((n) => n.points)
        .map((p) => p.value)
        .toList();
    
    final maxValue = allValues.isEmpty ? 100.0 : 
        allValues.reduce((a, b) => a > b ? a : b) * 1.2;
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: config.showGrid,
          drawVerticalLine: true,
          horizontalInterval: maxValue / 5,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: config.theme.gridColor,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: config.theme.gridColor,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: _buildTitlesData(),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: config.theme.gridColor,
            width: 1,
          ),
        ),
        minX: minDate.millisecondsSinceEpoch.toDouble(),
        maxX: maxDate.millisecondsSinceEpoch.toDouble(),
        minY: 0,
        maxY: maxValue,
        lineBarsData: _buildLineBars(),
        extraLinesData: _buildExtraLines(),
        lineTouchData: LineTouchData(
          enabled: config.showTooltip,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.black87,
            getTooltipItems: _getTooltipItems,
          ),
        ),
      ),
    );
  }
  
  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: null,
          getTitlesWidget: (value, meta) {
            final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: Text(
                '${date.month}/${date.day}',
                style: config.theme.labelStyle,
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: null,
          reservedSize: 42,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toStringAsFixed(0),
              style: config.theme.labelStyle,
              textAlign: TextAlign.right,
            );
          },
        ),
      ),
    );
  }
  
  List<LineChartBarData> _buildLineBars() {
    return nutrients.asMap().entries.map((entry) {
      final index = entry.key;
      final nutrient = entry.value;
      final color = nutrient.color ?? 
          config.theme.palette[index % config.theme.palette.length];
      
      return LineChartBarData(
        spots: nutrient.points.map((point) {
          return FlSpot(
            point.date.millisecondsSinceEpoch.toDouble(),
            point.value,
          );
        }).toList(),
        isCurved: true,
        color: color,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: showDataPoints,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 4,
              color: Colors.white,
              strokeWidth: 2,
              strokeColor: color,
            );
          },
        ),
        belowBarData: BarAreaData(
          show: true,
          color: color.withOpacity(0.1),
        ),
      );
    }).toList();
  }
  
  ExtraLinesData _buildExtraLines() {
    if (!showGoalLines) {
      return ExtraLinesData(horizontalLines: []);
    }
    
    final goalLines = nutrients
        .where((n) => n.goalValue != null)
        .map((nutrient) {
      final index = nutrients.indexOf(nutrient);
      final color = nutrient.color ?? 
          config.theme.palette[index % config.theme.palette.length];
      
      return HorizontalLine(
        y: nutrient.goalValue!,
        color: color.withOpacity(0.5),
        strokeWidth: 2,
        dashArray: [5, 5],
        label: HorizontalLineLabel(
          show: true,
          alignment: Alignment.topRight,
          style: config.theme.labelStyle.copyWith(
            color: color,
            fontSize: 10,
          ),
          labelResolver: (line) => '${nutrient.name} Goal',
        ),
      );
    }).toList();
    
    return ExtraLinesData(horizontalLines: goalLines);
  }
  
  List<LineTooltipItem?> _getTooltipItems(List<LineBarSpot> spots) {
    return spots.map((spot) {
      final nutrient = nutrients[spot.barIndex];
      final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
      
      return LineTooltipItem(
        '${nutrient.name}\n${spot.y.toStringAsFixed(1)}\n${date.month}/${date.day}',
        config.theme.tooltipStyle,
      );
    }).toList();
  }
}