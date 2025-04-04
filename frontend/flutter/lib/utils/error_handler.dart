import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 自定义错误
class AppError {
  final String message;
  final String? code;
  final int? statusCode;
  final dynamic data;

  AppError({
    required this.message,
    this.code,
    this.statusCode,
    this.data,
  });
}

/// 全局错误处理工具类
class GlobalErrorHandler {
  /// 处理异常
  static AppError handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is SocketException) {
      return _handleSocketException(error);
    } else if (error is TimeoutException) {
      return _handleTimeoutException(error);
    } else if (error is FormatException) {
      return _handleFormatException(error);
    } else if (error is AppError) {
      return error;
    } else {
      return _handleGenericError(error);
    }
  }

  /// 处理Dio错误
  static AppError _handleDioError(DioException error) {
    debugPrint('DioError: ${error.type}, ${error.message}');
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return AppError(
          message: '连接超时，请检查网络',
          code: 'CONNECTION_TIMEOUT',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.sendTimeout:
        return AppError(
          message: '发送请求超时，请稍后重试',
          code: 'SEND_TIMEOUT',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.receiveTimeout:
        return AppError(
          message: '接收响应超时，请稍后重试',
          code: 'RECEIVE_TIMEOUT',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.cancel:
        return AppError(
          message: '请求已取消',
          code: 'REQUEST_CANCELLED',
          statusCode: error.response?.statusCode,
        );
      default:
        if (error.message != null && (error.message!.contains('SocketException') || 
            error.message!.contains('Connection refused'))) {
          return AppError(
            message: '网络连接失败，请检查网络',
            code: 'NETWORK_ERROR',
            statusCode: error.response?.statusCode,
          );
        }
        return AppError(
          message: '请求错误：${error.message}',
          code: 'UNKNOWN_ERROR',
          statusCode: error.response?.statusCode,
          data: error.response?.data,
        );
    }
  }

  /// 处理HTTP错误响应
  static AppError _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    
    String? message;
    String? code;
    
    // 尝试从响应数据中提取错误信息
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? data['error'] as String?;
      code = data['code'] as String?;
    }
    
    switch (statusCode) {
      case 400:
        return AppError(
          message: message ?? '请求参数错误',
          code: code ?? 'BAD_REQUEST',
          statusCode: statusCode,
          data: data,
        );
      case 401:
        return AppError(
          message: message ?? '用户未授权，请重新登录',
          code: code ?? 'UNAUTHORIZED',
          statusCode: statusCode,
          data: data,
        );
      case 403:
        return AppError(
          message: message ?? '无权访问',
          code: code ?? 'FORBIDDEN',
          statusCode: statusCode,
          data: data,
        );
      case 404:
        return AppError(
          message: message ?? '请求的资源不存在',
          code: code ?? 'NOT_FOUND',
          statusCode: statusCode,
          data: data,
        );
      case 409:
        return AppError(
          message: message ?? '请求冲突',
          code: code ?? 'CONFLICT',
          statusCode: statusCode,
          data: data,
        );
      case 500:
        return AppError(
          message: message ?? '服务器内部错误',
          code: code ?? 'INTERNAL_SERVER_ERROR',
          statusCode: statusCode,
          data: data,
        );
      case 502:
        return AppError(
          message: message ?? '网关错误',
          code: code ?? 'BAD_GATEWAY',
          statusCode: statusCode,
          data: data,
        );
      case 503:
        return AppError(
          message: message ?? '服务不可用',
          code: code ?? 'SERVICE_UNAVAILABLE',
          statusCode: statusCode,
          data: data,
        );
      case 504:
        return AppError(
          message: message ?? '网关超时',
          code: code ?? 'GATEWAY_TIMEOUT',
          statusCode: statusCode,
          data: data,
        );
      default:
        return AppError(
          message: message ?? '未知HTTP错误，状态码：$statusCode',
          code: code ?? 'HTTP_ERROR',
          statusCode: statusCode,
          data: data,
        );
    }
  }

  /// 处理Socket异常
  static AppError _handleSocketException(SocketException error) {
    debugPrint('SocketException: ${error.message}');
    
    if (error.osError?.errorCode == 101 || 
        error.message.contains('Connection refused')) {
      return AppError(
        message: '无法连接到服务器，请检查网络',
        code: 'CONNECTION_REFUSED',
      );
    } else if (error.message.contains('Network is unreachable')) {
      return AppError(
        message: '网络不可达，请检查网络连接',
        code: 'NETWORK_UNREACHABLE',
      );
    } else {
      return AppError(
        message: '网络错误：${error.message}',
        code: 'SOCKET_ERROR',
      );
    }
  }

  /// 处理超时异常
  static AppError _handleTimeoutException(TimeoutException error) {
    debugPrint('TimeoutException: ${error.message}');
    
    return AppError(
      message: '请求超时，请稍后重试',
      code: 'TIMEOUT',
    );
  }

  /// 处理格式异常
  static AppError _handleFormatException(FormatException error) {
    debugPrint('FormatException: ${error.message}');
    
    return AppError(
      message: '数据格式错误',
      code: 'FORMAT_ERROR',
    );
  }

  /// 处理通用异常
  static AppError _handleGenericError(dynamic error) {
    debugPrint('GenericError: $error');
    
    return AppError(
      message: error?.toString() ?? '发生未知错误',
      code: 'GENERIC_ERROR',
    );
  }
}