import '../../domain/entities/cart_item.dart';

/// 购物车商品数据模型
class CartItemModel {
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
  final String addedAt;
  final String? updatedAt;
  
  const CartItemModel({
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
  
  /// 从JSON创建模型
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      dishId: (json['dishId'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: json['description']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 1,
      specification: json['specification']?.toString(),
      customization: json['customization'] as Map<String, dynamic>?,
      isValid: json['isValid'] as bool? ?? true,
      invalidReason: json['invalidReason']?.toString(),
      merchantId: (json['merchantId'] ?? '').toString(),
      merchantName: (json['merchantName'] ?? '').toString(),
      addedAt: (json['addedAt'] ?? DateTime.now().toIso8601String()).toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
  
  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dishId': dishId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'originalPrice': originalPrice,
      'quantity': quantity,
      'specification': specification,
      'customization': customization,
      'isValid': isValid,
      'invalidReason': invalidReason,
      'merchantId': merchantId,
      'merchantName': merchantName,
      'addedAt': addedAt,
      'updatedAt': updatedAt,
    };
  }
  
  /// 转换为领域实体
  CartItem toEntity() {
    return CartItem(
      id: id,
      dishId: dishId,
      name: name,
      description: description,
      imageUrl: imageUrl,
      price: price,
      originalPrice: originalPrice,
      quantity: quantity,
      specification: specification,
      customization: customization,
      isValid: isValid,
      invalidReason: invalidReason,
      merchantId: merchantId,
      merchantName: merchantName,
      addedAt: DateTime.parse(addedAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }
  
  /// 从领域实体创建
  factory CartItemModel.fromEntity(CartItem entity) {
    return CartItemModel(
      id: entity.id,
      dishId: entity.dishId,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      price: entity.price,
      originalPrice: entity.originalPrice,
      quantity: entity.quantity,
      specification: entity.specification,
      customization: entity.customization,
      isValid: entity.isValid,
      invalidReason: entity.invalidReason,
      merchantId: entity.merchantId,
      merchantName: entity.merchantName,
      addedAt: entity.addedAt.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
    );
  }
}