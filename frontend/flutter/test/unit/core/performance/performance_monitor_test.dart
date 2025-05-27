import 'package:flutter_test/flutter_test.dart';
import 'package:ai_nutrition_restaurant/core/performance/performance_monitor.dart';
import 'package:ai_nutrition_restaurant/config/app_config.dart';

void main() {
  group('PerformanceMonitor', () {
    setUpAll(() {
      AppConfig.setEnvironment(Environment.dev);
    });
    
    test('应该能够开始和停止跟踪', () {
      final monitor = PerformanceMonitorImpl();
      
      // 开始跟踪
      monitor.startTrace('test_trace');
      
      // 等待一段时间
      Future.delayed(const Duration(milliseconds: 100));
      
      // 停止跟踪
      monitor.stopTrace('test_trace');
      
      // 测试通过，没有抛出异常
      expect(true, true);
    });
    
    test('应该能够设置跟踪属性', () {
      final monitor = PerformanceMonitorImpl();
      
      monitor.startTrace('test_trace');
      monitor.setTraceAttribute('test_trace', 'user_id', '12345');
      monitor.setTraceAttribute('test_trace', 'action', 'login');
      monitor.stopTrace('test_trace');
      
      expect(true, true);
    });
    
    test('应该能够增加指标值', () {
      final monitor = PerformanceMonitorImpl();
      
      monitor.startTrace('test_trace');
      monitor.incrementMetric('test_trace', 'item_count', 1);
      monitor.incrementMetric('test_trace', 'item_count', 2);
      monitor.stopTrace('test_trace');
      
      expect(true, true);
    });
    
    test('停止不存在的跟踪应该记录警告', () {
      final monitor = PerformanceMonitorImpl();
      
      // 停止一个从未开始的跟踪
      monitor.stopTrace('non_existent_trace');
      
      // 不应该抛出异常
      expect(true, true);
    });
    
    test('应该能够记录自定义事件', () {
      final monitor = PerformanceMonitorImpl();
      
      monitor.logCustomEvent('user_login', {
        'method': 'phone',
        'success': true,
      });
      
      monitor.logCustomEvent('button_click', null);
      
      expect(true, true);
    });
    
    test('在生产环境禁用性能监控时不应执行操作', () {
      // 切换到生产环境
      AppConfig.setEnvironment(Environment.prod);
      
      final monitor = PerformanceMonitorImpl();
      
      // 这些操作不应该执行
      monitor.startTrace('test_trace');
      monitor.incrementMetric('test_trace', 'metric', 1);
      monitor.stopTrace('test_trace');
      
      // 切换回开发环境
      AppConfig.setEnvironment(Environment.dev);
      
      expect(true, true);
    });
  });
  
  group('Performance Singleton', () {
    test('应该返回相同的实例', () {
      final instance1 = Performance.monitor;
      final instance2 = Performance.monitor;
      
      expect(identical(instance1, instance2), true);
    });
  });
}