import 'package:dio/dio.dart';
import '../dtos/nutrition_profile_model.dart';
import '../../core/network/dio_client.dart';

class NutritionProfileApiService {
  final Dio _dio = DioClient.instance.dio;
  
  // 获取用户的营养档案
  Future<NutritionProfile?> getUserProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/nutrition-profiles/stats/completion');
      
      if (response.data?['success'] == true) {
        final profileId = response.data?['data']?['profileId'];
        if (profileId != null) {
          return await getProfileById(profileId);
        }
      }
      return null;
    } catch (e) {
      print('获取用户档案失败: $e');
      return null;
    }
  }
  
  // 根据ID获取档案
  Future<NutritionProfile> getProfileById(String profileId) async {
    final response = await _dio.get<Map<String, dynamic>>('/nutrition-profiles/$profileId');
    
    if (response.data?['success'] == true) {
      return NutritionProfile.fromJson(response.data?['profile'] as Map<String, dynamic>);
    }
    
    throw Exception(response.data?['message'] ?? '获取档案失败');
  }
  
  // 创建营养档案
  Future<NutritionProfileResponse> createProfile(NutritionProfile profile) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/nutrition-profiles',
      data: profile.toJson(),
    );
    
    return NutritionProfileResponse.fromJson(response.data as Map<String, dynamic>);
  }
  
  // 更新营养档案
  Future<NutritionProfileResponse> updateProfile(String profileId, NutritionProfile profile) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/nutrition-profiles/$profileId',
      data: profile.toJson(),
    );
    
    return NutritionProfileResponse.fromJson(response.data as Map<String, dynamic>);
  }
  
  // 获取完成度统计
  Future<CompletionStats> getCompletionStats() async {
    final response = await _dio.get<Map<String, dynamic>>('/nutrition-profiles/stats/completion');
    
    if (response.data?['success'] == true) {
      return CompletionStats.fromJson(response.data?['data'] as Map<String, dynamic>);
    }
    
    throw Exception(response.data?['message'] ?? '获取完成度统计失败');
  }
  
  // 验证档案数据
  Future<Map<String, dynamic>> validateProfile(NutritionProfile profile) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/nutrition-profiles/validate',
      data: profile.toJson(),
    );
    
    return response.data as Map<String, dynamic>;
  }
  
  // 获取AI推荐数据
  Future<Map<String, dynamic>> getProfileForAI() async {
    final response = await _dio.get<Map<String, dynamic>>('/nutrition-profiles/ai/data');
    
    if (response.data?['success'] == true) {
      return response.data?['data'] as Map<String, dynamic>;
    }
    
    throw Exception(response.data?['message'] ?? '获取AI数据失败');
  }
}