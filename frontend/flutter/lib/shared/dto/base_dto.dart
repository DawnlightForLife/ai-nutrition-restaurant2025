/// 基础 DTO 类
/// 
/// 所有 DTO 的基类，提供通用的转换方法
library;

import 'package:freezed_annotation/freezed_annotation.dart';

/// DTO 接口
abstract class DTO {
  /// 转换为 JSON
  Map<String, dynamic> toJson();
}

/// 分页请求 DTO
@freezed
class PaginationRequestDTO with _$PaginationRequestDTO implements DTO {
  const factory PaginationRequestDTO({
    @Default(1) int page,
    @Default(20) int limit,
    String? sortBy,
    @Default('desc') String sortOrder,
  }) = _PaginationRequestDTO;

  factory PaginationRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$PaginationRequestDTOFromJson(json);
}

/// 分页响应 DTO
@freezed
class PaginationResponseDTO<T> with _$PaginationResponseDTO<T> {
  const factory PaginationResponseDTO({
    required List<T> data,
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _PaginationResponseDTO;
}

/// API 响应 DTO
@freezed
class ApiResponseDTO<T> with _$ApiResponseDTO<T> {
  const factory ApiResponseDTO({
    required bool success,
    T? data,
    String? message,
    Map<String, dynamic>? errors,
    @Default(200) int statusCode,
  }) = _ApiResponseDTO;

  factory ApiResponseDTO.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ApiResponseDTOFromJson(json, fromJsonT);
}

part 'base_dto.freezed.dart';
part 'base_dto.g.dart';