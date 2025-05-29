// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthState {
  bool get isAuthenticated => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  UserModel? get user => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool get isVerifyingCode => throw _privateConstructorUsedError;
  bool get isCheckingAuth => throw _privateConstructorUsedError;
  DateTime? get tokenExpiry => throw _privateConstructorUsedError;
  Map<String, dynamic> get userPermissions =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AuthState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AuthState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AuthState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  @useResult
  $Res call(
      {bool isAuthenticated,
      bool isLoading,
      UserModel? user,
      String? token,
      String? error,
      bool isVerifyingCode,
      bool isCheckingAuth,
      DateTime? tokenExpiry,
      Map<String, dynamic> userPermissions});
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAuthenticated = null,
    Object? isLoading = null,
    Object? user = freezed,
    Object? token = freezed,
    Object? error = freezed,
    Object? isVerifyingCode = null,
    Object? isCheckingAuth = null,
    Object? tokenExpiry = freezed,
    Object? userPermissions = null,
  }) {
    return _then(_value.copyWith(
      isAuthenticated: null == isAuthenticated
          ? _value.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerifyingCode: null == isVerifyingCode
          ? _value.isVerifyingCode
          : isVerifyingCode // ignore: cast_nullable_to_non_nullable
              as bool,
      isCheckingAuth: null == isCheckingAuth
          ? _value.isCheckingAuth
          : isCheckingAuth // ignore: cast_nullable_to_non_nullable
              as bool,
      tokenExpiry: freezed == tokenExpiry
          ? _value.tokenExpiry
          : tokenExpiry // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userPermissions: null == userPermissions
          ? _value.userPermissions
          : userPermissions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthStateImplCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthStateImplCopyWith(
          _$AuthStateImpl value, $Res Function(_$AuthStateImpl) then) =
      __$$AuthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isAuthenticated,
      bool isLoading,
      UserModel? user,
      String? token,
      String? error,
      bool isVerifyingCode,
      bool isCheckingAuth,
      DateTime? tokenExpiry,
      Map<String, dynamic> userPermissions});
}

/// @nodoc
class __$$AuthStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateImpl>
    implements _$$AuthStateImplCopyWith<$Res> {
  __$$AuthStateImplCopyWithImpl(
      _$AuthStateImpl _value, $Res Function(_$AuthStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAuthenticated = null,
    Object? isLoading = null,
    Object? user = freezed,
    Object? token = freezed,
    Object? error = freezed,
    Object? isVerifyingCode = null,
    Object? isCheckingAuth = null,
    Object? tokenExpiry = freezed,
    Object? userPermissions = null,
  }) {
    return _then(_$AuthStateImpl(
      isAuthenticated: null == isAuthenticated
          ? _value.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerifyingCode: null == isVerifyingCode
          ? _value.isVerifyingCode
          : isVerifyingCode // ignore: cast_nullable_to_non_nullable
              as bool,
      isCheckingAuth: null == isCheckingAuth
          ? _value.isCheckingAuth
          : isCheckingAuth // ignore: cast_nullable_to_non_nullable
              as bool,
      tokenExpiry: freezed == tokenExpiry
          ? _value.tokenExpiry
          : tokenExpiry // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userPermissions: null == userPermissions
          ? _value._userPermissions
          : userPermissions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$AuthStateImpl extends _AuthState {
  const _$AuthStateImpl(
      {this.isAuthenticated = false,
      this.isLoading = false,
      this.user,
      this.token,
      this.error,
      this.isVerifyingCode = false,
      this.isCheckingAuth = false,
      this.tokenExpiry,
      final Map<String, dynamic> userPermissions = const {}})
      : _userPermissions = userPermissions,
        super._();

  @override
  @JsonKey()
  final bool isAuthenticated;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final UserModel? user;
  @override
  final String? token;
  @override
  final String? error;
  @override
  @JsonKey()
  final bool isVerifyingCode;
  @override
  @JsonKey()
  final bool isCheckingAuth;
  @override
  final DateTime? tokenExpiry;
  final Map<String, dynamic> _userPermissions;
  @override
  @JsonKey()
  Map<String, dynamic> get userPermissions {
    if (_userPermissions is EqualUnmodifiableMapView) return _userPermissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_userPermissions);
  }

  @override
  String toString() {
    return 'AuthState(isAuthenticated: $isAuthenticated, isLoading: $isLoading, user: $user, token: $token, error: $error, isVerifyingCode: $isVerifyingCode, isCheckingAuth: $isCheckingAuth, tokenExpiry: $tokenExpiry, userPermissions: $userPermissions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateImpl &&
            (identical(other.isAuthenticated, isAuthenticated) ||
                other.isAuthenticated == isAuthenticated) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other.user, user) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isVerifyingCode, isVerifyingCode) ||
                other.isVerifyingCode == isVerifyingCode) &&
            (identical(other.isCheckingAuth, isCheckingAuth) ||
                other.isCheckingAuth == isCheckingAuth) &&
            (identical(other.tokenExpiry, tokenExpiry) ||
                other.tokenExpiry == tokenExpiry) &&
            const DeepCollectionEquality()
                .equals(other._userPermissions, _userPermissions));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isAuthenticated,
      isLoading,
      const DeepCollectionEquality().hash(user),
      token,
      error,
      isVerifyingCode,
      isCheckingAuth,
      tokenExpiry,
      const DeepCollectionEquality().hash(_userPermissions));

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      __$$AuthStateImplCopyWithImpl<_$AuthStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AuthState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AuthState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AuthState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _AuthState extends AuthState {
  const factory _AuthState(
      {final bool isAuthenticated,
      final bool isLoading,
      final UserModel? user,
      final String? token,
      final String? error,
      final bool isVerifyingCode,
      final bool isCheckingAuth,
      final DateTime? tokenExpiry,
      final Map<String, dynamic> userPermissions}) = _$AuthStateImpl;
  const _AuthState._() : super._();

  @override
  bool get isAuthenticated;
  @override
  bool get isLoading;
  @override
  UserModel? get user;
  @override
  String? get token;
  @override
  String? get error;
  @override
  bool get isVerifyingCode;
  @override
  bool get isCheckingAuth;
  @override
  DateTime? get tokenExpiry;
  @override
  Map<String, dynamic> get userPermissions;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
