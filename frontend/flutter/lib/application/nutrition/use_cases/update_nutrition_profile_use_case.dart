import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/abstractions/repositories/i_nutrition_repository.dart';
import '../../../domain/common/failures/failure.dart';
import '../../../domain/nutrition/entities/nutrition_profile.dart';
import '../../../domain/user/value_objects/user_value_objects.dart';
import '../../core/use_case.dart';

/// 更新营养档案用例参数
class UpdateNutritionProfileParams extends Equatable {
  final UserId userId;
  final NutritionProfile profile;

  const UpdateNutritionProfileParams({
    required this.userId,
    required this.profile,
  });

  @override
  List<Object?> get props => [userId, profile];
}

/// 更新营养档案用例
@injectable
class UpdateNutritionProfileUseCase extends UseCase<NutritionProfile, UpdateNutritionProfileParams> {
  final INutritionRepository _repository;

  UpdateNutritionProfileUseCase(this._repository);

  @override
  Future<Either<Failure, NutritionProfile>> call(UpdateNutritionProfileParams params) {
    return _repository.updateNutritionProfile(params.userId, params.profile);
  }
}