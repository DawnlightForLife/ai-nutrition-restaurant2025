// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutritionist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PersonalInfoModel _$PersonalInfoModelFromJson(Map<String, dynamic> json) {
  return _PersonalInfoModel.fromJson(json);
}

/// @nodoc
mixin _$PersonalInfoModel {
  String get realName => throw _privateConstructorUsedError;
  String get idCardNumber => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PersonalInfoModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PersonalInfoModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PersonalInfoModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this PersonalInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonalInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonalInfoModelCopyWith<PersonalInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonalInfoModelCopyWith<$Res> {
  factory $PersonalInfoModelCopyWith(
          PersonalInfoModel value, $Res Function(PersonalInfoModel) then) =
      _$PersonalInfoModelCopyWithImpl<$Res, PersonalInfoModel>;
  @useResult
  $Res call({String realName, String idCardNumber});
}

/// @nodoc
class _$PersonalInfoModelCopyWithImpl<$Res, $Val extends PersonalInfoModel>
    implements $PersonalInfoModelCopyWith<$Res> {
  _$PersonalInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonalInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? realName = null,
    Object? idCardNumber = null,
  }) {
    return _then(_value.copyWith(
      realName: null == realName
          ? _value.realName
          : realName // ignore: cast_nullable_to_non_nullable
              as String,
      idCardNumber: null == idCardNumber
          ? _value.idCardNumber
          : idCardNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonalInfoModelImplCopyWith<$Res>
    implements $PersonalInfoModelCopyWith<$Res> {
  factory _$$PersonalInfoModelImplCopyWith(_$PersonalInfoModelImpl value,
          $Res Function(_$PersonalInfoModelImpl) then) =
      __$$PersonalInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String realName, String idCardNumber});
}

/// @nodoc
class __$$PersonalInfoModelImplCopyWithImpl<$Res>
    extends _$PersonalInfoModelCopyWithImpl<$Res, _$PersonalInfoModelImpl>
    implements _$$PersonalInfoModelImplCopyWith<$Res> {
  __$$PersonalInfoModelImplCopyWithImpl(_$PersonalInfoModelImpl _value,
      $Res Function(_$PersonalInfoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PersonalInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? realName = null,
    Object? idCardNumber = null,
  }) {
    return _then(_$PersonalInfoModelImpl(
      realName: null == realName
          ? _value.realName
          : realName // ignore: cast_nullable_to_non_nullable
              as String,
      idCardNumber: null == idCardNumber
          ? _value.idCardNumber
          : idCardNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonalInfoModelImpl implements _PersonalInfoModel {
  const _$PersonalInfoModelImpl(
      {required this.realName, required this.idCardNumber});

  factory _$PersonalInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonalInfoModelImplFromJson(json);

  @override
  final String realName;
  @override
  final String idCardNumber;

  @override
  String toString() {
    return 'PersonalInfoModel(realName: $realName, idCardNumber: $idCardNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalInfoModelImpl &&
            (identical(other.realName, realName) ||
                other.realName == realName) &&
            (identical(other.idCardNumber, idCardNumber) ||
                other.idCardNumber == idCardNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, realName, idCardNumber);

  /// Create a copy of PersonalInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonalInfoModelImplCopyWith<_$PersonalInfoModelImpl> get copyWith =>
      __$$PersonalInfoModelImplCopyWithImpl<_$PersonalInfoModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PersonalInfoModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PersonalInfoModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PersonalInfoModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonalInfoModelImplToJson(
      this,
    );
  }
}

abstract class _PersonalInfoModel implements PersonalInfoModel {
  const factory _PersonalInfoModel(
      {required final String realName,
      required final String idCardNumber}) = _$PersonalInfoModelImpl;

  factory _PersonalInfoModel.fromJson(Map<String, dynamic> json) =
      _$PersonalInfoModelImpl.fromJson;

  @override
  String get realName;
  @override
  String get idCardNumber;

  /// Create a copy of PersonalInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonalInfoModelImplCopyWith<_$PersonalInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QualificationsModel _$QualificationsModelFromJson(Map<String, dynamic> json) {
  return _QualificationsModel.fromJson(json);
}

/// @nodoc
mixin _$QualificationsModel {
  String get licenseNumber => throw _privateConstructorUsedError;
  String? get licenseImageUrl => throw _privateConstructorUsedError;
  List<String> get certificationImages => throw _privateConstructorUsedError;
  String? get professionalTitle => throw _privateConstructorUsedError;
  String? get certificationLevel => throw _privateConstructorUsedError;
  String? get issuingAuthority => throw _privateConstructorUsedError;
  DateTime? get issueDate => throw _privateConstructorUsedError;
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  bool get verified => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_QualificationsModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_QualificationsModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_QualificationsModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this QualificationsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QualificationsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QualificationsModelCopyWith<QualificationsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QualificationsModelCopyWith<$Res> {
  factory $QualificationsModelCopyWith(
          QualificationsModel value, $Res Function(QualificationsModel) then) =
      _$QualificationsModelCopyWithImpl<$Res, QualificationsModel>;
  @useResult
  $Res call(
      {String licenseNumber,
      String? licenseImageUrl,
      List<String> certificationImages,
      String? professionalTitle,
      String? certificationLevel,
      String? issuingAuthority,
      DateTime? issueDate,
      DateTime? expiryDate,
      bool verified});
}

/// @nodoc
class _$QualificationsModelCopyWithImpl<$Res, $Val extends QualificationsModel>
    implements $QualificationsModelCopyWith<$Res> {
  _$QualificationsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QualificationsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? licenseNumber = null,
    Object? licenseImageUrl = freezed,
    Object? certificationImages = null,
    Object? professionalTitle = freezed,
    Object? certificationLevel = freezed,
    Object? issuingAuthority = freezed,
    Object? issueDate = freezed,
    Object? expiryDate = freezed,
    Object? verified = null,
  }) {
    return _then(_value.copyWith(
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      licenseImageUrl: freezed == licenseImageUrl
          ? _value.licenseImageUrl
          : licenseImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      certificationImages: null == certificationImages
          ? _value.certificationImages
          : certificationImages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      professionalTitle: freezed == professionalTitle
          ? _value.professionalTitle
          : professionalTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      certificationLevel: freezed == certificationLevel
          ? _value.certificationLevel
          : certificationLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      issuingAuthority: freezed == issuingAuthority
          ? _value.issuingAuthority
          : issuingAuthority // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: freezed == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QualificationsModelImplCopyWith<$Res>
    implements $QualificationsModelCopyWith<$Res> {
  factory _$$QualificationsModelImplCopyWith(_$QualificationsModelImpl value,
          $Res Function(_$QualificationsModelImpl) then) =
      __$$QualificationsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String licenseNumber,
      String? licenseImageUrl,
      List<String> certificationImages,
      String? professionalTitle,
      String? certificationLevel,
      String? issuingAuthority,
      DateTime? issueDate,
      DateTime? expiryDate,
      bool verified});
}

/// @nodoc
class __$$QualificationsModelImplCopyWithImpl<$Res>
    extends _$QualificationsModelCopyWithImpl<$Res, _$QualificationsModelImpl>
    implements _$$QualificationsModelImplCopyWith<$Res> {
  __$$QualificationsModelImplCopyWithImpl(_$QualificationsModelImpl _value,
      $Res Function(_$QualificationsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of QualificationsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? licenseNumber = null,
    Object? licenseImageUrl = freezed,
    Object? certificationImages = null,
    Object? professionalTitle = freezed,
    Object? certificationLevel = freezed,
    Object? issuingAuthority = freezed,
    Object? issueDate = freezed,
    Object? expiryDate = freezed,
    Object? verified = null,
  }) {
    return _then(_$QualificationsModelImpl(
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      licenseImageUrl: freezed == licenseImageUrl
          ? _value.licenseImageUrl
          : licenseImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      certificationImages: null == certificationImages
          ? _value._certificationImages
          : certificationImages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      professionalTitle: freezed == professionalTitle
          ? _value.professionalTitle
          : professionalTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      certificationLevel: freezed == certificationLevel
          ? _value.certificationLevel
          : certificationLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      issuingAuthority: freezed == issuingAuthority
          ? _value.issuingAuthority
          : issuingAuthority // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: freezed == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QualificationsModelImpl implements _QualificationsModel {
  const _$QualificationsModelImpl(
      {required this.licenseNumber,
      this.licenseImageUrl,
      final List<String> certificationImages = const [],
      this.professionalTitle,
      this.certificationLevel,
      this.issuingAuthority,
      this.issueDate,
      this.expiryDate,
      this.verified = false})
      : _certificationImages = certificationImages;

  factory _$QualificationsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QualificationsModelImplFromJson(json);

  @override
  final String licenseNumber;
  @override
  final String? licenseImageUrl;
  final List<String> _certificationImages;
  @override
  @JsonKey()
  List<String> get certificationImages {
    if (_certificationImages is EqualUnmodifiableListView)
      return _certificationImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_certificationImages);
  }

  @override
  final String? professionalTitle;
  @override
  final String? certificationLevel;
  @override
  final String? issuingAuthority;
  @override
  final DateTime? issueDate;
  @override
  final DateTime? expiryDate;
  @override
  @JsonKey()
  final bool verified;

  @override
  String toString() {
    return 'QualificationsModel(licenseNumber: $licenseNumber, licenseImageUrl: $licenseImageUrl, certificationImages: $certificationImages, professionalTitle: $professionalTitle, certificationLevel: $certificationLevel, issuingAuthority: $issuingAuthority, issueDate: $issueDate, expiryDate: $expiryDate, verified: $verified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QualificationsModelImpl &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.licenseImageUrl, licenseImageUrl) ||
                other.licenseImageUrl == licenseImageUrl) &&
            const DeepCollectionEquality()
                .equals(other._certificationImages, _certificationImages) &&
            (identical(other.professionalTitle, professionalTitle) ||
                other.professionalTitle == professionalTitle) &&
            (identical(other.certificationLevel, certificationLevel) ||
                other.certificationLevel == certificationLevel) &&
            (identical(other.issuingAuthority, issuingAuthority) ||
                other.issuingAuthority == issuingAuthority) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.verified, verified) ||
                other.verified == verified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      licenseNumber,
      licenseImageUrl,
      const DeepCollectionEquality().hash(_certificationImages),
      professionalTitle,
      certificationLevel,
      issuingAuthority,
      issueDate,
      expiryDate,
      verified);

  /// Create a copy of QualificationsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QualificationsModelImplCopyWith<_$QualificationsModelImpl> get copyWith =>
      __$$QualificationsModelImplCopyWithImpl<_$QualificationsModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_QualificationsModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_QualificationsModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_QualificationsModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$QualificationsModelImplToJson(
      this,
    );
  }
}

abstract class _QualificationsModel implements QualificationsModel {
  const factory _QualificationsModel(
      {required final String licenseNumber,
      final String? licenseImageUrl,
      final List<String> certificationImages,
      final String? professionalTitle,
      final String? certificationLevel,
      final String? issuingAuthority,
      final DateTime? issueDate,
      final DateTime? expiryDate,
      final bool verified}) = _$QualificationsModelImpl;

  factory _QualificationsModel.fromJson(Map<String, dynamic> json) =
      _$QualificationsModelImpl.fromJson;

  @override
  String get licenseNumber;
  @override
  String? get licenseImageUrl;
  @override
  List<String> get certificationImages;
  @override
  String? get professionalTitle;
  @override
  String? get certificationLevel;
  @override
  String? get issuingAuthority;
  @override
  DateTime? get issueDate;
  @override
  DateTime? get expiryDate;
  @override
  bool get verified;

  /// Create a copy of QualificationsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QualificationsModelImplCopyWith<_$QualificationsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfessionalInfoModel _$ProfessionalInfoModelFromJson(
    Map<String, dynamic> json) {
  return _ProfessionalInfoModel.fromJson(json);
}

/// @nodoc
mixin _$ProfessionalInfoModel {
  List<String> get specializations => throw _privateConstructorUsedError;
  int get experienceYears => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get education =>
      throw _privateConstructorUsedError;
  List<String> get languages => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProfessionalInfoModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProfessionalInfoModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProfessionalInfoModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ProfessionalInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfessionalInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfessionalInfoModelCopyWith<ProfessionalInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfessionalInfoModelCopyWith<$Res> {
  factory $ProfessionalInfoModelCopyWith(ProfessionalInfoModel value,
          $Res Function(ProfessionalInfoModel) then) =
      _$ProfessionalInfoModelCopyWithImpl<$Res, ProfessionalInfoModel>;
  @useResult
  $Res call(
      {List<String> specializations,
      int experienceYears,
      List<Map<String, dynamic>> education,
      List<String> languages,
      String? bio});
}

/// @nodoc
class _$ProfessionalInfoModelCopyWithImpl<$Res,
        $Val extends ProfessionalInfoModel>
    implements $ProfessionalInfoModelCopyWith<$Res> {
  _$ProfessionalInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfessionalInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? specializations = null,
    Object? experienceYears = null,
    Object? education = null,
    Object? languages = null,
    Object? bio = freezed,
  }) {
    return _then(_value.copyWith(
      specializations: null == specializations
          ? _value.specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      experienceYears: null == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int,
      education: null == education
          ? _value.education
          : education // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      languages: null == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfessionalInfoModelImplCopyWith<$Res>
    implements $ProfessionalInfoModelCopyWith<$Res> {
  factory _$$ProfessionalInfoModelImplCopyWith(
          _$ProfessionalInfoModelImpl value,
          $Res Function(_$ProfessionalInfoModelImpl) then) =
      __$$ProfessionalInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> specializations,
      int experienceYears,
      List<Map<String, dynamic>> education,
      List<String> languages,
      String? bio});
}

/// @nodoc
class __$$ProfessionalInfoModelImplCopyWithImpl<$Res>
    extends _$ProfessionalInfoModelCopyWithImpl<$Res,
        _$ProfessionalInfoModelImpl>
    implements _$$ProfessionalInfoModelImplCopyWith<$Res> {
  __$$ProfessionalInfoModelImplCopyWithImpl(_$ProfessionalInfoModelImpl _value,
      $Res Function(_$ProfessionalInfoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfessionalInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? specializations = null,
    Object? experienceYears = null,
    Object? education = null,
    Object? languages = null,
    Object? bio = freezed,
  }) {
    return _then(_$ProfessionalInfoModelImpl(
      specializations: null == specializations
          ? _value._specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      experienceYears: null == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int,
      education: null == education
          ? _value._education
          : education // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      languages: null == languages
          ? _value._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfessionalInfoModelImpl implements _ProfessionalInfoModel {
  const _$ProfessionalInfoModelImpl(
      {final List<String> specializations = const [],
      this.experienceYears = 0,
      final List<Map<String, dynamic>> education = const [],
      final List<String> languages = const [],
      this.bio})
      : _specializations = specializations,
        _education = education,
        _languages = languages;

  factory _$ProfessionalInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfessionalInfoModelImplFromJson(json);

  final List<String> _specializations;
  @override
  @JsonKey()
  List<String> get specializations {
    if (_specializations is EqualUnmodifiableListView) return _specializations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specializations);
  }

  @override
  @JsonKey()
  final int experienceYears;
  final List<Map<String, dynamic>> _education;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get education {
    if (_education is EqualUnmodifiableListView) return _education;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_education);
  }

  final List<String> _languages;
  @override
  @JsonKey()
  List<String> get languages {
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_languages);
  }

  @override
  final String? bio;

  @override
  String toString() {
    return 'ProfessionalInfoModel(specializations: $specializations, experienceYears: $experienceYears, education: $education, languages: $languages, bio: $bio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfessionalInfoModelImpl &&
            const DeepCollectionEquality()
                .equals(other._specializations, _specializations) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            const DeepCollectionEquality()
                .equals(other._education, _education) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages) &&
            (identical(other.bio, bio) || other.bio == bio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_specializations),
      experienceYears,
      const DeepCollectionEquality().hash(_education),
      const DeepCollectionEquality().hash(_languages),
      bio);

  /// Create a copy of ProfessionalInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfessionalInfoModelImplCopyWith<_$ProfessionalInfoModelImpl>
      get copyWith => __$$ProfessionalInfoModelImplCopyWithImpl<
          _$ProfessionalInfoModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProfessionalInfoModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProfessionalInfoModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProfessionalInfoModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfessionalInfoModelImplToJson(
      this,
    );
  }
}

abstract class _ProfessionalInfoModel implements ProfessionalInfoModel {
  const factory _ProfessionalInfoModel(
      {final List<String> specializations,
      final int experienceYears,
      final List<Map<String, dynamic>> education,
      final List<String> languages,
      final String? bio}) = _$ProfessionalInfoModelImpl;

  factory _ProfessionalInfoModel.fromJson(Map<String, dynamic> json) =
      _$ProfessionalInfoModelImpl.fromJson;

  @override
  List<String> get specializations;
  @override
  int get experienceYears;
  @override
  List<Map<String, dynamic>> get education;
  @override
  List<String> get languages;
  @override
  String? get bio;

  /// Create a copy of ProfessionalInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfessionalInfoModelImplCopyWith<_$ProfessionalInfoModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ServiceInfoModel _$ServiceInfoModelFromJson(Map<String, dynamic> json) {
  return _ServiceInfoModel.fromJson(json);
}

/// @nodoc
mixin _$ServiceInfoModel {
  double get consultationFee => throw _privateConstructorUsedError;
  int get consultationDuration => throw _privateConstructorUsedError;
  bool get availableOnline => throw _privateConstructorUsedError;
  bool get availableInPerson => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get inPersonLocations =>
      throw _privateConstructorUsedError;
  List<String> get serviceTags => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get availableTimeSlots =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ServiceInfoModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ServiceInfoModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ServiceInfoModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ServiceInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceInfoModelCopyWith<ServiceInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceInfoModelCopyWith<$Res> {
  factory $ServiceInfoModelCopyWith(
          ServiceInfoModel value, $Res Function(ServiceInfoModel) then) =
      _$ServiceInfoModelCopyWithImpl<$Res, ServiceInfoModel>;
  @useResult
  $Res call(
      {double consultationFee,
      int consultationDuration,
      bool availableOnline,
      bool availableInPerson,
      List<Map<String, dynamic>> inPersonLocations,
      List<String> serviceTags,
      List<Map<String, dynamic>> availableTimeSlots});
}

/// @nodoc
class _$ServiceInfoModelCopyWithImpl<$Res, $Val extends ServiceInfoModel>
    implements $ServiceInfoModelCopyWith<$Res> {
  _$ServiceInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consultationFee = null,
    Object? consultationDuration = null,
    Object? availableOnline = null,
    Object? availableInPerson = null,
    Object? inPersonLocations = null,
    Object? serviceTags = null,
    Object? availableTimeSlots = null,
  }) {
    return _then(_value.copyWith(
      consultationFee: null == consultationFee
          ? _value.consultationFee
          : consultationFee // ignore: cast_nullable_to_non_nullable
              as double,
      consultationDuration: null == consultationDuration
          ? _value.consultationDuration
          : consultationDuration // ignore: cast_nullable_to_non_nullable
              as int,
      availableOnline: null == availableOnline
          ? _value.availableOnline
          : availableOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      availableInPerson: null == availableInPerson
          ? _value.availableInPerson
          : availableInPerson // ignore: cast_nullable_to_non_nullable
              as bool,
      inPersonLocations: null == inPersonLocations
          ? _value.inPersonLocations
          : inPersonLocations // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      serviceTags: null == serviceTags
          ? _value.serviceTags
          : serviceTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      availableTimeSlots: null == availableTimeSlots
          ? _value.availableTimeSlots
          : availableTimeSlots // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceInfoModelImplCopyWith<$Res>
    implements $ServiceInfoModelCopyWith<$Res> {
  factory _$$ServiceInfoModelImplCopyWith(_$ServiceInfoModelImpl value,
          $Res Function(_$ServiceInfoModelImpl) then) =
      __$$ServiceInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double consultationFee,
      int consultationDuration,
      bool availableOnline,
      bool availableInPerson,
      List<Map<String, dynamic>> inPersonLocations,
      List<String> serviceTags,
      List<Map<String, dynamic>> availableTimeSlots});
}

/// @nodoc
class __$$ServiceInfoModelImplCopyWithImpl<$Res>
    extends _$ServiceInfoModelCopyWithImpl<$Res, _$ServiceInfoModelImpl>
    implements _$$ServiceInfoModelImplCopyWith<$Res> {
  __$$ServiceInfoModelImplCopyWithImpl(_$ServiceInfoModelImpl _value,
      $Res Function(_$ServiceInfoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consultationFee = null,
    Object? consultationDuration = null,
    Object? availableOnline = null,
    Object? availableInPerson = null,
    Object? inPersonLocations = null,
    Object? serviceTags = null,
    Object? availableTimeSlots = null,
  }) {
    return _then(_$ServiceInfoModelImpl(
      consultationFee: null == consultationFee
          ? _value.consultationFee
          : consultationFee // ignore: cast_nullable_to_non_nullable
              as double,
      consultationDuration: null == consultationDuration
          ? _value.consultationDuration
          : consultationDuration // ignore: cast_nullable_to_non_nullable
              as int,
      availableOnline: null == availableOnline
          ? _value.availableOnline
          : availableOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      availableInPerson: null == availableInPerson
          ? _value.availableInPerson
          : availableInPerson // ignore: cast_nullable_to_non_nullable
              as bool,
      inPersonLocations: null == inPersonLocations
          ? _value._inPersonLocations
          : inPersonLocations // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      serviceTags: null == serviceTags
          ? _value._serviceTags
          : serviceTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      availableTimeSlots: null == availableTimeSlots
          ? _value._availableTimeSlots
          : availableTimeSlots // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceInfoModelImpl implements _ServiceInfoModel {
  const _$ServiceInfoModelImpl(
      {this.consultationFee = 0,
      this.consultationDuration = 60,
      this.availableOnline = true,
      this.availableInPerson = false,
      final List<Map<String, dynamic>> inPersonLocations = const [],
      final List<String> serviceTags = const [],
      final List<Map<String, dynamic>> availableTimeSlots = const []})
      : _inPersonLocations = inPersonLocations,
        _serviceTags = serviceTags,
        _availableTimeSlots = availableTimeSlots;

  factory _$ServiceInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceInfoModelImplFromJson(json);

  @override
  @JsonKey()
  final double consultationFee;
  @override
  @JsonKey()
  final int consultationDuration;
  @override
  @JsonKey()
  final bool availableOnline;
  @override
  @JsonKey()
  final bool availableInPerson;
  final List<Map<String, dynamic>> _inPersonLocations;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get inPersonLocations {
    if (_inPersonLocations is EqualUnmodifiableListView)
      return _inPersonLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inPersonLocations);
  }

  final List<String> _serviceTags;
  @override
  @JsonKey()
  List<String> get serviceTags {
    if (_serviceTags is EqualUnmodifiableListView) return _serviceTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_serviceTags);
  }

  final List<Map<String, dynamic>> _availableTimeSlots;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get availableTimeSlots {
    if (_availableTimeSlots is EqualUnmodifiableListView)
      return _availableTimeSlots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableTimeSlots);
  }

  @override
  String toString() {
    return 'ServiceInfoModel(consultationFee: $consultationFee, consultationDuration: $consultationDuration, availableOnline: $availableOnline, availableInPerson: $availableInPerson, inPersonLocations: $inPersonLocations, serviceTags: $serviceTags, availableTimeSlots: $availableTimeSlots)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceInfoModelImpl &&
            (identical(other.consultationFee, consultationFee) ||
                other.consultationFee == consultationFee) &&
            (identical(other.consultationDuration, consultationDuration) ||
                other.consultationDuration == consultationDuration) &&
            (identical(other.availableOnline, availableOnline) ||
                other.availableOnline == availableOnline) &&
            (identical(other.availableInPerson, availableInPerson) ||
                other.availableInPerson == availableInPerson) &&
            const DeepCollectionEquality()
                .equals(other._inPersonLocations, _inPersonLocations) &&
            const DeepCollectionEquality()
                .equals(other._serviceTags, _serviceTags) &&
            const DeepCollectionEquality()
                .equals(other._availableTimeSlots, _availableTimeSlots));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      consultationFee,
      consultationDuration,
      availableOnline,
      availableInPerson,
      const DeepCollectionEquality().hash(_inPersonLocations),
      const DeepCollectionEquality().hash(_serviceTags),
      const DeepCollectionEquality().hash(_availableTimeSlots));

  /// Create a copy of ServiceInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceInfoModelImplCopyWith<_$ServiceInfoModelImpl> get copyWith =>
      __$$ServiceInfoModelImplCopyWithImpl<_$ServiceInfoModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ServiceInfoModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ServiceInfoModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ServiceInfoModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceInfoModelImplToJson(
      this,
    );
  }
}

abstract class _ServiceInfoModel implements ServiceInfoModel {
  const factory _ServiceInfoModel(
          {final double consultationFee,
          final int consultationDuration,
          final bool availableOnline,
          final bool availableInPerson,
          final List<Map<String, dynamic>> inPersonLocations,
          final List<String> serviceTags,
          final List<Map<String, dynamic>> availableTimeSlots}) =
      _$ServiceInfoModelImpl;

  factory _ServiceInfoModel.fromJson(Map<String, dynamic> json) =
      _$ServiceInfoModelImpl.fromJson;

  @override
  double get consultationFee;
  @override
  int get consultationDuration;
  @override
  bool get availableOnline;
  @override
  bool get availableInPerson;
  @override
  List<Map<String, dynamic>> get inPersonLocations;
  @override
  List<String> get serviceTags;
  @override
  List<Map<String, dynamic>> get availableTimeSlots;

  /// Create a copy of ServiceInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceInfoModelImplCopyWith<_$ServiceInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RatingsModel _$RatingsModelFromJson(Map<String, dynamic> json) {
  return _RatingsModel.fromJson(json);
}

/// @nodoc
mixin _$RatingsModel {
  double get averageRating => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RatingsModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RatingsModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RatingsModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this RatingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RatingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RatingsModelCopyWith<RatingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RatingsModelCopyWith<$Res> {
  factory $RatingsModelCopyWith(
          RatingsModel value, $Res Function(RatingsModel) then) =
      _$RatingsModelCopyWithImpl<$Res, RatingsModel>;
  @useResult
  $Res call({double averageRating, int totalReviews});
}

/// @nodoc
class _$RatingsModelCopyWithImpl<$Res, $Val extends RatingsModel>
    implements $RatingsModelCopyWith<$Res> {
  _$RatingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RatingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageRating = null,
    Object? totalReviews = null,
  }) {
    return _then(_value.copyWith(
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RatingsModelImplCopyWith<$Res>
    implements $RatingsModelCopyWith<$Res> {
  factory _$$RatingsModelImplCopyWith(
          _$RatingsModelImpl value, $Res Function(_$RatingsModelImpl) then) =
      __$$RatingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double averageRating, int totalReviews});
}

/// @nodoc
class __$$RatingsModelImplCopyWithImpl<$Res>
    extends _$RatingsModelCopyWithImpl<$Res, _$RatingsModelImpl>
    implements _$$RatingsModelImplCopyWith<$Res> {
  __$$RatingsModelImplCopyWithImpl(
      _$RatingsModelImpl _value, $Res Function(_$RatingsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RatingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageRating = null,
    Object? totalReviews = null,
  }) {
    return _then(_$RatingsModelImpl(
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RatingsModelImpl implements _RatingsModel {
  const _$RatingsModelImpl({this.averageRating = 0.0, this.totalReviews = 0});

  factory _$RatingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RatingsModelImplFromJson(json);

  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final int totalReviews;

  @override
  String toString() {
    return 'RatingsModel(averageRating: $averageRating, totalReviews: $totalReviews)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RatingsModelImpl &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, averageRating, totalReviews);

  /// Create a copy of RatingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RatingsModelImplCopyWith<_$RatingsModelImpl> get copyWith =>
      __$$RatingsModelImplCopyWithImpl<_$RatingsModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RatingsModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RatingsModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RatingsModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RatingsModelImplToJson(
      this,
    );
  }
}

abstract class _RatingsModel implements RatingsModel {
  const factory _RatingsModel(
      {final double averageRating,
      final int totalReviews}) = _$RatingsModelImpl;

  factory _RatingsModel.fromJson(Map<String, dynamic> json) =
      _$RatingsModelImpl.fromJson;

  @override
  double get averageRating;
  @override
  int get totalReviews;

  /// Create a copy of RatingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RatingsModelImplCopyWith<_$RatingsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VerificationModel _$VerificationModelFromJson(Map<String, dynamic> json) {
  return _VerificationModel.fromJson(json);
}

/// @nodoc
mixin _$VerificationModel {
  String get verificationStatus => throw _privateConstructorUsedError;
  String? get rejectedReason => throw _privateConstructorUsedError;
  String? get reviewedBy => throw _privateConstructorUsedError;
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get verificationHistory =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_VerificationModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_VerificationModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_VerificationModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this VerificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerificationModelCopyWith<VerificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationModelCopyWith<$Res> {
  factory $VerificationModelCopyWith(
          VerificationModel value, $Res Function(VerificationModel) then) =
      _$VerificationModelCopyWithImpl<$Res, VerificationModel>;
  @useResult
  $Res call(
      {String verificationStatus,
      String? rejectedReason,
      String? reviewedBy,
      DateTime? reviewedAt,
      List<Map<String, dynamic>> verificationHistory});
}

/// @nodoc
class _$VerificationModelCopyWithImpl<$Res, $Val extends VerificationModel>
    implements $VerificationModelCopyWith<$Res> {
  _$VerificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verificationStatus = null,
    Object? rejectedReason = freezed,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
    Object? verificationHistory = null,
  }) {
    return _then(_value.copyWith(
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      rejectedReason: freezed == rejectedReason
          ? _value.rejectedReason
          : rejectedReason // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verificationHistory: null == verificationHistory
          ? _value.verificationHistory
          : verificationHistory // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerificationModelImplCopyWith<$Res>
    implements $VerificationModelCopyWith<$Res> {
  factory _$$VerificationModelImplCopyWith(_$VerificationModelImpl value,
          $Res Function(_$VerificationModelImpl) then) =
      __$$VerificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String verificationStatus,
      String? rejectedReason,
      String? reviewedBy,
      DateTime? reviewedAt,
      List<Map<String, dynamic>> verificationHistory});
}

/// @nodoc
class __$$VerificationModelImplCopyWithImpl<$Res>
    extends _$VerificationModelCopyWithImpl<$Res, _$VerificationModelImpl>
    implements _$$VerificationModelImplCopyWith<$Res> {
  __$$VerificationModelImplCopyWithImpl(_$VerificationModelImpl _value,
      $Res Function(_$VerificationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of VerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verificationStatus = null,
    Object? rejectedReason = freezed,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
    Object? verificationHistory = null,
  }) {
    return _then(_$VerificationModelImpl(
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      rejectedReason: freezed == rejectedReason
          ? _value.rejectedReason
          : rejectedReason // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verificationHistory: null == verificationHistory
          ? _value._verificationHistory
          : verificationHistory // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationModelImpl implements _VerificationModel {
  const _$VerificationModelImpl(
      {this.verificationStatus = 'pending',
      this.rejectedReason,
      this.reviewedBy,
      this.reviewedAt,
      final List<Map<String, dynamic>> verificationHistory = const []})
      : _verificationHistory = verificationHistory;

  factory _$VerificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationModelImplFromJson(json);

  @override
  @JsonKey()
  final String verificationStatus;
  @override
  final String? rejectedReason;
  @override
  final String? reviewedBy;
  @override
  final DateTime? reviewedAt;
  final List<Map<String, dynamic>> _verificationHistory;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get verificationHistory {
    if (_verificationHistory is EqualUnmodifiableListView)
      return _verificationHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_verificationHistory);
  }

  @override
  String toString() {
    return 'VerificationModel(verificationStatus: $verificationStatus, rejectedReason: $rejectedReason, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, verificationHistory: $verificationHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationModelImpl &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.rejectedReason, rejectedReason) ||
                other.rejectedReason == rejectedReason) &&
            (identical(other.reviewedBy, reviewedBy) ||
                other.reviewedBy == reviewedBy) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            const DeepCollectionEquality()
                .equals(other._verificationHistory, _verificationHistory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      verificationStatus,
      rejectedReason,
      reviewedBy,
      reviewedAt,
      const DeepCollectionEquality().hash(_verificationHistory));

  /// Create a copy of VerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationModelImplCopyWith<_$VerificationModelImpl> get copyWith =>
      __$$VerificationModelImplCopyWithImpl<_$VerificationModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_VerificationModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_VerificationModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_VerificationModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationModelImplToJson(
      this,
    );
  }
}

abstract class _VerificationModel implements VerificationModel {
  const factory _VerificationModel(
          {final String verificationStatus,
          final String? rejectedReason,
          final String? reviewedBy,
          final DateTime? reviewedAt,
          final List<Map<String, dynamic>> verificationHistory}) =
      _$VerificationModelImpl;

  factory _VerificationModel.fromJson(Map<String, dynamic> json) =
      _$VerificationModelImpl.fromJson;

  @override
  String get verificationStatus;
  @override
  String? get rejectedReason;
  @override
  String? get reviewedBy;
  @override
  DateTime? get reviewedAt;
  @override
  List<Map<String, dynamic>> get verificationHistory;

  /// Create a copy of VerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerificationModelImplCopyWith<_$VerificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OnlineStatusModel _$OnlineStatusModelFromJson(Map<String, dynamic> json) {
  return _OnlineStatusModel.fromJson(json);
}

/// @nodoc
mixin _$OnlineStatusModel {
  bool get isOnline => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  DateTime? get lastActiveAt => throw _privateConstructorUsedError;
  String? get statusMessage => throw _privateConstructorUsedError;
  List<String> get availableConsultationTypes =>
      throw _privateConstructorUsedError;
  double get averageResponseTime => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OnlineStatusModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OnlineStatusModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OnlineStatusModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OnlineStatusModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnlineStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnlineStatusModelCopyWith<OnlineStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnlineStatusModelCopyWith<$Res> {
  factory $OnlineStatusModelCopyWith(
          OnlineStatusModel value, $Res Function(OnlineStatusModel) then) =
      _$OnlineStatusModelCopyWithImpl<$Res, OnlineStatusModel>;
  @useResult
  $Res call(
      {bool isOnline,
      bool isAvailable,
      DateTime? lastActiveAt,
      String? statusMessage,
      List<String> availableConsultationTypes,
      double averageResponseTime,
      DateTime? lastUpdated});
}

/// @nodoc
class _$OnlineStatusModelCopyWithImpl<$Res, $Val extends OnlineStatusModel>
    implements $OnlineStatusModelCopyWith<$Res> {
  _$OnlineStatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnlineStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOnline = null,
    Object? isAvailable = null,
    Object? lastActiveAt = freezed,
    Object? statusMessage = freezed,
    Object? availableConsultationTypes = null,
    Object? averageResponseTime = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      lastActiveAt: freezed == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      statusMessage: freezed == statusMessage
          ? _value.statusMessage
          : statusMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      availableConsultationTypes: null == availableConsultationTypes
          ? _value.availableConsultationTypes
          : availableConsultationTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      averageResponseTime: null == averageResponseTime
          ? _value.averageResponseTime
          : averageResponseTime // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnlineStatusModelImplCopyWith<$Res>
    implements $OnlineStatusModelCopyWith<$Res> {
  factory _$$OnlineStatusModelImplCopyWith(_$OnlineStatusModelImpl value,
          $Res Function(_$OnlineStatusModelImpl) then) =
      __$$OnlineStatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isOnline,
      bool isAvailable,
      DateTime? lastActiveAt,
      String? statusMessage,
      List<String> availableConsultationTypes,
      double averageResponseTime,
      DateTime? lastUpdated});
}

/// @nodoc
class __$$OnlineStatusModelImplCopyWithImpl<$Res>
    extends _$OnlineStatusModelCopyWithImpl<$Res, _$OnlineStatusModelImpl>
    implements _$$OnlineStatusModelImplCopyWith<$Res> {
  __$$OnlineStatusModelImplCopyWithImpl(_$OnlineStatusModelImpl _value,
      $Res Function(_$OnlineStatusModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OnlineStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOnline = null,
    Object? isAvailable = null,
    Object? lastActiveAt = freezed,
    Object? statusMessage = freezed,
    Object? availableConsultationTypes = null,
    Object? averageResponseTime = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$OnlineStatusModelImpl(
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      lastActiveAt: freezed == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      statusMessage: freezed == statusMessage
          ? _value.statusMessage
          : statusMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      availableConsultationTypes: null == availableConsultationTypes
          ? _value._availableConsultationTypes
          : availableConsultationTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      averageResponseTime: null == averageResponseTime
          ? _value.averageResponseTime
          : averageResponseTime // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OnlineStatusModelImpl implements _OnlineStatusModel {
  const _$OnlineStatusModelImpl(
      {this.isOnline = false,
      this.isAvailable = false,
      this.lastActiveAt,
      this.statusMessage,
      final List<String> availableConsultationTypes = const [],
      this.averageResponseTime = 0.0,
      this.lastUpdated})
      : _availableConsultationTypes = availableConsultationTypes;

  factory _$OnlineStatusModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnlineStatusModelImplFromJson(json);

  @override
  @JsonKey()
  final bool isOnline;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  final DateTime? lastActiveAt;
  @override
  final String? statusMessage;
  final List<String> _availableConsultationTypes;
  @override
  @JsonKey()
  List<String> get availableConsultationTypes {
    if (_availableConsultationTypes is EqualUnmodifiableListView)
      return _availableConsultationTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableConsultationTypes);
  }

  @override
  @JsonKey()
  final double averageResponseTime;
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'OnlineStatusModel(isOnline: $isOnline, isAvailable: $isAvailable, lastActiveAt: $lastActiveAt, statusMessage: $statusMessage, availableConsultationTypes: $availableConsultationTypes, averageResponseTime: $averageResponseTime, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnlineStatusModelImpl &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt) &&
            (identical(other.statusMessage, statusMessage) ||
                other.statusMessage == statusMessage) &&
            const DeepCollectionEquality().equals(
                other._availableConsultationTypes,
                _availableConsultationTypes) &&
            (identical(other.averageResponseTime, averageResponseTime) ||
                other.averageResponseTime == averageResponseTime) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isOnline,
      isAvailable,
      lastActiveAt,
      statusMessage,
      const DeepCollectionEquality().hash(_availableConsultationTypes),
      averageResponseTime,
      lastUpdated);

  /// Create a copy of OnlineStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnlineStatusModelImplCopyWith<_$OnlineStatusModelImpl> get copyWith =>
      __$$OnlineStatusModelImplCopyWithImpl<_$OnlineStatusModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OnlineStatusModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OnlineStatusModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OnlineStatusModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OnlineStatusModelImplToJson(
      this,
    );
  }
}

abstract class _OnlineStatusModel implements OnlineStatusModel {
  const factory _OnlineStatusModel(
      {final bool isOnline,
      final bool isAvailable,
      final DateTime? lastActiveAt,
      final String? statusMessage,
      final List<String> availableConsultationTypes,
      final double averageResponseTime,
      final DateTime? lastUpdated}) = _$OnlineStatusModelImpl;

  factory _OnlineStatusModel.fromJson(Map<String, dynamic> json) =
      _$OnlineStatusModelImpl.fromJson;

  @override
  bool get isOnline;
  @override
  bool get isAvailable;
  @override
  DateTime? get lastActiveAt;
  @override
  String? get statusMessage;
  @override
  List<String> get availableConsultationTypes;
  @override
  double get averageResponseTime;
  @override
  DateTime? get lastUpdated;

  /// Create a copy of OnlineStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnlineStatusModelImplCopyWith<_$OnlineStatusModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionistModel _$NutritionistModelFromJson(Map<String, dynamic> json) {
  return _NutritionistModel.fromJson(json);
}

/// @nodoc
mixin _$NutritionistModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get certificationApplicationId => throw _privateConstructorUsedError;
  PersonalInfoModel get personalInfo => throw _privateConstructorUsedError;
  QualificationsModel get qualifications => throw _privateConstructorUsedError;
  ProfessionalInfoModel get professionalInfo =>
      throw _privateConstructorUsedError;
  ServiceInfoModel get serviceInfo => throw _privateConstructorUsedError;
  RatingsModel get ratings => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  VerificationModel get verification => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get affiliations =>
      throw _privateConstructorUsedError;
  OnlineStatusModel? get onlineStatus => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionistModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionistModelCopyWith<NutritionistModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionistModelCopyWith<$Res> {
  factory $NutritionistModelCopyWith(
          NutritionistModel value, $Res Function(NutritionistModel) then) =
      _$NutritionistModelCopyWithImpl<$Res, NutritionistModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String userId,
      String? certificationApplicationId,
      PersonalInfoModel personalInfo,
      QualificationsModel qualifications,
      ProfessionalInfoModel professionalInfo,
      ServiceInfoModel serviceInfo,
      RatingsModel ratings,
      String status,
      VerificationModel verification,
      List<Map<String, dynamic>> affiliations,
      OnlineStatusModel? onlineStatus,
      DateTime createdAt,
      DateTime updatedAt});

  $PersonalInfoModelCopyWith<$Res> get personalInfo;
  $QualificationsModelCopyWith<$Res> get qualifications;
  $ProfessionalInfoModelCopyWith<$Res> get professionalInfo;
  $ServiceInfoModelCopyWith<$Res> get serviceInfo;
  $RatingsModelCopyWith<$Res> get ratings;
  $VerificationModelCopyWith<$Res> get verification;
  $OnlineStatusModelCopyWith<$Res>? get onlineStatus;
}

/// @nodoc
class _$NutritionistModelCopyWithImpl<$Res, $Val extends NutritionistModel>
    implements $NutritionistModelCopyWith<$Res> {
  _$NutritionistModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? certificationApplicationId = freezed,
    Object? personalInfo = null,
    Object? qualifications = null,
    Object? professionalInfo = null,
    Object? serviceInfo = null,
    Object? ratings = null,
    Object? status = null,
    Object? verification = null,
    Object? affiliations = null,
    Object? onlineStatus = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      certificationApplicationId: freezed == certificationApplicationId
          ? _value.certificationApplicationId
          : certificationApplicationId // ignore: cast_nullable_to_non_nullable
              as String?,
      personalInfo: null == personalInfo
          ? _value.personalInfo
          : personalInfo // ignore: cast_nullable_to_non_nullable
              as PersonalInfoModel,
      qualifications: null == qualifications
          ? _value.qualifications
          : qualifications // ignore: cast_nullable_to_non_nullable
              as QualificationsModel,
      professionalInfo: null == professionalInfo
          ? _value.professionalInfo
          : professionalInfo // ignore: cast_nullable_to_non_nullable
              as ProfessionalInfoModel,
      serviceInfo: null == serviceInfo
          ? _value.serviceInfo
          : serviceInfo // ignore: cast_nullable_to_non_nullable
              as ServiceInfoModel,
      ratings: null == ratings
          ? _value.ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as RatingsModel,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      verification: null == verification
          ? _value.verification
          : verification // ignore: cast_nullable_to_non_nullable
              as VerificationModel,
      affiliations: null == affiliations
          ? _value.affiliations
          : affiliations // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      onlineStatus: freezed == onlineStatus
          ? _value.onlineStatus
          : onlineStatus // ignore: cast_nullable_to_non_nullable
              as OnlineStatusModel?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of NutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonalInfoModelCopyWith<$Res> get personalInfo {
    return $PersonalInfoModelCopyWith<$Res>(_value.personalInfo, (value) {
      return _then(_value.copyWith(personalInfo: value) as $Val);
    });
  }

  /// Create a copy of NutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QualificationsModelCopyWith<$Res> get qualifications {
    return $QualificationsModelCopyWith<$Res>(_value.qualifications, (value) {
      return _then(_value.copyWith(qualifications: value) as $Val);
    });
  }

  /// Create a copy of NutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfessionalInfoModelCopyWith<$Res> get professionalInfo {
    return $ProfessionalInfoModelCopyWith<$Res>(_value.professionalInfo,
        (value) {
      return _then(_value.copyWith(professionalInfo: value) as $Val);
    });
  }

  /// Create a copy of NutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ServiceInfoModelCopyWith<$Res> get serviceInfo {
    return $ServiceInfoModelCopyWith<$Res>(_value.serviceInfo, (value) {
      return _then(_value.copyWith(serviceInfo: value) as $Val);
    });
  }

  /// Create a copy of NutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RatingsModelCopyWith<$Res> get ratings {
    return $RatingsModelCopyWith<$Res>(_value.ratings, (value) {
      return _then(_value.copyWith(ratings: value) as $Val);
    });
  }

  /// Create a copy of NutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VerificationModelCopyWith<$Res> get verification {
    return $VerificationModelCopyWith<$Res>(_value.verification, (value) {
      return _then(_value.copyWith(verification: value) as $Val);
    });
  }

  /// Create a copy of NutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OnlineStatusModelCopyWith<$Res>? get onlineStatus {
    if (_value.onlineStatus == null) {
      return null;
    }

    return $OnlineStatusModelCopyWith<$Res>(_value.onlineStatus!, (value) {
      return _then(_value.copyWith(onlineStatus: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionistModelImplCopyWith<$Res>
    implements $NutritionistModelCopyWith<$Res> {
  factory _$$NutritionistModelImplCopyWith(_$NutritionistModelImpl value,
          $Res Function(_$NutritionistModelImpl) then) =
      __$$NutritionistModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String userId,
      String? certificationApplicationId,
      PersonalInfoModel personalInfo,
      QualificationsModel qualifications,
      ProfessionalInfoModel professionalInfo,
      ServiceInfoModel serviceInfo,
      RatingsModel ratings,
      String status,
      VerificationModel verification,
      List<Map<String, dynamic>> affiliations,
      OnlineStatusModel? onlineStatus,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $PersonalInfoModelCopyWith<$Res> get personalInfo;
  @override
  $QualificationsModelCopyWith<$Res> get qualifications;
  @override
  $ProfessionalInfoModelCopyWith<$Res> get professionalInfo;
  @override
  $ServiceInfoModelCopyWith<$Res> get serviceInfo;
  @override
  $RatingsModelCopyWith<$Res> get ratings;
  @override
  $VerificationModelCopyWith<$Res> get verification;
  @override
  $OnlineStatusModelCopyWith<$Res>? get onlineStatus;
}

/// @nodoc
class __$$NutritionistModelImplCopyWithImpl<$Res>
    extends _$NutritionistModelCopyWithImpl<$Res, _$NutritionistModelImpl>
    implements _$$NutritionistModelImplCopyWith<$Res> {
  __$$NutritionistModelImplCopyWithImpl(_$NutritionistModelImpl _value,
      $Res Function(_$NutritionistModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? certificationApplicationId = freezed,
    Object? personalInfo = null,
    Object? qualifications = null,
    Object? professionalInfo = null,
    Object? serviceInfo = null,
    Object? ratings = null,
    Object? status = null,
    Object? verification = null,
    Object? affiliations = null,
    Object? onlineStatus = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$NutritionistModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      certificationApplicationId: freezed == certificationApplicationId
          ? _value.certificationApplicationId
          : certificationApplicationId // ignore: cast_nullable_to_non_nullable
              as String?,
      personalInfo: null == personalInfo
          ? _value.personalInfo
          : personalInfo // ignore: cast_nullable_to_non_nullable
              as PersonalInfoModel,
      qualifications: null == qualifications
          ? _value.qualifications
          : qualifications // ignore: cast_nullable_to_non_nullable
              as QualificationsModel,
      professionalInfo: null == professionalInfo
          ? _value.professionalInfo
          : professionalInfo // ignore: cast_nullable_to_non_nullable
              as ProfessionalInfoModel,
      serviceInfo: null == serviceInfo
          ? _value.serviceInfo
          : serviceInfo // ignore: cast_nullable_to_non_nullable
              as ServiceInfoModel,
      ratings: null == ratings
          ? _value.ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as RatingsModel,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      verification: null == verification
          ? _value.verification
          : verification // ignore: cast_nullable_to_non_nullable
              as VerificationModel,
      affiliations: null == affiliations
          ? _value._affiliations
          : affiliations // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      onlineStatus: freezed == onlineStatus
          ? _value.onlineStatus
          : onlineStatus // ignore: cast_nullable_to_non_nullable
              as OnlineStatusModel?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionistModelImpl extends _NutritionistModel {
  const _$NutritionistModelImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.userId,
      this.certificationApplicationId,
      required this.personalInfo,
      required this.qualifications,
      required this.professionalInfo,
      required this.serviceInfo,
      required this.ratings,
      this.status = 'pendingVerification',
      required this.verification,
      final List<Map<String, dynamic>> affiliations = const [],
      this.onlineStatus,
      required this.createdAt,
      required this.updatedAt})
      : _affiliations = affiliations,
        super._();

  factory _$NutritionistModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionistModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String userId;
  @override
  final String? certificationApplicationId;
  @override
  final PersonalInfoModel personalInfo;
  @override
  final QualificationsModel qualifications;
  @override
  final ProfessionalInfoModel professionalInfo;
  @override
  final ServiceInfoModel serviceInfo;
  @override
  final RatingsModel ratings;
  @override
  @JsonKey()
  final String status;
  @override
  final VerificationModel verification;
  final List<Map<String, dynamic>> _affiliations;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get affiliations {
    if (_affiliations is EqualUnmodifiableListView) return _affiliations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_affiliations);
  }

  @override
  final OnlineStatusModel? onlineStatus;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'NutritionistModel(id: $id, userId: $userId, certificationApplicationId: $certificationApplicationId, personalInfo: $personalInfo, qualifications: $qualifications, professionalInfo: $professionalInfo, serviceInfo: $serviceInfo, ratings: $ratings, status: $status, verification: $verification, affiliations: $affiliations, onlineStatus: $onlineStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionistModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.certificationApplicationId,
                    certificationApplicationId) ||
                other.certificationApplicationId ==
                    certificationApplicationId) &&
            (identical(other.personalInfo, personalInfo) ||
                other.personalInfo == personalInfo) &&
            (identical(other.qualifications, qualifications) ||
                other.qualifications == qualifications) &&
            (identical(other.professionalInfo, professionalInfo) ||
                other.professionalInfo == professionalInfo) &&
            (identical(other.serviceInfo, serviceInfo) ||
                other.serviceInfo == serviceInfo) &&
            (identical(other.ratings, ratings) || other.ratings == ratings) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.verification, verification) ||
                other.verification == verification) &&
            const DeepCollectionEquality()
                .equals(other._affiliations, _affiliations) &&
            (identical(other.onlineStatus, onlineStatus) ||
                other.onlineStatus == onlineStatus) &&
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
      userId,
      certificationApplicationId,
      personalInfo,
      qualifications,
      professionalInfo,
      serviceInfo,
      ratings,
      status,
      verification,
      const DeepCollectionEquality().hash(_affiliations),
      onlineStatus,
      createdAt,
      updatedAt);

  /// Create a copy of NutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionistModelImplCopyWith<_$NutritionistModelImpl> get copyWith =>
      __$$NutritionistModelImplCopyWithImpl<_$NutritionistModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionistModelImplToJson(
      this,
    );
  }
}

abstract class _NutritionistModel extends NutritionistModel {
  const factory _NutritionistModel(
      {@JsonKey(name: '_id') required final String id,
      required final String userId,
      final String? certificationApplicationId,
      required final PersonalInfoModel personalInfo,
      required final QualificationsModel qualifications,
      required final ProfessionalInfoModel professionalInfo,
      required final ServiceInfoModel serviceInfo,
      required final RatingsModel ratings,
      final String status,
      required final VerificationModel verification,
      final List<Map<String, dynamic>> affiliations,
      final OnlineStatusModel? onlineStatus,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$NutritionistModelImpl;
  const _NutritionistModel._() : super._();

  factory _NutritionistModel.fromJson(Map<String, dynamic> json) =
      _$NutritionistModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get userId;
  @override
  String? get certificationApplicationId;
  @override
  PersonalInfoModel get personalInfo;
  @override
  QualificationsModel get qualifications;
  @override
  ProfessionalInfoModel get professionalInfo;
  @override
  ServiceInfoModel get serviceInfo;
  @override
  RatingsModel get ratings;
  @override
  String get status;
  @override
  VerificationModel get verification;
  @override
  List<Map<String, dynamic>> get affiliations;
  @override
  OnlineStatusModel? get onlineStatus;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of NutritionistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionistModelImplCopyWith<_$NutritionistModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
