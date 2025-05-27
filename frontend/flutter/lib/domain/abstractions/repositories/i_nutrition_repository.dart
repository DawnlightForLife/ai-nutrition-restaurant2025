import 'package:dartz/dartz.dart';

import '../../common/failures/failure.dart';
import '../../nutrition/entities/ai_recommendation.dart';
import '../../nutrition/entities/nutrition_profile.dart';
import '../../nutrition/entities/nutrition_profile_v2.dart';
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

  // ===== V2版本方法 =====
  
  /// 获取用户营养档案V2
  Future<Either<Failure, NutritionProfileV2>> getNutritionProfileV2(String userId);

  /// 创建营养档案V2
  Future<Either<Failure, NutritionProfileV2>> createNutritionProfileV2(
    NutritionProfileV2 profile,
  );

  /// 更新营养档案V2
  Future<Either<Failure, NutritionProfileV2>> updateNutritionProfileV2(
    NutritionProfileV2 profile,
  );

  /// 删除营养档案V2
  Future<Either<Failure, Unit>> deleteNutritionProfileV2(String profileId);
}