// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      isProfileCompleted: json['is_profile_completed'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      if (instance.email case final value?) 'email': value,
      if (instance.nickname case final value?) 'nickname': value,
      if (instance.avatar case final value?) 'avatar': value,
      'role': _$UserRoleEnumMap[instance.role]!,
      'is_profile_completed': instance.isProfileCompleted,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

const _$UserRoleEnumMap = {
  UserRole.user: 'user',
  UserRole.merchant: 'merchant',
  UserRole.employee: 'employee',
  UserRole.nutritionist: 'nutritionist',
  UserRole.admin: 'admin',
  UserRole.superAdmin: 'superAdmin',
};
