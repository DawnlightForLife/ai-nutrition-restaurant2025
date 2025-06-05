import 'package:dio/dio.dart';
import '../models/cart_model.dart';
import '../models/cart_item_model.dart';

/// 购物车远程数据源接口
abstract class CartRemoteDataSource {
  Future<CartModel> getCart(String userId);
  Future<CartModel> addToCart(String userId, CartItemModel item);
  Future<CartModel> updateCartItemQuantity(String userId, String itemId, int quantity);
  Future<CartModel> removeFromCart(String userId, String itemId);
  Future<CartModel> removeMultipleFromCart(String userId, List<String> itemIds);
  Future<CartModel> clearCart(String userId);
  Future<CartModel> clearInvalidItems(String userId);
  Future<CartModel> moveToFavorites(String userId, List<String> itemIds);
  Future<CartModel> syncCart(String userId, CartModel localCart);
  Future<CartModel> validateCartItems(String userId);
  Future<CartModel> applyCoupon(String userId, String couponId);
  Future<CartModel> removeCoupon(String userId, String couponId);
  Future<Map<String, bool>> checkStock(List<String> dishIds);
  Future<Map<String, dynamic>> estimateDelivery(String userId, String addressId);
}

/// 购物车远程数据源实现
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio _dio;
  
  const CartRemoteDataSourceImpl(this._dio);
  
  @override
  Future<CartModel> getCart(String userId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/cart/$userId');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          return CartModel.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
      
      return _getDefaultCart(userId);
    } catch (e) {
      return _getDefaultCart(userId);
    }
  }
  
  @override
  Future<CartModel> addToCart(String userId, CartItemModel item) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/cart/$userId/items',
        data: item.toJson(),
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          return CartModel.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
      
      throw Exception('添加商品到购物车失败');
    } catch (e) {
      throw Exception('添加商品到购物车失败: $e');
    }
  }
  
  @override
  Future<CartModel> updateCartItemQuantity(String userId, String itemId, int quantity) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/cart/$userId/items/$itemId',
        data: {'quantity': quantity},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          return CartModel.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
      
      throw Exception('更新商品数量失败');
    } catch (e) {
      throw Exception('更新商品数量失败: $e');
    }
  }
  
  @override
  Future<CartModel> removeFromCart(String userId, String itemId) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>('/cart/$userId/items/$itemId');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          return CartModel.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
      
      throw Exception('删除商品失败');
    } catch (e) {
      throw Exception('删除商品失败: $e');
    }
  }
  
  @override
  Future<CartModel> removeMultipleFromCart(String userId, List<String> itemIds) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        '/cart/$userId/items/batch',
        data: {'itemIds': itemIds},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          return CartModel.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
      
      throw Exception('批量删除商品失败');
    } catch (e) {
      throw Exception('批量删除商品失败: $e');
    }
  }
  
  @override
  Future<CartModel> clearCart(String userId) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>('/cart/$userId');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true) {
          return _getDefaultCart(userId);
        }
      }
      
      throw Exception('清空购物车失败');
    } catch (e) {
      throw Exception('清空购物车失败: $e');
    }
  }
  
  @override
  Future<CartModel> clearInvalidItems(String userId) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>('/cart/$userId/invalid-items');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          return CartModel.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
      
      throw Exception('清理失效商品失败');
    } catch (e) {
      throw Exception('清理失效商品失败: $e');
    }
  }
  
  @override
  Future<CartModel> moveToFavorites(String userId, List<String> itemIds) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/cart/$userId/move-to-favorites',
        data: {'itemIds': itemIds},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          return CartModel.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
      
      throw Exception('移动到收藏失败');
    } catch (e) {
      throw Exception('移动到收藏失败: $e');
    }
  }
  
  @override
  Future<CartModel> syncCart(String userId, CartModel localCart) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/cart/$userId/sync',
        data: localCart.toJson(),
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          return CartModel.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
      
      return localCart;
    } catch (e) {
      return localCart;
    }
  }
  
  @override
  Future<CartModel> validateCartItems(String userId) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/cart/$userId/validate');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          return CartModel.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
      
      return await getCart(userId);
    } catch (e) {
      return await getCart(userId);
    }
  }
  
  @override
  Future<CartModel> applyCoupon(String userId, String couponId) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/cart/$userId/coupon',
        data: {'couponId': couponId},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          return CartModel.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
      
      throw Exception('应用优惠券失败');
    } catch (e) {
      throw Exception('应用优惠券失败: $e');
    }
  }
  
  @override
  Future<CartModel> removeCoupon(String userId, String couponId) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>('/cart/$userId/coupon/$couponId');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          return CartModel.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
      
      throw Exception('移除优惠券失败');
    } catch (e) {
      throw Exception('移除优惠券失败: $e');
    }
  }
  
  @override
  Future<Map<String, bool>> checkStock(List<String> dishIds) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/dishes/check-stock',
        data: {'dishIds': dishIds},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          return Map<String, bool>.from(data['data'] as Map);
        }
      }
      
      // 默认返回所有商品有库存
      return Map.fromEntries(dishIds.map((id) => MapEntry(id, true)));
    } catch (e) {
      // 默认返回所有商品有库存
      return Map.fromEntries(dishIds.map((id) => MapEntry(id, true)));
    }
  }
  
  @override
  Future<Map<String, dynamic>> estimateDelivery(String userId, String addressId) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/cart/$userId/estimate-delivery',
        data: {'addressId': addressId},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          return data['data'] as Map<String, dynamic>;
        }
      }
      
      return _getDefaultDeliveryEstimate();
    } catch (e) {
      return _getDefaultDeliveryEstimate();
    }
  }
  
  /// 获取默认购物车
  CartModel _getDefaultCart(String userId) {
    return CartModel(
      userId: userId,
      items: const [],
      lastUpdated: DateTime.now().toIso8601String(),
      version: 0,
    );
  }
  
  /// 获取默认配送预估
  Map<String, dynamic> _getDefaultDeliveryEstimate() {
    return {
      'deliveryFee': 3.0,
      'estimatedTime': '约30分钟',
      'isAvailable': true,
      'message': null,
    };
  }
}