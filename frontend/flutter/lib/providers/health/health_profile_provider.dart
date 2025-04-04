import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../models/health/nutrition_profile_model.dart';
import '../../services/health/health_profile_service.dart';
import '../../services/health/health_data_service.dart';
import '../../services/api_service.dart';
import '../../services/core/auth_service.dart';
import '../core/auth_provider.dart';

enum HealthProfileStatus {
  initial,
  loading,
  loaded,
  error,
}

class HealthProfileProvider with ChangeNotifier {
  final HealthProfileService _healthService;
  final HealthDataService _healthDataService;
  final AuthProvider _authProvider;
  
  HealthProfileStatus _status = HealthProfileStatus.initial;
  String? _errorMessage;
  List<NutritionProfile> _profiles = [];
  NutritionProfile? _selectedProfile;
  bool _isCreating = false;
  
  HealthProfileProvider({
    required AuthProvider authProvider,
    required ApiService apiService,
  }) : _authProvider = authProvider,
       _healthService = HealthProfileService(
         apiService, 
         AuthService(apiService),
         authProvider
       ),
       _healthDataService = HealthDataService(apiService);
  
  // 获取状态
  HealthProfileStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<NutritionProfile> get profiles => _profiles;
  NutritionProfile? get selectedProfile => _selectedProfile;
  bool get isCreating => _isCreating;
  
  // 获取认证提供者
  AuthProvider get authProvider => _authProvider;
  
  // 设置创建模式
  void setCreatingMode(bool isCreating) {
    _isCreating = isCreating;
    notifyListeners();
  }
  
  // 选择当前档案
  void selectProfile(NutritionProfile? profile) {
    _selectedProfile = profile;
    notifyListeners();
  }
  
  // 重置错误状态
  void resetError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  /// 初始化方法
  Future<void> init() async {
    // 检查是否需要加载档案
    if (_authProvider.isAuthenticated && _profiles.isEmpty) {
      await fetchProfiles();
    }
  }
  
  /// 加载用户的所有档案
  Future<void> fetchProfiles() async {
    if (!_authProvider.isAuthenticated) {
      _errorMessage = '请先登录';
      _status = HealthProfileStatus.error;
      notifyListeners();
      return;
    }
    
    try {
      _status = HealthProfileStatus.loading;
      notifyListeners();
      
      final profiles = await _healthService.fetchProfilesByUserId();
      _profiles = profiles;
      
      if (_profiles.isNotEmpty && _selectedProfile == null) {
        _selectedProfile = _profiles.first;
      }
      
      _status = HealthProfileStatus.loaded;
      notifyListeners();
    } catch (e) {
      debugPrint('加载档案列表失败: $e');
      _status = HealthProfileStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  // 获取特定档案详情
  Future<void> loadProfileDetail(String profileId) async {
    if (!_authProvider.isAuthenticated) {
      _errorMessage = '请先登录';
      _status = HealthProfileStatus.error;
      notifyListeners();
      return;
    }
    
    try {
      _status = HealthProfileStatus.loading;
      notifyListeners();
      
      final profile = await _healthService.getProfileById(profileId);
      _selectedProfile = profile;
      _status = HealthProfileStatus.loaded;
      
      notifyListeners();
    } catch (e) {
      _status = HealthProfileStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  // 创建新档案
  Future<bool> createProfile(NutritionProfile profile) async {
    if (!_authProvider.isAuthenticated) {
      _errorMessage = '请先登录';
      _status = HealthProfileStatus.error;
      notifyListeners();
      return false;
    }
    
    try {
      _status = HealthProfileStatus.loading;
      notifyListeners();
      
      final userId = _authProvider.userId;
      if (userId == null) {
        throw Exception('用户ID不存在');
      }
      
      debugPrint('在Provider中创建档案，用户ID: $userId');
      
      // 添加用户ID
      final profileWithUserId = profile.copyWith(userId: userId);
      
      // 调用服务创建档案
      final result = await _healthService.createProfile(profileWithUserId);
      
      if (result['success'] == true && result['profile'] != null) {
        debugPrint('档案创建成功，返回数据: ${result['profile']}');
        final newProfile = NutritionProfile.fromJson(result['profile']);
        
        // 检查是否已存在同名档案，如果存在则替换
        final existingIndex = _profiles.indexWhere((p) => p.profileName == newProfile.profileName);
        if (existingIndex != -1) {
          _profiles[existingIndex] = newProfile;
        } else {
          _profiles.add(newProfile);
        }
        
        _selectedProfile = newProfile;
        _status = HealthProfileStatus.loaded;
        
        notifyListeners();
        
        // 创建后立即重新获取档案列表以确保同步
        fetchProfiles();
        
        return true;
      } else {
        // 创建失败
        final errorMessage = result['message'] ?? '创建档案失败';
        debugPrint('创建档案失败: $errorMessage');
        _errorMessage = errorMessage;
        _status = HealthProfileStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('创建档案过程中发生异常: $e');
      _status = HealthProfileStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // 更新档案
  Future<bool> updateProfile(String profileId, NutritionProfile updatedProfile) async {
    if (!_authProvider.isAuthenticated) {
      _errorMessage = '请先登录';
      _status = HealthProfileStatus.error;
      notifyListeners();
      return false;
    }
    
    try {
      _status = HealthProfileStatus.loading;
      notifyListeners();
      
      // 确保保留用户ID
      final userId = _authProvider.userId;
      final completeProfile = updatedProfile.copyWith(userId: userId);
      
      // 调用服务更新档案
      final result = await _healthService.updateProfile(profileId, completeProfile);
      
      if (result['success'] == true) {
        // 检查是否返回了档案数据
        if (result['profile'] != null) {
          NutritionProfile updatedProfileObj;
          if (result['profile'] is NutritionProfile) {
            updatedProfileObj = result['profile'];
          } else {
            updatedProfileObj = NutritionProfile.fromJson(result['profile']);
          }
          
          // 更新本地列表
          final index = _profiles.indexWhere((p) => p.id == profileId);
          if (index != -1) {
            _profiles[index] = updatedProfileObj;
          }
          
          // 如果正在更新的是选中的档案，更新选中档案
          if (_selectedProfile?.id == profileId) {
            _selectedProfile = updatedProfileObj;
          }
        }
        
        _status = HealthProfileStatus.loaded;
        notifyListeners();
        
        // 更新后立即重新获取档案列表以确保同步
        fetchProfiles();
        
        return true;
      } else {
        // 更新失败
        final errorMessage = result['message'] ?? '更新档案失败';
        debugPrint('更新档案失败: $errorMessage');
        _errorMessage = errorMessage;
        _status = HealthProfileStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('更新档案过程中发生异常: $e');
      _status = HealthProfileStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // 删除档案
  Future<bool> deleteProfile(String profileId) async {
    if (!_authProvider.isAuthenticated) {
      _errorMessage = '请先登录';
      _status = HealthProfileStatus.error;
      notifyListeners();
      return false;
    }
    
    try {
      _status = HealthProfileStatus.loading;
      notifyListeners();
      
      debugPrint('准备删除档案: $profileId');
      final success = await _healthService.deleteProfile(profileId);
      
      if (success) {
        debugPrint('档案删除成功，从列表中移除');
        // 从列表中移除
        _profiles.removeWhere((profile) => profile.id == profileId);
        
        // 如果删除的是当前选中的档案，重置选中档案
        if (_selectedProfile?.id == profileId) {
          _selectedProfile = _profiles.isNotEmpty ? _profiles.first : null;
        }
        
        _status = HealthProfileStatus.loaded;
        notifyListeners();
        
        // 删除后立即重新获取档案列表以确保同步
        fetchProfiles();
        
        return true;
      } else {
        debugPrint('档案删除返回失败');
        _status = HealthProfileStatus.error;
        _errorMessage = '删除档案失败，请重试';
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('删除档案异常: $e');
      _status = HealthProfileStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
