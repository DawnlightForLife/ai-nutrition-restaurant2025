/// AI服务集成模块
/// 
/// 这个模块提供了完整的AI服务架构，支持：
/// 1. 多种AI服务提供者（模拟、OpenAI、自定义）
/// 2. 热更换AI服务
/// 3. 自动故障转移
/// 4. 性能监控
/// 5. 配置管理
/// 
/// 使用方法：
/// ```dart
/// // 1. 在main.dart中初始化
/// await AIServiceConfig.initializeAIServices();
/// 
/// // 2. 在页面中使用
/// final aiService = ref.watch(currentAIServiceProvider);
/// final response = await aiService?.generateNutritionPlan(...);
/// 
/// // 3. 切换AI服务
/// await ref.read(aiServiceSwitchProvider.notifier).switchToProvider('openai');
/// ```

// 核心接口和类型定义
export 'ai_service_interface.dart';

// 服务管理器
export 'ai_service_manager.dart';

// Riverpod提供者
export 'ai_service_providers.dart';

// 配置和初始化
export 'ai_service_config.dart';

// AI服务实现
export 'providers/mock_ai_service.dart';
export 'providers/openai_service.dart';
export 'providers/custom_ai_service.dart';

/// AI服务快速访问工具类
class AIServices {
  // 私有构造函数，防止实例化
  AIServices._();
  
  /// 获取AI服务管理器实例
  static AIServiceManager get manager => AIServiceManager.instance;
  
  /// 初始化AI服务（应在应用启动时调用）
  static Future<bool> initialize() async {
    return await AIServiceConfig.initializeAIServices();
  }
  
  /// 配置开发环境
  static Future<void> configureDevelopment() async {
    await AIServiceConfig.configureDevelopmentServices();
  }
  
  /// 配置生产环境
  static Future<void> configureProduction() async {
    await AIServiceConfig.configureProductionServices();
  }
  
  /// 切换AI服务提供者
  static Future<bool> switchTo(String providerName) async {
    return await manager.switchToProvider(providerName);
  }
  
  /// 获取当前服务信息
  static String? get currentProvider => manager.currentProviderName;
  
  /// 检查服务可用性
  static bool get isAvailable => manager.currentService?.isAvailable ?? false;
  
  /// 获取服务能力
  static AICapabilities? get capabilities => manager.currentService?.capabilities;
  
  /// 重新加载当前服务
  static Future<bool> reload() async {
    final currentProvider = manager.currentProviderName;
    if (currentProvider != null) {
      return await manager.reloadService(currentProvider);
    }
    return false;
  }
  
  /// 测试所有服务连接
  static Future<Map<String, bool>> testAllConnections() async {
    return await manager.getServiceHealthStatus();
  }
  
  /// 自动选择最佳服务
  static Future<String?> selectBestService() async {
    return await AIServiceConfig.selectBestService();
  }
  
  /// 获取性能指标
  static Future<Map<String, PerformanceMetrics>> getPerformanceMetrics() async {
    return await AIServiceConfig.getPerformanceMetrics();
  }
}

/// AI服务常量
class AIServiceConstants {
  static const String mockProvider = 'mock';
  static const String openaiProvider = 'openai';
  static const String customProvider = 'custom';
  
  static const List<String> allProviders = [
    mockProvider,
    openaiProvider,
    customProvider,
  ];
  
  static const Map<String, String> providerDisplayNames = {
    mockProvider: '模拟AI服务',
    openaiProvider: 'OpenAI GPT',
    customProvider: '自定义AI模型',
  };
  
  static const Map<String, String> providerDescriptions = {
    mockProvider: '用于开发测试的模拟AI服务',
    openaiProvider: 'OpenAI GPT系列模型',
    customProvider: '您训练的专用营养AI模型',
  };
}

/// AI服务事件类型
enum AIServiceEvent {
  initialized,
  providerSwitched,
  connectionLost,
  connectionRestored,
  configUpdated,
  errorOccurred,
}

/// AI服务事件数据
class AIServiceEventData {
  final AIServiceEvent event;
  final String? providerName;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  AIServiceEventData({
    required this.event,
    this.providerName,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'event': event.name,
    'providerName': providerName,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
  };
}

/// AI服务使用统计
class AIServiceUsageStats {
  final Map<String, int> requestCounts;
  final Map<String, int> errorCounts;
  final Map<String, double> averageResponseTimes;
  final DateTime startTime;
  final DateTime lastUpdated;

  AIServiceUsageStats({
    required this.requestCounts,
    required this.errorCounts,
    required this.averageResponseTimes,
    required this.startTime,
    required this.lastUpdated,
  });

  int getTotalRequests() {
    return requestCounts.values.fold(0, (sum, count) => sum + count);
  }

  int getTotalErrors() {
    return errorCounts.values.fold(0, (sum, count) => sum + count);
  }

  double getOverallSuccessRate() {
    final total = getTotalRequests();
    final errors = getTotalErrors();
    return total > 0 ? (total - errors) / total : 1.0;
  }

  Map<String, dynamic> toJson() => {
    'requestCounts': requestCounts,
    'errorCounts': errorCounts,
    'averageResponseTimes': averageResponseTimes,
    'startTime': startTime.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
    'totalRequests': getTotalRequests(),
    'totalErrors': getTotalErrors(),
    'overallSuccessRate': getOverallSuccessRate(),
  };
}

/// AI服务版本信息
class AIServiceVersion {
  static const String version = '1.0.0';
  static const String buildNumber = '001';
  static const String releaseDate = '2024-01-01';
  
  static const List<String> supportedFeatures = [
    'multi_provider',
    'hot_swap',
    'auto_fallback',
    'performance_monitoring',
    'configuration_management',
    'streaming_chat',
    'nutrition_planning',
    'consultation_reply',
    'diet_analysis',
    'recipe_generation',
  ];
  
  static Map<String, dynamic> getVersionInfo() => {
    'version': version,
    'buildNumber': buildNumber,
    'releaseDate': releaseDate,
    'supportedFeatures': supportedFeatures,
  };
}