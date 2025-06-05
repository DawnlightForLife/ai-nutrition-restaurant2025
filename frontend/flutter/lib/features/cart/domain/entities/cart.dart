import 'cart_item.dart';

/// 购物车实体
class Cart {
  final String userId;
  final List<CartItem> items;
  final DateTime? lastUpdated;
  final int version;
  
  const Cart({
    required this.userId,
    this.items = const [],
    this.lastUpdated,
    this.version = 0,
  });
  
  /// 按商家分组的商品
  List<CartMerchantGroup> get merchantGroups {
    final Map<String, List<CartItem>> groupedItems = {};
    
    for (final item in items) {
      if (!groupedItems.containsKey(item.merchantId)) {
        groupedItems[item.merchantId] = [];
      }
      groupedItems[item.merchantId]!.add(item);
    }
    
    return groupedItems.entries.map((entry) {
      final merchantItems = entry.value;
      final firstItem = merchantItems.first;
      
      return CartMerchantGroup(
        merchantId: entry.key,
        merchantName: firstItem.merchantName,
        items: merchantItems,
        // TODO: 从商家信息获取配送费和起送金额
        deliveryFee: 3.0,
        minOrderAmount: 20.0,
      );
    }).toList();
  }
  
  /// 所有有效商品
  List<CartItem> get validItems => items.where((item) => item.isValid).toList();
  
  /// 所有失效商品
  List<CartItem> get invalidItems => items.where((item) => !item.isValid).toList();
  
  /// 商品总数量
  int get totalQuantity => validItems.fold(0, (sum, item) => sum + item.quantity);
  
  /// 商品总价（不含配送费）
  double get totalAmount => validItems.fold(0.0, (sum, item) => sum + item.subtotal);
  
  /// 原价总价
  double get originalTotalAmount => validItems.fold(0.0, (sum, item) => sum + item.originalSubtotal);
  
  /// 节省金额
  double get savedAmount => originalTotalAmount - totalAmount;
  
  /// 配送费总计
  double get totalDeliveryFee {
    return merchantGroups
        .where((group) => group.isMinOrderAmountMet && group.isDeliveryAvailable)
        .fold(0.0, (sum, group) => sum + group.deliveryFee);
  }
  
  /// 最终总价（含配送费）
  double get finalAmount => totalAmount + totalDeliveryFee;
  
  /// 是否为空购物车
  bool get isEmpty => validItems.isEmpty;
  
  /// 是否有失效商品
  bool get hasInvalidItems => invalidItems.isNotEmpty;
  
  /// 获取指定商品
  CartItem? getItem(String itemId) {
    try {
      return items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }
  
  /// 是否包含指定菜品
  bool containsDish(String dishId) {
    return items.any((item) => item.dishId == dishId && item.isValid);
  }
  
  /// 获取指定菜品的数量
  int getDishQuantity(String dishId) {
    return validItems
        .where((item) => item.dishId == dishId)
        .fold(0, (sum, item) => sum + item.quantity);
  }
  
  /// 复制购物车
  Cart copyWith({
    String? userId,
    List<CartItem>? items,
    DateTime? lastUpdated,
    int? version,
  }) {
    return Cart(
      userId: userId ?? this.userId,
      items: items ?? this.items,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      version: version ?? this.version,
    );
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cart &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          version == other.version;
  
  @override
  int get hashCode => userId.hashCode ^ version.hashCode;
}