import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/health/health_data_model.dart';
import '../../models/health/nutrition_profile_model.dart';
import '../../models/api_response.dart';
import '../../models/result.dart';
import '../../utils/error_handler.dart';
import '../core/api_service.dart';
import '../../common/constants/api_constants.dart';

/// 健康数据服务
/// 提供与健康数据相关的API调用方法
class HealthDataService {
  final ApiService _apiService;
  
  HealthDataService(this._apiService);
  
  /// 获取单个健康数据
  Future<Result<HealthData>> getHealthData(String healthDataId) async {
    try {
      debugPrint('获取健康数据: $healthDataId');
      
      final response = await _apiService.get('${ApiConstants.healthData}/$healthDataId');
      final apiResponse = ApiResponse.fromJson(response);
      
      if (!apiResponse.success) {
        return Result.failure(apiResponse.message ?? '获取健康数据失败');
      }
      
      final healthData = HealthData.fromJson(apiResponse.data);
      return Result.success(healthData);
    } catch (e, stackTrace) {
      debugPrint('获取健康数据异常: $e\n$stackTrace');
      return Result.failure(GlobalErrorHandler.handleError(e).message);
    }
  }
  
  /// 获取用户所有健康数据
  Future<Result<List<HealthData>>> getUserHealthData({String? userId}) async {
    try {
      final url = userId != null ? '${ApiConstants.healthData}/user/$userId' : '${ApiConstants.healthData}/user';
      
      debugPrint('获取用户健康数据列表: $url');
      
      final response = await _apiService.get(url);
      final apiResponse = ApiResponse.fromJson(response);
      
      if (!apiResponse.success) {
        return Result.failure(apiResponse.message ?? '获取用户健康数据列表失败');
      }
      
      final List<dynamic> dataList = apiResponse.data;
      final List<HealthData> healthDataList = dataList
          .map((item) => HealthData.fromJson(item))
          .toList();
      
      return Result.success(healthDataList);
    } catch (e, stackTrace) {
      debugPrint('获取用户健康数据列表异常: $e\n$stackTrace');
      return Result.failure(GlobalErrorHandler.handleError(e).message);
    }
  }
  
  /// 创建健康数据
  Future<Result<HealthData>> createHealthData(HealthData healthData) async {
    try {
      debugPrint('创建健康数据: ${healthData.toJson()}');
      
      final response = await _apiService.post(
        ApiConstants.healthData,
        data: healthData.toJson(),
      );
      
      final apiResponse = ApiResponse.fromJson(response);
      
      if (!apiResponse.success) {
        return Result.failure(apiResponse.message ?? '创建健康数据失败');
      }
      
      final createdHealthData = HealthData.fromJson(apiResponse.data);
      return Result.success(createdHealthData);
    } catch (e, stackTrace) {
      debugPrint('创建健康数据异常: $e\n$stackTrace');
      return Result.failure(GlobalErrorHandler.handleError(e).message);
    }
  }
  
  /// 更新健康数据
  Future<Result<HealthData>> updateHealthData(String id, HealthData healthData) async {
    try {
      debugPrint('更新健康数据: $id, ${healthData.toJson()}');
      
      final response = await _apiService.put(
        '${ApiConstants.healthData}/$id',
        data: healthData.toJson(),
      );
      
      final apiResponse = ApiResponse.fromJson(response);
      
      if (!apiResponse.success) {
        return Result.failure(apiResponse.message ?? '更新健康数据失败');
      }
      
      final updatedHealthData = HealthData.fromJson(apiResponse.data);
      return Result.success(updatedHealthData);
    } catch (e, stackTrace) {
      debugPrint('更新健康数据异常: $e\n$stackTrace');
      return Result.failure(GlobalErrorHandler.handleError(e).message);
    }
  }
  
  /// 删除健康数据
  Future<Result<bool>> deleteHealthData(String id) async {
    try {
      debugPrint('删除健康数据: $id');
      
      final response = await _apiService.delete('${ApiConstants.healthData}/$id');
      final apiResponse = ApiResponse.fromJson(response);
      
      if (!apiResponse.success) {
        return Result.failure(apiResponse.message ?? '删除健康数据失败');
      }
      
      return Result.success(true);
    } catch (e, stackTrace) {
      debugPrint('删除健康数据异常: $e\n$stackTrace');
      return Result.failure(GlobalErrorHandler.handleError(e).message);
    }
  }
  
  /// 将健康数据同步到营养档案
  Future<Result<bool>> syncToNutritionProfile(String healthDataId, String nutritionProfileId) async {
    try {
      debugPrint('将健康数据同步到营养档案: $healthDataId, $nutritionProfileId');
      
      final response = await _apiService.post(
        '${ApiConstants.healthData}/$healthDataId/sync/$nutritionProfileId',
      );
      
      final apiResponse = ApiResponse.fromJson(response);
      
      if (!apiResponse.success) {
        return Result.failure(apiResponse.message ?? '同步健康数据到营养档案失败');
      }
      
      return Result.success(true);
    } catch (e, stackTrace) {
      debugPrint('同步健康数据到营养档案异常: $e\n$stackTrace');
      return Result.failure(GlobalErrorHandler.handleError(e).message);
    }
  }
  
  /// 从健康数据创建营养档案
  Future<Result<NutritionProfile>> createProfileFromHealthData(String healthDataId) async {
    try {
      debugPrint('从健康数据创建营养档案: $healthDataId');
      
      final response = await _apiService.post(
        '${ApiConstants.healthData}/$healthDataId/create-profile',
      );
      
      final apiResponse = ApiResponse.fromJson(response);
      
      if (!apiResponse.success) {
        return Result.failure(apiResponse.message ?? '从健康数据创建营养档案失败');
      }
      
      final profile = NutritionProfile.fromJson(apiResponse.data);
      return Result.success(profile);
    } catch (e, stackTrace) {
      debugPrint('从健康数据创建营养档案异常: $e\n$stackTrace');
      return Result.failure(GlobalErrorHandler.handleError(e).message);
    }
  }
  
  /// 分析健康数据
  Future<Result<Map<String, dynamic>>> analyzeHealthData(String healthDataId) async {
    try {
      debugPrint('分析健康数据: $healthDataId');
      
      final response = await _apiService.get('${ApiConstants.healthData}/$healthDataId/analyze');
      final apiResponse = ApiResponse.fromJson(response);
      
      if (!apiResponse.success) {
        return Result.failure(apiResponse.message ?? '分析健康数据失败');
      }
      
      return Result.success(apiResponse.data);
    } catch (e, stackTrace) {
      debugPrint('分析健康数据异常: $e\n$stackTrace');
      return Result.failure(GlobalErrorHandler.handleError(e).message);
    }
  }
  
  /// 缓存健康数据到本地
  Future<void> cacheHealthData(HealthData healthData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'health_data_${healthData.id}';
      final json = jsonEncode(healthData.toJson());
      await prefs.setString(key, json);
    } catch (e) {
      debugPrint('缓存健康数据到本地失败: $e');
    }
  }
  
  /// 从本地缓存获取健康数据
  Future<HealthData?> getHealthDataFromCache(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'health_data_$id';
      final json = prefs.getString(key);
      
      if (json == null) {
        return null;
      }
      
      return HealthData.fromJson(jsonDecode(json));
    } catch (e) {
      debugPrint('从本地缓存获取健康数据失败: $e');
      return null;
    }
  }
  
  /// 清除本地缓存的健康数据
  Future<void> clearCachedHealthData(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'health_data_$id';
      await prefs.remove(key);
    } catch (e) {
      debugPrint('清除本地缓存的健康数据失败: $e');
    }
  }
}
