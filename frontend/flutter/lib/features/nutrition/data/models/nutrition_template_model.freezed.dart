// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrition_template_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NutritionTemplateModel _$NutritionTemplateModelFromJson(
    Map<String, dynamic> json) {
  return _NutritionTemplateModel.fromJson(json);
}

/// @nodoc
mixin _$NutritionTemplateModel {
  String get key => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  NutritionProfileModel get data => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_name')
  String? get iconName => throw _privateConstructorUsedError;
  @JsonKey(name: 'recommended_for')
  List<String>? get recommendedFor => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionTemplateModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionTemplateModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionTemplateModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionTemplateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionTemplateModelCopyWith<NutritionTemplateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionTemplateModelCopyWith<$Res> {
  factory $NutritionTemplateModelCopyWith(NutritionTemplateModel value,
          $Res Function(NutritionTemplateModel) then) =
      _$NutritionTemplateModelCopyWithImpl<$Res, NutritionTemplateModel>;
  @useResult
  $Res call(
      {String key,
      String name,
      NutritionProfileModel data,
      String? description,
      @JsonKey(name: 'icon_name') String? iconName,
      @JsonKey(name: 'recommended_for') List<String>? recommendedFor});
}

/// @nodoc
class _$NutritionTemplateModelCopyWithImpl<$Res,
        $Val extends NutritionTemplateModel>
    implements $NutritionTemplateModelCopyWith<$Res> {
  _$NutritionTemplateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? name = null,
    Object? data = null,
    Object? description = freezed,
    Object? iconName = freezed,
    Object? recommendedFor = freezed,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as NutritionProfileModel,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      recommendedFor: freezed == recommendedFor
          ? _value.recommendedFor
          : recommendedFor // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionTemplateModelImplCopyWith<$Res>
    implements $NutritionTemplateModelCopyWith<$Res> {
  factory _$$NutritionTemplateModelImplCopyWith(
          _$NutritionTemplateModelImpl value,
          $Res Function(_$NutritionTemplateModelImpl) then) =
      __$$NutritionTemplateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String key,
      String name,
      NutritionProfileModel data,
      String? description,
      @JsonKey(name: 'icon_name') String? iconName,
      @JsonKey(name: 'recommended_for') List<String>? recommendedFor});
}

/// @nodoc
class __$$NutritionTemplateModelImplCopyWithImpl<$Res>
    extends _$NutritionTemplateModelCopyWithImpl<$Res,
        _$NutritionTemplateModelImpl>
    implements _$$NutritionTemplateModelImplCopyWith<$Res> {
  __$$NutritionTemplateModelImplCopyWithImpl(
      _$NutritionTemplateModelImpl _value,
      $Res Function(_$NutritionTemplateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? name = null,
    Object? data = null,
    Object? description = freezed,
    Object? iconName = freezed,
    Object? recommendedFor = freezed,
  }) {
    return _then(_$NutritionTemplateModelImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as NutritionProfileModel,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      recommendedFor: freezed == recommendedFor
          ? _value._recommendedFor
          : recommendedFor // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionTemplateModelImpl implements _NutritionTemplateModel {
  const _$NutritionTemplateModelImpl(
      {required this.key,
      required this.name,
      required this.data,
      this.description,
      @JsonKey(name: 'icon_name') this.iconName,
      @JsonKey(name: 'recommended_for') final List<String>? recommendedFor})
      : _recommendedFor = recommendedFor;

  factory _$NutritionTemplateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionTemplateModelImplFromJson(json);

  @override
  final String key;
  @override
  final String name;
  @override
  final NutritionProfileModel data;
  @override
  final String? description;
  @override
  @JsonKey(name: 'icon_name')
  final String? iconName;
  final List<String>? _recommendedFor;
  @override
  @JsonKey(name: 'recommended_for')
  List<String>? get recommendedFor {
    final value = _recommendedFor;
    if (value == null) return null;
    if (_recommendedFor is EqualUnmodifiableListView) return _recommendedFor;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'NutritionTemplateModel(key: $key, name: $name, data: $data, description: $description, iconName: $iconName, recommendedFor: $recommendedFor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionTemplateModelImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            const DeepCollectionEquality()
                .equals(other._recommendedFor, _recommendedFor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, name, data, description,
      iconName, const DeepCollectionEquality().hash(_recommendedFor));

  /// Create a copy of NutritionTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionTemplateModelImplCopyWith<_$NutritionTemplateModelImpl>
      get copyWith => __$$NutritionTemplateModelImplCopyWithImpl<
          _$NutritionTemplateModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionTemplateModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionTemplateModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionTemplateModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionTemplateModelImplToJson(
      this,
    );
  }
}

abstract class _NutritionTemplateModel implements NutritionTemplateModel {
  const factory _NutritionTemplateModel(
      {required final String key,
      required final String name,
      required final NutritionProfileModel data,
      final String? description,
      @JsonKey(name: 'icon_name') final String? iconName,
      @JsonKey(name: 'recommended_for')
      final List<String>? recommendedFor}) = _$NutritionTemplateModelImpl;

  factory _NutritionTemplateModel.fromJson(Map<String, dynamic> json) =
      _$NutritionTemplateModelImpl.fromJson;

  @override
  String get key;
  @override
  String get name;
  @override
  NutritionProfileModel get data;
  @override
  String? get description;
  @override
  @JsonKey(name: 'icon_name')
  String? get iconName;
  @override
  @JsonKey(name: 'recommended_for')
  List<String>? get recommendedFor;

  /// Create a copy of NutritionTemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionTemplateModelImplCopyWith<_$NutritionTemplateModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

HealthGoalValidationResult _$HealthGoalValidationResultFromJson(
    Map<String, dynamic> json) {
  return _HealthGoalValidationResult.fromJson(json);
}

/// @nodoc
mixin _$HealthGoalValidationResult {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get field => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HealthGoalValidationResult value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HealthGoalValidationResult value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HealthGoalValidationResult value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this HealthGoalValidationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthGoalValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthGoalValidationResultCopyWith<HealthGoalValidationResult>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthGoalValidationResultCopyWith<$Res> {
  factory $HealthGoalValidationResultCopyWith(HealthGoalValidationResult value,
          $Res Function(HealthGoalValidationResult) then) =
      _$HealthGoalValidationResultCopyWithImpl<$Res,
          HealthGoalValidationResult>;
  @useResult
  $Res call({bool success, String message, String? field});
}

/// @nodoc
class _$HealthGoalValidationResultCopyWithImpl<$Res,
        $Val extends HealthGoalValidationResult>
    implements $HealthGoalValidationResultCopyWith<$Res> {
  _$HealthGoalValidationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthGoalValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? field = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      field: freezed == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthGoalValidationResultImplCopyWith<$Res>
    implements $HealthGoalValidationResultCopyWith<$Res> {
  factory _$$HealthGoalValidationResultImplCopyWith(
          _$HealthGoalValidationResultImpl value,
          $Res Function(_$HealthGoalValidationResultImpl) then) =
      __$$HealthGoalValidationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String message, String? field});
}

/// @nodoc
class __$$HealthGoalValidationResultImplCopyWithImpl<$Res>
    extends _$HealthGoalValidationResultCopyWithImpl<$Res,
        _$HealthGoalValidationResultImpl>
    implements _$$HealthGoalValidationResultImplCopyWith<$Res> {
  __$$HealthGoalValidationResultImplCopyWithImpl(
      _$HealthGoalValidationResultImpl _value,
      $Res Function(_$HealthGoalValidationResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of HealthGoalValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? field = freezed,
  }) {
    return _then(_$HealthGoalValidationResultImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      field: freezed == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthGoalValidationResultImpl implements _HealthGoalValidationResult {
  const _$HealthGoalValidationResultImpl(
      {required this.success, required this.message, this.field});

  factory _$HealthGoalValidationResultImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$HealthGoalValidationResultImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  @override
  final String? field;

  @override
  String toString() {
    return 'HealthGoalValidationResult(success: $success, message: $message, field: $field)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthGoalValidationResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.field, field) || other.field == field));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, message, field);

  /// Create a copy of HealthGoalValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthGoalValidationResultImplCopyWith<_$HealthGoalValidationResultImpl>
      get copyWith => __$$HealthGoalValidationResultImplCopyWithImpl<
          _$HealthGoalValidationResultImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HealthGoalValidationResult value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HealthGoalValidationResult value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HealthGoalValidationResult value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthGoalValidationResultImplToJson(
      this,
    );
  }
}

abstract class _HealthGoalValidationResult
    implements HealthGoalValidationResult {
  const factory _HealthGoalValidationResult(
      {required final bool success,
      required final String message,
      final String? field}) = _$HealthGoalValidationResultImpl;

  factory _HealthGoalValidationResult.fromJson(Map<String, dynamic> json) =
      _$HealthGoalValidationResultImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  String? get field;

  /// Create a copy of HealthGoalValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthGoalValidationResultImplCopyWith<_$HealthGoalValidationResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ConflictDetectionResult _$ConflictDetectionResultFromJson(
    Map<String, dynamic> json) {
  return _ConflictDetectionResult.fromJson(json);
}

/// @nodoc
mixin _$ConflictDetectionResult {
  bool get success => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_conflicts')
  bool get hasConflicts => throw _privateConstructorUsedError;
  List<ProfileConflict> get conflicts => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ConflictDetectionResult value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ConflictDetectionResult value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ConflictDetectionResult value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ConflictDetectionResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConflictDetectionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConflictDetectionResultCopyWith<ConflictDetectionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConflictDetectionResultCopyWith<$Res> {
  factory $ConflictDetectionResultCopyWith(ConflictDetectionResult value,
          $Res Function(ConflictDetectionResult) then) =
      _$ConflictDetectionResultCopyWithImpl<$Res, ConflictDetectionResult>;
  @useResult
  $Res call(
      {bool success,
      @JsonKey(name: 'has_conflicts') bool hasConflicts,
      List<ProfileConflict> conflicts});
}

/// @nodoc
class _$ConflictDetectionResultCopyWithImpl<$Res,
        $Val extends ConflictDetectionResult>
    implements $ConflictDetectionResultCopyWith<$Res> {
  _$ConflictDetectionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConflictDetectionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? hasConflicts = null,
    Object? conflicts = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      hasConflicts: null == hasConflicts
          ? _value.hasConflicts
          : hasConflicts // ignore: cast_nullable_to_non_nullable
              as bool,
      conflicts: null == conflicts
          ? _value.conflicts
          : conflicts // ignore: cast_nullable_to_non_nullable
              as List<ProfileConflict>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConflictDetectionResultImplCopyWith<$Res>
    implements $ConflictDetectionResultCopyWith<$Res> {
  factory _$$ConflictDetectionResultImplCopyWith(
          _$ConflictDetectionResultImpl value,
          $Res Function(_$ConflictDetectionResultImpl) then) =
      __$$ConflictDetectionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      @JsonKey(name: 'has_conflicts') bool hasConflicts,
      List<ProfileConflict> conflicts});
}

/// @nodoc
class __$$ConflictDetectionResultImplCopyWithImpl<$Res>
    extends _$ConflictDetectionResultCopyWithImpl<$Res,
        _$ConflictDetectionResultImpl>
    implements _$$ConflictDetectionResultImplCopyWith<$Res> {
  __$$ConflictDetectionResultImplCopyWithImpl(
      _$ConflictDetectionResultImpl _value,
      $Res Function(_$ConflictDetectionResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConflictDetectionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? hasConflicts = null,
    Object? conflicts = null,
  }) {
    return _then(_$ConflictDetectionResultImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      hasConflicts: null == hasConflicts
          ? _value.hasConflicts
          : hasConflicts // ignore: cast_nullable_to_non_nullable
              as bool,
      conflicts: null == conflicts
          ? _value._conflicts
          : conflicts // ignore: cast_nullable_to_non_nullable
              as List<ProfileConflict>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConflictDetectionResultImpl implements _ConflictDetectionResult {
  const _$ConflictDetectionResultImpl(
      {required this.success,
      @JsonKey(name: 'has_conflicts') required this.hasConflicts,
      required final List<ProfileConflict> conflicts})
      : _conflicts = conflicts;

  factory _$ConflictDetectionResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConflictDetectionResultImplFromJson(json);

  @override
  final bool success;
  @override
  @JsonKey(name: 'has_conflicts')
  final bool hasConflicts;
  final List<ProfileConflict> _conflicts;
  @override
  List<ProfileConflict> get conflicts {
    if (_conflicts is EqualUnmodifiableListView) return _conflicts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conflicts);
  }

  @override
  String toString() {
    return 'ConflictDetectionResult(success: $success, hasConflicts: $hasConflicts, conflicts: $conflicts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConflictDetectionResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.hasConflicts, hasConflicts) ||
                other.hasConflicts == hasConflicts) &&
            const DeepCollectionEquality()
                .equals(other._conflicts, _conflicts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, hasConflicts,
      const DeepCollectionEquality().hash(_conflicts));

  /// Create a copy of ConflictDetectionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConflictDetectionResultImplCopyWith<_$ConflictDetectionResultImpl>
      get copyWith => __$$ConflictDetectionResultImplCopyWithImpl<
          _$ConflictDetectionResultImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ConflictDetectionResult value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ConflictDetectionResult value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ConflictDetectionResult value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ConflictDetectionResultImplToJson(
      this,
    );
  }
}

abstract class _ConflictDetectionResult implements ConflictDetectionResult {
  const factory _ConflictDetectionResult(
          {required final bool success,
          @JsonKey(name: 'has_conflicts') required final bool hasConflicts,
          required final List<ProfileConflict> conflicts}) =
      _$ConflictDetectionResultImpl;

  factory _ConflictDetectionResult.fromJson(Map<String, dynamic> json) =
      _$ConflictDetectionResultImpl.fromJson;

  @override
  bool get success;
  @override
  @JsonKey(name: 'has_conflicts')
  bool get hasConflicts;
  @override
  List<ProfileConflict> get conflicts;

  /// Create a copy of ConflictDetectionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConflictDetectionResultImplCopyWith<_$ConflictDetectionResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ProfileConflict _$ProfileConflictFromJson(Map<String, dynamic> json) {
  return _ProfileConflict.fromJson(json);
}

/// @nodoc
mixin _$ProfileConflict {
  String get type => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get field => throw _privateConstructorUsedError;
  ConflictSeverity? get severity => throw _privateConstructorUsedError;
  List<String>? get suggestions => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProfileConflict value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProfileConflict value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProfileConflict value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ProfileConflict to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileConflict
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileConflictCopyWith<ProfileConflict> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileConflictCopyWith<$Res> {
  factory $ProfileConflictCopyWith(
          ProfileConflict value, $Res Function(ProfileConflict) then) =
      _$ProfileConflictCopyWithImpl<$Res, ProfileConflict>;
  @useResult
  $Res call(
      {String type,
      String message,
      String? field,
      ConflictSeverity? severity,
      List<String>? suggestions});
}

/// @nodoc
class _$ProfileConflictCopyWithImpl<$Res, $Val extends ProfileConflict>
    implements $ProfileConflictCopyWith<$Res> {
  _$ProfileConflictCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileConflict
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? message = null,
    Object? field = freezed,
    Object? severity = freezed,
    Object? suggestions = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      field: freezed == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: freezed == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as ConflictSeverity?,
      suggestions: freezed == suggestions
          ? _value.suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileConflictImplCopyWith<$Res>
    implements $ProfileConflictCopyWith<$Res> {
  factory _$$ProfileConflictImplCopyWith(_$ProfileConflictImpl value,
          $Res Function(_$ProfileConflictImpl) then) =
      __$$ProfileConflictImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      String message,
      String? field,
      ConflictSeverity? severity,
      List<String>? suggestions});
}

/// @nodoc
class __$$ProfileConflictImplCopyWithImpl<$Res>
    extends _$ProfileConflictCopyWithImpl<$Res, _$ProfileConflictImpl>
    implements _$$ProfileConflictImplCopyWith<$Res> {
  __$$ProfileConflictImplCopyWithImpl(
      _$ProfileConflictImpl _value, $Res Function(_$ProfileConflictImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileConflict
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? message = null,
    Object? field = freezed,
    Object? severity = freezed,
    Object? suggestions = freezed,
  }) {
    return _then(_$ProfileConflictImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      field: freezed == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: freezed == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as ConflictSeverity?,
      suggestions: freezed == suggestions
          ? _value._suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileConflictImpl implements _ProfileConflict {
  const _$ProfileConflictImpl(
      {required this.type,
      required this.message,
      this.field,
      this.severity,
      final List<String>? suggestions})
      : _suggestions = suggestions;

  factory _$ProfileConflictImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileConflictImplFromJson(json);

  @override
  final String type;
  @override
  final String message;
  @override
  final String? field;
  @override
  final ConflictSeverity? severity;
  final List<String>? _suggestions;
  @override
  List<String>? get suggestions {
    final value = _suggestions;
    if (value == null) return null;
    if (_suggestions is EqualUnmodifiableListView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ProfileConflict(type: $type, message: $message, field: $field, severity: $severity, suggestions: $suggestions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileConflictImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            const DeepCollectionEquality()
                .equals(other._suggestions, _suggestions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, message, field, severity,
      const DeepCollectionEquality().hash(_suggestions));

  /// Create a copy of ProfileConflict
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileConflictImplCopyWith<_$ProfileConflictImpl> get copyWith =>
      __$$ProfileConflictImplCopyWithImpl<_$ProfileConflictImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProfileConflict value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProfileConflict value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProfileConflict value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileConflictImplToJson(
      this,
    );
  }
}

abstract class _ProfileConflict implements ProfileConflict {
  const factory _ProfileConflict(
      {required final String type,
      required final String message,
      final String? field,
      final ConflictSeverity? severity,
      final List<String>? suggestions}) = _$ProfileConflictImpl;

  factory _ProfileConflict.fromJson(Map<String, dynamic> json) =
      _$ProfileConflictImpl.fromJson;

  @override
  String get type;
  @override
  String get message;
  @override
  String? get field;
  @override
  ConflictSeverity? get severity;
  @override
  List<String>? get suggestions;

  /// Create a copy of ProfileConflict
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileConflictImplCopyWith<_$ProfileConflictImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionSuggestions _$NutritionSuggestionsFromJson(Map<String, dynamic> json) {
  return _NutritionSuggestions.fromJson(json);
}

/// @nodoc
mixin _$NutritionSuggestions {
  bool get success => throw _privateConstructorUsedError;
  SuggestionsData get suggestions => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionSuggestions value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionSuggestions value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionSuggestions value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionSuggestions to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionSuggestions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionSuggestionsCopyWith<NutritionSuggestions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionSuggestionsCopyWith<$Res> {
  factory $NutritionSuggestionsCopyWith(NutritionSuggestions value,
          $Res Function(NutritionSuggestions) then) =
      _$NutritionSuggestionsCopyWithImpl<$Res, NutritionSuggestions>;
  @useResult
  $Res call({bool success, SuggestionsData suggestions});

  $SuggestionsDataCopyWith<$Res> get suggestions;
}

/// @nodoc
class _$NutritionSuggestionsCopyWithImpl<$Res,
        $Val extends NutritionSuggestions>
    implements $NutritionSuggestionsCopyWith<$Res> {
  _$NutritionSuggestionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionSuggestions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? suggestions = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      suggestions: null == suggestions
          ? _value.suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as SuggestionsData,
    ) as $Val);
  }

  /// Create a copy of NutritionSuggestions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SuggestionsDataCopyWith<$Res> get suggestions {
    return $SuggestionsDataCopyWith<$Res>(_value.suggestions, (value) {
      return _then(_value.copyWith(suggestions: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionSuggestionsImplCopyWith<$Res>
    implements $NutritionSuggestionsCopyWith<$Res> {
  factory _$$NutritionSuggestionsImplCopyWith(_$NutritionSuggestionsImpl value,
          $Res Function(_$NutritionSuggestionsImpl) then) =
      __$$NutritionSuggestionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, SuggestionsData suggestions});

  @override
  $SuggestionsDataCopyWith<$Res> get suggestions;
}

/// @nodoc
class __$$NutritionSuggestionsImplCopyWithImpl<$Res>
    extends _$NutritionSuggestionsCopyWithImpl<$Res, _$NutritionSuggestionsImpl>
    implements _$$NutritionSuggestionsImplCopyWith<$Res> {
  __$$NutritionSuggestionsImplCopyWithImpl(_$NutritionSuggestionsImpl _value,
      $Res Function(_$NutritionSuggestionsImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionSuggestions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? suggestions = null,
  }) {
    return _then(_$NutritionSuggestionsImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      suggestions: null == suggestions
          ? _value.suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as SuggestionsData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionSuggestionsImpl implements _NutritionSuggestions {
  const _$NutritionSuggestionsImpl(
      {required this.success, required this.suggestions});

  factory _$NutritionSuggestionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionSuggestionsImplFromJson(json);

  @override
  final bool success;
  @override
  final SuggestionsData suggestions;

  @override
  String toString() {
    return 'NutritionSuggestions(success: $success, suggestions: $suggestions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionSuggestionsImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.suggestions, suggestions) ||
                other.suggestions == suggestions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, suggestions);

  /// Create a copy of NutritionSuggestions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionSuggestionsImplCopyWith<_$NutritionSuggestionsImpl>
      get copyWith =>
          __$$NutritionSuggestionsImplCopyWithImpl<_$NutritionSuggestionsImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionSuggestions value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionSuggestions value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionSuggestions value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionSuggestionsImplToJson(
      this,
    );
  }
}

abstract class _NutritionSuggestions implements NutritionSuggestions {
  const factory _NutritionSuggestions(
      {required final bool success,
      required final SuggestionsData suggestions}) = _$NutritionSuggestionsImpl;

  factory _NutritionSuggestions.fromJson(Map<String, dynamic> json) =
      _$NutritionSuggestionsImpl.fromJson;

  @override
  bool get success;
  @override
  SuggestionsData get suggestions;

  /// Create a copy of NutritionSuggestions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionSuggestionsImplCopyWith<_$NutritionSuggestionsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SuggestionsData _$SuggestionsDataFromJson(Map<String, dynamic> json) {
  return _SuggestionsData.fromJson(json);
}

/// @nodoc
mixin _$SuggestionsData {
  @JsonKey(name: 'dietary_type')
  List<String>? get dietaryType => throw _privateConstructorUsedError;
  @JsonKey(name: 'taste_preferences')
  Map<String, int>? get tastePreferences => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_calorie_target')
  int? get dailyCalorieTarget => throw _privateConstructorUsedError;
  @JsonKey(name: 'macro_ratios')
  MacroRatios? get macroRatios => throw _privateConstructorUsedError;
  @JsonKey(name: 'hydration_goal')
  int? get hydrationGoal => throw _privateConstructorUsedError;
  @JsonKey(name: 'meal_frequency')
  int? get mealFrequency => throw _privateConstructorUsedError;
  @JsonKey(name: 'exercise_types')
  List<String>? get exerciseTypes => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplement_recommendations')
  List<String>? get supplementRecommendations =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SuggestionsData value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SuggestionsData value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SuggestionsData value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this SuggestionsData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SuggestionsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SuggestionsDataCopyWith<SuggestionsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestionsDataCopyWith<$Res> {
  factory $SuggestionsDataCopyWith(
          SuggestionsData value, $Res Function(SuggestionsData) then) =
      _$SuggestionsDataCopyWithImpl<$Res, SuggestionsData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'dietary_type') List<String>? dietaryType,
      @JsonKey(name: 'taste_preferences') Map<String, int>? tastePreferences,
      @JsonKey(name: 'daily_calorie_target') int? dailyCalorieTarget,
      @JsonKey(name: 'macro_ratios') MacroRatios? macroRatios,
      @JsonKey(name: 'hydration_goal') int? hydrationGoal,
      @JsonKey(name: 'meal_frequency') int? mealFrequency,
      @JsonKey(name: 'exercise_types') List<String>? exerciseTypes,
      @JsonKey(name: 'supplement_recommendations')
      List<String>? supplementRecommendations});

  $MacroRatiosCopyWith<$Res>? get macroRatios;
}

/// @nodoc
class _$SuggestionsDataCopyWithImpl<$Res, $Val extends SuggestionsData>
    implements $SuggestionsDataCopyWith<$Res> {
  _$SuggestionsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SuggestionsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dietaryType = freezed,
    Object? tastePreferences = freezed,
    Object? dailyCalorieTarget = freezed,
    Object? macroRatios = freezed,
    Object? hydrationGoal = freezed,
    Object? mealFrequency = freezed,
    Object? exerciseTypes = freezed,
    Object? supplementRecommendations = freezed,
  }) {
    return _then(_value.copyWith(
      dietaryType: freezed == dietaryType
          ? _value.dietaryType
          : dietaryType // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tastePreferences: freezed == tastePreferences
          ? _value.tastePreferences
          : tastePreferences // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      dailyCalorieTarget: freezed == dailyCalorieTarget
          ? _value.dailyCalorieTarget
          : dailyCalorieTarget // ignore: cast_nullable_to_non_nullable
              as int?,
      macroRatios: freezed == macroRatios
          ? _value.macroRatios
          : macroRatios // ignore: cast_nullable_to_non_nullable
              as MacroRatios?,
      hydrationGoal: freezed == hydrationGoal
          ? _value.hydrationGoal
          : hydrationGoal // ignore: cast_nullable_to_non_nullable
              as int?,
      mealFrequency: freezed == mealFrequency
          ? _value.mealFrequency
          : mealFrequency // ignore: cast_nullable_to_non_nullable
              as int?,
      exerciseTypes: freezed == exerciseTypes
          ? _value.exerciseTypes
          : exerciseTypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      supplementRecommendations: freezed == supplementRecommendations
          ? _value.supplementRecommendations
          : supplementRecommendations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  /// Create a copy of SuggestionsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MacroRatiosCopyWith<$Res>? get macroRatios {
    if (_value.macroRatios == null) {
      return null;
    }

    return $MacroRatiosCopyWith<$Res>(_value.macroRatios!, (value) {
      return _then(_value.copyWith(macroRatios: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SuggestionsDataImplCopyWith<$Res>
    implements $SuggestionsDataCopyWith<$Res> {
  factory _$$SuggestionsDataImplCopyWith(_$SuggestionsDataImpl value,
          $Res Function(_$SuggestionsDataImpl) then) =
      __$$SuggestionsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'dietary_type') List<String>? dietaryType,
      @JsonKey(name: 'taste_preferences') Map<String, int>? tastePreferences,
      @JsonKey(name: 'daily_calorie_target') int? dailyCalorieTarget,
      @JsonKey(name: 'macro_ratios') MacroRatios? macroRatios,
      @JsonKey(name: 'hydration_goal') int? hydrationGoal,
      @JsonKey(name: 'meal_frequency') int? mealFrequency,
      @JsonKey(name: 'exercise_types') List<String>? exerciseTypes,
      @JsonKey(name: 'supplement_recommendations')
      List<String>? supplementRecommendations});

  @override
  $MacroRatiosCopyWith<$Res>? get macroRatios;
}

/// @nodoc
class __$$SuggestionsDataImplCopyWithImpl<$Res>
    extends _$SuggestionsDataCopyWithImpl<$Res, _$SuggestionsDataImpl>
    implements _$$SuggestionsDataImplCopyWith<$Res> {
  __$$SuggestionsDataImplCopyWithImpl(
      _$SuggestionsDataImpl _value, $Res Function(_$SuggestionsDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of SuggestionsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dietaryType = freezed,
    Object? tastePreferences = freezed,
    Object? dailyCalorieTarget = freezed,
    Object? macroRatios = freezed,
    Object? hydrationGoal = freezed,
    Object? mealFrequency = freezed,
    Object? exerciseTypes = freezed,
    Object? supplementRecommendations = freezed,
  }) {
    return _then(_$SuggestionsDataImpl(
      dietaryType: freezed == dietaryType
          ? _value._dietaryType
          : dietaryType // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tastePreferences: freezed == tastePreferences
          ? _value._tastePreferences
          : tastePreferences // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      dailyCalorieTarget: freezed == dailyCalorieTarget
          ? _value.dailyCalorieTarget
          : dailyCalorieTarget // ignore: cast_nullable_to_non_nullable
              as int?,
      macroRatios: freezed == macroRatios
          ? _value.macroRatios
          : macroRatios // ignore: cast_nullable_to_non_nullable
              as MacroRatios?,
      hydrationGoal: freezed == hydrationGoal
          ? _value.hydrationGoal
          : hydrationGoal // ignore: cast_nullable_to_non_nullable
              as int?,
      mealFrequency: freezed == mealFrequency
          ? _value.mealFrequency
          : mealFrequency // ignore: cast_nullable_to_non_nullable
              as int?,
      exerciseTypes: freezed == exerciseTypes
          ? _value._exerciseTypes
          : exerciseTypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      supplementRecommendations: freezed == supplementRecommendations
          ? _value._supplementRecommendations
          : supplementRecommendations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestionsDataImpl implements _SuggestionsData {
  const _$SuggestionsDataImpl(
      {@JsonKey(name: 'dietary_type') final List<String>? dietaryType,
      @JsonKey(name: 'taste_preferences')
      final Map<String, int>? tastePreferences,
      @JsonKey(name: 'daily_calorie_target') this.dailyCalorieTarget,
      @JsonKey(name: 'macro_ratios') this.macroRatios,
      @JsonKey(name: 'hydration_goal') this.hydrationGoal,
      @JsonKey(name: 'meal_frequency') this.mealFrequency,
      @JsonKey(name: 'exercise_types') final List<String>? exerciseTypes,
      @JsonKey(name: 'supplement_recommendations')
      final List<String>? supplementRecommendations})
      : _dietaryType = dietaryType,
        _tastePreferences = tastePreferences,
        _exerciseTypes = exerciseTypes,
        _supplementRecommendations = supplementRecommendations;

  factory _$SuggestionsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestionsDataImplFromJson(json);

  final List<String>? _dietaryType;
  @override
  @JsonKey(name: 'dietary_type')
  List<String>? get dietaryType {
    final value = _dietaryType;
    if (value == null) return null;
    if (_dietaryType is EqualUnmodifiableListView) return _dietaryType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, int>? _tastePreferences;
  @override
  @JsonKey(name: 'taste_preferences')
  Map<String, int>? get tastePreferences {
    final value = _tastePreferences;
    if (value == null) return null;
    if (_tastePreferences is EqualUnmodifiableMapView) return _tastePreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'daily_calorie_target')
  final int? dailyCalorieTarget;
  @override
  @JsonKey(name: 'macro_ratios')
  final MacroRatios? macroRatios;
  @override
  @JsonKey(name: 'hydration_goal')
  final int? hydrationGoal;
  @override
  @JsonKey(name: 'meal_frequency')
  final int? mealFrequency;
  final List<String>? _exerciseTypes;
  @override
  @JsonKey(name: 'exercise_types')
  List<String>? get exerciseTypes {
    final value = _exerciseTypes;
    if (value == null) return null;
    if (_exerciseTypes is EqualUnmodifiableListView) return _exerciseTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _supplementRecommendations;
  @override
  @JsonKey(name: 'supplement_recommendations')
  List<String>? get supplementRecommendations {
    final value = _supplementRecommendations;
    if (value == null) return null;
    if (_supplementRecommendations is EqualUnmodifiableListView)
      return _supplementRecommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SuggestionsData(dietaryType: $dietaryType, tastePreferences: $tastePreferences, dailyCalorieTarget: $dailyCalorieTarget, macroRatios: $macroRatios, hydrationGoal: $hydrationGoal, mealFrequency: $mealFrequency, exerciseTypes: $exerciseTypes, supplementRecommendations: $supplementRecommendations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestionsDataImpl &&
            const DeepCollectionEquality()
                .equals(other._dietaryType, _dietaryType) &&
            const DeepCollectionEquality()
                .equals(other._tastePreferences, _tastePreferences) &&
            (identical(other.dailyCalorieTarget, dailyCalorieTarget) ||
                other.dailyCalorieTarget == dailyCalorieTarget) &&
            (identical(other.macroRatios, macroRatios) ||
                other.macroRatios == macroRatios) &&
            (identical(other.hydrationGoal, hydrationGoal) ||
                other.hydrationGoal == hydrationGoal) &&
            (identical(other.mealFrequency, mealFrequency) ||
                other.mealFrequency == mealFrequency) &&
            const DeepCollectionEquality()
                .equals(other._exerciseTypes, _exerciseTypes) &&
            const DeepCollectionEquality().equals(
                other._supplementRecommendations, _supplementRecommendations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_dietaryType),
      const DeepCollectionEquality().hash(_tastePreferences),
      dailyCalorieTarget,
      macroRatios,
      hydrationGoal,
      mealFrequency,
      const DeepCollectionEquality().hash(_exerciseTypes),
      const DeepCollectionEquality().hash(_supplementRecommendations));

  /// Create a copy of SuggestionsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestionsDataImplCopyWith<_$SuggestionsDataImpl> get copyWith =>
      __$$SuggestionsDataImplCopyWithImpl<_$SuggestionsDataImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SuggestionsData value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SuggestionsData value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SuggestionsData value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestionsDataImplToJson(
      this,
    );
  }
}

abstract class _SuggestionsData implements SuggestionsData {
  const factory _SuggestionsData(
      {@JsonKey(name: 'dietary_type') final List<String>? dietaryType,
      @JsonKey(name: 'taste_preferences')
      final Map<String, int>? tastePreferences,
      @JsonKey(name: 'daily_calorie_target') final int? dailyCalorieTarget,
      @JsonKey(name: 'macro_ratios') final MacroRatios? macroRatios,
      @JsonKey(name: 'hydration_goal') final int? hydrationGoal,
      @JsonKey(name: 'meal_frequency') final int? mealFrequency,
      @JsonKey(name: 'exercise_types') final List<String>? exerciseTypes,
      @JsonKey(name: 'supplement_recommendations')
      final List<String>? supplementRecommendations}) = _$SuggestionsDataImpl;

  factory _SuggestionsData.fromJson(Map<String, dynamic> json) =
      _$SuggestionsDataImpl.fromJson;

  @override
  @JsonKey(name: 'dietary_type')
  List<String>? get dietaryType;
  @override
  @JsonKey(name: 'taste_preferences')
  Map<String, int>? get tastePreferences;
  @override
  @JsonKey(name: 'daily_calorie_target')
  int? get dailyCalorieTarget;
  @override
  @JsonKey(name: 'macro_ratios')
  MacroRatios? get macroRatios;
  @override
  @JsonKey(name: 'hydration_goal')
  int? get hydrationGoal;
  @override
  @JsonKey(name: 'meal_frequency')
  int? get mealFrequency;
  @override
  @JsonKey(name: 'exercise_types')
  List<String>? get exerciseTypes;
  @override
  @JsonKey(name: 'supplement_recommendations')
  List<String>? get supplementRecommendations;

  /// Create a copy of SuggestionsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuggestionsDataImplCopyWith<_$SuggestionsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MacroRatios _$MacroRatiosFromJson(Map<String, dynamic> json) {
  return _MacroRatios.fromJson(json);
}

/// @nodoc
mixin _$MacroRatios {
  double get protein => throw _privateConstructorUsedError;
  double get fat => throw _privateConstructorUsedError;
  double get carbs => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MacroRatios value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MacroRatios value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MacroRatios value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MacroRatios to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MacroRatios
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MacroRatiosCopyWith<MacroRatios> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MacroRatiosCopyWith<$Res> {
  factory $MacroRatiosCopyWith(
          MacroRatios value, $Res Function(MacroRatios) then) =
      _$MacroRatiosCopyWithImpl<$Res, MacroRatios>;
  @useResult
  $Res call({double protein, double fat, double carbs});
}

/// @nodoc
class _$MacroRatiosCopyWithImpl<$Res, $Val extends MacroRatios>
    implements $MacroRatiosCopyWith<$Res> {
  _$MacroRatiosCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MacroRatios
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? protein = null,
    Object? fat = null,
    Object? carbs = null,
  }) {
    return _then(_value.copyWith(
      protein: null == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      fat: null == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double,
      carbs: null == carbs
          ? _value.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MacroRatiosImplCopyWith<$Res>
    implements $MacroRatiosCopyWith<$Res> {
  factory _$$MacroRatiosImplCopyWith(
          _$MacroRatiosImpl value, $Res Function(_$MacroRatiosImpl) then) =
      __$$MacroRatiosImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double protein, double fat, double carbs});
}

/// @nodoc
class __$$MacroRatiosImplCopyWithImpl<$Res>
    extends _$MacroRatiosCopyWithImpl<$Res, _$MacroRatiosImpl>
    implements _$$MacroRatiosImplCopyWith<$Res> {
  __$$MacroRatiosImplCopyWithImpl(
      _$MacroRatiosImpl _value, $Res Function(_$MacroRatiosImpl) _then)
      : super(_value, _then);

  /// Create a copy of MacroRatios
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? protein = null,
    Object? fat = null,
    Object? carbs = null,
  }) {
    return _then(_$MacroRatiosImpl(
      protein: null == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      fat: null == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double,
      carbs: null == carbs
          ? _value.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MacroRatiosImpl implements _MacroRatios {
  const _$MacroRatiosImpl(
      {required this.protein, required this.fat, required this.carbs});

  factory _$MacroRatiosImpl.fromJson(Map<String, dynamic> json) =>
      _$$MacroRatiosImplFromJson(json);

  @override
  final double protein;
  @override
  final double fat;
  @override
  final double carbs;

  @override
  String toString() {
    return 'MacroRatios(protein: $protein, fat: $fat, carbs: $carbs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MacroRatiosImpl &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.fat, fat) || other.fat == fat) &&
            (identical(other.carbs, carbs) || other.carbs == carbs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, protein, fat, carbs);

  /// Create a copy of MacroRatios
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MacroRatiosImplCopyWith<_$MacroRatiosImpl> get copyWith =>
      __$$MacroRatiosImplCopyWithImpl<_$MacroRatiosImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MacroRatios value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MacroRatios value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MacroRatios value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MacroRatiosImplToJson(
      this,
    );
  }
}

abstract class _MacroRatios implements MacroRatios {
  const factory _MacroRatios(
      {required final double protein,
      required final double fat,
      required final double carbs}) = _$MacroRatiosImpl;

  factory _MacroRatios.fromJson(Map<String, dynamic> json) =
      _$MacroRatiosImpl.fromJson;

  @override
  double get protein;
  @override
  double get fat;
  @override
  double get carbs;

  /// Create a copy of MacroRatios
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MacroRatiosImplCopyWith<_$MacroRatiosImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
