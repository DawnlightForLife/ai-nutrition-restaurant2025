// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutritionist_certification_model.dart';

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
  String get fullName => throw _privateConstructorUsedError;
  String get idNumber => throw _privateConstructorUsedError;
  String get phone =>
      throw _privateConstructorUsedError; // Keep for backward compatibility
  String? get gender => throw _privateConstructorUsedError;
  DateTime? get birthDate => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  AddressModel? get address => throw _privateConstructorUsedError;

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
  $Res call(
      {String fullName,
      String idNumber,
      String phone,
      String? gender,
      DateTime? birthDate,
      String? email,
      AddressModel? address});

  $AddressModelCopyWith<$Res>? get address;
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
    Object? fullName = null,
    Object? idNumber = null,
    Object? phone = null,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? email = freezed,
    Object? address = freezed,
  }) {
    return _then(_value.copyWith(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      idNumber: null == idNumber
          ? _value.idNumber
          : idNumber // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
    ) as $Val);
  }

  /// Create a copy of PersonalInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get address {
    if (_value.address == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.address!, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
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
  $Res call(
      {String fullName,
      String idNumber,
      String phone,
      String? gender,
      DateTime? birthDate,
      String? email,
      AddressModel? address});

  @override
  $AddressModelCopyWith<$Res>? get address;
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
    Object? fullName = null,
    Object? idNumber = null,
    Object? phone = null,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? email = freezed,
    Object? address = freezed,
  }) {
    return _then(_$PersonalInfoModelImpl(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      idNumber: null == idNumber
          ? _value.idNumber
          : idNumber // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonalInfoModelImpl extends _PersonalInfoModel {
  const _$PersonalInfoModelImpl(
      {required this.fullName,
      required this.idNumber,
      required this.phone,
      this.gender,
      this.birthDate,
      this.email,
      this.address})
      : super._();

  factory _$PersonalInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonalInfoModelImplFromJson(json);

  @override
  final String fullName;
  @override
  final String idNumber;
  @override
  final String phone;
// Keep for backward compatibility
  @override
  final String? gender;
  @override
  final DateTime? birthDate;
  @override
  final String? email;
  @override
  final AddressModel? address;

  @override
  String toString() {
    return 'PersonalInfoModel(fullName: $fullName, idNumber: $idNumber, phone: $phone, gender: $gender, birthDate: $birthDate, email: $email, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonalInfoModelImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.idNumber, idNumber) ||
                other.idNumber == idNumber) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fullName, idNumber, phone,
      gender, birthDate, email, address);

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

abstract class _PersonalInfoModel extends PersonalInfoModel {
  const factory _PersonalInfoModel(
      {required final String fullName,
      required final String idNumber,
      required final String phone,
      final String? gender,
      final DateTime? birthDate,
      final String? email,
      final AddressModel? address}) = _$PersonalInfoModelImpl;
  const _PersonalInfoModel._() : super._();

  factory _PersonalInfoModel.fromJson(Map<String, dynamic> json) =
      _$PersonalInfoModelImpl.fromJson;

  @override
  String get fullName;
  @override
  String get idNumber;
  @override
  String get phone; // Keep for backward compatibility
  @override
  String? get gender;
  @override
  DateTime? get birthDate;
  @override
  String? get email;
  @override
  AddressModel? get address;

  /// Create a copy of PersonalInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonalInfoModelImplCopyWith<_$PersonalInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) {
  return _AddressModel.fromJson(json);
}

/// @nodoc
mixin _$AddressModel {
  String get province => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get district => throw _privateConstructorUsedError;
  String get detailed => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AddressModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AddressModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AddressModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this AddressModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressModelCopyWith<AddressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressModelCopyWith<$Res> {
  factory $AddressModelCopyWith(
          AddressModel value, $Res Function(AddressModel) then) =
      _$AddressModelCopyWithImpl<$Res, AddressModel>;
  @useResult
  $Res call({String province, String city, String district, String detailed});
}

/// @nodoc
class _$AddressModelCopyWithImpl<$Res, $Val extends AddressModel>
    implements $AddressModelCopyWith<$Res> {
  _$AddressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? province = null,
    Object? city = null,
    Object? district = null,
    Object? detailed = null,
  }) {
    return _then(_value.copyWith(
      province: null == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      district: null == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String,
      detailed: null == detailed
          ? _value.detailed
          : detailed // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddressModelImplCopyWith<$Res>
    implements $AddressModelCopyWith<$Res> {
  factory _$$AddressModelImplCopyWith(
          _$AddressModelImpl value, $Res Function(_$AddressModelImpl) then) =
      __$$AddressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String province, String city, String district, String detailed});
}

/// @nodoc
class __$$AddressModelImplCopyWithImpl<$Res>
    extends _$AddressModelCopyWithImpl<$Res, _$AddressModelImpl>
    implements _$$AddressModelImplCopyWith<$Res> {
  __$$AddressModelImplCopyWithImpl(
      _$AddressModelImpl _value, $Res Function(_$AddressModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? province = null,
    Object? city = null,
    Object? district = null,
    Object? detailed = null,
  }) {
    return _then(_$AddressModelImpl(
      province: null == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      district: null == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String,
      detailed: null == detailed
          ? _value.detailed
          : detailed // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressModelImpl extends _AddressModel {
  const _$AddressModelImpl(
      {required this.province,
      required this.city,
      required this.district,
      required this.detailed})
      : super._();

  factory _$AddressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressModelImplFromJson(json);

  @override
  final String province;
  @override
  final String city;
  @override
  final String district;
  @override
  final String detailed;

  @override
  String toString() {
    return 'AddressModel(province: $province, city: $city, district: $district, detailed: $detailed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressModelImpl &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.detailed, detailed) ||
                other.detailed == detailed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, province, city, district, detailed);

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressModelImplCopyWith<_$AddressModelImpl> get copyWith =>
      __$$AddressModelImplCopyWithImpl<_$AddressModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AddressModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AddressModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AddressModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressModelImplToJson(
      this,
    );
  }
}

abstract class _AddressModel extends AddressModel {
  const factory _AddressModel(
      {required final String province,
      required final String city,
      required final String district,
      required final String detailed}) = _$AddressModelImpl;
  const _AddressModel._() : super._();

  factory _AddressModel.fromJson(Map<String, dynamic> json) =
      _$AddressModelImpl.fromJson;

  @override
  String get province;
  @override
  String get city;
  @override
  String get district;
  @override
  String get detailed;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressModelImplCopyWith<_$AddressModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EducationModel _$EducationModelFromJson(Map<String, dynamic> json) {
  return _EducationModel.fromJson(json);
}

/// @nodoc
mixin _$EducationModel {
  String get degree => throw _privateConstructorUsedError;
  String get major => throw _privateConstructorUsedError;
  String get school => throw _privateConstructorUsedError;
  int get graduationYear => throw _privateConstructorUsedError;
  double? get gpa => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_EducationModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_EducationModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_EducationModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this EducationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EducationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EducationModelCopyWith<EducationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EducationModelCopyWith<$Res> {
  factory $EducationModelCopyWith(
          EducationModel value, $Res Function(EducationModel) then) =
      _$EducationModelCopyWithImpl<$Res, EducationModel>;
  @useResult
  $Res call(
      {String degree,
      String major,
      String school,
      int graduationYear,
      double? gpa});
}

/// @nodoc
class _$EducationModelCopyWithImpl<$Res, $Val extends EducationModel>
    implements $EducationModelCopyWith<$Res> {
  _$EducationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EducationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? degree = null,
    Object? major = null,
    Object? school = null,
    Object? graduationYear = null,
    Object? gpa = freezed,
  }) {
    return _then(_value.copyWith(
      degree: null == degree
          ? _value.degree
          : degree // ignore: cast_nullable_to_non_nullable
              as String,
      major: null == major
          ? _value.major
          : major // ignore: cast_nullable_to_non_nullable
              as String,
      school: null == school
          ? _value.school
          : school // ignore: cast_nullable_to_non_nullable
              as String,
      graduationYear: null == graduationYear
          ? _value.graduationYear
          : graduationYear // ignore: cast_nullable_to_non_nullable
              as int,
      gpa: freezed == gpa
          ? _value.gpa
          : gpa // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EducationModelImplCopyWith<$Res>
    implements $EducationModelCopyWith<$Res> {
  factory _$$EducationModelImplCopyWith(_$EducationModelImpl value,
          $Res Function(_$EducationModelImpl) then) =
      __$$EducationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String degree,
      String major,
      String school,
      int graduationYear,
      double? gpa});
}

/// @nodoc
class __$$EducationModelImplCopyWithImpl<$Res>
    extends _$EducationModelCopyWithImpl<$Res, _$EducationModelImpl>
    implements _$$EducationModelImplCopyWith<$Res> {
  __$$EducationModelImplCopyWithImpl(
      _$EducationModelImpl _value, $Res Function(_$EducationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EducationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? degree = null,
    Object? major = null,
    Object? school = null,
    Object? graduationYear = null,
    Object? gpa = freezed,
  }) {
    return _then(_$EducationModelImpl(
      degree: null == degree
          ? _value.degree
          : degree // ignore: cast_nullable_to_non_nullable
              as String,
      major: null == major
          ? _value.major
          : major // ignore: cast_nullable_to_non_nullable
              as String,
      school: null == school
          ? _value.school
          : school // ignore: cast_nullable_to_non_nullable
              as String,
      graduationYear: null == graduationYear
          ? _value.graduationYear
          : graduationYear // ignore: cast_nullable_to_non_nullable
              as int,
      gpa: freezed == gpa
          ? _value.gpa
          : gpa // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EducationModelImpl extends _EducationModel {
  const _$EducationModelImpl(
      {required this.degree,
      required this.major,
      required this.school,
      required this.graduationYear,
      this.gpa})
      : super._();

  factory _$EducationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EducationModelImplFromJson(json);

  @override
  final String degree;
  @override
  final String major;
  @override
  final String school;
  @override
  final int graduationYear;
  @override
  final double? gpa;

  @override
  String toString() {
    return 'EducationModel(degree: $degree, major: $major, school: $school, graduationYear: $graduationYear, gpa: $gpa)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EducationModelImpl &&
            (identical(other.degree, degree) || other.degree == degree) &&
            (identical(other.major, major) || other.major == major) &&
            (identical(other.school, school) || other.school == school) &&
            (identical(other.graduationYear, graduationYear) ||
                other.graduationYear == graduationYear) &&
            (identical(other.gpa, gpa) || other.gpa == gpa));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, degree, major, school, graduationYear, gpa);

  /// Create a copy of EducationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EducationModelImplCopyWith<_$EducationModelImpl> get copyWith =>
      __$$EducationModelImplCopyWithImpl<_$EducationModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_EducationModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_EducationModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_EducationModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$EducationModelImplToJson(
      this,
    );
  }
}

abstract class _EducationModel extends EducationModel {
  const factory _EducationModel(
      {required final String degree,
      required final String major,
      required final String school,
      required final int graduationYear,
      final double? gpa}) = _$EducationModelImpl;
  const _EducationModel._() : super._();

  factory _EducationModel.fromJson(Map<String, dynamic> json) =
      _$EducationModelImpl.fromJson;

  @override
  String get degree;
  @override
  String get major;
  @override
  String get school;
  @override
  int get graduationYear;
  @override
  double? get gpa;

  /// Create a copy of EducationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EducationModelImplCopyWith<_$EducationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkExperienceModel _$WorkExperienceModelFromJson(Map<String, dynamic> json) {
  return _WorkExperienceModel.fromJson(json);
}

/// @nodoc
mixin _$WorkExperienceModel {
  int get totalYears => throw _privateConstructorUsedError;
  String get currentPosition => throw _privateConstructorUsedError;
  String get currentEmployer => throw _privateConstructorUsedError;
  String get workDescription => throw _privateConstructorUsedError;
  List<PreviousExperienceModel> get previousExperiences =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_WorkExperienceModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_WorkExperienceModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_WorkExperienceModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this WorkExperienceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkExperienceModelCopyWith<WorkExperienceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkExperienceModelCopyWith<$Res> {
  factory $WorkExperienceModelCopyWith(
          WorkExperienceModel value, $Res Function(WorkExperienceModel) then) =
      _$WorkExperienceModelCopyWithImpl<$Res, WorkExperienceModel>;
  @useResult
  $Res call(
      {int totalYears,
      String currentPosition,
      String currentEmployer,
      String workDescription,
      List<PreviousExperienceModel> previousExperiences});
}

/// @nodoc
class _$WorkExperienceModelCopyWithImpl<$Res, $Val extends WorkExperienceModel>
    implements $WorkExperienceModelCopyWith<$Res> {
  _$WorkExperienceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalYears = null,
    Object? currentPosition = null,
    Object? currentEmployer = null,
    Object? workDescription = null,
    Object? previousExperiences = null,
  }) {
    return _then(_value.copyWith(
      totalYears: null == totalYears
          ? _value.totalYears
          : totalYears // ignore: cast_nullable_to_non_nullable
              as int,
      currentPosition: null == currentPosition
          ? _value.currentPosition
          : currentPosition // ignore: cast_nullable_to_non_nullable
              as String,
      currentEmployer: null == currentEmployer
          ? _value.currentEmployer
          : currentEmployer // ignore: cast_nullable_to_non_nullable
              as String,
      workDescription: null == workDescription
          ? _value.workDescription
          : workDescription // ignore: cast_nullable_to_non_nullable
              as String,
      previousExperiences: null == previousExperiences
          ? _value.previousExperiences
          : previousExperiences // ignore: cast_nullable_to_non_nullable
              as List<PreviousExperienceModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkExperienceModelImplCopyWith<$Res>
    implements $WorkExperienceModelCopyWith<$Res> {
  factory _$$WorkExperienceModelImplCopyWith(_$WorkExperienceModelImpl value,
          $Res Function(_$WorkExperienceModelImpl) then) =
      __$$WorkExperienceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalYears,
      String currentPosition,
      String currentEmployer,
      String workDescription,
      List<PreviousExperienceModel> previousExperiences});
}

/// @nodoc
class __$$WorkExperienceModelImplCopyWithImpl<$Res>
    extends _$WorkExperienceModelCopyWithImpl<$Res, _$WorkExperienceModelImpl>
    implements _$$WorkExperienceModelImplCopyWith<$Res> {
  __$$WorkExperienceModelImplCopyWithImpl(_$WorkExperienceModelImpl _value,
      $Res Function(_$WorkExperienceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalYears = null,
    Object? currentPosition = null,
    Object? currentEmployer = null,
    Object? workDescription = null,
    Object? previousExperiences = null,
  }) {
    return _then(_$WorkExperienceModelImpl(
      totalYears: null == totalYears
          ? _value.totalYears
          : totalYears // ignore: cast_nullable_to_non_nullable
              as int,
      currentPosition: null == currentPosition
          ? _value.currentPosition
          : currentPosition // ignore: cast_nullable_to_non_nullable
              as String,
      currentEmployer: null == currentEmployer
          ? _value.currentEmployer
          : currentEmployer // ignore: cast_nullable_to_non_nullable
              as String,
      workDescription: null == workDescription
          ? _value.workDescription
          : workDescription // ignore: cast_nullable_to_non_nullable
              as String,
      previousExperiences: null == previousExperiences
          ? _value._previousExperiences
          : previousExperiences // ignore: cast_nullable_to_non_nullable
              as List<PreviousExperienceModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkExperienceModelImpl extends _WorkExperienceModel {
  const _$WorkExperienceModelImpl(
      {required this.totalYears,
      required this.currentPosition,
      required this.currentEmployer,
      required this.workDescription,
      required final List<PreviousExperienceModel> previousExperiences})
      : _previousExperiences = previousExperiences,
        super._();

  factory _$WorkExperienceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkExperienceModelImplFromJson(json);

  @override
  final int totalYears;
  @override
  final String currentPosition;
  @override
  final String currentEmployer;
  @override
  final String workDescription;
  final List<PreviousExperienceModel> _previousExperiences;
  @override
  List<PreviousExperienceModel> get previousExperiences {
    if (_previousExperiences is EqualUnmodifiableListView)
      return _previousExperiences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_previousExperiences);
  }

  @override
  String toString() {
    return 'WorkExperienceModel(totalYears: $totalYears, currentPosition: $currentPosition, currentEmployer: $currentEmployer, workDescription: $workDescription, previousExperiences: $previousExperiences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkExperienceModelImpl &&
            (identical(other.totalYears, totalYears) ||
                other.totalYears == totalYears) &&
            (identical(other.currentPosition, currentPosition) ||
                other.currentPosition == currentPosition) &&
            (identical(other.currentEmployer, currentEmployer) ||
                other.currentEmployer == currentEmployer) &&
            (identical(other.workDescription, workDescription) ||
                other.workDescription == workDescription) &&
            const DeepCollectionEquality()
                .equals(other._previousExperiences, _previousExperiences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalYears,
      currentPosition,
      currentEmployer,
      workDescription,
      const DeepCollectionEquality().hash(_previousExperiences));

  /// Create a copy of WorkExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkExperienceModelImplCopyWith<_$WorkExperienceModelImpl> get copyWith =>
      __$$WorkExperienceModelImplCopyWithImpl<_$WorkExperienceModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_WorkExperienceModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_WorkExperienceModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_WorkExperienceModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkExperienceModelImplToJson(
      this,
    );
  }
}

abstract class _WorkExperienceModel extends WorkExperienceModel {
  const factory _WorkExperienceModel(
          {required final int totalYears,
          required final String currentPosition,
          required final String currentEmployer,
          required final String workDescription,
          required final List<PreviousExperienceModel> previousExperiences}) =
      _$WorkExperienceModelImpl;
  const _WorkExperienceModel._() : super._();

  factory _WorkExperienceModel.fromJson(Map<String, dynamic> json) =
      _$WorkExperienceModelImpl.fromJson;

  @override
  int get totalYears;
  @override
  String get currentPosition;
  @override
  String get currentEmployer;
  @override
  String get workDescription;
  @override
  List<PreviousExperienceModel> get previousExperiences;

  /// Create a copy of WorkExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkExperienceModelImplCopyWith<_$WorkExperienceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PreviousExperienceModel _$PreviousExperienceModelFromJson(
    Map<String, dynamic> json) {
  return _PreviousExperienceModel.fromJson(json);
}

/// @nodoc
mixin _$PreviousExperienceModel {
  String get position => throw _privateConstructorUsedError;
  String get employer => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  String? get responsibilities => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PreviousExperienceModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PreviousExperienceModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PreviousExperienceModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this PreviousExperienceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PreviousExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PreviousExperienceModelCopyWith<PreviousExperienceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreviousExperienceModelCopyWith<$Res> {
  factory $PreviousExperienceModelCopyWith(PreviousExperienceModel value,
          $Res Function(PreviousExperienceModel) then) =
      _$PreviousExperienceModelCopyWithImpl<$Res, PreviousExperienceModel>;
  @useResult
  $Res call(
      {String position,
      String employer,
      DateTime startDate,
      DateTime? endDate,
      String? responsibilities});
}

/// @nodoc
class _$PreviousExperienceModelCopyWithImpl<$Res,
        $Val extends PreviousExperienceModel>
    implements $PreviousExperienceModelCopyWith<$Res> {
  _$PreviousExperienceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PreviousExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? employer = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? responsibilities = freezed,
  }) {
    return _then(_value.copyWith(
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String,
      employer: null == employer
          ? _value.employer
          : employer // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      responsibilities: freezed == responsibilities
          ? _value.responsibilities
          : responsibilities // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PreviousExperienceModelImplCopyWith<$Res>
    implements $PreviousExperienceModelCopyWith<$Res> {
  factory _$$PreviousExperienceModelImplCopyWith(
          _$PreviousExperienceModelImpl value,
          $Res Function(_$PreviousExperienceModelImpl) then) =
      __$$PreviousExperienceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String position,
      String employer,
      DateTime startDate,
      DateTime? endDate,
      String? responsibilities});
}

/// @nodoc
class __$$PreviousExperienceModelImplCopyWithImpl<$Res>
    extends _$PreviousExperienceModelCopyWithImpl<$Res,
        _$PreviousExperienceModelImpl>
    implements _$$PreviousExperienceModelImplCopyWith<$Res> {
  __$$PreviousExperienceModelImplCopyWithImpl(
      _$PreviousExperienceModelImpl _value,
      $Res Function(_$PreviousExperienceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PreviousExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? employer = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? responsibilities = freezed,
  }) {
    return _then(_$PreviousExperienceModelImpl(
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String,
      employer: null == employer
          ? _value.employer
          : employer // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      responsibilities: freezed == responsibilities
          ? _value.responsibilities
          : responsibilities // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PreviousExperienceModelImpl extends _PreviousExperienceModel {
  const _$PreviousExperienceModelImpl(
      {required this.position,
      required this.employer,
      required this.startDate,
      this.endDate,
      this.responsibilities})
      : super._();

  factory _$PreviousExperienceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreviousExperienceModelImplFromJson(json);

  @override
  final String position;
  @override
  final String employer;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  final String? responsibilities;

  @override
  String toString() {
    return 'PreviousExperienceModel(position: $position, employer: $employer, startDate: $startDate, endDate: $endDate, responsibilities: $responsibilities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreviousExperienceModelImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.employer, employer) ||
                other.employer == employer) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.responsibilities, responsibilities) ||
                other.responsibilities == responsibilities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, position, employer, startDate, endDate, responsibilities);

  /// Create a copy of PreviousExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreviousExperienceModelImplCopyWith<_$PreviousExperienceModelImpl>
      get copyWith => __$$PreviousExperienceModelImplCopyWithImpl<
          _$PreviousExperienceModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PreviousExperienceModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PreviousExperienceModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PreviousExperienceModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PreviousExperienceModelImplToJson(
      this,
    );
  }
}

abstract class _PreviousExperienceModel extends PreviousExperienceModel {
  const factory _PreviousExperienceModel(
      {required final String position,
      required final String employer,
      required final DateTime startDate,
      final DateTime? endDate,
      final String? responsibilities}) = _$PreviousExperienceModelImpl;
  const _PreviousExperienceModel._() : super._();

  factory _PreviousExperienceModel.fromJson(Map<String, dynamic> json) =
      _$PreviousExperienceModelImpl.fromJson;

  @override
  String get position;
  @override
  String get employer;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  String? get responsibilities;

  /// Create a copy of PreviousExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreviousExperienceModelImplCopyWith<_$PreviousExperienceModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CertificationInfoModel _$CertificationInfoModelFromJson(
    Map<String, dynamic> json) {
  return _CertificationInfoModel.fromJson(json);
}

/// @nodoc
mixin _$CertificationInfoModel {
  List<String> get specializationAreas => throw _privateConstructorUsedError;
  int get workYearsInNutrition =>
      throw _privateConstructorUsedError; // Keep backward compatibility
  String? get targetLevel => throw _privateConstructorUsedError;
  String? get motivationStatement => throw _privateConstructorUsedError;
  bool? get hasExistingCertificate => throw _privateConstructorUsedError;
  String? get existingCertificateType => throw _privateConstructorUsedError;
  String? get careerGoals => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CertificationInfoModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CertificationInfoModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CertificationInfoModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this CertificationInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CertificationInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CertificationInfoModelCopyWith<CertificationInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CertificationInfoModelCopyWith<$Res> {
  factory $CertificationInfoModelCopyWith(CertificationInfoModel value,
          $Res Function(CertificationInfoModel) then) =
      _$CertificationInfoModelCopyWithImpl<$Res, CertificationInfoModel>;
  @useResult
  $Res call(
      {List<String> specializationAreas,
      int workYearsInNutrition,
      String? targetLevel,
      String? motivationStatement,
      bool? hasExistingCertificate,
      String? existingCertificateType,
      String? careerGoals});
}

/// @nodoc
class _$CertificationInfoModelCopyWithImpl<$Res,
        $Val extends CertificationInfoModel>
    implements $CertificationInfoModelCopyWith<$Res> {
  _$CertificationInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CertificationInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? specializationAreas = null,
    Object? workYearsInNutrition = null,
    Object? targetLevel = freezed,
    Object? motivationStatement = freezed,
    Object? hasExistingCertificate = freezed,
    Object? existingCertificateType = freezed,
    Object? careerGoals = freezed,
  }) {
    return _then(_value.copyWith(
      specializationAreas: null == specializationAreas
          ? _value.specializationAreas
          : specializationAreas // ignore: cast_nullable_to_non_nullable
              as List<String>,
      workYearsInNutrition: null == workYearsInNutrition
          ? _value.workYearsInNutrition
          : workYearsInNutrition // ignore: cast_nullable_to_non_nullable
              as int,
      targetLevel: freezed == targetLevel
          ? _value.targetLevel
          : targetLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      motivationStatement: freezed == motivationStatement
          ? _value.motivationStatement
          : motivationStatement // ignore: cast_nullable_to_non_nullable
              as String?,
      hasExistingCertificate: freezed == hasExistingCertificate
          ? _value.hasExistingCertificate
          : hasExistingCertificate // ignore: cast_nullable_to_non_nullable
              as bool?,
      existingCertificateType: freezed == existingCertificateType
          ? _value.existingCertificateType
          : existingCertificateType // ignore: cast_nullable_to_non_nullable
              as String?,
      careerGoals: freezed == careerGoals
          ? _value.careerGoals
          : careerGoals // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CertificationInfoModelImplCopyWith<$Res>
    implements $CertificationInfoModelCopyWith<$Res> {
  factory _$$CertificationInfoModelImplCopyWith(
          _$CertificationInfoModelImpl value,
          $Res Function(_$CertificationInfoModelImpl) then) =
      __$$CertificationInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> specializationAreas,
      int workYearsInNutrition,
      String? targetLevel,
      String? motivationStatement,
      bool? hasExistingCertificate,
      String? existingCertificateType,
      String? careerGoals});
}

/// @nodoc
class __$$CertificationInfoModelImplCopyWithImpl<$Res>
    extends _$CertificationInfoModelCopyWithImpl<$Res,
        _$CertificationInfoModelImpl>
    implements _$$CertificationInfoModelImplCopyWith<$Res> {
  __$$CertificationInfoModelImplCopyWithImpl(
      _$CertificationInfoModelImpl _value,
      $Res Function(_$CertificationInfoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CertificationInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? specializationAreas = null,
    Object? workYearsInNutrition = null,
    Object? targetLevel = freezed,
    Object? motivationStatement = freezed,
    Object? hasExistingCertificate = freezed,
    Object? existingCertificateType = freezed,
    Object? careerGoals = freezed,
  }) {
    return _then(_$CertificationInfoModelImpl(
      specializationAreas: null == specializationAreas
          ? _value._specializationAreas
          : specializationAreas // ignore: cast_nullable_to_non_nullable
              as List<String>,
      workYearsInNutrition: null == workYearsInNutrition
          ? _value.workYearsInNutrition
          : workYearsInNutrition // ignore: cast_nullable_to_non_nullable
              as int,
      targetLevel: freezed == targetLevel
          ? _value.targetLevel
          : targetLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      motivationStatement: freezed == motivationStatement
          ? _value.motivationStatement
          : motivationStatement // ignore: cast_nullable_to_non_nullable
              as String?,
      hasExistingCertificate: freezed == hasExistingCertificate
          ? _value.hasExistingCertificate
          : hasExistingCertificate // ignore: cast_nullable_to_non_nullable
              as bool?,
      existingCertificateType: freezed == existingCertificateType
          ? _value.existingCertificateType
          : existingCertificateType // ignore: cast_nullable_to_non_nullable
              as String?,
      careerGoals: freezed == careerGoals
          ? _value.careerGoals
          : careerGoals // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CertificationInfoModelImpl extends _CertificationInfoModel {
  const _$CertificationInfoModelImpl(
      {required final List<String> specializationAreas,
      required this.workYearsInNutrition,
      this.targetLevel,
      this.motivationStatement,
      this.hasExistingCertificate,
      this.existingCertificateType,
      this.careerGoals})
      : _specializationAreas = specializationAreas,
        super._();

  factory _$CertificationInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CertificationInfoModelImplFromJson(json);

  final List<String> _specializationAreas;
  @override
  List<String> get specializationAreas {
    if (_specializationAreas is EqualUnmodifiableListView)
      return _specializationAreas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specializationAreas);
  }

  @override
  final int workYearsInNutrition;
// Keep backward compatibility
  @override
  final String? targetLevel;
  @override
  final String? motivationStatement;
  @override
  final bool? hasExistingCertificate;
  @override
  final String? existingCertificateType;
  @override
  final String? careerGoals;

  @override
  String toString() {
    return 'CertificationInfoModel(specializationAreas: $specializationAreas, workYearsInNutrition: $workYearsInNutrition, targetLevel: $targetLevel, motivationStatement: $motivationStatement, hasExistingCertificate: $hasExistingCertificate, existingCertificateType: $existingCertificateType, careerGoals: $careerGoals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CertificationInfoModelImpl &&
            const DeepCollectionEquality()
                .equals(other._specializationAreas, _specializationAreas) &&
            (identical(other.workYearsInNutrition, workYearsInNutrition) ||
                other.workYearsInNutrition == workYearsInNutrition) &&
            (identical(other.targetLevel, targetLevel) ||
                other.targetLevel == targetLevel) &&
            (identical(other.motivationStatement, motivationStatement) ||
                other.motivationStatement == motivationStatement) &&
            (identical(other.hasExistingCertificate, hasExistingCertificate) ||
                other.hasExistingCertificate == hasExistingCertificate) &&
            (identical(
                    other.existingCertificateType, existingCertificateType) ||
                other.existingCertificateType == existingCertificateType) &&
            (identical(other.careerGoals, careerGoals) ||
                other.careerGoals == careerGoals));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_specializationAreas),
      workYearsInNutrition,
      targetLevel,
      motivationStatement,
      hasExistingCertificate,
      existingCertificateType,
      careerGoals);

  /// Create a copy of CertificationInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CertificationInfoModelImplCopyWith<_$CertificationInfoModelImpl>
      get copyWith => __$$CertificationInfoModelImplCopyWithImpl<
          _$CertificationInfoModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CertificationInfoModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CertificationInfoModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CertificationInfoModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CertificationInfoModelImplToJson(
      this,
    );
  }
}

abstract class _CertificationInfoModel extends CertificationInfoModel {
  const factory _CertificationInfoModel(
      {required final List<String> specializationAreas,
      required final int workYearsInNutrition,
      final String? targetLevel,
      final String? motivationStatement,
      final bool? hasExistingCertificate,
      final String? existingCertificateType,
      final String? careerGoals}) = _$CertificationInfoModelImpl;
  const _CertificationInfoModel._() : super._();

  factory _CertificationInfoModel.fromJson(Map<String, dynamic> json) =
      _$CertificationInfoModelImpl.fromJson;

  @override
  List<String> get specializationAreas;
  @override
  int get workYearsInNutrition; // Keep backward compatibility
  @override
  String? get targetLevel;
  @override
  String? get motivationStatement;
  @override
  bool? get hasExistingCertificate;
  @override
  String? get existingCertificateType;
  @override
  String? get careerGoals;

  /// Create a copy of CertificationInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CertificationInfoModelImplCopyWith<_$CertificationInfoModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UploadedDocumentModel _$UploadedDocumentModelFromJson(
    Map<String, dynamic> json) {
  return _UploadedDocumentModel.fromJson(json);
}

/// @nodoc
mixin _$UploadedDocumentModel {
  String get documentType => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  String get fileUrl => throw _privateConstructorUsedError;
  int get fileSize => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  DateTime get uploadedAt => throw _privateConstructorUsedError;
  bool get verified => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UploadedDocumentModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UploadedDocumentModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UploadedDocumentModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this UploadedDocumentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UploadedDocumentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UploadedDocumentModelCopyWith<UploadedDocumentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadedDocumentModelCopyWith<$Res> {
  factory $UploadedDocumentModelCopyWith(UploadedDocumentModel value,
          $Res Function(UploadedDocumentModel) then) =
      _$UploadedDocumentModelCopyWithImpl<$Res, UploadedDocumentModel>;
  @useResult
  $Res call(
      {String documentType,
      String fileName,
      String fileUrl,
      int fileSize,
      String mimeType,
      DateTime uploadedAt,
      bool verified});
}

/// @nodoc
class _$UploadedDocumentModelCopyWithImpl<$Res,
        $Val extends UploadedDocumentModel>
    implements $UploadedDocumentModelCopyWith<$Res> {
  _$UploadedDocumentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadedDocumentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = null,
    Object? fileName = null,
    Object? fileUrl = null,
    Object? fileSize = null,
    Object? mimeType = null,
    Object? uploadedAt = null,
    Object? verified = null,
  }) {
    return _then(_value.copyWith(
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: null == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UploadedDocumentModelImplCopyWith<$Res>
    implements $UploadedDocumentModelCopyWith<$Res> {
  factory _$$UploadedDocumentModelImplCopyWith(
          _$UploadedDocumentModelImpl value,
          $Res Function(_$UploadedDocumentModelImpl) then) =
      __$$UploadedDocumentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String documentType,
      String fileName,
      String fileUrl,
      int fileSize,
      String mimeType,
      DateTime uploadedAt,
      bool verified});
}

/// @nodoc
class __$$UploadedDocumentModelImplCopyWithImpl<$Res>
    extends _$UploadedDocumentModelCopyWithImpl<$Res,
        _$UploadedDocumentModelImpl>
    implements _$$UploadedDocumentModelImplCopyWith<$Res> {
  __$$UploadedDocumentModelImplCopyWithImpl(_$UploadedDocumentModelImpl _value,
      $Res Function(_$UploadedDocumentModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UploadedDocumentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = null,
    Object? fileName = null,
    Object? fileUrl = null,
    Object? fileSize = null,
    Object? mimeType = null,
    Object? uploadedAt = null,
    Object? verified = null,
  }) {
    return _then(_$UploadedDocumentModelImpl(
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: null == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UploadedDocumentModelImpl extends _UploadedDocumentModel {
  const _$UploadedDocumentModelImpl(
      {required this.documentType,
      required this.fileName,
      required this.fileUrl,
      required this.fileSize,
      required this.mimeType,
      required this.uploadedAt,
      required this.verified})
      : super._();

  factory _$UploadedDocumentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UploadedDocumentModelImplFromJson(json);

  @override
  final String documentType;
  @override
  final String fileName;
  @override
  final String fileUrl;
  @override
  final int fileSize;
  @override
  final String mimeType;
  @override
  final DateTime uploadedAt;
  @override
  final bool verified;

  @override
  String toString() {
    return 'UploadedDocumentModel(documentType: $documentType, fileName: $fileName, fileUrl: $fileUrl, fileSize: $fileSize, mimeType: $mimeType, uploadedAt: $uploadedAt, verified: $verified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadedDocumentModelImpl &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt) &&
            (identical(other.verified, verified) ||
                other.verified == verified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, documentType, fileName, fileUrl,
      fileSize, mimeType, uploadedAt, verified);

  /// Create a copy of UploadedDocumentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadedDocumentModelImplCopyWith<_$UploadedDocumentModelImpl>
      get copyWith => __$$UploadedDocumentModelImplCopyWithImpl<
          _$UploadedDocumentModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UploadedDocumentModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UploadedDocumentModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UploadedDocumentModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UploadedDocumentModelImplToJson(
      this,
    );
  }
}

abstract class _UploadedDocumentModel extends UploadedDocumentModel {
  const factory _UploadedDocumentModel(
      {required final String documentType,
      required final String fileName,
      required final String fileUrl,
      required final int fileSize,
      required final String mimeType,
      required final DateTime uploadedAt,
      required final bool verified}) = _$UploadedDocumentModelImpl;
  const _UploadedDocumentModel._() : super._();

  factory _UploadedDocumentModel.fromJson(Map<String, dynamic> json) =
      _$UploadedDocumentModelImpl.fromJson;

  @override
  String get documentType;
  @override
  String get fileName;
  @override
  String get fileUrl;
  @override
  int get fileSize;
  @override
  String get mimeType;
  @override
  DateTime get uploadedAt;
  @override
  bool get verified;

  /// Create a copy of UploadedDocumentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadedDocumentModelImplCopyWith<_$UploadedDocumentModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ReviewInfoModel _$ReviewInfoModelFromJson(Map<String, dynamic> json) {
  return _ReviewInfoModel.fromJson(json);
}

/// @nodoc
mixin _$ReviewInfoModel {
  String get status => throw _privateConstructorUsedError;
  DateTime? get submittedAt => throw _privateConstructorUsedError;
  String? get reviewedBy => throw _privateConstructorUsedError;
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  String? get reviewNotes => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  DateTime? get approvalValidUntil => throw _privateConstructorUsedError;
  int get resubmissionCount => throw _privateConstructorUsedError;
  DateTime? get lastResubmissionDate => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ReviewInfoModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ReviewInfoModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ReviewInfoModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ReviewInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewInfoModelCopyWith<ReviewInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewInfoModelCopyWith<$Res> {
  factory $ReviewInfoModelCopyWith(
          ReviewInfoModel value, $Res Function(ReviewInfoModel) then) =
      _$ReviewInfoModelCopyWithImpl<$Res, ReviewInfoModel>;
  @useResult
  $Res call(
      {String status,
      DateTime? submittedAt,
      String? reviewedBy,
      DateTime? reviewedAt,
      String? reviewNotes,
      String? rejectionReason,
      DateTime? approvalValidUntil,
      int resubmissionCount,
      DateTime? lastResubmissionDate});
}

/// @nodoc
class _$ReviewInfoModelCopyWithImpl<$Res, $Val extends ReviewInfoModel>
    implements $ReviewInfoModelCopyWith<$Res> {
  _$ReviewInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? submittedAt = freezed,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
    Object? reviewNotes = freezed,
    Object? rejectionReason = freezed,
    Object? approvalValidUntil = freezed,
    Object? resubmissionCount = null,
    Object? lastResubmissionDate = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewNotes: freezed == reviewNotes
          ? _value.reviewNotes
          : reviewNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      approvalValidUntil: freezed == approvalValidUntil
          ? _value.approvalValidUntil
          : approvalValidUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resubmissionCount: null == resubmissionCount
          ? _value.resubmissionCount
          : resubmissionCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastResubmissionDate: freezed == lastResubmissionDate
          ? _value.lastResubmissionDate
          : lastResubmissionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewInfoModelImplCopyWith<$Res>
    implements $ReviewInfoModelCopyWith<$Res> {
  factory _$$ReviewInfoModelImplCopyWith(_$ReviewInfoModelImpl value,
          $Res Function(_$ReviewInfoModelImpl) then) =
      __$$ReviewInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      DateTime? submittedAt,
      String? reviewedBy,
      DateTime? reviewedAt,
      String? reviewNotes,
      String? rejectionReason,
      DateTime? approvalValidUntil,
      int resubmissionCount,
      DateTime? lastResubmissionDate});
}

/// @nodoc
class __$$ReviewInfoModelImplCopyWithImpl<$Res>
    extends _$ReviewInfoModelCopyWithImpl<$Res, _$ReviewInfoModelImpl>
    implements _$$ReviewInfoModelImplCopyWith<$Res> {
  __$$ReviewInfoModelImplCopyWithImpl(
      _$ReviewInfoModelImpl _value, $Res Function(_$ReviewInfoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReviewInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? submittedAt = freezed,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
    Object? reviewNotes = freezed,
    Object? rejectionReason = freezed,
    Object? approvalValidUntil = freezed,
    Object? resubmissionCount = null,
    Object? lastResubmissionDate = freezed,
  }) {
    return _then(_$ReviewInfoModelImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewNotes: freezed == reviewNotes
          ? _value.reviewNotes
          : reviewNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      approvalValidUntil: freezed == approvalValidUntil
          ? _value.approvalValidUntil
          : approvalValidUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resubmissionCount: null == resubmissionCount
          ? _value.resubmissionCount
          : resubmissionCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastResubmissionDate: freezed == lastResubmissionDate
          ? _value.lastResubmissionDate
          : lastResubmissionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewInfoModelImpl extends _ReviewInfoModel {
  const _$ReviewInfoModelImpl(
      {required this.status,
      this.submittedAt,
      this.reviewedBy,
      this.reviewedAt,
      this.reviewNotes,
      this.rejectionReason,
      this.approvalValidUntil,
      required this.resubmissionCount,
      this.lastResubmissionDate})
      : super._();

  factory _$ReviewInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewInfoModelImplFromJson(json);

  @override
  final String status;
  @override
  final DateTime? submittedAt;
  @override
  final String? reviewedBy;
  @override
  final DateTime? reviewedAt;
  @override
  final String? reviewNotes;
  @override
  final String? rejectionReason;
  @override
  final DateTime? approvalValidUntil;
  @override
  final int resubmissionCount;
  @override
  final DateTime? lastResubmissionDate;

  @override
  String toString() {
    return 'ReviewInfoModel(status: $status, submittedAt: $submittedAt, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, reviewNotes: $reviewNotes, rejectionReason: $rejectionReason, approvalValidUntil: $approvalValidUntil, resubmissionCount: $resubmissionCount, lastResubmissionDate: $lastResubmissionDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewInfoModelImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.reviewedBy, reviewedBy) ||
                other.reviewedBy == reviewedBy) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.reviewNotes, reviewNotes) ||
                other.reviewNotes == reviewNotes) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.approvalValidUntil, approvalValidUntil) ||
                other.approvalValidUntil == approvalValidUntil) &&
            (identical(other.resubmissionCount, resubmissionCount) ||
                other.resubmissionCount == resubmissionCount) &&
            (identical(other.lastResubmissionDate, lastResubmissionDate) ||
                other.lastResubmissionDate == lastResubmissionDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      submittedAt,
      reviewedBy,
      reviewedAt,
      reviewNotes,
      rejectionReason,
      approvalValidUntil,
      resubmissionCount,
      lastResubmissionDate);

  /// Create a copy of ReviewInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewInfoModelImplCopyWith<_$ReviewInfoModelImpl> get copyWith =>
      __$$ReviewInfoModelImplCopyWithImpl<_$ReviewInfoModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ReviewInfoModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ReviewInfoModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ReviewInfoModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewInfoModelImplToJson(
      this,
    );
  }
}

abstract class _ReviewInfoModel extends ReviewInfoModel {
  const factory _ReviewInfoModel(
      {required final String status,
      final DateTime? submittedAt,
      final String? reviewedBy,
      final DateTime? reviewedAt,
      final String? reviewNotes,
      final String? rejectionReason,
      final DateTime? approvalValidUntil,
      required final int resubmissionCount,
      final DateTime? lastResubmissionDate}) = _$ReviewInfoModelImpl;
  const _ReviewInfoModel._() : super._();

  factory _ReviewInfoModel.fromJson(Map<String, dynamic> json) =
      _$ReviewInfoModelImpl.fromJson;

  @override
  String get status;
  @override
  DateTime? get submittedAt;
  @override
  String? get reviewedBy;
  @override
  DateTime? get reviewedAt;
  @override
  String? get reviewNotes;
  @override
  String? get rejectionReason;
  @override
  DateTime? get approvalValidUntil;
  @override
  int get resubmissionCount;
  @override
  DateTime? get lastResubmissionDate;

  /// Create a copy of ReviewInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewInfoModelImplCopyWith<_$ReviewInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionistCertificationModel _$NutritionistCertificationModelFromJson(
    Map<String, dynamic> json) {
  return _NutritionistCertificationModel.fromJson(json);
}

/// @nodoc
mixin _$NutritionistCertificationModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get applicationNumber => throw _privateConstructorUsedError;
  PersonalInfoModel get personalInfo => throw _privateConstructorUsedError;
  CertificationInfoModel get certificationInfo =>
      throw _privateConstructorUsedError;
  List<UploadedDocumentModel> get documents =>
      throw _privateConstructorUsedError;
  ReviewInfoModel get review => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Keep for backward compatibility but mark as optional
  EducationModel? get education => throw _privateConstructorUsedError;
  WorkExperienceModel? get workExperience => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistCertificationModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistCertificationModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistCertificationModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionistCertificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionistCertificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionistCertificationModelCopyWith<NutritionistCertificationModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionistCertificationModelCopyWith<$Res> {
  factory $NutritionistCertificationModelCopyWith(
          NutritionistCertificationModel value,
          $Res Function(NutritionistCertificationModel) then) =
      _$NutritionistCertificationModelCopyWithImpl<$Res,
          NutritionistCertificationModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String applicationNumber,
      PersonalInfoModel personalInfo,
      CertificationInfoModel certificationInfo,
      List<UploadedDocumentModel> documents,
      ReviewInfoModel review,
      DateTime createdAt,
      DateTime updatedAt,
      EducationModel? education,
      WorkExperienceModel? workExperience});

  $PersonalInfoModelCopyWith<$Res> get personalInfo;
  $CertificationInfoModelCopyWith<$Res> get certificationInfo;
  $ReviewInfoModelCopyWith<$Res> get review;
  $EducationModelCopyWith<$Res>? get education;
  $WorkExperienceModelCopyWith<$Res>? get workExperience;
}

/// @nodoc
class _$NutritionistCertificationModelCopyWithImpl<$Res,
        $Val extends NutritionistCertificationModel>
    implements $NutritionistCertificationModelCopyWith<$Res> {
  _$NutritionistCertificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionistCertificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? applicationNumber = null,
    Object? personalInfo = null,
    Object? certificationInfo = null,
    Object? documents = null,
    Object? review = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? education = freezed,
    Object? workExperience = freezed,
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
      applicationNumber: null == applicationNumber
          ? _value.applicationNumber
          : applicationNumber // ignore: cast_nullable_to_non_nullable
              as String,
      personalInfo: null == personalInfo
          ? _value.personalInfo
          : personalInfo // ignore: cast_nullable_to_non_nullable
              as PersonalInfoModel,
      certificationInfo: null == certificationInfo
          ? _value.certificationInfo
          : certificationInfo // ignore: cast_nullable_to_non_nullable
              as CertificationInfoModel,
      documents: null == documents
          ? _value.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<UploadedDocumentModel>,
      review: null == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as ReviewInfoModel,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      education: freezed == education
          ? _value.education
          : education // ignore: cast_nullable_to_non_nullable
              as EducationModel?,
      workExperience: freezed == workExperience
          ? _value.workExperience
          : workExperience // ignore: cast_nullable_to_non_nullable
              as WorkExperienceModel?,
    ) as $Val);
  }

  /// Create a copy of NutritionistCertificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonalInfoModelCopyWith<$Res> get personalInfo {
    return $PersonalInfoModelCopyWith<$Res>(_value.personalInfo, (value) {
      return _then(_value.copyWith(personalInfo: value) as $Val);
    });
  }

  /// Create a copy of NutritionistCertificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CertificationInfoModelCopyWith<$Res> get certificationInfo {
    return $CertificationInfoModelCopyWith<$Res>(_value.certificationInfo,
        (value) {
      return _then(_value.copyWith(certificationInfo: value) as $Val);
    });
  }

  /// Create a copy of NutritionistCertificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReviewInfoModelCopyWith<$Res> get review {
    return $ReviewInfoModelCopyWith<$Res>(_value.review, (value) {
      return _then(_value.copyWith(review: value) as $Val);
    });
  }

  /// Create a copy of NutritionistCertificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EducationModelCopyWith<$Res>? get education {
    if (_value.education == null) {
      return null;
    }

    return $EducationModelCopyWith<$Res>(_value.education!, (value) {
      return _then(_value.copyWith(education: value) as $Val);
    });
  }

  /// Create a copy of NutritionistCertificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkExperienceModelCopyWith<$Res>? get workExperience {
    if (_value.workExperience == null) {
      return null;
    }

    return $WorkExperienceModelCopyWith<$Res>(_value.workExperience!, (value) {
      return _then(_value.copyWith(workExperience: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionistCertificationModelImplCopyWith<$Res>
    implements $NutritionistCertificationModelCopyWith<$Res> {
  factory _$$NutritionistCertificationModelImplCopyWith(
          _$NutritionistCertificationModelImpl value,
          $Res Function(_$NutritionistCertificationModelImpl) then) =
      __$$NutritionistCertificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String applicationNumber,
      PersonalInfoModel personalInfo,
      CertificationInfoModel certificationInfo,
      List<UploadedDocumentModel> documents,
      ReviewInfoModel review,
      DateTime createdAt,
      DateTime updatedAt,
      EducationModel? education,
      WorkExperienceModel? workExperience});

  @override
  $PersonalInfoModelCopyWith<$Res> get personalInfo;
  @override
  $CertificationInfoModelCopyWith<$Res> get certificationInfo;
  @override
  $ReviewInfoModelCopyWith<$Res> get review;
  @override
  $EducationModelCopyWith<$Res>? get education;
  @override
  $WorkExperienceModelCopyWith<$Res>? get workExperience;
}

/// @nodoc
class __$$NutritionistCertificationModelImplCopyWithImpl<$Res>
    extends _$NutritionistCertificationModelCopyWithImpl<$Res,
        _$NutritionistCertificationModelImpl>
    implements _$$NutritionistCertificationModelImplCopyWith<$Res> {
  __$$NutritionistCertificationModelImplCopyWithImpl(
      _$NutritionistCertificationModelImpl _value,
      $Res Function(_$NutritionistCertificationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionistCertificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? applicationNumber = null,
    Object? personalInfo = null,
    Object? certificationInfo = null,
    Object? documents = null,
    Object? review = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? education = freezed,
    Object? workExperience = freezed,
  }) {
    return _then(_$NutritionistCertificationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      applicationNumber: null == applicationNumber
          ? _value.applicationNumber
          : applicationNumber // ignore: cast_nullable_to_non_nullable
              as String,
      personalInfo: null == personalInfo
          ? _value.personalInfo
          : personalInfo // ignore: cast_nullable_to_non_nullable
              as PersonalInfoModel,
      certificationInfo: null == certificationInfo
          ? _value.certificationInfo
          : certificationInfo // ignore: cast_nullable_to_non_nullable
              as CertificationInfoModel,
      documents: null == documents
          ? _value._documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<UploadedDocumentModel>,
      review: null == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as ReviewInfoModel,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      education: freezed == education
          ? _value.education
          : education // ignore: cast_nullable_to_non_nullable
              as EducationModel?,
      workExperience: freezed == workExperience
          ? _value.workExperience
          : workExperience // ignore: cast_nullable_to_non_nullable
              as WorkExperienceModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionistCertificationModelImpl
    extends _NutritionistCertificationModel {
  const _$NutritionistCertificationModelImpl(
      {required this.id,
      required this.userId,
      required this.applicationNumber,
      required this.personalInfo,
      required this.certificationInfo,
      required final List<UploadedDocumentModel> documents,
      required this.review,
      required this.createdAt,
      required this.updatedAt,
      this.education,
      this.workExperience})
      : _documents = documents,
        super._();

  factory _$NutritionistCertificationModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NutritionistCertificationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String applicationNumber;
  @override
  final PersonalInfoModel personalInfo;
  @override
  final CertificationInfoModel certificationInfo;
  final List<UploadedDocumentModel> _documents;
  @override
  List<UploadedDocumentModel> get documents {
    if (_documents is EqualUnmodifiableListView) return _documents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documents);
  }

  @override
  final ReviewInfoModel review;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
// Keep for backward compatibility but mark as optional
  @override
  final EducationModel? education;
  @override
  final WorkExperienceModel? workExperience;

  @override
  String toString() {
    return 'NutritionistCertificationModel(id: $id, userId: $userId, applicationNumber: $applicationNumber, personalInfo: $personalInfo, certificationInfo: $certificationInfo, documents: $documents, review: $review, createdAt: $createdAt, updatedAt: $updatedAt, education: $education, workExperience: $workExperience)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionistCertificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.applicationNumber, applicationNumber) ||
                other.applicationNumber == applicationNumber) &&
            (identical(other.personalInfo, personalInfo) ||
                other.personalInfo == personalInfo) &&
            (identical(other.certificationInfo, certificationInfo) ||
                other.certificationInfo == certificationInfo) &&
            const DeepCollectionEquality()
                .equals(other._documents, _documents) &&
            (identical(other.review, review) || other.review == review) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.education, education) ||
                other.education == education) &&
            (identical(other.workExperience, workExperience) ||
                other.workExperience == workExperience));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      applicationNumber,
      personalInfo,
      certificationInfo,
      const DeepCollectionEquality().hash(_documents),
      review,
      createdAt,
      updatedAt,
      education,
      workExperience);

  /// Create a copy of NutritionistCertificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionistCertificationModelImplCopyWith<
          _$NutritionistCertificationModelImpl>
      get copyWith => __$$NutritionistCertificationModelImplCopyWithImpl<
          _$NutritionistCertificationModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistCertificationModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistCertificationModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistCertificationModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionistCertificationModelImplToJson(
      this,
    );
  }
}

abstract class _NutritionistCertificationModel
    extends NutritionistCertificationModel {
  const factory _NutritionistCertificationModel(
          {required final String id,
          required final String userId,
          required final String applicationNumber,
          required final PersonalInfoModel personalInfo,
          required final CertificationInfoModel certificationInfo,
          required final List<UploadedDocumentModel> documents,
          required final ReviewInfoModel review,
          required final DateTime createdAt,
          required final DateTime updatedAt,
          final EducationModel? education,
          final WorkExperienceModel? workExperience}) =
      _$NutritionistCertificationModelImpl;
  const _NutritionistCertificationModel._() : super._();

  factory _NutritionistCertificationModel.fromJson(Map<String, dynamic> json) =
      _$NutritionistCertificationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get applicationNumber;
  @override
  PersonalInfoModel get personalInfo;
  @override
  CertificationInfoModel get certificationInfo;
  @override
  List<UploadedDocumentModel> get documents;
  @override
  ReviewInfoModel get review;
  @override
  DateTime get createdAt;
  @override
  DateTime
      get updatedAt; // Keep for backward compatibility but mark as optional
  @override
  EducationModel? get education;
  @override
  WorkExperienceModel? get workExperience;

  /// Create a copy of NutritionistCertificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionistCertificationModelImplCopyWith<
          _$NutritionistCertificationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NutritionistCertificationRequestModel
    _$NutritionistCertificationRequestModelFromJson(Map<String, dynamic> json) {
  return _NutritionistCertificationRequestModel.fromJson(json);
}

/// @nodoc
mixin _$NutritionistCertificationRequestModel {
  PersonalInfoModel get personalInfo => throw _privateConstructorUsedError;
  CertificationInfoModel get certificationInfo =>
      throw _privateConstructorUsedError; // Keep for backward compatibility
  EducationModel? get education => throw _privateConstructorUsedError;
  WorkExperienceModel? get workExperience => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistCertificationRequestModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistCertificationRequestModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistCertificationRequestModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionistCertificationRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionistCertificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionistCertificationRequestModelCopyWith<
          NutritionistCertificationRequestModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionistCertificationRequestModelCopyWith<$Res> {
  factory $NutritionistCertificationRequestModelCopyWith(
          NutritionistCertificationRequestModel value,
          $Res Function(NutritionistCertificationRequestModel) then) =
      _$NutritionistCertificationRequestModelCopyWithImpl<$Res,
          NutritionistCertificationRequestModel>;
  @useResult
  $Res call(
      {PersonalInfoModel personalInfo,
      CertificationInfoModel certificationInfo,
      EducationModel? education,
      WorkExperienceModel? workExperience});

  $PersonalInfoModelCopyWith<$Res> get personalInfo;
  $CertificationInfoModelCopyWith<$Res> get certificationInfo;
  $EducationModelCopyWith<$Res>? get education;
  $WorkExperienceModelCopyWith<$Res>? get workExperience;
}

/// @nodoc
class _$NutritionistCertificationRequestModelCopyWithImpl<$Res,
        $Val extends NutritionistCertificationRequestModel>
    implements $NutritionistCertificationRequestModelCopyWith<$Res> {
  _$NutritionistCertificationRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionistCertificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? personalInfo = null,
    Object? certificationInfo = null,
    Object? education = freezed,
    Object? workExperience = freezed,
  }) {
    return _then(_value.copyWith(
      personalInfo: null == personalInfo
          ? _value.personalInfo
          : personalInfo // ignore: cast_nullable_to_non_nullable
              as PersonalInfoModel,
      certificationInfo: null == certificationInfo
          ? _value.certificationInfo
          : certificationInfo // ignore: cast_nullable_to_non_nullable
              as CertificationInfoModel,
      education: freezed == education
          ? _value.education
          : education // ignore: cast_nullable_to_non_nullable
              as EducationModel?,
      workExperience: freezed == workExperience
          ? _value.workExperience
          : workExperience // ignore: cast_nullable_to_non_nullable
              as WorkExperienceModel?,
    ) as $Val);
  }

  /// Create a copy of NutritionistCertificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonalInfoModelCopyWith<$Res> get personalInfo {
    return $PersonalInfoModelCopyWith<$Res>(_value.personalInfo, (value) {
      return _then(_value.copyWith(personalInfo: value) as $Val);
    });
  }

  /// Create a copy of NutritionistCertificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CertificationInfoModelCopyWith<$Res> get certificationInfo {
    return $CertificationInfoModelCopyWith<$Res>(_value.certificationInfo,
        (value) {
      return _then(_value.copyWith(certificationInfo: value) as $Val);
    });
  }

  /// Create a copy of NutritionistCertificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EducationModelCopyWith<$Res>? get education {
    if (_value.education == null) {
      return null;
    }

    return $EducationModelCopyWith<$Res>(_value.education!, (value) {
      return _then(_value.copyWith(education: value) as $Val);
    });
  }

  /// Create a copy of NutritionistCertificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkExperienceModelCopyWith<$Res>? get workExperience {
    if (_value.workExperience == null) {
      return null;
    }

    return $WorkExperienceModelCopyWith<$Res>(_value.workExperience!, (value) {
      return _then(_value.copyWith(workExperience: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionistCertificationRequestModelImplCopyWith<$Res>
    implements $NutritionistCertificationRequestModelCopyWith<$Res> {
  factory _$$NutritionistCertificationRequestModelImplCopyWith(
          _$NutritionistCertificationRequestModelImpl value,
          $Res Function(_$NutritionistCertificationRequestModelImpl) then) =
      __$$NutritionistCertificationRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PersonalInfoModel personalInfo,
      CertificationInfoModel certificationInfo,
      EducationModel? education,
      WorkExperienceModel? workExperience});

  @override
  $PersonalInfoModelCopyWith<$Res> get personalInfo;
  @override
  $CertificationInfoModelCopyWith<$Res> get certificationInfo;
  @override
  $EducationModelCopyWith<$Res>? get education;
  @override
  $WorkExperienceModelCopyWith<$Res>? get workExperience;
}

/// @nodoc
class __$$NutritionistCertificationRequestModelImplCopyWithImpl<$Res>
    extends _$NutritionistCertificationRequestModelCopyWithImpl<$Res,
        _$NutritionistCertificationRequestModelImpl>
    implements _$$NutritionistCertificationRequestModelImplCopyWith<$Res> {
  __$$NutritionistCertificationRequestModelImplCopyWithImpl(
      _$NutritionistCertificationRequestModelImpl _value,
      $Res Function(_$NutritionistCertificationRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionistCertificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? personalInfo = null,
    Object? certificationInfo = null,
    Object? education = freezed,
    Object? workExperience = freezed,
  }) {
    return _then(_$NutritionistCertificationRequestModelImpl(
      personalInfo: null == personalInfo
          ? _value.personalInfo
          : personalInfo // ignore: cast_nullable_to_non_nullable
              as PersonalInfoModel,
      certificationInfo: null == certificationInfo
          ? _value.certificationInfo
          : certificationInfo // ignore: cast_nullable_to_non_nullable
              as CertificationInfoModel,
      education: freezed == education
          ? _value.education
          : education // ignore: cast_nullable_to_non_nullable
              as EducationModel?,
      workExperience: freezed == workExperience
          ? _value.workExperience
          : workExperience // ignore: cast_nullable_to_non_nullable
              as WorkExperienceModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionistCertificationRequestModelImpl
    extends _NutritionistCertificationRequestModel {
  const _$NutritionistCertificationRequestModelImpl(
      {required this.personalInfo,
      required this.certificationInfo,
      this.education,
      this.workExperience})
      : super._();

  factory _$NutritionistCertificationRequestModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NutritionistCertificationRequestModelImplFromJson(json);

  @override
  final PersonalInfoModel personalInfo;
  @override
  final CertificationInfoModel certificationInfo;
// Keep for backward compatibility
  @override
  final EducationModel? education;
  @override
  final WorkExperienceModel? workExperience;

  @override
  String toString() {
    return 'NutritionistCertificationRequestModel(personalInfo: $personalInfo, certificationInfo: $certificationInfo, education: $education, workExperience: $workExperience)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionistCertificationRequestModelImpl &&
            (identical(other.personalInfo, personalInfo) ||
                other.personalInfo == personalInfo) &&
            (identical(other.certificationInfo, certificationInfo) ||
                other.certificationInfo == certificationInfo) &&
            (identical(other.education, education) ||
                other.education == education) &&
            (identical(other.workExperience, workExperience) ||
                other.workExperience == workExperience));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, personalInfo, certificationInfo, education, workExperience);

  /// Create a copy of NutritionistCertificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionistCertificationRequestModelImplCopyWith<
          _$NutritionistCertificationRequestModelImpl>
      get copyWith => __$$NutritionistCertificationRequestModelImplCopyWithImpl<
          _$NutritionistCertificationRequestModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistCertificationRequestModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistCertificationRequestModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistCertificationRequestModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionistCertificationRequestModelImplToJson(
      this,
    );
  }
}

abstract class _NutritionistCertificationRequestModel
    extends NutritionistCertificationRequestModel {
  const factory _NutritionistCertificationRequestModel(
          {required final PersonalInfoModel personalInfo,
          required final CertificationInfoModel certificationInfo,
          final EducationModel? education,
          final WorkExperienceModel? workExperience}) =
      _$NutritionistCertificationRequestModelImpl;
  const _NutritionistCertificationRequestModel._() : super._();

  factory _NutritionistCertificationRequestModel.fromJson(
          Map<String, dynamic> json) =
      _$NutritionistCertificationRequestModelImpl.fromJson;

  @override
  PersonalInfoModel get personalInfo;
  @override
  CertificationInfoModel
      get certificationInfo; // Keep for backward compatibility
  @override
  EducationModel? get education;
  @override
  WorkExperienceModel? get workExperience;

  /// Create a copy of NutritionistCertificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionistCertificationRequestModelImplCopyWith<
          _$NutritionistCertificationRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
