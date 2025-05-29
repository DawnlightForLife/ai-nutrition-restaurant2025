// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get nickname => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  List<UserRole> get roles => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError; // 角色相关信息
  String? get merchantId => throw _privateConstructorUsedError; // 商家ID（如果是商家）
  String? get storeId => throw _privateConstructorUsedError; // 店铺ID（如果是店员）
  String? get nutritionistId =>
      throw _privateConstructorUsedError; // 营养师ID（如果是营养师）
// 认证状态
  bool get isMerchantVerified => throw _privateConstructorUsedError;
  bool get isNutritionistVerified => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UserProfile value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UserProfile value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UserProfile value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String id,
      String phone,
      String? email,
      String? nickname,
      String? avatar,
      List<UserRole> roles,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? merchantId,
      String? storeId,
      String? nutritionistId,
      bool isMerchantVerified,
      bool isNutritionistVerified});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? email = freezed,
    Object? nickname = freezed,
    Object? avatar = freezed,
    Object? roles = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? merchantId = freezed,
    Object? storeId = freezed,
    Object? nutritionistId = freezed,
    Object? isMerchantVerified = null,
    Object? isNutritionistVerified = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<UserRole>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      merchantId: freezed == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionistId: freezed == nutritionistId
          ? _value.nutritionistId
          : nutritionistId // ignore: cast_nullable_to_non_nullable
              as String?,
      isMerchantVerified: null == isMerchantVerified
          ? _value.isMerchantVerified
          : isMerchantVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isNutritionistVerified: null == isNutritionistVerified
          ? _value.isNutritionistVerified
          : isNutritionistVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String phone,
      String? email,
      String? nickname,
      String? avatar,
      List<UserRole> roles,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? merchantId,
      String? storeId,
      String? nutritionistId,
      bool isMerchantVerified,
      bool isNutritionistVerified});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? email = freezed,
    Object? nickname = freezed,
    Object? avatar = freezed,
    Object? roles = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? merchantId = freezed,
    Object? storeId = freezed,
    Object? nutritionistId = freezed,
    Object? isMerchantVerified = null,
    Object? isNutritionistVerified = null,
  }) {
    return _then(_$UserProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<UserRole>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      merchantId: freezed == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionistId: freezed == nutritionistId
          ? _value.nutritionistId
          : nutritionistId // ignore: cast_nullable_to_non_nullable
              as String?,
      isMerchantVerified: null == isMerchantVerified
          ? _value.isMerchantVerified
          : isMerchantVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isNutritionistVerified: null == isNutritionistVerified
          ? _value.isNutritionistVerified
          : isNutritionistVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$UserProfileImpl extends _UserProfile {
  const _$UserProfileImpl(
      {required this.id,
      required this.phone,
      this.email,
      this.nickname,
      this.avatar,
      final List<UserRole> roles = const [UserRole.user],
      this.createdAt,
      this.updatedAt,
      this.merchantId,
      this.storeId,
      this.nutritionistId,
      this.isMerchantVerified = false,
      this.isNutritionistVerified = false})
      : _roles = roles,
        super._();

  @override
  final String id;
  @override
  final String phone;
  @override
  final String? email;
  @override
  final String? nickname;
  @override
  final String? avatar;
  final List<UserRole> _roles;
  @override
  @JsonKey()
  List<UserRole> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// 角色相关信息
  @override
  final String? merchantId;
// 商家ID（如果是商家）
  @override
  final String? storeId;
// 店铺ID（如果是店员）
  @override
  final String? nutritionistId;
// 营养师ID（如果是营养师）
// 认证状态
  @override
  @JsonKey()
  final bool isMerchantVerified;
  @override
  @JsonKey()
  final bool isNutritionistVerified;

  @override
  String toString() {
    return 'UserProfile(id: $id, phone: $phone, email: $email, nickname: $nickname, avatar: $avatar, roles: $roles, createdAt: $createdAt, updatedAt: $updatedAt, merchantId: $merchantId, storeId: $storeId, nutritionistId: $nutritionistId, isMerchantVerified: $isMerchantVerified, isNutritionistVerified: $isNutritionistVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.nutritionistId, nutritionistId) ||
                other.nutritionistId == nutritionistId) &&
            (identical(other.isMerchantVerified, isMerchantVerified) ||
                other.isMerchantVerified == isMerchantVerified) &&
            (identical(other.isNutritionistVerified, isNutritionistVerified) ||
                other.isNutritionistVerified == isNutritionistVerified));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      phone,
      email,
      nickname,
      avatar,
      const DeepCollectionEquality().hash(_roles),
      createdAt,
      updatedAt,
      merchantId,
      storeId,
      nutritionistId,
      isMerchantVerified,
      isNutritionistVerified);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UserProfile value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UserProfile value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UserProfile value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _UserProfile extends UserProfile {
  const factory _UserProfile(
      {required final String id,
      required final String phone,
      final String? email,
      final String? nickname,
      final String? avatar,
      final List<UserRole> roles,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? merchantId,
      final String? storeId,
      final String? nutritionistId,
      final bool isMerchantVerified,
      final bool isNutritionistVerified}) = _$UserProfileImpl;
  const _UserProfile._() : super._();

  @override
  String get id;
  @override
  String get phone;
  @override
  String? get email;
  @override
  String? get nickname;
  @override
  String? get avatar;
  @override
  List<UserRole> get roles;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // 角色相关信息
  @override
  String? get merchantId; // 商家ID（如果是商家）
  @override
  String? get storeId; // 店铺ID（如果是店员）
  @override
  String? get nutritionistId; // 营养师ID（如果是营养师）
// 认证状态
  @override
  bool get isMerchantVerified;
  @override
  bool get isNutritionistVerified;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RoleEntry {
  UserRole get role => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  IconData get icon => throw _privateConstructorUsedError;
  String get route => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RoleEntry value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RoleEntry value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RoleEntry value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of RoleEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoleEntryCopyWith<RoleEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleEntryCopyWith<$Res> {
  factory $RoleEntryCopyWith(RoleEntry value, $Res Function(RoleEntry) then) =
      _$RoleEntryCopyWithImpl<$Res, RoleEntry>;
  @useResult
  $Res call({UserRole role, String title, IconData icon, String route});
}

/// @nodoc
class _$RoleEntryCopyWithImpl<$Res, $Val extends RoleEntry>
    implements $RoleEntryCopyWith<$Res> {
  _$RoleEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoleEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = null,
    Object? title = null,
    Object? icon = null,
    Object? route = null,
  }) {
    return _then(_value.copyWith(
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData,
      route: null == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoleEntryImplCopyWith<$Res>
    implements $RoleEntryCopyWith<$Res> {
  factory _$$RoleEntryImplCopyWith(
          _$RoleEntryImpl value, $Res Function(_$RoleEntryImpl) then) =
      __$$RoleEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserRole role, String title, IconData icon, String route});
}

/// @nodoc
class __$$RoleEntryImplCopyWithImpl<$Res>
    extends _$RoleEntryCopyWithImpl<$Res, _$RoleEntryImpl>
    implements _$$RoleEntryImplCopyWith<$Res> {
  __$$RoleEntryImplCopyWithImpl(
      _$RoleEntryImpl _value, $Res Function(_$RoleEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoleEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = null,
    Object? title = null,
    Object? icon = null,
    Object? route = null,
  }) {
    return _then(_$RoleEntryImpl(
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData,
      route: null == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$RoleEntryImpl implements _RoleEntry {
  const _$RoleEntryImpl(
      {required this.role,
      required this.title,
      required this.icon,
      required this.route});

  @override
  final UserRole role;
  @override
  final String title;
  @override
  final IconData icon;
  @override
  final String route;

  @override
  String toString() {
    return 'RoleEntry(role: $role, title: $title, icon: $icon, route: $route)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleEntryImpl &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.route, route) || other.route == route));
  }

  @override
  int get hashCode => Object.hash(runtimeType, role, title, icon, route);

  /// Create a copy of RoleEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleEntryImplCopyWith<_$RoleEntryImpl> get copyWith =>
      __$$RoleEntryImplCopyWithImpl<_$RoleEntryImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RoleEntry value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RoleEntry value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RoleEntry value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _RoleEntry implements RoleEntry {
  const factory _RoleEntry(
      {required final UserRole role,
      required final String title,
      required final IconData icon,
      required final String route}) = _$RoleEntryImpl;

  @override
  UserRole get role;
  @override
  String get title;
  @override
  IconData get icon;
  @override
  String get route;

  /// Create a copy of RoleEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoleEntryImplCopyWith<_$RoleEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
