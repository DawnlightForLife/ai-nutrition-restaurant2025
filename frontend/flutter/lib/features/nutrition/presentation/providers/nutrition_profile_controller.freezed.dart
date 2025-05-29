// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrition_profile_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CompletionStats {
  int get completionPercentage => throw _privateConstructorUsedError;
  List<String> get missingFields => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CompletionStats value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CompletionStats value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CompletionStats value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of CompletionStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompletionStatsCopyWith<CompletionStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompletionStatsCopyWith<$Res> {
  factory $CompletionStatsCopyWith(
          CompletionStats value, $Res Function(CompletionStats) then) =
      _$CompletionStatsCopyWithImpl<$Res, CompletionStats>;
  @useResult
  $Res call({int completionPercentage, List<String> missingFields});
}

/// @nodoc
class _$CompletionStatsCopyWithImpl<$Res, $Val extends CompletionStats>
    implements $CompletionStatsCopyWith<$Res> {
  _$CompletionStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompletionStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completionPercentage = null,
    Object? missingFields = null,
  }) {
    return _then(_value.copyWith(
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as int,
      missingFields: null == missingFields
          ? _value.missingFields
          : missingFields // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompletionStatsImplCopyWith<$Res>
    implements $CompletionStatsCopyWith<$Res> {
  factory _$$CompletionStatsImplCopyWith(_$CompletionStatsImpl value,
          $Res Function(_$CompletionStatsImpl) then) =
      __$$CompletionStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int completionPercentage, List<String> missingFields});
}

/// @nodoc
class __$$CompletionStatsImplCopyWithImpl<$Res>
    extends _$CompletionStatsCopyWithImpl<$Res, _$CompletionStatsImpl>
    implements _$$CompletionStatsImplCopyWith<$Res> {
  __$$CompletionStatsImplCopyWithImpl(
      _$CompletionStatsImpl _value, $Res Function(_$CompletionStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompletionStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completionPercentage = null,
    Object? missingFields = null,
  }) {
    return _then(_$CompletionStatsImpl(
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as int,
      missingFields: null == missingFields
          ? _value._missingFields
          : missingFields // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$CompletionStatsImpl implements _CompletionStats {
  const _$CompletionStatsImpl(
      {required this.completionPercentage,
      required final List<String> missingFields})
      : _missingFields = missingFields;

  @override
  final int completionPercentage;
  final List<String> _missingFields;
  @override
  List<String> get missingFields {
    if (_missingFields is EqualUnmodifiableListView) return _missingFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_missingFields);
  }

  @override
  String toString() {
    return 'CompletionStats(completionPercentage: $completionPercentage, missingFields: $missingFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletionStatsImpl &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            const DeepCollectionEquality()
                .equals(other._missingFields, _missingFields));
  }

  @override
  int get hashCode => Object.hash(runtimeType, completionPercentage,
      const DeepCollectionEquality().hash(_missingFields));

  /// Create a copy of CompletionStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletionStatsImplCopyWith<_$CompletionStatsImpl> get copyWith =>
      __$$CompletionStatsImplCopyWithImpl<_$CompletionStatsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CompletionStats value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CompletionStats value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CompletionStats value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _CompletionStats implements CompletionStats {
  const factory _CompletionStats(
      {required final int completionPercentage,
      required final List<String> missingFields}) = _$CompletionStatsImpl;

  @override
  int get completionPercentage;
  @override
  List<String> get missingFields;

  /// Create a copy of CompletionStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompletionStatsImplCopyWith<_$CompletionStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NutritionProfileState {
  NutritionProfile? get profile => throw _privateConstructorUsedError;
  CompletionStats? get completionStats => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionProfileState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionProfileState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionProfileState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of NutritionProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionProfileStateCopyWith<NutritionProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionProfileStateCopyWith<$Res> {
  factory $NutritionProfileStateCopyWith(NutritionProfileState value,
          $Res Function(NutritionProfileState) then) =
      _$NutritionProfileStateCopyWithImpl<$Res, NutritionProfileState>;
  @useResult
  $Res call({NutritionProfile? profile, CompletionStats? completionStats});

  $CompletionStatsCopyWith<$Res>? get completionStats;
}

/// @nodoc
class _$NutritionProfileStateCopyWithImpl<$Res,
        $Val extends NutritionProfileState>
    implements $NutritionProfileStateCopyWith<$Res> {
  _$NutritionProfileStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionProfileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = freezed,
    Object? completionStats = freezed,
  }) {
    return _then(_value.copyWith(
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as NutritionProfile?,
      completionStats: freezed == completionStats
          ? _value.completionStats
          : completionStats // ignore: cast_nullable_to_non_nullable
              as CompletionStats?,
    ) as $Val);
  }

  /// Create a copy of NutritionProfileState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompletionStatsCopyWith<$Res>? get completionStats {
    if (_value.completionStats == null) {
      return null;
    }

    return $CompletionStatsCopyWith<$Res>(_value.completionStats!, (value) {
      return _then(_value.copyWith(completionStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionProfileStateImplCopyWith<$Res>
    implements $NutritionProfileStateCopyWith<$Res> {
  factory _$$NutritionProfileStateImplCopyWith(
          _$NutritionProfileStateImpl value,
          $Res Function(_$NutritionProfileStateImpl) then) =
      __$$NutritionProfileStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({NutritionProfile? profile, CompletionStats? completionStats});

  @override
  $CompletionStatsCopyWith<$Res>? get completionStats;
}

/// @nodoc
class __$$NutritionProfileStateImplCopyWithImpl<$Res>
    extends _$NutritionProfileStateCopyWithImpl<$Res,
        _$NutritionProfileStateImpl>
    implements _$$NutritionProfileStateImplCopyWith<$Res> {
  __$$NutritionProfileStateImplCopyWithImpl(_$NutritionProfileStateImpl _value,
      $Res Function(_$NutritionProfileStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionProfileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = freezed,
    Object? completionStats = freezed,
  }) {
    return _then(_$NutritionProfileStateImpl(
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as NutritionProfile?,
      completionStats: freezed == completionStats
          ? _value.completionStats
          : completionStats // ignore: cast_nullable_to_non_nullable
              as CompletionStats?,
    ));
  }
}

/// @nodoc

class _$NutritionProfileStateImpl implements _NutritionProfileState {
  const _$NutritionProfileStateImpl({this.profile, this.completionStats});

  @override
  final NutritionProfile? profile;
  @override
  final CompletionStats? completionStats;

  @override
  String toString() {
    return 'NutritionProfileState(profile: $profile, completionStats: $completionStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionProfileStateImpl &&
            const DeepCollectionEquality().equals(other.profile, profile) &&
            (identical(other.completionStats, completionStats) ||
                other.completionStats == completionStats));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(profile), completionStats);

  /// Create a copy of NutritionProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionProfileStateImplCopyWith<_$NutritionProfileStateImpl>
      get copyWith => __$$NutritionProfileStateImplCopyWithImpl<
          _$NutritionProfileStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionProfileState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionProfileState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionProfileState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _NutritionProfileState implements NutritionProfileState {
  const factory _NutritionProfileState(
      {final NutritionProfile? profile,
      final CompletionStats? completionStats}) = _$NutritionProfileStateImpl;

  @override
  NutritionProfile? get profile;
  @override
  CompletionStats? get completionStats;

  /// Create a copy of NutritionProfileState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionProfileStateImplCopyWith<_$NutritionProfileStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
