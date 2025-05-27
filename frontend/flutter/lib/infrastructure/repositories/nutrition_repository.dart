import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../domain/abstractions/repositories/i_nutrition_repository.dart';
import '../../domain/common/failures/failure.dart';
import '../../domain/nutrition/entities/ai_recommendation.dart';
import '../../domain/nutrition/entities/nutrition_profile.dart';
import '../../domain/user/value_objects/user_value_objects.dart';

/// 营养仓储实现
@LazySingleton(as: INutritionRepository)
class NutritionRepository implements INutritionRepository {
  // TODO(dev): 注入数据源依赖
  
  NutritionRepository();

  @override
  Future<Either<Failure, NutritionProfile>> getNutritionProfile(UserId userId) async {
    try {
      // TODO(dev): 从API或本地存储获取营养档案
      // 暂时返回默认档案
      final profile = NutritionProfile.createDefault(userId: userId);
      return Right(profile);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
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
      return Left(Failure.unexpected(e.toString()));
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
      return Left(Failure.unexpected(e.toString()));
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
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNutritionProfile(UserId userId) async {
    try {
      // TODO(dev): 从API或本地存储中删除营养档案
      return const Right(null);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }
}