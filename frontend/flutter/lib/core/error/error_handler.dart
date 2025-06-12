/// 错误处理器 - 向后兼容文件
/// 
/// 提供与旧版本API的兼容性，重定向到集中化错误处理器
library;

// 重新导出集中化错误处理器的所有内容
export 'centralized_error_handler.dart';

import 'centralized_error_handler.dart';
import '../utils/logger.dart';

/// 全局错误处理器类 - 向后兼容
/// 
/// 这个类提供与旧版本API的兼容性
class GlobalErrorHandler {
  /// 记录信息日志
  static void logInfo(String message) {
    AppLogger.info(message);
  }

  /// 记录错误日志
  static void logError(String message, {Object? error, StackTrace? stackTrace}) {
    CentralizedErrorHandler.instance.handleBusinessError(
      error ?? message,
      stackTrace: stackTrace,
      module: 'Error',
    );
  }

  /// 处理错误
  static void handleError(Object error, {StackTrace? stackTrace}) {
    CentralizedErrorHandler.instance.handleBusinessError(
      error,
      stackTrace: stackTrace,
    );
  }
}

/// API错误处理器类 - 向后兼容
class ApiErrorHandler {
  /// 处理API错误
  static Exception handleError(Object error) {
    CentralizedErrorHandler.instance.handleNetworkError(error);
    if (error is Exception) {
      return error;
    }
    return Exception(error.toString());
  }
}