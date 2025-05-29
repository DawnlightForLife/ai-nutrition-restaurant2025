import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/common.dart';
import '../../domain/repositories/common_repository.dart';
import '../datasources/common_remote_datasource.dart';
import '../models/common_model.dart';

/// UcommonRepository 实现
class UcommonRepositoryImpl implements UcommonRepository {
  final UcommonRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UcommonRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Ucommon>>> getUcommons() async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getUcommons();
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
  Future<Either<Failure, Ucommon>> getUcommon(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getUcommon(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Ucommon>> createUcommon(Ucommon common) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UcommonModel.fromEntity(common);
        final result = await remoteDataSource.createUcommon(model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Ucommon>> updateUcommon(Ucommon common) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UcommonModel.fromEntity(common);
        final result = await remoteDataSource.updateUcommon(common.id, model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUcommon(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUcommon(id);
        return Right(unit);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
