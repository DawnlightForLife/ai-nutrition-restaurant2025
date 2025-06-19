// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DishModelImpl _$$DishModelImplFromJson(Map<String, dynamic> json) =>
    _$DishModelImpl(
      id: json['_id'] as String,
      merchantId: json['merchant_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String? ?? '',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dietaryRestrictions: (json['dietary_restrictions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      spicyLevel:
          $enumDecodeNullable(_$SpicyLevelEnumMap, json['spicy_level']) ??
              SpicyLevel.none,
      estimatedPrepTime: (json['estimated_prep_time'] as num?)?.toInt() ?? 0,
      isAvailable: json['is_available'] as bool? ?? true,
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nutritionFacts:
          json['nutrition_facts'] as Map<String, dynamic>? ?? const {},
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => IngredientUsage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isFeatured: json['is_featured'] as bool? ?? false,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$DishModelImplToJson(_$DishModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'merchant_id': instance.merchantId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'category': instance.category,
      'tags': instance.tags,
      'allergens': instance.allergens,
      'dietary_restrictions': instance.dietaryRestrictions,
      'spicy_level': _$SpicyLevelEnumMap[instance.spicyLevel]!,
      'estimated_prep_time': instance.estimatedPrepTime,
      'is_available': instance.isAvailable,
      'image_urls': instance.imageUrls,
      'nutrition_facts': instance.nutritionFacts,
      'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
      'is_featured': instance.isFeatured,
      'sort_order': instance.sortOrder,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

const _$SpicyLevelEnumMap = {
  SpicyLevel.none: 'none',
  SpicyLevel.mild: 'mild',
  SpicyLevel.light: 'light',
  SpicyLevel.medium: 'medium',
  SpicyLevel.hot: 'hot',
  SpicyLevel.veryHot: 'veryHot',
  SpicyLevel.extraHot: 'extraHot',
};

_$StoreDishModelImpl _$$StoreDishModelImplFromJson(Map<String, dynamic> json) =>
    _$StoreDishModelImpl(
      id: json['_id'] as String,
      storeId: json['store_id'] as String,
      dishId: json['dish_id'] as String,
      merchantId: json['merchant_id'] as String,
      localPrice: (json['local_price'] as num).toDouble(),
      isAvailableInStore: json['is_available_in_store'] as bool? ?? true,
      dailyLimit: (json['daily_limit'] as num?)?.toInt() ?? 0,
      currentSold: (json['current_sold'] as num?)?.toInt() ?? 0,
      storeSpecificInfo:
          json['store_specific_info'] as Map<String, dynamic>? ?? const {},
      localTags: (json['local_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dish: DishModel.fromJson(json['dish'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$StoreDishModelImplToJson(
        _$StoreDishModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'store_id': instance.storeId,
      'dish_id': instance.dishId,
      'merchant_id': instance.merchantId,
      'local_price': instance.localPrice,
      'is_available_in_store': instance.isAvailableInStore,
      'daily_limit': instance.dailyLimit,
      'current_sold': instance.currentSold,
      'store_specific_info': instance.storeSpecificInfo,
      'local_tags': instance.localTags,
      'dish': instance.dish.toJson(),
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

_$IngredientUsageImpl _$$IngredientUsageImplFromJson(
        Map<String, dynamic> json) =>
    _$IngredientUsageImpl(
      ingredientId: json['ingredient_id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      isOptional: json['is_optional'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
    );

Map<String, dynamic> _$$IngredientUsageImplToJson(
        _$IngredientUsageImpl instance) =>
    <String, dynamic>{
      'ingredient_id': instance.ingredientId,
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'is_optional': instance.isOptional,
      'notes': instance.notes,
    };

_$DishCreateRequestImpl _$$DishCreateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$DishCreateRequestImpl(
      merchantId: json['merchant_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String? ?? '',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dietaryRestrictions: (json['dietary_restrictions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      spicyLevel:
          $enumDecodeNullable(_$SpicyLevelEnumMap, json['spicy_level']) ??
              SpicyLevel.none,
      estimatedPrepTime: (json['estimated_prep_time'] as num?)?.toInt() ?? 0,
      isAvailable: json['is_available'] as bool? ?? true,
      nutritionFacts:
          json['nutrition_facts'] as Map<String, dynamic>? ?? const {},
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => IngredientUsage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isFeatured: json['is_featured'] as bool? ?? false,
    );

Map<String, dynamic> _$$DishCreateRequestImplToJson(
        _$DishCreateRequestImpl instance) =>
    <String, dynamic>{
      'merchant_id': instance.merchantId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'category': instance.category,
      'tags': instance.tags,
      'allergens': instance.allergens,
      'dietary_restrictions': instance.dietaryRestrictions,
      'spicy_level': _$SpicyLevelEnumMap[instance.spicyLevel]!,
      'estimated_prep_time': instance.estimatedPrepTime,
      'is_available': instance.isAvailable,
      'nutrition_facts': instance.nutritionFacts,
      'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
      'is_featured': instance.isFeatured,
    };

_$DishUpdateRequestImpl _$$DishUpdateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$DishUpdateRequestImpl(
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      allergens: (json['allergens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      dietaryRestrictions: (json['dietary_restrictions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      spicyLevel: $enumDecodeNullable(_$SpicyLevelEnumMap, json['spicy_level']),
      estimatedPrepTime: (json['estimated_prep_time'] as num?)?.toInt(),
      isAvailable: json['is_available'] as bool?,
      nutritionFacts: json['nutrition_facts'] as Map<String, dynamic>?,
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => IngredientUsage.fromJson(e as Map<String, dynamic>))
          .toList(),
      isFeatured: json['is_featured'] as bool?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$DishUpdateRequestImplToJson(
        _$DishUpdateRequestImpl instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.description case final value?) 'description': value,
      if (instance.price case final value?) 'price': value,
      if (instance.category case final value?) 'category': value,
      if (instance.tags case final value?) 'tags': value,
      if (instance.allergens case final value?) 'allergens': value,
      if (instance.dietaryRestrictions case final value?)
        'dietary_restrictions': value,
      if (_$SpicyLevelEnumMap[instance.spicyLevel] case final value?)
        'spicy_level': value,
      if (instance.estimatedPrepTime case final value?)
        'estimated_prep_time': value,
      if (instance.isAvailable case final value?) 'is_available': value,
      if (instance.nutritionFacts case final value?) 'nutrition_facts': value,
      if (instance.ingredients?.map((e) => e.toJson()).toList()
          case final value?)
        'ingredients': value,
      if (instance.isFeatured case final value?) 'is_featured': value,
      if (instance.sortOrder case final value?) 'sort_order': value,
    };

_$StoreDishUpdateRequestImpl _$$StoreDishUpdateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$StoreDishUpdateRequestImpl(
      localPrice: (json['local_price'] as num?)?.toDouble(),
      isAvailableInStore: json['is_available_in_store'] as bool?,
      dailyLimit: (json['daily_limit'] as num?)?.toInt(),
      storeSpecificInfo: json['store_specific_info'] as Map<String, dynamic>?,
      localTags: (json['local_tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$StoreDishUpdateRequestImplToJson(
        _$StoreDishUpdateRequestImpl instance) =>
    <String, dynamic>{
      if (instance.localPrice case final value?) 'local_price': value,
      if (instance.isAvailableInStore case final value?)
        'is_available_in_store': value,
      if (instance.dailyLimit case final value?) 'daily_limit': value,
      if (instance.storeSpecificInfo case final value?)
        'store_specific_info': value,
      if (instance.localTags case final value?) 'local_tags': value,
    };
