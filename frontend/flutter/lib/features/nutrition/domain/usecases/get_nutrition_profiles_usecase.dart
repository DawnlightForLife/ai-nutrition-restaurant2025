import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/nutrition_profile.dart';
import '../repositories/nutrition_repository.dart';

/// 获取营养档案列表用例
class GetNutritionProfilesUseCase
    implements UseCase<List<NutritionProfile>, GetNutritionProfilesParams> {
  final NutritionRepository repository;

  GetNutritionProfilesUseCase(this.repository);

  @override
  Future<Either<Failure, List<NutritionProfile>>> call(
    GetNutritionProfilesParams params,
  ) async {
    return await repository.getNutritionProfiles(params.userId);
  }
}

class GetNutritionProfilesParams {
  final String userId;

  GetNutritionProfilesParams({required this.userId});
}