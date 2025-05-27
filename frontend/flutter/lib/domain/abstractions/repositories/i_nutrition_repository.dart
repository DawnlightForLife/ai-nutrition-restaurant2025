import 'package:dartz/dartz.dart';

import '../../common/failures/failure.dart';
import '../../nutrition/entities/ai_recommendation.dart';
import '../../nutrition/entities/nutrition_profile.dart';
import '../../user/value_objects/user_value_objects.dart';

/// 营养仓储接口
abstract class INutritionRepository {
  /// 获取用户营养档案
  Future<Either<Failure, NutritionProfile>> getNutritionProfile(UserId userId);

  /// 更新用户营养档案
  Future<Either<Failure, NutritionProfile>> updateNutritionProfile(
    UserId userId,
    NutritionProfile profile,
  );

  /// 获取AI推荐
  Future<Either<Failure, List<AiRecommendation>>> getAiRecommendations(
    UserId userId, {
    String? mealType,
    List<String>? preferences,
  });

  /// 创建营养档案
  Future<Either<Failure, NutritionProfile>> createNutritionProfile(
    NutritionProfile profile,
  );

  /// 删除营养档案
  Future<Either<Failure, void>> deleteNutritionProfile(UserId userId);
}