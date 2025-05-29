// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutritionist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UnutritionistModel _$UnutritionistModelFromJson(Map<String, dynamic> json) {
  return _UnutritionistModel.fromJson(json);
}

/// @nodoc
mixin _$UnutritionistModel {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UnutritionistModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UnutritionistModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UnutritionistModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this UnutritionistModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UnutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnutritionistModelCopyWith<UnutritionistModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnutritionistModelCopyWith<$Res> {
  factory $UnutritionistModelCopyWith(
          UnutritionistModel value, $Res Function(UnutritionistModel) then) =
      _$UnutritionistModelCopyWithImpl<$Res, UnutritionistModel>;
  @useResult
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class _$UnutritionistModelCopyWithImpl<$Res, $Val extends UnutritionistModel>
    implements $UnutritionistModelCopyWith<$Res> {
  _$UnutritionistModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UnutritionistModel
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
abstract class _$$UnutritionistModelImplCopyWith<$Res>
    implements $UnutritionistModelCopyWith<$Res> {
  factory _$$UnutritionistModelImplCopyWith(_$UnutritionistModelImpl value,
          $Res Function(_$UnutritionistModelImpl) then) =
      __$$UnutritionistModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class __$$UnutritionistModelImplCopyWithImpl<$Res>
    extends _$UnutritionistModelCopyWithImpl<$Res, _$UnutritionistModelImpl>
    implements _$$UnutritionistModelImplCopyWith<$Res> {
  __$$UnutritionistModelImplCopyWithImpl(_$UnutritionistModelImpl _value,
      $Res Function(_$UnutritionistModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UnutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UnutritionistModelImpl(
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
class _$UnutritionistModelImpl extends _UnutritionistModel {
  const _$UnutritionistModelImpl(
      {required this.id, required this.createdAt, required this.updatedAt})
      : super._();

  factory _$UnutritionistModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnutritionistModelImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UnutritionistModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnutritionistModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, updatedAt);

  /// Create a copy of UnutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnutritionistModelImplCopyWith<_$UnutritionistModelImpl> get copyWith =>
      __$$UnutritionistModelImplCopyWithImpl<_$UnutritionistModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UnutritionistModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UnutritionistModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UnutritionistModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UnutritionistModelImplToJson(
      this,
    );
  }
}

abstract class _UnutritionistModel extends UnutritionistModel {
  const factory _UnutritionistModel(
      {required final String id,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$UnutritionistModelImpl;
  const _UnutritionistModel._() : super._();

  factory _UnutritionistModel.fromJson(Map<String, dynamic> json) =
      _$UnutritionistModelImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of UnutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnutritionistModelImplCopyWith<_$UnutritionistModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
