import 'package:flutter/foundation.dart';

/// 日志级别枚举
enum LogLevel { debug, info, warning, error }

/// 日志工具类 - 提供统一的日志记录和前缀格式
class Logger {
  /// 不同模块的日志前缀
  static const String AUTH = '登录';
  static const String USER = '用户';
  static const String NUTRITION = '营养档案';
  static const String MERCHANT = '商家';
  static const String DISH = '菜品';
  static const String ORDER = '订单';
  static const String PAYMENT = '支付';
  static const String SYSTEM = '系统';
  static const String NETWORK = '网络';
  static const String API = 'API';

  /// 是否启用详细日志
  static bool _verbose = kDebugMode;

  /// 设置是否启用详细日志
  static void setVerbose(bool verbose) {
    _verbose = verbose;
  }

  /// 记录调试级别日志
  static void d(String prefix, String message) {
    _log(LogLevel.debug, prefix, message);
  }

  /// 记录信息级别日志
  static void i(String prefix, String message) {
    _log(LogLevel.info, prefix, message);
  }

  /// 记录警告级别日志
  static void w(String prefix, String message) {
    _log(LogLevel.warning, prefix, message);
  }

  /// 记录错误级别日志
  static void e(String prefix, String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.error, prefix, message);
    if (error != null) {
      print('[$prefix] 错误详情: $error');
      if (stackTrace != null && _verbose) {
        print('[$prefix] 堆栈跟踪: $stackTrace');
      }
    }
  }

  /// 记录API请求日志
  static void api(String prefix, String url, {Map<String, dynamic>? data, String? method}) {
    if (!_verbose) return;
    final methodStr = method != null ? '[$method]' : '';
    print('[$prefix]$methodStr 请求: $url');
    if (data != null) {
      // 屏蔽敏感信息
      final logData = Map<String, dynamic>.from(data);
      if (logData.containsKey('password')) {
        logData['password'] = '******';
      }
      print('[$prefix] 请求数据: $logData');
    }
  }

  /// 记录API响应日志
  static void apiResponse(String prefix, int statusCode, dynamic response, {String? url}) {
    if (!_verbose) return;
    print('[$prefix] 响应状态码: $statusCode');
    if (url != null) {
      print('[$prefix] 响应URL: $url');
    }
    print('[$prefix] 响应数据: $response');
  }

  /// 内部日志记录方法
  static void _log(LogLevel level, String prefix, String message) {
    if (!_verbose && level == LogLevel.debug) return;

    String levelStr;
    switch (level) {
      case LogLevel.debug:
        levelStr = '调试';
        break;
      case LogLevel.info:
        levelStr = '信息';
        break;
      case LogLevel.warning:
        levelStr = '警告';
        break;
      case LogLevel.error:
        levelStr = '错误';
        break;
    }

    print('[$prefix][$levelStr] $message');
  }
} 