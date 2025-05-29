import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/nutritionist.dart';
import '../repositories/nutritionist_repository.dart';

/// 获取Unutritionist列表用例
class GetUnutritionistsUseCase implements UseCase<List<Unutritionist>, NoParams> {
  final UnutritionistRepository repository;

  GetUnutritionistsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Unutritionist>>> call(NoParams params) async {
    return await repository.getUnutritionists();
  }
}
