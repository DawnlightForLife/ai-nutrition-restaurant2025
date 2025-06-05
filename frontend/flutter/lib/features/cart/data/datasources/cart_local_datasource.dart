import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';

/// 购物车本地数据源接口
abstract class CartLocalDataSource {
  Future<CartModel?> getCachedCart(String userId);
  Future<void> cacheCart(String userId, CartModel cart);
  Future<void> clearCachedCart(String userId);
  Future<int> getCachedCartItemCount(String userId);
}

/// 购物车本地数据源实现
class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences _prefs;
  static const String _cartPrefix = 'cart_';
  
  const CartLocalDataSourceImpl(this._prefs);
  
  @override
  Future<CartModel?> getCachedCart(String userId) async {
    try {
      final cartJson = _prefs.getString('$_cartPrefix$userId');
      if (cartJson != null) {
        final cartData = jsonDecode(cartJson) as Map<String, dynamic>;
        return CartModel.fromJson(cartData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<void> cacheCart(String userId, CartModel cart) async {
    try {
      final cartJson = jsonEncode(cart.toJson());
      await _prefs.setString('$_cartPrefix$userId', cartJson);
    } catch (e) {
      // 忽略缓存错误
    }
  }
  
  @override
  Future<void> clearCachedCart(String userId) async {
    try {
      await _prefs.remove('$_cartPrefix$userId');
    } catch (e) {
      // 忽略清理错误
    }
  }
  
  @override
  Future<int> getCachedCartItemCount(String userId) async {
    try {
      final cart = await getCachedCart(userId);
      if (cart != null) {
        final validItems = cart.items.where((item) => item.isValid).toList();
        return validItems.fold(0, (sum, item) => sum + item.quantity);
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}