// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchant_inventory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MerchantInfo _$MerchantInfoFromJson(Map<String, dynamic> json) {
  return _MerchantInfo.fromJson(json);
}

/// @nodoc
mixin _$MerchantInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get chineseName => throw _privateConstructorUsedError;
  String get businessLicense => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // pending, approved, rejected, suspended
  List<String> get supportedCuisineTypes => throw _privateConstructorUsedError;
  List<String> get certifications => throw _privateConstructorUsedError;
  List<String> get specialties => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError; // 营养管理资质
  bool get hasNutritionCertification => throw _privateConstructorUsedError;
  String? get nutritionistId => throw _privateConstructorUsedError;
  List<String> get nutritionSpecializations =>
      throw _privateConstructorUsedError; // 业务数据
  double get averageRating => throw _privateConstructorUsedError;
  int get totalOrders => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError; // 营养菜单设置
  bool get allowNutritionOrdering => throw _privateConstructorUsedError;
  List<String> get supportedNutritionElements =>
      throw _privateConstructorUsedError;
  Map<String, double> get ingredientPricingMultipliers =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MerchantInfo value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MerchantInfo value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MerchantInfo value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MerchantInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MerchantInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MerchantInfoCopyWith<MerchantInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MerchantInfoCopyWith<$Res> {
  factory $MerchantInfoCopyWith(
          MerchantInfo value, $Res Function(MerchantInfo) then) =
      _$MerchantInfoCopyWithImpl<$Res, MerchantInfo>;
  @useResult
  $Res call(
      {String id,
      String name,
      String chineseName,
      String businessLicense,
      String address,
      String phone,
      String email,
      String status,
      List<String> supportedCuisineTypes,
      List<String> certifications,
      List<String> specialties,
      DateTime createdAt,
      DateTime? updatedAt,
      bool hasNutritionCertification,
      String? nutritionistId,
      List<String> nutritionSpecializations,
      double averageRating,
      int totalOrders,
      int totalReviews,
      bool allowNutritionOrdering,
      List<String> supportedNutritionElements,
      Map<String, double> ingredientPricingMultipliers});
}

/// @nodoc
class _$MerchantInfoCopyWithImpl<$Res, $Val extends MerchantInfo>
    implements $MerchantInfoCopyWith<$Res> {
  _$MerchantInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MerchantInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? chineseName = null,
    Object? businessLicense = null,
    Object? address = null,
    Object? phone = null,
    Object? email = null,
    Object? status = null,
    Object? supportedCuisineTypes = null,
    Object? certifications = null,
    Object? specialties = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? hasNutritionCertification = null,
    Object? nutritionistId = freezed,
    Object? nutritionSpecializations = null,
    Object? averageRating = null,
    Object? totalOrders = null,
    Object? totalReviews = null,
    Object? allowNutritionOrdering = null,
    Object? supportedNutritionElements = null,
    Object? ingredientPricingMultipliers = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      chineseName: null == chineseName
          ? _value.chineseName
          : chineseName // ignore: cast_nullable_to_non_nullable
              as String,
      businessLicense: null == businessLicense
          ? _value.businessLicense
          : businessLicense // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      supportedCuisineTypes: null == supportedCuisineTypes
          ? _value.supportedCuisineTypes
          : supportedCuisineTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      certifications: null == certifications
          ? _value.certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>,
      specialties: null == specialties
          ? _value.specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hasNutritionCertification: null == hasNutritionCertification
          ? _value.hasNutritionCertification
          : hasNutritionCertification // ignore: cast_nullable_to_non_nullable
              as bool,
      nutritionistId: freezed == nutritionistId
          ? _value.nutritionistId
          : nutritionistId // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionSpecializations: null == nutritionSpecializations
          ? _value.nutritionSpecializations
          : nutritionSpecializations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      allowNutritionOrdering: null == allowNutritionOrdering
          ? _value.allowNutritionOrdering
          : allowNutritionOrdering // ignore: cast_nullable_to_non_nullable
              as bool,
      supportedNutritionElements: null == supportedNutritionElements
          ? _value.supportedNutritionElements
          : supportedNutritionElements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ingredientPricingMultipliers: null == ingredientPricingMultipliers
          ? _value.ingredientPricingMultipliers
          : ingredientPricingMultipliers // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MerchantInfoImplCopyWith<$Res>
    implements $MerchantInfoCopyWith<$Res> {
  factory _$$MerchantInfoImplCopyWith(
          _$MerchantInfoImpl value, $Res Function(_$MerchantInfoImpl) then) =
      __$$MerchantInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String chineseName,
      String businessLicense,
      String address,
      String phone,
      String email,
      String status,
      List<String> supportedCuisineTypes,
      List<String> certifications,
      List<String> specialties,
      DateTime createdAt,
      DateTime? updatedAt,
      bool hasNutritionCertification,
      String? nutritionistId,
      List<String> nutritionSpecializations,
      double averageRating,
      int totalOrders,
      int totalReviews,
      bool allowNutritionOrdering,
      List<String> supportedNutritionElements,
      Map<String, double> ingredientPricingMultipliers});
}

/// @nodoc
class __$$MerchantInfoImplCopyWithImpl<$Res>
    extends _$MerchantInfoCopyWithImpl<$Res, _$MerchantInfoImpl>
    implements _$$MerchantInfoImplCopyWith<$Res> {
  __$$MerchantInfoImplCopyWithImpl(
      _$MerchantInfoImpl _value, $Res Function(_$MerchantInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of MerchantInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? chineseName = null,
    Object? businessLicense = null,
    Object? address = null,
    Object? phone = null,
    Object? email = null,
    Object? status = null,
    Object? supportedCuisineTypes = null,
    Object? certifications = null,
    Object? specialties = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? hasNutritionCertification = null,
    Object? nutritionistId = freezed,
    Object? nutritionSpecializations = null,
    Object? averageRating = null,
    Object? totalOrders = null,
    Object? totalReviews = null,
    Object? allowNutritionOrdering = null,
    Object? supportedNutritionElements = null,
    Object? ingredientPricingMultipliers = null,
  }) {
    return _then(_$MerchantInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      chineseName: null == chineseName
          ? _value.chineseName
          : chineseName // ignore: cast_nullable_to_non_nullable
              as String,
      businessLicense: null == businessLicense
          ? _value.businessLicense
          : businessLicense // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      supportedCuisineTypes: null == supportedCuisineTypes
          ? _value._supportedCuisineTypes
          : supportedCuisineTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      certifications: null == certifications
          ? _value._certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>,
      specialties: null == specialties
          ? _value._specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hasNutritionCertification: null == hasNutritionCertification
          ? _value.hasNutritionCertification
          : hasNutritionCertification // ignore: cast_nullable_to_non_nullable
              as bool,
      nutritionistId: freezed == nutritionistId
          ? _value.nutritionistId
          : nutritionistId // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionSpecializations: null == nutritionSpecializations
          ? _value._nutritionSpecializations
          : nutritionSpecializations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      allowNutritionOrdering: null == allowNutritionOrdering
          ? _value.allowNutritionOrdering
          : allowNutritionOrdering // ignore: cast_nullable_to_non_nullable
              as bool,
      supportedNutritionElements: null == supportedNutritionElements
          ? _value._supportedNutritionElements
          : supportedNutritionElements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ingredientPricingMultipliers: null == ingredientPricingMultipliers
          ? _value._ingredientPricingMultipliers
          : ingredientPricingMultipliers // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MerchantInfoImpl implements _MerchantInfo {
  const _$MerchantInfoImpl(
      {required this.id,
      required this.name,
      required this.chineseName,
      required this.businessLicense,
      required this.address,
      required this.phone,
      required this.email,
      this.status = 'pending',
      required final List<String> supportedCuisineTypes,
      required final List<String> certifications,
      final List<String> specialties = const [],
      required this.createdAt,
      this.updatedAt,
      this.hasNutritionCertification = false,
      this.nutritionistId,
      final List<String> nutritionSpecializations = const [],
      this.averageRating = 0.0,
      this.totalOrders = 0,
      this.totalReviews = 0,
      this.allowNutritionOrdering = true,
      final List<String> supportedNutritionElements = const [],
      final Map<String, double> ingredientPricingMultipliers = const {}})
      : _supportedCuisineTypes = supportedCuisineTypes,
        _certifications = certifications,
        _specialties = specialties,
        _nutritionSpecializations = nutritionSpecializations,
        _supportedNutritionElements = supportedNutritionElements,
        _ingredientPricingMultipliers = ingredientPricingMultipliers;

  factory _$MerchantInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MerchantInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String chineseName;
  @override
  final String businessLicense;
  @override
  final String address;
  @override
  final String phone;
  @override
  final String email;
  @override
  @JsonKey()
  final String status;
// pending, approved, rejected, suspended
  final List<String> _supportedCuisineTypes;
// pending, approved, rejected, suspended
  @override
  List<String> get supportedCuisineTypes {
    if (_supportedCuisineTypes is EqualUnmodifiableListView)
      return _supportedCuisineTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportedCuisineTypes);
  }

  final List<String> _certifications;
  @override
  List<String> get certifications {
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_certifications);
  }

  final List<String> _specialties;
  @override
  @JsonKey()
  List<String> get specialties {
    if (_specialties is EqualUnmodifiableListView) return _specialties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialties);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
// 营养管理资质
  @override
  @JsonKey()
  final bool hasNutritionCertification;
  @override
  final String? nutritionistId;
  final List<String> _nutritionSpecializations;
  @override
  @JsonKey()
  List<String> get nutritionSpecializations {
    if (_nutritionSpecializations is EqualUnmodifiableListView)
      return _nutritionSpecializations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionSpecializations);
  }

// 业务数据
  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final int totalOrders;
  @override
  @JsonKey()
  final int totalReviews;
// 营养菜单设置
  @override
  @JsonKey()
  final bool allowNutritionOrdering;
  final List<String> _supportedNutritionElements;
  @override
  @JsonKey()
  List<String> get supportedNutritionElements {
    if (_supportedNutritionElements is EqualUnmodifiableListView)
      return _supportedNutritionElements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportedNutritionElements);
  }

  final Map<String, double> _ingredientPricingMultipliers;
  @override
  @JsonKey()
  Map<String, double> get ingredientPricingMultipliers {
    if (_ingredientPricingMultipliers is EqualUnmodifiableMapView)
      return _ingredientPricingMultipliers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ingredientPricingMultipliers);
  }

  @override
  String toString() {
    return 'MerchantInfo(id: $id, name: $name, chineseName: $chineseName, businessLicense: $businessLicense, address: $address, phone: $phone, email: $email, status: $status, supportedCuisineTypes: $supportedCuisineTypes, certifications: $certifications, specialties: $specialties, createdAt: $createdAt, updatedAt: $updatedAt, hasNutritionCertification: $hasNutritionCertification, nutritionistId: $nutritionistId, nutritionSpecializations: $nutritionSpecializations, averageRating: $averageRating, totalOrders: $totalOrders, totalReviews: $totalReviews, allowNutritionOrdering: $allowNutritionOrdering, supportedNutritionElements: $supportedNutritionElements, ingredientPricingMultipliers: $ingredientPricingMultipliers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MerchantInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.chineseName, chineseName) ||
                other.chineseName == chineseName) &&
            (identical(other.businessLicense, businessLicense) ||
                other.businessLicense == businessLicense) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._supportedCuisineTypes, _supportedCuisineTypes) &&
            const DeepCollectionEquality()
                .equals(other._certifications, _certifications) &&
            const DeepCollectionEquality()
                .equals(other._specialties, _specialties) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.hasNutritionCertification,
                    hasNutritionCertification) ||
                other.hasNutritionCertification == hasNutritionCertification) &&
            (identical(other.nutritionistId, nutritionistId) ||
                other.nutritionistId == nutritionistId) &&
            const DeepCollectionEquality().equals(
                other._nutritionSpecializations, _nutritionSpecializations) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.allowNutritionOrdering, allowNutritionOrdering) ||
                other.allowNutritionOrdering == allowNutritionOrdering) &&
            const DeepCollectionEquality().equals(
                other._supportedNutritionElements,
                _supportedNutritionElements) &&
            const DeepCollectionEquality().equals(
                other._ingredientPricingMultipliers,
                _ingredientPricingMultipliers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        chineseName,
        businessLicense,
        address,
        phone,
        email,
        status,
        const DeepCollectionEquality().hash(_supportedCuisineTypes),
        const DeepCollectionEquality().hash(_certifications),
        const DeepCollectionEquality().hash(_specialties),
        createdAt,
        updatedAt,
        hasNutritionCertification,
        nutritionistId,
        const DeepCollectionEquality().hash(_nutritionSpecializations),
        averageRating,
        totalOrders,
        totalReviews,
        allowNutritionOrdering,
        const DeepCollectionEquality().hash(_supportedNutritionElements),
        const DeepCollectionEquality().hash(_ingredientPricingMultipliers)
      ]);

  /// Create a copy of MerchantInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MerchantInfoImplCopyWith<_$MerchantInfoImpl> get copyWith =>
      __$$MerchantInfoImplCopyWithImpl<_$MerchantInfoImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MerchantInfo value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MerchantInfo value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MerchantInfo value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MerchantInfoImplToJson(
      this,
    );
  }
}

abstract class _MerchantInfo implements MerchantInfo {
  const factory _MerchantInfo(
          {required final String id,
          required final String name,
          required final String chineseName,
          required final String businessLicense,
          required final String address,
          required final String phone,
          required final String email,
          final String status,
          required final List<String> supportedCuisineTypes,
          required final List<String> certifications,
          final List<String> specialties,
          required final DateTime createdAt,
          final DateTime? updatedAt,
          final bool hasNutritionCertification,
          final String? nutritionistId,
          final List<String> nutritionSpecializations,
          final double averageRating,
          final int totalOrders,
          final int totalReviews,
          final bool allowNutritionOrdering,
          final List<String> supportedNutritionElements,
          final Map<String, double> ingredientPricingMultipliers}) =
      _$MerchantInfoImpl;

  factory _MerchantInfo.fromJson(Map<String, dynamic> json) =
      _$MerchantInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get chineseName;
  @override
  String get businessLicense;
  @override
  String get address;
  @override
  String get phone;
  @override
  String get email;
  @override
  String get status; // pending, approved, rejected, suspended
  @override
  List<String> get supportedCuisineTypes;
  @override
  List<String> get certifications;
  @override
  List<String> get specialties;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt; // 营养管理资质
  @override
  bool get hasNutritionCertification;
  @override
  String? get nutritionistId;
  @override
  List<String> get nutritionSpecializations; // 业务数据
  @override
  double get averageRating;
  @override
  int get totalOrders;
  @override
  int get totalReviews; // 营养菜单设置
  @override
  bool get allowNutritionOrdering;
  @override
  List<String> get supportedNutritionElements;
  @override
  Map<String, double> get ingredientPricingMultipliers;

  /// Create a copy of MerchantInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MerchantInfoImplCopyWith<_$MerchantInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IngredientInventoryItem _$IngredientInventoryItemFromJson(
    Map<String, dynamic> json) {
  return _IngredientInventoryItem.fromJson(json);
}

/// @nodoc
mixin _$IngredientInventoryItem {
  String get id => throw _privateConstructorUsedError;
  String get ingredientId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get chineseName => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError; // 库存信息
  double get currentStock => throw _privateConstructorUsedError;
  double get minThreshold => throw _privateConstructorUsedError;
  double get maxCapacity => throw _privateConstructorUsedError;
  double get reservedStock => throw _privateConstructorUsedError;
  double get availableStock => throw _privateConstructorUsedError; // 定价信息
  double get costPerUnit => throw _privateConstructorUsedError;
  double get sellingPricePerUnit => throw _privateConstructorUsedError;
  double get profitMargin =>
      throw _privateConstructorUsedError; // 营养数据（每100g/ml）
  Map<String, double> get nutritionPer100g =>
      throw _privateConstructorUsedError; // 采购信息
  String? get supplierId => throw _privateConstructorUsedError;
  String? get supplierName => throw _privateConstructorUsedError;
  DateTime? get lastRestockDate => throw _privateConstructorUsedError;
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  String get qualityStatus =>
      throw _privateConstructorUsedError; // fresh, good, fair, expired
// 菜单可用性
  bool get isAvailableForOrdering => throw _privateConstructorUsedError;
  List<String> get restrictedCookingMethods =>
      throw _privateConstructorUsedError;
  List<String> get allergenWarnings => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_IngredientInventoryItem value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_IngredientInventoryItem value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_IngredientInventoryItem value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this IngredientInventoryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IngredientInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IngredientInventoryItemCopyWith<IngredientInventoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IngredientInventoryItemCopyWith<$Res> {
  factory $IngredientInventoryItemCopyWith(IngredientInventoryItem value,
          $Res Function(IngredientInventoryItem) then) =
      _$IngredientInventoryItemCopyWithImpl<$Res, IngredientInventoryItem>;
  @useResult
  $Res call(
      {String id,
      String ingredientId,
      String name,
      String chineseName,
      String category,
      String unit,
      double currentStock,
      double minThreshold,
      double maxCapacity,
      double reservedStock,
      double availableStock,
      double costPerUnit,
      double sellingPricePerUnit,
      double profitMargin,
      Map<String, double> nutritionPer100g,
      String? supplierId,
      String? supplierName,
      DateTime? lastRestockDate,
      DateTime? expiryDate,
      String qualityStatus,
      bool isAvailableForOrdering,
      List<String> restrictedCookingMethods,
      List<String> allergenWarnings,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$IngredientInventoryItemCopyWithImpl<$Res,
        $Val extends IngredientInventoryItem>
    implements $IngredientInventoryItemCopyWith<$Res> {
  _$IngredientInventoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IngredientInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ingredientId = null,
    Object? name = null,
    Object? chineseName = null,
    Object? category = null,
    Object? unit = null,
    Object? currentStock = null,
    Object? minThreshold = null,
    Object? maxCapacity = null,
    Object? reservedStock = null,
    Object? availableStock = null,
    Object? costPerUnit = null,
    Object? sellingPricePerUnit = null,
    Object? profitMargin = null,
    Object? nutritionPer100g = null,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? lastRestockDate = freezed,
    Object? expiryDate = freezed,
    Object? qualityStatus = null,
    Object? isAvailableForOrdering = null,
    Object? restrictedCookingMethods = null,
    Object? allergenWarnings = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      chineseName: null == chineseName
          ? _value.chineseName
          : chineseName // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as double,
      minThreshold: null == minThreshold
          ? _value.minThreshold
          : minThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      maxCapacity: null == maxCapacity
          ? _value.maxCapacity
          : maxCapacity // ignore: cast_nullable_to_non_nullable
              as double,
      reservedStock: null == reservedStock
          ? _value.reservedStock
          : reservedStock // ignore: cast_nullable_to_non_nullable
              as double,
      availableStock: null == availableStock
          ? _value.availableStock
          : availableStock // ignore: cast_nullable_to_non_nullable
              as double,
      costPerUnit: null == costPerUnit
          ? _value.costPerUnit
          : costPerUnit // ignore: cast_nullable_to_non_nullable
              as double,
      sellingPricePerUnit: null == sellingPricePerUnit
          ? _value.sellingPricePerUnit
          : sellingPricePerUnit // ignore: cast_nullable_to_non_nullable
              as double,
      profitMargin: null == profitMargin
          ? _value.profitMargin
          : profitMargin // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionPer100g: null == nutritionPer100g
          ? _value.nutritionPer100g
          : nutritionPer100g // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastRestockDate: freezed == lastRestockDate
          ? _value.lastRestockDate
          : lastRestockDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      qualityStatus: null == qualityStatus
          ? _value.qualityStatus
          : qualityStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isAvailableForOrdering: null == isAvailableForOrdering
          ? _value.isAvailableForOrdering
          : isAvailableForOrdering // ignore: cast_nullable_to_non_nullable
              as bool,
      restrictedCookingMethods: null == restrictedCookingMethods
          ? _value.restrictedCookingMethods
          : restrictedCookingMethods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergenWarnings: null == allergenWarnings
          ? _value.allergenWarnings
          : allergenWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IngredientInventoryItemImplCopyWith<$Res>
    implements $IngredientInventoryItemCopyWith<$Res> {
  factory _$$IngredientInventoryItemImplCopyWith(
          _$IngredientInventoryItemImpl value,
          $Res Function(_$IngredientInventoryItemImpl) then) =
      __$$IngredientInventoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ingredientId,
      String name,
      String chineseName,
      String category,
      String unit,
      double currentStock,
      double minThreshold,
      double maxCapacity,
      double reservedStock,
      double availableStock,
      double costPerUnit,
      double sellingPricePerUnit,
      double profitMargin,
      Map<String, double> nutritionPer100g,
      String? supplierId,
      String? supplierName,
      DateTime? lastRestockDate,
      DateTime? expiryDate,
      String qualityStatus,
      bool isAvailableForOrdering,
      List<String> restrictedCookingMethods,
      List<String> allergenWarnings,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$IngredientInventoryItemImplCopyWithImpl<$Res>
    extends _$IngredientInventoryItemCopyWithImpl<$Res,
        _$IngredientInventoryItemImpl>
    implements _$$IngredientInventoryItemImplCopyWith<$Res> {
  __$$IngredientInventoryItemImplCopyWithImpl(
      _$IngredientInventoryItemImpl _value,
      $Res Function(_$IngredientInventoryItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of IngredientInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ingredientId = null,
    Object? name = null,
    Object? chineseName = null,
    Object? category = null,
    Object? unit = null,
    Object? currentStock = null,
    Object? minThreshold = null,
    Object? maxCapacity = null,
    Object? reservedStock = null,
    Object? availableStock = null,
    Object? costPerUnit = null,
    Object? sellingPricePerUnit = null,
    Object? profitMargin = null,
    Object? nutritionPer100g = null,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? lastRestockDate = freezed,
    Object? expiryDate = freezed,
    Object? qualityStatus = null,
    Object? isAvailableForOrdering = null,
    Object? restrictedCookingMethods = null,
    Object? allergenWarnings = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$IngredientInventoryItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      chineseName: null == chineseName
          ? _value.chineseName
          : chineseName // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as double,
      minThreshold: null == minThreshold
          ? _value.minThreshold
          : minThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      maxCapacity: null == maxCapacity
          ? _value.maxCapacity
          : maxCapacity // ignore: cast_nullable_to_non_nullable
              as double,
      reservedStock: null == reservedStock
          ? _value.reservedStock
          : reservedStock // ignore: cast_nullable_to_non_nullable
              as double,
      availableStock: null == availableStock
          ? _value.availableStock
          : availableStock // ignore: cast_nullable_to_non_nullable
              as double,
      costPerUnit: null == costPerUnit
          ? _value.costPerUnit
          : costPerUnit // ignore: cast_nullable_to_non_nullable
              as double,
      sellingPricePerUnit: null == sellingPricePerUnit
          ? _value.sellingPricePerUnit
          : sellingPricePerUnit // ignore: cast_nullable_to_non_nullable
              as double,
      profitMargin: null == profitMargin
          ? _value.profitMargin
          : profitMargin // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionPer100g: null == nutritionPer100g
          ? _value._nutritionPer100g
          : nutritionPer100g // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastRestockDate: freezed == lastRestockDate
          ? _value.lastRestockDate
          : lastRestockDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      qualityStatus: null == qualityStatus
          ? _value.qualityStatus
          : qualityStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isAvailableForOrdering: null == isAvailableForOrdering
          ? _value.isAvailableForOrdering
          : isAvailableForOrdering // ignore: cast_nullable_to_non_nullable
              as bool,
      restrictedCookingMethods: null == restrictedCookingMethods
          ? _value._restrictedCookingMethods
          : restrictedCookingMethods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergenWarnings: null == allergenWarnings
          ? _value._allergenWarnings
          : allergenWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IngredientInventoryItemImpl implements _IngredientInventoryItem {
  const _$IngredientInventoryItemImpl(
      {required this.id,
      required this.ingredientId,
      required this.name,
      required this.chineseName,
      required this.category,
      required this.unit,
      required this.currentStock,
      required this.minThreshold,
      required this.maxCapacity,
      this.reservedStock = 0.0,
      this.availableStock = 0.0,
      required this.costPerUnit,
      required this.sellingPricePerUnit,
      this.profitMargin = 1.0,
      required final Map<String, double> nutritionPer100g,
      this.supplierId,
      this.supplierName,
      this.lastRestockDate,
      this.expiryDate,
      this.qualityStatus = 'fresh',
      this.isAvailableForOrdering = true,
      final List<String> restrictedCookingMethods = const [],
      final List<String> allergenWarnings = const [],
      required this.createdAt,
      this.updatedAt})
      : _nutritionPer100g = nutritionPer100g,
        _restrictedCookingMethods = restrictedCookingMethods,
        _allergenWarnings = allergenWarnings;

  factory _$IngredientInventoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$IngredientInventoryItemImplFromJson(json);

  @override
  final String id;
  @override
  final String ingredientId;
  @override
  final String name;
  @override
  final String chineseName;
  @override
  final String category;
  @override
  final String unit;
// 库存信息
  @override
  final double currentStock;
  @override
  final double minThreshold;
  @override
  final double maxCapacity;
  @override
  @JsonKey()
  final double reservedStock;
  @override
  @JsonKey()
  final double availableStock;
// 定价信息
  @override
  final double costPerUnit;
  @override
  final double sellingPricePerUnit;
  @override
  @JsonKey()
  final double profitMargin;
// 营养数据（每100g/ml）
  final Map<String, double> _nutritionPer100g;
// 营养数据（每100g/ml）
  @override
  Map<String, double> get nutritionPer100g {
    if (_nutritionPer100g is EqualUnmodifiableMapView) return _nutritionPer100g;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionPer100g);
  }

// 采购信息
  @override
  final String? supplierId;
  @override
  final String? supplierName;
  @override
  final DateTime? lastRestockDate;
  @override
  final DateTime? expiryDate;
  @override
  @JsonKey()
  final String qualityStatus;
// fresh, good, fair, expired
// 菜单可用性
  @override
  @JsonKey()
  final bool isAvailableForOrdering;
  final List<String> _restrictedCookingMethods;
  @override
  @JsonKey()
  List<String> get restrictedCookingMethods {
    if (_restrictedCookingMethods is EqualUnmodifiableListView)
      return _restrictedCookingMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_restrictedCookingMethods);
  }

  final List<String> _allergenWarnings;
  @override
  @JsonKey()
  List<String> get allergenWarnings {
    if (_allergenWarnings is EqualUnmodifiableListView)
      return _allergenWarnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergenWarnings);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'IngredientInventoryItem(id: $id, ingredientId: $ingredientId, name: $name, chineseName: $chineseName, category: $category, unit: $unit, currentStock: $currentStock, minThreshold: $minThreshold, maxCapacity: $maxCapacity, reservedStock: $reservedStock, availableStock: $availableStock, costPerUnit: $costPerUnit, sellingPricePerUnit: $sellingPricePerUnit, profitMargin: $profitMargin, nutritionPer100g: $nutritionPer100g, supplierId: $supplierId, supplierName: $supplierName, lastRestockDate: $lastRestockDate, expiryDate: $expiryDate, qualityStatus: $qualityStatus, isAvailableForOrdering: $isAvailableForOrdering, restrictedCookingMethods: $restrictedCookingMethods, allergenWarnings: $allergenWarnings, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IngredientInventoryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ingredientId, ingredientId) ||
                other.ingredientId == ingredientId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.chineseName, chineseName) ||
                other.chineseName == chineseName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.minThreshold, minThreshold) ||
                other.minThreshold == minThreshold) &&
            (identical(other.maxCapacity, maxCapacity) ||
                other.maxCapacity == maxCapacity) &&
            (identical(other.reservedStock, reservedStock) ||
                other.reservedStock == reservedStock) &&
            (identical(other.availableStock, availableStock) ||
                other.availableStock == availableStock) &&
            (identical(other.costPerUnit, costPerUnit) ||
                other.costPerUnit == costPerUnit) &&
            (identical(other.sellingPricePerUnit, sellingPricePerUnit) ||
                other.sellingPricePerUnit == sellingPricePerUnit) &&
            (identical(other.profitMargin, profitMargin) ||
                other.profitMargin == profitMargin) &&
            const DeepCollectionEquality()
                .equals(other._nutritionPer100g, _nutritionPer100g) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.lastRestockDate, lastRestockDate) ||
                other.lastRestockDate == lastRestockDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.qualityStatus, qualityStatus) ||
                other.qualityStatus == qualityStatus) &&
            (identical(other.isAvailableForOrdering, isAvailableForOrdering) ||
                other.isAvailableForOrdering == isAvailableForOrdering) &&
            const DeepCollectionEquality().equals(
                other._restrictedCookingMethods, _restrictedCookingMethods) &&
            const DeepCollectionEquality()
                .equals(other._allergenWarnings, _allergenWarnings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        ingredientId,
        name,
        chineseName,
        category,
        unit,
        currentStock,
        minThreshold,
        maxCapacity,
        reservedStock,
        availableStock,
        costPerUnit,
        sellingPricePerUnit,
        profitMargin,
        const DeepCollectionEquality().hash(_nutritionPer100g),
        supplierId,
        supplierName,
        lastRestockDate,
        expiryDate,
        qualityStatus,
        isAvailableForOrdering,
        const DeepCollectionEquality().hash(_restrictedCookingMethods),
        const DeepCollectionEquality().hash(_allergenWarnings),
        createdAt,
        updatedAt
      ]);

  /// Create a copy of IngredientInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IngredientInventoryItemImplCopyWith<_$IngredientInventoryItemImpl>
      get copyWith => __$$IngredientInventoryItemImplCopyWithImpl<
          _$IngredientInventoryItemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_IngredientInventoryItem value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_IngredientInventoryItem value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_IngredientInventoryItem value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IngredientInventoryItemImplToJson(
      this,
    );
  }
}

abstract class _IngredientInventoryItem implements IngredientInventoryItem {
  const factory _IngredientInventoryItem(
      {required final String id,
      required final String ingredientId,
      required final String name,
      required final String chineseName,
      required final String category,
      required final String unit,
      required final double currentStock,
      required final double minThreshold,
      required final double maxCapacity,
      final double reservedStock,
      final double availableStock,
      required final double costPerUnit,
      required final double sellingPricePerUnit,
      final double profitMargin,
      required final Map<String, double> nutritionPer100g,
      final String? supplierId,
      final String? supplierName,
      final DateTime? lastRestockDate,
      final DateTime? expiryDate,
      final String qualityStatus,
      final bool isAvailableForOrdering,
      final List<String> restrictedCookingMethods,
      final List<String> allergenWarnings,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$IngredientInventoryItemImpl;

  factory _IngredientInventoryItem.fromJson(Map<String, dynamic> json) =
      _$IngredientInventoryItemImpl.fromJson;

  @override
  String get id;
  @override
  String get ingredientId;
  @override
  String get name;
  @override
  String get chineseName;
  @override
  String get category;
  @override
  String get unit; // 库存信息
  @override
  double get currentStock;
  @override
  double get minThreshold;
  @override
  double get maxCapacity;
  @override
  double get reservedStock;
  @override
  double get availableStock; // 定价信息
  @override
  double get costPerUnit;
  @override
  double get sellingPricePerUnit;
  @override
  double get profitMargin; // 营养数据（每100g/ml）
  @override
  Map<String, double> get nutritionPer100g; // 采购信息
  @override
  String? get supplierId;
  @override
  String? get supplierName;
  @override
  DateTime? get lastRestockDate;
  @override
  DateTime? get expiryDate;
  @override
  String get qualityStatus; // fresh, good, fair, expired
// 菜单可用性
  @override
  bool get isAvailableForOrdering;
  @override
  List<String> get restrictedCookingMethods;
  @override
  List<String> get allergenWarnings;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of IngredientInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IngredientInventoryItemImplCopyWith<_$IngredientInventoryItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CookingMethodConfig _$CookingMethodConfigFromJson(Map<String, dynamic> json) {
  return _CookingMethodConfig.fromJson(json);
}

/// @nodoc
mixin _$CookingMethodConfig {
  String get id => throw _privateConstructorUsedError;
  String get cookingMethodId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get chineseName => throw _privateConstructorUsedError;
  int get preparationTimeMinutes => throw _privateConstructorUsedError;
  int get cookingTimeMinutes => throw _privateConstructorUsedError; // 设备要求
  List<String> get requiredEquipment => throw _privateConstructorUsedError;
  int get skillLevelRequired => throw _privateConstructorUsedError; // 1-5
  double get laborCostMultiplier => throw _privateConstructorUsedError; // 营养影响
  Map<String, double> get nutritionRetentionRates =>
      throw _privateConstructorUsedError;
  Map<String, double> get nutritionEnhancements =>
      throw _privateConstructorUsedError; // 成本影响
  double get preparationCostMultiplier => throw _privateConstructorUsedError;
  double get additionalFixedCost => throw _privateConstructorUsedError; // 可用性
  bool get isAvailable => throw _privateConstructorUsedError;
  List<String> get compatibleIngredientCategories =>
      throw _privateConstructorUsedError;
  List<String> get incompatibleIngredients =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CookingMethodConfig value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CookingMethodConfig value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CookingMethodConfig value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this CookingMethodConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CookingMethodConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CookingMethodConfigCopyWith<CookingMethodConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CookingMethodConfigCopyWith<$Res> {
  factory $CookingMethodConfigCopyWith(
          CookingMethodConfig value, $Res Function(CookingMethodConfig) then) =
      _$CookingMethodConfigCopyWithImpl<$Res, CookingMethodConfig>;
  @useResult
  $Res call(
      {String id,
      String cookingMethodId,
      String name,
      String chineseName,
      int preparationTimeMinutes,
      int cookingTimeMinutes,
      List<String> requiredEquipment,
      int skillLevelRequired,
      double laborCostMultiplier,
      Map<String, double> nutritionRetentionRates,
      Map<String, double> nutritionEnhancements,
      double preparationCostMultiplier,
      double additionalFixedCost,
      bool isAvailable,
      List<String> compatibleIngredientCategories,
      List<String> incompatibleIngredients,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$CookingMethodConfigCopyWithImpl<$Res, $Val extends CookingMethodConfig>
    implements $CookingMethodConfigCopyWith<$Res> {
  _$CookingMethodConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CookingMethodConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cookingMethodId = null,
    Object? name = null,
    Object? chineseName = null,
    Object? preparationTimeMinutes = null,
    Object? cookingTimeMinutes = null,
    Object? requiredEquipment = null,
    Object? skillLevelRequired = null,
    Object? laborCostMultiplier = null,
    Object? nutritionRetentionRates = null,
    Object? nutritionEnhancements = null,
    Object? preparationCostMultiplier = null,
    Object? additionalFixedCost = null,
    Object? isAvailable = null,
    Object? compatibleIngredientCategories = null,
    Object? incompatibleIngredients = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      cookingMethodId: null == cookingMethodId
          ? _value.cookingMethodId
          : cookingMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      chineseName: null == chineseName
          ? _value.chineseName
          : chineseName // ignore: cast_nullable_to_non_nullable
              as String,
      preparationTimeMinutes: null == preparationTimeMinutes
          ? _value.preparationTimeMinutes
          : preparationTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      cookingTimeMinutes: null == cookingTimeMinutes
          ? _value.cookingTimeMinutes
          : cookingTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      requiredEquipment: null == requiredEquipment
          ? _value.requiredEquipment
          : requiredEquipment // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skillLevelRequired: null == skillLevelRequired
          ? _value.skillLevelRequired
          : skillLevelRequired // ignore: cast_nullable_to_non_nullable
              as int,
      laborCostMultiplier: null == laborCostMultiplier
          ? _value.laborCostMultiplier
          : laborCostMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionRetentionRates: null == nutritionRetentionRates
          ? _value.nutritionRetentionRates
          : nutritionRetentionRates // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      nutritionEnhancements: null == nutritionEnhancements
          ? _value.nutritionEnhancements
          : nutritionEnhancements // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      preparationCostMultiplier: null == preparationCostMultiplier
          ? _value.preparationCostMultiplier
          : preparationCostMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      additionalFixedCost: null == additionalFixedCost
          ? _value.additionalFixedCost
          : additionalFixedCost // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      compatibleIngredientCategories: null == compatibleIngredientCategories
          ? _value.compatibleIngredientCategories
          : compatibleIngredientCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      incompatibleIngredients: null == incompatibleIngredients
          ? _value.incompatibleIngredients
          : incompatibleIngredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CookingMethodConfigImplCopyWith<$Res>
    implements $CookingMethodConfigCopyWith<$Res> {
  factory _$$CookingMethodConfigImplCopyWith(_$CookingMethodConfigImpl value,
          $Res Function(_$CookingMethodConfigImpl) then) =
      __$$CookingMethodConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String cookingMethodId,
      String name,
      String chineseName,
      int preparationTimeMinutes,
      int cookingTimeMinutes,
      List<String> requiredEquipment,
      int skillLevelRequired,
      double laborCostMultiplier,
      Map<String, double> nutritionRetentionRates,
      Map<String, double> nutritionEnhancements,
      double preparationCostMultiplier,
      double additionalFixedCost,
      bool isAvailable,
      List<String> compatibleIngredientCategories,
      List<String> incompatibleIngredients,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$CookingMethodConfigImplCopyWithImpl<$Res>
    extends _$CookingMethodConfigCopyWithImpl<$Res, _$CookingMethodConfigImpl>
    implements _$$CookingMethodConfigImplCopyWith<$Res> {
  __$$CookingMethodConfigImplCopyWithImpl(_$CookingMethodConfigImpl _value,
      $Res Function(_$CookingMethodConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of CookingMethodConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cookingMethodId = null,
    Object? name = null,
    Object? chineseName = null,
    Object? preparationTimeMinutes = null,
    Object? cookingTimeMinutes = null,
    Object? requiredEquipment = null,
    Object? skillLevelRequired = null,
    Object? laborCostMultiplier = null,
    Object? nutritionRetentionRates = null,
    Object? nutritionEnhancements = null,
    Object? preparationCostMultiplier = null,
    Object? additionalFixedCost = null,
    Object? isAvailable = null,
    Object? compatibleIngredientCategories = null,
    Object? incompatibleIngredients = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$CookingMethodConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      cookingMethodId: null == cookingMethodId
          ? _value.cookingMethodId
          : cookingMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      chineseName: null == chineseName
          ? _value.chineseName
          : chineseName // ignore: cast_nullable_to_non_nullable
              as String,
      preparationTimeMinutes: null == preparationTimeMinutes
          ? _value.preparationTimeMinutes
          : preparationTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      cookingTimeMinutes: null == cookingTimeMinutes
          ? _value.cookingTimeMinutes
          : cookingTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      requiredEquipment: null == requiredEquipment
          ? _value._requiredEquipment
          : requiredEquipment // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skillLevelRequired: null == skillLevelRequired
          ? _value.skillLevelRequired
          : skillLevelRequired // ignore: cast_nullable_to_non_nullable
              as int,
      laborCostMultiplier: null == laborCostMultiplier
          ? _value.laborCostMultiplier
          : laborCostMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionRetentionRates: null == nutritionRetentionRates
          ? _value._nutritionRetentionRates
          : nutritionRetentionRates // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      nutritionEnhancements: null == nutritionEnhancements
          ? _value._nutritionEnhancements
          : nutritionEnhancements // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      preparationCostMultiplier: null == preparationCostMultiplier
          ? _value.preparationCostMultiplier
          : preparationCostMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      additionalFixedCost: null == additionalFixedCost
          ? _value.additionalFixedCost
          : additionalFixedCost // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      compatibleIngredientCategories: null == compatibleIngredientCategories
          ? _value._compatibleIngredientCategories
          : compatibleIngredientCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      incompatibleIngredients: null == incompatibleIngredients
          ? _value._incompatibleIngredients
          : incompatibleIngredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CookingMethodConfigImpl implements _CookingMethodConfig {
  const _$CookingMethodConfigImpl(
      {required this.id,
      required this.cookingMethodId,
      required this.name,
      required this.chineseName,
      required this.preparationTimeMinutes,
      required this.cookingTimeMinutes,
      required final List<String> requiredEquipment,
      this.skillLevelRequired = 1,
      this.laborCostMultiplier = 1.0,
      required final Map<String, double> nutritionRetentionRates,
      final Map<String, double> nutritionEnhancements = const {},
      this.preparationCostMultiplier = 1.0,
      this.additionalFixedCost = 0.0,
      this.isAvailable = true,
      final List<String> compatibleIngredientCategories = const [],
      final List<String> incompatibleIngredients = const [],
      required this.createdAt,
      this.updatedAt})
      : _requiredEquipment = requiredEquipment,
        _nutritionRetentionRates = nutritionRetentionRates,
        _nutritionEnhancements = nutritionEnhancements,
        _compatibleIngredientCategories = compatibleIngredientCategories,
        _incompatibleIngredients = incompatibleIngredients;

  factory _$CookingMethodConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$CookingMethodConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String cookingMethodId;
  @override
  final String name;
  @override
  final String chineseName;
  @override
  final int preparationTimeMinutes;
  @override
  final int cookingTimeMinutes;
// 设备要求
  final List<String> _requiredEquipment;
// 设备要求
  @override
  List<String> get requiredEquipment {
    if (_requiredEquipment is EqualUnmodifiableListView)
      return _requiredEquipment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredEquipment);
  }

  @override
  @JsonKey()
  final int skillLevelRequired;
// 1-5
  @override
  @JsonKey()
  final double laborCostMultiplier;
// 营养影响
  final Map<String, double> _nutritionRetentionRates;
// 营养影响
  @override
  Map<String, double> get nutritionRetentionRates {
    if (_nutritionRetentionRates is EqualUnmodifiableMapView)
      return _nutritionRetentionRates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionRetentionRates);
  }

  final Map<String, double> _nutritionEnhancements;
  @override
  @JsonKey()
  Map<String, double> get nutritionEnhancements {
    if (_nutritionEnhancements is EqualUnmodifiableMapView)
      return _nutritionEnhancements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionEnhancements);
  }

// 成本影响
  @override
  @JsonKey()
  final double preparationCostMultiplier;
  @override
  @JsonKey()
  final double additionalFixedCost;
// 可用性
  @override
  @JsonKey()
  final bool isAvailable;
  final List<String> _compatibleIngredientCategories;
  @override
  @JsonKey()
  List<String> get compatibleIngredientCategories {
    if (_compatibleIngredientCategories is EqualUnmodifiableListView)
      return _compatibleIngredientCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_compatibleIngredientCategories);
  }

  final List<String> _incompatibleIngredients;
  @override
  @JsonKey()
  List<String> get incompatibleIngredients {
    if (_incompatibleIngredients is EqualUnmodifiableListView)
      return _incompatibleIngredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_incompatibleIngredients);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CookingMethodConfig(id: $id, cookingMethodId: $cookingMethodId, name: $name, chineseName: $chineseName, preparationTimeMinutes: $preparationTimeMinutes, cookingTimeMinutes: $cookingTimeMinutes, requiredEquipment: $requiredEquipment, skillLevelRequired: $skillLevelRequired, laborCostMultiplier: $laborCostMultiplier, nutritionRetentionRates: $nutritionRetentionRates, nutritionEnhancements: $nutritionEnhancements, preparationCostMultiplier: $preparationCostMultiplier, additionalFixedCost: $additionalFixedCost, isAvailable: $isAvailable, compatibleIngredientCategories: $compatibleIngredientCategories, incompatibleIngredients: $incompatibleIngredients, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CookingMethodConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cookingMethodId, cookingMethodId) ||
                other.cookingMethodId == cookingMethodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.chineseName, chineseName) ||
                other.chineseName == chineseName) &&
            (identical(other.preparationTimeMinutes, preparationTimeMinutes) ||
                other.preparationTimeMinutes == preparationTimeMinutes) &&
            (identical(other.cookingTimeMinutes, cookingTimeMinutes) ||
                other.cookingTimeMinutes == cookingTimeMinutes) &&
            const DeepCollectionEquality()
                .equals(other._requiredEquipment, _requiredEquipment) &&
            (identical(other.skillLevelRequired, skillLevelRequired) ||
                other.skillLevelRequired == skillLevelRequired) &&
            (identical(other.laborCostMultiplier, laborCostMultiplier) ||
                other.laborCostMultiplier == laborCostMultiplier) &&
            const DeepCollectionEquality().equals(
                other._nutritionRetentionRates, _nutritionRetentionRates) &&
            const DeepCollectionEquality()
                .equals(other._nutritionEnhancements, _nutritionEnhancements) &&
            (identical(other.preparationCostMultiplier,
                    preparationCostMultiplier) ||
                other.preparationCostMultiplier == preparationCostMultiplier) &&
            (identical(other.additionalFixedCost, additionalFixedCost) ||
                other.additionalFixedCost == additionalFixedCost) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            const DeepCollectionEquality().equals(
                other._compatibleIngredientCategories,
                _compatibleIngredientCategories) &&
            const DeepCollectionEquality().equals(
                other._incompatibleIngredients, _incompatibleIngredients) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      cookingMethodId,
      name,
      chineseName,
      preparationTimeMinutes,
      cookingTimeMinutes,
      const DeepCollectionEquality().hash(_requiredEquipment),
      skillLevelRequired,
      laborCostMultiplier,
      const DeepCollectionEquality().hash(_nutritionRetentionRates),
      const DeepCollectionEquality().hash(_nutritionEnhancements),
      preparationCostMultiplier,
      additionalFixedCost,
      isAvailable,
      const DeepCollectionEquality().hash(_compatibleIngredientCategories),
      const DeepCollectionEquality().hash(_incompatibleIngredients),
      createdAt,
      updatedAt);

  /// Create a copy of CookingMethodConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CookingMethodConfigImplCopyWith<_$CookingMethodConfigImpl> get copyWith =>
      __$$CookingMethodConfigImplCopyWithImpl<_$CookingMethodConfigImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CookingMethodConfig value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CookingMethodConfig value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CookingMethodConfig value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CookingMethodConfigImplToJson(
      this,
    );
  }
}

abstract class _CookingMethodConfig implements CookingMethodConfig {
  const factory _CookingMethodConfig(
      {required final String id,
      required final String cookingMethodId,
      required final String name,
      required final String chineseName,
      required final int preparationTimeMinutes,
      required final int cookingTimeMinutes,
      required final List<String> requiredEquipment,
      final int skillLevelRequired,
      final double laborCostMultiplier,
      required final Map<String, double> nutritionRetentionRates,
      final Map<String, double> nutritionEnhancements,
      final double preparationCostMultiplier,
      final double additionalFixedCost,
      final bool isAvailable,
      final List<String> compatibleIngredientCategories,
      final List<String> incompatibleIngredients,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$CookingMethodConfigImpl;

  factory _CookingMethodConfig.fromJson(Map<String, dynamic> json) =
      _$CookingMethodConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get cookingMethodId;
  @override
  String get name;
  @override
  String get chineseName;
  @override
  int get preparationTimeMinutes;
  @override
  int get cookingTimeMinutes; // 设备要求
  @override
  List<String> get requiredEquipment;
  @override
  int get skillLevelRequired; // 1-5
  @override
  double get laborCostMultiplier; // 营养影响
  @override
  Map<String, double> get nutritionRetentionRates;
  @override
  Map<String, double> get nutritionEnhancements; // 成本影响
  @override
  double get preparationCostMultiplier;
  @override
  double get additionalFixedCost; // 可用性
  @override
  bool get isAvailable;
  @override
  List<String> get compatibleIngredientCategories;
  @override
  List<String> get incompatibleIngredients;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of CookingMethodConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CookingMethodConfigImplCopyWith<_$CookingMethodConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionBasedDish _$NutritionBasedDishFromJson(Map<String, dynamic> json) {
  return _NutritionBasedDish.fromJson(json);
}

/// @nodoc
mixin _$NutritionBasedDish {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get chineseName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError; // 食材配方
  List<DishIngredient> get ingredients => throw _privateConstructorUsedError;
  List<String> get cookingMethods =>
      throw _privateConstructorUsedError; // 营养信息（计算得出）
  Map<String, double> get totalNutritionPer100g =>
      throw _privateConstructorUsedError;
  double get totalCaloriesPer100g => throw _privateConstructorUsedError;
  double get recommendedServingSize => throw _privateConstructorUsedError; // 定价
  double get basePrice => throw _privateConstructorUsedError;
  double get calculatedCost => throw _privateConstructorUsedError;
  double get profitMargin => throw _privateConstructorUsedError; // 目标营养人群
  List<String> get targetNutritionGoals => throw _privateConstructorUsedError;
  List<String> get suitableForConditions => throw _privateConstructorUsedError;
  List<String> get allergenWarnings =>
      throw _privateConstructorUsedError; // 商业信息
  int get preparationTimeMinutes => throw _privateConstructorUsedError;
  int get difficultyLevel => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  int get popularityScore => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionBasedDish value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionBasedDish value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionBasedDish value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionBasedDish to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionBasedDish
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionBasedDishCopyWith<NutritionBasedDish> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionBasedDishCopyWith<$Res> {
  factory $NutritionBasedDishCopyWith(
          NutritionBasedDish value, $Res Function(NutritionBasedDish) then) =
      _$NutritionBasedDishCopyWithImpl<$Res, NutritionBasedDish>;
  @useResult
  $Res call(
      {String id,
      String name,
      String chineseName,
      String? description,
      List<DishIngredient> ingredients,
      List<String> cookingMethods,
      Map<String, double> totalNutritionPer100g,
      double totalCaloriesPer100g,
      double recommendedServingSize,
      double basePrice,
      double calculatedCost,
      double profitMargin,
      List<String> targetNutritionGoals,
      List<String> suitableForConditions,
      List<String> allergenWarnings,
      int preparationTimeMinutes,
      int difficultyLevel,
      bool isAvailable,
      int popularityScore,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$NutritionBasedDishCopyWithImpl<$Res, $Val extends NutritionBasedDish>
    implements $NutritionBasedDishCopyWith<$Res> {
  _$NutritionBasedDishCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionBasedDish
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? chineseName = null,
    Object? description = freezed,
    Object? ingredients = null,
    Object? cookingMethods = null,
    Object? totalNutritionPer100g = null,
    Object? totalCaloriesPer100g = null,
    Object? recommendedServingSize = null,
    Object? basePrice = null,
    Object? calculatedCost = null,
    Object? profitMargin = null,
    Object? targetNutritionGoals = null,
    Object? suitableForConditions = null,
    Object? allergenWarnings = null,
    Object? preparationTimeMinutes = null,
    Object? difficultyLevel = null,
    Object? isAvailable = null,
    Object? popularityScore = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      chineseName: null == chineseName
          ? _value.chineseName
          : chineseName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<DishIngredient>,
      cookingMethods: null == cookingMethods
          ? _value.cookingMethods
          : cookingMethods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalNutritionPer100g: null == totalNutritionPer100g
          ? _value.totalNutritionPer100g
          : totalNutritionPer100g // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalCaloriesPer100g: null == totalCaloriesPer100g
          ? _value.totalCaloriesPer100g
          : totalCaloriesPer100g // ignore: cast_nullable_to_non_nullable
              as double,
      recommendedServingSize: null == recommendedServingSize
          ? _value.recommendedServingSize
          : recommendedServingSize // ignore: cast_nullable_to_non_nullable
              as double,
      basePrice: null == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double,
      calculatedCost: null == calculatedCost
          ? _value.calculatedCost
          : calculatedCost // ignore: cast_nullable_to_non_nullable
              as double,
      profitMargin: null == profitMargin
          ? _value.profitMargin
          : profitMargin // ignore: cast_nullable_to_non_nullable
              as double,
      targetNutritionGoals: null == targetNutritionGoals
          ? _value.targetNutritionGoals
          : targetNutritionGoals // ignore: cast_nullable_to_non_nullable
              as List<String>,
      suitableForConditions: null == suitableForConditions
          ? _value.suitableForConditions
          : suitableForConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergenWarnings: null == allergenWarnings
          ? _value.allergenWarnings
          : allergenWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      preparationTimeMinutes: null == preparationTimeMinutes
          ? _value.preparationTimeMinutes
          : preparationTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      difficultyLevel: null == difficultyLevel
          ? _value.difficultyLevel
          : difficultyLevel // ignore: cast_nullable_to_non_nullable
              as int,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      popularityScore: null == popularityScore
          ? _value.popularityScore
          : popularityScore // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionBasedDishImplCopyWith<$Res>
    implements $NutritionBasedDishCopyWith<$Res> {
  factory _$$NutritionBasedDishImplCopyWith(_$NutritionBasedDishImpl value,
          $Res Function(_$NutritionBasedDishImpl) then) =
      __$$NutritionBasedDishImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String chineseName,
      String? description,
      List<DishIngredient> ingredients,
      List<String> cookingMethods,
      Map<String, double> totalNutritionPer100g,
      double totalCaloriesPer100g,
      double recommendedServingSize,
      double basePrice,
      double calculatedCost,
      double profitMargin,
      List<String> targetNutritionGoals,
      List<String> suitableForConditions,
      List<String> allergenWarnings,
      int preparationTimeMinutes,
      int difficultyLevel,
      bool isAvailable,
      int popularityScore,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$NutritionBasedDishImplCopyWithImpl<$Res>
    extends _$NutritionBasedDishCopyWithImpl<$Res, _$NutritionBasedDishImpl>
    implements _$$NutritionBasedDishImplCopyWith<$Res> {
  __$$NutritionBasedDishImplCopyWithImpl(_$NutritionBasedDishImpl _value,
      $Res Function(_$NutritionBasedDishImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionBasedDish
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? chineseName = null,
    Object? description = freezed,
    Object? ingredients = null,
    Object? cookingMethods = null,
    Object? totalNutritionPer100g = null,
    Object? totalCaloriesPer100g = null,
    Object? recommendedServingSize = null,
    Object? basePrice = null,
    Object? calculatedCost = null,
    Object? profitMargin = null,
    Object? targetNutritionGoals = null,
    Object? suitableForConditions = null,
    Object? allergenWarnings = null,
    Object? preparationTimeMinutes = null,
    Object? difficultyLevel = null,
    Object? isAvailable = null,
    Object? popularityScore = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$NutritionBasedDishImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      chineseName: null == chineseName
          ? _value.chineseName
          : chineseName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<DishIngredient>,
      cookingMethods: null == cookingMethods
          ? _value._cookingMethods
          : cookingMethods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalNutritionPer100g: null == totalNutritionPer100g
          ? _value._totalNutritionPer100g
          : totalNutritionPer100g // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalCaloriesPer100g: null == totalCaloriesPer100g
          ? _value.totalCaloriesPer100g
          : totalCaloriesPer100g // ignore: cast_nullable_to_non_nullable
              as double,
      recommendedServingSize: null == recommendedServingSize
          ? _value.recommendedServingSize
          : recommendedServingSize // ignore: cast_nullable_to_non_nullable
              as double,
      basePrice: null == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double,
      calculatedCost: null == calculatedCost
          ? _value.calculatedCost
          : calculatedCost // ignore: cast_nullable_to_non_nullable
              as double,
      profitMargin: null == profitMargin
          ? _value.profitMargin
          : profitMargin // ignore: cast_nullable_to_non_nullable
              as double,
      targetNutritionGoals: null == targetNutritionGoals
          ? _value._targetNutritionGoals
          : targetNutritionGoals // ignore: cast_nullable_to_non_nullable
              as List<String>,
      suitableForConditions: null == suitableForConditions
          ? _value._suitableForConditions
          : suitableForConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergenWarnings: null == allergenWarnings
          ? _value._allergenWarnings
          : allergenWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      preparationTimeMinutes: null == preparationTimeMinutes
          ? _value.preparationTimeMinutes
          : preparationTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      difficultyLevel: null == difficultyLevel
          ? _value.difficultyLevel
          : difficultyLevel // ignore: cast_nullable_to_non_nullable
              as int,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      popularityScore: null == popularityScore
          ? _value.popularityScore
          : popularityScore // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionBasedDishImpl implements _NutritionBasedDish {
  const _$NutritionBasedDishImpl(
      {required this.id,
      required this.name,
      required this.chineseName,
      this.description,
      required final List<DishIngredient> ingredients,
      required final List<String> cookingMethods,
      required final Map<String, double> totalNutritionPer100g,
      required this.totalCaloriesPer100g,
      required this.recommendedServingSize,
      required this.basePrice,
      required this.calculatedCost,
      this.profitMargin = 0.3,
      final List<String> targetNutritionGoals = const [],
      final List<String> suitableForConditions = const [],
      final List<String> allergenWarnings = const [],
      this.preparationTimeMinutes = 0,
      this.difficultyLevel = 1,
      this.isAvailable = true,
      this.popularityScore = 0,
      required this.createdAt,
      this.updatedAt})
      : _ingredients = ingredients,
        _cookingMethods = cookingMethods,
        _totalNutritionPer100g = totalNutritionPer100g,
        _targetNutritionGoals = targetNutritionGoals,
        _suitableForConditions = suitableForConditions,
        _allergenWarnings = allergenWarnings;

  factory _$NutritionBasedDishImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionBasedDishImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String chineseName;
  @override
  final String? description;
// 食材配方
  final List<DishIngredient> _ingredients;
// 食材配方
  @override
  List<DishIngredient> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  final List<String> _cookingMethods;
  @override
  List<String> get cookingMethods {
    if (_cookingMethods is EqualUnmodifiableListView) return _cookingMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cookingMethods);
  }

// 营养信息（计算得出）
  final Map<String, double> _totalNutritionPer100g;
// 营养信息（计算得出）
  @override
  Map<String, double> get totalNutritionPer100g {
    if (_totalNutritionPer100g is EqualUnmodifiableMapView)
      return _totalNutritionPer100g;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_totalNutritionPer100g);
  }

  @override
  final double totalCaloriesPer100g;
  @override
  final double recommendedServingSize;
// 定价
  @override
  final double basePrice;
  @override
  final double calculatedCost;
  @override
  @JsonKey()
  final double profitMargin;
// 目标营养人群
  final List<String> _targetNutritionGoals;
// 目标营养人群
  @override
  @JsonKey()
  List<String> get targetNutritionGoals {
    if (_targetNutritionGoals is EqualUnmodifiableListView)
      return _targetNutritionGoals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetNutritionGoals);
  }

  final List<String> _suitableForConditions;
  @override
  @JsonKey()
  List<String> get suitableForConditions {
    if (_suitableForConditions is EqualUnmodifiableListView)
      return _suitableForConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suitableForConditions);
  }

  final List<String> _allergenWarnings;
  @override
  @JsonKey()
  List<String> get allergenWarnings {
    if (_allergenWarnings is EqualUnmodifiableListView)
      return _allergenWarnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergenWarnings);
  }

// 商业信息
  @override
  @JsonKey()
  final int preparationTimeMinutes;
  @override
  @JsonKey()
  final int difficultyLevel;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  @JsonKey()
  final int popularityScore;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'NutritionBasedDish(id: $id, name: $name, chineseName: $chineseName, description: $description, ingredients: $ingredients, cookingMethods: $cookingMethods, totalNutritionPer100g: $totalNutritionPer100g, totalCaloriesPer100g: $totalCaloriesPer100g, recommendedServingSize: $recommendedServingSize, basePrice: $basePrice, calculatedCost: $calculatedCost, profitMargin: $profitMargin, targetNutritionGoals: $targetNutritionGoals, suitableForConditions: $suitableForConditions, allergenWarnings: $allergenWarnings, preparationTimeMinutes: $preparationTimeMinutes, difficultyLevel: $difficultyLevel, isAvailable: $isAvailable, popularityScore: $popularityScore, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionBasedDishImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.chineseName, chineseName) ||
                other.chineseName == chineseName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            const DeepCollectionEquality()
                .equals(other._cookingMethods, _cookingMethods) &&
            const DeepCollectionEquality()
                .equals(other._totalNutritionPer100g, _totalNutritionPer100g) &&
            (identical(other.totalCaloriesPer100g, totalCaloriesPer100g) ||
                other.totalCaloriesPer100g == totalCaloriesPer100g) &&
            (identical(other.recommendedServingSize, recommendedServingSize) ||
                other.recommendedServingSize == recommendedServingSize) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.calculatedCost, calculatedCost) ||
                other.calculatedCost == calculatedCost) &&
            (identical(other.profitMargin, profitMargin) ||
                other.profitMargin == profitMargin) &&
            const DeepCollectionEquality()
                .equals(other._targetNutritionGoals, _targetNutritionGoals) &&
            const DeepCollectionEquality()
                .equals(other._suitableForConditions, _suitableForConditions) &&
            const DeepCollectionEquality()
                .equals(other._allergenWarnings, _allergenWarnings) &&
            (identical(other.preparationTimeMinutes, preparationTimeMinutes) ||
                other.preparationTimeMinutes == preparationTimeMinutes) &&
            (identical(other.difficultyLevel, difficultyLevel) ||
                other.difficultyLevel == difficultyLevel) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.popularityScore, popularityScore) ||
                other.popularityScore == popularityScore) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        chineseName,
        description,
        const DeepCollectionEquality().hash(_ingredients),
        const DeepCollectionEquality().hash(_cookingMethods),
        const DeepCollectionEquality().hash(_totalNutritionPer100g),
        totalCaloriesPer100g,
        recommendedServingSize,
        basePrice,
        calculatedCost,
        profitMargin,
        const DeepCollectionEquality().hash(_targetNutritionGoals),
        const DeepCollectionEquality().hash(_suitableForConditions),
        const DeepCollectionEquality().hash(_allergenWarnings),
        preparationTimeMinutes,
        difficultyLevel,
        isAvailable,
        popularityScore,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of NutritionBasedDish
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionBasedDishImplCopyWith<_$NutritionBasedDishImpl> get copyWith =>
      __$$NutritionBasedDishImplCopyWithImpl<_$NutritionBasedDishImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionBasedDish value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionBasedDish value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionBasedDish value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionBasedDishImplToJson(
      this,
    );
  }
}

abstract class _NutritionBasedDish implements NutritionBasedDish {
  const factory _NutritionBasedDish(
      {required final String id,
      required final String name,
      required final String chineseName,
      final String? description,
      required final List<DishIngredient> ingredients,
      required final List<String> cookingMethods,
      required final Map<String, double> totalNutritionPer100g,
      required final double totalCaloriesPer100g,
      required final double recommendedServingSize,
      required final double basePrice,
      required final double calculatedCost,
      final double profitMargin,
      final List<String> targetNutritionGoals,
      final List<String> suitableForConditions,
      final List<String> allergenWarnings,
      final int preparationTimeMinutes,
      final int difficultyLevel,
      final bool isAvailable,
      final int popularityScore,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$NutritionBasedDishImpl;

  factory _NutritionBasedDish.fromJson(Map<String, dynamic> json) =
      _$NutritionBasedDishImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get chineseName;
  @override
  String? get description; // 食材配方
  @override
  List<DishIngredient> get ingredients;
  @override
  List<String> get cookingMethods; // 营养信息（计算得出）
  @override
  Map<String, double> get totalNutritionPer100g;
  @override
  double get totalCaloriesPer100g;
  @override
  double get recommendedServingSize; // 定价
  @override
  double get basePrice;
  @override
  double get calculatedCost;
  @override
  double get profitMargin; // 目标营养人群
  @override
  List<String> get targetNutritionGoals;
  @override
  List<String> get suitableForConditions;
  @override
  List<String> get allergenWarnings; // 商业信息
  @override
  int get preparationTimeMinutes;
  @override
  int get difficultyLevel;
  @override
  bool get isAvailable;
  @override
  int get popularityScore;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of NutritionBasedDish
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionBasedDishImplCopyWith<_$NutritionBasedDishImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DishIngredient _$DishIngredientFromJson(Map<String, dynamic> json) {
  return _DishIngredient.fromJson(json);
}

/// @nodoc
mixin _$DishIngredient {
  String get ingredientId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  String get cookingMethodId => throw _privateConstructorUsedError;
  bool get isOptional => throw _privateConstructorUsedError;
  List<String> get substitutes => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DishIngredient value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DishIngredient value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DishIngredient value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this DishIngredient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DishIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DishIngredientCopyWith<DishIngredient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DishIngredientCopyWith<$Res> {
  factory $DishIngredientCopyWith(
          DishIngredient value, $Res Function(DishIngredient) then) =
      _$DishIngredientCopyWithImpl<$Res, DishIngredient>;
  @useResult
  $Res call(
      {String ingredientId,
      String name,
      double quantity,
      String unit,
      String cookingMethodId,
      bool isOptional,
      List<String> substitutes});
}

/// @nodoc
class _$DishIngredientCopyWithImpl<$Res, $Val extends DishIngredient>
    implements $DishIngredientCopyWith<$Res> {
  _$DishIngredientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DishIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ingredientId = null,
    Object? name = null,
    Object? quantity = null,
    Object? unit = null,
    Object? cookingMethodId = null,
    Object? isOptional = null,
    Object? substitutes = null,
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
      cookingMethodId: null == cookingMethodId
          ? _value.cookingMethodId
          : cookingMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      isOptional: null == isOptional
          ? _value.isOptional
          : isOptional // ignore: cast_nullable_to_non_nullable
              as bool,
      substitutes: null == substitutes
          ? _value.substitutes
          : substitutes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DishIngredientImplCopyWith<$Res>
    implements $DishIngredientCopyWith<$Res> {
  factory _$$DishIngredientImplCopyWith(_$DishIngredientImpl value,
          $Res Function(_$DishIngredientImpl) then) =
      __$$DishIngredientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String ingredientId,
      String name,
      double quantity,
      String unit,
      String cookingMethodId,
      bool isOptional,
      List<String> substitutes});
}

/// @nodoc
class __$$DishIngredientImplCopyWithImpl<$Res>
    extends _$DishIngredientCopyWithImpl<$Res, _$DishIngredientImpl>
    implements _$$DishIngredientImplCopyWith<$Res> {
  __$$DishIngredientImplCopyWithImpl(
      _$DishIngredientImpl _value, $Res Function(_$DishIngredientImpl) _then)
      : super(_value, _then);

  /// Create a copy of DishIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ingredientId = null,
    Object? name = null,
    Object? quantity = null,
    Object? unit = null,
    Object? cookingMethodId = null,
    Object? isOptional = null,
    Object? substitutes = null,
  }) {
    return _then(_$DishIngredientImpl(
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
      cookingMethodId: null == cookingMethodId
          ? _value.cookingMethodId
          : cookingMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      isOptional: null == isOptional
          ? _value.isOptional
          : isOptional // ignore: cast_nullable_to_non_nullable
              as bool,
      substitutes: null == substitutes
          ? _value._substitutes
          : substitutes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DishIngredientImpl implements _DishIngredient {
  const _$DishIngredientImpl(
      {required this.ingredientId,
      required this.name,
      required this.quantity,
      required this.unit,
      required this.cookingMethodId,
      this.isOptional = false,
      final List<String> substitutes = const []})
      : _substitutes = substitutes;

  factory _$DishIngredientImpl.fromJson(Map<String, dynamic> json) =>
      _$$DishIngredientImplFromJson(json);

  @override
  final String ingredientId;
  @override
  final String name;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  final String cookingMethodId;
  @override
  @JsonKey()
  final bool isOptional;
  final List<String> _substitutes;
  @override
  @JsonKey()
  List<String> get substitutes {
    if (_substitutes is EqualUnmodifiableListView) return _substitutes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_substitutes);
  }

  @override
  String toString() {
    return 'DishIngredient(ingredientId: $ingredientId, name: $name, quantity: $quantity, unit: $unit, cookingMethodId: $cookingMethodId, isOptional: $isOptional, substitutes: $substitutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DishIngredientImpl &&
            (identical(other.ingredientId, ingredientId) ||
                other.ingredientId == ingredientId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.cookingMethodId, cookingMethodId) ||
                other.cookingMethodId == cookingMethodId) &&
            (identical(other.isOptional, isOptional) ||
                other.isOptional == isOptional) &&
            const DeepCollectionEquality()
                .equals(other._substitutes, _substitutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      ingredientId,
      name,
      quantity,
      unit,
      cookingMethodId,
      isOptional,
      const DeepCollectionEquality().hash(_substitutes));

  /// Create a copy of DishIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DishIngredientImplCopyWith<_$DishIngredientImpl> get copyWith =>
      __$$DishIngredientImplCopyWithImpl<_$DishIngredientImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DishIngredient value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DishIngredient value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DishIngredient value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DishIngredientImplToJson(
      this,
    );
  }
}

abstract class _DishIngredient implements DishIngredient {
  const factory _DishIngredient(
      {required final String ingredientId,
      required final String name,
      required final double quantity,
      required final String unit,
      required final String cookingMethodId,
      final bool isOptional,
      final List<String> substitutes}) = _$DishIngredientImpl;

  factory _DishIngredient.fromJson(Map<String, dynamic> json) =
      _$DishIngredientImpl.fromJson;

  @override
  String get ingredientId;
  @override
  String get name;
  @override
  double get quantity;
  @override
  String get unit;
  @override
  String get cookingMethodId;
  @override
  bool get isOptional;
  @override
  List<String> get substitutes;

  /// Create a copy of DishIngredient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DishIngredientImplCopyWith<_$DishIngredientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryTransaction _$InventoryTransactionFromJson(Map<String, dynamic> json) {
  return _InventoryTransaction.fromJson(json);
}

/// @nodoc
mixin _$InventoryTransaction {
  String get id => throw _privateConstructorUsedError;
  String get ingredientId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // restock, usage, waste, adjustment
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  String? get orderId => throw _privateConstructorUsedError;
  String? get supplierId => throw _privateConstructorUsedError;
  double get costPerUnit => throw _privateConstructorUsedError;
  String get operatorId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError; // 库存快照
  double get stockBefore => throw _privateConstructorUsedError;
  double get stockAfter => throw _privateConstructorUsedError; // 附加信息
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_InventoryTransaction value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InventoryTransaction value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InventoryTransaction value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this InventoryTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryTransactionCopyWith<InventoryTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryTransactionCopyWith<$Res> {
  factory $InventoryTransactionCopyWith(InventoryTransaction value,
          $Res Function(InventoryTransaction) then) =
      _$InventoryTransactionCopyWithImpl<$Res, InventoryTransaction>;
  @useResult
  $Res call(
      {String id,
      String ingredientId,
      String type,
      double quantity,
      String unit,
      String? reason,
      String? orderId,
      String? supplierId,
      double costPerUnit,
      String operatorId,
      DateTime timestamp,
      double stockBefore,
      double stockAfter,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$InventoryTransactionCopyWithImpl<$Res,
        $Val extends InventoryTransaction>
    implements $InventoryTransactionCopyWith<$Res> {
  _$InventoryTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ingredientId = null,
    Object? type = null,
    Object? quantity = null,
    Object? unit = null,
    Object? reason = freezed,
    Object? orderId = freezed,
    Object? supplierId = freezed,
    Object? costPerUnit = null,
    Object? operatorId = null,
    Object? timestamp = null,
    Object? stockBefore = null,
    Object? stockAfter = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      costPerUnit: null == costPerUnit
          ? _value.costPerUnit
          : costPerUnit // ignore: cast_nullable_to_non_nullable
              as double,
      operatorId: null == operatorId
          ? _value.operatorId
          : operatorId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      stockBefore: null == stockBefore
          ? _value.stockBefore
          : stockBefore // ignore: cast_nullable_to_non_nullable
              as double,
      stockAfter: null == stockAfter
          ? _value.stockAfter
          : stockAfter // ignore: cast_nullable_to_non_nullable
              as double,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryTransactionImplCopyWith<$Res>
    implements $InventoryTransactionCopyWith<$Res> {
  factory _$$InventoryTransactionImplCopyWith(_$InventoryTransactionImpl value,
          $Res Function(_$InventoryTransactionImpl) then) =
      __$$InventoryTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ingredientId,
      String type,
      double quantity,
      String unit,
      String? reason,
      String? orderId,
      String? supplierId,
      double costPerUnit,
      String operatorId,
      DateTime timestamp,
      double stockBefore,
      double stockAfter,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$InventoryTransactionImplCopyWithImpl<$Res>
    extends _$InventoryTransactionCopyWithImpl<$Res, _$InventoryTransactionImpl>
    implements _$$InventoryTransactionImplCopyWith<$Res> {
  __$$InventoryTransactionImplCopyWithImpl(_$InventoryTransactionImpl _value,
      $Res Function(_$InventoryTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ingredientId = null,
    Object? type = null,
    Object? quantity = null,
    Object? unit = null,
    Object? reason = freezed,
    Object? orderId = freezed,
    Object? supplierId = freezed,
    Object? costPerUnit = null,
    Object? operatorId = null,
    Object? timestamp = null,
    Object? stockBefore = null,
    Object? stockAfter = null,
    Object? metadata = freezed,
  }) {
    return _then(_$InventoryTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      costPerUnit: null == costPerUnit
          ? _value.costPerUnit
          : costPerUnit // ignore: cast_nullable_to_non_nullable
              as double,
      operatorId: null == operatorId
          ? _value.operatorId
          : operatorId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      stockBefore: null == stockBefore
          ? _value.stockBefore
          : stockBefore // ignore: cast_nullable_to_non_nullable
              as double,
      stockAfter: null == stockAfter
          ? _value.stockAfter
          : stockAfter // ignore: cast_nullable_to_non_nullable
              as double,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryTransactionImpl implements _InventoryTransaction {
  const _$InventoryTransactionImpl(
      {required this.id,
      required this.ingredientId,
      required this.type,
      required this.quantity,
      required this.unit,
      this.reason,
      this.orderId,
      this.supplierId,
      required this.costPerUnit,
      required this.operatorId,
      required this.timestamp,
      required this.stockBefore,
      required this.stockAfter,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$InventoryTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String ingredientId;
  @override
  final String type;
// restock, usage, waste, adjustment
  @override
  final double quantity;
  @override
  final String unit;
  @override
  final String? reason;
  @override
  final String? orderId;
  @override
  final String? supplierId;
  @override
  final double costPerUnit;
  @override
  final String operatorId;
  @override
  final DateTime timestamp;
// 库存快照
  @override
  final double stockBefore;
  @override
  final double stockAfter;
// 附加信息
  final Map<String, dynamic>? _metadata;
// 附加信息
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'InventoryTransaction(id: $id, ingredientId: $ingredientId, type: $type, quantity: $quantity, unit: $unit, reason: $reason, orderId: $orderId, supplierId: $supplierId, costPerUnit: $costPerUnit, operatorId: $operatorId, timestamp: $timestamp, stockBefore: $stockBefore, stockAfter: $stockAfter, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ingredientId, ingredientId) ||
                other.ingredientId == ingredientId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.costPerUnit, costPerUnit) ||
                other.costPerUnit == costPerUnit) &&
            (identical(other.operatorId, operatorId) ||
                other.operatorId == operatorId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.stockBefore, stockBefore) ||
                other.stockBefore == stockBefore) &&
            (identical(other.stockAfter, stockAfter) ||
                other.stockAfter == stockAfter) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      ingredientId,
      type,
      quantity,
      unit,
      reason,
      orderId,
      supplierId,
      costPerUnit,
      operatorId,
      timestamp,
      stockBefore,
      stockAfter,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of InventoryTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryTransactionImplCopyWith<_$InventoryTransactionImpl>
      get copyWith =>
          __$$InventoryTransactionImplCopyWithImpl<_$InventoryTransactionImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_InventoryTransaction value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InventoryTransaction value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InventoryTransaction value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryTransactionImplToJson(
      this,
    );
  }
}

abstract class _InventoryTransaction implements InventoryTransaction {
  const factory _InventoryTransaction(
      {required final String id,
      required final String ingredientId,
      required final String type,
      required final double quantity,
      required final String unit,
      final String? reason,
      final String? orderId,
      final String? supplierId,
      required final double costPerUnit,
      required final String operatorId,
      required final DateTime timestamp,
      required final double stockBefore,
      required final double stockAfter,
      final Map<String, dynamic>? metadata}) = _$InventoryTransactionImpl;

  factory _InventoryTransaction.fromJson(Map<String, dynamic> json) =
      _$InventoryTransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get ingredientId;
  @override
  String get type; // restock, usage, waste, adjustment
  @override
  double get quantity;
  @override
  String get unit;
  @override
  String? get reason;
  @override
  String? get orderId;
  @override
  String? get supplierId;
  @override
  double get costPerUnit;
  @override
  String get operatorId;
  @override
  DateTime get timestamp; // 库存快照
  @override
  double get stockBefore;
  @override
  double get stockAfter; // 附加信息
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of InventoryTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryTransactionImplCopyWith<_$InventoryTransactionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

InventoryAlert _$InventoryAlertFromJson(Map<String, dynamic> json) {
  return _InventoryAlert.fromJson(json);
}

/// @nodoc
mixin _$InventoryAlert {
  String get id => throw _privateConstructorUsedError;
  String get ingredientId => throw _privateConstructorUsedError;
  String get ingredientName => throw _privateConstructorUsedError;
  String get alertType =>
      throw _privateConstructorUsedError; // low_stock, expired, quality_issue
  String get severity =>
      throw _privateConstructorUsedError; // low, medium, high, critical
  String get message => throw _privateConstructorUsedError;
  bool get isResolved => throw _privateConstructorUsedError;
  String? get resolvedBy => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError; // 预警数据
  double? get currentStock => throw _privateConstructorUsedError;
  double? get threshold => throw _privateConstructorUsedError;
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  String? get qualityStatus => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_InventoryAlert value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InventoryAlert value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InventoryAlert value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this InventoryAlert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryAlertCopyWith<InventoryAlert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryAlertCopyWith<$Res> {
  factory $InventoryAlertCopyWith(
          InventoryAlert value, $Res Function(InventoryAlert) then) =
      _$InventoryAlertCopyWithImpl<$Res, InventoryAlert>;
  @useResult
  $Res call(
      {String id,
      String ingredientId,
      String ingredientName,
      String alertType,
      String severity,
      String message,
      bool isResolved,
      String? resolvedBy,
      DateTime? resolvedAt,
      DateTime createdAt,
      double? currentStock,
      double? threshold,
      DateTime? expiryDate,
      String? qualityStatus});
}

/// @nodoc
class _$InventoryAlertCopyWithImpl<$Res, $Val extends InventoryAlert>
    implements $InventoryAlertCopyWith<$Res> {
  _$InventoryAlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ingredientId = null,
    Object? ingredientName = null,
    Object? alertType = null,
    Object? severity = null,
    Object? message = null,
    Object? isResolved = null,
    Object? resolvedBy = freezed,
    Object? resolvedAt = freezed,
    Object? createdAt = null,
    Object? currentStock = freezed,
    Object? threshold = freezed,
    Object? expiryDate = freezed,
    Object? qualityStatus = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientName: null == ingredientName
          ? _value.ingredientName
          : ingredientName // ignore: cast_nullable_to_non_nullable
              as String,
      alertType: null == alertType
          ? _value.alertType
          : alertType // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      resolvedBy: freezed == resolvedBy
          ? _value.resolvedBy
          : resolvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentStock: freezed == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as double?,
      threshold: freezed == threshold
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as double?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      qualityStatus: freezed == qualityStatus
          ? _value.qualityStatus
          : qualityStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryAlertImplCopyWith<$Res>
    implements $InventoryAlertCopyWith<$Res> {
  factory _$$InventoryAlertImplCopyWith(_$InventoryAlertImpl value,
          $Res Function(_$InventoryAlertImpl) then) =
      __$$InventoryAlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ingredientId,
      String ingredientName,
      String alertType,
      String severity,
      String message,
      bool isResolved,
      String? resolvedBy,
      DateTime? resolvedAt,
      DateTime createdAt,
      double? currentStock,
      double? threshold,
      DateTime? expiryDate,
      String? qualityStatus});
}

/// @nodoc
class __$$InventoryAlertImplCopyWithImpl<$Res>
    extends _$InventoryAlertCopyWithImpl<$Res, _$InventoryAlertImpl>
    implements _$$InventoryAlertImplCopyWith<$Res> {
  __$$InventoryAlertImplCopyWithImpl(
      _$InventoryAlertImpl _value, $Res Function(_$InventoryAlertImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ingredientId = null,
    Object? ingredientName = null,
    Object? alertType = null,
    Object? severity = null,
    Object? message = null,
    Object? isResolved = null,
    Object? resolvedBy = freezed,
    Object? resolvedAt = freezed,
    Object? createdAt = null,
    Object? currentStock = freezed,
    Object? threshold = freezed,
    Object? expiryDate = freezed,
    Object? qualityStatus = freezed,
  }) {
    return _then(_$InventoryAlertImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientName: null == ingredientName
          ? _value.ingredientName
          : ingredientName // ignore: cast_nullable_to_non_nullable
              as String,
      alertType: null == alertType
          ? _value.alertType
          : alertType // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      resolvedBy: freezed == resolvedBy
          ? _value.resolvedBy
          : resolvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentStock: freezed == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as double?,
      threshold: freezed == threshold
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as double?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      qualityStatus: freezed == qualityStatus
          ? _value.qualityStatus
          : qualityStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryAlertImpl implements _InventoryAlert {
  const _$InventoryAlertImpl(
      {required this.id,
      required this.ingredientId,
      required this.ingredientName,
      required this.alertType,
      required this.severity,
      required this.message,
      this.isResolved = false,
      this.resolvedBy,
      this.resolvedAt,
      required this.createdAt,
      this.currentStock,
      this.threshold,
      this.expiryDate,
      this.qualityStatus});

  factory _$InventoryAlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryAlertImplFromJson(json);

  @override
  final String id;
  @override
  final String ingredientId;
  @override
  final String ingredientName;
  @override
  final String alertType;
// low_stock, expired, quality_issue
  @override
  final String severity;
// low, medium, high, critical
  @override
  final String message;
  @override
  @JsonKey()
  final bool isResolved;
  @override
  final String? resolvedBy;
  @override
  final DateTime? resolvedAt;
  @override
  final DateTime createdAt;
// 预警数据
  @override
  final double? currentStock;
  @override
  final double? threshold;
  @override
  final DateTime? expiryDate;
  @override
  final String? qualityStatus;

  @override
  String toString() {
    return 'InventoryAlert(id: $id, ingredientId: $ingredientId, ingredientName: $ingredientName, alertType: $alertType, severity: $severity, message: $message, isResolved: $isResolved, resolvedBy: $resolvedBy, resolvedAt: $resolvedAt, createdAt: $createdAt, currentStock: $currentStock, threshold: $threshold, expiryDate: $expiryDate, qualityStatus: $qualityStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryAlertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ingredientId, ingredientId) ||
                other.ingredientId == ingredientId) &&
            (identical(other.ingredientName, ingredientName) ||
                other.ingredientName == ingredientName) &&
            (identical(other.alertType, alertType) ||
                other.alertType == alertType) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isResolved, isResolved) ||
                other.isResolved == isResolved) &&
            (identical(other.resolvedBy, resolvedBy) ||
                other.resolvedBy == resolvedBy) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.qualityStatus, qualityStatus) ||
                other.qualityStatus == qualityStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      ingredientId,
      ingredientName,
      alertType,
      severity,
      message,
      isResolved,
      resolvedBy,
      resolvedAt,
      createdAt,
      currentStock,
      threshold,
      expiryDate,
      qualityStatus);

  /// Create a copy of InventoryAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryAlertImplCopyWith<_$InventoryAlertImpl> get copyWith =>
      __$$InventoryAlertImplCopyWithImpl<_$InventoryAlertImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_InventoryAlert value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InventoryAlert value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InventoryAlert value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryAlertImplToJson(
      this,
    );
  }
}

abstract class _InventoryAlert implements InventoryAlert {
  const factory _InventoryAlert(
      {required final String id,
      required final String ingredientId,
      required final String ingredientName,
      required final String alertType,
      required final String severity,
      required final String message,
      final bool isResolved,
      final String? resolvedBy,
      final DateTime? resolvedAt,
      required final DateTime createdAt,
      final double? currentStock,
      final double? threshold,
      final DateTime? expiryDate,
      final String? qualityStatus}) = _$InventoryAlertImpl;

  factory _InventoryAlert.fromJson(Map<String, dynamic> json) =
      _$InventoryAlertImpl.fromJson;

  @override
  String get id;
  @override
  String get ingredientId;
  @override
  String get ingredientName;
  @override
  String get alertType; // low_stock, expired, quality_issue
  @override
  String get severity; // low, medium, high, critical
  @override
  String get message;
  @override
  bool get isResolved;
  @override
  String? get resolvedBy;
  @override
  DateTime? get resolvedAt;
  @override
  DateTime get createdAt; // 预警数据
  @override
  double? get currentStock;
  @override
  double? get threshold;
  @override
  DateTime? get expiryDate;
  @override
  String? get qualityStatus;

  /// Create a copy of InventoryAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryAlertImplCopyWith<_$InventoryAlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionMenuAnalysis _$NutritionMenuAnalysisFromJson(
    Map<String, dynamic> json) {
  return _NutritionMenuAnalysis.fromJson(json);
}

/// @nodoc
mixin _$NutritionMenuAnalysis {
  String get merchantId => throw _privateConstructorUsedError;
  DateTime get analysisDate => throw _privateConstructorUsedError; // 营养覆盖度分析
  Map<String, double> get nutritionElementCoverage =>
      throw _privateConstructorUsedError;
  List<String> get missingNutritionElements =>
      throw _privateConstructorUsedError;
  List<String> get overrepresentedElements =>
      throw _privateConstructorUsedError; // 成本效益分析
  double get averageCostPerCalorie => throw _privateConstructorUsedError;
  double get averageCostPerProteinGram => throw _privateConstructorUsedError;
  Map<String, double> get costEfficiencyByCategory =>
      throw _privateConstructorUsedError; // 菜单建议
  List<String> get recommendedIngredients => throw _privateConstructorUsedError;
  List<String> get costOptimizationSuggestions =>
      throw _privateConstructorUsedError;
  List<String> get nutritionBalanceSuggestions =>
      throw _privateConstructorUsedError; // 市场分析
  double get competitivenessScore => throw _privateConstructorUsedError;
  List<String> get marketOpportunities => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionMenuAnalysis value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionMenuAnalysis value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionMenuAnalysis value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionMenuAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionMenuAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionMenuAnalysisCopyWith<NutritionMenuAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionMenuAnalysisCopyWith<$Res> {
  factory $NutritionMenuAnalysisCopyWith(NutritionMenuAnalysis value,
          $Res Function(NutritionMenuAnalysis) then) =
      _$NutritionMenuAnalysisCopyWithImpl<$Res, NutritionMenuAnalysis>;
  @useResult
  $Res call(
      {String merchantId,
      DateTime analysisDate,
      Map<String, double> nutritionElementCoverage,
      List<String> missingNutritionElements,
      List<String> overrepresentedElements,
      double averageCostPerCalorie,
      double averageCostPerProteinGram,
      Map<String, double> costEfficiencyByCategory,
      List<String> recommendedIngredients,
      List<String> costOptimizationSuggestions,
      List<String> nutritionBalanceSuggestions,
      double competitivenessScore,
      List<String> marketOpportunities});
}

/// @nodoc
class _$NutritionMenuAnalysisCopyWithImpl<$Res,
        $Val extends NutritionMenuAnalysis>
    implements $NutritionMenuAnalysisCopyWith<$Res> {
  _$NutritionMenuAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionMenuAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchantId = null,
    Object? analysisDate = null,
    Object? nutritionElementCoverage = null,
    Object? missingNutritionElements = null,
    Object? overrepresentedElements = null,
    Object? averageCostPerCalorie = null,
    Object? averageCostPerProteinGram = null,
    Object? costEfficiencyByCategory = null,
    Object? recommendedIngredients = null,
    Object? costOptimizationSuggestions = null,
    Object? nutritionBalanceSuggestions = null,
    Object? competitivenessScore = null,
    Object? marketOpportunities = null,
  }) {
    return _then(_value.copyWith(
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      analysisDate: null == analysisDate
          ? _value.analysisDate
          : analysisDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nutritionElementCoverage: null == nutritionElementCoverage
          ? _value.nutritionElementCoverage
          : nutritionElementCoverage // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      missingNutritionElements: null == missingNutritionElements
          ? _value.missingNutritionElements
          : missingNutritionElements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      overrepresentedElements: null == overrepresentedElements
          ? _value.overrepresentedElements
          : overrepresentedElements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      averageCostPerCalorie: null == averageCostPerCalorie
          ? _value.averageCostPerCalorie
          : averageCostPerCalorie // ignore: cast_nullable_to_non_nullable
              as double,
      averageCostPerProteinGram: null == averageCostPerProteinGram
          ? _value.averageCostPerProteinGram
          : averageCostPerProteinGram // ignore: cast_nullable_to_non_nullable
              as double,
      costEfficiencyByCategory: null == costEfficiencyByCategory
          ? _value.costEfficiencyByCategory
          : costEfficiencyByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      recommendedIngredients: null == recommendedIngredients
          ? _value.recommendedIngredients
          : recommendedIngredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      costOptimizationSuggestions: null == costOptimizationSuggestions
          ? _value.costOptimizationSuggestions
          : costOptimizationSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionBalanceSuggestions: null == nutritionBalanceSuggestions
          ? _value.nutritionBalanceSuggestions
          : nutritionBalanceSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      competitivenessScore: null == competitivenessScore
          ? _value.competitivenessScore
          : competitivenessScore // ignore: cast_nullable_to_non_nullable
              as double,
      marketOpportunities: null == marketOpportunities
          ? _value.marketOpportunities
          : marketOpportunities // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionMenuAnalysisImplCopyWith<$Res>
    implements $NutritionMenuAnalysisCopyWith<$Res> {
  factory _$$NutritionMenuAnalysisImplCopyWith(
          _$NutritionMenuAnalysisImpl value,
          $Res Function(_$NutritionMenuAnalysisImpl) then) =
      __$$NutritionMenuAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String merchantId,
      DateTime analysisDate,
      Map<String, double> nutritionElementCoverage,
      List<String> missingNutritionElements,
      List<String> overrepresentedElements,
      double averageCostPerCalorie,
      double averageCostPerProteinGram,
      Map<String, double> costEfficiencyByCategory,
      List<String> recommendedIngredients,
      List<String> costOptimizationSuggestions,
      List<String> nutritionBalanceSuggestions,
      double competitivenessScore,
      List<String> marketOpportunities});
}

/// @nodoc
class __$$NutritionMenuAnalysisImplCopyWithImpl<$Res>
    extends _$NutritionMenuAnalysisCopyWithImpl<$Res,
        _$NutritionMenuAnalysisImpl>
    implements _$$NutritionMenuAnalysisImplCopyWith<$Res> {
  __$$NutritionMenuAnalysisImplCopyWithImpl(_$NutritionMenuAnalysisImpl _value,
      $Res Function(_$NutritionMenuAnalysisImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionMenuAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchantId = null,
    Object? analysisDate = null,
    Object? nutritionElementCoverage = null,
    Object? missingNutritionElements = null,
    Object? overrepresentedElements = null,
    Object? averageCostPerCalorie = null,
    Object? averageCostPerProteinGram = null,
    Object? costEfficiencyByCategory = null,
    Object? recommendedIngredients = null,
    Object? costOptimizationSuggestions = null,
    Object? nutritionBalanceSuggestions = null,
    Object? competitivenessScore = null,
    Object? marketOpportunities = null,
  }) {
    return _then(_$NutritionMenuAnalysisImpl(
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      analysisDate: null == analysisDate
          ? _value.analysisDate
          : analysisDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nutritionElementCoverage: null == nutritionElementCoverage
          ? _value._nutritionElementCoverage
          : nutritionElementCoverage // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      missingNutritionElements: null == missingNutritionElements
          ? _value._missingNutritionElements
          : missingNutritionElements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      overrepresentedElements: null == overrepresentedElements
          ? _value._overrepresentedElements
          : overrepresentedElements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      averageCostPerCalorie: null == averageCostPerCalorie
          ? _value.averageCostPerCalorie
          : averageCostPerCalorie // ignore: cast_nullable_to_non_nullable
              as double,
      averageCostPerProteinGram: null == averageCostPerProteinGram
          ? _value.averageCostPerProteinGram
          : averageCostPerProteinGram // ignore: cast_nullable_to_non_nullable
              as double,
      costEfficiencyByCategory: null == costEfficiencyByCategory
          ? _value._costEfficiencyByCategory
          : costEfficiencyByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      recommendedIngredients: null == recommendedIngredients
          ? _value._recommendedIngredients
          : recommendedIngredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      costOptimizationSuggestions: null == costOptimizationSuggestions
          ? _value._costOptimizationSuggestions
          : costOptimizationSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionBalanceSuggestions: null == nutritionBalanceSuggestions
          ? _value._nutritionBalanceSuggestions
          : nutritionBalanceSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      competitivenessScore: null == competitivenessScore
          ? _value.competitivenessScore
          : competitivenessScore // ignore: cast_nullable_to_non_nullable
              as double,
      marketOpportunities: null == marketOpportunities
          ? _value._marketOpportunities
          : marketOpportunities // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionMenuAnalysisImpl implements _NutritionMenuAnalysis {
  const _$NutritionMenuAnalysisImpl(
      {required this.merchantId,
      required this.analysisDate,
      required final Map<String, double> nutritionElementCoverage,
      required final List<String> missingNutritionElements,
      required final List<String> overrepresentedElements,
      required this.averageCostPerCalorie,
      required this.averageCostPerProteinGram,
      required final Map<String, double> costEfficiencyByCategory,
      required final List<String> recommendedIngredients,
      required final List<String> costOptimizationSuggestions,
      required final List<String> nutritionBalanceSuggestions,
      this.competitivenessScore = 0.0,
      required final List<String> marketOpportunities})
      : _nutritionElementCoverage = nutritionElementCoverage,
        _missingNutritionElements = missingNutritionElements,
        _overrepresentedElements = overrepresentedElements,
        _costEfficiencyByCategory = costEfficiencyByCategory,
        _recommendedIngredients = recommendedIngredients,
        _costOptimizationSuggestions = costOptimizationSuggestions,
        _nutritionBalanceSuggestions = nutritionBalanceSuggestions,
        _marketOpportunities = marketOpportunities;

  factory _$NutritionMenuAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionMenuAnalysisImplFromJson(json);

  @override
  final String merchantId;
  @override
  final DateTime analysisDate;
// 营养覆盖度分析
  final Map<String, double> _nutritionElementCoverage;
// 营养覆盖度分析
  @override
  Map<String, double> get nutritionElementCoverage {
    if (_nutritionElementCoverage is EqualUnmodifiableMapView)
      return _nutritionElementCoverage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionElementCoverage);
  }

  final List<String> _missingNutritionElements;
  @override
  List<String> get missingNutritionElements {
    if (_missingNutritionElements is EqualUnmodifiableListView)
      return _missingNutritionElements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_missingNutritionElements);
  }

  final List<String> _overrepresentedElements;
  @override
  List<String> get overrepresentedElements {
    if (_overrepresentedElements is EqualUnmodifiableListView)
      return _overrepresentedElements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_overrepresentedElements);
  }

// 成本效益分析
  @override
  final double averageCostPerCalorie;
  @override
  final double averageCostPerProteinGram;
  final Map<String, double> _costEfficiencyByCategory;
  @override
  Map<String, double> get costEfficiencyByCategory {
    if (_costEfficiencyByCategory is EqualUnmodifiableMapView)
      return _costEfficiencyByCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_costEfficiencyByCategory);
  }

// 菜单建议
  final List<String> _recommendedIngredients;
// 菜单建议
  @override
  List<String> get recommendedIngredients {
    if (_recommendedIngredients is EqualUnmodifiableListView)
      return _recommendedIngredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedIngredients);
  }

  final List<String> _costOptimizationSuggestions;
  @override
  List<String> get costOptimizationSuggestions {
    if (_costOptimizationSuggestions is EqualUnmodifiableListView)
      return _costOptimizationSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_costOptimizationSuggestions);
  }

  final List<String> _nutritionBalanceSuggestions;
  @override
  List<String> get nutritionBalanceSuggestions {
    if (_nutritionBalanceSuggestions is EqualUnmodifiableListView)
      return _nutritionBalanceSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionBalanceSuggestions);
  }

// 市场分析
  @override
  @JsonKey()
  final double competitivenessScore;
  final List<String> _marketOpportunities;
  @override
  List<String> get marketOpportunities {
    if (_marketOpportunities is EqualUnmodifiableListView)
      return _marketOpportunities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_marketOpportunities);
  }

  @override
  String toString() {
    return 'NutritionMenuAnalysis(merchantId: $merchantId, analysisDate: $analysisDate, nutritionElementCoverage: $nutritionElementCoverage, missingNutritionElements: $missingNutritionElements, overrepresentedElements: $overrepresentedElements, averageCostPerCalorie: $averageCostPerCalorie, averageCostPerProteinGram: $averageCostPerProteinGram, costEfficiencyByCategory: $costEfficiencyByCategory, recommendedIngredients: $recommendedIngredients, costOptimizationSuggestions: $costOptimizationSuggestions, nutritionBalanceSuggestions: $nutritionBalanceSuggestions, competitivenessScore: $competitivenessScore, marketOpportunities: $marketOpportunities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionMenuAnalysisImpl &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.analysisDate, analysisDate) ||
                other.analysisDate == analysisDate) &&
            const DeepCollectionEquality().equals(
                other._nutritionElementCoverage, _nutritionElementCoverage) &&
            const DeepCollectionEquality().equals(
                other._missingNutritionElements, _missingNutritionElements) &&
            const DeepCollectionEquality().equals(
                other._overrepresentedElements, _overrepresentedElements) &&
            (identical(other.averageCostPerCalorie, averageCostPerCalorie) ||
                other.averageCostPerCalorie == averageCostPerCalorie) &&
            (identical(other.averageCostPerProteinGram,
                    averageCostPerProteinGram) ||
                other.averageCostPerProteinGram == averageCostPerProteinGram) &&
            const DeepCollectionEquality().equals(
                other._costEfficiencyByCategory, _costEfficiencyByCategory) &&
            const DeepCollectionEquality().equals(
                other._recommendedIngredients, _recommendedIngredients) &&
            const DeepCollectionEquality().equals(
                other._costOptimizationSuggestions,
                _costOptimizationSuggestions) &&
            const DeepCollectionEquality().equals(
                other._nutritionBalanceSuggestions,
                _nutritionBalanceSuggestions) &&
            (identical(other.competitivenessScore, competitivenessScore) ||
                other.competitivenessScore == competitivenessScore) &&
            const DeepCollectionEquality()
                .equals(other._marketOpportunities, _marketOpportunities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      merchantId,
      analysisDate,
      const DeepCollectionEquality().hash(_nutritionElementCoverage),
      const DeepCollectionEquality().hash(_missingNutritionElements),
      const DeepCollectionEquality().hash(_overrepresentedElements),
      averageCostPerCalorie,
      averageCostPerProteinGram,
      const DeepCollectionEquality().hash(_costEfficiencyByCategory),
      const DeepCollectionEquality().hash(_recommendedIngredients),
      const DeepCollectionEquality().hash(_costOptimizationSuggestions),
      const DeepCollectionEquality().hash(_nutritionBalanceSuggestions),
      competitivenessScore,
      const DeepCollectionEquality().hash(_marketOpportunities));

  /// Create a copy of NutritionMenuAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionMenuAnalysisImplCopyWith<_$NutritionMenuAnalysisImpl>
      get copyWith => __$$NutritionMenuAnalysisImplCopyWithImpl<
          _$NutritionMenuAnalysisImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionMenuAnalysis value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionMenuAnalysis value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionMenuAnalysis value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionMenuAnalysisImplToJson(
      this,
    );
  }
}

abstract class _NutritionMenuAnalysis implements NutritionMenuAnalysis {
  const factory _NutritionMenuAnalysis(
          {required final String merchantId,
          required final DateTime analysisDate,
          required final Map<String, double> nutritionElementCoverage,
          required final List<String> missingNutritionElements,
          required final List<String> overrepresentedElements,
          required final double averageCostPerCalorie,
          required final double averageCostPerProteinGram,
          required final Map<String, double> costEfficiencyByCategory,
          required final List<String> recommendedIngredients,
          required final List<String> costOptimizationSuggestions,
          required final List<String> nutritionBalanceSuggestions,
          final double competitivenessScore,
          required final List<String> marketOpportunities}) =
      _$NutritionMenuAnalysisImpl;

  factory _NutritionMenuAnalysis.fromJson(Map<String, dynamic> json) =
      _$NutritionMenuAnalysisImpl.fromJson;

  @override
  String get merchantId;
  @override
  DateTime get analysisDate; // 营养覆盖度分析
  @override
  Map<String, double> get nutritionElementCoverage;
  @override
  List<String> get missingNutritionElements;
  @override
  List<String> get overrepresentedElements; // 成本效益分析
  @override
  double get averageCostPerCalorie;
  @override
  double get averageCostPerProteinGram;
  @override
  Map<String, double> get costEfficiencyByCategory; // 菜单建议
  @override
  List<String> get recommendedIngredients;
  @override
  List<String> get costOptimizationSuggestions;
  @override
  List<String> get nutritionBalanceSuggestions; // 市场分析
  @override
  double get competitivenessScore;
  @override
  List<String> get marketOpportunities;

  /// Create a copy of NutritionMenuAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionMenuAnalysisImplCopyWith<_$NutritionMenuAnalysisImpl>
      get copyWith => throw _privateConstructorUsedError;
}
