import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../../user/domain/value_objects/user_id.dart';

/// 营养档案仓库接口
abstract class NutritionProfileRepository {
  Future<List<NutritionProfileV2>> getProfilesByUserId(String userId);
  Future<NutritionProfileV2> createProfile(NutritionProfileV2 profile);
  Future<NutritionProfileV2> updateProfile(NutritionProfileV2 profile);
  Future<void> deleteProfile(String profileId);
  Future<NutritionProfileV2?> getProfileById(String profileId);
}

/// 营养档案仓库实现
class NutritionProfileRepositoryImpl implements NutritionProfileRepository {
  static const String _profilesKey = 'nutrition_profiles';
  static const String _counterKey = 'profile_id_counter';

  /// 从SharedPreferences加载所有档案
  Future<List<Map<String, dynamic>>> _loadProfilesFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final profilesJson = prefs.getString(_profilesKey);
    if (profilesJson == null) return [];
    
    try {
      final List<dynamic> profilesList = jsonDecode(profilesJson);
      return profilesList.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error loading profiles from storage: $e');
      return [];
    }
  }

  /// 保存所有档案到SharedPreferences
  Future<void> _saveProfilesToStorage(List<Map<String, dynamic>> profiles) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final profilesJson = jsonEncode(profiles);
      await prefs.setString(_profilesKey, profilesJson);
    } catch (e) {
      print('Error saving profiles to storage: $e');
    }
  }

  /// 获取并递增ID计数器
  Future<int> _getNextId() async {
    final prefs = await SharedPreferences.getInstance();
    final currentId = prefs.getInt(_counterKey) ?? 1;
    await prefs.setInt(_counterKey, currentId + 1);
    return currentId;
  }

  @override
  Future<List<NutritionProfileV2>> getProfilesByUserId(String userId) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));
    
    final profilesData = await _loadProfilesFromStorage();
    final userProfiles = profilesData.where((p) => p['userId'] == userId).toList();
    
    return userProfiles.map((profileMap) => _mapToEntity(profileMap)).toList();
  }

  @override
  Future<NutritionProfileV2> createProfile(NutritionProfileV2 profile) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 300));
    
    final profilesData = await _loadProfilesFromStorage();
    final userProfiles = profilesData.where((p) => p['userId'] == profile.userId.value).toList();
    
    // 如果这是第一个档案，设为主要档案
    final isPrimary = userProfiles.isEmpty;
    
    // 创建新档案
    final newId = await _getNextId();
    final newProfile = profile.copyWith(
      id: 'profile_$newId',
      isPrimary: isPrimary,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // 添加到存储
    profilesData.add(_mapToData(newProfile));
    await _saveProfilesToStorage(profilesData);
    
    return newProfile;
  }

  @override
  Future<NutritionProfileV2> updateProfile(NutritionProfileV2 profile) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 300));
    
    final profilesData = await _loadProfilesFromStorage();
    final index = profilesData.indexWhere((p) => p['id'] == profile.id);
    if (index == -1) {
      throw Exception('Profile not found');
    }
    
    final updatedProfile = profile.copyWith(updatedAt: DateTime.now());
    profilesData[index] = _mapToData(updatedProfile);
    
    // 如果更新为主要档案，将其他档案设为非主要
    if (updatedProfile.isPrimary) {
      for (int i = 0; i < profilesData.length; i++) {
        if (i != index && profilesData[i]['userId'] == updatedProfile.userId.value) {
          profilesData[i]['isPrimary'] = false;
        }
      }
    }
    
    await _saveProfilesToStorage(profilesData);
    return updatedProfile;
  }

  @override
  Future<void> deleteProfile(String profileId) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 300));
    
    final profilesData = await _loadProfilesFromStorage();
    profilesData.removeWhere((p) => p['id'] == profileId);
    await _saveProfilesToStorage(profilesData);
  }

  @override
  Future<NutritionProfileV2?> getProfileById(String profileId) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 200));
    
    final profilesData = await _loadProfilesFromStorage();
    try {
      final profileMap = profilesData.firstWhere((p) => p['id'] == profileId);
      return _mapToEntity(profileMap);
    } catch (e) {
      return null;
    }
  }

  /// 将实体转换为存储数据
  Map<String, dynamic> _mapToData(NutritionProfileV2 profile) {
    return {
      'id': profile.id,
      'userId': profile.userId.value,
      'profileName': profile.profileName,
      'gender': profile.gender,
      'ageGroup': profile.ageGroup,
      'height': profile.height,
      'weight': profile.weight,
      'healthGoal': profile.healthGoal,
      'targetCalories': profile.targetCalories,
      'dietaryPreferences': profile.dietaryPreferences,
      'medicalConditions': profile.medicalConditions,
      'exerciseFrequency': profile.exerciseFrequency,
      'nutritionPreferences': profile.nutritionPreferences,
      'specialStatus': profile.specialStatus,
      'forbiddenIngredients': profile.forbiddenIngredients,
      'allergies': profile.allergies,
      'isPrimary': profile.isPrimary,
      'activityDetails': profile.activityDetails,
      'healthGoalDetails': profile.healthGoalDetails,
      'aiRecommendationId': profile.aiRecommendationId,
      'aiNutritionTargets': profile.aiNutritionTargets,
      'hasAIRecommendation': profile.hasAIRecommendation,
      'nutritionProgress': profile.nutritionProgress,
      'totalEnergyPoints': profile.totalEnergyPoints,
      'currentStreak': profile.currentStreak,
      'bestStreak': profile.bestStreak,
      'lastActiveDate': profile.lastActiveDate?.toIso8601String(),
      'createdAt': profile.createdAt.toIso8601String(),
      'updatedAt': profile.updatedAt.toIso8601String(),
    };
  }

  /// 将存储数据转换为实体
  NutritionProfileV2 _mapToEntity(Map<String, dynamic> data) {
    return NutritionProfileV2(
      userId: UserId(data['userId'] ?? ''),
      id: data['id'],
      profileName: data['profileName'] ?? '',
      gender: data['gender'] ?? '',
      ageGroup: data['ageGroup'] ?? '',
      height: (data['height'] ?? 0.0).toDouble(),
      weight: (data['weight'] ?? 0.0).toDouble(),
      healthGoal: data['healthGoal'] ?? '',
      targetCalories: (data['targetCalories'] ?? 0.0).toDouble(),
      dietaryPreferences: List<String>.from(data['dietaryPreferences'] ?? []),
      medicalConditions: List<String>.from(data['medicalConditions'] ?? []),
      exerciseFrequency: data['exerciseFrequency'],
      nutritionPreferences: List<String>.from(data['nutritionPreferences'] ?? []),
      specialStatus: List<String>.from(data['specialStatus'] ?? []),
      forbiddenIngredients: List<String>.from(data['forbiddenIngredients'] ?? []),
      allergies: List<String>.from(data['allergies'] ?? []),
      isPrimary: data['isPrimary'] ?? false,
      activityDetails: Map<String, dynamic>.from(data['activityDetails'] ?? {}),
      healthGoalDetails: Map<String, dynamic>.from(data['healthGoalDetails'] ?? {}),
      aiRecommendationId: data['aiRecommendationId'],
      aiNutritionTargets: data['aiNutritionTargets'] != null 
          ? Map<String, double>.from(
              (data['aiNutritionTargets'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(key, (value as num).toDouble())
              )
            )
          : null,
      hasAIRecommendation: data['hasAIRecommendation'] ?? false,
      nutritionProgress: data['nutritionProgress'] != null 
          ? Map<String, dynamic>.from(data['nutritionProgress'])
          : null,
      totalEnergyPoints: data['totalEnergyPoints'] ?? 0,
      currentStreak: data['currentStreak'] ?? 0,
      bestStreak: data['bestStreak'] ?? 0,
      lastActiveDate: data['lastActiveDate'] != null 
          ? DateTime.parse(data['lastActiveDate'])
          : null,
      createdAt: DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(data['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}