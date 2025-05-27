import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../domain/abstractions/repositories/i_nutrition_repository.dart';
import '../../domain/common/failures/failure.dart';
import '../../domain/nutrition/entities/ai_recommendation.dart';
import '../../domain/nutrition/entities/nutrition_profile.dart';
import '../../domain/nutrition/entities/nutrition_profile_v2.dart';
import '../../domain/user/value_objects/user_value_objects.dart';
import '../services/nutrition_api_service.dart';
import '../services/nutrition_profile_v2_api_service.dart';

/// 营养仓储实现
@LazySingleton(as: INutritionRepository)
class NutritionRepository implements INutritionRepository {
  final NutritionApiService _apiService;
  final NutritionProfileV2ApiService _v2ApiService;
  
  // 支持直接注入API服务
  NutritionRepository(this._apiService) : _v2ApiService = NutritionProfileV2ApiService();
  
  // 支持无参数构造
  @factoryMethod
  factory NutritionRepository.create() {
    return NutritionRepository(NutritionApiService());
  }

  @override
  Future<Either<Failure, NutritionProfile>> getNutritionProfile(UserId userId) async {
    try {
      // TODO(dev): 从API或本地存储获取营养档案
      // 暂时返回默认档案
      final profile = NutritionProfile.createDefault(userId: userId);
      return Right(profile);
    } catch (e) {
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NutritionProfile>> updateNutritionProfile(
    UserId userId,
    NutritionProfile profile,
  ) async {
    try {
      // TODO(dev): 更新API或本地存储中的营养档案
      return Right(profile);
    } catch (e) {
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AiRecommendation>>> getAiRecommendations(
    UserId userId, {
    String? mealType,
    List<String>? preferences,
  }) async {
    try {
      // TODO(dev): 调用AI服务获取推荐
      // 暂时返回空列表
      return const Right([]);
    } catch (e) {
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NutritionProfile>> createNutritionProfile(
    NutritionProfile profile,
  ) async {
    try {
      // TODO(dev): 在API或本地存储中创建营养档案
      return Right(profile);
    } catch (e) {
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNutritionProfile(UserId userId) async {
    try {
      // TODO(dev): 从API或本地存储中删除营养档案
      return const Right(null);
    } catch (e) {
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  // ===== V2版本方法实现 =====
  
  @override
  Future<Either<Failure, NutritionProfileV2>> getNutritionProfileV2(String userId) async {
    try {
      final result = await _v2ApiService.getUserProfiles();
      return result.fold(
        (failure) => left(failure),
        (profiles) {
          if (profiles.isEmpty) {
            // 如果没有档案，返回默认档案
            final profile = NutritionProfileV2.createDefault(
              userId: UserId(userId),
              profileName: '我的营养档案',
            );
            return right(profile);
          }
          // 返回第一个档案或主档案
          final primaryProfile = profiles.firstWhere(
            (p) => p.isPrimary ?? false,
            orElse: () => profiles.first,
          );
          return right(primaryProfile);
        },
      );
    } catch (e) {
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NutritionProfileV2>> createNutritionProfileV2(
    NutritionProfileV2 profile,
  ) async {
    return _v2ApiService.createProfile(profile);
  }

  @override
  Future<Either<Failure, NutritionProfileV2>> updateNutritionProfileV2(
    NutritionProfileV2 profile,
  ) async {
    if (profile.id == null) {
      return left(const ValidationFailure(message: '档案ID不能为空'));
    }
    return _v2ApiService.updateProfile(profile.id!, profile);
  }

  @override
  Future<Either<Failure, Unit>> deleteNutritionProfileV2(String profileId) async {
    return _v2ApiService.deleteProfile(profileId);
  }
  
  // 获取用户的所有营养档案
  Future<Either<Failure, List<NutritionProfileV2>>> getUserProfilesV2() async {
    return _v2ApiService.getUserProfiles();
  }
  
  // 设置主档案
  Future<Either<Failure, Unit>> setPrimaryProfileV2(String profileId) async {
    return _v2ApiService.setPrimaryProfile(profileId);
  }
}