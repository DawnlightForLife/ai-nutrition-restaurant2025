import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/nutrition_profile_model.dart';
import '../../config/api_config.dart';
import '../auth_service.dart';

class NutritionProfileApiService {
  final String baseUrl = ApiConfig.baseUrl;
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // 获取当前用户的所有营养档案
  Future<List<NutritionProfile>> getUserProfiles(String userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/nutrition/nutrition-profiles/user/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['profiles'] != null) {
          final List<dynamic> profilesJson = data['profiles'];
          return profilesJson
              .map((json) => NutritionProfile.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? '获取档案列表失败');
        }
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? '请求失败');
      }
    } catch (e) {
      print('Error fetching user profiles: $e');
      rethrow;
    }
  }

  // 获取单个营养档案详情
  Future<NutritionProfile> getProfileById(String profileId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/nutrition/nutrition-profiles/$profileId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['profile'] != null) {
          return NutritionProfile.fromJson(data['profile']);
        } else {
          throw Exception(data['message'] ?? '获取档案详情失败');
        }
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? '请求失败');
      }
    } catch (e) {
      print('Error fetching profile by id: $e');
      rethrow;
    }
  }

  // 创建新的营养档案
  Future<NutritionProfile> createProfile(NutritionProfile profile) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/nutrition/nutrition-profiles'),
        headers: headers,
        body: json.encode(profile.toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['profile'] != null) {
          return NutritionProfile.fromJson(data['profile']);
        } else {
          throw Exception(data['message'] ?? '创建档案失败');
        }
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? '请求失败');
      }
    } catch (e) {
      print('Error creating profile: $e');
      rethrow;
    }
  }

  // 更新营养档案
  Future<NutritionProfile> updateProfile(String profileId, NutritionProfile profile) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/api/nutrition/nutrition-profiles/$profileId'),
        headers: headers,
        body: json.encode(profile.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['profile'] != null) {
          return NutritionProfile.fromJson(data['profile']);
        } else {
          throw Exception(data['message'] ?? '更新档案失败');
        }
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? '请求失败');
      }
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  // 删除营养档案
  Future<void> deleteProfile(String profileId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/api/nutrition/nutrition-profiles/$profileId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] != true) {
          throw Exception(data['message'] ?? '删除档案失败');
        }
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? '请求失败');
      }
    } catch (e) {
      print('Error deleting profile: $e');
      rethrow;
    }
  }

  // 设置为主档案
  Future<NutritionProfile> setPrimaryProfile(String profileId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/api/nutrition/nutrition-profiles/$profileId/primary'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['profile'] != null) {
          return NutritionProfile.fromJson(data['profile']);
        } else {
          throw Exception(data['message'] ?? '设置主档案失败');
        }
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? '请求失败');
      }
    } catch (e) {
      print('Error setting primary profile: $e');
      rethrow;
    }
  }

  // 获取档案完成度统计
  Future<Map<String, dynamic>> getCompletionStats() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/nutrition/nutrition-profiles/stats/completion'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        } else {
          throw Exception(data['message'] ?? '获取完成度统计失败');
        }
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? '请求失败');
      }
    } catch (e) {
      print('Error fetching completion stats: $e');
      rethrow;
    }
  }

  // 验证档案数据
  Future<Map<String, dynamic>> validateProfile(Map<String, dynamic> profileData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/nutrition/nutrition-profiles/validate'),
        headers: headers,
        body: json.encode(profileData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return {
            'isValid': data['isValid'],
            'errors': data['errors'] ?? [],
          };
        } else {
          throw Exception(data['message'] ?? '验证失败');
        }
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? '请求失败');
      }
    } catch (e) {
      print('Error validating profile: $e');
      rethrow;
    }
  }
}