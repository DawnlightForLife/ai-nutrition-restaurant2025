import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_service_interface.dart';
import 'providers/custom_ai_service.dart';
import 'providers/mock_ai_service.dart';
import 'providers/openai_service.dart';

/// AI服务管理器
/// 负责管理和切换不同的AI服务提供者
class AIServiceManager {
  static AIServiceManager? _instance;
  static AIServiceManager get instance => _instance ??= AIServiceManager._();
  
  AIServiceManager._();

  AIServiceInterface? _currentService;
  final Map<String, AIServiceInterface> _services = {};
  final Map<String, AIServiceFactory> _factories = {};
  
  /// 当前活跃的AI服务
  AIServiceInterface? get currentService => _currentService;
  
  /// 可用的服务提供者列表
  List<String> get availableProviders => _factories.keys.toList();
  
  /// 当前服务提供者名称
  String? get currentProviderName => _currentService?.providerName;

  /// 初始化AI服务管理器
  Future<void> initialize() async {
    // 注册所有可用的AI服务工厂
    _registerServiceFactories();
    
    // 从本地存储加载上次选择的服务提供者
    final prefs = await SharedPreferences.getInstance();
    final savedProvider = prefs.getString('ai_service_provider') ?? 'mock';
    
    // 初始化默认服务
    await switchToProvider(savedProvider);
  }

  /// 注册所有AI服务工厂
  void _registerServiceFactories() {
    // 模拟AI服务（用于开发和测试）
    _factories['mock'] = () => MockAIService();
    
    // OpenAI服务
    _factories['openai'] = () => OpenAIService();
    
    // 自定义AI服务（您的AI模型）
    _factories['custom'] = () => CustomAIService();
    
    // 可以在这里添加更多AI服务提供者
    // _factories['claude'] = () => ClaudeAIService();
    // _factories['gemini'] = () => GeminiAIService();
  }

  /// 切换到指定的AI服务提供者
  Future<bool> switchToProvider(String providerName) async {
    try {
      // 检查服务提供者是否存在
      if (!_factories.containsKey(providerName)) {
        debugPrint('AI服务提供者不存在: $providerName');
        return false;
      }

      // 如果已经是当前服务，直接返回
      if (_currentService?.providerName == providerName) {
        return true;
      }

      // 释放当前服务资源
      if (_currentService != null) {
        await _currentService!.dispose();
      }

      // 获取或创建新服务实例
      AIServiceInterface newService;
      if (_services.containsKey(providerName)) {
        newService = _services[providerName]!;
      } else {
        newService = _factories[providerName]!();
        _services[providerName] = newService;
      }

      // 初始化新服务
      await newService.initialize();
      
      // 检查服务是否可用
      if (!newService.isAvailable) {
        debugPrint('AI服务不可用: $providerName');
        return false;
      }

      // 设置为当前服务
      _currentService = newService;
      
      // 保存选择到本地存储
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ai_service_provider', providerName);
      
      debugPrint('已切换到AI服务提供者: $providerName');
      return true;
    } catch (e) {
      debugPrint('切换AI服务提供者失败: $e');
      return false;
    }
  }

  /// 获取指定服务提供者的信息
  Future<AIServiceInfo?> getServiceInfo(String providerName) async {
    try {
      if (!_factories.containsKey(providerName)) {
        return null;
      }

      AIServiceInterface service;
      if (_services.containsKey(providerName)) {
        service = _services[providerName]!;
      } else {
        service = _factories[providerName]!();
        // 临时初始化以获取信息
        await service.initialize();
      }

      return AIServiceInfo(
        name: service.providerName,
        isAvailable: service.isAvailable,
        capabilities: service.capabilities,
        isActive: service == _currentService,
      );
    } catch (e) {
      debugPrint('获取AI服务信息失败: $e');
      return null;
    }
  }

  /// 获取所有服务提供者的信息
  Future<List<AIServiceInfo>> getAllServiceInfo() async {
    final List<AIServiceInfo> serviceInfos = [];
    
    for (final providerName in _factories.keys) {
      final info = await getServiceInfo(providerName);
      if (info != null) {
        serviceInfos.add(info);
      }
    }
    
    return serviceInfos;
  }

  /// 测试指定服务提供者的连接
  Future<bool> testServiceConnection(String providerName) async {
    try {
      if (!_factories.containsKey(providerName)) {
        return false;
      }

      AIServiceInterface service;
      if (_services.containsKey(providerName)) {
        service = _services[providerName]!;
      } else {
        service = _factories[providerName]!();
        await service.initialize();
      }

      // 执行简单的测试请求
      final testResponse = await service.generateConsultationReply(
        question: '测试连接',
      );

      return testResponse.success;
    } catch (e) {
      debugPrint('测试AI服务连接失败: $e');
      return false;
    }
  }

  /// 热重载指定的服务提供者
  Future<bool> reloadService(String providerName) async {
    try {
      if (_services.containsKey(providerName)) {
        final service = _services[providerName]!;
        await service.dispose();
        _services.remove(providerName);
      }

      // 如果是当前活跃服务，重新切换
      if (_currentService?.providerName == providerName) {
        _currentService = null;
        return await switchToProvider(providerName);
      }

      return true;
    } catch (e) {
      debugPrint('重载AI服务失败: $e');
      return false;
    }
  }

  /// 清理所有服务资源
  Future<void> dispose() async {
    for (final service in _services.values) {
      await service.dispose();
    }
    _services.clear();
    _currentService = null;
  }

  /// 动态注册新的AI服务提供者
  void registerServiceProvider(String name, AIServiceFactory factory) {
    _factories[name] = factory;
    debugPrint('已注册AI服务提供者: $name');
  }

  /// 注销AI服务提供者
  Future<void> unregisterServiceProvider(String name) async {
    if (_services.containsKey(name)) {
      await _services[name]!.dispose();
      _services.remove(name);
    }
    _factories.remove(name);
    
    // 如果是当前活跃服务，切换到默认服务
    if (_currentService?.providerName == name) {
      await switchToProvider('mock');
    }
    
    debugPrint('已注销AI服务提供者: $name');
  }

  /// 获取服务健康状态
  Future<Map<String, bool>> getServiceHealthStatus() async {
    final Map<String, bool> healthStatus = {};
    
    for (final providerName in _factories.keys) {
      healthStatus[providerName] = await testServiceConnection(providerName);
    }
    
    return healthStatus;
  }
}

/// AI服务工厂函数类型
typedef AIServiceFactory = AIServiceInterface Function();

/// AI服务信息
class AIServiceInfo {
  final String name;
  final bool isAvailable;
  final AICapabilities capabilities;
  final bool isActive;

  AIServiceInfo({
    required this.name,
    required this.isAvailable,
    required this.capabilities,
    required this.isActive,
  });

  /// 获取服务显示名称
  String get displayName {
    switch (name) {
      case 'mock':
        return '模拟AI服务';
      case 'openai':
        return 'OpenAI GPT';
      case 'custom':
        return '自定义AI模型';
      default:
        return name;
    }
  }

  /// 获取服务描述
  String get description {
    switch (name) {
      case 'mock':
        return '用于开发测试的模拟AI服务';
      case 'openai':
        return 'OpenAI GPT系列模型';
      case 'custom':
        return '您训练的专用营养AI模型';
      default:
        return '第三方AI服务';
    }
  }

  /// 获取服务状态文本
  String get statusText {
    if (!isAvailable) return '不可用';
    if (isActive) return '当前使用';
    return '可用';
  }

  /// 获取状态颜色
  Color get statusColor {
    if (!isAvailable) return const Color(0xFFE53E3E);
    if (isActive) return const Color(0xFF38A169);
    return const Color(0xFF4A5568);
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'displayName': displayName,
    'description': description,
    'isAvailable': isAvailable,
    'isActive': isActive,
    'statusText': statusText,
  };
}


/// AI服务管理器异常
class AIServiceManagerException implements Exception {
  final String message;
  final String? code;

  AIServiceManagerException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AIServiceManagerException: $message${code != null ? ' (Code: $code)' : ''}';
}