/// 集中化错误处理器
/// 
/// 统一管理应用中所有的错误处理逻辑
/// 替代分散在各个模块中的多个错误处理器
library;

import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../utils/logger.dart';

/// 集中化错误处理器
/// 
/// 提供统一的错误处理、日志记录和用户通知机制
class CentralizedErrorHandler {
  static CentralizedErrorHandler? _instance;
  static CentralizedErrorHandler get instance => _instance ??= CentralizedErrorHandler._();
  
  CentralizedErrorHandler._();

  /// 错误监听器列表
  final List<ErrorListener> _listeners = [];
  
  /// 错误过滤器列表
  final List<ErrorFilter> _filters = [];

  /// 初始化错误处理器
  void initialize() {
    // 捕获 Flutter 框架错误
    FlutterError.onError = (FlutterErrorDetails details) {
      handleFlutterError(details);
    };

    // 捕获其他未处理的异步错误
    PlatformDispatcher.instance.onError = (error, stack) {
      handlePlatformError(error, stack);
      return true;
    };

    // 捕获 Zone 错误
    runZonedGuarded(() {}, (error, stack) {
      handleZoneError(error, stack);
    });

    AppLogger.info('CentralizedErrorHandler 已初始化');
  }

  /// 处理 Flutter 框架错误
  void handleFlutterError(FlutterErrorDetails details) {
    final errorInfo = ErrorInfo(
      type: ErrorType.flutter,
      error: details.exception,
      stackTrace: details.stack,
      context: details.context?.toString(),
      library: details.library,
      timestamp: DateTime.now(),
    );

    _processError(errorInfo);
  }

  /// 处理平台错误
  void handlePlatformError(Object error, StackTrace stack) {
    final errorInfo = ErrorInfo(
      type: ErrorType.platform,
      error: error,
      stackTrace: stack,
      timestamp: DateTime.now(),
    );

    _processError(errorInfo);
  }

  /// 处理 Zone 错误
  void handleZoneError(Object error, StackTrace stack) {
    final errorInfo = ErrorInfo(
      type: ErrorType.zone,
      error: error,
      stackTrace: stack,
      timestamp: DateTime.now(),
    );

    _processError(errorInfo);
  }

  /// 处理业务逻辑错误
  void handleBusinessError(
    Object error, {
    StackTrace? stackTrace,
    String? module,
    String? operation,
    Map<String, dynamic>? context,
  }) {
    final errorInfo = ErrorInfo(
      type: ErrorType.business,
      error: error,
      stackTrace: stackTrace,
      module: module,
      operation: operation,
      context: context?.toString(),
      timestamp: DateTime.now(),
    );

    _processError(errorInfo);
  }

  /// 处理网络错误
  void handleNetworkError(
    Object error, {
    StackTrace? stackTrace,
    String? url,
    String? method,
    int? statusCode,
    Map<String, dynamic>? requestData,
  }) {
    final errorInfo = ErrorInfo(
      type: ErrorType.network,
      error: error,
      stackTrace: stackTrace,
      url: url,
      method: method,
      statusCode: statusCode,
      context: requestData?.toString(),
      timestamp: DateTime.now(),
    );

    _processError(errorInfo);
  }

  /// 内部错误处理逻辑
  void _processError(ErrorInfo errorInfo) {
    // 应用错误过滤器
    for (final filter in _filters) {
      if (!filter.shouldHandle(errorInfo)) {
        return;
      }
    }

    // 记录错误日志
    _logError(errorInfo);

    // 通知所有错误监听器
    for (final listener in _listeners) {
      try {
        listener.onError(errorInfo);
      } catch (e) {
        // 避免监听器本身出错影响错误处理
        developer.log(
          'Error listener failed: $e',
          name: 'CentralizedErrorHandler',
          error: e,
        );
      }
    }
  }

  /// 记录错误日志
  void _logError(ErrorInfo errorInfo) {
    final message = 'Error [${errorInfo.type.name}]: ${errorInfo.error}';
    
    if (kDebugMode) {
      developer.log(
        message,
        name: 'ErrorHandler',
        error: errorInfo.error,
        stackTrace: errorInfo.stackTrace,
      );
    }

    AppLogger.error(
      message,
      error: errorInfo.error,
      stackTrace: errorInfo.stackTrace,
    );
  }

  /// 添加错误监听器
  void addListener(ErrorListener listener) {
    _listeners.add(listener);
  }

  /// 移除错误监听器
  void removeListener(ErrorListener listener) {
    _listeners.remove(listener);
  }

  /// 添加错误过滤器
  void addFilter(ErrorFilter filter) {
    _filters.add(filter);
  }

  /// 移除错误过滤器
  void removeFilter(ErrorFilter filter) {
    _filters.remove(filter);
  }

  /// 清理资源
  void dispose() {
    _listeners.clear();
    _filters.clear();
    _instance = null;
  }
}

/// 错误信息类
class ErrorInfo {
  const ErrorInfo({
    required this.type,
    required this.error,
    required this.timestamp,
    this.stackTrace,
    this.module,
    this.operation,
    this.context,
    this.library,
    this.url,
    this.method,
    this.statusCode,
  });

  final ErrorType type;
  final Object error;
  final StackTrace? stackTrace;
  final DateTime timestamp;
  final String? module;
  final String? operation;
  final String? context;
  final String? library;
  final String? url;
  final String? method;
  final int? statusCode;

  @override
  String toString() {
    return 'ErrorInfo(type: $type, error: $error, module: $module, operation: $operation)';
  }
}

/// 错误类型枚举
enum ErrorType {
  flutter,
  platform,
  zone,
  business,
  network,
}

/// 错误监听器接口
abstract class ErrorListener {
  void onError(ErrorInfo errorInfo);
}

/// 错误过滤器接口
abstract class ErrorFilter {
  bool shouldHandle(ErrorInfo errorInfo);
}

/// 常用错误过滤器

/// 调试模式过滤器
class DebugModeFilter implements ErrorFilter {
  @override
  bool shouldHandle(ErrorInfo errorInfo) {
    return kDebugMode;
  }
}

/// 错误类型过滤器
class ErrorTypeFilter implements ErrorFilter {
  const ErrorTypeFilter(this.allowedTypes);
  
  final Set<ErrorType> allowedTypes;
  
  @override
  bool shouldHandle(ErrorInfo errorInfo) {
    return allowedTypes.contains(errorInfo.type);
  }
}

/// 常用错误监听器

/// 用户通知监听器
class UserNotificationListener implements ErrorListener {
  @override
  void onError(ErrorInfo errorInfo) {
    // TODO: 显示用户友好的错误消息
    // 例如：Toast、Dialog、SnackBar 等
  }
}

/// 错误上报监听器
class ErrorReportingListener implements ErrorListener {
  @override
  void onError(ErrorInfo errorInfo) {
    // TODO: 上报错误到远程服务
    // 例如：Sentry、Firebase Crashlytics 等
  }
}