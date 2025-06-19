import 'package:freezed_annotation/freezed_annotation.dart';

part 'dish_entity.freezed.dart';
part 'dish_entity.g.dart';

@freezed
class DishEntity with _$DishEntity {
  const factory DishEntity({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String description,
    @JsonKey(name: 'imageUrl') String? imageUrl,
    @Default([]) List<String> imageUrls, // 多图片支持
    required double price,
    @JsonKey(name: 'discountedPrice') double? discountedPrice,
    required String category,
    String? subCategory,
    @Default([]) List<String> tags,
    @Default({}) Map<String, dynamic> nutritionFacts,
    @Default([]) List<String> nutritionAttributes,
    @Default([]) List<String> ingredients,
    @Default([]) List<String> allergens,
    @Default(0) int spicyLevel,
    @Default(0) int preparationTime,
    @Default(0) int estimatedPrepTime, // 预计准备时间（分钟）
    @Default([]) List<String> regions,
    @Default([]) List<String> seasons,
    @Default(false) bool isPackage,
    @Default([]) List<PackageDishItem> packageDishes,
    @Default(['all']) List<String> suitableMerchantTypes,
    @Default([]) List<HealthBenefit> healthBenefits,
    @Default([]) List<String> suitableDiets,
    @Default(['all']) List<String> suitableActivityLevels,
    @Default(['all']) List<String> suitableAgeGroups,
    @JsonKey(name: 'createdBy') required String createdBy,
    @Default(true) bool isActive,
    @Default(true) bool isAvailable, // 是否可用
    @Default(false) bool isFeatured, // 是否特色推荐
    @Default('public') String visibility,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
  }) = _DishEntity;

  factory DishEntity.fromJson(Map<String, dynamic> json) =>
      _$DishEntityFromJson(json);
}

@freezed
class PackageDishItem with _$PackageDishItem {
  const factory PackageDishItem({
    @JsonKey(name: 'dishId') required String dishId,
    @Default(1) int quantity,
  }) = _PackageDishItem;

  factory PackageDishItem.fromJson(Map<String, dynamic> json) =>
      _$PackageDishItemFromJson(json);
}

@freezed
class HealthBenefit with _$HealthBenefit {
  const factory HealthBenefit({
    required String targetCondition,
    required String benefitDescription,
  }) = _HealthBenefit;

  factory HealthBenefit.fromJson(Map<String, dynamic> json) =>
      _$HealthBenefitFromJson(json);
}

@freezed
class StoreDishEntity with _$StoreDishEntity {
  const factory StoreDishEntity({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'storeId') required String storeId,
    @JsonKey(name: 'dishId') required DishEntity dishInfo,
    @JsonKey(name: 'priceOverride') double? priceOverride,
    @JsonKey(name: 'discountPriceOverride') double? discountPriceOverride,
    @Default(true) bool isAvailable,
    @Default([]) List<String> images,
    @Default({}) Map<String, dynamic> inventory,
    String? storeSpecificDescription,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
  }) = _StoreDishEntity;

  factory StoreDishEntity.fromJson(Map<String, dynamic> json) =>
      _$StoreDishEntityFromJson(json);
}

extension StoreDishEntityExtension on StoreDishEntity {
  double get finalPrice => priceOverride ?? dishInfo.price;
  
  double? get finalDiscountPrice => discountPriceOverride ?? dishInfo.discountedPrice;
  
  bool get hasDiscount => finalDiscountPrice != null && finalDiscountPrice! < finalPrice;
  
  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((finalPrice - finalDiscountPrice!) / finalPrice) * 100;
  }
  
  String get primaryImage => images.isNotEmpty ? images.first : (dishInfo.imageUrl ?? '');
  
  int get currentStock => (inventory['currentStock'] as num?)?.toInt() ?? 0;
  
  int get alertThreshold => (inventory['alertThreshold'] as num?)?.toInt() ?? 0;
  
  bool get isLowStock => currentStock <= alertThreshold;
  
  String get stockStatus {
    if (currentStock <= 0) return 'out';
    if (isLowStock) return 'low';
    return 'normal';
  }
}

// 营养成分扩展
extension NutritionExtension on DishEntity {
  double get calories => (nutritionFacts['calories'] as num?)?.toDouble() ?? 0;
  double get protein => (nutritionFacts['protein'] as num?)?.toDouble() ?? 0;
  double get fat => (nutritionFacts['fat'] as num?)?.toDouble() ?? 0;
  double get carbohydrates => (nutritionFacts['carbohydrates'] as num?)?.toDouble() ?? 0;
  double get fiber => (nutritionFacts['fiber'] as num?)?.toDouble() ?? 0;
  double get sugar => (nutritionFacts['sugar'] as num?)?.toDouble() ?? 0;
  double get sodium => (nutritionFacts['sodium'] as num?)?.toDouble() ?? 0;
  
  bool get isVegetarian => nutritionAttributes.contains('vegetarian');
  bool get isVegan => nutritionAttributes.contains('vegan');
  bool get isGlutenFree => nutritionAttributes.contains('glutenFree');
  bool get isLowCarb => nutritionAttributes.contains('lowCarb');
  bool get isHighProtein => nutritionAttributes.contains('highProtein');
}

// 菜品类别枚举
enum DishCategory {
  mainCourse('主菜', 'mainCourse'),
  appetizer('开胃菜', 'appetizer'),
  soup('汤', 'soup'),
  salad('沙拉', 'salad'),
  dessert('甜品', 'dessert'),
  beverage('饮品', 'beverage'),
  packageMeal('套餐', 'packageMeal'),
  other('其他', 'other');

  const DishCategory(this.displayName, this.value);
  final String displayName;
  final String value;

  static DishCategory fromValue(String value) {
    return DishCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => DishCategory.other,
    );
  }
}

// 辣度等级枚举
enum SpicyLevel {
  none('不辣', 0),
  mild('微辣', 1),
  light('轻微', 2),
  medium('中辣', 3),
  hot('辣', 4),
  veryHot('很辣', 5),
  extraHot('特辣', 6);

  const SpicyLevel(this.displayName, this.level);
  final String displayName;
  final int level;

  static SpicyLevel fromLevel(int level) {
    return SpicyLevel.values.firstWhere(
      (spicy) => spicy.level == level,
      orElse: () => SpicyLevel.none,
    );
  }
}