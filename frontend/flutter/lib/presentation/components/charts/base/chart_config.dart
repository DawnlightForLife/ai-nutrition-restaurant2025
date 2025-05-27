import 'package:flutter/material.dart';

/// Base configuration for all charts
class ChartConfig {
  final ChartTheme theme;
  final bool showLegend;
  final bool showGrid;
  final bool showTooltip;
  final bool animate;
  final Duration animationDuration;
  final EdgeInsets padding;
  final double? height;
  final double? width;
  
  const ChartConfig({
    this.theme = const ChartTheme(),
    this.showLegend = true,
    this.showGrid = true,
    this.showTooltip = true,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 600),
    this.padding = const EdgeInsets.all(16),
    this.height,
    this.width,
  });
  
  ChartConfig copyWith({
    ChartTheme? theme,
    bool? showLegend,
    bool? showGrid,
    bool? showTooltip,
    bool? animate,
    Duration? animationDuration,
    EdgeInsets? padding,
    double? height,
    double? width,
  }) {
    return ChartConfig(
      theme: theme ?? this.theme,
      showLegend: showLegend ?? this.showLegend,
      showGrid: showGrid ?? this.showGrid,
      showTooltip: showTooltip ?? this.showTooltip,
      animate: animate ?? this.animate,
      animationDuration: animationDuration ?? this.animationDuration,
      padding: padding ?? this.padding,
      height: height ?? this.height,
      width: width ?? this.width,
    );
  }
}

/// Theme configuration for charts
class ChartTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color gridColor;
  final Color textColor;
  final List<Color> palette;
  final TextStyle labelStyle;
  final TextStyle titleStyle;
  final TextStyle tooltipStyle;
  
  const ChartTheme({
    this.primaryColor = const Color(0xFF2196F3),
    this.secondaryColor = const Color(0xFF4CAF50),
    this.backgroundColor = Colors.white,
    this.gridColor = const Color(0xFFE0E0E0),
    this.textColor = const Color(0xFF424242),
    this.palette = const [
      Color(0xFF2196F3),
      Color(0xFF4CAF50),
      Color(0xFFFF9800),
      Color(0xFFF44336),
      Color(0xFF9C27B0),
      Color(0xFF00BCD4),
      Color(0xFFFFEB3B),
      Color(0xFF795548),
    ],
    this.labelStyle = const TextStyle(
      fontSize: 12,
      color: Color(0xFF757575),
    ),
    this.titleStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color(0xFF212121),
    ),
    this.tooltipStyle = const TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),
  });
  
  /// Create theme from Flutter ThemeData
  factory ChartTheme.fromTheme(ThemeData theme) {
    return ChartTheme(
      primaryColor: theme.primaryColor,
      secondaryColor: theme.colorScheme.secondary,
      backgroundColor: theme.cardColor,
      gridColor: theme.dividerColor,
      textColor: theme.textTheme.bodyMedium?.color ?? Colors.black87,
      labelStyle: theme.textTheme.labelSmall ?? const TextStyle(),
      titleStyle: theme.textTheme.titleMedium ?? const TextStyle(),
      tooltipStyle: const TextStyle(color: Colors.white),
    );
  }
  
  /// Dark theme preset
  static const ChartTheme dark = ChartTheme(
    primaryColor: Color(0xFF64B5F6),
    secondaryColor: Color(0xFF81C784),
    backgroundColor: Color(0xFF1E1E1E),
    gridColor: Color(0xFF424242),
    textColor: Color(0xFFE0E0E0),
    labelStyle: TextStyle(
      fontSize: 12,
      color: Color(0xFFBDBDBD),
    ),
    titleStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color(0xFFF5F5F5),
    ),
  );
}