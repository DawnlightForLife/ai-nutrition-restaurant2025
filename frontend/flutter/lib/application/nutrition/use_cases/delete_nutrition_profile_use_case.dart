import 'package:injectable/injectable.dart';
import '../../../domain/abstractions/repositories/i_nutrition_repository.dart';
import '../../../domain/common/failures/failures.dart';
import 'package:dartz/dartz.dart';
import '../../core/use_case.dart';

@injectable
class DeleteNutritionProfileUseCase implements UseCase<Unit, DeleteNutritionProfileParams> {
  final INutritionRepository _repository;

  DeleteNutritionProfileUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteNutritionProfileParams params) async {
    try {
      if (params.profileId.isEmpty) {
        return left(const ValidationFailure(message: '档案ID不能为空'));
      }

      return await _repository.deleteNutritionProfileV2(params.profileId);
    } catch (e) {
      return left(UnexpectedFailure(message: e.toString()));
    }
  }
}

class DeleteNutritionProfileParams {
  final String profileId;

  DeleteNutritionProfileParams({required this.profileId});
}