import 'package:flutter/material.dart';
import 'base_scaffold.dart';
import 'error_display.dart';
import 'loading_indicator.dart';

class BasePage extends StatelessWidget {
  final String title;
  final bool isLoading;
  final String? errorMessage;
  final Widget Function(BuildContext context) builder;
  final List<Widget>? actions;

  const BasePage({
    super.key,
    required this.title,
    required this.builder,
    this.isLoading = false,
    this.errorMessage,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: title,
      actions: actions,
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(child: NRLoadingIndicator());
          }
          if (errorMessage != null) {
            return Center(child: ErrorDisplay(message: errorMessage!));
          }
          return builder(context);
        },
      ),
    );
  }
}