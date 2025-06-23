import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_service_interface.dart';
import 'ai_service_manager.dart';

/// AI服务配置数据模型
class AIServiceConfig {
  final String provider;
  final Map<String, dynamic> settings;
  final bool autoSwitch;
  final List<String> fallbackProviders;

  const AIServiceConfig({
    required this.provider,
    required this.settings,
    this.autoSwitch = false,
    this.fallbackProviders = const [],
  });

  AIServiceConfig copyWith({
    String? provider,
    Map<String, dynamic>? settings,
    bool? autoSwitch,
    List<String>? fallbackProviders,
  }) {
    return AIServiceConfig(
      provider: provider ?? this.provider,
      settings: settings ?? this.settings,
      autoSwitch: autoSwitch ?? this.autoSwitch,
      fallbackProviders: fallbackProviders ?? this.fallbackProviders,
    );
  }
}

/// AI服务管理器提供者
final aiServiceManagerProvider = Provider<AIServiceManager>((ref) {
  return AIServiceManager.instance;
});

/// 当前AI服务提供者
final currentAIServiceProvider = Provider<AIServiceInterface?>((ref) {
  final manager = ref.watch(aiServiceManagerProvider);
  return manager.currentService;
});

/// AI服务可用性提供者
final aiServiceAvailabilityProvider = Provider<bool>((ref) {
  final service = ref.watch(currentAIServiceProvider);
  return service?.isAvailable ?? false;
});

/// AI服务信息列表提供者
final aiServiceInfoListProvider = FutureProvider<List<AIServiceInfo>>((ref) async {
  final manager = ref.watch(aiServiceManagerProvider);
  return await manager.getAllServiceInfo();
});

/// 当前AI服务信息提供者
final currentAIServiceInfoProvider = Provider<AIServiceInfo?>((ref) {
  final serviceInfoListAsync = ref.watch(aiServiceInfoListProvider);
  return serviceInfoListAsync.whenData((list) {
    return list.firstWhere(
      (info) => info.isActive,
      orElse: () => AIServiceInfo(
        name: 'none',
        isAvailable: false,
        capabilities: AICapabilities(
          supportsNutritionPlanning: false,
          supportsConsultationReply: false,
          supportsDietAnalysis: false,
          supportsRecipeGeneration: false,
          supportsStreamingChat: false,
          supportedLanguages: [],
        ),
        isActive: false,
      ),
    );
  }).value;
});

/// AI服务健康状态提供者
final aiServiceHealthStatusProvider = FutureProvider<Map<String, bool>>((ref) async {
  final manager = ref.watch(aiServiceManagerProvider);
  return await manager.getServiceHealthStatus();
});

/// 营养方案生成提供者
final nutritionPlanGeneratorProvider = Provider<Future<NutritionPlanResponse> Function({
  required ClientInfo clientInfo,
  required NutritionGoals nutritionGoals,
  List<String>? preferences,
  List<String>? restrictions,
})>((ref) {
  return ({
    required ClientInfo clientInfo,
    required NutritionGoals nutritionGoals,
    List<String>? preferences,
    List<String>? restrictions,
  }) async {
    final service = ref.read(currentAIServiceProvider);
    
    if (service == null || !service.isAvailable) {
      return NutritionPlanResponse(
        success: false,
        error: 'AI服务不可用',
      );
    }
    
    return await service.generateNutritionPlan(
      clientInfo: clientInfo,
      nutritionGoals: nutritionGoals,
      preferences: preferences,
      restrictions: restrictions,
    );
  };
});

/// 咨询回复生成提供者
final consultationReplyGeneratorProvider = Provider<Future<ConsultationReplyResponse> Function({
  required String question,
  String? context,
  NutritionistProfile? nutritionistProfile,
})>((ref) {
  return ({
    required String question,
    String? context,
    NutritionistProfile? nutritionistProfile,
  }) async {
    final service = ref.read(currentAIServiceProvider);
    
    if (service == null || !service.isAvailable) {
      return ConsultationReplyResponse(
        success: false,
        error: 'AI服务不可用',
      );
    }
    
    return await service.generateConsultationReply(
      question: question,
      context: context,
      nutritionistProfile: nutritionistProfile,
    );
  };
});

/// 饮食分析提供者
final dietAnalyzerProvider = Provider<Future<DietAnalysisResponse> Function({
  required List<FoodRecord> foodRecords,
  DietAnalysisType analysisType,
})>((ref) {
  return ({
    required List<FoodRecord> foodRecords,
    DietAnalysisType analysisType = DietAnalysisType.comprehensive,
  }) async {
    final service = ref.read(currentAIServiceProvider);
    
    if (service == null || !service.isAvailable) {
      return DietAnalysisResponse(
        success: false,
        error: 'AI服务不可用',
      );
    }
    
    return await service.analyzeDiet(
      foodRecords: foodRecords,
      analysisType: analysisType,
    );
  };
});

/// 食谱生成提供者
final recipeGeneratorProvider = Provider<Future<RecipeResponse> Function({
  required RecipeRequirements requirements,
})>((ref) {
  return ({
    required RecipeRequirements requirements,
  }) async {
    final service = ref.read(currentAIServiceProvider);
    
    if (service == null || !service.isAvailable) {
      return RecipeResponse(
        success: false,
        error: 'AI服务不可用',
      );
    }
    
    return await service.generateRecipe(requirements: requirements);
  };
});

/// AI聊天流提供者
final aiChatStreamProvider = Provider<Stream<String> Function({
  required List<ChatMessage> messages,
  required AIAssistantType assistantType,
})>((ref) {
  return ({
    required List<ChatMessage> messages,
    required AIAssistantType assistantType,
  }) {
    final service = ref.read(currentAIServiceProvider);
    
    if (service == null || !service.isAvailable) {
      return Stream.fromIterable(['AI服务不可用']);
    }
    
    return service.streamChat(
      messages: messages,
      assistantType: assistantType,
    );
  };
});

/// AI服务切换通知器
class AIServiceSwitchNotifier extends StateNotifier<AsyncValue<bool>> {
  AIServiceSwitchNotifier(this._manager) : super(const AsyncValue.data(false));
  
  final AIServiceManager _manager;
  
  Future<void> switchToProvider(String providerName) async {
    state = const AsyncValue.loading();
    
    try {
      final success = await _manager.switchToProvider(providerName);
      state = AsyncValue.data(success);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> reloadCurrentService() async {
    final currentProvider = _manager.currentProviderName;
    if (currentProvider != null) {
      await switchToProvider(currentProvider);
    }
  }
  
  Future<void> testService(String providerName) async {
    state = const AsyncValue.loading();
    
    try {
      final success = await _manager.testServiceConnection(providerName);
      state = AsyncValue.data(success);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// AI服务切换提供者
final aiServiceSwitchProvider = StateNotifierProvider<AIServiceSwitchNotifier, AsyncValue<bool>>((ref) {
  final manager = ref.watch(aiServiceManagerProvider);
  return AIServiceSwitchNotifier(manager);
});

/// AI服务配置提供者
final aiServiceConfigProvider = StateProvider<AIServiceConfig>((ref) {
  return AIServiceConfig(
    provider: 'mock',
    settings: {},
  );
});

/// AI服务初始化提供者
final aiServiceInitializationProvider = FutureProvider<bool>((ref) async {
  final manager = ref.watch(aiServiceManagerProvider);
  
  try {
    await manager.initialize();
    return true;
  } catch (e) {
    return false;
  }
});

/// AI服务能力检查提供者
final aiServiceCapabilitiesProvider = Provider<AICapabilities?>((ref) {
  final service = ref.watch(currentAIServiceProvider);
  return service?.capabilities;
});

/// 特定AI功能可用性检查提供者族
final nutritionPlanningAvailableProvider = Provider<bool>((ref) {
  final capabilities = ref.watch(aiServiceCapabilitiesProvider);
  return capabilities?.supportsNutritionPlanning ?? false;
});

final consultationReplyAvailableProvider = Provider<bool>((ref) {
  final capabilities = ref.watch(aiServiceCapabilitiesProvider);
  return capabilities?.supportsConsultationReply ?? false;
});

final dietAnalysisAvailableProvider = Provider<bool>((ref) {
  final capabilities = ref.watch(aiServiceCapabilitiesProvider);
  return capabilities?.supportsDietAnalysis ?? false;
});

final recipeGenerationAvailableProvider = Provider<bool>((ref) {
  final capabilities = ref.watch(aiServiceCapabilitiesProvider);
  return capabilities?.supportsRecipeGeneration ?? false;
});

final streamingChatAvailableProvider = Provider<bool>((ref) {
  final capabilities = ref.watch(aiServiceCapabilitiesProvider);
  return capabilities?.supportsStreamingChat ?? false;
});

/// AI服务使用统计提供者（可选）
class AIServiceUsageNotifier extends StateNotifier<Map<String, int>> {
  AIServiceUsageNotifier() : super({});
  
  void incrementUsage(String serviceType) {
    state = {
      ...state,
      serviceType: (state[serviceType] ?? 0) + 1,
    };
  }
  
  void resetUsage() {
    state = {};
  }
  
  int getUsageCount(String serviceType) {
    return state[serviceType] ?? 0;
  }
}

final aiServiceUsageProvider = StateNotifierProvider<AIServiceUsageNotifier, Map<String, int>>((ref) {
  return AIServiceUsageNotifier();
});

/// AI服务错误处理提供者
class AIServiceErrorNotifier extends StateNotifier<List<String>> {
  AIServiceErrorNotifier() : super([]);
  
  void addError(String error) {
    state = [...state, error];
  }
  
  void clearErrors() {
    state = [];
  }
  
  void removeError(int index) {
    if (index >= 0 && index < state.length) {
      state = [...state]..removeAt(index);
    }
  }
}

final aiServiceErrorProvider = StateNotifierProvider<AIServiceErrorNotifier, List<String>>((ref) {
  return AIServiceErrorNotifier();
});

/// AI服务监控提供者（定期检查服务状态）
final aiServiceMonitorProvider = StreamProvider<Map<String, bool>>((ref) {
  final manager = ref.watch(aiServiceManagerProvider);
  
  return Stream.periodic(const Duration(minutes: 5), (count) async {
    try {
      return await manager.getServiceHealthStatus();
    } catch (e) {
      return <String, bool>{};
    }
  }).asyncMap((future) => future);
});

/// AI服务配置更新提供者
class AIServiceConfigNotifier extends StateNotifier<AIServiceConfig> {
  AIServiceConfigNotifier(this._manager) : super(AIServiceConfig(
    provider: 'mock',
    settings: {},
  ));
  
  final AIServiceManager _manager;
  
  Future<void> updateProvider(String provider) async {
    state = state.copyWith(provider: provider);
    await _manager.switchToProvider(provider);
  }
  
  void updateSettings(Map<String, dynamic> settings) {
    state = state.copyWith(settings: settings);
  }
  
  void updateAutoSwitch(bool autoSwitch) {
    state = state.copyWith(autoSwitch: autoSwitch);
  }
  
  void updateFallbackProviders(List<String> fallbackProviders) {
    state = state.copyWith(fallbackProviders: fallbackProviders);
  }
}

final aiServiceConfigNotifierProvider = StateNotifierProvider<AIServiceConfigNotifier, AIServiceConfig>((ref) {
  final manager = ref.watch(aiServiceManagerProvider);
  return AIServiceConfigNotifier(manager);
});

