import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/merchant.dart';
import '../repositories/merchant_repository.dart';

/// 获取Umerchant列表用例
class GetUmerchantsUseCase implements UseCase<List<Umerchant>, NoParams> {
  final UmerchantRepository repository;

  GetUmerchantsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Umerchant>>> call(NoParams params) async {
    return await repository.getUmerchants();
  }
}
