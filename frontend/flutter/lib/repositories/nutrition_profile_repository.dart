import 'dart:async';
import '../models/nutrition_profile_model.dart';

abstract class NutritionProfileRepository {
  // 获取所有营养档案
  Future<List<NutritionProfile>> getAllProfiles();
  
  // 根据ID获取单个档案
  Future<NutritionProfile?> getProfileById(String id);
  
  // 创建新档案
  Future<NutritionProfile> createProfile(NutritionProfile profile);
  
  // 更新档案
  Future<NutritionProfile> updateProfile(NutritionProfile profile);
  
  // 删除档案
  Future<void> deleteProfile(String id);
  
  // 设置为主档案
  Future<void> setPrimaryProfile(String id);
  
  // 监听档案变化（可选）
  Stream<List<NutritionProfile>> watchProfiles();
  
  // 获取完成度
  Future<int> getCompletionPercentage(String profileId);
}