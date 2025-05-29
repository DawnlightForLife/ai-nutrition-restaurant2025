import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/admin.dart';

/// Uadmin 仓储接口
abstract class UadminRepository {
  Future<Either<Failure, List<Uadmin>>> getUadmins();
  Future<Either<Failure, Uadmin>> getUadmin(String id);
  Future<Either<Failure, Uadmin>> createUadmin(Uadmin admin);
  Future<Either<Failure, Uadmin>> updateUadmin(Uadmin admin);
  Future<Either<Failure, Unit>> deleteUadmin(String id);
}
