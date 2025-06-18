import 'package:dio/dio.dart';
import '../models/cart_order_model.dart';

/// 购物车订单远程数据源接口
abstract class CartOrderRemoteDataSource {
  /// 创建订单
  Future<CartOrderModel> createOrder(CartOrderModel order);
  
  /// 获取订单详情
  Future<CartOrderModel> getOrder(String orderId);
  
  /// 获取用户订单列表
  Future<List<CartOrderModel>> getUserOrders(String userId);
  
  /// 更新订单状态
  Future<CartOrderModel> updateOrderStatus(String orderId, String status);
  
  /// 取消订单
  Future<void> cancelOrder(String orderId);
}

/// 购物车订单远程数据源实现
class CartOrderRemoteDataSourceImpl implements CartOrderRemoteDataSource {
  final Dio _dio;

  CartOrderRemoteDataSourceImpl(this._dio);

  @override
  Future<CartOrderModel> createOrder(CartOrderModel order) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/orders',
        data: order.toJson(),
      );
      
      return CartOrderModel.fromJson(response.data!['data'] as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(message: '创建订单失败: ${e.toString()}');
    }
  }

  @override
  Future<CartOrderModel> getOrder(String orderId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/api/orders/$orderId');
      return CartOrderModel.fromJson(response.data!['data'] as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(message: '获取订单失败: ${e.toString()}');
    }
  }

  @override
  Future<List<CartOrderModel>> getUserOrders(String userId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/orders',
        queryParameters: {'userId': userId},
      );
      
      final List<dynamic> data = response.data!['data'] as List<dynamic>;
      return data.map((json) => CartOrderModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ServerException(message: '获取订单列表失败: ${e.toString()}');
    }
  }

  @override
  Future<CartOrderModel> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/api/orders/$orderId/status',
        data: {'status': status},
      );
      
      return CartOrderModel.fromJson(response.data!['data'] as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(message: '更新订单状态失败: ${e.toString()}');
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      await _dio.put<void>(
        '/api/orders/$orderId/cancel',
      );
    } catch (e) {
      throw ServerException(message: '取消订单失败: ${e.toString()}');
    }
  }
}

/// 服务器异常
class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}