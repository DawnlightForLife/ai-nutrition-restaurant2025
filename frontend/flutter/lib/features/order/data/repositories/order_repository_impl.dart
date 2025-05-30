import 'package:dartz/dartz.dart';
import 'package:ai_nutrition_restaurant/core/failures/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';
import '../models/order_model.dart';

/// UorderRepository 实现
class UorderRepositoryImpl implements UorderRepository {
  final UorderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UorderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Uorder>>> getUorders() async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getUorders();
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
  Future<Either<Failure, Uorder>> getUorder(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getUorder(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Uorder>> createUorder(Uorder order) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UorderModel.fromEntity(order);
        final result = await remoteDataSource.createUorder(model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Uorder>> updateUorder(Uorder order) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UorderModel.fromEntity(order);
        final result = await remoteDataSource.updateUorder(order.id, model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUorder(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUorder(id);
        return Right(unit);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
