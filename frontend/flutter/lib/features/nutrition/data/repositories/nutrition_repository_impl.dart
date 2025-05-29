import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/nutrition_profile.dart';
import '../../domain/repositories/nutrition_repository.dart';
import '../datasources/nutrition_api.dart';
import '../models/nutrition_profile_model.dart';

/// 营养档案仓库实现
class NutritionRepositoryImpl implements NutritionRepository {
  final NutritionApi remoteDataSource;
  final NetworkInfo networkInfo;

  NutritionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NutritionProfile>>> getNutritionProfiles(
    String userId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getNutritionProfiles(userId);
        final profiles = response.data
            .map((model) => model.toEntity())
            .toList();
        return Right(profiles);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: '无网络连接'));
    }
  }

  @override
  Future<Either<Failure, NutritionProfile>> getNutritionProfile(
    String profileId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getNutritionProfile(profileId);
        return Right(response.data.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: '无网络连接'));
    }
  }

  @override
  Future<Either<Failure, NutritionProfile>> createNutritionProfile(
    NutritionProfile profile,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final model = NutritionProfileModel.fromEntity(profile);
        final response = await remoteDataSource.createNutritionProfile(
          model.toJson(),
        );
        return Right(response.data.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: '无网络连接'));
    }
  }

  @override
  Future<Either<Failure, NutritionProfile>> updateNutritionProfile(
    NutritionProfile profile,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final model = NutritionProfileModel.fromEntity(profile);
        final response = await remoteDataSource.updateNutritionProfile(
          profile.id,
          model.toJson(),
        );
        return Right(response.data.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: '无网络连接'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNutritionProfile(
    String profileId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteNutritionProfile(profileId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: '无网络连接'));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultProfile(String profileId) async {
    // TODO: 实现设置默认档案
    return const Right(null);
  }

  @override
  Future<Either<Failure, NutritionProfile?>> getDefaultProfile(
    String userId,
  ) async {
    // TODO: 实现获取默认档案
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<DietaryPreference>>> getAvailableDietaryPreferences() async {
    // TODO: 实现获取饮食偏好列表
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<HealthCondition>>> getAvailableHealthConditions() async {
    // TODO: 实现获取健康状况列表
    return const Right([]);
  }
}