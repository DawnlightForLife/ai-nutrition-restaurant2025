import 'package:dartz/dartz.dart';
import 'package:ai_nutrition_restaurant/core/failures/failures.dart';
import '../entities/nutritionist.dart';
import '../entities/nutritionist_filter.dart';

/// Nutritionist 仓储接口
abstract class NutritionistRepository {
  Future<Either<Failure, List<Nutritionist>>> getNutritionists({
    NutritionistFilter? filter,
  });
  Future<Either<Failure, Nutritionist>> getNutritionistById(String id);
  Future<Either<Failure, Nutritionist>> createNutritionist(Nutritionist nutritionist);
  Future<Either<Failure, Nutritionist>> updateNutritionist(Nutritionist nutritionist);
  Future<Either<Failure, Unit>> deleteNutritionist(String id);
}

/// 向后兼容的接口
@Deprecated('Use NutritionistRepository instead')
abstract class UnutritionistRepository {
  Future<Either<Failure, List<Unutritionist>>> getUnutritionists();
  Future<Either<Failure, Unutritionist>> getUnutritionist(String id);
  Future<Either<Failure, Unutritionist>> createUnutritionist(Unutritionist nutritionist);
  Future<Either<Failure, Unutritionist>> updateUnutritionist(Unutritionist nutritionist);
  Future<Either<Failure, Unit>> deleteUnutritionist(String id);
}
