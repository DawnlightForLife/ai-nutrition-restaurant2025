import 'package:dartz/dartz.dart';
import 'package:ai_nutrition_restaurant/core/failures/failures.dart';
import '../entities/merchant.dart';

/// Umerchant 仓储接口
abstract class UmerchantRepository {
  Future<Either<Failure, List<Umerchant>>> getUmerchants();
  Future<Either<Failure, Umerchant>> getUmerchant(String id);
  Future<Either<Failure, Umerchant>> createUmerchant(Umerchant merchant);
  Future<Either<Failure, Umerchant>> updateUmerchant(Umerchant merchant);
  Future<Either<Failure, Unit>> deleteUmerchant(String id);
}
