// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UuserModel _$UuserModelFromJson(Map<String, dynamic> json) {
  return _UuserModel.fromJson(json);
}

/// @nodoc
mixin _$UuserModel {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UuserModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UuserModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UuserModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this UuserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UuserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UuserModelCopyWith<UuserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UuserModelCopyWith<$Res> {
  factory $UuserModelCopyWith(
          UuserModel value, $Res Function(UuserModel) then) =
      _$UuserModelCopyWithImpl<$Res, UuserModel>;
  @useResult
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class _$UuserModelCopyWithImpl<$Res, $Val extends UuserModel>
    implements $UuserModelCopyWith<$Res> {
  _$UuserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UuserModel
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
abstract class _$$UuserModelImplCopyWith<$Res>
    implements $UuserModelCopyWith<$Res> {
  factory _$$UuserModelImplCopyWith(
          _$UuserModelImpl value, $Res Function(_$UuserModelImpl) then) =
      __$$UuserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class __$$UuserModelImplCopyWithImpl<$Res>
    extends _$UuserModelCopyWithImpl<$Res, _$UuserModelImpl>
    implements _$$UuserModelImplCopyWith<$Res> {
  __$$UuserModelImplCopyWithImpl(
      _$UuserModelImpl _value, $Res Function(_$UuserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UuserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UuserModelImpl(
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
class _$UuserModelImpl extends _UuserModel {
  const _$UuserModelImpl(
      {required this.id, required this.createdAt, required this.updatedAt})
      : super._();

  factory _$UuserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UuserModelImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UuserModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UuserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, updatedAt);

  /// Create a copy of UuserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UuserModelImplCopyWith<_$UuserModelImpl> get copyWith =>
      __$$UuserModelImplCopyWithImpl<_$UuserModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UuserModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UuserModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UuserModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UuserModelImplToJson(
      this,
    );
  }
}

abstract class _UuserModel extends UuserModel {
  const factory _UuserModel(
      {required final String id,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$UuserModelImpl;
  const _UuserModel._() : super._();

  factory _UuserModel.fromJson(Map<String, dynamic> json) =
      _$UuserModelImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of UuserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UuserModelImplCopyWith<_$UuserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
