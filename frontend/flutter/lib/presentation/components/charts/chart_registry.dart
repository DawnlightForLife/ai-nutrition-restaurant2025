import 'package:flutter/material.dart';

/// 图表组件目录（禁用了Widgetbook）
/// 
/// 注意: Widgetbook相关代码已暂时禁用，以解决构建问题
/// 完成路由生成后可以重新启用

/// 图表信息
class ChartInfo {
  final String name;
  final String description;
  final Widget Function(BuildContext) widgetBuilder;
  final ChartCategory category;
  final List<String> tags;
  
  const ChartInfo({
    required this.name,
    required this.description,
    required this.widgetBuilder,
    required this.category,
    this.tags = const [],
  });
}

/// 图表类别
enum ChartCategory {
  distribution,
  trend,
  comparison,
  progress,
  heatmap,
  gauge,
  custom,
}

/// 营养数据
class NutritionData {
  final String name;
  final double value;
  final Color? color;
  
  const NutritionData({
    required this.name,
    required this.value,
    this.color,
  });
}

/// 营养趋势点
class NutritionTrendPoint {
  final DateTime date;
  final double value;
  
  const NutritionTrendPoint({
    required this.date,
    required this.value,
  });
}

/// 营养趋势数据
class NutrientTrendData {
  final String name;
  final double goalValue;
  final Color? color;
  final List<NutritionTrendPoint> points;
  
  const NutrientTrendData({
    required this.name,
    required this.goalValue,
    this.color,
    required this.points,
  });
}

/// 图表主题
class ChartTheme {
  final Color textColor;
  final Color gridColor;
  final Color backgroundColor;
  final List<Color> defaultColors;
  
  const ChartTheme({
    required this.textColor,
    required this.gridColor,
    required this.backgroundColor,
    required this.defaultColors,
  });
  
  static const dark = ChartTheme(
    textColor: Colors.white,
    gridColor: Color(0xFF333333),
    backgroundColor: Color(0xFF121212),
    defaultColors: [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ],
  );
  
  static ChartTheme fromTheme(ThemeData theme) {
    return ChartTheme(
      textColor: theme.textTheme.bodyMedium?.color ?? Colors.black,
      gridColor: theme.dividerColor,
      backgroundColor: theme.scaffoldBackgroundColor,
      defaultColors: [
        theme.colorScheme.primary,
        theme.colorScheme.secondary,
        theme.colorScheme.tertiary,
        Colors.orange,
        Colors.purple,
      ],
    );
  }
}

/// 图表配置
class ChartConfig {
  final ChartTheme theme;
  final double height;
  final EdgeInsets padding;
  
  const ChartConfig({
    required this.theme,
    required this.height,
    this.padding = const EdgeInsets.all(16),
  });
} 