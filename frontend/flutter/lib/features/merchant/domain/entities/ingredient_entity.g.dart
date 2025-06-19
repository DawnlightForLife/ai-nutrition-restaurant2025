// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IngredientUsageEntityImpl _$$IngredientUsageEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$IngredientUsageEntityImpl(
      ingredientId: json['ingredient_id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      isOptional: json['is_optional'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
    );

Map<String, dynamic> _$$IngredientUsageEntityImplToJson(
        _$IngredientUsageEntityImpl instance) =>
    <String, dynamic>{
      'ingredient_id': instance.ingredientId,
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'is_optional': instance.isOptional,
      'notes': instance.notes,
    };
