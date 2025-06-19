// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingredient_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IngredientUsageEntity _$IngredientUsageEntityFromJson(
    Map<String, dynamic> json) {
  return _IngredientUsageEntity.fromJson(json);
}

/// @nodoc
mixin _$IngredientUsageEntity {
  String get ingredientId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  bool get isOptional => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_IngredientUsageEntity value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_IngredientUsageEntity value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_IngredientUsageEntity value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this IngredientUsageEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IngredientUsageEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IngredientUsageEntityCopyWith<IngredientUsageEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IngredientUsageEntityCopyWith<$Res> {
  factory $IngredientUsageEntityCopyWith(IngredientUsageEntity value,
          $Res Function(IngredientUsageEntity) then) =
      _$IngredientUsageEntityCopyWithImpl<$Res, IngredientUsageEntity>;
  @useResult
  $Res call(
      {String ingredientId,
      String name,
      double quantity,
      String unit,
      bool isOptional,
      String notes});
}

/// @nodoc
class _$IngredientUsageEntityCopyWithImpl<$Res,
        $Val extends IngredientUsageEntity>
    implements $IngredientUsageEntityCopyWith<$Res> {
  _$IngredientUsageEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IngredientUsageEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ingredientId = null,
    Object? name = null,
    Object? quantity = null,
    Object? unit = null,
    Object? isOptional = null,
    Object? notes = null,
  }) {
    return _then(_value.copyWith(
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      isOptional: null == isOptional
          ? _value.isOptional
          : isOptional // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IngredientUsageEntityImplCopyWith<$Res>
    implements $IngredientUsageEntityCopyWith<$Res> {
  factory _$$IngredientUsageEntityImplCopyWith(
          _$IngredientUsageEntityImpl value,
          $Res Function(_$IngredientUsageEntityImpl) then) =
      __$$IngredientUsageEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String ingredientId,
      String name,
      double quantity,
      String unit,
      bool isOptional,
      String notes});
}

/// @nodoc
class __$$IngredientUsageEntityImplCopyWithImpl<$Res>
    extends _$IngredientUsageEntityCopyWithImpl<$Res,
        _$IngredientUsageEntityImpl>
    implements _$$IngredientUsageEntityImplCopyWith<$Res> {
  __$$IngredientUsageEntityImplCopyWithImpl(_$IngredientUsageEntityImpl _value,
      $Res Function(_$IngredientUsageEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of IngredientUsageEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ingredientId = null,
    Object? name = null,
    Object? quantity = null,
    Object? unit = null,
    Object? isOptional = null,
    Object? notes = null,
  }) {
    return _then(_$IngredientUsageEntityImpl(
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      isOptional: null == isOptional
          ? _value.isOptional
          : isOptional // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IngredientUsageEntityImpl implements _IngredientUsageEntity {
  const _$IngredientUsageEntityImpl(
      {required this.ingredientId,
      required this.name,
      required this.quantity,
      required this.unit,
      this.isOptional = false,
      this.notes = ''});

  factory _$IngredientUsageEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$IngredientUsageEntityImplFromJson(json);

  @override
  final String ingredientId;
  @override
  final String name;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  @JsonKey()
  final bool isOptional;
  @override
  @JsonKey()
  final String notes;

  @override
  String toString() {
    return 'IngredientUsageEntity(ingredientId: $ingredientId, name: $name, quantity: $quantity, unit: $unit, isOptional: $isOptional, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IngredientUsageEntityImpl &&
            (identical(other.ingredientId, ingredientId) ||
                other.ingredientId == ingredientId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.isOptional, isOptional) ||
                other.isOptional == isOptional) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, ingredientId, name, quantity, unit, isOptional, notes);

  /// Create a copy of IngredientUsageEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IngredientUsageEntityImplCopyWith<_$IngredientUsageEntityImpl>
      get copyWith => __$$IngredientUsageEntityImplCopyWithImpl<
          _$IngredientUsageEntityImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_IngredientUsageEntity value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_IngredientUsageEntity value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_IngredientUsageEntity value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IngredientUsageEntityImplToJson(
      this,
    );
  }
}

abstract class _IngredientUsageEntity implements IngredientUsageEntity {
  const factory _IngredientUsageEntity(
      {required final String ingredientId,
      required final String name,
      required final double quantity,
      required final String unit,
      final bool isOptional,
      final String notes}) = _$IngredientUsageEntityImpl;

  factory _IngredientUsageEntity.fromJson(Map<String, dynamic> json) =
      _$IngredientUsageEntityImpl.fromJson;

  @override
  String get ingredientId;
  @override
  String get name;
  @override
  double get quantity;
  @override
  String get unit;
  @override
  bool get isOptional;
  @override
  String get notes;

  /// Create a copy of IngredientUsageEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IngredientUsageEntityImplCopyWith<_$IngredientUsageEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
