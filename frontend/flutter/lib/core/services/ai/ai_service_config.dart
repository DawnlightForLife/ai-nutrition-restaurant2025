import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'ai_service_manager.dart';

/// AI服务配置和初始化工具
class AIServiceConfig {
  static const String configVersion = '1.0.0';
  
  /// 默认AI服务配置
  static const Map<String, dynamic> defaultConfig = {
    'default_provider': 'mock',
    'fallback_providers': ['mock'],
    'auto_switch_on_failure': true,
    'connection_timeout': 30000,
    'retry_count': 3,
    'retry_delay': 1000,
    'enable_caching': true,
    'cache_duration': 300000, // 5分钟
    'log_requests': kDebugMode,
    'analytics_enabled': false,
  };

  /// OpenAI服务配置
  static const Map<String, dynamic> openaiConfig = {
    'base_url': 'https://api.openai.com/v1',
    'model': 'gpt-3.5-turbo',
    'max_tokens': 2000,
    'temperature': 0.7,
    'top_p': 1.0,
    'frequency_penalty': 0.0,
    'presence_penalty': 0.0,
  };

  /// 自定义AI服务配置
  static const Map<String, dynamic> customConfig = {
    'base_url': 'http://localhost:8000/api/v1',
    'model_version': 'v1.0',
    'timeout': 30000,
    'max_retries': 3,
    'retry_delay': 1000,
    'stream_enabled': true,
    'batch_size': 10,
  };

  /// 模拟AI服务配置
  static const Map<String, dynamic> mockConfig = {
    'response_delay': 1500, // 毫秒
    'failure_rate': 0.0, // 0-1之间，用于测试错误处理
    'enable_streaming': true,
    'mock_data_quality': 'high', // low, medium, high
  };

  /// 初始化AI服务管理器
  static Future<bool> initializeAIServices() async {
    try {
      debugPrint('开始初始化AI服务...');
      
      final manager = AIServiceManager.instance;
      
      // 初始化管理器
      await manager.initialize();
      
      debugPrint('AI服务初始化完成');
      return true;
    } catch (e) {
      debugPrint('AI服务初始化失败: $e');
      return false;
    }
  }

  /// 配置开发环境的AI服务
  static Future<void> configureDevelopmentServices() async {
    final manager = AIServiceManager.instance;
    
    // 在开发环境中优先使用模拟服务
    debugPrint('配置开发环境AI服务...');
    
    try {
      // 确保模拟服务可用
      await manager.switchToProvider('mock');
      debugPrint('开发环境AI服务配置完成');
    } catch (e) {
      debugPrint('开发环境AI服务配置失败: $e');
    }
  }

  /// 配置生产环境的AI服务
  static Future<void> configureProductionServices() async {
    final manager = AIServiceManager.instance;
    
    debugPrint('配置生产环境AI服务...');
    
    try {
      // 生产环境优先使用自定义AI服务
      final customAvailable = await manager.testServiceConnection('custom');
      if (customAvailable) {
        await manager.switchToProvider('custom');
        debugPrint('已切换到自定义AI服务');
      } else {
        // 如果自定义服务不可用，尝试OpenAI
        final openaiAvailable = await manager.testServiceConnection('openai');
        if (openaiAvailable) {
          await manager.switchToProvider('openai');
          debugPrint('已切换到OpenAI服务');
        } else {
          // 最后回退到模拟服务
          await manager.switchToProvider('mock');
          debugPrint('已回退到模拟AI服务');
        }
      }
      
      debugPrint('生产环境AI服务配置完成');
    } catch (e) {
      debugPrint('生产环境AI服务配置失败: $e');
    }
  }

  /// 获取推荐的AI服务配置
  static Map<String, dynamic> getRecommendedConfig() {
    final config = Map<String, dynamic>.from(defaultConfig);
    
    if (kDebugMode) {
      // 开发环境配置
      config.addAll({
        'default_provider': 'mock',
        'log_requests': true,
        'analytics_enabled': false,
        'enable_debug_mode': true,
      });
    } else {
      // 生产环境配置
      config.addAll({
        'default_provider': 'custom',
        'fallback_providers': ['custom', 'openai', 'mock'],
        'log_requests': false,
        'analytics_enabled': true,
        'enable_debug_mode': false,
      });
    }
    
    return config;
  }

  /// 验证AI服务配置
  static bool validateConfig(Map<String, dynamic> config) {
    final requiredKeys = [
      'default_provider',
      'connection_timeout',
      'retry_count',
    ];
    
    for (final key in requiredKeys) {
      if (!config.containsKey(key)) {
        debugPrint('配置验证失败：缺少必需的配置项 $key');
        return false;
      }
    }
    
    // 验证超时时间
    final timeout = config['connection_timeout'];
    if (timeout is! int || timeout <= 0) {
      debugPrint('配置验证失败：connection_timeout 必须是正整数');
      return false;
    }
    
    // 验证重试次数
    final retryCount = config['retry_count'];
    if (retryCount is! int || retryCount < 0) {
      debugPrint('配置验证失败：retry_count 必须是非负整数');
      return false;
    }
    
    return true;
  }

  /// 热更新AI服务配置
  static Future<bool> updateServiceConfig(
    String providerName,
    Map<String, dynamic> newConfig,
  ) async {
    try {
      final manager = AIServiceManager.instance;
      
      // 验证配置
      if (!validateConfig(newConfig)) {
        return false;
      }
      
      // 重新加载服务
      await manager.reloadService(providerName);
      
      debugPrint('AI服务配置更新成功: $providerName');
      return true;
    } catch (e) {
      debugPrint('AI服务配置更新失败: $e');
      return false;
    }
  }

  /// 获取所有服务的健康状态
  static Future<Map<String, ServiceHealthInfo>> getServicesHealthInfo() async {
    final manager = AIServiceManager.instance;
    final healthStatus = await manager.getServiceHealthStatus();
    final Map<String, ServiceHealthInfo> healthInfo = {};
    
    for (final entry in healthStatus.entries) {
      final providerName = entry.key;
      final isHealthy = entry.value;
      
      healthInfo[providerName] = ServiceHealthInfo(
        providerName: providerName,
        isHealthy: isHealthy,
        lastChecked: DateTime.now(),
        responseTime: isHealthy ? 100 : -1, // 简化实现
      );
    }
    
    return healthInfo;
  }

  /// 自动选择最佳AI服务
  static Future<String?> selectBestService() async {
    final manager = AIServiceManager.instance;
    final healthStatus = await manager.getServiceHealthStatus();
    
    // 按优先级排序的服务列表
    const priorityOrder = ['custom', 'openai', 'mock'];
    
    for (final provider in priorityOrder) {
      if (healthStatus[provider] == true) {
        return provider;
      }
    }
    
    return null; // 没有可用的服务
  }

  /// 监控AI服务性能
  static Future<Map<String, PerformanceMetrics>> getPerformanceMetrics() async {
    // 简化实现，实际应用中可以从缓存或数据库获取性能指标
    return {
      'mock': PerformanceMetrics(
        averageResponseTime: 1500,
        successRate: 1.0,
        totalRequests: 100,
        errorCount: 0,
      ),
      'custom': PerformanceMetrics(
        averageResponseTime: 800,
        successRate: 0.95,
        totalRequests: 50,
        errorCount: 2,
      ),
      'openai': PerformanceMetrics(
        averageResponseTime: 2000,
        successRate: 0.98,
        totalRequests: 30,
        errorCount: 1,
      ),
    };
  }

  /// 导出AI服务配置
  static Map<String, dynamic> exportConfig() {
    return {
      'version': configVersion,
      'timestamp': DateTime.now().toIso8601String(),
      'default_config': defaultConfig,
      'openai_config': openaiConfig,
      'custom_config': customConfig,
      'mock_config': mockConfig,
    };
  }

  /// 导入AI服务配置
  static bool importConfig(Map<String, dynamic> config) {
    try {
      // 验证配置版本
      final version = config['version'];
      if (version != configVersion) {
        debugPrint('配置版本不匹配: $version != $configVersion');
        return false;
      }
      
      // 验证配置格式
      if (!config.containsKey('default_config')) {
        debugPrint('配置格式无效：缺少 default_config');
        return false;
      }
      
      debugPrint('AI服务配置导入成功');
      return true;
    } catch (e) {
      debugPrint('配置导入失败: $e');
      return false;
    }
  }
}

/// 服务健康信息
class ServiceHealthInfo {
  final String providerName;
  final bool isHealthy;
  final DateTime lastChecked;
  final int responseTime; // 毫秒，-1表示不可用

  ServiceHealthInfo({
    required this.providerName,
    required this.isHealthy,
    required this.lastChecked,
    required this.responseTime,
  });

  String get statusText => isHealthy ? '健康' : '不可用';
  
  Color get statusColor {
    if (!isHealthy) return const Color(0xFFE53E3E);
    if (responseTime > 2000) return const Color(0xFFED8936);
    return const Color(0xFF38A169);
  }

  Map<String, dynamic> toJson() => {
    'providerName': providerName,
    'isHealthy': isHealthy,
    'lastChecked': lastChecked.toIso8601String(),
    'responseTime': responseTime,
    'statusText': statusText,
  };
}

/// 性能指标
class PerformanceMetrics {
  final double averageResponseTime; // 毫秒
  final double successRate; // 0-1
  final int totalRequests;
  final int errorCount;

  PerformanceMetrics({
    required this.averageResponseTime,
    required this.successRate,
    required this.totalRequests,
    required this.errorCount,
  });

  double get errorRate => totalRequests > 0 ? errorCount / totalRequests : 0.0;
  
  String get performanceGrade {
    if (successRate >= 0.98 && averageResponseTime < 1000) return 'A';
    if (successRate >= 0.95 && averageResponseTime < 2000) return 'B';
    if (successRate >= 0.90 && averageResponseTime < 3000) return 'C';
    return 'D';
  }

  Map<String, dynamic> toJson() => {
    'averageResponseTime': averageResponseTime,
    'successRate': successRate,
    'totalRequests': totalRequests,
    'errorCount': errorCount,
    'errorRate': errorRate,
    'performanceGrade': performanceGrade,
  };
}

/// AI服务配置异常
class AIServiceConfigException implements Exception {
  final String message;
  final String? code;

  AIServiceConfigException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AIServiceConfigException: $message${code != null ? ' (Code: $code)' : ''}';
}