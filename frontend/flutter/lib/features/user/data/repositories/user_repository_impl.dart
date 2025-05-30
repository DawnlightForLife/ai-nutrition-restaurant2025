import 'package:dartz/dartz.dart';
import 'package:ai_nutrition_restaurant/core/failures/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/user_model.dart';

/// UuserRepository 实现
class UuserRepositoryImpl implements UuserRepository {
  final UuserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UuserRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Uuser>>> getUusers() async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getUusers();
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
  Future<Either<Failure, Uuser>> getUuser(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getUuser(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Uuser>> createUuser(Uuser user) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UuserModel.fromEntity(user);
        final result = await remoteDataSource.createUuser(model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Uuser>> updateUuser(Uuser user) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UuserModel.fromEntity(user);
        final result = await remoteDataSource.updateUuser(user.id, model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUuser(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUuser(id);
        return Right(unit);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
