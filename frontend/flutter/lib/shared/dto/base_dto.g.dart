// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginationRequestDTOImpl _$$PaginationRequestDTOImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginationRequestDTOImpl(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      sortBy: json['sort_by'] as String?,
      sortOrder: json['sort_order'] as String? ?? 'desc',
    );

Map<String, dynamic> _$$PaginationRequestDTOImplToJson(
        _$PaginationRequestDTOImpl instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      if (instance.sortBy case final value?) 'sort_by': value,
      'sort_order': instance.sortOrder,
    };

_$PaginationResponseDTOImpl<T> _$$PaginationResponseDTOImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$PaginationResponseDTOImpl<T>(
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
    );

Map<String, dynamic> _$$PaginationResponseDTOImplToJson<T>(
  _$PaginationResponseDTOImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': instance.data.map(toJsonT).toList(),
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'total_pages': instance.totalPages,
    };

_$ApiResponseDTOImpl<T> _$$ApiResponseDTOImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$ApiResponseDTOImpl<T>(
      success: json['success'] as bool,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      message: json['message'] as String?,
      errors: json['errors'] as Map<String, dynamic>?,
      statusCode: (json['status_code'] as num?)?.toInt() ?? 200,
    );

Map<String, dynamic> _$$ApiResponseDTOImplToJson<T>(
  _$ApiResponseDTOImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.success,
      if (_$nullableGenericToJson(instance.data, toJsonT) case final value?)
        'data': value,
      if (instance.message case final value?) 'message': value,
      if (instance.errors case final value?) 'errors': value,
      'status_code': instance.statusCode,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
