import '../../domain/entities/cart.dart';
import 'cart_item_model.dart';

/// 购物车数据模型
class CartModel {
  final String userId;
  final List<CartItemModel> items;
  final String? lastUpdated;
  final int version;
  
  const CartModel({
    required this.userId,
    this.items = const [],
    this.lastUpdated,
    this.version = 0,
  });
  
  /// 从JSON创建模型
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      userId: (json['userId'] ?? '').toString(),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      lastUpdated: json['lastUpdated']?.toString(),
      version: json['version'] as int? ?? 0,
    );
  }
  
  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'lastUpdated': lastUpdated,
      'version': version,
    };
  }
  
  /// 转换为领域实体
  Cart toEntity() {
    return Cart(
      userId: userId,
      items: items.map((item) => item.toEntity()).toList(),
      lastUpdated: lastUpdated != null ? DateTime.parse(lastUpdated!) : null,
      version: version,
    );
  }
  
  /// 从领域实体创建
  factory CartModel.fromEntity(Cart entity) {
    return CartModel(
      userId: entity.userId,
      items: entity.items.map((item) => CartItemModel.fromEntity(item)).toList(),
      lastUpdated: entity.lastUpdated?.toIso8601String(),
      version: entity.version,
    );
  }
}