// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UmerchantModel _$UmerchantModelFromJson(Map<String, dynamic> json) {
  return _UmerchantModel.fromJson(json);
}

/// @nodoc
mixin _$UmerchantModel {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UmerchantModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UmerchantModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UmerchantModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this UmerchantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UmerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UmerchantModelCopyWith<UmerchantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UmerchantModelCopyWith<$Res> {
  factory $UmerchantModelCopyWith(
          UmerchantModel value, $Res Function(UmerchantModel) then) =
      _$UmerchantModelCopyWithImpl<$Res, UmerchantModel>;
  @useResult
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class _$UmerchantModelCopyWithImpl<$Res, $Val extends UmerchantModel>
    implements $UmerchantModelCopyWith<$Res> {
  _$UmerchantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UmerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UmerchantModelImplCopyWith<$Res>
    implements $UmerchantModelCopyWith<$Res> {
  factory _$$UmerchantModelImplCopyWith(_$UmerchantModelImpl value,
          $Res Function(_$UmerchantModelImpl) then) =
      __$$UmerchantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class __$$UmerchantModelImplCopyWithImpl<$Res>
    extends _$UmerchantModelCopyWithImpl<$Res, _$UmerchantModelImpl>
    implements _$$UmerchantModelImplCopyWith<$Res> {
  __$$UmerchantModelImplCopyWithImpl(
      _$UmerchantModelImpl _value, $Res Function(_$UmerchantModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UmerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UmerchantModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UmerchantModelImpl extends _UmerchantModel {
  const _$UmerchantModelImpl(
      {required this.id, required this.createdAt, required this.updatedAt})
      : super._();

  factory _$UmerchantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UmerchantModelImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UmerchantModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UmerchantModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, updatedAt);

  /// Create a copy of UmerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UmerchantModelImplCopyWith<_$UmerchantModelImpl> get copyWith =>
      __$$UmerchantModelImplCopyWithImpl<_$UmerchantModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UmerchantModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UmerchantModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UmerchantModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UmerchantModelImplToJson(
      this,
    );
  }
}

abstract class _UmerchantModel extends UmerchantModel {
  const factory _UmerchantModel(
      {required final String id,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$UmerchantModelImpl;
  const _UmerchantModel._() : super._();

  factory _UmerchantModel.fromJson(Map<String, dynamic> json) =
      _$UmerchantModelImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of UmerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UmerchantModelImplCopyWith<_$UmerchantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
