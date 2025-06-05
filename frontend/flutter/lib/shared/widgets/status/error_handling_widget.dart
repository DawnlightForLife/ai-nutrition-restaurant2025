import 'package:flutter/material.dart';

/// 错误处理展示组件
class ErrorHandlingWidget extends StatelessWidget {
  final String? error;
  final String? title;
  final String? subtitle;
  final VoidCallback? onRetry;
  final IconData? icon;
  
  const ErrorHandlingWidget({
    super.key,
    this.error,
    this.title,
    this.subtitle,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorMessage = _getErrorMessage();
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 80,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              title ?? '出错了',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle ?? errorMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('重试'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getErrorMessage() {
    if (error == null) return '发生了未知错误';
    
    // 常见错误映射
    if (error!.contains('Connection refused') ||
        error!.contains('Failed host lookup')) {
      return '网络连接失败，请检查网络设置';
    }
    
    if (error!.contains('timeout')) {
      return '请求超时，请稍后重试';
    }
    
    if (error!.contains('401') || error!.contains('Unauthorized')) {
      return '登录已过期，请重新登录';
    }
    
    if (error!.contains('403') || error!.contains('Forbidden')) {
      return '没有权限访问此内容';
    }
    
    if (error!.contains('404') || error!.contains('Not Found')) {
      return '请求的内容不存在';
    }
    
    if (error!.contains('500') || error!.contains('Internal Server Error')) {
      return '服务器错误，请稍后重试';
    }
    
    // 默认显示原始错误
    return error!;
  }
}