import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

/// 获取Uorder列表用例
class GetUordersUseCase implements UseCase<List<Uorder>, NoParams> {
  final UorderRepository repository;

  GetUordersUseCase(this.repository);

  @override
  Future<Either<Failure, List<Uorder>>> call(NoParams params) async {
    return await repository.getUorders();
  }
}
