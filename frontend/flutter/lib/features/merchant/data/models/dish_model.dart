import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/dish_entity.dart';
import '../../domain/entities/ingredient_entity.dart';

part 'dish_model.freezed.dart';
part 'dish_model.g.dart';

@freezed
class DishModel with _$DishModel {
  const factory DishModel({
    @JsonKey(name: '_id') required String id,
    required String merchantId,
    required String name,
    required String description,
    required double price,
    @Default('') String category,
    @Default([]) List<String> tags,
    @Default([]) List<String> allergens,
    @Default([]) List<String> dietaryRestrictions,
    @Default(SpicyLevel.none) SpicyLevel spicyLevel,
    @Default(0) int estimatedPrepTime,
    @Default(true) bool isAvailable,
    @Default([]) List<String> imageUrls,
    @Default({}) Map<String, dynamic> nutritionFacts,
    @Default([]) List<IngredientUsage> ingredients,
    @Default(false) bool isFeatured,
    @Default(0) int sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DishModel;

  factory DishModel.fromJson(Map<String, dynamic> json) => _$DishModelFromJson(json);
}

@freezed
class StoreDishModel with _$StoreDishModel {
  const factory StoreDishModel({
    @JsonKey(name: '_id') required String id,
    required String storeId,
    required String dishId,
    required String merchantId,
    required double localPrice,
    @Default(true) bool isAvailableInStore,
    @Default(0) int dailyLimit,
    @Default(0) int currentSold,
    @Default({}) Map<String, dynamic> storeSpecificInfo,
    @Default([]) List<String> localTags,
    required DishModel dish,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _StoreDishModel;

  factory StoreDishModel.fromJson(Map<String, dynamic> json) => _$StoreDishModelFromJson(json);
}

@freezed
class IngredientUsage with _$IngredientUsage {
  const factory IngredientUsage({
    required String ingredientId,
    required String name,
    required double quantity,
    required String unit,
    @Default(false) bool isOptional,
    @Default('') String notes,
  }) = _IngredientUsage;

  factory IngredientUsage.fromJson(Map<String, dynamic> json) => _$IngredientUsageFromJson(json);
}

@freezed
class DishCreateRequest with _$DishCreateRequest {
  const factory DishCreateRequest({
    required String merchantId,
    required String name,
    required String description,
    required double price,
    @Default('') String category,
    @Default([]) List<String> tags,
    @Default([]) List<String> allergens,
    @Default([]) List<String> dietaryRestrictions,
    @Default(SpicyLevel.none) SpicyLevel spicyLevel,
    @Default(0) int estimatedPrepTime,
    @Default(true) bool isAvailable,
    @Default({}) Map<String, dynamic> nutritionFacts,
    @Default([]) List<IngredientUsage> ingredients,
    @Default(false) bool isFeatured,
  }) = _DishCreateRequest;

  factory DishCreateRequest.fromJson(Map<String, dynamic> json) => _$DishCreateRequestFromJson(json);
}

@freezed
class DishUpdateRequest with _$DishUpdateRequest {
  const factory DishUpdateRequest({
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? tags,
    List<String>? allergens,
    List<String>? dietaryRestrictions,
    SpicyLevel? spicyLevel,
    int? estimatedPrepTime,
    bool? isAvailable,
    Map<String, dynamic>? nutritionFacts,
    List<IngredientUsage>? ingredients,
    bool? isFeatured,
    int? sortOrder,
  }) = _DishUpdateRequest;

  factory DishUpdateRequest.fromJson(Map<String, dynamic> json) => _$DishUpdateRequestFromJson(json);
}

@freezed
class StoreDishUpdateRequest with _$StoreDishUpdateRequest {
  const factory StoreDishUpdateRequest({
    double? localPrice,
    bool? isAvailableInStore,
    int? dailyLimit,
    Map<String, dynamic>? storeSpecificInfo,
    List<String>? localTags,
  }) = _StoreDishUpdateRequest;

  factory StoreDishUpdateRequest.fromJson(Map<String, dynamic> json) => _$StoreDishUpdateRequestFromJson(json);
}

// Extension methods to convert between models and entities
extension DishModelX on DishModel {
  DishEntity toEntity() {
    return DishEntity(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrls.isNotEmpty ? imageUrls.first : null,
      imageUrls: imageUrls,
      price: price,
      category: category,
      tags: tags,
      allergens: allergens,
      spicyLevel: spicyLevel.level,
      preparationTime: estimatedPrepTime,
      estimatedPrepTime: estimatedPrepTime,
      isAvailable: isAvailable,
      nutritionFacts: nutritionFacts,
      ingredients: ingredients.map((i) => i.ingredientId).toList(),
      isFeatured: isFeatured,
      createdBy: merchantId, // 使用 merchantId 作为 createdBy
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

extension StoreDishModelX on StoreDishModel {
  StoreDishEntity toEntity() {
    return StoreDishEntity(
      id: id,
      storeId: storeId,
      dishInfo: dish.toEntity(),
      priceOverride: localPrice != dish.price ? localPrice : null,
      isAvailable: isAvailableInStore,
      storeSpecificDescription: storeSpecificInfo['description'] as String?,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

extension IngredientUsageModelX on IngredientUsage {
  IngredientUsageEntity toEntity() {
    return IngredientUsageEntity(
      ingredientId: ingredientId,
      name: name,
      quantity: quantity,
      unit: unit,
      isOptional: isOptional,
      notes: notes,
    );
  }
}