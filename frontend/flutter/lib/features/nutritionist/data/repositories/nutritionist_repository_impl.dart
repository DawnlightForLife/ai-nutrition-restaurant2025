import 'package:dartz/dartz.dart';
import 'package:ai_nutrition_restaurant/core/failures/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/nutritionist.dart';
import '../../domain/repositories/nutritionist_repository.dart';
import '../datasources/nutritionist_remote_datasource.dart';
import '../models/nutritionist_model.dart';

/// UnutritionistRepository 实现
class UnutritionistRepositoryImpl implements UnutritionistRepository {
  final UnutritionistRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UnutritionistRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Unutritionist>>> getUnutritionists() async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getUnutritionists();
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
  Future<Either<Failure, Unutritionist>> getUnutritionist(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getUnutritionist(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unutritionist>> createUnutritionist(Unutritionist nutritionist) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UnutritionistModel.fromEntity(nutritionist);
        final result = await remoteDataSource.createUnutritionist(model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unutritionist>> updateUnutritionist(Unutritionist nutritionist) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UnutritionistModel.fromEntity(nutritionist);
        final result = await remoteDataSource.updateUnutritionist(nutritionist.id, model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUnutritionist(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUnutritionist(id);
        return Right(unit);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
