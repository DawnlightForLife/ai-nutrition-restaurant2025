// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_recommendation_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AIRecommendationState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get hasError => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  AIRecommendation? get recommendation => throw _privateConstructorUsedError;
  Map<String, dynamic> get userAdjustments =>
      throw _privateConstructorUsedError;
  List<AIRecommendation> get history => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AIRecommendationState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AIRecommendationState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AIRecommendationState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of AIRecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIRecommendationStateCopyWith<AIRecommendationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIRecommendationStateCopyWith<$Res> {
  factory $AIRecommendationStateCopyWith(AIRecommendationState value,
          $Res Function(AIRecommendationState) then) =
      _$AIRecommendationStateCopyWithImpl<$Res, AIRecommendationState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool hasError,
      String? errorMessage,
      AIRecommendation? recommendation,
      Map<String, dynamic> userAdjustments,
      List<AIRecommendation> history});
}

/// @nodoc
class _$AIRecommendationStateCopyWithImpl<$Res,
        $Val extends AIRecommendationState>
    implements $AIRecommendationStateCopyWith<$Res> {
  _$AIRecommendationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIRecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? hasError = null,
    Object? errorMessage = freezed,
    Object? recommendation = freezed,
    Object? userAdjustments = null,
    Object? history = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasError: null == hasError
          ? _value.hasError
          : hasError // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      recommendation: freezed == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as AIRecommendation?,
      userAdjustments: null == userAdjustments
          ? _value.userAdjustments
          : userAdjustments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<AIRecommendation>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIRecommendationStateImplCopyWith<$Res>
    implements $AIRecommendationStateCopyWith<$Res> {
  factory _$$AIRecommendationStateImplCopyWith(
          _$AIRecommendationStateImpl value,
          $Res Function(_$AIRecommendationStateImpl) then) =
      __$$AIRecommendationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool hasError,
      String? errorMessage,
      AIRecommendation? recommendation,
      Map<String, dynamic> userAdjustments,
      List<AIRecommendation> history});
}

/// @nodoc
class __$$AIRecommendationStateImplCopyWithImpl<$Res>
    extends _$AIRecommendationStateCopyWithImpl<$Res,
        _$AIRecommendationStateImpl>
    implements _$$AIRecommendationStateImplCopyWith<$Res> {
  __$$AIRecommendationStateImplCopyWithImpl(_$AIRecommendationStateImpl _value,
      $Res Function(_$AIRecommendationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIRecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? hasError = null,
    Object? errorMessage = freezed,
    Object? recommendation = freezed,
    Object? userAdjustments = null,
    Object? history = null,
  }) {
    return _then(_$AIRecommendationStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasError: null == hasError
          ? _value.hasError
          : hasError // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      recommendation: freezed == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as AIRecommendation?,
      userAdjustments: null == userAdjustments
          ? _value._userAdjustments
          : userAdjustments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      history: null == history
          ? _value._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<AIRecommendation>,
    ));
  }
}

/// @nodoc

class _$AIRecommendationStateImpl implements _AIRecommendationState {
  const _$AIRecommendationStateImpl(
      {this.isLoading = false,
      this.hasError = false,
      this.errorMessage,
      this.recommendation,
      final Map<String, dynamic> userAdjustments = const {},
      final List<AIRecommendation> history = const []})
      : _userAdjustments = userAdjustments,
        _history = history;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool hasError;
  @override
  final String? errorMessage;
  @override
  final AIRecommendation? recommendation;
  final Map<String, dynamic> _userAdjustments;
  @override
  @JsonKey()
  Map<String, dynamic> get userAdjustments {
    if (_userAdjustments is EqualUnmodifiableMapView) return _userAdjustments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_userAdjustments);
  }

  final List<AIRecommendation> _history;
  @override
  @JsonKey()
  List<AIRecommendation> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  String toString() {
    return 'AIRecommendationState(isLoading: $isLoading, hasError: $hasError, errorMessage: $errorMessage, recommendation: $recommendation, userAdjustments: $userAdjustments, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIRecommendationStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasError, hasError) ||
                other.hasError == hasError) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.recommendation, recommendation) ||
                other.recommendation == recommendation) &&
            const DeepCollectionEquality()
                .equals(other._userAdjustments, _userAdjustments) &&
            const DeepCollectionEquality().equals(other._history, _history));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      hasError,
      errorMessage,
      recommendation,
      const DeepCollectionEquality().hash(_userAdjustments),
      const DeepCollectionEquality().hash(_history));

  /// Create a copy of AIRecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIRecommendationStateImplCopyWith<_$AIRecommendationStateImpl>
      get copyWith => __$$AIRecommendationStateImplCopyWithImpl<
          _$AIRecommendationStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AIRecommendationState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AIRecommendationState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AIRecommendationState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _AIRecommendationState implements AIRecommendationState {
  const factory _AIRecommendationState(
      {final bool isLoading,
      final bool hasError,
      final String? errorMessage,
      final AIRecommendation? recommendation,
      final Map<String, dynamic> userAdjustments,
      final List<AIRecommendation> history}) = _$AIRecommendationStateImpl;

  @override
  bool get isLoading;
  @override
  bool get hasError;
  @override
  String? get errorMessage;
  @override
  AIRecommendation? get recommendation;
  @override
  Map<String, dynamic> get userAdjustments;
  @override
  List<AIRecommendation> get history;

  /// Create a copy of AIRecommendationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIRecommendationStateImplCopyWith<_$AIRecommendationStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
