import 'package:flutter/material.dart';

/// 重试按钮组件
class RetryButtonWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String text;
  final IconData? icon;
  final bool outlined;
  final bool loading;
  
  const RetryButtonWidget({
    super.key,
    required this.onRetry,
    this.text = '重试',
    this.icon,
    this.outlined = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: loading ? null : onRetry,
        icon: loading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              )
            : Icon(icon ?? Icons.refresh),
        label: Text(loading ? '加载中...' : text),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      );
    }
    
    return ElevatedButton.icon(
      onPressed: loading ? null : onRetry,
      icon: loading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.onPrimary,
                ),
              ),
            )
          : Icon(icon ?? Icons.refresh),
      label: Text(loading ? '加载中...' : text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}