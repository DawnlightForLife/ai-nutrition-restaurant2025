import 'package:flutter/material.dart';
import 'performance_monitor.dart';

mixin PerformanceTrackingMixin<T extends StatefulWidget> on State<T> {
  late final String _screenName;
  
  String get screenName => widget.runtimeType.toString();
  
  @override
  void initState() {
    super.initState();
    _screenName = screenName;
    _startScreenTrace();
  }
  
  @override
  void dispose() {
    _stopScreenTrace();
    super.dispose();
  }
  
  void _startScreenTrace() {
    Performance.monitor.startTrace('screen_$_screenName');
    Performance.monitor.setTraceAttribute('screen_$_screenName', 'screen_name', _screenName);
  }
  
  void _stopScreenTrace() {
    Performance.monitor.stopTrace('screen_$_screenName');
  }
  
  // 用于跟踪网络请求
  Future<T> trackNetworkRequest<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final traceName = 'network_$operationName';
    Performance.monitor.startTrace(traceName);
    
    try {
      final result = await operation();
      Performance.monitor.setTraceAttribute(traceName, 'status', 'success');
      return result;
    } catch (e) {
      Performance.monitor.setTraceAttribute(traceName, 'status', 'error');
      Performance.monitor.setTraceAttribute(traceName, 'error', e.toString());
      rethrow;
    } finally {
      Performance.monitor.stopTrace(traceName);
    }
  }
  
  // 用于跟踪用户操作
  void trackUserAction(String action, [Map<String, dynamic>? parameters]) {
    Performance.monitor.logCustomEvent('user_$action', parameters);
  }
  
  // 用于跟踪列表滚动性能
  void trackListScroll(String listName, int itemCount) {
    Performance.monitor.incrementMetric('screen_$_screenName', '${listName}_scrolled_items', itemCount);
  }
}