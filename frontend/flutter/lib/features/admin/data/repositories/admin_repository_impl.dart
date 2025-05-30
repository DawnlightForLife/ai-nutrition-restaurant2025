import 'package:dartz/dartz.dart';
import 'package:ai_nutrition_restaurant/core/failures/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/admin.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_datasource.dart';
import '../models/admin_model.dart';

/// UadminRepository 实现
class UadminRepositoryImpl implements UadminRepository {
  final UadminRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UadminRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Uadmin>>> getUadmins() async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getUadmins();
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
  Future<Either<Failure, Uadmin>> getUadmin(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getUadmin(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Uadmin>> createUadmin(Uadmin admin) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UadminModel.fromEntity(admin);
        final result = await remoteDataSource.createUadmin(model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Uadmin>> updateUadmin(Uadmin admin) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UadminModel.fromEntity(admin);
        final result = await remoteDataSource.updateUadmin(admin.id, model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUadmin(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUadmin(id);
        return Right(unit);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
