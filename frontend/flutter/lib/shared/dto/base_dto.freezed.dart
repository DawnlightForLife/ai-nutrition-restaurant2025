// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaginationRequestDTO _$PaginationRequestDTOFromJson(Map<String, dynamic> json) {
  return _PaginationRequestDTO.fromJson(json);
}

/// @nodoc
mixin _$PaginationRequestDTO {
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  String? get sortBy => throw _privateConstructorUsedError;
  String get sortOrder => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PaginationRequestDTO value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PaginationRequestDTO value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PaginationRequestDTO value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this PaginationRequestDTO to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginationRequestDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationRequestDTOCopyWith<PaginationRequestDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationRequestDTOCopyWith<$Res> {
  factory $PaginationRequestDTOCopyWith(PaginationRequestDTO value,
          $Res Function(PaginationRequestDTO) then) =
      _$PaginationRequestDTOCopyWithImpl<$Res, PaginationRequestDTO>;
  @useResult
  $Res call({int page, int limit, String? sortBy, String sortOrder});
}

/// @nodoc
class _$PaginationRequestDTOCopyWithImpl<$Res,
        $Val extends PaginationRequestDTO>
    implements $PaginationRequestDTOCopyWith<$Res> {
  _$PaginationRequestDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationRequestDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? sortBy = freezed,
    Object? sortOrder = null,
  }) {
    return _then(_value.copyWith(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationRequestDTOImplCopyWith<$Res>
    implements $PaginationRequestDTOCopyWith<$Res> {
  factory _$$PaginationRequestDTOImplCopyWith(_$PaginationRequestDTOImpl value,
          $Res Function(_$PaginationRequestDTOImpl) then) =
      __$$PaginationRequestDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int page, int limit, String? sortBy, String sortOrder});
}

/// @nodoc
class __$$PaginationRequestDTOImplCopyWithImpl<$Res>
    extends _$PaginationRequestDTOCopyWithImpl<$Res, _$PaginationRequestDTOImpl>
    implements _$$PaginationRequestDTOImplCopyWith<$Res> {
  __$$PaginationRequestDTOImplCopyWithImpl(_$PaginationRequestDTOImpl _value,
      $Res Function(_$PaginationRequestDTOImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginationRequestDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? sortBy = freezed,
    Object? sortOrder = null,
  }) {
    return _then(_$PaginationRequestDTOImpl(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationRequestDTOImpl implements _PaginationRequestDTO {
  const _$PaginationRequestDTOImpl(
      {this.page = 1, this.limit = 20, this.sortBy, this.sortOrder = 'desc'});

  factory _$PaginationRequestDTOImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationRequestDTOImplFromJson(json);

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int limit;
  @override
  final String? sortBy;
  @override
  @JsonKey()
  final String sortOrder;

  @override
  String toString() {
    return 'PaginationRequestDTO(page: $page, limit: $limit, sortBy: $sortBy, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationRequestDTOImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, page, limit, sortBy, sortOrder);

  /// Create a copy of PaginationRequestDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationRequestDTOImplCopyWith<_$PaginationRequestDTOImpl>
      get copyWith =>
          __$$PaginationRequestDTOImplCopyWithImpl<_$PaginationRequestDTOImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PaginationRequestDTO value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PaginationRequestDTO value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PaginationRequestDTO value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationRequestDTOImplToJson(
      this,
    );
  }
}

abstract class _PaginationRequestDTO implements PaginationRequestDTO {
  const factory _PaginationRequestDTO(
      {final int page,
      final int limit,
      final String? sortBy,
      final String sortOrder}) = _$PaginationRequestDTOImpl;

  factory _PaginationRequestDTO.fromJson(Map<String, dynamic> json) =
      _$PaginationRequestDTOImpl.fromJson;

  @override
  int get page;
  @override
  int get limit;
  @override
  String? get sortBy;
  @override
  String get sortOrder;

  /// Create a copy of PaginationRequestDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationRequestDTOImplCopyWith<_$PaginationRequestDTOImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PaginationResponseDTO<T> _$PaginationResponseDTOFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _PaginationResponseDTO<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$PaginationResponseDTO<T> {
  List<T> get data => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PaginationResponseDTO<T> value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PaginationResponseDTO<T> value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PaginationResponseDTO<T> value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this PaginationResponseDTO to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;

  /// Create a copy of PaginationResponseDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationResponseDTOCopyWith<T, PaginationResponseDTO<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationResponseDTOCopyWith<T, $Res> {
  factory $PaginationResponseDTOCopyWith(PaginationResponseDTO<T> value,
          $Res Function(PaginationResponseDTO<T>) then) =
      _$PaginationResponseDTOCopyWithImpl<T, $Res, PaginationResponseDTO<T>>;
  @useResult
  $Res call({List<T> data, int total, int page, int limit, int totalPages});
}

/// @nodoc
class _$PaginationResponseDTOCopyWithImpl<T, $Res,
        $Val extends PaginationResponseDTO<T>>
    implements $PaginationResponseDTOCopyWith<T, $Res> {
  _$PaginationResponseDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationResponseDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? totalPages = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<T>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationResponseDTOImplCopyWith<T, $Res>
    implements $PaginationResponseDTOCopyWith<T, $Res> {
  factory _$$PaginationResponseDTOImplCopyWith(
          _$PaginationResponseDTOImpl<T> value,
          $Res Function(_$PaginationResponseDTOImpl<T>) then) =
      __$$PaginationResponseDTOImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T> data, int total, int page, int limit, int totalPages});
}

/// @nodoc
class __$$PaginationResponseDTOImplCopyWithImpl<T, $Res>
    extends _$PaginationResponseDTOCopyWithImpl<T, $Res,
        _$PaginationResponseDTOImpl<T>>
    implements _$$PaginationResponseDTOImplCopyWith<T, $Res> {
  __$$PaginationResponseDTOImplCopyWithImpl(
      _$PaginationResponseDTOImpl<T> _value,
      $Res Function(_$PaginationResponseDTOImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationResponseDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? totalPages = null,
  }) {
    return _then(_$PaginationResponseDTOImpl<T>(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<T>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$PaginationResponseDTOImpl<T> implements _PaginationResponseDTO<T> {
  const _$PaginationResponseDTOImpl(
      {required final List<T> data,
      required this.total,
      required this.page,
      required this.limit,
      required this.totalPages})
      : _data = data;

  factory _$PaginationResponseDTOImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$PaginationResponseDTOImplFromJson(json, fromJsonT);

  final List<T> _data;
  @override
  List<T> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  final int limit;
  @override
  final int totalPages;

  @override
  String toString() {
    return 'PaginationResponseDTO<$T>(data: $data, total: $total, page: $page, limit: $limit, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationResponseDTOImpl<T> &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_data),
      total,
      page,
      limit,
      totalPages);

  /// Create a copy of PaginationResponseDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationResponseDTOImplCopyWith<T, _$PaginationResponseDTOImpl<T>>
      get copyWith => __$$PaginationResponseDTOImplCopyWithImpl<T,
          _$PaginationResponseDTOImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PaginationResponseDTO<T> value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PaginationResponseDTO<T> value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PaginationResponseDTO<T> value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$PaginationResponseDTOImplToJson<T>(this, toJsonT);
  }
}

abstract class _PaginationResponseDTO<T> implements PaginationResponseDTO<T> {
  const factory _PaginationResponseDTO(
      {required final List<T> data,
      required final int total,
      required final int page,
      required final int limit,
      required final int totalPages}) = _$PaginationResponseDTOImpl<T>;

  factory _PaginationResponseDTO.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$PaginationResponseDTOImpl<T>.fromJson;

  @override
  List<T> get data;
  @override
  int get total;
  @override
  int get page;
  @override
  int get limit;
  @override
  int get totalPages;

  /// Create a copy of PaginationResponseDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationResponseDTOImplCopyWith<T, _$PaginationResponseDTOImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

ApiResponseDTO<T> _$ApiResponseDTOFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _ApiResponseDTO<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$ApiResponseDTO<T> {
  bool get success => throw _privateConstructorUsedError;
  T? get data => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  Map<String, dynamic>? get errors => throw _privateConstructorUsedError;
  int get statusCode => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ApiResponseDTO<T> value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ApiResponseDTO<T> value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ApiResponseDTO<T> value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ApiResponseDTO to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;

  /// Create a copy of ApiResponseDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiResponseDTOCopyWith<T, ApiResponseDTO<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiResponseDTOCopyWith<T, $Res> {
  factory $ApiResponseDTOCopyWith(
          ApiResponseDTO<T> value, $Res Function(ApiResponseDTO<T>) then) =
      _$ApiResponseDTOCopyWithImpl<T, $Res, ApiResponseDTO<T>>;
  @useResult
  $Res call(
      {bool success,
      T? data,
      String? message,
      Map<String, dynamic>? errors,
      int statusCode});
}

/// @nodoc
class _$ApiResponseDTOCopyWithImpl<T, $Res, $Val extends ApiResponseDTO<T>>
    implements $ApiResponseDTOCopyWith<T, $Res> {
  _$ApiResponseDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiResponseDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? message = freezed,
    Object? errors = freezed,
    Object? statusCode = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      errors: freezed == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiResponseDTOImplCopyWith<T, $Res>
    implements $ApiResponseDTOCopyWith<T, $Res> {
  factory _$$ApiResponseDTOImplCopyWith(_$ApiResponseDTOImpl<T> value,
          $Res Function(_$ApiResponseDTOImpl<T>) then) =
      __$$ApiResponseDTOImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      T? data,
      String? message,
      Map<String, dynamic>? errors,
      int statusCode});
}

/// @nodoc
class __$$ApiResponseDTOImplCopyWithImpl<T, $Res>
    extends _$ApiResponseDTOCopyWithImpl<T, $Res, _$ApiResponseDTOImpl<T>>
    implements _$$ApiResponseDTOImplCopyWith<T, $Res> {
  __$$ApiResponseDTOImplCopyWithImpl(_$ApiResponseDTOImpl<T> _value,
      $Res Function(_$ApiResponseDTOImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ApiResponseDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? message = freezed,
    Object? errors = freezed,
    Object? statusCode = null,
  }) {
    return _then(_$ApiResponseDTOImpl<T>(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      errors: freezed == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$ApiResponseDTOImpl<T> implements _ApiResponseDTO<T> {
  const _$ApiResponseDTOImpl(
      {required this.success,
      this.data,
      this.message,
      final Map<String, dynamic>? errors,
      this.statusCode = 200})
      : _errors = errors;

  factory _$ApiResponseDTOImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$ApiResponseDTOImplFromJson(json, fromJsonT);

  @override
  final bool success;
  @override
  final T? data;
  @override
  final String? message;
  final Map<String, dynamic>? _errors;
  @override
  Map<String, dynamic>? get errors {
    final value = _errors;
    if (value == null) return null;
    if (_errors is EqualUnmodifiableMapView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final int statusCode;

  @override
  String toString() {
    return 'ApiResponseDTO<$T>(success: $success, data: $data, message: $message, errors: $errors, statusCode: $statusCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiResponseDTOImpl<T> &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      const DeepCollectionEquality().hash(data),
      message,
      const DeepCollectionEquality().hash(_errors),
      statusCode);

  /// Create a copy of ApiResponseDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiResponseDTOImplCopyWith<T, _$ApiResponseDTOImpl<T>> get copyWith =>
      __$$ApiResponseDTOImplCopyWithImpl<T, _$ApiResponseDTOImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ApiResponseDTO<T> value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ApiResponseDTO<T> value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ApiResponseDTO<T> value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$ApiResponseDTOImplToJson<T>(this, toJsonT);
  }
}

abstract class _ApiResponseDTO<T> implements ApiResponseDTO<T> {
  const factory _ApiResponseDTO(
      {required final bool success,
      final T? data,
      final String? message,
      final Map<String, dynamic>? errors,
      final int statusCode}) = _$ApiResponseDTOImpl<T>;

  factory _ApiResponseDTO.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$ApiResponseDTOImpl<T>.fromJson;

  @override
  bool get success;
  @override
  T? get data;
  @override
  String? get message;
  @override
  Map<String, dynamic>? get errors;
  @override
  int get statusCode;

  /// Create a copy of ApiResponseDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiResponseDTOImplCopyWith<T, _$ApiResponseDTOImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
