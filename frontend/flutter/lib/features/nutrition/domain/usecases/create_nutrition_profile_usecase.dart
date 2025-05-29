import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/nutrition_profile.dart';
import '../repositories/nutrition_repository.dart';

/// 创建营养档案用例
class CreateNutritionProfileUseCase
    implements UseCase<NutritionProfile, CreateNutritionProfileParams> {
  final NutritionRepository repository;

  CreateNutritionProfileUseCase(this.repository);

  @override
  Future<Either<Failure, NutritionProfile>> call(
    CreateNutritionProfileParams params,
  ) async {
    return await repository.createNutritionProfile(params.profile);
  }
}

class CreateNutritionProfileParams {
  final NutritionProfile profile;

  CreateNutritionProfileParams({required this.profile});
}