import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_handler.dart';
import 'app_exception.dart';

/// 全局错误边界组件
class ErrorBoundary extends ConsumerWidget {
  final Widget child;
  final Widget Function(BuildContext context, AppException error)? errorBuilder;
  final Function(AppException error, StackTrace stackTrace)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ErrorHandler(
      onError: onError,
      errorBuilder: errorBuilder,
      child: child,
    );
  }
}

class _ErrorHandler extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, AppException error)? errorBuilder;
  final Function(AppException error, StackTrace stackTrace)? onError;

  const _ErrorHandler({
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  State<_ErrorHandler> createState() => _ErrorHandlerState();
}

class _ErrorHandlerState extends State<_ErrorHandler> {
  AppException? _error;

  @override
  void initState() {
    super.initState();
    // 配置自定义错误构建器
    ErrorWidget.builder = (FlutterErrorDetails details) {
      final error = GlobalErrorHandler.handleError(details.exception, details.stack);
      
      widget.onError?.call(error, details.stack ?? StackTrace.current);
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _error = error);
        }
      });

      return Material(
        child: Container(
          color: Colors.red.withOpacity(0.1),
          padding: const EdgeInsets.all(8),
          child: const Center(
            child: Text(
              '错误已捕获，正在重建界面...',
              style: TextStyle(color: Colors.red),
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(context, _error!) ?? 
          DefaultErrorWidget(
            error: _error!,
            onRetry: () => setState(() => _error = null),
          );
    }

    return widget.child;
  }
}

/// 默认错误显示组件
class DefaultErrorWidget extends StatelessWidget {
  final AppException error;
  final VoidCallback? onRetry;

  const DefaultErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getErrorIcon(),
                size: 80,
                color: Colors.red.shade400,
              ),
              
              const SizedBox(height: 24),
              
              Text(
                _getErrorTitle(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                error.message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              
              if (error.code != null) ...[
                const SizedBox(height: 8),
                Text(
                  '错误代码: ${error.code}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              if (onRetry != null)
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
          ),
        ),
      ),
    );
  }

  IconData _getErrorIcon() {
    if (error is NetworkException) {
      return Icons.wifi_off;
    } else if (error is AuthException) {
      return Icons.lock;
    } else if (error is ValidationException) {
      return Icons.warning;
    } else if (error is ServerException) {
      return Icons.error_outline;
    } else {
      return Icons.error;
    }
  }

  String _getErrorTitle() {
    if (error is NetworkException) {
      return '网络连接异常';
    } else if (error is AuthException) {
      return '认证失败';
    } else if (error is ValidationException) {
      return '数据验证失败';
    } else if (error is ServerException) {
      return '服务器异常';
    } else {
      return '发生错误';
    }
  }
}

/// 错误吐司显示组件
class ErrorToast {
  static void show(BuildContext context, AppException error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _getErrorIcon(error),
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error.message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: _getErrorColor(error),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: '关闭',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static IconData _getErrorIcon(AppException error) {
    if (error is NetworkException) {
      return Icons.wifi_off;
    } else if (error is AuthException) {
      return Icons.lock;
    } else if (error is ValidationException) {
      return Icons.warning;
    } else {
      return Icons.error;
    }
  }

  static Color _getErrorColor(AppException error) {
    if (error is NetworkException) {
      return Colors.orange;
    } else if (error is AuthException) {
      return Colors.red;
    } else if (error is ValidationException) {
      return Colors.amber;
    } else {
      return Colors.red.shade600;
    }
  }
}