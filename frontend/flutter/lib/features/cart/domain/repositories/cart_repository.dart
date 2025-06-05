import '../entities/cart.dart';
import '../entities/cart_item.dart';

/// 购物车仓储接口
abstract class CartRepository {
  /// 获取用户购物车
  Future<Cart> getCart(String userId);
  
  /// 添加商品到购物车
  Future<Cart> addToCart(String userId, CartItem item);
  
  /// 更新购物车商品数量
  Future<Cart> updateCartItemQuantity(String userId, String itemId, int quantity);
  
  /// 从购物车删除商品
  Future<Cart> removeFromCart(String userId, String itemId);
  
  /// 从购物车删除多个商品
  Future<Cart> removeMultipleFromCart(String userId, List<String> itemIds);
  
  /// 清空购物车
  Future<Cart> clearCart(String userId);
  
  /// 清理失效商品
  Future<Cart> clearInvalidItems(String userId);
  
  /// 移动商品到收藏
  Future<Cart> moveToFavorites(String userId, List<String> itemIds);
  
  /// 同步购物车到服务器
  Future<Cart> syncCart(String userId, Cart localCart);
  
  /// 获取购物车商品数量（用于Tab图标显示）
  Future<int> getCartItemCount(String userId);
  
  /// 验证购物车商品有效性
  Future<Cart> validateCartItems(String userId);
  
  /// 应用优惠券
  Future<Cart> applyCoupon(String userId, String couponId);
  
  /// 移除优惠券
  Future<Cart> removeCoupon(String userId, String couponId);
  
  /// 检查库存
  Future<Map<String, bool>> checkStock(List<String> dishIds);
  
  /// 预估配送时间和费用
  Future<Map<String, dynamic>> estimateDelivery(String userId, String addressId);
}