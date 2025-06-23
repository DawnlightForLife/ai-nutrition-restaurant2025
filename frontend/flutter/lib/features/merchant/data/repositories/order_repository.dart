import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/order_entity.dart';
import '../models/order_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrderList({
    String? merchantId,
    String? storeId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId);
  Future<Either<Failure, OrderEntity>> updateOrderStatus(
    String orderId,
    OrderStatusUpdateRequest request,
  );
  Future<Either<Failure, List<OrderEntity>>> batchUpdateOrderStatus(
    BatchOrderStatusUpdateRequest request,
  );
  Future<Either<Failure, ProductionQueueEntity>> getProductionQueue(String storeId);
  Future<Either<Failure, DeliveryManagementEntity>> getDeliveryManagement(String storeId);
  Future<Either<Failure, OrderAnalyticsEntity>> getOrderAnalytics({
    String? merchantId,
    String? storeId,
    DateTime? startDate,
    DateTime? endDate,
  });
}

class OrderRepositoryImpl implements OrderRepository {
  final ApiClient _apiClient;

  OrderRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrderList({
    String? merchantId,
    String? storeId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (merchantId != null) queryParams['merchantId'] = merchantId;
      if (storeId != null) queryParams['storeId'] = storeId;
      if (status != null) queryParams['status'] = status;
      if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _apiClient.get('/merchant/orders', 
        queryParameters: queryParams
      );
      
      final responseData = response.data['data'] ?? {};
      final List<dynamic> ordersJson = responseData['orders'] ?? [];
      final orders = ordersJson.map((json) => OrderModel.fromJson(json).toEntity()).toList();
      
      return Right(orders);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch orders'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId) async {
    try {
      final response = await _apiClient.get('/merchant/orders/$orderId');
      
      final orderJson = response.data['data'];
      final order = OrderModel.fromJson(orderJson).toEntity();
      
      return Right(order);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch order'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrderStatus(
    String orderId,
    OrderStatusUpdateRequest request,
  ) async {
    try {
      final response = await _apiClient.put('/merchant/orders/$orderId/status', 
        data: request.toJson()
      );
      
      final orderJson = response.data['data'];
      final order = OrderModel.fromJson(orderJson).toEntity();
      
      return Right(order);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update order status'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> batchUpdateOrderStatus(
    BatchOrderStatusUpdateRequest request,
  ) async {
    try {
      final response = await _apiClient.post('/merchant/orders/batch/status', 
        data: request.toJson()
      );
      
      final List<dynamic> ordersJson = response.data['data'] ?? [];
      final orders = ordersJson.map((json) => OrderModel.fromJson(json).toEntity()).toList();
      
      return Right(orders);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to batch update order status'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductionQueueEntity>> getProductionQueue(String storeId) async {
    try {
      final response = await _apiClient.get('/merchant/orders/production/queue',
        queryParameters: {'storeId': storeId}
      );
      
      final data = response.data['data'];
      
      // Manually construct ProductionQueueEntity from the response
      final productionQueue = ProductionQueueEntity(
        pendingOrders: (data['pendingOrders'] as List? ?? [])
            .map((json) => OrderModel.fromJson(json).toEntity())
            .toList(),
        preparingOrders: (data['preparingOrders'] as List? ?? [])
            .map((json) => OrderModel.fromJson(json).toEntity())
            .toList(),
        readyOrders: (data['readyOrders'] as List? ?? [])
            .map((json) => OrderModel.fromJson(json).toEntity())
            .toList(),
        totalOrders: data['totalOrders'] ?? 0,
        averagePrepTime: (data['averagePrepTime'] ?? 0).toDouble(),
        lastUpdated: DateTime.parse(data['lastUpdated'] ?? DateTime.now().toIso8601String()),
      );
      
      return Right(productionQueue);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch production queue'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeliveryManagementEntity>> getDeliveryManagement(String storeId) async {
    try {
      final response = await _apiClient.get('/merchant/orders/delivery',
        queryParameters: {'storeId': storeId}
      );
      
      final data = response.data['data'];
      
      // Manually construct DeliveryManagementEntity from the response
      final deliveryManagement = DeliveryManagementEntity(
        readyForDelivery: (data['readyForDelivery'] as List? ?? [])
            .map((json) => OrderModel.fromJson(json).toEntity())
            .toList(),
        outForDelivery: (data['outForDelivery'] as List? ?? [])
            .map((json) => OrderModel.fromJson(json).toEntity())
            .toList(),
        delivered: (data['delivered'] as List? ?? [])
            .map((json) => OrderModel.fromJson(json).toEntity())
            .toList(),
        totalDeliveries: data['totalDeliveries'] ?? 0,
        averageDeliveryTime: (data['averageDeliveryTime'] ?? 0).toDouble(),
        lastUpdated: DateTime.parse(data['lastUpdated'] ?? DateTime.now().toIso8601String()),
      );
      
      return Right(deliveryManagement);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch delivery management'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderAnalyticsEntity>> getOrderAnalytics({
    String? merchantId,
    String? storeId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (merchantId != null) queryParams['merchantId'] = merchantId;
      if (storeId != null) queryParams['storeId'] = storeId;
      if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _apiClient.get('/merchant/orders/analytics',
        queryParameters: queryParams
      );
      
      final data = response.data['data'];
      
      // Manually construct OrderAnalyticsEntity from the response
      final analytics = OrderAnalyticsEntity(
        totalOrders: data['totalOrders'] ?? 0,
        completedOrders: data['completedOrders'] ?? 0,
        cancelledOrders: data['cancelledOrders'] ?? 0,
        pendingOrders: data['pendingOrders'] ?? 0,
        totalRevenue: (data['totalRevenue'] ?? 0).toDouble(),
        averageOrderValue: (data['averageOrderValue'] ?? 0).toDouble(),
        averagePrepTime: (data['averagePrepTime'] ?? 0).toDouble(),
        ordersByStatus: Map<String, int>.from(data['ordersByStatus'] ?? {}),
        revenueByDay: Map<String, double>.from(data['revenueByDay'] ?? {}),
        topDishes: (data['topDishes'] as List? ?? [])
            .map((json) => TopDishEntity(
                  dishId: json['dishId'],
                  dishName: json['dishName'],
                  orderCount: json['orderCount'],
                  revenue: (json['revenue'] ?? 0).toDouble(),
                ))
            .toList(),
        periodStart: DateTime.parse(data['periodStart'] ?? DateTime.now().toIso8601String()),
        periodEnd: DateTime.parse(data['periodEnd'] ?? DateTime.now().toIso8601String()),
      );
      
      return Right(analytics);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch order analytics'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}