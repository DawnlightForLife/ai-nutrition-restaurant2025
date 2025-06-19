import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/inventory_entity.dart';
import '../models/inventory_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<InventoryEntity>>> getInventoryList(String merchantId);
  Future<Either<Failure, InventoryEntity>> getInventoryById(String inventoryId);
  Future<Either<Failure, InventoryEntity>> createInventory(InventoryCreateRequest request);
  Future<Either<Failure, InventoryEntity>> addStock(String inventoryId, StockAddRequest request);
  Future<Either<Failure, InventoryEntity>> consumeStock(String inventoryId, StockConsumeRequest request);
  Future<Either<Failure, List<InventoryAlert>>> getInventoryAlerts(String merchantId);
  Future<Either<Failure, InventoryEntity>> removeExpiredStock(String inventoryId);
  Future<Either<Failure, Map<String, dynamic>>> getInventoryAnalytics(String merchantId);
  Future<Either<Failure, InventoryEntity>> updateInventorySettings(String inventoryId, AlertSettings alertSettings);
}

class InventoryRepositoryImpl implements InventoryRepository {
  final ApiClient _apiClient;

  InventoryRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, List<InventoryEntity>>> getInventoryList(String merchantId) async {
    try {
      final response = await _apiClient.get('/merchant/inventory', 
        queryParameters: {'merchantId': merchantId}
      );
      
      final List<dynamic> inventoryJson = response.data['data'] ?? [];
      final inventories = inventoryJson.map((json) => InventoryModel.fromJson(json).toEntity()).toList();
      
      return Right(inventories);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch inventory'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InventoryEntity>> getInventoryById(String inventoryId) async {
    try {
      final response = await _apiClient.get('/merchant/inventory/$inventoryId');
      
      final inventoryJson = response.data['data'];
      final inventory = InventoryModel.fromJson(inventoryJson).toEntity();
      
      return Right(inventory);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch inventory'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InventoryEntity>> createInventory(InventoryCreateRequest request) async {
    try {
      final response = await _apiClient.post('/merchant/inventory', 
        data: request.toJson()
      );
      
      final inventoryJson = response.data['data'];
      final inventory = InventoryModel.fromJson(inventoryJson).toEntity();
      
      return Right(inventory);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to create inventory'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InventoryEntity>> addStock(String inventoryId, StockAddRequest request) async {
    try {
      final response = await _apiClient.post('/merchant/inventory/$inventoryId/stock', 
        data: request.toJson()
      );
      
      final inventoryJson = response.data['data'];
      final inventory = InventoryModel.fromJson(inventoryJson).toEntity();
      
      return Right(inventory);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to add stock'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InventoryEntity>> consumeStock(String inventoryId, StockConsumeRequest request) async {
    try {
      final response = await _apiClient.post('/merchant/inventory/$inventoryId/consume', 
        data: request.toJson()
      );
      
      final inventoryJson = response.data['data'];
      final inventory = InventoryModel.fromJson(inventoryJson).toEntity();
      
      return Right(inventory);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to consume stock'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InventoryAlert>>> getInventoryAlerts(String merchantId) async {
    try {
      final response = await _apiClient.get('/merchant/inventory/alerts', 
        queryParameters: {'merchantId': merchantId}
      );
      
      final List<dynamic> alertsJson = response.data['data'] ?? [];
      final alerts = alertsJson.map((json) => InventoryAlertModel.fromJson(json).toEntity()).toList();
      
      return Right(alerts);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch alerts'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InventoryEntity>> removeExpiredStock(String inventoryId) async {
    try {
      final response = await _apiClient.delete('/merchant/inventory/$inventoryId/expired');
      
      final inventoryJson = response.data['data'];
      final inventory = InventoryModel.fromJson(inventoryJson).toEntity();
      
      return Right(inventory);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to remove expired stock'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getInventoryAnalytics(String merchantId) async {
    try {
      final response = await _apiClient.get('/merchant/inventory/analytics', 
        queryParameters: {'merchantId': merchantId}
      );
      
      return Right(response.data['data'] ?? {});
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch analytics'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InventoryEntity>> updateInventorySettings(
    String inventoryId, 
    AlertSettings alertSettings
  ) async {
    try {
      final response = await _apiClient.put('/merchant/inventory/$inventoryId/settings', 
        data: {
          'alertSettings': {
            'lowStockAlert': alertSettings.lowStockAlert,
            'expiryAlert': alertSettings.expiryAlert,
            'qualityAlert': alertSettings.qualityAlert,
            'expiryWarningDays': alertSettings.expiryWarningDays,
            'lowStockRatio': alertSettings.lowStockRatio,
          }
        }
      );
      
      final inventoryJson = response.data['data'];
      final inventory = InventoryModel.fromJson(inventoryJson).toEntity();
      
      return Right(inventory);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update settings'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}