import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';
import '../datasources/cart_local_datasource.dart';
import '../models/cart_model.dart';
import '../models/cart_item_model.dart';

/// 购物车仓储实现
class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remoteDataSource;
  final CartLocalDataSource _localDataSource;
  
  const CartRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );
  
  @override
  Future<Cart> getCart(String userId) async {
    try {
      // 尝试从远程获取购物车
      final remoteCart = await _remoteDataSource.getCart(userId);
      final cart = remoteCart.toEntity();
      
      // 缓存到本地
      await _localDataSource.cacheCart(userId, remoteCart);
      
      return cart;
    } catch (e) {
      // 网络失败时从本地缓存获取
      final cachedCart = await _localDataSource.getCachedCart(userId);
      if (cachedCart != null) {
        return cachedCart.toEntity();
      }
      
      // 返回空购物车
      return Cart(userId: userId);
    }
  }
  
  @override
  Future<Cart> addToCart(String userId, CartItem item) async {
    try {
      final itemModel = CartItemModel.fromEntity(item);
      final updatedCart = await _remoteDataSource.addToCart(userId, itemModel);
      final cart = updatedCart.toEntity();
      
      // 更新本地缓存
      await _localDataSource.cacheCart(userId, updatedCart);
      
      return cart;
    } catch (e) {
      throw Exception('添加到购物车失败: $e');
    }
  }
  
  @override
  Future<Cart> updateCartItemQuantity(String userId, String itemId, int quantity) async {
    try {
      final updatedCart = await _remoteDataSource.updateCartItemQuantity(userId, itemId, quantity);
      final cart = updatedCart.toEntity();
      
      // 更新本地缓存
      await _localDataSource.cacheCart(userId, updatedCart);
      
      return cart;
    } catch (e) {
      throw Exception('更新商品数量失败: $e');
    }
  }
  
  @override
  Future<Cart> removeFromCart(String userId, String itemId) async {
    try {
      final updatedCart = await _remoteDataSource.removeFromCart(userId, itemId);
      final cart = updatedCart.toEntity();
      
      // 更新本地缓存
      await _localDataSource.cacheCart(userId, updatedCart);
      
      return cart;
    } catch (e) {
      throw Exception('删除商品失败: $e');
    }
  }
  
  @override
  Future<Cart> removeMultipleFromCart(String userId, List<String> itemIds) async {
    try {
      final updatedCart = await _remoteDataSource.removeMultipleFromCart(userId, itemIds);
      final cart = updatedCart.toEntity();
      
      // 更新本地缓存
      await _localDataSource.cacheCart(userId, updatedCart);
      
      return cart;
    } catch (e) {
      throw Exception('批量删除商品失败: $e');
    }
  }
  
  @override
  Future<Cart> clearCart(String userId) async {
    try {
      final updatedCart = await _remoteDataSource.clearCart(userId);
      final cart = updatedCart.toEntity();
      
      // 清空本地缓存
      await _localDataSource.clearCachedCart(userId);
      
      return cart;
    } catch (e) {
      throw Exception('清空购物车失败: $e');
    }
  }
  
  @override
  Future<Cart> clearInvalidItems(String userId) async {
    try {
      final updatedCart = await _remoteDataSource.clearInvalidItems(userId);
      final cart = updatedCart.toEntity();
      
      // 更新本地缓存
      await _localDataSource.cacheCart(userId, updatedCart);
      
      return cart;
    } catch (e) {
      throw Exception('清理失效商品失败: $e');
    }
  }
  
  @override
  Future<Cart> moveToFavorites(String userId, List<String> itemIds) async {
    try {
      final updatedCart = await _remoteDataSource.moveToFavorites(userId, itemIds);
      final cart = updatedCart.toEntity();
      
      // 更新本地缓存
      await _localDataSource.cacheCart(userId, updatedCart);
      
      return cart;
    } catch (e) {
      throw Exception('移动到收藏失败: $e');
    }
  }
  
  @override
  Future<Cart> syncCart(String userId, Cart localCart) async {
    try {
      final localCartModel = CartModel.fromEntity(localCart);
      final syncedCart = await _remoteDataSource.syncCart(userId, localCartModel);
      final cart = syncedCart.toEntity();
      
      // 更新本地缓存
      await _localDataSource.cacheCart(userId, syncedCart);
      
      return cart;
    } catch (e) {
      return localCart;
    }
  }
  
  @override
  Future<int> getCartItemCount(String userId) async {
    try {
      // 优先从本地缓存获取，速度更快
      final cachedCount = await _localDataSource.getCachedCartItemCount(userId);
      if (cachedCount > 0) {
        return cachedCount;
      }
      
      // 从远程获取最新数据
      final cart = await getCart(userId);
      return cart.totalQuantity;
    } catch (e) {
      return 0;
    }
  }
  
  @override
  Future<Cart> validateCartItems(String userId) async {
    try {
      final validatedCart = await _remoteDataSource.validateCartItems(userId);
      final cart = validatedCart.toEntity();
      
      // 更新本地缓存
      await _localDataSource.cacheCart(userId, validatedCart);
      
      return cart;
    } catch (e) {
      // 验证失败时返回当前购物车
      return await getCart(userId);
    }
  }
  
  @override
  Future<Cart> applyCoupon(String userId, String couponId) async {
    try {
      final updatedCart = await _remoteDataSource.applyCoupon(userId, couponId);
      final cart = updatedCart.toEntity();
      
      // 更新本地缓存
      await _localDataSource.cacheCart(userId, updatedCart);
      
      return cart;
    } catch (e) {
      throw Exception('应用优惠券失败: $e');
    }
  }
  
  @override
  Future<Cart> removeCoupon(String userId, String couponId) async {
    try {
      final updatedCart = await _remoteDataSource.removeCoupon(userId, couponId);
      final cart = updatedCart.toEntity();
      
      // 更新本地缓存
      await _localDataSource.cacheCart(userId, updatedCart);
      
      return cart;
    } catch (e) {
      throw Exception('移除优惠券失败: $e');
    }
  }
  
  @override
  Future<Map<String, bool>> checkStock(List<String> dishIds) async {
    try {
      return await _remoteDataSource.checkStock(dishIds);
    } catch (e) {
      // 默认返回所有商品有库存
      return Map.fromEntries(dishIds.map((id) => MapEntry(id, true)));
    }
  }
  
  @override
  Future<Map<String, dynamic>> estimateDelivery(String userId, String addressId) async {
    try {
      return await _remoteDataSource.estimateDelivery(userId, addressId);
    } catch (e) {
      return {
        'deliveryFee': 3.0,
        'estimatedTime': '约30分钟',
        'isAvailable': true,
        'message': null,
      };
    }
  }
}