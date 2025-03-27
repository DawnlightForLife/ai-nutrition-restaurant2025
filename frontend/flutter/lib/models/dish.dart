import 'nutrition_profile.dart';

/// 菜品模型
class Dish {
  final String id;
  final String merchantId;
  final String name;
  final String? description;
  final double price;
  final double? discountPrice;
  final String? imageUrl;
  final List<String> categories;
  final bool isAvailable;
  final Map<String, dynamic>? nutritionInfo;
  final Map<String, dynamic>? ingredients;
  final int popularity;
  final DateTime createdAt;
  final DateTime updatedAt;

  Dish({
    required this.id,
    required this.merchantId,
    required this.name,
    this.description,
    required this.price,
    this.discountPrice,
    this.imageUrl,
    required this.categories,
    this.isAvailable = true,
    this.nutritionInfo,
    this.ingredients,
    this.popularity = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从JSON创建Dish对象
  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['_id'] ?? json['id'] ?? '',
      merchantId: json['merchantId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: json['discountPrice']?.toDouble(),
      imageUrl: json['imageUrl'],
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : [],
      isAvailable: json['isAvailable'] ?? true,
      nutritionInfo: json['nutritionInfo'],
      ingredients: json['ingredients'],
      popularity: json['popularity'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// 将Dish对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchantId': merchantId,
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'imageUrl': imageUrl,
      'categories': categories,
      'isAvailable': isAvailable,
      'nutritionInfo': nutritionInfo,
      'ingredients': ingredients,
      'popularity': popularity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// 用于调试的字符串表示
  @override
  String toString() {
    return 'Dish{id: $id, name: $name, merchantId: $merchantId, '
           'price: $price, discountPrice: $discountPrice, isAvailable: $isAvailable}';
  }

  /// 创建带有更新属性的Dish副本
  Dish copyWith({
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    String? imageUrl,
    List<String>? categories,
    bool? isAvailable,
    Map<String, dynamic>? nutritionInfo,
    Map<String, dynamic>? ingredients,
    int? popularity,
  }) {
    return Dish(
      id: id,
      merchantId: merchantId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      isAvailable: isAvailable ?? this.isAvailable,
      nutritionInfo: nutritionInfo ?? this.nutritionInfo,
      ingredients: ingredients ?? this.ingredients,
      popularity: popularity ?? this.popularity,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
} 