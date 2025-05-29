import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/forum.dart';

/// Uforum 仓储接口
abstract class UforumRepository {
  Future<Either<Failure, List<Uforum>>> getUforums();
  Future<Either<Failure, Uforum>> getUforum(String id);
  Future<Either<Failure, Uforum>> createUforum(Uforum forum);
  Future<Either<Failure, Uforum>> updateUforum(Uforum forum);
  Future<Either<Failure, Unit>> deleteUforum(String id);
}
