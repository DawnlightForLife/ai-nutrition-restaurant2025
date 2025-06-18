import '../../../../core/base/use_case.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

/// 获取Uorder列表用例
class GetUordersUseCase implements UseCase<List<Uorder>, NoParams> {
  final UorderRepository repository;

  GetUordersUseCase(this.repository);

  @override
  Future<List<Uorder>> call(NoParams params) async {
    return await repository.getUorders();
  }
}
