// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DishEntityImpl _$$DishEntityImplFromJson(Map<String, dynamic> json) =>
    _$DishEntityImpl(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      price: (json['price'] as num).toDouble(),
      discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
      category: json['category'] as String,
      subCategory: json['sub_category'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      nutritionFacts:
          json['nutrition_facts'] as Map<String, dynamic>? ?? const {},
      nutritionAttributes: (json['nutrition_attributes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      spicyLevel: (json['spicy_level'] as num?)?.toInt() ?? 0,
      preparationTime: (json['preparation_time'] as num?)?.toInt() ?? 0,
      estimatedPrepTime: (json['estimated_prep_time'] as num?)?.toInt() ?? 0,
      regions: (json['regions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      seasons: (json['seasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isPackage: json['is_package'] as bool? ?? false,
      packageDishes: (json['package_dishes'] as List<dynamic>?)
              ?.map((e) => PackageDishItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      suitableMerchantTypes: (json['suitable_merchant_types'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['all'],
      healthBenefits: (json['health_benefits'] as List<dynamic>?)
              ?.map((e) => HealthBenefit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      suitableDiets: (json['suitable_diets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      suitableActivityLevels:
          (json['suitable_activity_levels'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const ['all'],
      suitableAgeGroups: (json['suitable_age_groups'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['all'],
      createdBy: json['createdBy'] as String,
      isActive: json['is_active'] as bool? ?? true,
      isAvailable: json['is_available'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      visibility: json['visibility'] as String? ?? 'public',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$DishEntityImplToJson(_$DishEntityImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      if (instance.imageUrl case final value?) 'imageUrl': value,
      'image_urls': instance.imageUrls,
      'price': instance.price,
      if (instance.discountedPrice case final value?) 'discountedPrice': value,
      'category': instance.category,
      if (instance.subCategory case final value?) 'sub_category': value,
      'tags': instance.tags,
      'nutrition_facts': instance.nutritionFacts,
      'nutrition_attributes': instance.nutritionAttributes,
      'ingredients': instance.ingredients,
      'allergens': instance.allergens,
      'spicy_level': instance.spicyLevel,
      'preparation_time': instance.preparationTime,
      'estimated_prep_time': instance.estimatedPrepTime,
      'regions': instance.regions,
      'seasons': instance.seasons,
      'is_package': instance.isPackage,
      'package_dishes': instance.packageDishes.map((e) => e.toJson()).toList(),
      'suitable_merchant_types': instance.suitableMerchantTypes,
      'health_benefits':
          instance.healthBenefits.map((e) => e.toJson()).toList(),
      'suitable_diets': instance.suitableDiets,
      'suitable_activity_levels': instance.suitableActivityLevels,
      'suitable_age_groups': instance.suitableAgeGroups,
      'createdBy': instance.createdBy,
      'is_active': instance.isActive,
      'is_available': instance.isAvailable,
      'is_featured': instance.isFeatured,
      'visibility': instance.visibility,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$PackageDishItemImpl _$$PackageDishItemImplFromJson(
        Map<String, dynamic> json) =>
    _$PackageDishItemImpl(
      dishId: json['dishId'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$PackageDishItemImplToJson(
        _$PackageDishItemImpl instance) =>
    <String, dynamic>{
      'dishId': instance.dishId,
      'quantity': instance.quantity,
    };

_$HealthBenefitImpl _$$HealthBenefitImplFromJson(Map<String, dynamic> json) =>
    _$HealthBenefitImpl(
      targetCondition: json['target_condition'] as String,
      benefitDescription: json['benefit_description'] as String,
    );

Map<String, dynamic> _$$HealthBenefitImplToJson(_$HealthBenefitImpl instance) =>
    <String, dynamic>{
      'target_condition': instance.targetCondition,
      'benefit_description': instance.benefitDescription,
    };

_$StoreDishEntityImpl _$$StoreDishEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$StoreDishEntityImpl(
      id: json['_id'] as String,
      storeId: json['storeId'] as String,
      dishInfo: DishEntity.fromJson(json['dishId'] as Map<String, dynamic>),
      priceOverride: (json['priceOverride'] as num?)?.toDouble(),
      discountPriceOverride:
          (json['discountPriceOverride'] as num?)?.toDouble(),
      isAvailable: json['is_available'] as bool? ?? true,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      inventory: json['inventory'] as Map<String, dynamic>? ?? const {},
      storeSpecificDescription: json['store_specific_description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$StoreDishEntityImplToJson(
        _$StoreDishEntityImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'storeId': instance.storeId,
      'dishId': instance.dishInfo.toJson(),
      if (instance.priceOverride case final value?) 'priceOverride': value,
      if (instance.discountPriceOverride case final value?)
        'discountPriceOverride': value,
      'is_available': instance.isAvailable,
      'images': instance.images,
      'inventory': instance.inventory,
      if (instance.storeSpecificDescription case final value?)
        'store_specific_description': value,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
