// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SystemConfigModelImpl _$$SystemConfigModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SystemConfigModelImpl(
      id: json['id'] as String?,
      key: json['key'] as String,
      value: json['value'],
      valueType: json['value_type'] as String?,
      category: json['category'] as String?,
      description: json['description'] as String?,
      isPublic: json['is_public'] as bool?,
      isEditable: json['is_editable'] as bool?,
      updatedBy: json['updated_by'] as Map<String, dynamic>?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      remark: json['remark'] as String?,
    );

Map<String, dynamic> _$$SystemConfigModelImplToJson(
        _$SystemConfigModelImpl instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'key': instance.key,
      if (instance.value case final value?) 'value': value,
      if (instance.valueType case final value?) 'value_type': value,
      if (instance.category case final value?) 'category': value,
      if (instance.description case final value?) 'description': value,
      if (instance.isPublic case final value?) 'is_public': value,
      if (instance.isEditable case final value?) 'is_editable': value,
      if (instance.updatedBy case final value?) 'updated_by': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
      if (instance.remark case final value?) 'remark': value,
    };
