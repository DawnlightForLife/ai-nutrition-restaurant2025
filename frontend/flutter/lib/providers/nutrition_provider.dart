import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/nutrition_profile.dart';
import '../constants/api.dart';
import '../utils/api_helper.dart';
import '../utils/logger.dart';

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
      final url = '${ApiConstants.baseUrl}${ApiConstants.nutritionProfilesPath}?ownerId=$userId';
      
      Logger.i(Logger.NUTRITION, '获取营养档案列表，用户ID: $userId');
      
      final responseData = await ApiHelper.get(
        url,
        logPrefix: Logger.NUTRITION,
        timeout: ApiConstants.connectionTimeout,
      );
      
      if (responseData['success'] == true) {
        final List<dynamic> profilesData = responseData['profiles'];
        _profiles = profilesData.map((profile) => NutritionProfile.fromJson(profile)).toList();
        _error = null;
        Logger.i(Logger.NUTRITION, '成功获取${_profiles.length}个营养档案');
      } else {
        _error = responseData['message'] ?? '获取营养档案失败';
        _profiles = [];
        Logger.w(Logger.NUTRITION, '获取营养档案失败: $_error');
      }
    } catch (e) {
      Logger.e(Logger.NUTRITION, '获取营养档案出错', e);
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
      print('创建营养档案请求数据: ${jsonEncode(profileData)}');
      
      final url = '${ApiConstants.baseUrl}${ApiConstants.nutritionProfilesPath}';
      Logger.i(Logger.NUTRITION, '创建营养档案: ${profileData['name']}');
      
      final responseData = await ApiHelper.post(
        url,
        data: profileData,
        token: token,
        logPrefix: Logger.NUTRITION,
        timeout: ApiConstants.connectionTimeout,
      );

      if (responseData['success'] == true) {
        // 创建成功后刷新列表
        final newProfile = NutritionProfile.fromJson(responseData['profile']);
        _profiles.insert(0, newProfile);
        _error = null;
        Logger.i(Logger.NUTRITION, '创建档案成功: ${newProfile.id}');
        notifyListeners();
        return true;
      } else {
        _error = responseData['message'] ?? '创建营养档案失败';
        Logger.w(Logger.NUTRITION, '创建档案失败: $_error');
        notifyListeners();
        return false;
      }
    } catch (e) {
      Logger.e(Logger.NUTRITION, '创建营养档案出错', e);
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
      print('更新营养档案请求数据: ${jsonEncode(profileData)}');
      
      // 确保ownerId包含在URL参数中
      final ownerId = profileData['ownerId'];
      final url = '${ApiConstants.baseUrl}${ApiConstants.nutritionProfilesPath}/$profileId?ownerId=$ownerId';
      
      Logger.i(Logger.NUTRITION, '更新营养档案ID: $profileId, 名称: ${profileData['name']}');
      
      final responseData = await ApiHelper.put(
        url,
        data: profileData,
        token: token,
        logPrefix: Logger.NUTRITION,
        timeout: ApiConstants.connectionTimeout,
      );

      if (responseData['success'] == true) {
        // 更新成功后更新本地数据
        final updatedProfile = NutritionProfile.fromJson(responseData['profile']);
        final index = _profiles.indexWhere((p) => p.id == profileId);
        if (index != -1) {
          _profiles[index] = updatedProfile;
        }
        _error = null;
        Logger.i(Logger.NUTRITION, '更新档案成功: $profileId');
        notifyListeners();
        return true;
      } else {
        _error = responseData['message'] ?? '更新营养档案失败';
        Logger.w(Logger.NUTRITION, '更新档案失败: $_error');
        notifyListeners();
        return false;
      }
    } catch (e) {
      Logger.e(Logger.NUTRITION, '更新营养档案出错', e);
      _error = '无法连接到服务器，请检查网络连接';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 删除营养档案
  Future<bool> deleteProfile(String token, String profileId, {required String ownerId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final url = '${ApiConstants.baseUrl}${ApiConstants.nutritionProfilesPath}/$profileId?ownerId=$ownerId';
      Logger.i(Logger.NUTRITION, '删除营养档案ID: $profileId, 用户ID: $ownerId');
      
      final responseData = await ApiHelper.delete(
        url,
        token: token,
        logPrefix: Logger.NUTRITION,
        timeout: ApiConstants.connectionTimeout,
      );

      if (responseData['success'] == true) {
        // 删除成功后更新本地数据
        _profiles.removeWhere((p) => p.id == profileId);
        _error = null;
        Logger.i(Logger.NUTRITION, '删除档案成功: $profileId');
        notifyListeners();
        return true;
      } else {
        _error = responseData['message'] ?? '删除营养档案失败';
        Logger.w(Logger.NUTRITION, '删除档案失败: $_error');
        notifyListeners();
        return false;
      }
    } catch (e) {
      Logger.e(Logger.NUTRITION, '删除营养档案出错', e);
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