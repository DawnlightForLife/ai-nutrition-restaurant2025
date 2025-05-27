import 'package:injectable/injectable.dart';
import '../../../domain/nutrition/entities/nutrition_profile_v2.dart';
import '../../../domain/abstractions/repositories/i_nutrition_repository.dart';
import '../../../domain/common/failures/failures.dart';
import 'package:dartz/dartz.dart';
import '../../core/use_case.dart';

@injectable
class CreateNutritionProfileUseCase implements UseCase<NutritionProfileV2, CreateNutritionProfileParams> {
  final INutritionRepository _repository;

  CreateNutritionProfileUseCase(this._repository);

  @override
  Future<Either<Failure, NutritionProfileV2>> call(CreateNutritionProfileParams params) async {
    try {
      // 验证必填字段
      if (params.profile.gender.isEmpty ||
          params.profile.ageGroup.isEmpty ||
          params.profile.height <= 0 ||
          params.profile.weight <= 0 ||
          params.profile.healthGoal.isEmpty ||
          params.profile.targetCalories <= 0 ||
          params.profile.dietaryPreferences.isEmpty) {
        return left(const ValidationFailure(message: '请填写所有必填项'));
      }

      // 调用repository创建档案
      return await _repository.createNutritionProfileV2(params.profile);
    } catch (e) {
      return left(UnexpectedFailure(message: e.toString()));
    }
  }
}

class CreateNutritionProfileParams {
  final NutritionProfileV2 profile;

  CreateNutritionProfileParams({required this.profile});
}