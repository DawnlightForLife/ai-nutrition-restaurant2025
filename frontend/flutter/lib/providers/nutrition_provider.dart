import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/nutrition_profile.dart';
import '../constants/api.dart';

class NutritionProvider with ChangeNotifier {
  List<NutritionProfile> _profiles = [];
  bool _isLoading = false;
  String? _error;

  List<NutritionProfile> get profiles => _profiles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 根据用户ID获取营养档案列表
  Future<void> fetchProfiles(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/profiles?ownerId=$userId');
      
      print('获取营养档案URL: $url');
      
      final response = await http.get(url)
          .timeout(Duration(seconds: ApiConstants.connectionTimeout));
      
      print('响应状态码: ${response.statusCode}');
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        final List<dynamic> profilesData = data['profiles'];
        _profiles = profilesData.map((profile) => NutritionProfile.fromJson(profile)).toList();
        _error = null;
      } else {
        _error = data['message'] ?? '获取营养档案失败';
        _profiles = [];
      }
    } catch (e) {
      print('获取营养档案出错: $e');
      _error = '无法连接到服务器，请检查网络连接';
      _profiles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 创建新的营养档案
  Future<bool> createProfile(String token, Map<String, dynamic> profileData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/profiles');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(profileData),
      ).timeout(Duration(seconds: ApiConstants.connectionTimeout));

      final data = json.decode(response.body);
      
      if (response.statusCode == 201 && data['success'] == true) {
        // 创建成功后刷新列表
        final newProfile = NutritionProfile.fromJson(data['profile']);
        _profiles.insert(0, newProfile);
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = data['message'] ?? '创建营养档案失败';
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('创建营养档案出错: $e');
      _error = '无法连接到服务器，请检查网络连接';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 更新营养档案
  Future<bool> updateProfile(String token, String profileId, Map<String, dynamic> profileData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/profiles/$profileId');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(profileData),
      ).timeout(Duration(seconds: ApiConstants.connectionTimeout));

      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        // 更新成功后更新本地数据
        final updatedProfile = NutritionProfile.fromJson(data['profile']);
        final index = _profiles.indexWhere((p) => p.id == profileId);
        if (index != -1) {
          _profiles[index] = updatedProfile;
        }
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = data['message'] ?? '更新营养档案失败';
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('更新营养档案出错: $e');
      _error = '无法连接到服务器，请检查网络连接';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 删除营养档案
  Future<bool> deleteProfile(String token, String profileId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/profiles/$profileId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: ApiConstants.connectionTimeout));

      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        // 删除成功后更新本地数据
        _profiles.removeWhere((p) => p.id == profileId);
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = data['message'] ?? '删除营养档案失败';
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('删除营养档案出错: $e');
      _error = '无法连接到服务器，请检查网络连接';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 清除错误信息
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 