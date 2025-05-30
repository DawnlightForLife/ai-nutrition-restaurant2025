import 'package:logger/logger.dart' as logger_lib;

/// 日志级别
enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  wtf,
  nothing,
}

class AppLogger {
  static late logger_lib.Logger _instance;
  static LogLevel _level = LogLevel.info;
  static bool _enableFileLogging = false;
  
  static void init({
    LogLevel level = LogLevel.info,
    bool enableFileLogging = false,
  }) {
    _level = level;
    _enableFileLogging = enableFileLogging;
    
    _instance = logger_lib.Logger(
      printer: logger_lib.PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: logger_lib.DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: _mapLogLevel(level),
    );
  }
  
  static logger_lib.Level _mapLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return logger_lib.Level.trace;
      case LogLevel.debug:
        return logger_lib.Level.debug;
      case LogLevel.info:
        return logger_lib.Level.info;
      case LogLevel.warning:
        return logger_lib.Level.warning;
      case LogLevel.error:
        return logger_lib.Level.error;
      case LogLevel.wtf:
        return logger_lib.Level.fatal;
      case LogLevel.nothing:
        return logger_lib.Level.off;
    }
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
  
  // 添加缺失的方法别名
  static void debug(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    d(message, time: time, error: error, stackTrace: stackTrace);
  }
  
  static void info(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    i(message, time: time, error: error, stackTrace: stackTrace);
  }
  
  static void warning(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    w(message, time: time, error: error, stackTrace: stackTrace);
  }
  
  static void error(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    e(message, time: time, error: error, stackTrace: stackTrace);
  }
}

/// 向后兼容的Logger别名
typedef Logger = AppLogger;