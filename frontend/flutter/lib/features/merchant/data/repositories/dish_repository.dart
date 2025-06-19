import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/dish_entity.dart';
import '../models/dish_model.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/network/api_client.dart';

abstract class DishRepository {
  Future<Either<Failure, List<DishEntity>>> getDishes(String merchantId);
  Future<Either<Failure, DishEntity>> getDishById(String dishId);
  Future<Either<Failure, DishEntity>> createDish(DishCreateRequest request);
  Future<Either<Failure, DishEntity>> updateDish(String dishId, DishUpdateRequest request);
  Future<Either<Failure, void>> deleteDish(String dishId);
  Future<Either<Failure, List<String>>> uploadDishImages(String dishId, List<File> images);
  Future<Either<Failure, List<StoreDishEntity>>> getStoreDishes(String storeId);
  Future<Either<Failure, StoreDishEntity>> updateStoreDish(String storeDishId, StoreDishUpdateRequest request);
}

class DishRepositoryImpl implements DishRepository {
  final ApiClient _apiClient;

  DishRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, List<DishEntity>>> getDishes(String merchantId) async {
    try {
      final response = await _apiClient.get('/merchant/dishes-enhanced', 
        queryParameters: {'merchantId': merchantId}
      );
      
      final responseData = response.data['data'] ?? {};
      final List<dynamic> dishesJson = responseData['dishes'] ?? [];
      final dishes = dishesJson.map((json) => DishModel.fromJson(json).toEntity()).toList();
      
      return Right(dishes);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to fetch dishes'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DishEntity>> getDishById(String dishId) async {
    try {
      final response = await _apiClient.get('/merchant/dishes-enhanced/$dishId');
      
      final dishJson = response.data['data'];
      final dish = DishModel.fromJson(dishJson).toEntity();
      
      return Right(dish);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to fetch dish'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DishEntity>> createDish(DishCreateRequest request) async {
    try {
      final response = await _apiClient.post('/merchant/dishes-enhanced', 
        data: request.toJson()
      );
      
      final dishJson = response.data['data'];
      final dish = DishModel.fromJson(dishJson).toEntity();
      
      return Right(dish);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to create dish'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DishEntity>> updateDish(String dishId, DishUpdateRequest request) async {
    try {
      final response = await _apiClient.put('/merchant/dishes-enhanced/$dishId', 
        data: request.toJson()
      );
      
      final dishJson = response.data['data'];
      final dish = DishModel.fromJson(dishJson).toEntity();
      
      return Right(dish);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to update dish'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDish(String dishId) async {
    try {
      await _apiClient.delete('/merchant/dishes-enhanced/$dishId');
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to delete dish'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadDishImages(String dishId, List<File> images) async {
    try {
      final formData = FormData();
      
      for (int i = 0; i < images.length; i++) {
        final file = images[i];
        formData.files.add(MapEntry(
          'images',
          await MultipartFile.fromFile(
            file.path,
            filename: 'dish_image_$i.${file.path.split('.').last}',
          ),
        ));
      }

      final response = await _apiClient.post(
        '/merchant/dishes-enhanced/$dishId/images',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      final List<dynamic> imageUrls = response.data['data']['imageUrls'] ?? [];
      return Right(imageUrls.cast<String>());
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to upload images'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StoreDishEntity>>> getStoreDishes(String storeId) async {
    try {
      final response = await _apiClient.get('/merchant/dishes-enhanced/store/$storeId/dishes');
      
      final List<dynamic> dishesJson = response.data['data'] ?? [];
      final dishes = dishesJson.map((json) => StoreDishModel.fromJson(json).toEntity()).toList();
      
      return Right(dishes);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to fetch store dishes'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, StoreDishEntity>> updateStoreDish(String storeDishId, StoreDishUpdateRequest request) async {
    try {
      final response = await _apiClient.put('/merchant/dishes-enhanced/store-dish/$storeDishId', 
        data: request.toJson()
      );
      
      final dishJson = response.data['data'];
      final dish = StoreDishModel.fromJson(dishJson).toEntity();
      
      return Right(dish);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to update store dish'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}