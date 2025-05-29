import 'package:logger/logger.dart' as logger_lib;

class AppLogger {
  static late logger_lib.Logger _instance;
  
  static void init() {
    _instance = logger_lib.Logger(
      printer: logger_lib.PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: logger_lib.DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }
  
  static void d(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _instance.d(message, time: time, error: error, stackTrace: stackTrace);
  }
  
  static void i(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _instance.i(message, time: time, error: error, stackTrace: stackTrace);
  }
  
  static void w(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _instance.w(message, time: time, error: error, stackTrace: stackTrace);
  }
  
  static void e(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _instance.e(message, time: time, error: error, stackTrace: stackTrace);
  }
}

/// 向后兼容的Logger别名
typedef Logger = AppLogger;