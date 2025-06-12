// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthFailure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidCredentials,
    required TResult Function() userNotFound,
    required TResult Function() emailAlreadyExists,
    required TResult Function() weakPassword,
    required TResult Function() networkError,
    required TResult Function() serverError,
    required TResult Function() unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidCredentials,
    TResult? Function()? userNotFound,
    TResult? Function()? emailAlreadyExists,
    TResult? Function()? weakPassword,
    TResult? Function()? networkError,
    TResult? Function()? serverError,
    TResult? Function()? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidCredentials,
    TResult Function()? userNotFound,
    TResult Function()? emailAlreadyExists,
    TResult Function()? weakPassword,
    TResult Function()? networkError,
    TResult Function()? serverError,
    TResult Function()? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InvalidCredentials value) invalidCredentials,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_EmailAlreadyExists value) emailAlreadyExists,
    required TResult Function(_WeakPassword value) weakPassword,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_Unknown value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InvalidCredentials value)? invalidCredentials,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult? Function(_WeakPassword value)? weakPassword,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_Unknown value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InvalidCredentials value)? invalidCredentials,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult Function(_WeakPassword value)? weakPassword,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_Unknown value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthFailureCopyWith<$Res> {
  factory $AuthFailureCopyWith(
          AuthFailure value, $Res Function(AuthFailure) then) =
      _$AuthFailureCopyWithImpl<$Res, AuthFailure>;
}

/// @nodoc
class _$AuthFailureCopyWithImpl<$Res, $Val extends AuthFailure>
    implements $AuthFailureCopyWith<$Res> {
  _$AuthFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InvalidCredentialsImplCopyWith<$Res> {
  factory _$$InvalidCredentialsImplCopyWith(_$InvalidCredentialsImpl value,
          $Res Function(_$InvalidCredentialsImpl) then) =
      __$$InvalidCredentialsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InvalidCredentialsImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$InvalidCredentialsImpl>
    implements _$$InvalidCredentialsImplCopyWith<$Res> {
  __$$InvalidCredentialsImplCopyWithImpl(_$InvalidCredentialsImpl _value,
      $Res Function(_$InvalidCredentialsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InvalidCredentialsImpl implements _InvalidCredentials {
  const _$InvalidCredentialsImpl();

  @override
  String toString() {
    return 'AuthFailure.invalidCredentials()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InvalidCredentialsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidCredentials,
    required TResult Function() userNotFound,
    required TResult Function() emailAlreadyExists,
    required TResult Function() weakPassword,
    required TResult Function() networkError,
    required TResult Function() serverError,
    required TResult Function() unknown,
  }) {
    return invalidCredentials();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidCredentials,
    TResult? Function()? userNotFound,
    TResult? Function()? emailAlreadyExists,
    TResult? Function()? weakPassword,
    TResult? Function()? networkError,
    TResult? Function()? serverError,
    TResult? Function()? unknown,
  }) {
    return invalidCredentials?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidCredentials,
    TResult Function()? userNotFound,
    TResult Function()? emailAlreadyExists,
    TResult Function()? weakPassword,
    TResult Function()? networkError,
    TResult Function()? serverError,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (invalidCredentials != null) {
      return invalidCredentials();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InvalidCredentials value) invalidCredentials,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_EmailAlreadyExists value) emailAlreadyExists,
    required TResult Function(_WeakPassword value) weakPassword,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_Unknown value) unknown,
  }) {
    return invalidCredentials(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InvalidCredentials value)? invalidCredentials,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult? Function(_WeakPassword value)? weakPassword,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_Unknown value)? unknown,
  }) {
    return invalidCredentials?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InvalidCredentials value)? invalidCredentials,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult Function(_WeakPassword value)? weakPassword,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (invalidCredentials != null) {
      return invalidCredentials(this);
    }
    return orElse();
  }
}

abstract class _InvalidCredentials implements AuthFailure {
  const factory _InvalidCredentials() = _$InvalidCredentialsImpl;
}

/// @nodoc
abstract class _$$UserNotFoundImplCopyWith<$Res> {
  factory _$$UserNotFoundImplCopyWith(
          _$UserNotFoundImpl value, $Res Function(_$UserNotFoundImpl) then) =
      __$$UserNotFoundImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserNotFoundImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$UserNotFoundImpl>
    implements _$$UserNotFoundImplCopyWith<$Res> {
  __$$UserNotFoundImplCopyWithImpl(
      _$UserNotFoundImpl _value, $Res Function(_$UserNotFoundImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UserNotFoundImpl implements _UserNotFound {
  const _$UserNotFoundImpl();

  @override
  String toString() {
    return 'AuthFailure.userNotFound()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UserNotFoundImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidCredentials,
    required TResult Function() userNotFound,
    required TResult Function() emailAlreadyExists,
    required TResult Function() weakPassword,
    required TResult Function() networkError,
    required TResult Function() serverError,
    required TResult Function() unknown,
  }) {
    return userNotFound();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidCredentials,
    TResult? Function()? userNotFound,
    TResult? Function()? emailAlreadyExists,
    TResult? Function()? weakPassword,
    TResult? Function()? networkError,
    TResult? Function()? serverError,
    TResult? Function()? unknown,
  }) {
    return userNotFound?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidCredentials,
    TResult Function()? userNotFound,
    TResult Function()? emailAlreadyExists,
    TResult Function()? weakPassword,
    TResult Function()? networkError,
    TResult Function()? serverError,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (userNotFound != null) {
      return userNotFound();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InvalidCredentials value) invalidCredentials,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_EmailAlreadyExists value) emailAlreadyExists,
    required TResult Function(_WeakPassword value) weakPassword,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_Unknown value) unknown,
  }) {
    return userNotFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InvalidCredentials value)? invalidCredentials,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult? Function(_WeakPassword value)? weakPassword,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_Unknown value)? unknown,
  }) {
    return userNotFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InvalidCredentials value)? invalidCredentials,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult Function(_WeakPassword value)? weakPassword,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (userNotFound != null) {
      return userNotFound(this);
    }
    return orElse();
  }
}

abstract class _UserNotFound implements AuthFailure {
  const factory _UserNotFound() = _$UserNotFoundImpl;
}

/// @nodoc
abstract class _$$EmailAlreadyExistsImplCopyWith<$Res> {
  factory _$$EmailAlreadyExistsImplCopyWith(_$EmailAlreadyExistsImpl value,
          $Res Function(_$EmailAlreadyExistsImpl) then) =
      __$$EmailAlreadyExistsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$EmailAlreadyExistsImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$EmailAlreadyExistsImpl>
    implements _$$EmailAlreadyExistsImplCopyWith<$Res> {
  __$$EmailAlreadyExistsImplCopyWithImpl(_$EmailAlreadyExistsImpl _value,
      $Res Function(_$EmailAlreadyExistsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$EmailAlreadyExistsImpl implements _EmailAlreadyExists {
  const _$EmailAlreadyExistsImpl();

  @override
  String toString() {
    return 'AuthFailure.emailAlreadyExists()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$EmailAlreadyExistsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidCredentials,
    required TResult Function() userNotFound,
    required TResult Function() emailAlreadyExists,
    required TResult Function() weakPassword,
    required TResult Function() networkError,
    required TResult Function() serverError,
    required TResult Function() unknown,
  }) {
    return emailAlreadyExists();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidCredentials,
    TResult? Function()? userNotFound,
    TResult? Function()? emailAlreadyExists,
    TResult? Function()? weakPassword,
    TResult? Function()? networkError,
    TResult? Function()? serverError,
    TResult? Function()? unknown,
  }) {
    return emailAlreadyExists?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidCredentials,
    TResult Function()? userNotFound,
    TResult Function()? emailAlreadyExists,
    TResult Function()? weakPassword,
    TResult Function()? networkError,
    TResult Function()? serverError,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (emailAlreadyExists != null) {
      return emailAlreadyExists();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InvalidCredentials value) invalidCredentials,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_EmailAlreadyExists value) emailAlreadyExists,
    required TResult Function(_WeakPassword value) weakPassword,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_Unknown value) unknown,
  }) {
    return emailAlreadyExists(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InvalidCredentials value)? invalidCredentials,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult? Function(_WeakPassword value)? weakPassword,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_Unknown value)? unknown,
  }) {
    return emailAlreadyExists?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InvalidCredentials value)? invalidCredentials,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult Function(_WeakPassword value)? weakPassword,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (emailAlreadyExists != null) {
      return emailAlreadyExists(this);
    }
    return orElse();
  }
}

abstract class _EmailAlreadyExists implements AuthFailure {
  const factory _EmailAlreadyExists() = _$EmailAlreadyExistsImpl;
}

/// @nodoc
abstract class _$$WeakPasswordImplCopyWith<$Res> {
  factory _$$WeakPasswordImplCopyWith(
          _$WeakPasswordImpl value, $Res Function(_$WeakPasswordImpl) then) =
      __$$WeakPasswordImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$WeakPasswordImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$WeakPasswordImpl>
    implements _$$WeakPasswordImplCopyWith<$Res> {
  __$$WeakPasswordImplCopyWithImpl(
      _$WeakPasswordImpl _value, $Res Function(_$WeakPasswordImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$WeakPasswordImpl implements _WeakPassword {
  const _$WeakPasswordImpl();

  @override
  String toString() {
    return 'AuthFailure.weakPassword()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$WeakPasswordImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidCredentials,
    required TResult Function() userNotFound,
    required TResult Function() emailAlreadyExists,
    required TResult Function() weakPassword,
    required TResult Function() networkError,
    required TResult Function() serverError,
    required TResult Function() unknown,
  }) {
    return weakPassword();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidCredentials,
    TResult? Function()? userNotFound,
    TResult? Function()? emailAlreadyExists,
    TResult? Function()? weakPassword,
    TResult? Function()? networkError,
    TResult? Function()? serverError,
    TResult? Function()? unknown,
  }) {
    return weakPassword?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidCredentials,
    TResult Function()? userNotFound,
    TResult Function()? emailAlreadyExists,
    TResult Function()? weakPassword,
    TResult Function()? networkError,
    TResult Function()? serverError,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (weakPassword != null) {
      return weakPassword();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InvalidCredentials value) invalidCredentials,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_EmailAlreadyExists value) emailAlreadyExists,
    required TResult Function(_WeakPassword value) weakPassword,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_Unknown value) unknown,
  }) {
    return weakPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InvalidCredentials value)? invalidCredentials,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult? Function(_WeakPassword value)? weakPassword,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_Unknown value)? unknown,
  }) {
    return weakPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InvalidCredentials value)? invalidCredentials,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult Function(_WeakPassword value)? weakPassword,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (weakPassword != null) {
      return weakPassword(this);
    }
    return orElse();
  }
}

abstract class _WeakPassword implements AuthFailure {
  const factory _WeakPassword() = _$WeakPasswordImpl;
}

/// @nodoc
abstract class _$$NetworkErrorImplCopyWith<$Res> {
  factory _$$NetworkErrorImplCopyWith(
          _$NetworkErrorImpl value, $Res Function(_$NetworkErrorImpl) then) =
      __$$NetworkErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NetworkErrorImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$NetworkErrorImpl>
    implements _$$NetworkErrorImplCopyWith<$Res> {
  __$$NetworkErrorImplCopyWithImpl(
      _$NetworkErrorImpl _value, $Res Function(_$NetworkErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NetworkErrorImpl implements _NetworkError {
  const _$NetworkErrorImpl();

  @override
  String toString() {
    return 'AuthFailure.networkError()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NetworkErrorImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidCredentials,
    required TResult Function() userNotFound,
    required TResult Function() emailAlreadyExists,
    required TResult Function() weakPassword,
    required TResult Function() networkError,
    required TResult Function() serverError,
    required TResult Function() unknown,
  }) {
    return networkError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidCredentials,
    TResult? Function()? userNotFound,
    TResult? Function()? emailAlreadyExists,
    TResult? Function()? weakPassword,
    TResult? Function()? networkError,
    TResult? Function()? serverError,
    TResult? Function()? unknown,
  }) {
    return networkError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidCredentials,
    TResult Function()? userNotFound,
    TResult Function()? emailAlreadyExists,
    TResult Function()? weakPassword,
    TResult Function()? networkError,
    TResult Function()? serverError,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (networkError != null) {
      return networkError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InvalidCredentials value) invalidCredentials,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_EmailAlreadyExists value) emailAlreadyExists,
    required TResult Function(_WeakPassword value) weakPassword,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_Unknown value) unknown,
  }) {
    return networkError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InvalidCredentials value)? invalidCredentials,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult? Function(_WeakPassword value)? weakPassword,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_Unknown value)? unknown,
  }) {
    return networkError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InvalidCredentials value)? invalidCredentials,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult Function(_WeakPassword value)? weakPassword,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (networkError != null) {
      return networkError(this);
    }
    return orElse();
  }
}

abstract class _NetworkError implements AuthFailure {
  const factory _NetworkError() = _$NetworkErrorImpl;
}

/// @nodoc
abstract class _$$ServerErrorImplCopyWith<$Res> {
  factory _$$ServerErrorImplCopyWith(
          _$ServerErrorImpl value, $Res Function(_$ServerErrorImpl) then) =
      __$$ServerErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ServerErrorImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$ServerErrorImpl>
    implements _$$ServerErrorImplCopyWith<$Res> {
  __$$ServerErrorImplCopyWithImpl(
      _$ServerErrorImpl _value, $Res Function(_$ServerErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ServerErrorImpl implements _ServerError {
  const _$ServerErrorImpl();

  @override
  String toString() {
    return 'AuthFailure.serverError()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ServerErrorImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidCredentials,
    required TResult Function() userNotFound,
    required TResult Function() emailAlreadyExists,
    required TResult Function() weakPassword,
    required TResult Function() networkError,
    required TResult Function() serverError,
    required TResult Function() unknown,
  }) {
    return serverError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidCredentials,
    TResult? Function()? userNotFound,
    TResult? Function()? emailAlreadyExists,
    TResult? Function()? weakPassword,
    TResult? Function()? networkError,
    TResult? Function()? serverError,
    TResult? Function()? unknown,
  }) {
    return serverError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidCredentials,
    TResult Function()? userNotFound,
    TResult Function()? emailAlreadyExists,
    TResult Function()? weakPassword,
    TResult Function()? networkError,
    TResult Function()? serverError,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InvalidCredentials value) invalidCredentials,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_EmailAlreadyExists value) emailAlreadyExists,
    required TResult Function(_WeakPassword value) weakPassword,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_Unknown value) unknown,
  }) {
    return serverError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InvalidCredentials value)? invalidCredentials,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult? Function(_WeakPassword value)? weakPassword,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_Unknown value)? unknown,
  }) {
    return serverError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InvalidCredentials value)? invalidCredentials,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult Function(_WeakPassword value)? weakPassword,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(this);
    }
    return orElse();
  }
}

abstract class _ServerError implements AuthFailure {
  const factory _ServerError() = _$ServerErrorImpl;
}

/// @nodoc
abstract class _$$UnknownImplCopyWith<$Res> {
  factory _$$UnknownImplCopyWith(
          _$UnknownImpl value, $Res Function(_$UnknownImpl) then) =
      __$$UnknownImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnknownImplCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res, _$UnknownImpl>
    implements _$$UnknownImplCopyWith<$Res> {
  __$$UnknownImplCopyWithImpl(
      _$UnknownImpl _value, $Res Function(_$UnknownImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UnknownImpl implements _Unknown {
  const _$UnknownImpl();

  @override
  String toString() {
    return 'AuthFailure.unknown()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UnknownImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() invalidCredentials,
    required TResult Function() userNotFound,
    required TResult Function() emailAlreadyExists,
    required TResult Function() weakPassword,
    required TResult Function() networkError,
    required TResult Function() serverError,
    required TResult Function() unknown,
  }) {
    return unknown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? invalidCredentials,
    TResult? Function()? userNotFound,
    TResult? Function()? emailAlreadyExists,
    TResult? Function()? weakPassword,
    TResult? Function()? networkError,
    TResult? Function()? serverError,
    TResult? Function()? unknown,
  }) {
    return unknown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? invalidCredentials,
    TResult Function()? userNotFound,
    TResult Function()? emailAlreadyExists,
    TResult Function()? weakPassword,
    TResult Function()? networkError,
    TResult Function()? serverError,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InvalidCredentials value) invalidCredentials,
    required TResult Function(_UserNotFound value) userNotFound,
    required TResult Function(_EmailAlreadyExists value) emailAlreadyExists,
    required TResult Function(_WeakPassword value) weakPassword,
    required TResult Function(_NetworkError value) networkError,
    required TResult Function(_ServerError value) serverError,
    required TResult Function(_Unknown value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InvalidCredentials value)? invalidCredentials,
    TResult? Function(_UserNotFound value)? userNotFound,
    TResult? Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult? Function(_WeakPassword value)? weakPassword,
    TResult? Function(_NetworkError value)? networkError,
    TResult? Function(_ServerError value)? serverError,
    TResult? Function(_Unknown value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InvalidCredentials value)? invalidCredentials,
    TResult Function(_UserNotFound value)? userNotFound,
    TResult Function(_EmailAlreadyExists value)? emailAlreadyExists,
    TResult Function(_WeakPassword value)? weakPassword,
    TResult Function(_NetworkError value)? networkError,
    TResult Function(_ServerError value)? serverError,
    TResult Function(_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class _Unknown implements AuthFailure {
  const factory _Unknown() = _$UnknownImpl;
}
