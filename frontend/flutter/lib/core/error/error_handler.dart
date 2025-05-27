import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'app_exception.dart';

/// 全局错误处理器
@singleton
class GlobalErrorHandler {
  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  /// 处理并转换异常
  static AppException handleError(dynamic error, [StackTrace? stackTrace]) {
    _logger.e('Error occurred', error: error, stackTrace: stackTrace);

    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return _handleDioError(error);
    }

    if (error is FormatException) {
      return const DataFormatException('数据格式错误');
    }

    if (error is TypeError) {
      return const AppException(
        message: '数据类型错误',
        code: 'TYPE_ERROR',
      );
    }

    if (error.toString().contains('SocketException') || 
        error.toString().contains('Connection')) {
      return NetworkException(
        '网络连接错误，请检查您的网络设置',
        code: 'network_error',
      );
    }

    // 默认处理
    return AppException(
      message: kDebugMode ? error.toString() : '发生未知错误',
      code: 'UNKNOWN_ERROR',
    );
  }

  /// 处理Dio网络错误
  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const NetworkException('连接超时，请检查网络连接');
      
      case DioExceptionType.sendTimeout:
        return const NetworkException('请求超时，请稍后重试');
      
      case DioExceptionType.receiveTimeout:
        return const NetworkException('响应超时，请稍后重试');
      
      case DioExceptionType.badCertificate:
        return const NetworkException('证书验证失败');
      
      case DioExceptionType.cancel:
        return const NetworkException('请求已取消');
      
      case DioExceptionType.connectionError:
        return const NetworkException('网络连接失败，请检查网络设置');
      
      case DioExceptionType.badResponse:
        return _handleHttpError(error.response);
      
      case DioExceptionType.unknown:
        return NetworkException(error.message ?? '网络请求失败');
    }
  }

  /// 处理HTTP状态码错误
  static AppException _handleHttpError(Response<dynamic>? response) {
    if (response == null) {
      return const ServerException('服务器响应异常');
    }

    switch (response.statusCode) {
      case 400:
        return const ValidationException('请求参数错误');
      
      case 401:
        return const AuthException('未授权，请重新登录');
      
      case 403:
        return const AuthException('权限不足，无法访问');
      
      case 404:
        return const ServerException('请求的资源不存在');
      
      case 422:
        return ValidationException(_extractValidationMessage(response.data));
      
      case 429:
        return const ServerException('请求过于频繁，请稍后重试');
      
      case 500:
        return const ServerException('服务器内部错误');
      
      case 502:
        return const ServerException('网关错误');
      
      case 503:
        return const ServerException('服务暂时不可用');
      
      default:
        return ServerException('服务器错误 (${response.statusCode})');
    }
  }

  /// 提取验证错误信息
  static String _extractValidationMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) {
        return data['message'].toString();
      }
      
      if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is Map<String, dynamic>) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
        }
      }
    }
    
    return '数据验证失败';
  }

  /// 记录错误信息
  static void logError(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    _logger.e(
      message,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
    );
    
    if (context != null) {
      _logger.d('Error context: $context');
    }
  }

  /// 记录警告信息
  static void logWarning(
    String message, [
    Map<String, dynamic>? context,
  ]) {
    _logger.w(message);
    if (context != null) {
      _logger.d('Warning context: $context');
    }
  }

  /// 记录调试信息
  static void logDebug(
    String message, [
    Map<String, dynamic>? context,
  ]) {
    if (kDebugMode) {
      _logger.d(message);
      if (context != null) {
        _logger.d('Debug context: $context');
      }
    }
  }

  /// 记录信息
  static void logInfo(
    String message, [
    Map<String, dynamic>? context,
  ]) {
    _logger.i(message);
    if (context != null) {
      _logger.d('Info context: $context');
    }
  }

  /// 显示错误提示
  static void showErrorSnackBar(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: duration,
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
}