import 'package:dartz/dartz.dart';
import 'package:ai_nutrition_restaurant/core/failures/failures.dart';
import '../entities/common.dart';

/// Ucommon 仓储接口
abstract class UcommonRepository {
  Future<Either<Failure, List<Ucommon>>> getUcommons();
  Future<Either<Failure, Ucommon>> getUcommon(String id);
  Future<Either<Failure, Ucommon>> createUcommon(Ucommon common);
  Future<Either<Failure, Ucommon>> updateUcommon(Ucommon common);
  Future<Either<Failure, Unit>> deleteUcommon(String id);
}
