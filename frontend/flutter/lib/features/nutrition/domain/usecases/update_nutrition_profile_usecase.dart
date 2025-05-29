import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/nutrition_profile.dart';
import '../repositories/nutrition_repository.dart';

/// 更新营养档案用例
class UpdateNutritionProfileUseCase
    implements UseCase<NutritionProfile, UpdateNutritionProfileParams> {
  final NutritionRepository repository;

  UpdateNutritionProfileUseCase(this.repository);

  @override
  Future<Either<Failure, NutritionProfile>> call(
    UpdateNutritionProfileParams params,
  ) async {
    return await repository.updateNutritionProfile(params.profile);
  }
}

class UpdateNutritionProfileParams {
  final NutritionProfile profile;

  UpdateNutritionProfileParams({required this.profile});
}