// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'value_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ValueFailure<T> {
  T get failedValue => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T failedValue) empty,
    required TResult Function(T failedValue, int max) tooLong,
    required TResult Function(T failedValue, int min) tooShort,
    required TResult Function(T failedValue, String? message) invalidFormat,
    required TResult Function(T failedValue, num max) numberTooLarge,
    required TResult Function(T failedValue, num min) numberTooSmall,
    required TResult Function(T failedValue) notANumber,
    required TResult Function(T failedValue) invalidEmail,
    required TResult Function(T failedValue) invalidPhone,
    required TResult Function(T failedValue) weakPassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T failedValue)? empty,
    TResult? Function(T failedValue, int max)? tooLong,
    TResult? Function(T failedValue, int min)? tooShort,
    TResult? Function(T failedValue, String? message)? invalidFormat,
    TResult? Function(T failedValue, num max)? numberTooLarge,
    TResult? Function(T failedValue, num min)? numberTooSmall,
    TResult? Function(T failedValue)? notANumber,
    TResult? Function(T failedValue)? invalidEmail,
    TResult? Function(T failedValue)? invalidPhone,
    TResult? Function(T failedValue)? weakPassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T failedValue)? empty,
    TResult Function(T failedValue, int max)? tooLong,
    TResult Function(T failedValue, int min)? tooShort,
    TResult Function(T failedValue, String? message)? invalidFormat,
    TResult Function(T failedValue, num max)? numberTooLarge,
    TResult Function(T failedValue, num min)? numberTooSmall,
    TResult Function(T failedValue)? notANumber,
    TResult Function(T failedValue)? invalidEmail,
    TResult Function(T failedValue)? invalidPhone,
    TResult Function(T failedValue)? weakPassword,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Empty<T> value) empty,
    required TResult Function(TooLong<T> value) tooLong,
    required TResult Function(TooShort<T> value) tooShort,
    required TResult Function(InvalidFormat<T> value) invalidFormat,
    required TResult Function(NumberTooLarge<T> value) numberTooLarge,
    required TResult Function(NumberTooSmall<T> value) numberTooSmall,
    required TResult Function(NotANumber<T> value) notANumber,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidPhone<T> value) invalidPhone,
    required TResult Function(WeakPassword<T> value) weakPassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(TooLong<T> value)? tooLong,
    TResult? Function(TooShort<T> value)? tooShort,
    TResult? Function(InvalidFormat<T> value)? invalidFormat,
    TResult? Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult? Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult? Function(NotANumber<T> value)? notANumber,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidPhone<T> value)? invalidPhone,
    TResult? Function(WeakPassword<T> value)? weakPassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Empty<T> value)? empty,
    TResult Function(TooLong<T> value)? tooLong,
    TResult Function(TooShort<T> value)? tooShort,
    TResult Function(InvalidFormat<T> value)? invalidFormat,
    TResult Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult Function(NotANumber<T> value)? notANumber,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidPhone<T> value)? invalidPhone,
    TResult Function(WeakPassword<T> value)? weakPassword,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ValueFailureCopyWith<T, ValueFailure<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValueFailureCopyWith<T, $Res> {
  factory $ValueFailureCopyWith(
          ValueFailure<T> value, $Res Function(ValueFailure<T>) then) =
      _$ValueFailureCopyWithImpl<T, $Res, ValueFailure<T>>;
  @useResult
  $Res call({T failedValue});
}

/// @nodoc
class _$ValueFailureCopyWithImpl<T, $Res, $Val extends ValueFailure<T>>
    implements $ValueFailureCopyWith<T, $Res> {
  _$ValueFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
  }) {
    return _then(_value.copyWith(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as T,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmptyImplCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$EmptyImplCopyWith(
          _$EmptyImpl<T> value, $Res Function(_$EmptyImpl<T>) then) =
      __$$EmptyImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T failedValue});
}

/// @nodoc
class __$$EmptyImplCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$EmptyImpl<T>>
    implements _$$EmptyImplCopyWith<T, $Res> {
  __$$EmptyImplCopyWithImpl(
      _$EmptyImpl<T> _value, $Res Function(_$EmptyImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
  }) {
    return _then(_$EmptyImpl<T>(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$EmptyImpl<T> implements Empty<T> {
  const _$EmptyImpl({required this.failedValue});

  @override
  final T failedValue;

  @override
  String toString() {
    return 'ValueFailure<$T>.empty(failedValue: $failedValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmptyImpl<T> &&
            const DeepCollectionEquality()
                .equals(other.failedValue, failedValue));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(failedValue));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmptyImplCopyWith<T, _$EmptyImpl<T>> get copyWith =>
      __$$EmptyImplCopyWithImpl<T, _$EmptyImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T failedValue) empty,
    required TResult Function(T failedValue, int max) tooLong,
    required TResult Function(T failedValue, int min) tooShort,
    required TResult Function(T failedValue, String? message) invalidFormat,
    required TResult Function(T failedValue, num max) numberTooLarge,
    required TResult Function(T failedValue, num min) numberTooSmall,
    required TResult Function(T failedValue) notANumber,
    required TResult Function(T failedValue) invalidEmail,
    required TResult Function(T failedValue) invalidPhone,
    required TResult Function(T failedValue) weakPassword,
  }) {
    return empty(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T failedValue)? empty,
    TResult? Function(T failedValue, int max)? tooLong,
    TResult? Function(T failedValue, int min)? tooShort,
    TResult? Function(T failedValue, String? message)? invalidFormat,
    TResult? Function(T failedValue, num max)? numberTooLarge,
    TResult? Function(T failedValue, num min)? numberTooSmall,
    TResult? Function(T failedValue)? notANumber,
    TResult? Function(T failedValue)? invalidEmail,
    TResult? Function(T failedValue)? invalidPhone,
    TResult? Function(T failedValue)? weakPassword,
  }) {
    return empty?.call(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T failedValue)? empty,
    TResult Function(T failedValue, int max)? tooLong,
    TResult Function(T failedValue, int min)? tooShort,
    TResult Function(T failedValue, String? message)? invalidFormat,
    TResult Function(T failedValue, num max)? numberTooLarge,
    TResult Function(T failedValue, num min)? numberTooSmall,
    TResult Function(T failedValue)? notANumber,
    TResult Function(T failedValue)? invalidEmail,
    TResult Function(T failedValue)? invalidPhone,
    TResult Function(T failedValue)? weakPassword,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(failedValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Empty<T> value) empty,
    required TResult Function(TooLong<T> value) tooLong,
    required TResult Function(TooShort<T> value) tooShort,
    required TResult Function(InvalidFormat<T> value) invalidFormat,
    required TResult Function(NumberTooLarge<T> value) numberTooLarge,
    required TResult Function(NumberTooSmall<T> value) numberTooSmall,
    required TResult Function(NotANumber<T> value) notANumber,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidPhone<T> value) invalidPhone,
    required TResult Function(WeakPassword<T> value) weakPassword,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(TooLong<T> value)? tooLong,
    TResult? Function(TooShort<T> value)? tooShort,
    TResult? Function(InvalidFormat<T> value)? invalidFormat,
    TResult? Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult? Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult? Function(NotANumber<T> value)? notANumber,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidPhone<T> value)? invalidPhone,
    TResult? Function(WeakPassword<T> value)? weakPassword,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Empty<T> value)? empty,
    TResult Function(TooLong<T> value)? tooLong,
    TResult Function(TooShort<T> value)? tooShort,
    TResult Function(InvalidFormat<T> value)? invalidFormat,
    TResult Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult Function(NotANumber<T> value)? notANumber,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidPhone<T> value)? invalidPhone,
    TResult Function(WeakPassword<T> value)? weakPassword,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class Empty<T> implements ValueFailure<T> {
  const factory Empty({required final T failedValue}) = _$EmptyImpl<T>;

  @override
  T get failedValue;
  @override
  @JsonKey(ignore: true)
  _$$EmptyImplCopyWith<T, _$EmptyImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TooLongImplCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$TooLongImplCopyWith(
          _$TooLongImpl<T> value, $Res Function(_$TooLongImpl<T>) then) =
      __$$TooLongImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T failedValue, int max});
}

/// @nodoc
class __$$TooLongImplCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$TooLongImpl<T>>
    implements _$$TooLongImplCopyWith<T, $Res> {
  __$$TooLongImplCopyWithImpl(
      _$TooLongImpl<T> _value, $Res Function(_$TooLongImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
    Object? max = null,
  }) {
    return _then(_$TooLongImpl<T>(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as T,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TooLongImpl<T> implements TooLong<T> {
  const _$TooLongImpl({required this.failedValue, required this.max});

  @override
  final T failedValue;
  @override
  final int max;

  @override
  String toString() {
    return 'ValueFailure<$T>.tooLong(failedValue: $failedValue, max: $max)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TooLongImpl<T> &&
            const DeepCollectionEquality()
                .equals(other.failedValue, failedValue) &&
            (identical(other.max, max) || other.max == max));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(failedValue), max);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TooLongImplCopyWith<T, _$TooLongImpl<T>> get copyWith =>
      __$$TooLongImplCopyWithImpl<T, _$TooLongImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T failedValue) empty,
    required TResult Function(T failedValue, int max) tooLong,
    required TResult Function(T failedValue, int min) tooShort,
    required TResult Function(T failedValue, String? message) invalidFormat,
    required TResult Function(T failedValue, num max) numberTooLarge,
    required TResult Function(T failedValue, num min) numberTooSmall,
    required TResult Function(T failedValue) notANumber,
    required TResult Function(T failedValue) invalidEmail,
    required TResult Function(T failedValue) invalidPhone,
    required TResult Function(T failedValue) weakPassword,
  }) {
    return tooLong(failedValue, max);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T failedValue)? empty,
    TResult? Function(T failedValue, int max)? tooLong,
    TResult? Function(T failedValue, int min)? tooShort,
    TResult? Function(T failedValue, String? message)? invalidFormat,
    TResult? Function(T failedValue, num max)? numberTooLarge,
    TResult? Function(T failedValue, num min)? numberTooSmall,
    TResult? Function(T failedValue)? notANumber,
    TResult? Function(T failedValue)? invalidEmail,
    TResult? Function(T failedValue)? invalidPhone,
    TResult? Function(T failedValue)? weakPassword,
  }) {
    return tooLong?.call(failedValue, max);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T failedValue)? empty,
    TResult Function(T failedValue, int max)? tooLong,
    TResult Function(T failedValue, int min)? tooShort,
    TResult Function(T failedValue, String? message)? invalidFormat,
    TResult Function(T failedValue, num max)? numberTooLarge,
    TResult Function(T failedValue, num min)? numberTooSmall,
    TResult Function(T failedValue)? notANumber,
    TResult Function(T failedValue)? invalidEmail,
    TResult Function(T failedValue)? invalidPhone,
    TResult Function(T failedValue)? weakPassword,
    required TResult orElse(),
  }) {
    if (tooLong != null) {
      return tooLong(failedValue, max);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Empty<T> value) empty,
    required TResult Function(TooLong<T> value) tooLong,
    required TResult Function(TooShort<T> value) tooShort,
    required TResult Function(InvalidFormat<T> value) invalidFormat,
    required TResult Function(NumberTooLarge<T> value) numberTooLarge,
    required TResult Function(NumberTooSmall<T> value) numberTooSmall,
    required TResult Function(NotANumber<T> value) notANumber,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidPhone<T> value) invalidPhone,
    required TResult Function(WeakPassword<T> value) weakPassword,
  }) {
    return tooLong(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(TooLong<T> value)? tooLong,
    TResult? Function(TooShort<T> value)? tooShort,
    TResult? Function(InvalidFormat<T> value)? invalidFormat,
    TResult? Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult? Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult? Function(NotANumber<T> value)? notANumber,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidPhone<T> value)? invalidPhone,
    TResult? Function(WeakPassword<T> value)? weakPassword,
  }) {
    return tooLong?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Empty<T> value)? empty,
    TResult Function(TooLong<T> value)? tooLong,
    TResult Function(TooShort<T> value)? tooShort,
    TResult Function(InvalidFormat<T> value)? invalidFormat,
    TResult Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult Function(NotANumber<T> value)? notANumber,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidPhone<T> value)? invalidPhone,
    TResult Function(WeakPassword<T> value)? weakPassword,
    required TResult orElse(),
  }) {
    if (tooLong != null) {
      return tooLong(this);
    }
    return orElse();
  }
}

abstract class TooLong<T> implements ValueFailure<T> {
  const factory TooLong(
      {required final T failedValue,
      required final int max}) = _$TooLongImpl<T>;

  @override
  T get failedValue;
  int get max;
  @override
  @JsonKey(ignore: true)
  _$$TooLongImplCopyWith<T, _$TooLongImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TooShortImplCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$TooShortImplCopyWith(
          _$TooShortImpl<T> value, $Res Function(_$TooShortImpl<T>) then) =
      __$$TooShortImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T failedValue, int min});
}

/// @nodoc
class __$$TooShortImplCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$TooShortImpl<T>>
    implements _$$TooShortImplCopyWith<T, $Res> {
  __$$TooShortImplCopyWithImpl(
      _$TooShortImpl<T> _value, $Res Function(_$TooShortImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
    Object? min = null,
  }) {
    return _then(_$TooShortImpl<T>(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as T,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TooShortImpl<T> implements TooShort<T> {
  const _$TooShortImpl({required this.failedValue, required this.min});

  @override
  final T failedValue;
  @override
  final int min;

  @override
  String toString() {
    return 'ValueFailure<$T>.tooShort(failedValue: $failedValue, min: $min)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TooShortImpl<T> &&
            const DeepCollectionEquality()
                .equals(other.failedValue, failedValue) &&
            (identical(other.min, min) || other.min == min));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(failedValue), min);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TooShortImplCopyWith<T, _$TooShortImpl<T>> get copyWith =>
      __$$TooShortImplCopyWithImpl<T, _$TooShortImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T failedValue) empty,
    required TResult Function(T failedValue, int max) tooLong,
    required TResult Function(T failedValue, int min) tooShort,
    required TResult Function(T failedValue, String? message) invalidFormat,
    required TResult Function(T failedValue, num max) numberTooLarge,
    required TResult Function(T failedValue, num min) numberTooSmall,
    required TResult Function(T failedValue) notANumber,
    required TResult Function(T failedValue) invalidEmail,
    required TResult Function(T failedValue) invalidPhone,
    required TResult Function(T failedValue) weakPassword,
  }) {
    return tooShort(failedValue, min);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T failedValue)? empty,
    TResult? Function(T failedValue, int max)? tooLong,
    TResult? Function(T failedValue, int min)? tooShort,
    TResult? Function(T failedValue, String? message)? invalidFormat,
    TResult? Function(T failedValue, num max)? numberTooLarge,
    TResult? Function(T failedValue, num min)? numberTooSmall,
    TResult? Function(T failedValue)? notANumber,
    TResult? Function(T failedValue)? invalidEmail,
    TResult? Function(T failedValue)? invalidPhone,
    TResult? Function(T failedValue)? weakPassword,
  }) {
    return tooShort?.call(failedValue, min);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T failedValue)? empty,
    TResult Function(T failedValue, int max)? tooLong,
    TResult Function(T failedValue, int min)? tooShort,
    TResult Function(T failedValue, String? message)? invalidFormat,
    TResult Function(T failedValue, num max)? numberTooLarge,
    TResult Function(T failedValue, num min)? numberTooSmall,
    TResult Function(T failedValue)? notANumber,
    TResult Function(T failedValue)? invalidEmail,
    TResult Function(T failedValue)? invalidPhone,
    TResult Function(T failedValue)? weakPassword,
    required TResult orElse(),
  }) {
    if (tooShort != null) {
      return tooShort(failedValue, min);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Empty<T> value) empty,
    required TResult Function(TooLong<T> value) tooLong,
    required TResult Function(TooShort<T> value) tooShort,
    required TResult Function(InvalidFormat<T> value) invalidFormat,
    required TResult Function(NumberTooLarge<T> value) numberTooLarge,
    required TResult Function(NumberTooSmall<T> value) numberTooSmall,
    required TResult Function(NotANumber<T> value) notANumber,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidPhone<T> value) invalidPhone,
    required TResult Function(WeakPassword<T> value) weakPassword,
  }) {
    return tooShort(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(TooLong<T> value)? tooLong,
    TResult? Function(TooShort<T> value)? tooShort,
    TResult? Function(InvalidFormat<T> value)? invalidFormat,
    TResult? Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult? Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult? Function(NotANumber<T> value)? notANumber,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidPhone<T> value)? invalidPhone,
    TResult? Function(WeakPassword<T> value)? weakPassword,
  }) {
    return tooShort?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Empty<T> value)? empty,
    TResult Function(TooLong<T> value)? tooLong,
    TResult Function(TooShort<T> value)? tooShort,
    TResult Function(InvalidFormat<T> value)? invalidFormat,
    TResult Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult Function(NotANumber<T> value)? notANumber,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidPhone<T> value)? invalidPhone,
    TResult Function(WeakPassword<T> value)? weakPassword,
    required TResult orElse(),
  }) {
    if (tooShort != null) {
      return tooShort(this);
    }
    return orElse();
  }
}

abstract class TooShort<T> implements ValueFailure<T> {
  const factory TooShort(
      {required final T failedValue,
      required final int min}) = _$TooShortImpl<T>;

  @override
  T get failedValue;
  int get min;
  @override
  @JsonKey(ignore: true)
  _$$TooShortImplCopyWith<T, _$TooShortImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidFormatImplCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$InvalidFormatImplCopyWith(_$InvalidFormatImpl<T> value,
          $Res Function(_$InvalidFormatImpl<T>) then) =
      __$$InvalidFormatImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T failedValue, String? message});
}

/// @nodoc
class __$$InvalidFormatImplCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$InvalidFormatImpl<T>>
    implements _$$InvalidFormatImplCopyWith<T, $Res> {
  __$$InvalidFormatImplCopyWithImpl(_$InvalidFormatImpl<T> _value,
      $Res Function(_$InvalidFormatImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
    Object? message = freezed,
  }) {
    return _then(_$InvalidFormatImpl<T>(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as T,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$InvalidFormatImpl<T> implements InvalidFormat<T> {
  const _$InvalidFormatImpl({required this.failedValue, this.message});

  @override
  final T failedValue;
  @override
  final String? message;

  @override
  String toString() {
    return 'ValueFailure<$T>.invalidFormat(failedValue: $failedValue, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidFormatImpl<T> &&
            const DeepCollectionEquality()
                .equals(other.failedValue, failedValue) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(failedValue), message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidFormatImplCopyWith<T, _$InvalidFormatImpl<T>> get copyWith =>
      __$$InvalidFormatImplCopyWithImpl<T, _$InvalidFormatImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T failedValue) empty,
    required TResult Function(T failedValue, int max) tooLong,
    required TResult Function(T failedValue, int min) tooShort,
    required TResult Function(T failedValue, String? message) invalidFormat,
    required TResult Function(T failedValue, num max) numberTooLarge,
    required TResult Function(T failedValue, num min) numberTooSmall,
    required TResult Function(T failedValue) notANumber,
    required TResult Function(T failedValue) invalidEmail,
    required TResult Function(T failedValue) invalidPhone,
    required TResult Function(T failedValue) weakPassword,
  }) {
    return invalidFormat(failedValue, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T failedValue)? empty,
    TResult? Function(T failedValue, int max)? tooLong,
    TResult? Function(T failedValue, int min)? tooShort,
    TResult? Function(T failedValue, String? message)? invalidFormat,
    TResult? Function(T failedValue, num max)? numberTooLarge,
    TResult? Function(T failedValue, num min)? numberTooSmall,
    TResult? Function(T failedValue)? notANumber,
    TResult? Function(T failedValue)? invalidEmail,
    TResult? Function(T failedValue)? invalidPhone,
    TResult? Function(T failedValue)? weakPassword,
  }) {
    return invalidFormat?.call(failedValue, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T failedValue)? empty,
    TResult Function(T failedValue, int max)? tooLong,
    TResult Function(T failedValue, int min)? tooShort,
    TResult Function(T failedValue, String? message)? invalidFormat,
    TResult Function(T failedValue, num max)? numberTooLarge,
    TResult Function(T failedValue, num min)? numberTooSmall,
    TResult Function(T failedValue)? notANumber,
    TResult Function(T failedValue)? invalidEmail,
    TResult Function(T failedValue)? invalidPhone,
    TResult Function(T failedValue)? weakPassword,
    required TResult orElse(),
  }) {
    if (invalidFormat != null) {
      return invalidFormat(failedValue, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Empty<T> value) empty,
    required TResult Function(TooLong<T> value) tooLong,
    required TResult Function(TooShort<T> value) tooShort,
    required TResult Function(InvalidFormat<T> value) invalidFormat,
    required TResult Function(NumberTooLarge<T> value) numberTooLarge,
    required TResult Function(NumberTooSmall<T> value) numberTooSmall,
    required TResult Function(NotANumber<T> value) notANumber,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidPhone<T> value) invalidPhone,
    required TResult Function(WeakPassword<T> value) weakPassword,
  }) {
    return invalidFormat(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(TooLong<T> value)? tooLong,
    TResult? Function(TooShort<T> value)? tooShort,
    TResult? Function(InvalidFormat<T> value)? invalidFormat,
    TResult? Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult? Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult? Function(NotANumber<T> value)? notANumber,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidPhone<T> value)? invalidPhone,
    TResult? Function(WeakPassword<T> value)? weakPassword,
  }) {
    return invalidFormat?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Empty<T> value)? empty,
    TResult Function(TooLong<T> value)? tooLong,
    TResult Function(TooShort<T> value)? tooShort,
    TResult Function(InvalidFormat<T> value)? invalidFormat,
    TResult Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult Function(NotANumber<T> value)? notANumber,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidPhone<T> value)? invalidPhone,
    TResult Function(WeakPassword<T> value)? weakPassword,
    required TResult orElse(),
  }) {
    if (invalidFormat != null) {
      return invalidFormat(this);
    }
    return orElse();
  }
}

abstract class InvalidFormat<T> implements ValueFailure<T> {
  const factory InvalidFormat(
      {required final T failedValue,
      final String? message}) = _$InvalidFormatImpl<T>;

  @override
  T get failedValue;
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$InvalidFormatImplCopyWith<T, _$InvalidFormatImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NumberTooLargeImplCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$NumberTooLargeImplCopyWith(_$NumberTooLargeImpl<T> value,
          $Res Function(_$NumberTooLargeImpl<T>) then) =
      __$$NumberTooLargeImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T failedValue, num max});
}

/// @nodoc
class __$$NumberTooLargeImplCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$NumberTooLargeImpl<T>>
    implements _$$NumberTooLargeImplCopyWith<T, $Res> {
  __$$NumberTooLargeImplCopyWithImpl(_$NumberTooLargeImpl<T> _value,
      $Res Function(_$NumberTooLargeImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
    Object? max = null,
  }) {
    return _then(_$NumberTooLargeImpl<T>(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as T,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc

class _$NumberTooLargeImpl<T> implements NumberTooLarge<T> {
  const _$NumberTooLargeImpl({required this.failedValue, required this.max});

  @override
  final T failedValue;
  @override
  final num max;

  @override
  String toString() {
    return 'ValueFailure<$T>.numberTooLarge(failedValue: $failedValue, max: $max)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NumberTooLargeImpl<T> &&
            const DeepCollectionEquality()
                .equals(other.failedValue, failedValue) &&
            (identical(other.max, max) || other.max == max));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(failedValue), max);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NumberTooLargeImplCopyWith<T, _$NumberTooLargeImpl<T>> get copyWith =>
      __$$NumberTooLargeImplCopyWithImpl<T, _$NumberTooLargeImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T failedValue) empty,
    required TResult Function(T failedValue, int max) tooLong,
    required TResult Function(T failedValue, int min) tooShort,
    required TResult Function(T failedValue, String? message) invalidFormat,
    required TResult Function(T failedValue, num max) numberTooLarge,
    required TResult Function(T failedValue, num min) numberTooSmall,
    required TResult Function(T failedValue) notANumber,
    required TResult Function(T failedValue) invalidEmail,
    required TResult Function(T failedValue) invalidPhone,
    required TResult Function(T failedValue) weakPassword,
  }) {
    return numberTooLarge(failedValue, max);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T failedValue)? empty,
    TResult? Function(T failedValue, int max)? tooLong,
    TResult? Function(T failedValue, int min)? tooShort,
    TResult? Function(T failedValue, String? message)? invalidFormat,
    TResult? Function(T failedValue, num max)? numberTooLarge,
    TResult? Function(T failedValue, num min)? numberTooSmall,
    TResult? Function(T failedValue)? notANumber,
    TResult? Function(T failedValue)? invalidEmail,
    TResult? Function(T failedValue)? invalidPhone,
    TResult? Function(T failedValue)? weakPassword,
  }) {
    return numberTooLarge?.call(failedValue, max);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T failedValue)? empty,
    TResult Function(T failedValue, int max)? tooLong,
    TResult Function(T failedValue, int min)? tooShort,
    TResult Function(T failedValue, String? message)? invalidFormat,
    TResult Function(T failedValue, num max)? numberTooLarge,
    TResult Function(T failedValue, num min)? numberTooSmall,
    TResult Function(T failedValue)? notANumber,
    TResult Function(T failedValue)? invalidEmail,
    TResult Function(T failedValue)? invalidPhone,
    TResult Function(T failedValue)? weakPassword,
    required TResult orElse(),
  }) {
    if (numberTooLarge != null) {
      return numberTooLarge(failedValue, max);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Empty<T> value) empty,
    required TResult Function(TooLong<T> value) tooLong,
    required TResult Function(TooShort<T> value) tooShort,
    required TResult Function(InvalidFormat<T> value) invalidFormat,
    required TResult Function(NumberTooLarge<T> value) numberTooLarge,
    required TResult Function(NumberTooSmall<T> value) numberTooSmall,
    required TResult Function(NotANumber<T> value) notANumber,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidPhone<T> value) invalidPhone,
    required TResult Function(WeakPassword<T> value) weakPassword,
  }) {
    return numberTooLarge(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(TooLong<T> value)? tooLong,
    TResult? Function(TooShort<T> value)? tooShort,
    TResult? Function(InvalidFormat<T> value)? invalidFormat,
    TResult? Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult? Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult? Function(NotANumber<T> value)? notANumber,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidPhone<T> value)? invalidPhone,
    TResult? Function(WeakPassword<T> value)? weakPassword,
  }) {
    return numberTooLarge?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Empty<T> value)? empty,
    TResult Function(TooLong<T> value)? tooLong,
    TResult Function(TooShort<T> value)? tooShort,
    TResult Function(InvalidFormat<T> value)? invalidFormat,
    TResult Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult Function(NotANumber<T> value)? notANumber,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidPhone<T> value)? invalidPhone,
    TResult Function(WeakPassword<T> value)? weakPassword,
    required TResult orElse(),
  }) {
    if (numberTooLarge != null) {
      return numberTooLarge(this);
    }
    return orElse();
  }
}

abstract class NumberTooLarge<T> implements ValueFailure<T> {
  const factory NumberTooLarge(
      {required final T failedValue,
      required final num max}) = _$NumberTooLargeImpl<T>;

  @override
  T get failedValue;
  num get max;
  @override
  @JsonKey(ignore: true)
  _$$NumberTooLargeImplCopyWith<T, _$NumberTooLargeImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NumberTooSmallImplCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$NumberTooSmallImplCopyWith(_$NumberTooSmallImpl<T> value,
          $Res Function(_$NumberTooSmallImpl<T>) then) =
      __$$NumberTooSmallImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T failedValue, num min});
}

/// @nodoc
class __$$NumberTooSmallImplCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$NumberTooSmallImpl<T>>
    implements _$$NumberTooSmallImplCopyWith<T, $Res> {
  __$$NumberTooSmallImplCopyWithImpl(_$NumberTooSmallImpl<T> _value,
      $Res Function(_$NumberTooSmallImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
    Object? min = null,
  }) {
    return _then(_$NumberTooSmallImpl<T>(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as T,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc

class _$NumberTooSmallImpl<T> implements NumberTooSmall<T> {
  const _$NumberTooSmallImpl({required this.failedValue, required this.min});

  @override
  final T failedValue;
  @override
  final num min;

  @override
  String toString() {
    return 'ValueFailure<$T>.numberTooSmall(failedValue: $failedValue, min: $min)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NumberTooSmallImpl<T> &&
            const DeepCollectionEquality()
                .equals(other.failedValue, failedValue) &&
            (identical(other.min, min) || other.min == min));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(failedValue), min);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NumberTooSmallImplCopyWith<T, _$NumberTooSmallImpl<T>> get copyWith =>
      __$$NumberTooSmallImplCopyWithImpl<T, _$NumberTooSmallImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T failedValue) empty,
    required TResult Function(T failedValue, int max) tooLong,
    required TResult Function(T failedValue, int min) tooShort,
    required TResult Function(T failedValue, String? message) invalidFormat,
    required TResult Function(T failedValue, num max) numberTooLarge,
    required TResult Function(T failedValue, num min) numberTooSmall,
    required TResult Function(T failedValue) notANumber,
    required TResult Function(T failedValue) invalidEmail,
    required TResult Function(T failedValue) invalidPhone,
    required TResult Function(T failedValue) weakPassword,
  }) {
    return numberTooSmall(failedValue, min);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T failedValue)? empty,
    TResult? Function(T failedValue, int max)? tooLong,
    TResult? Function(T failedValue, int min)? tooShort,
    TResult? Function(T failedValue, String? message)? invalidFormat,
    TResult? Function(T failedValue, num max)? numberTooLarge,
    TResult? Function(T failedValue, num min)? numberTooSmall,
    TResult? Function(T failedValue)? notANumber,
    TResult? Function(T failedValue)? invalidEmail,
    TResult? Function(T failedValue)? invalidPhone,
    TResult? Function(T failedValue)? weakPassword,
  }) {
    return numberTooSmall?.call(failedValue, min);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T failedValue)? empty,
    TResult Function(T failedValue, int max)? tooLong,
    TResult Function(T failedValue, int min)? tooShort,
    TResult Function(T failedValue, String? message)? invalidFormat,
    TResult Function(T failedValue, num max)? numberTooLarge,
    TResult Function(T failedValue, num min)? numberTooSmall,
    TResult Function(T failedValue)? notANumber,
    TResult Function(T failedValue)? invalidEmail,
    TResult Function(T failedValue)? invalidPhone,
    TResult Function(T failedValue)? weakPassword,
    required TResult orElse(),
  }) {
    if (numberTooSmall != null) {
      return numberTooSmall(failedValue, min);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Empty<T> value) empty,
    required TResult Function(TooLong<T> value) tooLong,
    required TResult Function(TooShort<T> value) tooShort,
    required TResult Function(InvalidFormat<T> value) invalidFormat,
    required TResult Function(NumberTooLarge<T> value) numberTooLarge,
    required TResult Function(NumberTooSmall<T> value) numberTooSmall,
    required TResult Function(NotANumber<T> value) notANumber,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidPhone<T> value) invalidPhone,
    required TResult Function(WeakPassword<T> value) weakPassword,
  }) {
    return numberTooSmall(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(TooLong<T> value)? tooLong,
    TResult? Function(TooShort<T> value)? tooShort,
    TResult? Function(InvalidFormat<T> value)? invalidFormat,
    TResult? Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult? Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult? Function(NotANumber<T> value)? notANumber,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidPhone<T> value)? invalidPhone,
    TResult? Function(WeakPassword<T> value)? weakPassword,
  }) {
    return numberTooSmall?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Empty<T> value)? empty,
    TResult Function(TooLong<T> value)? tooLong,
    TResult Function(TooShort<T> value)? tooShort,
    TResult Function(InvalidFormat<T> value)? invalidFormat,
    TResult Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult Function(NotANumber<T> value)? notANumber,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidPhone<T> value)? invalidPhone,
    TResult Function(WeakPassword<T> value)? weakPassword,
    required TResult orElse(),
  }) {
    if (numberTooSmall != null) {
      return numberTooSmall(this);
    }
    return orElse();
  }
}

abstract class NumberTooSmall<T> implements ValueFailure<T> {
  const factory NumberTooSmall(
      {required final T failedValue,
      required final num min}) = _$NumberTooSmallImpl<T>;

  @override
  T get failedValue;
  num get min;
  @override
  @JsonKey(ignore: true)
  _$$NumberTooSmallImplCopyWith<T, _$NumberTooSmallImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotANumberImplCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$NotANumberImplCopyWith(
          _$NotANumberImpl<T> value, $Res Function(_$NotANumberImpl<T>) then) =
      __$$NotANumberImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T failedValue});
}

/// @nodoc
class __$$NotANumberImplCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$NotANumberImpl<T>>
    implements _$$NotANumberImplCopyWith<T, $Res> {
  __$$NotANumberImplCopyWithImpl(
      _$NotANumberImpl<T> _value, $Res Function(_$NotANumberImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
  }) {
    return _then(_$NotANumberImpl<T>(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$NotANumberImpl<T> implements NotANumber<T> {
  const _$NotANumberImpl({required this.failedValue});

  @override
  final T failedValue;

  @override
  String toString() {
    return 'ValueFailure<$T>.notANumber(failedValue: $failedValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotANumberImpl<T> &&
            const DeepCollectionEquality()
                .equals(other.failedValue, failedValue));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(failedValue));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotANumberImplCopyWith<T, _$NotANumberImpl<T>> get copyWith =>
      __$$NotANumberImplCopyWithImpl<T, _$NotANumberImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T failedValue) empty,
    required TResult Function(T failedValue, int max) tooLong,
    required TResult Function(T failedValue, int min) tooShort,
    required TResult Function(T failedValue, String? message) invalidFormat,
    required TResult Function(T failedValue, num max) numberTooLarge,
    required TResult Function(T failedValue, num min) numberTooSmall,
    required TResult Function(T failedValue) notANumber,
    required TResult Function(T failedValue) invalidEmail,
    required TResult Function(T failedValue) invalidPhone,
    required TResult Function(T failedValue) weakPassword,
  }) {
    return notANumber(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T failedValue)? empty,
    TResult? Function(T failedValue, int max)? tooLong,
    TResult? Function(T failedValue, int min)? tooShort,
    TResult? Function(T failedValue, String? message)? invalidFormat,
    TResult? Function(T failedValue, num max)? numberTooLarge,
    TResult? Function(T failedValue, num min)? numberTooSmall,
    TResult? Function(T failedValue)? notANumber,
    TResult? Function(T failedValue)? invalidEmail,
    TResult? Function(T failedValue)? invalidPhone,
    TResult? Function(T failedValue)? weakPassword,
  }) {
    return notANumber?.call(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T failedValue)? empty,
    TResult Function(T failedValue, int max)? tooLong,
    TResult Function(T failedValue, int min)? tooShort,
    TResult Function(T failedValue, String? message)? invalidFormat,
    TResult Function(T failedValue, num max)? numberTooLarge,
    TResult Function(T failedValue, num min)? numberTooSmall,
    TResult Function(T failedValue)? notANumber,
    TResult Function(T failedValue)? invalidEmail,
    TResult Function(T failedValue)? invalidPhone,
    TResult Function(T failedValue)? weakPassword,
    required TResult orElse(),
  }) {
    if (notANumber != null) {
      return notANumber(failedValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Empty<T> value) empty,
    required TResult Function(TooLong<T> value) tooLong,
    required TResult Function(TooShort<T> value) tooShort,
    required TResult Function(InvalidFormat<T> value) invalidFormat,
    required TResult Function(NumberTooLarge<T> value) numberTooLarge,
    required TResult Function(NumberTooSmall<T> value) numberTooSmall,
    required TResult Function(NotANumber<T> value) notANumber,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidPhone<T> value) invalidPhone,
    required TResult Function(WeakPassword<T> value) weakPassword,
  }) {
    return notANumber(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(TooLong<T> value)? tooLong,
    TResult? Function(TooShort<T> value)? tooShort,
    TResult? Function(InvalidFormat<T> value)? invalidFormat,
    TResult? Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult? Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult? Function(NotANumber<T> value)? notANumber,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidPhone<T> value)? invalidPhone,
    TResult? Function(WeakPassword<T> value)? weakPassword,
  }) {
    return notANumber?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Empty<T> value)? empty,
    TResult Function(TooLong<T> value)? tooLong,
    TResult Function(TooShort<T> value)? tooShort,
    TResult Function(InvalidFormat<T> value)? invalidFormat,
    TResult Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult Function(NotANumber<T> value)? notANumber,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidPhone<T> value)? invalidPhone,
    TResult Function(WeakPassword<T> value)? weakPassword,
    required TResult orElse(),
  }) {
    if (notANumber != null) {
      return notANumber(this);
    }
    return orElse();
  }
}

abstract class NotANumber<T> implements ValueFailure<T> {
  const factory NotANumber({required final T failedValue}) =
      _$NotANumberImpl<T>;

  @override
  T get failedValue;
  @override
  @JsonKey(ignore: true)
  _$$NotANumberImplCopyWith<T, _$NotANumberImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidEmailImplCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$InvalidEmailImplCopyWith(_$InvalidEmailImpl<T> value,
          $Res Function(_$InvalidEmailImpl<T>) then) =
      __$$InvalidEmailImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T failedValue});
}

/// @nodoc
class __$$InvalidEmailImplCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$InvalidEmailImpl<T>>
    implements _$$InvalidEmailImplCopyWith<T, $Res> {
  __$$InvalidEmailImplCopyWithImpl(
      _$InvalidEmailImpl<T> _value, $Res Function(_$InvalidEmailImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
  }) {
    return _then(_$InvalidEmailImpl<T>(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$InvalidEmailImpl<T> implements InvalidEmail<T> {
  const _$InvalidEmailImpl({required this.failedValue});

  @override
  final T failedValue;

  @override
  String toString() {
    return 'ValueFailure<$T>.invalidEmail(failedValue: $failedValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidEmailImpl<T> &&
            const DeepCollectionEquality()
                .equals(other.failedValue, failedValue));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(failedValue));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidEmailImplCopyWith<T, _$InvalidEmailImpl<T>> get copyWith =>
      __$$InvalidEmailImplCopyWithImpl<T, _$InvalidEmailImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T failedValue) empty,
    required TResult Function(T failedValue, int max) tooLong,
    required TResult Function(T failedValue, int min) tooShort,
    required TResult Function(T failedValue, String? message) invalidFormat,
    required TResult Function(T failedValue, num max) numberTooLarge,
    required TResult Function(T failedValue, num min) numberTooSmall,
    required TResult Function(T failedValue) notANumber,
    required TResult Function(T failedValue) invalidEmail,
    required TResult Function(T failedValue) invalidPhone,
    required TResult Function(T failedValue) weakPassword,
  }) {
    return invalidEmail(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T failedValue)? empty,
    TResult? Function(T failedValue, int max)? tooLong,
    TResult? Function(T failedValue, int min)? tooShort,
    TResult? Function(T failedValue, String? message)? invalidFormat,
    TResult? Function(T failedValue, num max)? numberTooLarge,
    TResult? Function(T failedValue, num min)? numberTooSmall,
    TResult? Function(T failedValue)? notANumber,
    TResult? Function(T failedValue)? invalidEmail,
    TResult? Function(T failedValue)? invalidPhone,
    TResult? Function(T failedValue)? weakPassword,
  }) {
    return invalidEmail?.call(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T failedValue)? empty,
    TResult Function(T failedValue, int max)? tooLong,
    TResult Function(T failedValue, int min)? tooShort,
    TResult Function(T failedValue, String? message)? invalidFormat,
    TResult Function(T failedValue, num max)? numberTooLarge,
    TResult Function(T failedValue, num min)? numberTooSmall,
    TResult Function(T failedValue)? notANumber,
    TResult Function(T failedValue)? invalidEmail,
    TResult Function(T failedValue)? invalidPhone,
    TResult Function(T failedValue)? weakPassword,
    required TResult orElse(),
  }) {
    if (invalidEmail != null) {
      return invalidEmail(failedValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Empty<T> value) empty,
    required TResult Function(TooLong<T> value) tooLong,
    required TResult Function(TooShort<T> value) tooShort,
    required TResult Function(InvalidFormat<T> value) invalidFormat,
    required TResult Function(NumberTooLarge<T> value) numberTooLarge,
    required TResult Function(NumberTooSmall<T> value) numberTooSmall,
    required TResult Function(NotANumber<T> value) notANumber,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidPhone<T> value) invalidPhone,
    required TResult Function(WeakPassword<T> value) weakPassword,
  }) {
    return invalidEmail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(TooLong<T> value)? tooLong,
    TResult? Function(TooShort<T> value)? tooShort,
    TResult? Function(InvalidFormat<T> value)? invalidFormat,
    TResult? Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult? Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult? Function(NotANumber<T> value)? notANumber,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidPhone<T> value)? invalidPhone,
    TResult? Function(WeakPassword<T> value)? weakPassword,
  }) {
    return invalidEmail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Empty<T> value)? empty,
    TResult Function(TooLong<T> value)? tooLong,
    TResult Function(TooShort<T> value)? tooShort,
    TResult Function(InvalidFormat<T> value)? invalidFormat,
    TResult Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult Function(NotANumber<T> value)? notANumber,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidPhone<T> value)? invalidPhone,
    TResult Function(WeakPassword<T> value)? weakPassword,
    required TResult orElse(),
  }) {
    if (invalidEmail != null) {
      return invalidEmail(this);
    }
    return orElse();
  }
}

abstract class InvalidEmail<T> implements ValueFailure<T> {
  const factory InvalidEmail({required final T failedValue}) =
      _$InvalidEmailImpl<T>;

  @override
  T get failedValue;
  @override
  @JsonKey(ignore: true)
  _$$InvalidEmailImplCopyWith<T, _$InvalidEmailImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidPhoneImplCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$InvalidPhoneImplCopyWith(_$InvalidPhoneImpl<T> value,
          $Res Function(_$InvalidPhoneImpl<T>) then) =
      __$$InvalidPhoneImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T failedValue});
}

/// @nodoc
class __$$InvalidPhoneImplCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$InvalidPhoneImpl<T>>
    implements _$$InvalidPhoneImplCopyWith<T, $Res> {
  __$$InvalidPhoneImplCopyWithImpl(
      _$InvalidPhoneImpl<T> _value, $Res Function(_$InvalidPhoneImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
  }) {
    return _then(_$InvalidPhoneImpl<T>(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$InvalidPhoneImpl<T> implements InvalidPhone<T> {
  const _$InvalidPhoneImpl({required this.failedValue});

  @override
  final T failedValue;

  @override
  String toString() {
    return 'ValueFailure<$T>.invalidPhone(failedValue: $failedValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidPhoneImpl<T> &&
            const DeepCollectionEquality()
                .equals(other.failedValue, failedValue));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(failedValue));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidPhoneImplCopyWith<T, _$InvalidPhoneImpl<T>> get copyWith =>
      __$$InvalidPhoneImplCopyWithImpl<T, _$InvalidPhoneImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T failedValue) empty,
    required TResult Function(T failedValue, int max) tooLong,
    required TResult Function(T failedValue, int min) tooShort,
    required TResult Function(T failedValue, String? message) invalidFormat,
    required TResult Function(T failedValue, num max) numberTooLarge,
    required TResult Function(T failedValue, num min) numberTooSmall,
    required TResult Function(T failedValue) notANumber,
    required TResult Function(T failedValue) invalidEmail,
    required TResult Function(T failedValue) invalidPhone,
    required TResult Function(T failedValue) weakPassword,
  }) {
    return invalidPhone(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T failedValue)? empty,
    TResult? Function(T failedValue, int max)? tooLong,
    TResult? Function(T failedValue, int min)? tooShort,
    TResult? Function(T failedValue, String? message)? invalidFormat,
    TResult? Function(T failedValue, num max)? numberTooLarge,
    TResult? Function(T failedValue, num min)? numberTooSmall,
    TResult? Function(T failedValue)? notANumber,
    TResult? Function(T failedValue)? invalidEmail,
    TResult? Function(T failedValue)? invalidPhone,
    TResult? Function(T failedValue)? weakPassword,
  }) {
    return invalidPhone?.call(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T failedValue)? empty,
    TResult Function(T failedValue, int max)? tooLong,
    TResult Function(T failedValue, int min)? tooShort,
    TResult Function(T failedValue, String? message)? invalidFormat,
    TResult Function(T failedValue, num max)? numberTooLarge,
    TResult Function(T failedValue, num min)? numberTooSmall,
    TResult Function(T failedValue)? notANumber,
    TResult Function(T failedValue)? invalidEmail,
    TResult Function(T failedValue)? invalidPhone,
    TResult Function(T failedValue)? weakPassword,
    required TResult orElse(),
  }) {
    if (invalidPhone != null) {
      return invalidPhone(failedValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Empty<T> value) empty,
    required TResult Function(TooLong<T> value) tooLong,
    required TResult Function(TooShort<T> value) tooShort,
    required TResult Function(InvalidFormat<T> value) invalidFormat,
    required TResult Function(NumberTooLarge<T> value) numberTooLarge,
    required TResult Function(NumberTooSmall<T> value) numberTooSmall,
    required TResult Function(NotANumber<T> value) notANumber,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidPhone<T> value) invalidPhone,
    required TResult Function(WeakPassword<T> value) weakPassword,
  }) {
    return invalidPhone(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(TooLong<T> value)? tooLong,
    TResult? Function(TooShort<T> value)? tooShort,
    TResult? Function(InvalidFormat<T> value)? invalidFormat,
    TResult? Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult? Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult? Function(NotANumber<T> value)? notANumber,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidPhone<T> value)? invalidPhone,
    TResult? Function(WeakPassword<T> value)? weakPassword,
  }) {
    return invalidPhone?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Empty<T> value)? empty,
    TResult Function(TooLong<T> value)? tooLong,
    TResult Function(TooShort<T> value)? tooShort,
    TResult Function(InvalidFormat<T> value)? invalidFormat,
    TResult Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult Function(NotANumber<T> value)? notANumber,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidPhone<T> value)? invalidPhone,
    TResult Function(WeakPassword<T> value)? weakPassword,
    required TResult orElse(),
  }) {
    if (invalidPhone != null) {
      return invalidPhone(this);
    }
    return orElse();
  }
}

abstract class InvalidPhone<T> implements ValueFailure<T> {
  const factory InvalidPhone({required final T failedValue}) =
      _$InvalidPhoneImpl<T>;

  @override
  T get failedValue;
  @override
  @JsonKey(ignore: true)
  _$$InvalidPhoneImplCopyWith<T, _$InvalidPhoneImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WeakPasswordImplCopyWith<T, $Res>
    implements $ValueFailureCopyWith<T, $Res> {
  factory _$$WeakPasswordImplCopyWith(_$WeakPasswordImpl<T> value,
          $Res Function(_$WeakPasswordImpl<T>) then) =
      __$$WeakPasswordImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T failedValue});
}

/// @nodoc
class __$$WeakPasswordImplCopyWithImpl<T, $Res>
    extends _$ValueFailureCopyWithImpl<T, $Res, _$WeakPasswordImpl<T>>
    implements _$$WeakPasswordImplCopyWith<T, $Res> {
  __$$WeakPasswordImplCopyWithImpl(
      _$WeakPasswordImpl<T> _value, $Res Function(_$WeakPasswordImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
  }) {
    return _then(_$WeakPasswordImpl<T>(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$WeakPasswordImpl<T> implements WeakPassword<T> {
  const _$WeakPasswordImpl({required this.failedValue});

  @override
  final T failedValue;

  @override
  String toString() {
    return 'ValueFailure<$T>.weakPassword(failedValue: $failedValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeakPasswordImpl<T> &&
            const DeepCollectionEquality()
                .equals(other.failedValue, failedValue));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(failedValue));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeakPasswordImplCopyWith<T, _$WeakPasswordImpl<T>> get copyWith =>
      __$$WeakPasswordImplCopyWithImpl<T, _$WeakPasswordImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T failedValue) empty,
    required TResult Function(T failedValue, int max) tooLong,
    required TResult Function(T failedValue, int min) tooShort,
    required TResult Function(T failedValue, String? message) invalidFormat,
    required TResult Function(T failedValue, num max) numberTooLarge,
    required TResult Function(T failedValue, num min) numberTooSmall,
    required TResult Function(T failedValue) notANumber,
    required TResult Function(T failedValue) invalidEmail,
    required TResult Function(T failedValue) invalidPhone,
    required TResult Function(T failedValue) weakPassword,
  }) {
    return weakPassword(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T failedValue)? empty,
    TResult? Function(T failedValue, int max)? tooLong,
    TResult? Function(T failedValue, int min)? tooShort,
    TResult? Function(T failedValue, String? message)? invalidFormat,
    TResult? Function(T failedValue, num max)? numberTooLarge,
    TResult? Function(T failedValue, num min)? numberTooSmall,
    TResult? Function(T failedValue)? notANumber,
    TResult? Function(T failedValue)? invalidEmail,
    TResult? Function(T failedValue)? invalidPhone,
    TResult? Function(T failedValue)? weakPassword,
  }) {
    return weakPassword?.call(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T failedValue)? empty,
    TResult Function(T failedValue, int max)? tooLong,
    TResult Function(T failedValue, int min)? tooShort,
    TResult Function(T failedValue, String? message)? invalidFormat,
    TResult Function(T failedValue, num max)? numberTooLarge,
    TResult Function(T failedValue, num min)? numberTooSmall,
    TResult Function(T failedValue)? notANumber,
    TResult Function(T failedValue)? invalidEmail,
    TResult Function(T failedValue)? invalidPhone,
    TResult Function(T failedValue)? weakPassword,
    required TResult orElse(),
  }) {
    if (weakPassword != null) {
      return weakPassword(failedValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Empty<T> value) empty,
    required TResult Function(TooLong<T> value) tooLong,
    required TResult Function(TooShort<T> value) tooShort,
    required TResult Function(InvalidFormat<T> value) invalidFormat,
    required TResult Function(NumberTooLarge<T> value) numberTooLarge,
    required TResult Function(NumberTooSmall<T> value) numberTooSmall,
    required TResult Function(NotANumber<T> value) notANumber,
    required TResult Function(InvalidEmail<T> value) invalidEmail,
    required TResult Function(InvalidPhone<T> value) invalidPhone,
    required TResult Function(WeakPassword<T> value) weakPassword,
  }) {
    return weakPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Empty<T> value)? empty,
    TResult? Function(TooLong<T> value)? tooLong,
    TResult? Function(TooShort<T> value)? tooShort,
    TResult? Function(InvalidFormat<T> value)? invalidFormat,
    TResult? Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult? Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult? Function(NotANumber<T> value)? notANumber,
    TResult? Function(InvalidEmail<T> value)? invalidEmail,
    TResult? Function(InvalidPhone<T> value)? invalidPhone,
    TResult? Function(WeakPassword<T> value)? weakPassword,
  }) {
    return weakPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Empty<T> value)? empty,
    TResult Function(TooLong<T> value)? tooLong,
    TResult Function(TooShort<T> value)? tooShort,
    TResult Function(InvalidFormat<T> value)? invalidFormat,
    TResult Function(NumberTooLarge<T> value)? numberTooLarge,
    TResult Function(NumberTooSmall<T> value)? numberTooSmall,
    TResult Function(NotANumber<T> value)? notANumber,
    TResult Function(InvalidEmail<T> value)? invalidEmail,
    TResult Function(InvalidPhone<T> value)? invalidPhone,
    TResult Function(WeakPassword<T> value)? weakPassword,
    required TResult orElse(),
  }) {
    if (weakPassword != null) {
      return weakPassword(this);
    }
    return orElse();
  }
}

abstract class WeakPassword<T> implements ValueFailure<T> {
  const factory WeakPassword({required final T failedValue}) =
      _$WeakPasswordImpl<T>;

  @override
  T get failedValue;
  @override
  @JsonKey(ignore: true)
  _$$WeakPasswordImplCopyWith<T, _$WeakPasswordImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
