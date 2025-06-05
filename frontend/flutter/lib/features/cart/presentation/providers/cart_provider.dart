import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/cart_management_usecase.dart';
import '../../domain/usecases/cart_checkout_usecase.dart';

/// 购物车状态
class CartState {
  final Cart cart;
  final bool isLoading;
  final String? error;
  final bool isManagementMode;
  final Set<String> selectedItemIds;
  
  const CartState({
    required this.cart,
    this.isLoading = false,
    this.error,
    this.isManagementMode = false,
    this.selectedItemIds = const {},
  });
  
  CartState copyWith({
    Cart? cart,
    bool? isLoading,
    String? error,
    bool? isManagementMode,
    Set<String>? selectedItemIds,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isManagementMode: isManagementMode ?? this.isManagementMode,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
    );
  }
  
  /// 是否全选
  bool get isAllSelected {
    if (cart.validItems.isEmpty) return false;
    return cart.validItems.every((item) => selectedItemIds.contains(item.id));
  }
  
  /// 选中的商品
  List<CartItem> get selectedItems {
    return cart.validItems.where((item) => selectedItemIds.contains(item.id)).toList();
  }
  
  /// 选中商品的总价
  double get selectedAmount {
    return selectedItems.fold(0.0, (sum, item) => sum + item.subtotal);
  }
}

/// 购物车状态通知器
class CartNotifier extends StateNotifier<CartState> {
  final CartManagementUseCase _cartUseCase;
  final CartCheckoutUseCase _checkoutUseCase;
  final String _userId;
  
  CartNotifier(
    this._cartUseCase,
    this._checkoutUseCase,
    this._userId,
  ) : super(CartState(cart: Cart(userId: _userId))) {
    _loadCart();
  }
  
  /// 加载购物车
  Future<void> _loadCart() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final cart = await _cartUseCase.getCart(_userId);
      state = state.copyWith(
        cart: cart,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '加载购物车失败: $e',
      );
    }
  }
  
  /// 添加商品到购物车
  Future<void> addToCart(CartItem item) async {
    try {
      final updatedCart = await _cartUseCase.addToCart(_userId, item);
      state = state.copyWith(cart: updatedCart, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// 更新商品数量
  Future<void> updateQuantity(String itemId, int quantity) async {
    try {
      final updatedCart = await _cartUseCase.updateQuantity(_userId, itemId, quantity);
      state = state.copyWith(cart: updatedCart, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// 删除商品
  Future<void> removeItem(String itemId) async {
    try {
      final updatedCart = await _cartUseCase.removeItem(_userId, itemId);
      state = state.copyWith(cart: updatedCart, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// 批量删除选中商品
  Future<void> removeSelectedItems() async {
    if (state.selectedItemIds.isEmpty) {
      state = state.copyWith(error: '请选择要删除的商品');
      return;
    }
    
    try {
      final updatedCart = await _cartUseCase.removeMultipleItems(_userId, state.selectedItemIds.toList());
      state = state.copyWith(
        cart: updatedCart,
        selectedItemIds: {},
        isManagementMode: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// 移动选中商品到收藏
  Future<void> moveSelectedToFavorites() async {
    if (state.selectedItemIds.isEmpty) {
      state = state.copyWith(error: '请选择要收藏的商品');
      return;
    }
    
    try {
      final updatedCart = await _cartUseCase.moveToFavorites(_userId, state.selectedItemIds.toList());
      state = state.copyWith(
        cart: updatedCart,
        selectedItemIds: {},
        isManagementMode: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// 清空购物车
  Future<void> clearCart() async {
    try {
      final updatedCart = await _cartUseCase.clearCart(_userId);
      state = state.copyWith(
        cart: updatedCart,
        selectedItemIds: {},
        isManagementMode: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// 清理失效商品
  Future<void> clearInvalidItems() async {
    try {
      final updatedCart = await _cartUseCase.clearInvalidItems(_userId);
      state = state.copyWith(cart: updatedCart, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// 切换管理模式
  void toggleManagementMode() {
    state = state.copyWith(
      isManagementMode: !state.isManagementMode,
      selectedItemIds: {},
    );
  }
  
  /// 退出管理模式
  void exitManagementMode() {
    state = state.copyWith(
      isManagementMode: false,
      selectedItemIds: {},
    );
  }
  
  /// 切换商品选中状态
  void toggleItemSelection(String itemId) {
    final selectedIds = Set<String>.from(state.selectedItemIds);
    
    if (selectedIds.contains(itemId)) {
      selectedIds.remove(itemId);
    } else {
      selectedIds.add(itemId);
    }
    
    state = state.copyWith(selectedItemIds: selectedIds);
  }
  
  /// 全选/反选
  void toggleSelectAll() {
    if (state.isAllSelected) {
      // 取消全选
      state = state.copyWith(selectedItemIds: {});
    } else {
      // 全选
      final allValidIds = state.cart.validItems.map((item) => item.id).toSet();
      state = state.copyWith(selectedItemIds: allValidIds);
    }
  }
  
  /// 验证结算
  Future<CheckoutValidation> validateCheckout() async {
    try {
      return await _checkoutUseCase.validateCheckout(_userId);
    } catch (e) {
      return CheckoutValidation(
        isValid: false,
        message: '验证失败: $e',
      );
    }
  }
  
  /// 刷新购物车
  Future<void> refresh() async {
    await _loadCart();
  }
  
  /// 清除错误状态
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// 依赖提供者
final cartUseCaseProvider = Provider<CartManagementUseCase>((ref) {
  throw UnimplementedError('CartManagementUseCase not implemented');
});

final checkoutUseCaseProvider = Provider<CartCheckoutUseCase>((ref) {
  throw UnimplementedError('CartCheckoutUseCase not implemented');
});

final currentUserIdProvider = Provider<String>((ref) {
  // TODO: 从用户认证状态获取
  return 'test-user-id';
});

// 简化版购物车provider（仅用于测试）
final testCartProvider = StateNotifierProvider<TestCartNotifier, Cart>((ref) {
  return TestCartNotifier();
});

/// 测试用的购物车通知器
class TestCartNotifier extends StateNotifier<Cart> {
  TestCartNotifier() : super(_createTestCart());
  
  static Cart _createTestCart() {
    final now = DateTime.now();
    
    final testItems = [
      CartItem(
        id: '1',
        dishId: 'dish_1',
        name: '宫保鸡丁',
        description: '川菜经典，麻辣鲜香',
        imageUrl: null,
        price: 28.0,
        originalPrice: 32.0,
        quantity: 2,
        specification: '微辣,去花生',
        merchantId: 'merchant_1',
        merchantName: '川味小厨',
        addedAt: now,
      ),
      CartItem(
        id: '2',
        dishId: 'dish_2',
        name: '麻婆豆腐',
        description: '嫩滑豆腐，香辣可口',
        imageUrl: null,
        price: 18.0,
        originalPrice: 18.0,
        quantity: 1,
        specification: '中辣',
        merchantId: 'merchant_1',
        merchantName: '川味小厨',
        addedAt: now,
      ),
      CartItem(
        id: '3',
        dishId: 'dish_3',
        name: '小笼包',
        description: '皮薄馅多，汤汁鲜美',
        imageUrl: null,
        price: 15.0,
        originalPrice: 15.0,
        quantity: 1,
        specification: '8只装',
        merchantId: 'merchant_2',
        merchantName: '江南点心',
        addedAt: now,
        isValid: false,
        invalidReason: '商品已下架',
      ),
    ];
    
    return Cart(
      userId: 'test-user-id',
      items: testItems,
      lastUpdated: now,
    );
  }
  
  void updateQuantity(String itemId, int quantity) {
    final items = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: quantity, updatedAt: DateTime.now());
      }
      return item;
    }).toList();
    
    state = state.copyWith(items: items, lastUpdated: DateTime.now());
  }
  
  void removeItem(String itemId) {
    final items = state.items.where((item) => item.id != itemId).toList();
    state = state.copyWith(items: items, lastUpdated: DateTime.now());
  }
  
  void addItem(CartItem item) {
    final items = [...state.items, item];
    state = state.copyWith(items: items, lastUpdated: DateTime.now());
  }
}

// 导出用于测试的购物车provider别名
final cartProvider = testCartProvider;