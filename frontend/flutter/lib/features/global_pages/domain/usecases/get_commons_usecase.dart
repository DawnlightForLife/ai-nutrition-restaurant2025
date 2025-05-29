import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/common.dart';
import '../repositories/common_repository.dart';

/// 获取Ucommon列表用例
class GetUcommonsUseCase implements UseCase<List<Ucommon>, NoParams> {
  final UcommonRepository repository;

  GetUcommonsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Ucommon>>> call(NoParams params) async {
    return await repository.getUcommons();
  }
}
