import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../../domain/common/failures/failure.dart';
import '../../infrastructure/dtos/nutrition_profile_model.dart';
import '../../core/network/dio_client.dart';

/// 营养相关API服务
class NutritionApiService {
  final Dio _dio = DioClient.instance.dio;
  
  /// 获取用户的营养档案
  Future<NutritionProfile?> getUserProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/nutrition/profile');
      
      if (response.data == null || response.data?['success'] == false) {
        return null;
      }
      
      final data = response.data?['profile'] as Map<String, dynamic>?;
      if (data == null) {
        return null;
      }
      
      return NutritionProfile.fromJson(data);
    } catch (e) {
      print('获取营养档案失败: $e');
      return null;
    }
  }
  
  /// 创建营养档案
  Future<NutritionProfileResponse> createProfile(NutritionProfile profile) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/nutrition/profile',
        data: profile.toJson(),
      );
      
      return NutritionProfileResponse.fromJson(response.data!);
    } catch (e) {
      return NutritionProfileResponse(
        success: false,
        message: '创建档案失败: $e',
      );
    }
  }
  
  /// 更新营养档案
  Future<NutritionProfileResponse> updateProfile(String id, NutritionProfile profile) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/nutrition/profile/$id',
        data: profile.toJson(),
      );
      
      return NutritionProfileResponse.fromJson(response.data!);
    } catch (e) {
      return NutritionProfileResponse(
        success: false,
        message: '更新档案失败: $e',
      );
    }
  }
  
  /// 获取营养档案完成度统计
  Future<CompletionStats?> getCompletionStats() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/nutrition/profile/completion');
      
      if (response.data == null || response.data?['success'] == false) {
        return null;
      }
      
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        return null;
      }
      
      return CompletionStats.fromJson(data);
    } catch (e) {
      print('获取档案完成度统计失败: $e');
      return null;
    }
  }
  
  /// 验证营养档案数据
  Future<Map<String, dynamic>> validateProfile(NutritionProfile profile) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/nutrition/profile/validate',
        data: profile.toJson(),
      );
      
      return response.data ?? {'success': false, 'isValid': false};
    } catch (e) {
      return {
        'success': false,
        'isValid': false,
        'errors': [e.toString()]
      };
    }
  }
  
  /// 获取用于AI推荐的数据
  Future<Map<String, dynamic>?> getProfileForAI() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/nutrition/profile/ai-data');
      
      if (response.data == null || response.data?['success'] == false) {
        return null;
      }
      
      return response.data?['data'] as Map<String, dynamic>?;
    } catch (e) {
      print('获取AI推荐数据失败: $e');
      return null;
    }
  }
} 