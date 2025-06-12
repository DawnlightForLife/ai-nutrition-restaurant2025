// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MerchantModel _$MerchantModelFromJson(Map<String, dynamic> json) {
  return _MerchantModel.fromJson(json);
}

/// @nodoc
mixin _$MerchantModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'businessName')
  String? get businessName => throw _privateConstructorUsedError;
  @JsonKey(name: 'businessType')
  String? get businessType => throw _privateConstructorUsedError;
  @JsonKey(name: 'registrationNumber')
  String? get registrationNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'taxId')
  String? get taxId => throw _privateConstructorUsedError;
  ContactInfo? get contact => throw _privateConstructorUsedError;
  AddressInfo? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'businessProfile')
  BusinessProfile? get businessProfile => throw _privateConstructorUsedError;
  @JsonKey(name: 'nutritionFeatures')
  NutritionFeatures? get nutritionFeatures =>
      throw _privateConstructorUsedError;
  VerificationInfo? get verification => throw _privateConstructorUsedError;
  @JsonKey(name: 'accountStatus')
  AccountStatus? get accountStatus => throw _privateConstructorUsedError;
  MerchantStats? get stats => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'isOpen')
  bool get isOpen => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MerchantModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MerchantModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MerchantModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MerchantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MerchantModelCopyWith<MerchantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MerchantModelCopyWith<$Res> {
  factory $MerchantModelCopyWith(
          MerchantModel value, $Res Function(MerchantModel) then) =
      _$MerchantModelCopyWithImpl<$Res, MerchantModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'businessName') String? businessName,
      @JsonKey(name: 'businessType') String? businessType,
      @JsonKey(name: 'registrationNumber') String? registrationNumber,
      @JsonKey(name: 'taxId') String? taxId,
      ContactInfo? contact,
      AddressInfo? address,
      @JsonKey(name: 'businessProfile') BusinessProfile? businessProfile,
      @JsonKey(name: 'nutritionFeatures') NutritionFeatures? nutritionFeatures,
      VerificationInfo? verification,
      @JsonKey(name: 'accountStatus') AccountStatus? accountStatus,
      MerchantStats? stats,
      @JsonKey(name: 'createdAt') DateTime? createdAt,
      @JsonKey(name: 'updatedAt') DateTime? updatedAt,
      @JsonKey(name: 'isOpen') bool isOpen});

  $ContactInfoCopyWith<$Res>? get contact;
  $AddressInfoCopyWith<$Res>? get address;
  $BusinessProfileCopyWith<$Res>? get businessProfile;
  $NutritionFeaturesCopyWith<$Res>? get nutritionFeatures;
  $VerificationInfoCopyWith<$Res>? get verification;
  $AccountStatusCopyWith<$Res>? get accountStatus;
  $MerchantStatsCopyWith<$Res>? get stats;
}

/// @nodoc
class _$MerchantModelCopyWithImpl<$Res, $Val extends MerchantModel>
    implements $MerchantModelCopyWith<$Res> {
  _$MerchantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessName = freezed,
    Object? businessType = freezed,
    Object? registrationNumber = freezed,
    Object? taxId = freezed,
    Object? contact = freezed,
    Object? address = freezed,
    Object? businessProfile = freezed,
    Object? nutritionFeatures = freezed,
    Object? verification = freezed,
    Object? accountStatus = freezed,
    Object? stats = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isOpen = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessType: freezed == businessType
          ? _value.businessType
          : businessType // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationNumber: freezed == registrationNumber
          ? _value.registrationNumber
          : registrationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      taxId: freezed == taxId
          ? _value.taxId
          : taxId // ignore: cast_nullable_to_non_nullable
              as String?,
      contact: freezed == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as ContactInfo?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as AddressInfo?,
      businessProfile: freezed == businessProfile
          ? _value.businessProfile
          : businessProfile // ignore: cast_nullable_to_non_nullable
              as BusinessProfile?,
      nutritionFeatures: freezed == nutritionFeatures
          ? _value.nutritionFeatures
          : nutritionFeatures // ignore: cast_nullable_to_non_nullable
              as NutritionFeatures?,
      verification: freezed == verification
          ? _value.verification
          : verification // ignore: cast_nullable_to_non_nullable
              as VerificationInfo?,
      accountStatus: freezed == accountStatus
          ? _value.accountStatus
          : accountStatus // ignore: cast_nullable_to_non_nullable
              as AccountStatus?,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as MerchantStats?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isOpen: null == isOpen
          ? _value.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of MerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactInfoCopyWith<$Res>? get contact {
    if (_value.contact == null) {
      return null;
    }

    return $ContactInfoCopyWith<$Res>(_value.contact!, (value) {
      return _then(_value.copyWith(contact: value) as $Val);
    });
  }

  /// Create a copy of MerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressInfoCopyWith<$Res>? get address {
    if (_value.address == null) {
      return null;
    }

    return $AddressInfoCopyWith<$Res>(_value.address!, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }

  /// Create a copy of MerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BusinessProfileCopyWith<$Res>? get businessProfile {
    if (_value.businessProfile == null) {
      return null;
    }

    return $BusinessProfileCopyWith<$Res>(_value.businessProfile!, (value) {
      return _then(_value.copyWith(businessProfile: value) as $Val);
    });
  }

  /// Create a copy of MerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionFeaturesCopyWith<$Res>? get nutritionFeatures {
    if (_value.nutritionFeatures == null) {
      return null;
    }

    return $NutritionFeaturesCopyWith<$Res>(_value.nutritionFeatures!, (value) {
      return _then(_value.copyWith(nutritionFeatures: value) as $Val);
    });
  }

  /// Create a copy of MerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VerificationInfoCopyWith<$Res>? get verification {
    if (_value.verification == null) {
      return null;
    }

    return $VerificationInfoCopyWith<$Res>(_value.verification!, (value) {
      return _then(_value.copyWith(verification: value) as $Val);
    });
  }

  /// Create a copy of MerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountStatusCopyWith<$Res>? get accountStatus {
    if (_value.accountStatus == null) {
      return null;
    }

    return $AccountStatusCopyWith<$Res>(_value.accountStatus!, (value) {
      return _then(_value.copyWith(accountStatus: value) as $Val);
    });
  }

  /// Create a copy of MerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MerchantStatsCopyWith<$Res>? get stats {
    if (_value.stats == null) {
      return null;
    }

    return $MerchantStatsCopyWith<$Res>(_value.stats!, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MerchantModelImplCopyWith<$Res>
    implements $MerchantModelCopyWith<$Res> {
  factory _$$MerchantModelImplCopyWith(
          _$MerchantModelImpl value, $Res Function(_$MerchantModelImpl) then) =
      __$$MerchantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'businessName') String? businessName,
      @JsonKey(name: 'businessType') String? businessType,
      @JsonKey(name: 'registrationNumber') String? registrationNumber,
      @JsonKey(name: 'taxId') String? taxId,
      ContactInfo? contact,
      AddressInfo? address,
      @JsonKey(name: 'businessProfile') BusinessProfile? businessProfile,
      @JsonKey(name: 'nutritionFeatures') NutritionFeatures? nutritionFeatures,
      VerificationInfo? verification,
      @JsonKey(name: 'accountStatus') AccountStatus? accountStatus,
      MerchantStats? stats,
      @JsonKey(name: 'createdAt') DateTime? createdAt,
      @JsonKey(name: 'updatedAt') DateTime? updatedAt,
      @JsonKey(name: 'isOpen') bool isOpen});

  @override
  $ContactInfoCopyWith<$Res>? get contact;
  @override
  $AddressInfoCopyWith<$Res>? get address;
  @override
  $BusinessProfileCopyWith<$Res>? get businessProfile;
  @override
  $NutritionFeaturesCopyWith<$Res>? get nutritionFeatures;
  @override
  $VerificationInfoCopyWith<$Res>? get verification;
  @override
  $AccountStatusCopyWith<$Res>? get accountStatus;
  @override
  $MerchantStatsCopyWith<$Res>? get stats;
}

/// @nodoc
class __$$MerchantModelImplCopyWithImpl<$Res>
    extends _$MerchantModelCopyWithImpl<$Res, _$MerchantModelImpl>
    implements _$$MerchantModelImplCopyWith<$Res> {
  __$$MerchantModelImplCopyWithImpl(
      _$MerchantModelImpl _value, $Res Function(_$MerchantModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessName = freezed,
    Object? businessType = freezed,
    Object? registrationNumber = freezed,
    Object? taxId = freezed,
    Object? contact = freezed,
    Object? address = freezed,
    Object? businessProfile = freezed,
    Object? nutritionFeatures = freezed,
    Object? verification = freezed,
    Object? accountStatus = freezed,
    Object? stats = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isOpen = null,
  }) {
    return _then(_$MerchantModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessType: freezed == businessType
          ? _value.businessType
          : businessType // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationNumber: freezed == registrationNumber
          ? _value.registrationNumber
          : registrationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      taxId: freezed == taxId
          ? _value.taxId
          : taxId // ignore: cast_nullable_to_non_nullable
              as String?,
      contact: freezed == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as ContactInfo?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as AddressInfo?,
      businessProfile: freezed == businessProfile
          ? _value.businessProfile
          : businessProfile // ignore: cast_nullable_to_non_nullable
              as BusinessProfile?,
      nutritionFeatures: freezed == nutritionFeatures
          ? _value.nutritionFeatures
          : nutritionFeatures // ignore: cast_nullable_to_non_nullable
              as NutritionFeatures?,
      verification: freezed == verification
          ? _value.verification
          : verification // ignore: cast_nullable_to_non_nullable
              as VerificationInfo?,
      accountStatus: freezed == accountStatus
          ? _value.accountStatus
          : accountStatus // ignore: cast_nullable_to_non_nullable
              as AccountStatus?,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as MerchantStats?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isOpen: null == isOpen
          ? _value.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MerchantModelImpl implements _MerchantModel {
  const _$MerchantModelImpl(
      {required this.id,
      @JsonKey(name: 'businessName') this.businessName,
      @JsonKey(name: 'businessType') this.businessType,
      @JsonKey(name: 'registrationNumber') this.registrationNumber,
      @JsonKey(name: 'taxId') this.taxId,
      this.contact,
      this.address,
      @JsonKey(name: 'businessProfile') this.businessProfile,
      @JsonKey(name: 'nutritionFeatures') this.nutritionFeatures,
      this.verification,
      @JsonKey(name: 'accountStatus') this.accountStatus,
      this.stats,
      @JsonKey(name: 'createdAt') this.createdAt,
      @JsonKey(name: 'updatedAt') this.updatedAt,
      @JsonKey(name: 'isOpen') this.isOpen = false});

  factory _$MerchantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MerchantModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'businessName')
  final String? businessName;
  @override
  @JsonKey(name: 'businessType')
  final String? businessType;
  @override
  @JsonKey(name: 'registrationNumber')
  final String? registrationNumber;
  @override
  @JsonKey(name: 'taxId')
  final String? taxId;
  @override
  final ContactInfo? contact;
  @override
  final AddressInfo? address;
  @override
  @JsonKey(name: 'businessProfile')
  final BusinessProfile? businessProfile;
  @override
  @JsonKey(name: 'nutritionFeatures')
  final NutritionFeatures? nutritionFeatures;
  @override
  final VerificationInfo? verification;
  @override
  @JsonKey(name: 'accountStatus')
  final AccountStatus? accountStatus;
  @override
  final MerchantStats? stats;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'isOpen')
  final bool isOpen;

  @override
  String toString() {
    return 'MerchantModel(id: $id, businessName: $businessName, businessType: $businessType, registrationNumber: $registrationNumber, taxId: $taxId, contact: $contact, address: $address, businessProfile: $businessProfile, nutritionFeatures: $nutritionFeatures, verification: $verification, accountStatus: $accountStatus, stats: $stats, createdAt: $createdAt, updatedAt: $updatedAt, isOpen: $isOpen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MerchantModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.businessType, businessType) ||
                other.businessType == businessType) &&
            (identical(other.registrationNumber, registrationNumber) ||
                other.registrationNumber == registrationNumber) &&
            (identical(other.taxId, taxId) || other.taxId == taxId) &&
            (identical(other.contact, contact) || other.contact == contact) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.businessProfile, businessProfile) ||
                other.businessProfile == businessProfile) &&
            (identical(other.nutritionFeatures, nutritionFeatures) ||
                other.nutritionFeatures == nutritionFeatures) &&
            (identical(other.verification, verification) ||
                other.verification == verification) &&
            (identical(other.accountStatus, accountStatus) ||
                other.accountStatus == accountStatus) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      businessName,
      businessType,
      registrationNumber,
      taxId,
      contact,
      address,
      businessProfile,
      nutritionFeatures,
      verification,
      accountStatus,
      stats,
      createdAt,
      updatedAt,
      isOpen);

  /// Create a copy of MerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MerchantModelImplCopyWith<_$MerchantModelImpl> get copyWith =>
      __$$MerchantModelImplCopyWithImpl<_$MerchantModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MerchantModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MerchantModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MerchantModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MerchantModelImplToJson(
      this,
    );
  }
}

abstract class _MerchantModel implements MerchantModel {
  const factory _MerchantModel(
      {required final String id,
      @JsonKey(name: 'businessName') final String? businessName,
      @JsonKey(name: 'businessType') final String? businessType,
      @JsonKey(name: 'registrationNumber') final String? registrationNumber,
      @JsonKey(name: 'taxId') final String? taxId,
      final ContactInfo? contact,
      final AddressInfo? address,
      @JsonKey(name: 'businessProfile') final BusinessProfile? businessProfile,
      @JsonKey(name: 'nutritionFeatures')
      final NutritionFeatures? nutritionFeatures,
      final VerificationInfo? verification,
      @JsonKey(name: 'accountStatus') final AccountStatus? accountStatus,
      final MerchantStats? stats,
      @JsonKey(name: 'createdAt') final DateTime? createdAt,
      @JsonKey(name: 'updatedAt') final DateTime? updatedAt,
      @JsonKey(name: 'isOpen') final bool isOpen}) = _$MerchantModelImpl;

  factory _MerchantModel.fromJson(Map<String, dynamic> json) =
      _$MerchantModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'businessName')
  String? get businessName;
  @override
  @JsonKey(name: 'businessType')
  String? get businessType;
  @override
  @JsonKey(name: 'registrationNumber')
  String? get registrationNumber;
  @override
  @JsonKey(name: 'taxId')
  String? get taxId;
  @override
  ContactInfo? get contact;
  @override
  AddressInfo? get address;
  @override
  @JsonKey(name: 'businessProfile')
  BusinessProfile? get businessProfile;
  @override
  @JsonKey(name: 'nutritionFeatures')
  NutritionFeatures? get nutritionFeatures;
  @override
  VerificationInfo? get verification;
  @override
  @JsonKey(name: 'accountStatus')
  AccountStatus? get accountStatus;
  @override
  MerchantStats? get stats;
  @override
  @JsonKey(name: 'createdAt')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'isOpen')
  bool get isOpen;

  /// Create a copy of MerchantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MerchantModelImplCopyWith<_$MerchantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) {
  return _ContactInfo.fromJson(json);
}

/// @nodoc
mixin _$ContactInfo {
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get alternativePhone => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ContactInfo value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ContactInfo value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ContactInfo value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ContactInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactInfoCopyWith<ContactInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactInfoCopyWith<$Res> {
  factory $ContactInfoCopyWith(
          ContactInfo value, $Res Function(ContactInfo) then) =
      _$ContactInfoCopyWithImpl<$Res, ContactInfo>;
  @useResult
  $Res call(
      {String? email,
      String? phone,
      String? alternativePhone,
      String? website});
}

/// @nodoc
class _$ContactInfoCopyWithImpl<$Res, $Val extends ContactInfo>
    implements $ContactInfoCopyWith<$Res> {
  _$ContactInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? phone = freezed,
    Object? alternativePhone = freezed,
    Object? website = freezed,
  }) {
    return _then(_value.copyWith(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      alternativePhone: freezed == alternativePhone
          ? _value.alternativePhone
          : alternativePhone // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactInfoImplCopyWith<$Res>
    implements $ContactInfoCopyWith<$Res> {
  factory _$$ContactInfoImplCopyWith(
          _$ContactInfoImpl value, $Res Function(_$ContactInfoImpl) then) =
      __$$ContactInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? email,
      String? phone,
      String? alternativePhone,
      String? website});
}

/// @nodoc
class __$$ContactInfoImplCopyWithImpl<$Res>
    extends _$ContactInfoCopyWithImpl<$Res, _$ContactInfoImpl>
    implements _$$ContactInfoImplCopyWith<$Res> {
  __$$ContactInfoImplCopyWithImpl(
      _$ContactInfoImpl _value, $Res Function(_$ContactInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? phone = freezed,
    Object? alternativePhone = freezed,
    Object? website = freezed,
  }) {
    return _then(_$ContactInfoImpl(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      alternativePhone: freezed == alternativePhone
          ? _value.alternativePhone
          : alternativePhone // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactInfoImpl implements _ContactInfo {
  const _$ContactInfoImpl(
      {this.email, this.phone, this.alternativePhone, this.website});

  factory _$ContactInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactInfoImplFromJson(json);

  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? alternativePhone;
  @override
  final String? website;

  @override
  String toString() {
    return 'ContactInfo(email: $email, phone: $phone, alternativePhone: $alternativePhone, website: $website)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactInfoImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.alternativePhone, alternativePhone) ||
                other.alternativePhone == alternativePhone) &&
            (identical(other.website, website) || other.website == website));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, phone, alternativePhone, website);

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactInfoImplCopyWith<_$ContactInfoImpl> get copyWith =>
      __$$ContactInfoImplCopyWithImpl<_$ContactInfoImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ContactInfo value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ContactInfo value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ContactInfo value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactInfoImplToJson(
      this,
    );
  }
}

abstract class _ContactInfo implements ContactInfo {
  const factory _ContactInfo(
      {final String? email,
      final String? phone,
      final String? alternativePhone,
      final String? website}) = _$ContactInfoImpl;

  factory _ContactInfo.fromJson(Map<String, dynamic> json) =
      _$ContactInfoImpl.fromJson;

  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get alternativePhone;
  @override
  String? get website;

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactInfoImplCopyWith<_$ContactInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddressInfo _$AddressInfoFromJson(Map<String, dynamic> json) {
  return _AddressInfo.fromJson(json);
}

/// @nodoc
mixin _$AddressInfo {
  String? get line1 => throw _privateConstructorUsedError;
  String? get line2 => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  @JsonKey(name: 'postalCode')
  String? get postalCode => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  Coordinates? get coordinates => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AddressInfo value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AddressInfo value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AddressInfo value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this AddressInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddressInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressInfoCopyWith<AddressInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressInfoCopyWith<$Res> {
  factory $AddressInfoCopyWith(
          AddressInfo value, $Res Function(AddressInfo) then) =
      _$AddressInfoCopyWithImpl<$Res, AddressInfo>;
  @useResult
  $Res call(
      {String? line1,
      String? line2,
      String? city,
      String? state,
      @JsonKey(name: 'postalCode') String? postalCode,
      String country,
      Coordinates? coordinates});

  $CoordinatesCopyWith<$Res>? get coordinates;
}

/// @nodoc
class _$AddressInfoCopyWithImpl<$Res, $Val extends AddressInfo>
    implements $AddressInfoCopyWith<$Res> {
  _$AddressInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? line1 = freezed,
    Object? line2 = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? postalCode = freezed,
    Object? country = null,
    Object? coordinates = freezed,
  }) {
    return _then(_value.copyWith(
      line1: freezed == line1
          ? _value.line1
          : line1 // ignore: cast_nullable_to_non_nullable
              as String?,
      line2: freezed == line2
          ? _value.line2
          : line2 // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      coordinates: freezed == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as Coordinates?,
    ) as $Val);
  }

  /// Create a copy of AddressInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoordinatesCopyWith<$Res>? get coordinates {
    if (_value.coordinates == null) {
      return null;
    }

    return $CoordinatesCopyWith<$Res>(_value.coordinates!, (value) {
      return _then(_value.copyWith(coordinates: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AddressInfoImplCopyWith<$Res>
    implements $AddressInfoCopyWith<$Res> {
  factory _$$AddressInfoImplCopyWith(
          _$AddressInfoImpl value, $Res Function(_$AddressInfoImpl) then) =
      __$$AddressInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? line1,
      String? line2,
      String? city,
      String? state,
      @JsonKey(name: 'postalCode') String? postalCode,
      String country,
      Coordinates? coordinates});

  @override
  $CoordinatesCopyWith<$Res>? get coordinates;
}

/// @nodoc
class __$$AddressInfoImplCopyWithImpl<$Res>
    extends _$AddressInfoCopyWithImpl<$Res, _$AddressInfoImpl>
    implements _$$AddressInfoImplCopyWith<$Res> {
  __$$AddressInfoImplCopyWithImpl(
      _$AddressInfoImpl _value, $Res Function(_$AddressInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddressInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? line1 = freezed,
    Object? line2 = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? postalCode = freezed,
    Object? country = null,
    Object? coordinates = freezed,
  }) {
    return _then(_$AddressInfoImpl(
      line1: freezed == line1
          ? _value.line1
          : line1 // ignore: cast_nullable_to_non_nullable
              as String?,
      line2: freezed == line2
          ? _value.line2
          : line2 // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      coordinates: freezed == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as Coordinates?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressInfoImpl implements _AddressInfo {
  const _$AddressInfoImpl(
      {this.line1,
      this.line2,
      this.city,
      this.state,
      @JsonKey(name: 'postalCode') this.postalCode,
      this.country = 'China',
      this.coordinates});

  factory _$AddressInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressInfoImplFromJson(json);

  @override
  final String? line1;
  @override
  final String? line2;
  @override
  final String? city;
  @override
  final String? state;
  @override
  @JsonKey(name: 'postalCode')
  final String? postalCode;
  @override
  @JsonKey()
  final String country;
  @override
  final Coordinates? coordinates;

  @override
  String toString() {
    return 'AddressInfo(line1: $line1, line2: $line2, city: $city, state: $state, postalCode: $postalCode, country: $country, coordinates: $coordinates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressInfoImpl &&
            (identical(other.line1, line1) || other.line1 == line1) &&
            (identical(other.line2, line2) || other.line2 == line2) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.coordinates, coordinates) ||
                other.coordinates == coordinates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, line1, line2, city, state, postalCode, country, coordinates);

  /// Create a copy of AddressInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressInfoImplCopyWith<_$AddressInfoImpl> get copyWith =>
      __$$AddressInfoImplCopyWithImpl<_$AddressInfoImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AddressInfo value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AddressInfo value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AddressInfo value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressInfoImplToJson(
      this,
    );
  }
}

abstract class _AddressInfo implements AddressInfo {
  const factory _AddressInfo(
      {final String? line1,
      final String? line2,
      final String? city,
      final String? state,
      @JsonKey(name: 'postalCode') final String? postalCode,
      final String country,
      final Coordinates? coordinates}) = _$AddressInfoImpl;

  factory _AddressInfo.fromJson(Map<String, dynamic> json) =
      _$AddressInfoImpl.fromJson;

  @override
  String? get line1;
  @override
  String? get line2;
  @override
  String? get city;
  @override
  String? get state;
  @override
  @JsonKey(name: 'postalCode')
  String? get postalCode;
  @override
  String get country;
  @override
  Coordinates? get coordinates;

  /// Create a copy of AddressInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressInfoImplCopyWith<_$AddressInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Coordinates _$CoordinatesFromJson(Map<String, dynamic> json) {
  return _Coordinates.fromJson(json);
}

/// @nodoc
mixin _$Coordinates {
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Coordinates value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Coordinates value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Coordinates value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this Coordinates to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Coordinates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoordinatesCopyWith<Coordinates> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoordinatesCopyWith<$Res> {
  factory $CoordinatesCopyWith(
          Coordinates value, $Res Function(Coordinates) then) =
      _$CoordinatesCopyWithImpl<$Res, Coordinates>;
  @useResult
  $Res call({double? latitude, double? longitude});
}

/// @nodoc
class _$CoordinatesCopyWithImpl<$Res, $Val extends Coordinates>
    implements $CoordinatesCopyWith<$Res> {
  _$CoordinatesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Coordinates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_value.copyWith(
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoordinatesImplCopyWith<$Res>
    implements $CoordinatesCopyWith<$Res> {
  factory _$$CoordinatesImplCopyWith(
          _$CoordinatesImpl value, $Res Function(_$CoordinatesImpl) then) =
      __$$CoordinatesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double? latitude, double? longitude});
}

/// @nodoc
class __$$CoordinatesImplCopyWithImpl<$Res>
    extends _$CoordinatesCopyWithImpl<$Res, _$CoordinatesImpl>
    implements _$$CoordinatesImplCopyWith<$Res> {
  __$$CoordinatesImplCopyWithImpl(
      _$CoordinatesImpl _value, $Res Function(_$CoordinatesImpl) _then)
      : super(_value, _then);

  /// Create a copy of Coordinates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_$CoordinatesImpl(
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoordinatesImpl implements _Coordinates {
  const _$CoordinatesImpl({this.latitude, this.longitude});

  factory _$CoordinatesImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoordinatesImplFromJson(json);

  @override
  final double? latitude;
  @override
  final double? longitude;

  @override
  String toString() {
    return 'Coordinates(latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoordinatesImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude);

  /// Create a copy of Coordinates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoordinatesImplCopyWith<_$CoordinatesImpl> get copyWith =>
      __$$CoordinatesImplCopyWithImpl<_$CoordinatesImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Coordinates value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Coordinates value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Coordinates value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CoordinatesImplToJson(
      this,
    );
  }
}

abstract class _Coordinates implements Coordinates {
  const factory _Coordinates(
      {final double? latitude, final double? longitude}) = _$CoordinatesImpl;

  factory _Coordinates.fromJson(Map<String, dynamic> json) =
      _$CoordinatesImpl.fromJson;

  @override
  double? get latitude;
  @override
  double? get longitude;

  /// Create a copy of Coordinates
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoordinatesImplCopyWith<_$CoordinatesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BusinessProfile _$BusinessProfileFromJson(Map<String, dynamic> json) {
  return _BusinessProfile.fromJson(json);
}

/// @nodoc
mixin _$BusinessProfile {
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'establishmentYear')
  int? get establishmentYear => throw _privateConstructorUsedError;
  @JsonKey(name: 'operatingHours')
  List<String> get operatingHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'cuisineTypes')
  List<String> get cuisineTypes => throw _privateConstructorUsedError;
  List<String> get facilities => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'logoUrl')
  String? get logoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'averagePriceRange')
  Map<String, dynamic>? get averagePriceRange =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BusinessProfile value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BusinessProfile value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BusinessProfile value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this BusinessProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BusinessProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessProfileCopyWith<BusinessProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessProfileCopyWith<$Res> {
  factory $BusinessProfileCopyWith(
          BusinessProfile value, $Res Function(BusinessProfile) then) =
      _$BusinessProfileCopyWithImpl<$Res, BusinessProfile>;
  @useResult
  $Res call(
      {String? description,
      @JsonKey(name: 'establishmentYear') int? establishmentYear,
      @JsonKey(name: 'operatingHours') List<String> operatingHours,
      @JsonKey(name: 'cuisineTypes') List<String> cuisineTypes,
      List<String> facilities,
      List<String> images,
      @JsonKey(name: 'logoUrl') String? logoUrl,
      @JsonKey(name: 'averagePriceRange')
      Map<String, dynamic>? averagePriceRange});
}

/// @nodoc
class _$BusinessProfileCopyWithImpl<$Res, $Val extends BusinessProfile>
    implements $BusinessProfileCopyWith<$Res> {
  _$BusinessProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? establishmentYear = freezed,
    Object? operatingHours = null,
    Object? cuisineTypes = null,
    Object? facilities = null,
    Object? images = null,
    Object? logoUrl = freezed,
    Object? averagePriceRange = freezed,
  }) {
    return _then(_value.copyWith(
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      establishmentYear: freezed == establishmentYear
          ? _value.establishmentYear
          : establishmentYear // ignore: cast_nullable_to_non_nullable
              as int?,
      operatingHours: null == operatingHours
          ? _value.operatingHours
          : operatingHours // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cuisineTypes: null == cuisineTypes
          ? _value.cuisineTypes
          : cuisineTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      facilities: null == facilities
          ? _value.facilities
          : facilities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      averagePriceRange: freezed == averagePriceRange
          ? _value.averagePriceRange
          : averagePriceRange // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusinessProfileImplCopyWith<$Res>
    implements $BusinessProfileCopyWith<$Res> {
  factory _$$BusinessProfileImplCopyWith(_$BusinessProfileImpl value,
          $Res Function(_$BusinessProfileImpl) then) =
      __$$BusinessProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? description,
      @JsonKey(name: 'establishmentYear') int? establishmentYear,
      @JsonKey(name: 'operatingHours') List<String> operatingHours,
      @JsonKey(name: 'cuisineTypes') List<String> cuisineTypes,
      List<String> facilities,
      List<String> images,
      @JsonKey(name: 'logoUrl') String? logoUrl,
      @JsonKey(name: 'averagePriceRange')
      Map<String, dynamic>? averagePriceRange});
}

/// @nodoc
class __$$BusinessProfileImplCopyWithImpl<$Res>
    extends _$BusinessProfileCopyWithImpl<$Res, _$BusinessProfileImpl>
    implements _$$BusinessProfileImplCopyWith<$Res> {
  __$$BusinessProfileImplCopyWithImpl(
      _$BusinessProfileImpl _value, $Res Function(_$BusinessProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of BusinessProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? establishmentYear = freezed,
    Object? operatingHours = null,
    Object? cuisineTypes = null,
    Object? facilities = null,
    Object? images = null,
    Object? logoUrl = freezed,
    Object? averagePriceRange = freezed,
  }) {
    return _then(_$BusinessProfileImpl(
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      establishmentYear: freezed == establishmentYear
          ? _value.establishmentYear
          : establishmentYear // ignore: cast_nullable_to_non_nullable
              as int?,
      operatingHours: null == operatingHours
          ? _value._operatingHours
          : operatingHours // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cuisineTypes: null == cuisineTypes
          ? _value._cuisineTypes
          : cuisineTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      facilities: null == facilities
          ? _value._facilities
          : facilities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      averagePriceRange: freezed == averagePriceRange
          ? _value._averagePriceRange
          : averagePriceRange // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessProfileImpl implements _BusinessProfile {
  const _$BusinessProfileImpl(
      {this.description,
      @JsonKey(name: 'establishmentYear') this.establishmentYear,
      @JsonKey(name: 'operatingHours')
      final List<String> operatingHours = const [],
      @JsonKey(name: 'cuisineTypes') final List<String> cuisineTypes = const [],
      final List<String> facilities = const [],
      final List<String> images = const [],
      @JsonKey(name: 'logoUrl') this.logoUrl,
      @JsonKey(name: 'averagePriceRange')
      final Map<String, dynamic>? averagePriceRange})
      : _operatingHours = operatingHours,
        _cuisineTypes = cuisineTypes,
        _facilities = facilities,
        _images = images,
        _averagePriceRange = averagePriceRange;

  factory _$BusinessProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessProfileImplFromJson(json);

  @override
  final String? description;
  @override
  @JsonKey(name: 'establishmentYear')
  final int? establishmentYear;
  final List<String> _operatingHours;
  @override
  @JsonKey(name: 'operatingHours')
  List<String> get operatingHours {
    if (_operatingHours is EqualUnmodifiableListView) return _operatingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_operatingHours);
  }

  final List<String> _cuisineTypes;
  @override
  @JsonKey(name: 'cuisineTypes')
  List<String> get cuisineTypes {
    if (_cuisineTypes is EqualUnmodifiableListView) return _cuisineTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cuisineTypes);
  }

  final List<String> _facilities;
  @override
  @JsonKey()
  List<String> get facilities {
    if (_facilities is EqualUnmodifiableListView) return _facilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_facilities);
  }

  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey(name: 'logoUrl')
  final String? logoUrl;
  final Map<String, dynamic>? _averagePriceRange;
  @override
  @JsonKey(name: 'averagePriceRange')
  Map<String, dynamic>? get averagePriceRange {
    final value = _averagePriceRange;
    if (value == null) return null;
    if (_averagePriceRange is EqualUnmodifiableMapView)
      return _averagePriceRange;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'BusinessProfile(description: $description, establishmentYear: $establishmentYear, operatingHours: $operatingHours, cuisineTypes: $cuisineTypes, facilities: $facilities, images: $images, logoUrl: $logoUrl, averagePriceRange: $averagePriceRange)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessProfileImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.establishmentYear, establishmentYear) ||
                other.establishmentYear == establishmentYear) &&
            const DeepCollectionEquality()
                .equals(other._operatingHours, _operatingHours) &&
            const DeepCollectionEquality()
                .equals(other._cuisineTypes, _cuisineTypes) &&
            const DeepCollectionEquality()
                .equals(other._facilities, _facilities) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            const DeepCollectionEquality()
                .equals(other._averagePriceRange, _averagePriceRange));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      description,
      establishmentYear,
      const DeepCollectionEquality().hash(_operatingHours),
      const DeepCollectionEquality().hash(_cuisineTypes),
      const DeepCollectionEquality().hash(_facilities),
      const DeepCollectionEquality().hash(_images),
      logoUrl,
      const DeepCollectionEquality().hash(_averagePriceRange));

  /// Create a copy of BusinessProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessProfileImplCopyWith<_$BusinessProfileImpl> get copyWith =>
      __$$BusinessProfileImplCopyWithImpl<_$BusinessProfileImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BusinessProfile value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BusinessProfile value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BusinessProfile value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessProfileImplToJson(
      this,
    );
  }
}

abstract class _BusinessProfile implements BusinessProfile {
  const factory _BusinessProfile(
      {final String? description,
      @JsonKey(name: 'establishmentYear') final int? establishmentYear,
      @JsonKey(name: 'operatingHours') final List<String> operatingHours,
      @JsonKey(name: 'cuisineTypes') final List<String> cuisineTypes,
      final List<String> facilities,
      final List<String> images,
      @JsonKey(name: 'logoUrl') final String? logoUrl,
      @JsonKey(name: 'averagePriceRange')
      final Map<String, dynamic>? averagePriceRange}) = _$BusinessProfileImpl;

  factory _BusinessProfile.fromJson(Map<String, dynamic> json) =
      _$BusinessProfileImpl.fromJson;

  @override
  String? get description;
  @override
  @JsonKey(name: 'establishmentYear')
  int? get establishmentYear;
  @override
  @JsonKey(name: 'operatingHours')
  List<String> get operatingHours;
  @override
  @JsonKey(name: 'cuisineTypes')
  List<String> get cuisineTypes;
  @override
  List<String> get facilities;
  @override
  List<String> get images;
  @override
  @JsonKey(name: 'logoUrl')
  String? get logoUrl;
  @override
  @JsonKey(name: 'averagePriceRange')
  Map<String, dynamic>? get averagePriceRange;

  /// Create a copy of BusinessProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessProfileImplCopyWith<_$BusinessProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionFeatures _$NutritionFeaturesFromJson(Map<String, dynamic> json) {
  return _NutritionFeatures.fromJson(json);
}

/// @nodoc
mixin _$NutritionFeatures {
  @JsonKey(name: 'hasNutritionist')
  bool get hasNutritionist => throw _privateConstructorUsedError;
  @JsonKey(name: 'nutritionCertified')
  bool get nutritionCertified => throw _privateConstructorUsedError;
  @JsonKey(name: 'certificationDetails')
  String? get certificationDetails => throw _privateConstructorUsedError;
  @JsonKey(name: 'specialtyDiets')
  List<String>? get specialtyDiets => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionFeatures value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionFeatures value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionFeatures value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionFeatures to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionFeatures
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionFeaturesCopyWith<NutritionFeatures> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionFeaturesCopyWith<$Res> {
  factory $NutritionFeaturesCopyWith(
          NutritionFeatures value, $Res Function(NutritionFeatures) then) =
      _$NutritionFeaturesCopyWithImpl<$Res, NutritionFeatures>;
  @useResult
  $Res call(
      {@JsonKey(name: 'hasNutritionist') bool hasNutritionist,
      @JsonKey(name: 'nutritionCertified') bool nutritionCertified,
      @JsonKey(name: 'certificationDetails') String? certificationDetails,
      @JsonKey(name: 'specialtyDiets') List<String>? specialtyDiets});
}

/// @nodoc
class _$NutritionFeaturesCopyWithImpl<$Res, $Val extends NutritionFeatures>
    implements $NutritionFeaturesCopyWith<$Res> {
  _$NutritionFeaturesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionFeatures
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasNutritionist = null,
    Object? nutritionCertified = null,
    Object? certificationDetails = freezed,
    Object? specialtyDiets = freezed,
  }) {
    return _then(_value.copyWith(
      hasNutritionist: null == hasNutritionist
          ? _value.hasNutritionist
          : hasNutritionist // ignore: cast_nullable_to_non_nullable
              as bool,
      nutritionCertified: null == nutritionCertified
          ? _value.nutritionCertified
          : nutritionCertified // ignore: cast_nullable_to_non_nullable
              as bool,
      certificationDetails: freezed == certificationDetails
          ? _value.certificationDetails
          : certificationDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      specialtyDiets: freezed == specialtyDiets
          ? _value.specialtyDiets
          : specialtyDiets // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionFeaturesImplCopyWith<$Res>
    implements $NutritionFeaturesCopyWith<$Res> {
  factory _$$NutritionFeaturesImplCopyWith(_$NutritionFeaturesImpl value,
          $Res Function(_$NutritionFeaturesImpl) then) =
      __$$NutritionFeaturesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'hasNutritionist') bool hasNutritionist,
      @JsonKey(name: 'nutritionCertified') bool nutritionCertified,
      @JsonKey(name: 'certificationDetails') String? certificationDetails,
      @JsonKey(name: 'specialtyDiets') List<String>? specialtyDiets});
}

/// @nodoc
class __$$NutritionFeaturesImplCopyWithImpl<$Res>
    extends _$NutritionFeaturesCopyWithImpl<$Res, _$NutritionFeaturesImpl>
    implements _$$NutritionFeaturesImplCopyWith<$Res> {
  __$$NutritionFeaturesImplCopyWithImpl(_$NutritionFeaturesImpl _value,
      $Res Function(_$NutritionFeaturesImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionFeatures
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasNutritionist = null,
    Object? nutritionCertified = null,
    Object? certificationDetails = freezed,
    Object? specialtyDiets = freezed,
  }) {
    return _then(_$NutritionFeaturesImpl(
      hasNutritionist: null == hasNutritionist
          ? _value.hasNutritionist
          : hasNutritionist // ignore: cast_nullable_to_non_nullable
              as bool,
      nutritionCertified: null == nutritionCertified
          ? _value.nutritionCertified
          : nutritionCertified // ignore: cast_nullable_to_non_nullable
              as bool,
      certificationDetails: freezed == certificationDetails
          ? _value.certificationDetails
          : certificationDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      specialtyDiets: freezed == specialtyDiets
          ? _value._specialtyDiets
          : specialtyDiets // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionFeaturesImpl implements _NutritionFeatures {
  const _$NutritionFeaturesImpl(
      {@JsonKey(name: 'hasNutritionist') this.hasNutritionist = false,
      @JsonKey(name: 'nutritionCertified') this.nutritionCertified = false,
      @JsonKey(name: 'certificationDetails') this.certificationDetails,
      @JsonKey(name: 'specialtyDiets') final List<String>? specialtyDiets})
      : _specialtyDiets = specialtyDiets;

  factory _$NutritionFeaturesImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionFeaturesImplFromJson(json);

  @override
  @JsonKey(name: 'hasNutritionist')
  final bool hasNutritionist;
  @override
  @JsonKey(name: 'nutritionCertified')
  final bool nutritionCertified;
  @override
  @JsonKey(name: 'certificationDetails')
  final String? certificationDetails;
  final List<String>? _specialtyDiets;
  @override
  @JsonKey(name: 'specialtyDiets')
  List<String>? get specialtyDiets {
    final value = _specialtyDiets;
    if (value == null) return null;
    if (_specialtyDiets is EqualUnmodifiableListView) return _specialtyDiets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'NutritionFeatures(hasNutritionist: $hasNutritionist, nutritionCertified: $nutritionCertified, certificationDetails: $certificationDetails, specialtyDiets: $specialtyDiets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionFeaturesImpl &&
            (identical(other.hasNutritionist, hasNutritionist) ||
                other.hasNutritionist == hasNutritionist) &&
            (identical(other.nutritionCertified, nutritionCertified) ||
                other.nutritionCertified == nutritionCertified) &&
            (identical(other.certificationDetails, certificationDetails) ||
                other.certificationDetails == certificationDetails) &&
            const DeepCollectionEquality()
                .equals(other._specialtyDiets, _specialtyDiets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      hasNutritionist,
      nutritionCertified,
      certificationDetails,
      const DeepCollectionEquality().hash(_specialtyDiets));

  /// Create a copy of NutritionFeatures
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionFeaturesImplCopyWith<_$NutritionFeaturesImpl> get copyWith =>
      __$$NutritionFeaturesImplCopyWithImpl<_$NutritionFeaturesImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionFeatures value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionFeatures value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionFeatures value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionFeaturesImplToJson(
      this,
    );
  }
}

abstract class _NutritionFeatures implements NutritionFeatures {
  const factory _NutritionFeatures(
      {@JsonKey(name: 'hasNutritionist') final bool hasNutritionist,
      @JsonKey(name: 'nutritionCertified') final bool nutritionCertified,
      @JsonKey(name: 'certificationDetails') final String? certificationDetails,
      @JsonKey(name: 'specialtyDiets')
      final List<String>? specialtyDiets}) = _$NutritionFeaturesImpl;

  factory _NutritionFeatures.fromJson(Map<String, dynamic> json) =
      _$NutritionFeaturesImpl.fromJson;

  @override
  @JsonKey(name: 'hasNutritionist')
  bool get hasNutritionist;
  @override
  @JsonKey(name: 'nutritionCertified')
  bool get nutritionCertified;
  @override
  @JsonKey(name: 'certificationDetails')
  String? get certificationDetails;
  @override
  @JsonKey(name: 'specialtyDiets')
  List<String>? get specialtyDiets;

  /// Create a copy of NutritionFeatures
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionFeaturesImplCopyWith<_$NutritionFeaturesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VerificationInfo _$VerificationInfoFromJson(Map<String, dynamic> json) {
  return _VerificationInfo.fromJson(json);
}

/// @nodoc
mixin _$VerificationInfo {
  @JsonKey(name: 'isVerified')
  bool get isVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'verificationStatus')
  String get verificationStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'verifiedAt')
  DateTime? get verifiedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'verifiedBy')
  String? get verifiedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'verificationNotes')
  String? get verificationNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejectionReason')
  String? get rejectionReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'verificationDocuments')
  List<VerificationDocument>? get verificationDocuments =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_VerificationInfo value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_VerificationInfo value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_VerificationInfo value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this VerificationInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerificationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerificationInfoCopyWith<VerificationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationInfoCopyWith<$Res> {
  factory $VerificationInfoCopyWith(
          VerificationInfo value, $Res Function(VerificationInfo) then) =
      _$VerificationInfoCopyWithImpl<$Res, VerificationInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'isVerified') bool isVerified,
      @JsonKey(name: 'verificationStatus') String verificationStatus,
      @JsonKey(name: 'verifiedAt') DateTime? verifiedAt,
      @JsonKey(name: 'verifiedBy') String? verifiedBy,
      @JsonKey(name: 'verificationNotes') String? verificationNotes,
      @JsonKey(name: 'rejectionReason') String? rejectionReason,
      @JsonKey(name: 'verificationDocuments')
      List<VerificationDocument>? verificationDocuments});
}

/// @nodoc
class _$VerificationInfoCopyWithImpl<$Res, $Val extends VerificationInfo>
    implements $VerificationInfoCopyWith<$Res> {
  _$VerificationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerificationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVerified = null,
    Object? verificationStatus = null,
    Object? verifiedAt = freezed,
    Object? verifiedBy = freezed,
    Object? verificationNotes = freezed,
    Object? rejectionReason = freezed,
    Object? verificationDocuments = freezed,
  }) {
    return _then(_value.copyWith(
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verifiedBy: freezed == verifiedBy
          ? _value.verifiedBy
          : verifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationNotes: freezed == verificationNotes
          ? _value.verificationNotes
          : verificationNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationDocuments: freezed == verificationDocuments
          ? _value.verificationDocuments
          : verificationDocuments // ignore: cast_nullable_to_non_nullable
              as List<VerificationDocument>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerificationInfoImplCopyWith<$Res>
    implements $VerificationInfoCopyWith<$Res> {
  factory _$$VerificationInfoImplCopyWith(_$VerificationInfoImpl value,
          $Res Function(_$VerificationInfoImpl) then) =
      __$$VerificationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'isVerified') bool isVerified,
      @JsonKey(name: 'verificationStatus') String verificationStatus,
      @JsonKey(name: 'verifiedAt') DateTime? verifiedAt,
      @JsonKey(name: 'verifiedBy') String? verifiedBy,
      @JsonKey(name: 'verificationNotes') String? verificationNotes,
      @JsonKey(name: 'rejectionReason') String? rejectionReason,
      @JsonKey(name: 'verificationDocuments')
      List<VerificationDocument>? verificationDocuments});
}

/// @nodoc
class __$$VerificationInfoImplCopyWithImpl<$Res>
    extends _$VerificationInfoCopyWithImpl<$Res, _$VerificationInfoImpl>
    implements _$$VerificationInfoImplCopyWith<$Res> {
  __$$VerificationInfoImplCopyWithImpl(_$VerificationInfoImpl _value,
      $Res Function(_$VerificationInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of VerificationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVerified = null,
    Object? verificationStatus = null,
    Object? verifiedAt = freezed,
    Object? verifiedBy = freezed,
    Object? verificationNotes = freezed,
    Object? rejectionReason = freezed,
    Object? verificationDocuments = freezed,
  }) {
    return _then(_$VerificationInfoImpl(
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verifiedBy: freezed == verifiedBy
          ? _value.verifiedBy
          : verifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationNotes: freezed == verificationNotes
          ? _value.verificationNotes
          : verificationNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationDocuments: freezed == verificationDocuments
          ? _value._verificationDocuments
          : verificationDocuments // ignore: cast_nullable_to_non_nullable
              as List<VerificationDocument>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationInfoImpl implements _VerificationInfo {
  const _$VerificationInfoImpl(
      {@JsonKey(name: 'isVerified') this.isVerified = false,
      @JsonKey(name: 'verificationStatus') this.verificationStatus = 'pending',
      @JsonKey(name: 'verifiedAt') this.verifiedAt,
      @JsonKey(name: 'verifiedBy') this.verifiedBy,
      @JsonKey(name: 'verificationNotes') this.verificationNotes,
      @JsonKey(name: 'rejectionReason') this.rejectionReason,
      @JsonKey(name: 'verificationDocuments')
      final List<VerificationDocument>? verificationDocuments})
      : _verificationDocuments = verificationDocuments;

  factory _$VerificationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationInfoImplFromJson(json);

  @override
  @JsonKey(name: 'isVerified')
  final bool isVerified;
  @override
  @JsonKey(name: 'verificationStatus')
  final String verificationStatus;
  @override
  @JsonKey(name: 'verifiedAt')
  final DateTime? verifiedAt;
  @override
  @JsonKey(name: 'verifiedBy')
  final String? verifiedBy;
  @override
  @JsonKey(name: 'verificationNotes')
  final String? verificationNotes;
  @override
  @JsonKey(name: 'rejectionReason')
  final String? rejectionReason;
  final List<VerificationDocument>? _verificationDocuments;
  @override
  @JsonKey(name: 'verificationDocuments')
  List<VerificationDocument>? get verificationDocuments {
    final value = _verificationDocuments;
    if (value == null) return null;
    if (_verificationDocuments is EqualUnmodifiableListView)
      return _verificationDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'VerificationInfo(isVerified: $isVerified, verificationStatus: $verificationStatus, verifiedAt: $verifiedAt, verifiedBy: $verifiedBy, verificationNotes: $verificationNotes, rejectionReason: $rejectionReason, verificationDocuments: $verificationDocuments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationInfoImpl &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt) &&
            (identical(other.verifiedBy, verifiedBy) ||
                other.verifiedBy == verifiedBy) &&
            (identical(other.verificationNotes, verificationNotes) ||
                other.verificationNotes == verificationNotes) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            const DeepCollectionEquality()
                .equals(other._verificationDocuments, _verificationDocuments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isVerified,
      verificationStatus,
      verifiedAt,
      verifiedBy,
      verificationNotes,
      rejectionReason,
      const DeepCollectionEquality().hash(_verificationDocuments));

  /// Create a copy of VerificationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationInfoImplCopyWith<_$VerificationInfoImpl> get copyWith =>
      __$$VerificationInfoImplCopyWithImpl<_$VerificationInfoImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_VerificationInfo value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_VerificationInfo value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_VerificationInfo value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationInfoImplToJson(
      this,
    );
  }
}

abstract class _VerificationInfo implements VerificationInfo {
  const factory _VerificationInfo(
          {@JsonKey(name: 'isVerified') final bool isVerified,
          @JsonKey(name: 'verificationStatus') final String verificationStatus,
          @JsonKey(name: 'verifiedAt') final DateTime? verifiedAt,
          @JsonKey(name: 'verifiedBy') final String? verifiedBy,
          @JsonKey(name: 'verificationNotes') final String? verificationNotes,
          @JsonKey(name: 'rejectionReason') final String? rejectionReason,
          @JsonKey(name: 'verificationDocuments')
          final List<VerificationDocument>? verificationDocuments}) =
      _$VerificationInfoImpl;

  factory _VerificationInfo.fromJson(Map<String, dynamic> json) =
      _$VerificationInfoImpl.fromJson;

  @override
  @JsonKey(name: 'isVerified')
  bool get isVerified;
  @override
  @JsonKey(name: 'verificationStatus')
  String get verificationStatus;
  @override
  @JsonKey(name: 'verifiedAt')
  DateTime? get verifiedAt;
  @override
  @JsonKey(name: 'verifiedBy')
  String? get verifiedBy;
  @override
  @JsonKey(name: 'verificationNotes')
  String? get verificationNotes;
  @override
  @JsonKey(name: 'rejectionReason')
  String? get rejectionReason;
  @override
  @JsonKey(name: 'verificationDocuments')
  List<VerificationDocument>? get verificationDocuments;

  /// Create a copy of VerificationInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerificationInfoImplCopyWith<_$VerificationInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VerificationDocument _$VerificationDocumentFromJson(Map<String, dynamic> json) {
  return _VerificationDocument.fromJson(json);
}

/// @nodoc
mixin _$VerificationDocument {
  @JsonKey(name: 'documentType')
  String? get documentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'documentUrl')
  String? get documentUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'uploadedAt')
  DateTime? get uploadedAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_VerificationDocument value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_VerificationDocument value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_VerificationDocument value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this VerificationDocument to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerificationDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerificationDocumentCopyWith<VerificationDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationDocumentCopyWith<$Res> {
  factory $VerificationDocumentCopyWith(VerificationDocument value,
          $Res Function(VerificationDocument) then) =
      _$VerificationDocumentCopyWithImpl<$Res, VerificationDocument>;
  @useResult
  $Res call(
      {@JsonKey(name: 'documentType') String? documentType,
      @JsonKey(name: 'documentUrl') String? documentUrl,
      @JsonKey(name: 'uploadedAt') DateTime? uploadedAt,
      String status});
}

/// @nodoc
class _$VerificationDocumentCopyWithImpl<$Res,
        $Val extends VerificationDocument>
    implements $VerificationDocumentCopyWith<$Res> {
  _$VerificationDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerificationDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = freezed,
    Object? documentUrl = freezed,
    Object? uploadedAt = freezed,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      documentType: freezed == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String?,
      documentUrl: freezed == documentUrl
          ? _value.documentUrl
          : documentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedAt: freezed == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerificationDocumentImplCopyWith<$Res>
    implements $VerificationDocumentCopyWith<$Res> {
  factory _$$VerificationDocumentImplCopyWith(_$VerificationDocumentImpl value,
          $Res Function(_$VerificationDocumentImpl) then) =
      __$$VerificationDocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'documentType') String? documentType,
      @JsonKey(name: 'documentUrl') String? documentUrl,
      @JsonKey(name: 'uploadedAt') DateTime? uploadedAt,
      String status});
}

/// @nodoc
class __$$VerificationDocumentImplCopyWithImpl<$Res>
    extends _$VerificationDocumentCopyWithImpl<$Res, _$VerificationDocumentImpl>
    implements _$$VerificationDocumentImplCopyWith<$Res> {
  __$$VerificationDocumentImplCopyWithImpl(_$VerificationDocumentImpl _value,
      $Res Function(_$VerificationDocumentImpl) _then)
      : super(_value, _then);

  /// Create a copy of VerificationDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = freezed,
    Object? documentUrl = freezed,
    Object? uploadedAt = freezed,
    Object? status = null,
  }) {
    return _then(_$VerificationDocumentImpl(
      documentType: freezed == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String?,
      documentUrl: freezed == documentUrl
          ? _value.documentUrl
          : documentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedAt: freezed == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationDocumentImpl implements _VerificationDocument {
  const _$VerificationDocumentImpl(
      {@JsonKey(name: 'documentType') this.documentType,
      @JsonKey(name: 'documentUrl') this.documentUrl,
      @JsonKey(name: 'uploadedAt') this.uploadedAt,
      this.status = 'pending'});

  factory _$VerificationDocumentImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationDocumentImplFromJson(json);

  @override
  @JsonKey(name: 'documentType')
  final String? documentType;
  @override
  @JsonKey(name: 'documentUrl')
  final String? documentUrl;
  @override
  @JsonKey(name: 'uploadedAt')
  final DateTime? uploadedAt;
  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'VerificationDocument(documentType: $documentType, documentUrl: $documentUrl, uploadedAt: $uploadedAt, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationDocumentImpl &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.documentUrl, documentUrl) ||
                other.documentUrl == documentUrl) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, documentType, documentUrl, uploadedAt, status);

  /// Create a copy of VerificationDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationDocumentImplCopyWith<_$VerificationDocumentImpl>
      get copyWith =>
          __$$VerificationDocumentImplCopyWithImpl<_$VerificationDocumentImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_VerificationDocument value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_VerificationDocument value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_VerificationDocument value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationDocumentImplToJson(
      this,
    );
  }
}

abstract class _VerificationDocument implements VerificationDocument {
  const factory _VerificationDocument(
      {@JsonKey(name: 'documentType') final String? documentType,
      @JsonKey(name: 'documentUrl') final String? documentUrl,
      @JsonKey(name: 'uploadedAt') final DateTime? uploadedAt,
      final String status}) = _$VerificationDocumentImpl;

  factory _VerificationDocument.fromJson(Map<String, dynamic> json) =
      _$VerificationDocumentImpl.fromJson;

  @override
  @JsonKey(name: 'documentType')
  String? get documentType;
  @override
  @JsonKey(name: 'documentUrl')
  String? get documentUrl;
  @override
  @JsonKey(name: 'uploadedAt')
  DateTime? get uploadedAt;
  @override
  String get status;

  /// Create a copy of VerificationDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerificationDocumentImplCopyWith<_$VerificationDocumentImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AccountStatus _$AccountStatusFromJson(Map<String, dynamic> json) {
  return _AccountStatus.fromJson(json);
}

/// @nodoc
mixin _$AccountStatus {
  @JsonKey(name: 'isActive')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'suspensionReason')
  String? get suspensionReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'suspendedAt')
  DateTime? get suspendedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'suspendedBy')
  String? get suspendedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'suspensionEndDate')
  DateTime? get suspensionEndDate => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AccountStatus value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AccountStatus value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AccountStatus value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this AccountStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountStatusCopyWith<AccountStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountStatusCopyWith<$Res> {
  factory $AccountStatusCopyWith(
          AccountStatus value, $Res Function(AccountStatus) then) =
      _$AccountStatusCopyWithImpl<$Res, AccountStatus>;
  @useResult
  $Res call(
      {@JsonKey(name: 'isActive') bool isActive,
      @JsonKey(name: 'suspensionReason') String? suspensionReason,
      @JsonKey(name: 'suspendedAt') DateTime? suspendedAt,
      @JsonKey(name: 'suspendedBy') String? suspendedBy,
      @JsonKey(name: 'suspensionEndDate') DateTime? suspensionEndDate});
}

/// @nodoc
class _$AccountStatusCopyWithImpl<$Res, $Val extends AccountStatus>
    implements $AccountStatusCopyWith<$Res> {
  _$AccountStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isActive = null,
    Object? suspensionReason = freezed,
    Object? suspendedAt = freezed,
    Object? suspendedBy = freezed,
    Object? suspensionEndDate = freezed,
  }) {
    return _then(_value.copyWith(
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      suspensionReason: freezed == suspensionReason
          ? _value.suspensionReason
          : suspensionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      suspendedAt: freezed == suspendedAt
          ? _value.suspendedAt
          : suspendedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      suspendedBy: freezed == suspendedBy
          ? _value.suspendedBy
          : suspendedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      suspensionEndDate: freezed == suspensionEndDate
          ? _value.suspensionEndDate
          : suspensionEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountStatusImplCopyWith<$Res>
    implements $AccountStatusCopyWith<$Res> {
  factory _$$AccountStatusImplCopyWith(
          _$AccountStatusImpl value, $Res Function(_$AccountStatusImpl) then) =
      __$$AccountStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'isActive') bool isActive,
      @JsonKey(name: 'suspensionReason') String? suspensionReason,
      @JsonKey(name: 'suspendedAt') DateTime? suspendedAt,
      @JsonKey(name: 'suspendedBy') String? suspendedBy,
      @JsonKey(name: 'suspensionEndDate') DateTime? suspensionEndDate});
}

/// @nodoc
class __$$AccountStatusImplCopyWithImpl<$Res>
    extends _$AccountStatusCopyWithImpl<$Res, _$AccountStatusImpl>
    implements _$$AccountStatusImplCopyWith<$Res> {
  __$$AccountStatusImplCopyWithImpl(
      _$AccountStatusImpl _value, $Res Function(_$AccountStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isActive = null,
    Object? suspensionReason = freezed,
    Object? suspendedAt = freezed,
    Object? suspendedBy = freezed,
    Object? suspensionEndDate = freezed,
  }) {
    return _then(_$AccountStatusImpl(
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      suspensionReason: freezed == suspensionReason
          ? _value.suspensionReason
          : suspensionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      suspendedAt: freezed == suspendedAt
          ? _value.suspendedAt
          : suspendedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      suspendedBy: freezed == suspendedBy
          ? _value.suspendedBy
          : suspendedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      suspensionEndDate: freezed == suspensionEndDate
          ? _value.suspensionEndDate
          : suspensionEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountStatusImpl implements _AccountStatus {
  const _$AccountStatusImpl(
      {@JsonKey(name: 'isActive') this.isActive = true,
      @JsonKey(name: 'suspensionReason') this.suspensionReason,
      @JsonKey(name: 'suspendedAt') this.suspendedAt,
      @JsonKey(name: 'suspendedBy') this.suspendedBy,
      @JsonKey(name: 'suspensionEndDate') this.suspensionEndDate});

  factory _$AccountStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountStatusImplFromJson(json);

  @override
  @JsonKey(name: 'isActive')
  final bool isActive;
  @override
  @JsonKey(name: 'suspensionReason')
  final String? suspensionReason;
  @override
  @JsonKey(name: 'suspendedAt')
  final DateTime? suspendedAt;
  @override
  @JsonKey(name: 'suspendedBy')
  final String? suspendedBy;
  @override
  @JsonKey(name: 'suspensionEndDate')
  final DateTime? suspensionEndDate;

  @override
  String toString() {
    return 'AccountStatus(isActive: $isActive, suspensionReason: $suspensionReason, suspendedAt: $suspendedAt, suspendedBy: $suspendedBy, suspensionEndDate: $suspensionEndDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountStatusImpl &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.suspensionReason, suspensionReason) ||
                other.suspensionReason == suspensionReason) &&
            (identical(other.suspendedAt, suspendedAt) ||
                other.suspendedAt == suspendedAt) &&
            (identical(other.suspendedBy, suspendedBy) ||
                other.suspendedBy == suspendedBy) &&
            (identical(other.suspensionEndDate, suspensionEndDate) ||
                other.suspensionEndDate == suspensionEndDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isActive, suspensionReason,
      suspendedAt, suspendedBy, suspensionEndDate);

  /// Create a copy of AccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountStatusImplCopyWith<_$AccountStatusImpl> get copyWith =>
      __$$AccountStatusImplCopyWithImpl<_$AccountStatusImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AccountStatus value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AccountStatus value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AccountStatus value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountStatusImplToJson(
      this,
    );
  }
}

abstract class _AccountStatus implements AccountStatus {
  const factory _AccountStatus(
      {@JsonKey(name: 'isActive') final bool isActive,
      @JsonKey(name: 'suspensionReason') final String? suspensionReason,
      @JsonKey(name: 'suspendedAt') final DateTime? suspendedAt,
      @JsonKey(name: 'suspendedBy') final String? suspendedBy,
      @JsonKey(name: 'suspensionEndDate')
      final DateTime? suspensionEndDate}) = _$AccountStatusImpl;

  factory _AccountStatus.fromJson(Map<String, dynamic> json) =
      _$AccountStatusImpl.fromJson;

  @override
  @JsonKey(name: 'isActive')
  bool get isActive;
  @override
  @JsonKey(name: 'suspensionReason')
  String? get suspensionReason;
  @override
  @JsonKey(name: 'suspendedAt')
  DateTime? get suspendedAt;
  @override
  @JsonKey(name: 'suspendedBy')
  String? get suspendedBy;
  @override
  @JsonKey(name: 'suspensionEndDate')
  DateTime? get suspensionEndDate;

  /// Create a copy of AccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountStatusImplCopyWith<_$AccountStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MerchantStats _$MerchantStatsFromJson(Map<String, dynamic> json) {
  return _MerchantStats.fromJson(json);
}

/// @nodoc
mixin _$MerchantStats {
  @JsonKey(name: 'totalOrders')
  int get totalOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'totalSales')
  double get totalSales => throw _privateConstructorUsedError;
  @JsonKey(name: 'avgOrderValue')
  double get avgOrderValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'avgRating')
  double get avgRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'ratingCount')
  int get ratingCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'healthScore')
  int get healthScore => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MerchantStats value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MerchantStats value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MerchantStats value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MerchantStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MerchantStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MerchantStatsCopyWith<MerchantStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MerchantStatsCopyWith<$Res> {
  factory $MerchantStatsCopyWith(
          MerchantStats value, $Res Function(MerchantStats) then) =
      _$MerchantStatsCopyWithImpl<$Res, MerchantStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'totalOrders') int totalOrders,
      @JsonKey(name: 'totalSales') double totalSales,
      @JsonKey(name: 'avgOrderValue') double avgOrderValue,
      @JsonKey(name: 'avgRating') double avgRating,
      @JsonKey(name: 'ratingCount') int ratingCount,
      @JsonKey(name: 'healthScore') int healthScore});
}

/// @nodoc
class _$MerchantStatsCopyWithImpl<$Res, $Val extends MerchantStats>
    implements $MerchantStatsCopyWith<$Res> {
  _$MerchantStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MerchantStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalOrders = null,
    Object? totalSales = null,
    Object? avgOrderValue = null,
    Object? avgRating = null,
    Object? ratingCount = null,
    Object? healthScore = null,
  }) {
    return _then(_value.copyWith(
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as double,
      avgOrderValue: null == avgOrderValue
          ? _value.avgOrderValue
          : avgOrderValue // ignore: cast_nullable_to_non_nullable
              as double,
      avgRating: null == avgRating
          ? _value.avgRating
          : avgRating // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _value.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      healthScore: null == healthScore
          ? _value.healthScore
          : healthScore // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MerchantStatsImplCopyWith<$Res>
    implements $MerchantStatsCopyWith<$Res> {
  factory _$$MerchantStatsImplCopyWith(
          _$MerchantStatsImpl value, $Res Function(_$MerchantStatsImpl) then) =
      __$$MerchantStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'totalOrders') int totalOrders,
      @JsonKey(name: 'totalSales') double totalSales,
      @JsonKey(name: 'avgOrderValue') double avgOrderValue,
      @JsonKey(name: 'avgRating') double avgRating,
      @JsonKey(name: 'ratingCount') int ratingCount,
      @JsonKey(name: 'healthScore') int healthScore});
}

/// @nodoc
class __$$MerchantStatsImplCopyWithImpl<$Res>
    extends _$MerchantStatsCopyWithImpl<$Res, _$MerchantStatsImpl>
    implements _$$MerchantStatsImplCopyWith<$Res> {
  __$$MerchantStatsImplCopyWithImpl(
      _$MerchantStatsImpl _value, $Res Function(_$MerchantStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of MerchantStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalOrders = null,
    Object? totalSales = null,
    Object? avgOrderValue = null,
    Object? avgRating = null,
    Object? ratingCount = null,
    Object? healthScore = null,
  }) {
    return _then(_$MerchantStatsImpl(
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as double,
      avgOrderValue: null == avgOrderValue
          ? _value.avgOrderValue
          : avgOrderValue // ignore: cast_nullable_to_non_nullable
              as double,
      avgRating: null == avgRating
          ? _value.avgRating
          : avgRating // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _value.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      healthScore: null == healthScore
          ? _value.healthScore
          : healthScore // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MerchantStatsImpl implements _MerchantStats {
  const _$MerchantStatsImpl(
      {@JsonKey(name: 'totalOrders') this.totalOrders = 0,
      @JsonKey(name: 'totalSales') this.totalSales = 0.0,
      @JsonKey(name: 'avgOrderValue') this.avgOrderValue = 0.0,
      @JsonKey(name: 'avgRating') this.avgRating = 0.0,
      @JsonKey(name: 'ratingCount') this.ratingCount = 0,
      @JsonKey(name: 'healthScore') this.healthScore = 80});

  factory _$MerchantStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MerchantStatsImplFromJson(json);

  @override
  @JsonKey(name: 'totalOrders')
  final int totalOrders;
  @override
  @JsonKey(name: 'totalSales')
  final double totalSales;
  @override
  @JsonKey(name: 'avgOrderValue')
  final double avgOrderValue;
  @override
  @JsonKey(name: 'avgRating')
  final double avgRating;
  @override
  @JsonKey(name: 'ratingCount')
  final int ratingCount;
  @override
  @JsonKey(name: 'healthScore')
  final int healthScore;

  @override
  String toString() {
    return 'MerchantStats(totalOrders: $totalOrders, totalSales: $totalSales, avgOrderValue: $avgOrderValue, avgRating: $avgRating, ratingCount: $ratingCount, healthScore: $healthScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MerchantStatsImpl &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.avgOrderValue, avgOrderValue) ||
                other.avgOrderValue == avgOrderValue) &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.healthScore, healthScore) ||
                other.healthScore == healthScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalOrders, totalSales,
      avgOrderValue, avgRating, ratingCount, healthScore);

  /// Create a copy of MerchantStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MerchantStatsImplCopyWith<_$MerchantStatsImpl> get copyWith =>
      __$$MerchantStatsImplCopyWithImpl<_$MerchantStatsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MerchantStats value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MerchantStats value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MerchantStats value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MerchantStatsImplToJson(
      this,
    );
  }
}

abstract class _MerchantStats implements MerchantStats {
  const factory _MerchantStats(
          {@JsonKey(name: 'totalOrders') final int totalOrders,
          @JsonKey(name: 'totalSales') final double totalSales,
          @JsonKey(name: 'avgOrderValue') final double avgOrderValue,
          @JsonKey(name: 'avgRating') final double avgRating,
          @JsonKey(name: 'ratingCount') final int ratingCount,
          @JsonKey(name: 'healthScore') final int healthScore}) =
      _$MerchantStatsImpl;

  factory _MerchantStats.fromJson(Map<String, dynamic> json) =
      _$MerchantStatsImpl.fromJson;

  @override
  @JsonKey(name: 'totalOrders')
  int get totalOrders;
  @override
  @JsonKey(name: 'totalSales')
  double get totalSales;
  @override
  @JsonKey(name: 'avgOrderValue')
  double get avgOrderValue;
  @override
  @JsonKey(name: 'avgRating')
  double get avgRating;
  @override
  @JsonKey(name: 'ratingCount')
  int get ratingCount;
  @override
  @JsonKey(name: 'healthScore')
  int get healthScore;

  /// Create a copy of MerchantStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MerchantStatsImplCopyWith<_$MerchantStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
