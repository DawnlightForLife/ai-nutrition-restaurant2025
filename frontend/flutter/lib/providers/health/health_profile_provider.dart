import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../models/health/nutrition_profile_model.dart';
import '../../services/health/health_profile_service.dart';
import '../../services/health/health_data_service.dart';
import '../../services/api_service.dart';
import '../../services/core/auth_service.dart';
import '../core/auth_provider.dart';

/**
 * 健康档案状态枚举
 * 
 * 用于表示健康档案数据的当前加载状态
 */
enum HealthProfileStatus {
  initial,  // 初始状态，未加载任何数据
  loading,  // 正在加载数据
  loaded,   // 数据加载完成
  error,    // 加载出错
}

/**
 * 健康档案状态管理提供者
 * 
 * 负责管理用户的营养健康档案数据，提供以下功能：
 * 1. 获取用户的所有营养档案
 * 2. 创建新的营养档案
 * 3. 更新现有营养档案
 * 4. 删除营养档案
 * 5. 管理档案的选择状态
 * 
 * 该类使用ChangeNotifier实现，可以通过Provider在整个应用中共享档案数据状态
 */
class HealthProfileProvider with ChangeNotifier {
  final HealthProfileService _healthService;      // 健康档案服务，用于与后端API通信
  final HealthDataService _healthDataService;     // 健康数据服务，用于获取健康相关的辅助数据
  final AuthProvider _authProvider;               // 认证提供者，用于获取用户信息和验证登录状态
  
  HealthProfileStatus _status = HealthProfileStatus.initial;  // 当前数据加载状态
  String? _errorMessage;                          // 错误信息
  List<NutritionProfile> _profiles = [];          // 用户的所有营养档案列表
  NutritionProfile? _selectedProfile;             // 当前选中的档案
  bool _isCreating = false;                       // 是否处于创建新档案模式
  
  /**
   * 构造函数
   * 
   * @param authProvider 认证提供者，用于获取用户信息
   * @param apiService API服务，用于与后端通信
   */
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
  
  // Getters
  /**
   * 获取当前数据加载状态
   * 
   * @return 当前状态枚举值
   */
  HealthProfileStatus get status => _status;
  
  /**
   * 获取错误信息
   * 
   * @return 错误信息，如果没有错误则为null
   */
  String? get errorMessage => _errorMessage;
  
  /**
   * 获取所有营养档案列表
   * 
   * @return 档案列表，可能为空
   */
  List<NutritionProfile> get profiles => _profiles;
  
  /**
   * 获取当前选中的档案
   * 
   * @return 选中的档案，如果没有选中任何档案则为null
   */
  NutritionProfile? get selectedProfile => _selectedProfile;
  
  /**
   * 获取是否处于创建新档案模式
   * 
   * @return 如果正在创建新档案则返回true，否则返回false
   */
  bool get isCreating => _isCreating;
  
  /**
   * 获取认证提供者实例
   * 
   * @return 认证提供者实例
   */
  AuthProvider get authProvider => _authProvider;
  
  /**
   * 设置创建模式状态
   * 
   * 切换UI显示状态，用于区分创建新档案和查看/编辑现有档案
   * 
   * @param isCreating true表示进入创建模式，false表示退出创建模式
   */
  void setCreatingMode(bool isCreating) {
    _isCreating = isCreating;
    notifyListeners();  // 通知UI状态已更新
  }
  
  /**
   * 选择当前操作的档案
   * 
   * 设置当前选中的档案，用于查看、编辑或其他操作
   * 
   * @param profile 要选择的档案，传入null表示取消选择
   */
  void selectProfile(NutritionProfile? profile) {
    _selectedProfile = profile;
    notifyListeners();  // 通知UI状态已更新
  }
  
  /**
   * 重置错误状态
   * 
   * 清除错误信息，通常在用户确认错误或重试操作后调用
   */
  void resetError() {
    _errorMessage = null;
    notifyListeners();  // 通知UI状态已更新
  }
  
  /**
   * 初始化方法
   * 
   * 检查用户登录状态，如果已登录且尚未加载档案，则自动加载用户的档案列表
   * 通常在应用启动或进入相关页面时调用
   */
  Future<void> init() async {
    // 检查是否需要加载档案
    if (_authProvider.isAuthenticated && _profiles.isEmpty) {
      await fetchProfiles();
    }
  }
  
  /**
   * 加载用户的所有营养档案
   * 
   * 从服务器获取当前登录用户的所有营养档案列表
   * 
   * @throws Exception 如果用户未登录或加载过程中出错
   */
  Future<void> fetchProfiles() async {
    // 检查用户是否已登录
    if (!_authProvider.isAuthenticated) {
      _errorMessage = '请先登录';
      _status = HealthProfileStatus.error;
      notifyListeners();
      return;
    }
    
    try {
      // 更新状态为加载中
      _status = HealthProfileStatus.loading;
      notifyListeners();
      
      // 调用服务获取档案列表
      final profiles = await _healthService.fetchProfilesByUserId();
      _profiles = profiles;
      
      // 如果有档案但没有选中任何档案，自动选择第一个
      if (_profiles.isNotEmpty && _selectedProfile == null) {
        _selectedProfile = _profiles.first;
      }
      
      // 更新状态为加载完成
      _status = HealthProfileStatus.loaded;
      notifyListeners();
    } catch (e) {
      // 处理错误
      debugPrint('加载档案列表失败: $e');
      _status = HealthProfileStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  /**
   * 获取特定档案的详细信息
   * 
   * 根据档案ID从服务器获取完整的档案信息
   * 
   * @param profileId 要加载的档案ID
   * @throws Exception 如果用户未登录或加载过程中出错
   */
  Future<void> loadProfileDetail(String profileId) async {
    // 检查用户是否已登录
    if (!_authProvider.isAuthenticated) {
      _errorMessage = '请先登录';
      _status = HealthProfileStatus.error;
      notifyListeners();
      return;
    }
    
    try {
      // 更新状态为加载中
      _status = HealthProfileStatus.loading;
      notifyListeners();
      
      // 调用服务获取档案详情
      final profile = await _healthService.getProfileById(profileId);
      _selectedProfile = profile;
      
      // 更新状态为加载完成
      _status = HealthProfileStatus.loaded;
      notifyListeners();
    } catch (e) {
      // 处理错误
      _status = HealthProfileStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  /**
   * 创建新的营养档案
   * 
   * 将新档案信息提交到服务器，成功后更新本地档案列表
   * 
   * @param profile 要创建的新档案信息
   * @return 创建成功返回true，失败返回false
   * @throws Exception 如果用户未登录或创建过程中出错
   */
  Future<bool> createProfile(NutritionProfile profile) async {
    // 检查用户是否已登录
    if (!_authProvider.isAuthenticated) {
      _errorMessage = '请先登录';
      _status = HealthProfileStatus.error;
      notifyListeners();
      return false;
    }
    
    try {
      // 更新状态为加载中
      _status = HealthProfileStatus.loading;
      notifyListeners();
      
      // 获取用户ID
      final userId = _authProvider.userId;
      if (userId == null) {
        throw Exception('用户ID不存在');
      }
      
      debugPrint('在Provider中创建档案，用户ID: $userId');
      
      // 添加用户ID到档案数据中
      final profileWithUserId = profile.copyWith(userId: userId);
      
      // 调用服务创建档案
      final result = await _healthService.createProfile(profileWithUserId);
      
      // 处理创建结果
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
        
        // 设置新创建的档案为当前选中档案
        _selectedProfile = newProfile;
        _status = HealthProfileStatus.loaded;
        notifyListeners();
        
        // 创建后立即重新获取档案列表以确保同步
        fetchProfiles();
        
        return true;
      } else {
        // 创建失败，更新错误信息
        final errorMessage = result['message'] ?? '创建档案失败';
        debugPrint('创建档案失败: $errorMessage');
        _errorMessage = errorMessage;
        _status = HealthProfileStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      // 处理异常
      debugPrint('创建档案过程中发生异常: $e');
      _status = HealthProfileStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  /**
   * 更新现有营养档案
   * 
   * 将更新后的档案信息提交到服务器，成功后更新本地档案列表
   * 
   * @param profileId 要更新的档案ID
   * @param updatedProfile 更新后的档案信息
   * @return 更新成功返回true，失败返回false
   * @throws Exception 如果用户未登录或更新过程中出错
   */
  Future<bool> updateProfile(String profileId, NutritionProfile updatedProfile) async {
    // 检查用户是否已登录
    if (!_authProvider.isAuthenticated) {
      _errorMessage = '请先登录';
      _status = HealthProfileStatus.error;
      notifyListeners();
      return false;
    }
    
    try {
      // 更新状态为加载中
      _status = HealthProfileStatus.loading;
      notifyListeners();
      
      // 确保保留用户ID
      final userId = _authProvider.userId;
      final completeProfile = updatedProfile.copyWith(userId: userId);
      
      // 调用服务更新档案
      final result = await _healthService.updateProfile(profileId, completeProfile);
      
      // 处理更新结果
      if (result['success'] == true) {
        // 检查是否返回了档案数据
        if (result['profile'] != null) {
          NutritionProfile updatedProfileObj;
          if (result['profile'] is NutritionProfile) {
            updatedProfileObj = result['profile'];
          } else {
            updatedProfileObj = NutritionProfile.fromJson(result['profile']);
          }
          
          // 更新本地列表中的档案数据
          final index = _profiles.indexWhere((p) => p.id == profileId);
          if (index != -1) {
            _profiles[index] = updatedProfileObj;
          }
          
          // 如果正在更新的是选中的档案，也更新选中档案
          if (_selectedProfile?.id == profileId) {
            _selectedProfile = updatedProfileObj;
          }
        }
        
        // 更新状态为加载完成
        _status = HealthProfileStatus.loaded;
        notifyListeners();
        
        // 更新后立即重新获取档案列表以确保同步
        fetchProfiles();
        
        return true;
      } else {
        // 更新失败，更新错误信息
        final errorMessage = result['message'] ?? '更新档案失败';
        debugPrint('更新档案失败: $errorMessage');
        _errorMessage = errorMessage;
        _status = HealthProfileStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      // 处理异常
      debugPrint('更新档案过程中发生异常: $e');
      _status = HealthProfileStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  /**
   * 删除营养档案
   * 
   * 从服务器删除指定ID的档案，成功后更新本地档案列表
   * 
   * @param profileId 要删除的档案ID
   * @return 删除成功返回true，失败返回false
   * @throws Exception 如果用户未登录或删除过程中出错
   */
  Future<bool> deleteProfile(String profileId) async {
    // 检查用户是否已登录
    if (!_authProvider.isAuthenticated) {
      _errorMessage = '请先登录';
      _status = HealthProfileStatus.error;
      notifyListeners();
      return false;
    }
    
    try {
      // 更新状态为加载中
      _status = HealthProfileStatus.loading;
      notifyListeners();
      
      debugPrint('准备删除档案: $profileId');
      // 调用服务删除档案
      final success = await _healthService.deleteProfile(profileId);
      
      // 处理删除结果
      if (success) {
        debugPrint('档案删除成功，从列表中移除');
        // 从本地列表中移除已删除的档案
        _profiles.removeWhere((profile) => profile.id == profileId);
        
        // 如果删除的是当前选中的档案，重置选中档案（选择列表中的第一个，如果列表为空则设为null）
        if (_selectedProfile?.id == profileId) {
          _selectedProfile = _profiles.isNotEmpty ? _profiles.first : null;
        }
        
        // 更新状态为加载完成
        _status = HealthProfileStatus.loaded;
        notifyListeners();
        
        // 删除后立即重新获取档案列表以确保同步
        fetchProfiles();
        
        return true;
      } else {
        // 删除失败，更新错误信息
        debugPrint('档案删除返回失败');
        _status = HealthProfileStatus.error;
        _errorMessage = '删除档案失败，请重试';
        notifyListeners();
        return false;
      }
    } catch (e) {
      // 处理异常
      debugPrint('删除档案异常: $e');
      _status = HealthProfileStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
