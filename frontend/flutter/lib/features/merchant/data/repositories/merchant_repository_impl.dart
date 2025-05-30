import 'package:dartz/dartz.dart';
import 'package:ai_nutrition_restaurant/core/failures/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/repositories/merchant_repository.dart';
import '../datasources/merchant_remote_datasource.dart';
import '../models/merchant_model.dart';

/// UmerchantRepository 实现
class UmerchantRepositoryImpl implements UmerchantRepository {
  final UmerchantRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UmerchantRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Umerchant>>> getUmerchants() async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getUmerchants();
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
  Future<Either<Failure, Umerchant>> getUmerchant(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getUmerchant(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Umerchant>> createUmerchant(Umerchant merchant) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UmerchantModel.fromEntity(merchant);
        final result = await remoteDataSource.createUmerchant(model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Umerchant>> updateUmerchant(Umerchant merchant) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UmerchantModel.fromEntity(merchant);
        final result = await remoteDataSource.updateUmerchant(merchant.id, model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUmerchant(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUmerchant(id);
        return Right(unit);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
