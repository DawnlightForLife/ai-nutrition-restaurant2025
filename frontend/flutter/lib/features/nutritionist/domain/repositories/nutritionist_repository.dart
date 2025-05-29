import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/nutritionist.dart';

/// Unutritionist 仓储接口
abstract class UnutritionistRepository {
  Future<Either<Failure, List<Unutritionist>>> getUnutritionists();
  Future<Either<Failure, Unutritionist>> getUnutritionist(String id);
  Future<Either<Failure, Unutritionist>> createUnutritionist(Unutritionist nutritionist);
  Future<Either<Failure, Unutritionist>> updateUnutritionist(Unutritionist nutritionist);
  Future<Either<Failure, Unit>> deleteUnutritionist(String id);
}
