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
  // 临时存储，实际应该使用API或本地数据库
  static final List<NutritionProfileV2> _profiles = [];
  static int _idCounter = 1;

  @override
  Future<List<NutritionProfileV2>> getProfilesByUserId(String userId) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));
    
    // 返回该用户的所有档案
    return _profiles.where((p) => p.userId.value == userId).toList();
  }

  @override
  Future<NutritionProfileV2> createProfile(NutritionProfileV2 profile) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 300));
    
    // 如果这是第一个档案，设为主要档案
    final isPrimary = _profiles.where((p) => p.userId.value == profile.userId.value).isEmpty;
    
    // 创建新档案
    final newProfile = profile.copyWith(
      id: 'profile_${_idCounter++}',
      isPrimary: isPrimary,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _profiles.add(newProfile);
    return newProfile;
  }

  @override
  Future<NutritionProfileV2> updateProfile(NutritionProfileV2 profile) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _profiles.indexWhere((p) => p.id == profile.id);
    if (index == -1) {
      throw Exception('Profile not found');
    }
    
    final updatedProfile = profile.copyWith(updatedAt: DateTime.now());
    _profiles[index] = updatedProfile;
    
    // 如果更新为主要档案，将其他档案设为非主要
    if (updatedProfile.isPrimary) {
      for (int i = 0; i < _profiles.length; i++) {
        if (i != index && _profiles[i].userId.value == updatedProfile.userId.value) {
          _profiles[i] = _profiles[i].copyWith(isPrimary: false);
        }
      }
    }
    
    return updatedProfile;
  }

  @override
  Future<void> deleteProfile(String profileId) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 300));
    
    _profiles.removeWhere((p) => p.id == profileId);
  }

  @override
  Future<NutritionProfileV2?> getProfileById(String profileId) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return _profiles.firstWhere((p) => p.id == profileId);
    } catch (e) {
      return null;
    }
  }
}