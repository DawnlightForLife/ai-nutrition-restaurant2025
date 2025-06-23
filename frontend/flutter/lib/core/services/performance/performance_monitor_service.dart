import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// 性能监控服务
/// 用于监控应用的性能指标
class PerformanceMonitorService {
  static final PerformanceMonitorService _instance = PerformanceMonitorService._internal();
  factory PerformanceMonitorService() => _instance;
  PerformanceMonitorService._internal();

  final Map<String, DateTime> _operationStartTimes = {};
  final Map<String, List<int>> _operationDurations = {};
  final StreamController<PerformanceMetric> _metricsController = 
      StreamController<PerformanceMetric>.broadcast();

  Stream<PerformanceMetric> get metrics => _metricsController.stream;

  /// 开始监控一个操作
  void startOperation(String operationName) {
    _operationStartTimes[operationName] = DateTime.now();
    if (kDebugMode) {
      developer.log('开始操作: $operationName', name: 'Performance');
    }
  }

  /// 结束监控一个操作
  void endOperation(String operationName, {Map<String, dynamic>? metadata}) {
    final startTime = _operationStartTimes.remove(operationName);
    if (startTime == null) return;

    final duration = DateTime.now().difference(startTime).inMilliseconds;
    
    // 记录持续时间
    _operationDurations.putIfAbsent(operationName, () => []).add(duration);
    
    // 创建性能指标
    final metric = PerformanceMetric(
      operationName: operationName,
      duration: duration,
      timestamp: DateTime.now(),
      metadata: metadata,
    );

    _metricsController.add(metric);

    if (kDebugMode) {
      developer.log(
        '完成操作: $operationName, 耗时: ${duration}ms',
        name: 'Performance',
      );
    }

    // 警告慢操作
    if (duration > 1000) {
      if (kDebugMode) {
        developer.log(
          '慢操作警告: $operationName 耗时 ${duration}ms',
          name: 'Performance',
        );
      }
    }
  }

  /// 记录API调用性能
  void recordApiCall(String endpoint, int duration, {
    bool success = true,
    String? error,
  }) {
    final metric = PerformanceMetric(
      operationName: 'api_call',
      duration: duration,
      timestamp: DateTime.now(),
      metadata: {
        'endpoint': endpoint,
        'success': success,
        'error': error,
      },
    );

    _metricsController.add(metric);

    if (kDebugMode) {
      final status = success ? '成功' : '失败';
      developer.log(
        'API调用 $endpoint: $status, 耗时: ${duration}ms',
        name: 'API Performance',
      );
    }
  }

  /// 记录页面加载性能
  void recordPageLoad(String pageName, int duration) {
    final metric = PerformanceMetric(
      operationName: 'page_load',
      duration: duration,
      timestamp: DateTime.now(),
      metadata: {'pageName': pageName},
    );

    _metricsController.add(metric);

    if (kDebugMode) {
      developer.log(
        '页面加载 $pageName: 耗时 ${duration}ms',
        name: 'Page Performance',
      );
    }
  }

  /// 获取操作的平均持续时间
  double getAverageDuration(String operationName) {
    final durations = _operationDurations[operationName];
    if (durations == null || durations.isEmpty) return 0.0;
    
    return durations.reduce((a, b) => a + b) / durations.length;
  }

  /// 获取操作的最大持续时间
  int getMaxDuration(String operationName) {
    final durations = _operationDurations[operationName];
    if (durations == null || durations.isEmpty) return 0;
    
    return durations.reduce((a, b) => a > b ? a : b);
  }

  /// 获取操作的最小持续时间
  int getMinDuration(String operationName) {
    final durations = _operationDurations[operationName];
    if (durations == null || durations.isEmpty) return 0;
    
    return durations.reduce((a, b) => a < b ? a : b);
  }

  /// 获取所有监控的操作名称
  List<String> getMonitoredOperations() {
    return _operationDurations.keys.toList();
  }

  /// 清除指定操作的性能数据
  void clearOperationData(String operationName) {
    _operationDurations.remove(operationName);
    _operationStartTimes.remove(operationName);
  }

  /// 清除所有性能数据
  void clearAllData() {
    _operationDurations.clear();
    _operationStartTimes.clear();
  }

  /// 获取性能报告
  PerformanceReport getPerformanceReport() {
    final operations = <OperationStats>[];
    
    for (final operationName in _operationDurations.keys) {
      final durations = _operationDurations[operationName]!;
      operations.add(OperationStats(
        name: operationName,
        count: durations.length,
        averageDuration: getAverageDuration(operationName),
        maxDuration: getMaxDuration(operationName),
        minDuration: getMinDuration(operationName),
      ));
    }

    return PerformanceReport(
      operations: operations,
      timestamp: DateTime.now(),
    );
  }

  /// 销毁服务
  void dispose() {
    _metricsController.close();
    _operationDurations.clear();
    _operationStartTimes.clear();
  }
}

/// 性能指标数据类
class PerformanceMetric {
  final String operationName;
  final int duration;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  const PerformanceMetric({
    required this.operationName,
    required this.duration,
    required this.timestamp,
    this.metadata,
  });

  @override
  String toString() {
    return 'PerformanceMetric{operationName: $operationName, duration: ${duration}ms, timestamp: $timestamp}';
  }
}

/// 操作统计数据类
class OperationStats {
  final String name;
  final int count;
  final double averageDuration;
  final int maxDuration;
  final int minDuration;

  const OperationStats({
    required this.name,
    required this.count,
    required this.averageDuration,
    required this.maxDuration,
    required this.minDuration,
  });

  @override
  String toString() {
    return 'OperationStats{name: $name, count: $count, avg: ${averageDuration.toStringAsFixed(1)}ms, max: ${maxDuration}ms, min: ${minDuration}ms}';
  }
}

/// 性能报告数据类
class PerformanceReport {
  final List<OperationStats> operations;
  final DateTime timestamp;

  const PerformanceReport({
    required this.operations,
    required this.timestamp,
  });

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Performance Report - ${timestamp}');
    buffer.writeln('=' * 50);
    
    for (final operation in operations) {
      buffer.writeln(operation.toString());
    }
    
    return buffer.toString();
  }
}

/// 性能监控装饰器，用于自动监控函数执行时间
Future<T> monitorPerformance<T>(
  String operationName,
  Future<T> Function() operation, {
  Map<String, dynamic>? metadata,
}) async {
  final monitor = PerformanceMonitorService();
  monitor.startOperation(operationName);
  
  try {
    final result = await operation();
    monitor.endOperation(operationName, metadata: metadata);
    return result;
  } catch (e) {
    monitor.endOperation(operationName, metadata: {
      ...?metadata,
      'error': e.toString(),
    });
    rethrow;
  }
}

/// 同步操作性能监控装饰器
T monitorPerformanceSync<T>(
  String operationName,
  T Function() operation, {
  Map<String, dynamic>? metadata,
}) {
  final monitor = PerformanceMonitorService();
  monitor.startOperation(operationName);
  
  try {
    final result = operation();
    monitor.endOperation(operationName, metadata: metadata);
    return result;
  } catch (e) {
    monitor.endOperation(operationName, metadata: {
      ...?metadata,
      'error': e.toString(),
    });
    rethrow;
  }
}