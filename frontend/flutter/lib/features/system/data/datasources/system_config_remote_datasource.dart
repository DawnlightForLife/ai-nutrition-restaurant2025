import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/system_config_model.dart';

/// 系统配置远程数据源接口
abstract class SystemConfigRemoteDataSource {
  /// 获取公开配置
  Future<Map<String, dynamic>> getPublicConfigs();
  
  /// 获取认证功能配置
  Future<Map<String, dynamic>> getCertificationConfigs();
  
  /// 获取所有配置（管理后台）
  Future<List<SystemConfigModel>> getAllConfigs({
    String? category,
    bool? isPublic,
    bool? isEditable,
  });
  
  /// 获取单个配置（管理后台）
  Future<SystemConfigModel> getConfig(String key);
  
  /// 更新配置（管理后台）
  Future<SystemConfigModel> updateConfig(String key, dynamic value);
  
  /// 批量更新认证配置（管理后台）
  Future<Map<String, dynamic>> updateCertificationConfigs(Map<String, dynamic> configs);
  
  /// 创建配置（管理后台）
  Future<SystemConfigModel> createConfig(SystemConfigModel config);
  
  /// 删除配置（管理后台）
  Future<void> deleteConfig(String key);
  
  /// 初始化默认配置（管理后台）
  Future<void> initializeDefaults();
}

/// 系统配置远程数据源实现
class SystemConfigRemoteDataSourceImpl implements SystemConfigRemoteDataSource {
  final ApiClient _apiClient;
  
  SystemConfigRemoteDataSourceImpl(this._apiClient);
  
  @override
  Future<Map<String, dynamic>> getPublicConfigs() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.systemConfigPublic,
      );
      
      if (response.data != null && response.data!['success'] == true) {
        return response.data!['data'] as Map<String, dynamic>;
      }
      
      throw Exception('获取公开配置失败');
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  @override
  Future<Map<String, dynamic>> getCertificationConfigs() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.systemConfigCertification,
      );
      
      if (response.data != null && response.data!['success'] == true) {
        return response.data!['data'] as Map<String, dynamic>;
      }
      
      throw Exception('获取认证功能配置失败');
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  @override
  Future<List<SystemConfigModel>> getAllConfigs({
    String? category,
    bool? isPublic,
    bool? isEditable,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null) queryParams['category'] = category;
      if (isPublic != null) queryParams['isPublic'] = isPublic.toString();
      if (isEditable != null) queryParams['isEditable'] = isEditable.toString();
      
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.systemConfig,
        queryParameters: queryParams,
      );
      
      if (response.data != null && response.data!['success'] == true) {
        final List<dynamic> data = response.data!['data'] as List<dynamic>;
        return data.map((e) => SystemConfigModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      
      throw Exception('获取所有配置失败');
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  @override
  Future<SystemConfigModel> getConfig(String key) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '${ApiEndpoints.systemConfig}/$key',
      );
      
      if (response.data != null && response.data!['success'] == true) {
        final data = response.data!['data'] as Map<String, dynamic>;
        return SystemConfigModel.fromJson({
          'key': data['key'],
          'value': data['value'],
        });
      }
      
      throw Exception('获取配置失败');
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  @override
  Future<SystemConfigModel> updateConfig(String key, dynamic value) async {
    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        '${ApiEndpoints.systemConfig}/$key',
        data: {'value': value},
      );
      
      if (response.data != null && response.data!['success'] == true) {
        return SystemConfigModel.fromJson(response.data!['data'] as Map<String, dynamic>);
      }
      
      throw Exception('更新配置失败');
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  @override
  Future<Map<String, dynamic>> updateCertificationConfigs(Map<String, dynamic> configs) async {
    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        ApiEndpoints.systemConfigCertification,
        data: configs,
      );
      
      if (response.data != null && response.data!['success'] == true) {
        return response.data!['data'] as Map<String, dynamic>;
      }
      
      throw Exception('更新认证配置失败');
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  @override
  Future<SystemConfigModel> createConfig(SystemConfigModel config) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.systemConfig,
        data: config.toJson(),
      );
      
      if (response.data != null && response.data!['success'] == true) {
        return SystemConfigModel.fromJson(response.data!['data'] as Map<String, dynamic>);
      }
      
      throw Exception('创建配置失败');
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  @override
  Future<void> deleteConfig(String key) async {
    try {
      final response = await _apiClient.delete<Map<String, dynamic>>(
        '${ApiEndpoints.systemConfig}/$key',
      );
      
      if (response.data == null || response.data!['success'] != true) {
        throw Exception('删除配置失败');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  @override
  Future<void> initializeDefaults() async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '${ApiEndpoints.systemConfig}/initialize',
      );
      
      if (response.data == null || response.data!['success'] != true) {
        throw Exception('初始化默认配置失败');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      final message = error.response?.data?['message'] ?? error.message;
      return Exception(message);
    }
    return Exception(error.toString());
  }
}