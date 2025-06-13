import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/system_config_service.dart';
import '../../domain/entities/system_config.dart';

/// 认证功能配置状态
class CertificationConfigState {
  final bool merchantEnabled;
  final bool nutritionistEnabled;
  final CertificationMode merchantMode;
  final CertificationMode nutritionistMode;
  final bool isLoading;
  final String? error;
  
  const CertificationConfigState({
    this.merchantEnabled = false,
    this.nutritionistEnabled = false,
    this.merchantMode = CertificationMode.contact,
    this.nutritionistMode = CertificationMode.contact,
    this.isLoading = false,
    this.error,
  });
  
  CertificationConfigState copyWith({
    bool? merchantEnabled,
    bool? nutritionistEnabled,
    CertificationMode? merchantMode,
    CertificationMode? nutritionistMode,
    bool? isLoading,
    String? error,
  }) {
    return CertificationConfigState(
      merchantEnabled: merchantEnabled ?? this.merchantEnabled,
      nutritionistEnabled: nutritionistEnabled ?? this.nutritionistEnabled,
      merchantMode: merchantMode ?? this.merchantMode,
      nutritionistMode: nutritionistMode ?? this.nutritionistMode,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 认证功能配置Provider
final certificationConfigProvider = StateNotifierProvider<CertificationConfigNotifier, CertificationConfigState>((ref) {
  final service = ref.watch(systemConfigServiceProvider);
  return CertificationConfigNotifier(service);
});

/// 认证功能配置状态管理器
class CertificationConfigNotifier extends StateNotifier<CertificationConfigState> {
  final SystemConfigService _service;
  
  CertificationConfigNotifier(this._service) : super(const CertificationConfigState()) {
    // 初始化时加载配置
    loadConfigs();
  }
  
  /// 加载认证功能配置
  Future<void> loadConfigs({bool forceRefresh = false}) async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final configs = await _service.getCertificationConfigs(forceRefresh: forceRefresh);
      
      state = state.copyWith(
        merchantEnabled: configs[CertificationConfigKeys.merchantCertificationEnabled] == true,
        nutritionistEnabled: configs[CertificationConfigKeys.nutritionistCertificationEnabled] == true,
        merchantMode: CertificationMode.fromString(
          configs[CertificationConfigKeys.merchantCertificationMode] ?? 'contact'
        ),
        nutritionistMode: CertificationMode.fromString(
          configs[CertificationConfigKeys.nutritionistCertificationMode] ?? 'contact'
        ),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// 刷新配置
  Future<void> refreshConfigs() async {
    await loadConfigs(forceRefresh: true);
  }
}

/// 商家认证是否启用
final isMerchantCertificationEnabledProvider = Provider<bool>((ref) {
  final configState = ref.watch(certificationConfigProvider);
  return configState.merchantEnabled;
});

/// 营养师认证是否启用
final isNutritionistCertificationEnabledProvider = Provider<bool>((ref) {
  final configState = ref.watch(certificationConfigProvider);
  return configState.nutritionistEnabled;
});

/// 商家认证模式
final merchantCertificationModeProvider = Provider<CertificationMode>((ref) {
  final configState = ref.watch(certificationConfigProvider);
  return configState.merchantMode;
});

/// 营养师认证模式
final nutritionistCertificationModeProvider = Provider<CertificationMode>((ref) {
  final configState = ref.watch(certificationConfigProvider);
  return configState.nutritionistMode;
});

/// 联系信息配置Provider
final contactInfoProvider = FutureProvider<Map<String, String>>((ref) async {
  final service = ref.watch(systemConfigServiceProvider);
  // 每次都强制从后端拉取最新配置
  final configs = await service.getPublicConfigs(forceRefresh: true);
  return {
    'wechat': configs['certification_contact_wechat'] ?? 'AIHealth2025',
    'phone': configs['certification_contact_phone'] ?? '400-123-4567',
    'email': configs['certification_contact_email'] ?? 'cert@aihealth.com',
  };
});

/// 系统配置管理Provider（管理后台使用）
final systemConfigManagerProvider = StateNotifierProvider<SystemConfigManager, AsyncValue<List<SystemConfig>>>((ref) {
  final service = ref.watch(systemConfigServiceProvider);
  return SystemConfigManager(service);
});

/// 系统配置管理器
class SystemConfigManager extends StateNotifier<AsyncValue<List<SystemConfig>>> {
  final SystemConfigService _service;
  
  SystemConfigManager(this._service) : super(const AsyncValue.loading());
  
  /// 加载所有配置
  Future<void> loadAllConfigs({
    String? category,
    bool? isPublic,
    bool? isEditable,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final configs = await _service.getAllConfigs(
        category: category,
        isPublic: isPublic,
        isEditable: isEditable,
      );
      state = AsyncValue.data(configs);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  /// 更新配置
  Future<void> updateConfig(String key, dynamic value) async {
    try {
      await _service.updateConfig(key, value);
      // 重新加载配置
      await loadAllConfigs();
    } catch (e) {
      // 处理错误
      print('[SystemConfigManager] 更新配置失败: $e');
      rethrow;
    }
  }
  
  /// 批量更新认证配置
  Future<void> updateCertificationConfigs(Map<String, dynamic> configs) async {
    try {
      await _service.updateCertificationConfigs(configs);
      // 重新加载配置
      await loadAllConfigs();
    } catch (e) {
      print('[SystemConfigManager] 批量更新认证配置失败: $e');
      rethrow;
    }
  }
  
  /// 创建配置
  Future<void> createConfig(SystemConfig config) async {
    try {
      await _service.createConfig(config);
      // 重新加载配置
      await loadAllConfigs();
    } catch (e) {
      print('[SystemConfigManager] 创建配置失败: $e');
      rethrow;
    }
  }
  
  /// 删除配置
  Future<void> deleteConfig(String key) async {
    try {
      await _service.deleteConfig(key);
      // 重新加载配置
      await loadAllConfigs();
    } catch (e) {
      print('[SystemConfigManager] 删除配置失败: $e');
      rethrow;
    }
  }
  
  /// 初始化默认配置
  Future<void> initializeDefaults() async {
    try {
      await _service.initializeDefaults();
      // 重新加载配置
      await loadAllConfigs();
    } catch (e) {
      print('[SystemConfigManager] 初始化默认配置失败: $e');
      rethrow;
    }
  }
}