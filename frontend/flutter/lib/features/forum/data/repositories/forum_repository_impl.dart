import 'package:dartz/dartz.dart';
import 'package:ai_nutrition_restaurant/core/failures/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/forum.dart';
import '../../domain/repositories/forum_repository.dart';
import '../datasources/forum_remote_datasource.dart';
import '../models/forum_model.dart';

/// UforumRepository 实现
class UforumRepositoryImpl implements UforumRepository {
  final UforumRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UforumRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Uforum>>> getUforums() async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getUforums();
        final entities = models.map((model) => model.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Uforum>> getUforum(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getUforum(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Uforum>> createUforum(Uforum forum) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UforumModel.fromEntity(forum);
        final result = await remoteDataSource.createUforum(model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Uforum>> updateUforum(Uforum forum) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UforumModel.fromEntity(forum);
        final result = await remoteDataSource.updateUforum(forum.id, model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUforum(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUforum(id);
        return Right(unit);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
