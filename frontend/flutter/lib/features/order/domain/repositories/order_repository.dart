import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order.dart';

/// Uorder 仓储接口
abstract class UorderRepository {
  Future<Either<Failure, List<Uorder>>> getUorders();
  Future<Either<Failure, Uorder>> getUorder(String id);
  Future<Either<Failure, Uorder>> createUorder(Uorder order);
  Future<Either<Failure, Uorder>> updateUorder(Uorder order);
  Future<Either<Failure, Unit>> deleteUorder(String id);
}
