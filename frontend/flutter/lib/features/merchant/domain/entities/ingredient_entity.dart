import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient_entity.freezed.dart';
part 'ingredient_entity.g.dart';

@freezed
class IngredientUsageEntity with _$IngredientUsageEntity {
  const factory IngredientUsageEntity({
    required String ingredientId,
    required String name,
    required double quantity,
    required String unit,
    @Default(false) bool isOptional,
    @Default('') String notes,
  }) = _IngredientUsageEntity;

  factory IngredientUsageEntity.fromJson(Map<String, dynamic> json) =>
      _$IngredientUsageEntityFromJson(json);
}