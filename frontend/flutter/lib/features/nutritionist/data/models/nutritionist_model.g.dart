// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutritionist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UnutritionistModelImpl _$$UnutritionistModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UnutritionistModelImpl(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UnutritionistModelImplToJson(
        _$UnutritionistModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
