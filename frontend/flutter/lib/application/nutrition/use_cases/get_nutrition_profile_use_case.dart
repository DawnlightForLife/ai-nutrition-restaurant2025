import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/abstractions/repositories/i_nutrition_repository.dart';
import '../../../domain/common/failures/failure.dart';
import '../../../domain/nutrition/entities/nutrition_profile.dart';
import '../../../domain/user/value_objects/user_value_objects.dart';
import '../../core/use_case.dart';

/// 获取营养档案用例参数
class GetNutritionProfileParams extends Equatable {
  final UserId userId;

  const GetNutritionProfileParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// 获取营养档案用例
@injectable
class GetNutritionProfileUseCase extends UseCase<NutritionProfile, GetNutritionProfileParams> {
  final INutritionRepository _repository;

  GetNutritionProfileUseCase(this._repository);

  @override
  Future<Either<Failure, NutritionProfile>> call(GetNutritionProfileParams params) {
    return _repository.getNutritionProfile(params.userId);
  }
}