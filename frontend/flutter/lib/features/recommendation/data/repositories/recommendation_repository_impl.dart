import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../datasources/recommendation_remote_datasource.dart';
import '../models/recommendation_model.dart';

/// UrecommendationRepository 实现
class UrecommendationRepositoryImpl implements UrecommendationRepository {
  final UrecommendationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UrecommendationRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Urecommendation>>> getUrecommendations() async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getUrecommendations();
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
  Future<Either<Failure, Urecommendation>> getUrecommendation(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getUrecommendation(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Urecommendation>> createUrecommendation(Urecommendation recommendation) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UrecommendationModel.fromEntity(recommendation);
        final result = await remoteDataSource.createUrecommendation(model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Urecommendation>> updateUrecommendation(Urecommendation recommendation) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UrecommendationModel.fromEntity(recommendation);
        final result = await remoteDataSource.updateUrecommendation(recommendation.id, model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUrecommendation(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUrecommendation(id);
        return Right(unit);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
