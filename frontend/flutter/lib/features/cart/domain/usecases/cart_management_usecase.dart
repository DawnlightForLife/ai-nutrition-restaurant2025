import '../../../../core/base/use_case.dart';
import '../entities/cart.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

/// 购物车管理用例
class CartManagementUseCase {
  final CartRepository _repository;
  
  const CartManagementUseCase(this._repository);
  
  /// 获取购物车
  Future<Cart> getCart(String userId) async {
    return await _repository.getCart(userId);
  }
  
  /// 添加商品到购物车
  Future<Cart> addToCart(String userId, CartItem item) async {
    // 检查库存
    final stockStatus = await _repository.checkStock([item.dishId]);
    if (stockStatus[item.dishId] != true) {
      throw CartException('商品库存不足');
    }
    
    return await _repository.addToCart(userId, item);
  }
  
  /// 更新商品数量
  Future<Cart> updateQuantity(String userId, String itemId, int quantity) async {
    if (quantity < 0) {
      throw CartException('商品数量不能小于0');
    }
    
    if (quantity == 0) {
      return await _repository.removeFromCart(userId, itemId);
    }
    
    // 检查库存
    final cart = await _repository.getCart(userId);
    final item = cart.getItem(itemId);
    if (item != null) {
      final stockStatus = await _repository.checkStock([item.dishId]);
      if (stockStatus[item.dishId] != true) {
        throw CartException('商品库存不足');
      }
    }
    
    return await _repository.updateCartItemQuantity(userId, itemId, quantity);
  }
  
  /// 删除商品
  Future<Cart> removeItem(String userId, String itemId) async {
    return await _repository.removeFromCart(userId, itemId);
  }
  
  /// 批量删除商品
  Future<Cart> removeMultipleItems(String userId, List<String> itemIds) async {
    if (itemIds.isEmpty) {
      throw CartException('请选择要删除的商品');
    }
    
    return await _repository.removeMultipleFromCart(userId, itemIds);
  }
  
  /// 清空购物车
  Future<Cart> clearCart(String userId) async {
    return await _repository.clearCart(userId);
  }
  
  /// 清理失效商品
  Future<Cart> clearInvalidItems(String userId) async {
    return await _repository.clearInvalidItems(userId);
  }
  
  /// 移动到收藏
  Future<Cart> moveToFavorites(String userId, List<String> itemIds) async {
    if (itemIds.isEmpty) {
      throw CartException('请选择要收藏的商品');
    }
    
    return await _repository.moveToFavorites(userId, itemIds);
  }
  
  /// 验证购物车
  Future<Cart> validateCart(String userId) async {
    return await _repository.validateCartItems(userId);
  }
  
  /// 获取购物车数量
  Future<int> getCartItemCount(String userId) async {
    return await _repository.getCartItemCount(userId);
  }
}

/// 购物车异常
class CartException implements Exception {
  final String message;
  
  const CartException(this.message);
  
  @override
  String toString() => message;
}