/// 购物车商品项实体
class CartItem {
  final String id;
  final String dishId;
  final String name;
  final String? description;
  final String? imageUrl;
  final double price;
  final double originalPrice;
  final int quantity;
  final String? specification;
  final Map<String, dynamic>? customization;
  final bool isValid;
  final String? invalidReason;
  final String merchantId;
  final String merchantName;
  final DateTime addedAt;
  final DateTime? updatedAt;
  
  const CartItem({
    required this.id,
    required this.dishId,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    this.specification,
    this.customization,
    this.isValid = true,
    this.invalidReason,
    required this.merchantId,
    required this.merchantName,
    required this.addedAt,
    this.updatedAt,
  });
  
  /// 计算小计
  double get subtotal => isValid ? price * quantity : 0.0;
  
  /// 计算原价小计
  double get originalSubtotal => originalPrice * quantity;
  
  /// 计算节省金额
  double get savedAmount => originalSubtotal - subtotal;
  
  /// 是否有优惠
  bool get hasDiscount => price < originalPrice;
  
  /// 规格列表（用于UI显示）
  List<String> get specifications {
    if (specification == null || specification!.trim().isEmpty) {
      return [];
    }
    return specification!.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }
  
  /// 复制并更新数量
  CartItem copyWith({
    String? id,
    String? dishId,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    double? originalPrice,
    int? quantity,
    String? specification,
    Map<String, dynamic>? customization,
    bool? isValid,
    String? invalidReason,
    String? merchantId,
    String? merchantName,
    DateTime? addedAt,
    DateTime? updatedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      dishId: dishId ?? this.dishId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      quantity: quantity ?? this.quantity,
      specification: specification ?? this.specification,
      customization: customization ?? this.customization,
      isValid: isValid ?? this.isValid,
      invalidReason: invalidReason ?? this.invalidReason,
      merchantId: merchantId ?? this.merchantId,
      merchantName: merchantName ?? this.merchantName,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}

/// 购物车商品分组（按商家）
class CartMerchantGroup {
  final String merchantId;
  final String merchantName;
  final String? merchantLogo;
  final List<CartItem> items;
  final double deliveryFee;
  final double minOrderAmount;
  final bool isDeliveryAvailable;
  
  const CartMerchantGroup({
    required this.merchantId,
    required this.merchantName,
    this.merchantLogo,
    required this.items,
    this.deliveryFee = 0.0,
    this.minOrderAmount = 0.0,
    this.isDeliveryAvailable = true,
  });
  
  /// 有效商品列表
  List<CartItem> get validItems => items.where((item) => item.isValid).toList();
  
  /// 失效商品列表
  List<CartItem> get invalidItems => items.where((item) => !item.isValid).toList();
  
  /// 商品总数量
  int get totalQuantity => validItems.fold(0, (sum, item) => sum + item.quantity);
  
  /// 商品总价
  double get totalAmount => validItems.fold(0.0, (sum, item) => sum + item.subtotal);
  
  /// 商品小计（别名，用于兼容UI代码）
  double get subtotal => totalAmount;
  
  /// 原价总价
  double get originalTotalAmount => validItems.fold(0.0, (sum, item) => sum + item.originalSubtotal);
  
  /// 节省金额
  double get savedAmount => originalTotalAmount - totalAmount;
  
  /// 是否达到起送金额
  bool get isMinOrderAmountMet => totalAmount >= minOrderAmount;
  
  /// 距离起送金额差额
  double get amountToMinOrder => minOrderAmount > totalAmount ? minOrderAmount - totalAmount : 0.0;
}