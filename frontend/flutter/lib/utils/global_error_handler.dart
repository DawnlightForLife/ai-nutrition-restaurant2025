import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// 全局错误处理工具
///
/// 提供统一的错误处理、日志记录和用户提示功能
class GlobalErrorHandler {
  /// 单例实例
  static final GlobalErrorHandler _instance = GlobalErrorHandler._internal();
  
  /// 构造函数
  factory GlobalErrorHandler() {
    return _instance;
  }
  
  /// 内部构造函数
  GlobalErrorHandler._internal();
  
  /// 处理登录错误
  void handleAuthError(BuildContext context, Object error, {String? customMessage, String operation = '登录'}) {
    _logError('Auth Error', error);
    
    // 根据错误类型显示不同的错误消息
    String message = customMessage ?? _getAuthErrorMessage(error, operation: operation);
    
    // 显示错误提示
    _showErrorSnackBar(context, message);
  }
  
  /// 处理一般网络错误
  void handleNetworkError(BuildContext context, Object error, {String? customMessage, String operation = '操作'}) {
    _logError('Network Error', error);
    
    String message = customMessage ?? _getNetworkErrorMessage(error, operation: operation);
    
    _showErrorSnackBar(context, message);
  }
  
  /// 处理一般业务错误
  void handleBusinessError(BuildContext context, Object error, {String? customMessage}) {
    _logError('Business Error', error);
    
    String message = customMessage ?? _getBusinessErrorMessage(error);
    
    _showErrorSnackBar(context, message);
  }
  
  /// 处理未知错误
  void handleUnknownError(BuildContext context, Object error, {String? customMessage}) {
    _logError('Unknown Error', error);
    
    String message = customMessage ?? '发生未知错误，请稍后再试';
    
    _showErrorSnackBar(context, message);
  }
  
  /// 记录错误日志
  void _logError(String type, Object error) {
    developer.log(
      '$type: ${error.toString()}',
      name: 'GlobalErrorHandler',
      error: error,
    );
  }
  
  /// 获取认证错误消息
  String _getAuthErrorMessage(Object error, {String operation = '登录'}) {
    String errorStr = error.toString().toLowerCase();
    
    if (errorStr.contains('unauthorized') || errorStr.contains('401')) {
      return '身份验证失败，请重新登录';
    } else if (errorStr.contains('invalid') && errorStr.contains('credential')) {
      return '用户名或密码错误';
    } else if (errorStr.contains('code') && 
              (errorStr.contains('invalid') || errorStr.contains('expired'))) {
      return '验证码无效或已过期';
    } else if (errorStr.contains('too many') && errorStr.contains('attempt')) {
      return '尝试次数过多，请稍后再试';
    } else if (errorStr.contains('network') || errorStr.contains('connect')) {
      return '网络连接错误，请检查您的网络';
    } else if (errorStr.contains('404') || errorStr.contains('not found')) {
      return '服务暂不可用，请稍后再试';
    } else {
      return '${operation}失败，请稍后再试';
    }
  }
  
  /// 获取网络错误消息
  String _getNetworkErrorMessage(Object error, {String operation = '操作'}) {
    String errorStr = error.toString().toLowerCase();
    
    if (errorStr.contains('timeout')) {
      return '请求超时，请检查您的网络连接';
    } else if (errorStr.contains('connection') || errorStr.contains('network')) {
      return '网络连接错误，请稍后再试';
    } else if (errorStr.contains('server')) {
      return '服务器错误，请稍后再试';
    } else if (errorStr.contains('404') || errorStr.contains('not found')) {
      return '服务暂不可用，请稍后再试';
    } else {
      return '${operation}失败，请检查网络后重试';
    }
  }
  
  /// 获取业务错误消息
  String _getBusinessErrorMessage(Object error) {
    String errorStr = error.toString();
    
    // 如果错误消息已经是业务层定义的友好消息，直接返回
    if (errorStr.startsWith('业务错误:')) {
      return errorStr.substring(5);
    }
    
    // 否则返回通用错误消息
    return '操作失败，请稍后再试';
  }
  
  /// 显示错误提示条
  void _showErrorSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: '知道了',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void handleError(dynamic error) {
    debugPrint('全局错误处理: $error');
  }
} 