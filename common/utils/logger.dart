import 'dart:developer' as developer;

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// 日志工具类，用于应用中统一的日志记录
class Logger {
  // 当前日志级别
  static LogLevel _currentLevel = LogLevel.info;
  
  // 是否在生产环境中
  static bool _isProduction = false;
  
  // 是否将日志写入文件
  static bool _writeToFile = false;
  
  // 配置日志工具
  static void configure({
    LogLevel logLevel = LogLevel.info,
    bool isProduction = false,
    bool writeToFile = false,
  }) {
    _currentLevel = logLevel;
    _isProduction = isProduction;
    _writeToFile = writeToFile;
  }
  
  // 判断是否应该记录该级别的日志
  static bool _shouldLog(LogLevel level) {
    // 在生产环境下，不记录debug级别的日志
    if (_isProduction && level == LogLevel.debug) {
      return false;
    }
    
    // 根据当前设置的日志级别判断
    return level.index >= _currentLevel.index;
  }
  
  // 格式化日志消息
  static String _formatMessage(String message, String level) {
    final DateTime now = DateTime.now();
    final String timestamp = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    
    return "[$timestamp][$level] $message";
  }
  
  // 记录日志
  static void _log(String message, LogLevel level, {Object? error, StackTrace? stackTrace}) {
    if (!_shouldLog(level)) return;
    
    final String levelStr = level.toString().split('.').last.toUpperCase();
    final String formattedMessage = _formatMessage(message, levelStr);
    
    // 控制台输出
    developer.log(
      formattedMessage,
      name: 'AIRestaurant',
      error: error,
      stackTrace: stackTrace,
    );
    
    // 如果需要写入文件，这里可以添加文件写入逻辑
    if (_writeToFile) {
      // TODO: 实现文件日志记录
    }
  }
  
  /// 记录调试级别日志
  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _log(message, LogLevel.debug, error: error, stackTrace: stackTrace);
  }
  
  /// 记录信息级别日志
  static void info(String message, {Object? error, StackTrace? stackTrace}) {
    _log(message, LogLevel.info, error: error, stackTrace: stackTrace);
  }
  
  /// 记录警告级别日志
  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _log(message, LogLevel.warning, error: error, stackTrace: stackTrace);
  }
  
  /// 记录错误级别日志
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log(message, LogLevel.error, error: error, stackTrace: stackTrace);
  }
} 