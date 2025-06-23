import 'package:dartz/dartz.dart';
import 'package:ai_nutrition_restaurant/core/failures/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/nutritionist.dart';
import '../../domain/entities/nutritionist_filter.dart';
import '../../domain/repositories/nutritionist_repository.dart';
import '../datasources/nutritionist_remote_datasource.dart';
import '../models/nutritionist_model.dart';

/// NutritionistRepository 实现
class NutritionistRepositoryImpl implements NutritionistRepository {
  final NutritionistRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NutritionistRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Nutritionist>>> getNutritionists({
    NutritionistFilter? filter,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getNutritionists(
          specialization: filter?.specialization,
          minRating: filter?.minRating,
          consultationFeeRange: filter?.priceRange != null 
              ? '{"min": ${filter!.priceRange!.start}, "max": ${filter.priceRange!.end}}'
              : null,
          limit: filter?.limit ?? 10,
          skip: filter?.offset ?? 0,
          sortBy: _mapSortBy(filter?.sortBy.name),
          sortOrder: filter?.sortAscending == false ? -1 : 1,
        );
        
        if (!response.success) {
          return Left(ServerFailure(message: response.message));
        }
        
        final entities = response.data.map((model) => model.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: '无网络连接'));
    }
  }

  @override
  Future<Either<Failure, Nutritionist>> getNutritionistById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getNutritionistById(id);
        
        if (!response.success || response.data == null) {
          return Left(ServerFailure(message: response.message));
        }
        
        return Right(response.data!.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: '无网络连接'));
    }
  }

  @override
  Future<Either<Failure, Nutritionist>> createNutritionist(Nutritionist nutritionist) async {
    if (await networkInfo.isConnected) {
      try {
        final model = NutritionistModel.fromEntity(nutritionist);
        final response = await remoteDataSource.createNutritionist(model.toJson());
        
        if (!response.success || response.data == null) {
          return Left(ServerFailure(message: response.message));
        }
        
        return Right(response.data!.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: '无网络连接'));
    }
  }

  @override
  Future<Either<Failure, Nutritionist>> updateNutritionist(Nutritionist nutritionist) async {
    if (await networkInfo.isConnected) {
      try {
        final model = NutritionistModel.fromEntity(nutritionist);
        final response = await remoteDataSource.updateNutritionist(
          nutritionist.id, 
          model.toJson(),
        );
        
        if (!response.success || response.data == null) {
          return Left(ServerFailure(message: response.message));
        }
        
        return Right(response.data!.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: '无网络连接'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNutritionist(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteNutritionist(id);
        return Right(unit);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: '无网络连接'));
    }
  }

  String? _mapSortBy(String? sortBy) {
    switch (sortBy) {
      case 'rating':
        return 'ratings.averageRating';
      case 'experience':
        return 'professionalInfo.experienceYears';
      case 'price':
        return 'serviceInfo.consultationFee';
      case 'name':
        return 'personalInfo.realName';
      default:
        return 'ratings.averageRating'; // 默认按评分排序
    }
  }
}
