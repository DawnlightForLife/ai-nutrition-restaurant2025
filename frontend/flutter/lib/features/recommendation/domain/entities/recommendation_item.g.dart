// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendationItemImpl _$$RecommendationItemImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendationItemImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      nutritionInfo: json['nutrition_info'] == null
          ? null
          : NutritionInfo.fromJson(
              json['nutrition_info'] as Map<String, dynamic>),
      priceInfo: json['price_info'] == null
          ? null
          : PriceInfo.fromJson(json['price_info'] as Map<String, dynamic>),
      reasons: (json['reasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isAvailable: json['is_available'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$RecommendationItemImplToJson(
    _$RecommendationItemImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': instance.type,
    'title': instance.title,
    'description': instance.description,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('image_url', instance.imageUrl);
  val['score'] = instance.score;
  val['confidence'] = instance.confidence;
  writeNotNull('nutrition_info', instance.nutritionInfo?.toJson());
  writeNotNull('price_info', instance.priceInfo?.toJson());
  val['reasons'] = instance.reasons;
  val['tags'] = instance.tags;
  val['is_available'] = instance.isAvailable;
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  val['metadata'] = instance.metadata;
  return val;
}

_$NutritionInfoImpl _$$NutritionInfoImplFromJson(Map<String, dynamic> json) =>
    _$NutritionInfoImpl(
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0.0,
      sugar: (json['sugar'] as num?)?.toDouble() ?? 0.0,
      sodium: (json['sodium'] as num?)?.toDouble() ?? 0.0,
      others: (json['others'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$NutritionInfoImplToJson(_$NutritionInfoImpl instance) =>
    <String, dynamic>{
      'calories': instance.calories,
      'protein': instance.protein,
      'fat': instance.fat,
      'carbs': instance.carbs,
      'fiber': instance.fiber,
      'sugar': instance.sugar,
      'sodium': instance.sodium,
      'others': instance.others,
    };

_$PriceInfoImpl _$$PriceInfoImplFromJson(Map<String, dynamic> json) =>
    _$PriceInfoImpl(
      originalPrice: (json['original_price'] as num?)?.toDouble() ?? 0.0,
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'CNY',
      unit: json['unit'] as String? ?? '份',
    );

Map<String, dynamic> _$$PriceInfoImplToJson(_$PriceInfoImpl instance) =>
    <String, dynamic>{
      'original_price': instance.originalPrice,
      'current_price': instance.currentPrice,
      'discount': instance.discount,
      'currency': instance.currency,
      'unit': instance.unit,
    };
