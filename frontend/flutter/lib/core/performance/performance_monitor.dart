import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../config/app_config.dart';

abstract class PerformanceMonitor {
  void startTrace(String name);
  void stopTrace(String name);
  void incrementMetric(String name, String metric, int value);
  void setTraceAttribute(String name, String attribute, String value);
  void logCustomEvent(String name, Map<String, dynamic>? parameters);
}

class PerformanceMonitorImpl implements PerformanceMonitor {
  final Logger _logger = Logger();
  final Map<String, _TraceInfo> _traces = {};
  final bool _enableLogging;
  
  PerformanceMonitorImpl() : _enableLogging = AppConfig.instance.enableLogging;
  
  @override
  void startTrace(String name) {
    if (!AppConfig.instance.enablePerformanceMonitoring) return;
    
    _traces[name] = _TraceInfo(
      name: name,
      startTime: DateTime.now(),
    );
    
    if (_enableLogging) {
      _logger.d('Performance trace started: $name');
    }
  }
  
  @override
  void stopTrace(String name) {
    if (!AppConfig.instance.enablePerformanceMonitoring) return;
    
    final trace = _traces[name];
    if (trace == null) {
      _logger.w('Trace not found: $name');
      return;
    }
    
    final duration = DateTime.now().difference(trace.startTime);
    _traces.remove(name);
    
    if (_enableLogging) {
      _logger.d('Performance trace stopped: $name, duration: ${duration.inMilliseconds}ms');
    }
    
    // 在生产环境中，这里会发送到 Firebase Performance
    _reportPerformanceData(name, duration, trace.metrics, trace.attributes);
  }
  
  @override
  void incrementMetric(String traceName, String metric, int value) {
    if (!AppConfig.instance.enablePerformanceMonitoring) return;
    
    final trace = _traces[traceName];
    if (trace == null) {
      _logger.w('Trace not found: $traceName');
      return;
    }
    
    trace.metrics[metric] = (trace.metrics[metric] ?? 0) + value;
    
    if (_enableLogging) {
      _logger.d('Metric incremented: $traceName.$metric += $value');
    }
  }
  
  @override
  void setTraceAttribute(String traceName, String attribute, String value) {
    if (!AppConfig.instance.enablePerformanceMonitoring) return;
    
    final trace = _traces[traceName];
    if (trace == null) {
      _logger.w('Trace not found: $traceName');
      return;
    }
    
    trace.attributes[attribute] = value;
    
    if (_enableLogging) {
      _logger.d('Attribute set: $traceName.$attribute = $value');
    }
  }
  
  @override
  void logCustomEvent(String name, Map<String, dynamic>? parameters) {
    if (!AppConfig.instance.enablePerformanceMonitoring) return;
    
    if (_enableLogging) {
      _logger.d('Custom event: $name, parameters: $parameters');
    }
    
    // 在生产环境中，这里会发送到 Firebase Analytics
    _reportCustomEvent(name, parameters);
  }
  
  void _reportPerformanceData(
    String name,
    Duration duration,
    Map<String, int> metrics,
    Map<String, String> attributes,
  ) {
    // TODO: 集成 Firebase Performance 后，在这里上报数据
    if (kDebugMode) {
      print('Performance Report:');
      print('  Trace: $name');
      print('  Duration: ${duration.inMilliseconds}ms');
      print('  Metrics: $metrics');
      print('  Attributes: $attributes');
    }
  }
  
  void _reportCustomEvent(String name, Map<String, dynamic>? parameters) {
    // TODO: 集成 Firebase Analytics 后，在这里上报事件
    if (kDebugMode) {
      print('Custom Event: $name');
      print('  Parameters: $parameters');
    }
  }
}

class _TraceInfo {
  final String name;
  final DateTime startTime;
  final Map<String, int> metrics = {};
  final Map<String, String> attributes = {};
  
  _TraceInfo({
    required this.name,
    required this.startTime,
  });
}

// 单例访问
class Performance {
  static final PerformanceMonitor _instance = PerformanceMonitorImpl();
  static PerformanceMonitor get monitor => _instance;
}