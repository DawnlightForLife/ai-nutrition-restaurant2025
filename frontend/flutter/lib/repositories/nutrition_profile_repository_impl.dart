import 'dart:async';
import '../models/nutrition_profile_model.dart';
import 'nutrition_profile_repository.dart';
import '../services/api/nutrition_profile_api_service.dart';
import '../services/auth_service.dart';
import '../services/mock_auth_service.dart';
import '../config/api_config.dart';

class NutritionProfileRepositoryImpl implements NutritionProfileRepository {
  final NutritionProfileApiService _apiService = NutritionProfileApiService();
  late final AuthService _authService;
  
  NutritionProfileRepositoryImpl() {
    // 在开发环境使用mock认证服务
    _authService = ApiConfig.isProduction ? AuthService() : MockAuthService();
  }
  
  // 缓存机制
  List<NutritionProfile>? _cachedProfiles;
  DateTime? _lastCacheTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);
  
  bool get _isCacheValid {
    return _cachedProfiles != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _cacheValidDuration;
  }
  
  void _updateCache(List<NutritionProfile> profiles) {
    _cachedProfiles = profiles;
    _lastCacheTime = DateTime.now();
  }
  
  void _invalidateCache() {
    _cachedProfiles = null;
    _lastCacheTime = null;
  }

  @override
  Future<List<NutritionProfile>> getAllProfiles() async {
    try {
      // 如果缓存有效，返回缓存数据
      if (_isCacheValid && _cachedProfiles != null) {
        return _cachedProfiles!;
      }
      
      // 获取当前用户ID
      final userId = await _authService.getUserId();
      if (userId == null) {
        throw Exception('用户未登录');
      }
      
      // 从API获取数据
      final profiles = await _apiService.getUserProfiles(userId);
      
      // 更新缓存
      _updateCache(profiles);
      
      return profiles;
    } catch (e) {
      print('Error in getAllProfiles: $e');
      
      // 如果请求失败但有缓存，返回缓存数据
      if (_cachedProfiles != null) {
        return _cachedProfiles!;
      }
      
      throw Exception('获取营养档案列表失败: $e');
    }
  }

  @override
  Future<NutritionProfile?> getProfileById(String id) async {
    try {
      // 先尝试从缓存中查找
      if (_cachedProfiles != null) {
        final cachedProfile = _cachedProfiles!.firstWhere(
          (p) => p.id == id,
          orElse: () => throw Exception('未找到档案'),
        );
        
        // 如果缓存有效，直接返回
        if (_isCacheValid) {
          return cachedProfile;
        }
      }
      
      // 从API获取最新数据
      final profile = await _apiService.getProfileById(id);
      
      // 更新缓存中的对应项
      if (_cachedProfiles != null) {
        final index = _cachedProfiles!.indexWhere((p) => p.id == id);
        if (index != -1) {
          _cachedProfiles![index] = profile;
        }
      }
      
      return profile;
    } catch (e) {
      print('Error in getProfileById: $e');
      throw Exception('获取营养档案详情失败: $e');
    }
  }

  @override
  Future<NutritionProfile> createProfile(NutritionProfile profile) async {
    try {
      final newProfile = await _apiService.createProfile(profile);
      
      // 使缓存失效，下次获取时会重新加载
      _invalidateCache();
      
      return newProfile;
    } catch (e) {
      print('Error in createProfile: $e');
      throw Exception('创建营养档案失败: $e');
    }
  }

  @override
  Future<NutritionProfile> updateProfile(NutritionProfile profile) async {
    try {
      if (profile.id == null) {
        throw Exception('档案ID不能为空');
      }
      
      final updatedProfile = await _apiService.updateProfile(profile.id!, profile);
      
      // 更新缓存中的对应项
      if (_cachedProfiles != null) {
        final index = _cachedProfiles!.indexWhere((p) => p.id == profile.id);
        if (index != -1) {
          _cachedProfiles![index] = updatedProfile;
        }
      }
      
      return updatedProfile;
    } catch (e) {
      print('Error in updateProfile: $e');
      throw Exception('更新营养档案失败: $e');
    }
  }

  @override
  Future<void> deleteProfile(String id) async {
    try {
      await _apiService.deleteProfile(id);
      
      // 从缓存中移除
      if (_cachedProfiles != null) {
        _cachedProfiles!.removeWhere((p) => p.id == id);
      }
    } catch (e) {
      print('Error in deleteProfile: $e');
      throw Exception('删除营养档案失败: $e');
    }
  }

  @override
  Future<void> setPrimaryProfile(String id) async {
    try {
      final updatedProfile = await _apiService.setPrimaryProfile(id);
      
      // 更新缓存中的主档案状态
      if (_cachedProfiles != null) {
        for (var profile in _cachedProfiles!) {
          profile.isPrimary = profile.id == id;
        }
      }
    } catch (e) {
      print('Error in setPrimaryProfile: $e');
      throw Exception('设置主档案失败: $e');
    }
  }

  @override
  Stream<List<NutritionProfile>> watchProfiles() {
    // 创建一个定期刷新的Stream
    return Stream.periodic(
      const Duration(seconds: 30),
      (_) => getAllProfiles(),
    ).asyncExpand((future) => Stream.fromFuture(future));
  }

  @override
  Future<int> getCompletionPercentage(String profileId) async {
    try {
      final stats = await _apiService.getCompletionStats();
      return stats['completionPercentage'] ?? 0;
    } catch (e) {
      print('Error in getCompletionPercentage: $e');
      // 如果获取失败，尝试本地计算
      final profile = await getProfileById(profileId);
      if (profile != null) {
        return _calculateLocalCompletionPercentage(profile);
      }
      return 0;
    }
  }
  
  // 本地计算完成度
  int _calculateLocalCompletionPercentage(NutritionProfile profile) {
    int completedFields = 0;
    int totalFields = 11; // 总字段数
    
    if (profile.profileName.isNotEmpty) completedFields++;
    if (profile.gender != null) completedFields++;
    if (profile.height != null && profile.height! > 0) completedFields++;
    if (profile.weight != null && profile.weight! > 0) completedFields++;
    if (profile.activityLevel != null) completedFields++;
    if (profile.nutritionGoals.isNotEmpty) completedFields++;
    if (profile.targetWeight != null && profile.targetWeight! > 0) completedFields++;
    if (profile.dietaryPreferences?.allergies?.isNotEmpty == true) completedFields++;
    if (profile.medicalConditions?.isNotEmpty == true) completedFields++;
    if (profile.dailyCalorieTarget != null && profile.dailyCalorieTarget! > 0) completedFields++;
    if (profile.hydrationGoal != null && profile.hydrationGoal! > 0) completedFields++;
    
    return ((completedFields / totalFields) * 100).round();
  }

  // 清除缓存
  void clearCache() {
    _invalidateCache();
  }
}