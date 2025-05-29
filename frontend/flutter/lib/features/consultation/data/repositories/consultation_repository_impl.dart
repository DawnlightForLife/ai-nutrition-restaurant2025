import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/consultation.dart';
import '../../domain/repositories/consultation_repository.dart';
import '../datasources/consultation_remote_datasource.dart';
import '../models/consultation_model.dart';

/// UconsultationRepository 实现
class UconsultationRepositoryImpl implements UconsultationRepository {
  final UconsultationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UconsultationRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Uconsultation>>> getUconsultations() async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getUconsultations();
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
  Future<Either<Failure, Uconsultation>> getUconsultation(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getUconsultation(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Uconsultation>> createUconsultation(Uconsultation consultation) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UconsultationModel.fromEntity(consultation);
        final result = await remoteDataSource.createUconsultation(model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Uconsultation>> updateUconsultation(Uconsultation consultation) async {
    if (await networkInfo.isConnected) {
      try {
        final model = UconsultationModel.fromEntity(consultation);
        final result = await remoteDataSource.updateUconsultation(consultation.id, model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUconsultation(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUconsultation(id);
        return Right(unit);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
