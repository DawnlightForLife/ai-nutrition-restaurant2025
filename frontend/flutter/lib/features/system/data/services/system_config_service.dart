import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../domain/entities/system_config.dart';
import '../datasources/system_config_remote_datasource.dart';
import '../models/system_config_model.dart';

/// 系统配置服务
class SystemConfigService {
  final SystemConfigRemoteDataSource _remoteDataSource;
  
  // 缓存配置
  final Map<String, dynamic> _configCache = {};
  DateTime? _lastFetchTime;
  static const Duration _cacheExpiry = Duration(minutes: 5);
  
  SystemConfigService(this._remoteDataSource);
  
  /// 清除缓存
  void clearCache() {
    _configCache.clear();
    _lastFetchTime = null;
  }
  
  /// 检查缓存是否有效
  bool _isCacheValid() {
    if (_lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < _cacheExpiry;
  }
  
  /// 获取认证功能配置
  Future<Map<String, dynamic>> getCertificationConfigs({bool forceRefresh = false}) async {
    try {
      // 检查缓存
      if (!forceRefresh && _isCacheValid() && _configCache.isNotEmpty) {
        final certConfigs = <String, dynamic>{};
        for (final key in [
          CertificationConfigKeys.merchantCertificationEnabled,
          CertificationConfigKeys.nutritionistCertificationEnabled,
          CertificationConfigKeys.merchantCertificationMode,
          CertificationConfigKeys.nutritionistCertificationMode,
        ]) {
          if (_configCache.containsKey(key)) {
            certConfigs[key] = _configCache[key];
          }
        }
        if (certConfigs.length == 4) {
          return certConfigs;
        }
      }
      
      // 从服务器获取
      final configs = await _remoteDataSource.getCertificationConfigs();
      
      // 更新缓存
      _configCache.addAll(configs);
      _lastFetchTime = DateTime.now();
      
      return configs;
    } catch (e) {
      print('[SystemConfigService] 获取认证配置失败: $e');
      // 返回默认值
      return {
        CertificationConfigKeys.merchantCertificationEnabled: false,
        CertificationConfigKeys.nutritionistCertificationEnabled: false,
        CertificationConfigKeys.merchantCertificationMode: 'contact',
        CertificationConfigKeys.nutritionistCertificationMode: 'contact',
      };
    }
  }
  
  /// 检查商家认证是否启用
  Future<bool> isMerchantCertificationEnabled() async {
    final configs = await getCertificationConfigs();
    return configs[CertificationConfigKeys.merchantCertificationEnabled] == true;
  }
  
  /// 检查营养师认证是否启用
  Future<bool> isNutritionistCertificationEnabled() async {
    final configs = await getCertificationConfigs();
    return configs[CertificationConfigKeys.nutritionistCertificationEnabled] == true;
  }
  
  /// 获取商家认证模式
  Future<CertificationMode> getMerchantCertificationMode() async {
    final configs = await getCertificationConfigs();
    final mode = configs[CertificationConfigKeys.merchantCertificationMode] as String?;
    return CertificationMode.fromString(mode ?? 'contact');
  }
  
  /// 获取营养师认证模式
  Future<CertificationMode> getNutritionistCertificationMode() async {
    final configs = await getCertificationConfigs();
    final mode = configs[CertificationConfigKeys.nutritionistCertificationMode] as String?;
    return CertificationMode.fromString(mode ?? 'contact');
  }
  
  /// 获取公开配置
  Future<Map<String, dynamic>> getPublicConfigs() async {
    try {
      final configs = await _remoteDataSource.getPublicConfigs();
      
      // 更新缓存
      _configCache.addAll(configs);
      _lastFetchTime = DateTime.now();
      
      return configs;
    } catch (e) {
      print('[SystemConfigService] 获取公开配置失败: $e');
      return {};
    }
  }
  
  /// 获取单个配置值
  Future<dynamic> getConfigValue(String key, {dynamic defaultValue}) async {
    try {
      // 先检查缓存
      if (_isCacheValid() && _configCache.containsKey(key)) {
        return _configCache[key];
      }
      
      // 从服务器获取
      final config = await _remoteDataSource.getConfig(key);
      
      // 更新缓存
      _configCache[key] = config.value;
      
      return config.value;
    } catch (e) {
      print('[SystemConfigService] 获取配置值失败: $key, $e');
      return defaultValue;
    }
  }
  
  // ========== 管理后台功能 ==========
  
  /// 获取所有配置
  Future<List<SystemConfig>> getAllConfigs({
    String? category,
    bool? isPublic,
    bool? isEditable,
  }) async {
    try {
      final models = await _remoteDataSource.getAllConfigs(
        category: category,
        isPublic: isPublic,
        isEditable: isEditable,
      );
      
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      print('[SystemConfigService] 获取所有配置失败: $e');
      rethrow;
    }
  }
  
  /// 更新配置
  Future<SystemConfig> updateConfig(String key, dynamic value) async {
    try {
      final model = await _remoteDataSource.updateConfig(key, value);
      
      // 更新缓存
      _configCache[key] = value;
      
      return model.toEntity();
    } catch (e) {
      print('[SystemConfigService] 更新配置失败: $key, $e');
      rethrow;
    }
  }
  
  /// 批量更新认证配置
  Future<Map<String, dynamic>> updateCertificationConfigs(Map<String, dynamic> configs) async {
    try {
      final result = await _remoteDataSource.updateCertificationConfigs(configs);
      
      // 更新缓存
      _configCache.addAll(result);
      
      return result;
    } catch (e) {
      print('[SystemConfigService] 批量更新认证配置失败: $e');
      rethrow;
    }
  }
  
  /// 创建配置
  Future<SystemConfig> createConfig(SystemConfig config) async {
    try {
      final model = SystemConfigModel.fromEntity(config);
      final createdModel = await _remoteDataSource.createConfig(model);
      
      // 更新缓存
      _configCache[config.key] = config.value;
      
      return createdModel.toEntity();
    } catch (e) {
      print('[SystemConfigService] 创建配置失败: $e');
      rethrow;
    }
  }
  
  /// 删除配置
  Future<void> deleteConfig(String key) async {
    try {
      await _remoteDataSource.deleteConfig(key);
      
      // 从缓存中移除
      _configCache.remove(key);
    } catch (e) {
      print('[SystemConfigService] 删除配置失败: $key, $e');
      rethrow;
    }
  }
  
  /// 初始化默认配置
  Future<void> initializeDefaults() async {
    try {
      await _remoteDataSource.initializeDefaults();
      
      // 清除缓存，强制重新加载
      clearCache();
    } catch (e) {
      print('[SystemConfigService] 初始化默认配置失败: $e');
      rethrow;
    }
  }
}

/// 系统配置服务提供者
final systemConfigServiceProvider = Provider<SystemConfigService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = SystemConfigRemoteDataSourceImpl(apiClient);
  return SystemConfigService(remoteDataSource);
});