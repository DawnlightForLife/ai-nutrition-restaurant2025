// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UorderModel _$UorderModelFromJson(Map<String, dynamic> json) {
  return _UorderModel.fromJson(json);
}

/// @nodoc
mixin _$UorderModel {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UorderModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UorderModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UorderModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this UorderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UorderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UorderModelCopyWith<UorderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UorderModelCopyWith<$Res> {
  factory $UorderModelCopyWith(
          UorderModel value, $Res Function(UorderModel) then) =
      _$UorderModelCopyWithImpl<$Res, UorderModel>;
  @useResult
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class _$UorderModelCopyWithImpl<$Res, $Val extends UorderModel>
    implements $UorderModelCopyWith<$Res> {
  _$UorderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UorderModel
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
abstract class _$$UorderModelImplCopyWith<$Res>
    implements $UorderModelCopyWith<$Res> {
  factory _$$UorderModelImplCopyWith(
          _$UorderModelImpl value, $Res Function(_$UorderModelImpl) then) =
      __$$UorderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class __$$UorderModelImplCopyWithImpl<$Res>
    extends _$UorderModelCopyWithImpl<$Res, _$UorderModelImpl>
    implements _$$UorderModelImplCopyWith<$Res> {
  __$$UorderModelImplCopyWithImpl(
      _$UorderModelImpl _value, $Res Function(_$UorderModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UorderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UorderModelImpl(
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
class _$UorderModelImpl extends _UorderModel {
  const _$UorderModelImpl(
      {required this.id, required this.createdAt, required this.updatedAt})
      : super._();

  factory _$UorderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UorderModelImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UorderModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UorderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, updatedAt);

  /// Create a copy of UorderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UorderModelImplCopyWith<_$UorderModelImpl> get copyWith =>
      __$$UorderModelImplCopyWithImpl<_$UorderModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UorderModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UorderModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UorderModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UorderModelImplToJson(
      this,
    );
  }
}

abstract class _UorderModel extends UorderModel {
  const factory _UorderModel(
      {required final String id,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$UorderModelImpl;
  const _UorderModel._() : super._();

  factory _UorderModel.fromJson(Map<String, dynamic> json) =
      _$UorderModelImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of UorderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UorderModelImplCopyWith<_$UorderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
