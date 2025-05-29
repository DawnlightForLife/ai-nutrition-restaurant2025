import 'package:flutter/material.dart';
import 'package:ai_nutrition_restaurant/presentation/components/charts/base/chart_config.dart';

/// Base class for all chart widgets
abstract class BaseChart extends StatelessWidget {
  final ChartConfig config;
  final String? title;
  final Widget? legend;
  
  const BaseChart({
    Key? key,
    required this.config,
    this.title,
    this.legend,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: config.height,
      width: config.width,
      padding: config.padding,
      decoration: BoxDecoration(
        color: config.theme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: config.theme.titleStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],
          Expanded(
            child: buildChart(context),
          ),
          if (legend != null && config.showLegend) ...[
            const SizedBox(height: 16),
            legend!,
          ],
        ],
      ),
    );
  }
  
  /// Build the actual chart widget
  Widget buildChart(BuildContext context);
  
  /// Create a loading placeholder
  static Widget loading({ChartConfig? config}) {
    final cfg = config ?? const ChartConfig();
    return Container(
      height: cfg.height ?? 200,
      width: cfg.width,
      padding: cfg.padding,
      decoration: BoxDecoration(
        color: cfg.theme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  
  /// Create an error placeholder
  static Widget error({
    required String message,
    ChartConfig? config,
    VoidCallback? onRetry,
  }) {
    final cfg = config ?? const ChartConfig();
    return Container(
      height: cfg.height ?? 200,
      width: cfg.width,
      padding: cfg.padding,
      decoration: BoxDecoration(
        color: cfg.theme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: cfg.theme.textColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: cfg.theme.labelStyle,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Create an empty state placeholder
  static Widget empty({
    required String message,
    ChartConfig? config,
    Widget? action,
  }) {
    final cfg = config ?? const ChartConfig();
    return Container(
      height: cfg.height ?? 200,
      width: cfg.width,
      padding: cfg.padding,
      decoration: BoxDecoration(
        color: cfg.theme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_chart_outlined,
              size: 48,
              color: cfg.theme.textColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: cfg.theme.labelStyle,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: 16),
              action,
            ],
          ],
        ),
      ),
    );
  }
}