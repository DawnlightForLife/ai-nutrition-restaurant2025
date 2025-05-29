import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../repositories/nutrition_repository.dart';

/// 删除营养档案用例
class DeleteNutritionProfileUseCase
    implements UseCase<void, DeleteNutritionProfileParams> {
  final NutritionRepository repository;

  DeleteNutritionProfileUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(
    DeleteNutritionProfileParams params,
  ) async {
    return await repository.deleteNutritionProfile(params.profileId);
  }
}

class DeleteNutritionProfileParams {
  final String profileId;

  DeleteNutritionProfileParams({required this.profileId});
}