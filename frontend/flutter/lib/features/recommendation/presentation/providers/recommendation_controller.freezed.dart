// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecommendationState {
  List<Urecommendation> get recommendations =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RecommendationState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RecommendationState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RecommendationState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of RecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationStateCopyWith<RecommendationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationStateCopyWith<$Res> {
  factory $RecommendationStateCopyWith(
          RecommendationState value, $Res Function(RecommendationState) then) =
      _$RecommendationStateCopyWithImpl<$Res, RecommendationState>;
  @useResult
  $Res call(
      {List<Urecommendation> recommendations,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$RecommendationStateCopyWithImpl<$Res, $Val extends RecommendationState>
    implements $RecommendationStateCopyWith<$Res> {
  _$RecommendationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recommendations = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<Urecommendation>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendationStateImplCopyWith<$Res>
    implements $RecommendationStateCopyWith<$Res> {
  factory _$$RecommendationStateImplCopyWith(_$RecommendationStateImpl value,
          $Res Function(_$RecommendationStateImpl) then) =
      __$$RecommendationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Urecommendation> recommendations,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$$RecommendationStateImplCopyWithImpl<$Res>
    extends _$RecommendationStateCopyWithImpl<$Res, _$RecommendationStateImpl>
    implements _$$RecommendationStateImplCopyWith<$Res> {
  __$$RecommendationStateImplCopyWithImpl(_$RecommendationStateImpl _value,
      $Res Function(_$RecommendationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recommendations = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$RecommendationStateImpl(
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<Urecommendation>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$RecommendationStateImpl implements _RecommendationState {
  const _$RecommendationStateImpl(
      {final List<Urecommendation> recommendations = const [],
      this.isLoading = false,
      this.errorMessage})
      : _recommendations = recommendations;

  final List<Urecommendation> _recommendations;
  @override
  @JsonKey()
  List<Urecommendation> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'RecommendationState(recommendations: $recommendations, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationStateImpl &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_recommendations),
      isLoading,
      errorMessage);

  /// Create a copy of RecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationStateImplCopyWith<_$RecommendationStateImpl> get copyWith =>
      __$$RecommendationStateImplCopyWithImpl<_$RecommendationStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RecommendationState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RecommendationState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RecommendationState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _RecommendationState implements RecommendationState {
  const factory _RecommendationState(
      {final List<Urecommendation> recommendations,
      final bool isLoading,
      final String? errorMessage}) = _$RecommendationStateImpl;

  @override
  List<Urecommendation> get recommendations;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of RecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationStateImplCopyWith<_$RecommendationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
