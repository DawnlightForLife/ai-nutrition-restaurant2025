// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consultation_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ConsultationState {
  List<Uconsultation> get consultations => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ConsultationState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ConsultationState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ConsultationState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of ConsultationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConsultationStateCopyWith<ConsultationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConsultationStateCopyWith<$Res> {
  factory $ConsultationStateCopyWith(
          ConsultationState value, $Res Function(ConsultationState) then) =
      _$ConsultationStateCopyWithImpl<$Res, ConsultationState>;
  @useResult
  $Res call(
      {List<Uconsultation> consultations,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$ConsultationStateCopyWithImpl<$Res, $Val extends ConsultationState>
    implements $ConsultationStateCopyWith<$Res> {
  _$ConsultationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConsultationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consultations = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      consultations: null == consultations
          ? _value.consultations
          : consultations // ignore: cast_nullable_to_non_nullable
              as List<Uconsultation>,
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
abstract class _$$ConsultationStateImplCopyWith<$Res>
    implements $ConsultationStateCopyWith<$Res> {
  factory _$$ConsultationStateImplCopyWith(_$ConsultationStateImpl value,
          $Res Function(_$ConsultationStateImpl) then) =
      __$$ConsultationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Uconsultation> consultations,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$$ConsultationStateImplCopyWithImpl<$Res>
    extends _$ConsultationStateCopyWithImpl<$Res, _$ConsultationStateImpl>
    implements _$$ConsultationStateImplCopyWith<$Res> {
  __$$ConsultationStateImplCopyWithImpl(_$ConsultationStateImpl _value,
      $Res Function(_$ConsultationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConsultationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consultations = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$ConsultationStateImpl(
      consultations: null == consultations
          ? _value._consultations
          : consultations // ignore: cast_nullable_to_non_nullable
              as List<Uconsultation>,
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

class _$ConsultationStateImpl implements _ConsultationState {
  const _$ConsultationStateImpl(
      {final List<Uconsultation> consultations = const [],
      this.isLoading = false,
      this.errorMessage})
      : _consultations = consultations;

  final List<Uconsultation> _consultations;
  @override
  @JsonKey()
  List<Uconsultation> get consultations {
    if (_consultations is EqualUnmodifiableListView) return _consultations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_consultations);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ConsultationState(consultations: $consultations, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConsultationStateImpl &&
            const DeepCollectionEquality()
                .equals(other._consultations, _consultations) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_consultations),
      isLoading,
      errorMessage);

  /// Create a copy of ConsultationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConsultationStateImplCopyWith<_$ConsultationStateImpl> get copyWith =>
      __$$ConsultationStateImplCopyWithImpl<_$ConsultationStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ConsultationState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ConsultationState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ConsultationState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _ConsultationState implements ConsultationState {
  const factory _ConsultationState(
      {final List<Uconsultation> consultations,
      final bool isLoading,
      final String? errorMessage}) = _$ConsultationStateImpl;

  @override
  List<Uconsultation> get consultations;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of ConsultationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConsultationStateImplCopyWith<_$ConsultationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
