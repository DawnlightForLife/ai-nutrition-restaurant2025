// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutritionist_management_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NutritionistManagementEntity _$NutritionistManagementEntityFromJson(
    Map<String, dynamic> json) {
  return _NutritionistManagementEntity.fromJson(json);
}

/// @nodoc
mixin _$NutritionistManagementEntity {
  String get id => throw _privateConstructorUsedError;
  String get realName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String get licenseNumber => throw _privateConstructorUsedError;
  String get certificationLevel => throw _privateConstructorUsedError;
  List<String> get specializations => throw _privateConstructorUsedError;
  int get experienceYears => throw _privateConstructorUsedError;
  double get consultationFee => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get verificationStatus => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  DateTime? get lastActiveAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  NutritionistStats? get stats => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistManagementEntity value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistManagementEntity value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistManagementEntity value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionistManagementEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionistManagementEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionistManagementEntityCopyWith<NutritionistManagementEntity>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionistManagementEntityCopyWith<$Res> {
  factory $NutritionistManagementEntityCopyWith(
          NutritionistManagementEntity value,
          $Res Function(NutritionistManagementEntity) then) =
      _$NutritionistManagementEntityCopyWithImpl<$Res,
          NutritionistManagementEntity>;
  @useResult
  $Res call(
      {String id,
      String realName,
      String? phone,
      String? email,
      String? avatar,
      String licenseNumber,
      String certificationLevel,
      List<String> specializations,
      int experienceYears,
      double consultationFee,
      String status,
      String verificationStatus,
      double averageRating,
      int totalReviews,
      bool isOnline,
      bool isAvailable,
      DateTime? lastActiveAt,
      DateTime createdAt,
      DateTime? updatedAt,
      NutritionistStats? stats});

  $NutritionistStatsCopyWith<$Res>? get stats;
}

/// @nodoc
class _$NutritionistManagementEntityCopyWithImpl<$Res,
        $Val extends NutritionistManagementEntity>
    implements $NutritionistManagementEntityCopyWith<$Res> {
  _$NutritionistManagementEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionistManagementEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? realName = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? avatar = freezed,
    Object? licenseNumber = null,
    Object? certificationLevel = null,
    Object? specializations = null,
    Object? experienceYears = null,
    Object? consultationFee = null,
    Object? status = null,
    Object? verificationStatus = null,
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? isOnline = null,
    Object? isAvailable = null,
    Object? lastActiveAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? stats = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      realName: null == realName
          ? _value.realName
          : realName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      certificationLevel: null == certificationLevel
          ? _value.certificationLevel
          : certificationLevel // ignore: cast_nullable_to_non_nullable
              as String,
      specializations: null == specializations
          ? _value.specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      experienceYears: null == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int,
      consultationFee: null == consultationFee
          ? _value.consultationFee
          : consultationFee // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as NutritionistStats?,
    ) as $Val);
  }

  /// Create a copy of NutritionistManagementEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionistStatsCopyWith<$Res>? get stats {
    if (_value.stats == null) {
      return null;
    }

    return $NutritionistStatsCopyWith<$Res>(_value.stats!, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionistManagementEntityImplCopyWith<$Res>
    implements $NutritionistManagementEntityCopyWith<$Res> {
  factory _$$NutritionistManagementEntityImplCopyWith(
          _$NutritionistManagementEntityImpl value,
          $Res Function(_$NutritionistManagementEntityImpl) then) =
      __$$NutritionistManagementEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String realName,
      String? phone,
      String? email,
      String? avatar,
      String licenseNumber,
      String certificationLevel,
      List<String> specializations,
      int experienceYears,
      double consultationFee,
      String status,
      String verificationStatus,
      double averageRating,
      int totalReviews,
      bool isOnline,
      bool isAvailable,
      DateTime? lastActiveAt,
      DateTime createdAt,
      DateTime? updatedAt,
      NutritionistStats? stats});

  @override
  $NutritionistStatsCopyWith<$Res>? get stats;
}

/// @nodoc
class __$$NutritionistManagementEntityImplCopyWithImpl<$Res>
    extends _$NutritionistManagementEntityCopyWithImpl<$Res,
        _$NutritionistManagementEntityImpl>
    implements _$$NutritionistManagementEntityImplCopyWith<$Res> {
  __$$NutritionistManagementEntityImplCopyWithImpl(
      _$NutritionistManagementEntityImpl _value,
      $Res Function(_$NutritionistManagementEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionistManagementEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? realName = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? avatar = freezed,
    Object? licenseNumber = null,
    Object? certificationLevel = null,
    Object? specializations = null,
    Object? experienceYears = null,
    Object? consultationFee = null,
    Object? status = null,
    Object? verificationStatus = null,
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? isOnline = null,
    Object? isAvailable = null,
    Object? lastActiveAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? stats = freezed,
  }) {
    return _then(_$NutritionistManagementEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      realName: null == realName
          ? _value.realName
          : realName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      certificationLevel: null == certificationLevel
          ? _value.certificationLevel
          : certificationLevel // ignore: cast_nullable_to_non_nullable
              as String,
      specializations: null == specializations
          ? _value._specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      experienceYears: null == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int,
      consultationFee: null == consultationFee
          ? _value.consultationFee
          : consultationFee // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as NutritionistStats?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionistManagementEntityImpl
    implements _NutritionistManagementEntity {
  const _$NutritionistManagementEntityImpl(
      {required this.id,
      required this.realName,
      this.phone,
      this.email,
      this.avatar,
      required this.licenseNumber,
      required this.certificationLevel,
      final List<String> specializations = const [],
      required this.experienceYears,
      required this.consultationFee,
      required this.status,
      required this.verificationStatus,
      this.averageRating = 0.0,
      this.totalReviews = 0,
      this.isOnline = false,
      this.isAvailable = false,
      this.lastActiveAt,
      required this.createdAt,
      this.updatedAt,
      this.stats})
      : _specializations = specializations;

  factory _$NutritionistManagementEntityImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NutritionistManagementEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String realName;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? avatar;
  @override
  final String licenseNumber;
  @override
  final String certificationLevel;
  final List<String> _specializations;
  @override
  @JsonKey()
  List<String> get specializations {
    if (_specializations is EqualUnmodifiableListView) return _specializations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specializations);
  }

  @override
  final int experienceYears;
  @override
  final double consultationFee;
  @override
  final String status;
  @override
  final String verificationStatus;
  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final int totalReviews;
  @override
  @JsonKey()
  final bool isOnline;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  final DateTime? lastActiveAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final NutritionistStats? stats;

  @override
  String toString() {
    return 'NutritionistManagementEntity(id: $id, realName: $realName, phone: $phone, email: $email, avatar: $avatar, licenseNumber: $licenseNumber, certificationLevel: $certificationLevel, specializations: $specializations, experienceYears: $experienceYears, consultationFee: $consultationFee, status: $status, verificationStatus: $verificationStatus, averageRating: $averageRating, totalReviews: $totalReviews, isOnline: $isOnline, isAvailable: $isAvailable, lastActiveAt: $lastActiveAt, createdAt: $createdAt, updatedAt: $updatedAt, stats: $stats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionistManagementEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.realName, realName) ||
                other.realName == realName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.certificationLevel, certificationLevel) ||
                other.certificationLevel == certificationLevel) &&
            const DeepCollectionEquality()
                .equals(other._specializations, _specializations) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            (identical(other.consultationFee, consultationFee) ||
                other.consultationFee == consultationFee) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.stats, stats) || other.stats == stats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        realName,
        phone,
        email,
        avatar,
        licenseNumber,
        certificationLevel,
        const DeepCollectionEquality().hash(_specializations),
        experienceYears,
        consultationFee,
        status,
        verificationStatus,
        averageRating,
        totalReviews,
        isOnline,
        isAvailable,
        lastActiveAt,
        createdAt,
        updatedAt,
        stats
      ]);

  /// Create a copy of NutritionistManagementEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionistManagementEntityImplCopyWith<
          _$NutritionistManagementEntityImpl>
      get copyWith => __$$NutritionistManagementEntityImplCopyWithImpl<
          _$NutritionistManagementEntityImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistManagementEntity value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistManagementEntity value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistManagementEntity value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionistManagementEntityImplToJson(
      this,
    );
  }
}

abstract class _NutritionistManagementEntity
    implements NutritionistManagementEntity {
  const factory _NutritionistManagementEntity(
      {required final String id,
      required final String realName,
      final String? phone,
      final String? email,
      final String? avatar,
      required final String licenseNumber,
      required final String certificationLevel,
      final List<String> specializations,
      required final int experienceYears,
      required final double consultationFee,
      required final String status,
      required final String verificationStatus,
      final double averageRating,
      final int totalReviews,
      final bool isOnline,
      final bool isAvailable,
      final DateTime? lastActiveAt,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final NutritionistStats? stats}) = _$NutritionistManagementEntityImpl;

  factory _NutritionistManagementEntity.fromJson(Map<String, dynamic> json) =
      _$NutritionistManagementEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get realName;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get avatar;
  @override
  String get licenseNumber;
  @override
  String get certificationLevel;
  @override
  List<String> get specializations;
  @override
  int get experienceYears;
  @override
  double get consultationFee;
  @override
  String get status;
  @override
  String get verificationStatus;
  @override
  double get averageRating;
  @override
  int get totalReviews;
  @override
  bool get isOnline;
  @override
  bool get isAvailable;
  @override
  DateTime? get lastActiveAt;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  NutritionistStats? get stats;

  /// Create a copy of NutritionistManagementEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionistManagementEntityImplCopyWith<
          _$NutritionistManagementEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NutritionistStats _$NutritionistStatsFromJson(Map<String, dynamic> json) {
  return _NutritionistStats.fromJson(json);
}

/// @nodoc
mixin _$NutritionistStats {
  int get totalConsultations => throw _privateConstructorUsedError;
  int get completedConsultations => throw _privateConstructorUsedError;
  double get avgRating => throw _privateConstructorUsedError;
  double get totalIncome => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistStats value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistStats value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistStats value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionistStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionistStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionistStatsCopyWith<NutritionistStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionistStatsCopyWith<$Res> {
  factory $NutritionistStatsCopyWith(
          NutritionistStats value, $Res Function(NutritionistStats) then) =
      _$NutritionistStatsCopyWithImpl<$Res, NutritionistStats>;
  @useResult
  $Res call(
      {int totalConsultations,
      int completedConsultations,
      double avgRating,
      double totalIncome});
}

/// @nodoc
class _$NutritionistStatsCopyWithImpl<$Res, $Val extends NutritionistStats>
    implements $NutritionistStatsCopyWith<$Res> {
  _$NutritionistStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionistStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalConsultations = null,
    Object? completedConsultations = null,
    Object? avgRating = null,
    Object? totalIncome = null,
  }) {
    return _then(_value.copyWith(
      totalConsultations: null == totalConsultations
          ? _value.totalConsultations
          : totalConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      completedConsultations: null == completedConsultations
          ? _value.completedConsultations
          : completedConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      avgRating: null == avgRating
          ? _value.avgRating
          : avgRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionistStatsImplCopyWith<$Res>
    implements $NutritionistStatsCopyWith<$Res> {
  factory _$$NutritionistStatsImplCopyWith(_$NutritionistStatsImpl value,
          $Res Function(_$NutritionistStatsImpl) then) =
      __$$NutritionistStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalConsultations,
      int completedConsultations,
      double avgRating,
      double totalIncome});
}

/// @nodoc
class __$$NutritionistStatsImplCopyWithImpl<$Res>
    extends _$NutritionistStatsCopyWithImpl<$Res, _$NutritionistStatsImpl>
    implements _$$NutritionistStatsImplCopyWith<$Res> {
  __$$NutritionistStatsImplCopyWithImpl(_$NutritionistStatsImpl _value,
      $Res Function(_$NutritionistStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionistStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalConsultations = null,
    Object? completedConsultations = null,
    Object? avgRating = null,
    Object? totalIncome = null,
  }) {
    return _then(_$NutritionistStatsImpl(
      totalConsultations: null == totalConsultations
          ? _value.totalConsultations
          : totalConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      completedConsultations: null == completedConsultations
          ? _value.completedConsultations
          : completedConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      avgRating: null == avgRating
          ? _value.avgRating
          : avgRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionistStatsImpl implements _NutritionistStats {
  const _$NutritionistStatsImpl(
      {this.totalConsultations = 0,
      this.completedConsultations = 0,
      this.avgRating = 0.0,
      this.totalIncome = 0.0});

  factory _$NutritionistStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionistStatsImplFromJson(json);

  @override
  @JsonKey()
  final int totalConsultations;
  @override
  @JsonKey()
  final int completedConsultations;
  @override
  @JsonKey()
  final double avgRating;
  @override
  @JsonKey()
  final double totalIncome;

  @override
  String toString() {
    return 'NutritionistStats(totalConsultations: $totalConsultations, completedConsultations: $completedConsultations, avgRating: $avgRating, totalIncome: $totalIncome)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionistStatsImpl &&
            (identical(other.totalConsultations, totalConsultations) ||
                other.totalConsultations == totalConsultations) &&
            (identical(other.completedConsultations, completedConsultations) ||
                other.completedConsultations == completedConsultations) &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalConsultations,
      completedConsultations, avgRating, totalIncome);

  /// Create a copy of NutritionistStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionistStatsImplCopyWith<_$NutritionistStatsImpl> get copyWith =>
      __$$NutritionistStatsImplCopyWithImpl<_$NutritionistStatsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistStats value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistStats value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistStats value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionistStatsImplToJson(
      this,
    );
  }
}

abstract class _NutritionistStats implements NutritionistStats {
  const factory _NutritionistStats(
      {final int totalConsultations,
      final int completedConsultations,
      final double avgRating,
      final double totalIncome}) = _$NutritionistStatsImpl;

  factory _NutritionistStats.fromJson(Map<String, dynamic> json) =
      _$NutritionistStatsImpl.fromJson;

  @override
  int get totalConsultations;
  @override
  int get completedConsultations;
  @override
  double get avgRating;
  @override
  double get totalIncome;

  /// Create a copy of NutritionistStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionistStatsImplCopyWith<_$NutritionistStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionistManagementResponse _$NutritionistManagementResponseFromJson(
    Map<String, dynamic> json) {
  return _NutritionistManagementResponse.fromJson(json);
}

/// @nodoc
mixin _$NutritionistManagementResponse {
  List<NutritionistManagementEntity> get nutritionists =>
      throw _privateConstructorUsedError;
  PaginationInfo get pagination => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistManagementResponse value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistManagementResponse value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistManagementResponse value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionistManagementResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionistManagementResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionistManagementResponseCopyWith<NutritionistManagementResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionistManagementResponseCopyWith<$Res> {
  factory $NutritionistManagementResponseCopyWith(
          NutritionistManagementResponse value,
          $Res Function(NutritionistManagementResponse) then) =
      _$NutritionistManagementResponseCopyWithImpl<$Res,
          NutritionistManagementResponse>;
  @useResult
  $Res call(
      {List<NutritionistManagementEntity> nutritionists,
      PaginationInfo pagination});

  $PaginationInfoCopyWith<$Res> get pagination;
}

/// @nodoc
class _$NutritionistManagementResponseCopyWithImpl<$Res,
        $Val extends NutritionistManagementResponse>
    implements $NutritionistManagementResponseCopyWith<$Res> {
  _$NutritionistManagementResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionistManagementResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nutritionists = null,
    Object? pagination = null,
  }) {
    return _then(_value.copyWith(
      nutritionists: null == nutritionists
          ? _value.nutritionists
          : nutritionists // ignore: cast_nullable_to_non_nullable
              as List<NutritionistManagementEntity>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfo,
    ) as $Val);
  }

  /// Create a copy of NutritionistManagementResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationInfoCopyWith<$Res> get pagination {
    return $PaginationInfoCopyWith<$Res>(_value.pagination, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionistManagementResponseImplCopyWith<$Res>
    implements $NutritionistManagementResponseCopyWith<$Res> {
  factory _$$NutritionistManagementResponseImplCopyWith(
          _$NutritionistManagementResponseImpl value,
          $Res Function(_$NutritionistManagementResponseImpl) then) =
      __$$NutritionistManagementResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<NutritionistManagementEntity> nutritionists,
      PaginationInfo pagination});

  @override
  $PaginationInfoCopyWith<$Res> get pagination;
}

/// @nodoc
class __$$NutritionistManagementResponseImplCopyWithImpl<$Res>
    extends _$NutritionistManagementResponseCopyWithImpl<$Res,
        _$NutritionistManagementResponseImpl>
    implements _$$NutritionistManagementResponseImplCopyWith<$Res> {
  __$$NutritionistManagementResponseImplCopyWithImpl(
      _$NutritionistManagementResponseImpl _value,
      $Res Function(_$NutritionistManagementResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionistManagementResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nutritionists = null,
    Object? pagination = null,
  }) {
    return _then(_$NutritionistManagementResponseImpl(
      nutritionists: null == nutritionists
          ? _value._nutritionists
          : nutritionists // ignore: cast_nullable_to_non_nullable
              as List<NutritionistManagementEntity>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfo,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionistManagementResponseImpl
    implements _NutritionistManagementResponse {
  const _$NutritionistManagementResponseImpl(
      {required final List<NutritionistManagementEntity> nutritionists,
      required this.pagination})
      : _nutritionists = nutritionists;

  factory _$NutritionistManagementResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NutritionistManagementResponseImplFromJson(json);

  final List<NutritionistManagementEntity> _nutritionists;
  @override
  List<NutritionistManagementEntity> get nutritionists {
    if (_nutritionists is EqualUnmodifiableListView) return _nutritionists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionists);
  }

  @override
  final PaginationInfo pagination;

  @override
  String toString() {
    return 'NutritionistManagementResponse(nutritionists: $nutritionists, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionistManagementResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._nutritionists, _nutritionists) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_nutritionists), pagination);

  /// Create a copy of NutritionistManagementResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionistManagementResponseImplCopyWith<
          _$NutritionistManagementResponseImpl>
      get copyWith => __$$NutritionistManagementResponseImplCopyWithImpl<
          _$NutritionistManagementResponseImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistManagementResponse value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistManagementResponse value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistManagementResponse value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionistManagementResponseImplToJson(
      this,
    );
  }
}

abstract class _NutritionistManagementResponse
    implements NutritionistManagementResponse {
  const factory _NutritionistManagementResponse(
          {required final List<NutritionistManagementEntity> nutritionists,
          required final PaginationInfo pagination}) =
      _$NutritionistManagementResponseImpl;

  factory _NutritionistManagementResponse.fromJson(Map<String, dynamic> json) =
      _$NutritionistManagementResponseImpl.fromJson;

  @override
  List<NutritionistManagementEntity> get nutritionists;
  @override
  PaginationInfo get pagination;

  /// Create a copy of NutritionistManagementResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionistManagementResponseImplCopyWith<
          _$NutritionistManagementResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PaginationInfo _$PaginationInfoFromJson(Map<String, dynamic> json) {
  return _PaginationInfo.fromJson(json);
}

/// @nodoc
mixin _$PaginationInfo {
  int get current => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get totalRecords => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PaginationInfo value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PaginationInfo value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PaginationInfo value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this PaginationInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationInfoCopyWith<PaginationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationInfoCopyWith<$Res> {
  factory $PaginationInfoCopyWith(
          PaginationInfo value, $Res Function(PaginationInfo) then) =
      _$PaginationInfoCopyWithImpl<$Res, PaginationInfo>;
  @useResult
  $Res call({int current, int total, int pageSize, int totalRecords});
}

/// @nodoc
class _$PaginationInfoCopyWithImpl<$Res, $Val extends PaginationInfo>
    implements $PaginationInfoCopyWith<$Res> {
  _$PaginationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? total = null,
    Object? pageSize = null,
    Object? totalRecords = null,
  }) {
    return _then(_value.copyWith(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalRecords: null == totalRecords
          ? _value.totalRecords
          : totalRecords // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationInfoImplCopyWith<$Res>
    implements $PaginationInfoCopyWith<$Res> {
  factory _$$PaginationInfoImplCopyWith(_$PaginationInfoImpl value,
          $Res Function(_$PaginationInfoImpl) then) =
      __$$PaginationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int current, int total, int pageSize, int totalRecords});
}

/// @nodoc
class __$$PaginationInfoImplCopyWithImpl<$Res>
    extends _$PaginationInfoCopyWithImpl<$Res, _$PaginationInfoImpl>
    implements _$$PaginationInfoImplCopyWith<$Res> {
  __$$PaginationInfoImplCopyWithImpl(
      _$PaginationInfoImpl _value, $Res Function(_$PaginationInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? total = null,
    Object? pageSize = null,
    Object? totalRecords = null,
  }) {
    return _then(_$PaginationInfoImpl(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalRecords: null == totalRecords
          ? _value.totalRecords
          : totalRecords // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationInfoImpl implements _PaginationInfo {
  const _$PaginationInfoImpl(
      {required this.current,
      required this.total,
      required this.pageSize,
      required this.totalRecords});

  factory _$PaginationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationInfoImplFromJson(json);

  @override
  final int current;
  @override
  final int total;
  @override
  final int pageSize;
  @override
  final int totalRecords;

  @override
  String toString() {
    return 'PaginationInfo(current: $current, total: $total, pageSize: $pageSize, totalRecords: $totalRecords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationInfoImpl &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalRecords, totalRecords) ||
                other.totalRecords == totalRecords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, current, total, pageSize, totalRecords);

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationInfoImplCopyWith<_$PaginationInfoImpl> get copyWith =>
      __$$PaginationInfoImplCopyWithImpl<_$PaginationInfoImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PaginationInfo value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PaginationInfo value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PaginationInfo value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationInfoImplToJson(
      this,
    );
  }
}

abstract class _PaginationInfo implements PaginationInfo {
  const factory _PaginationInfo(
      {required final int current,
      required final int total,
      required final int pageSize,
      required final int totalRecords}) = _$PaginationInfoImpl;

  factory _PaginationInfo.fromJson(Map<String, dynamic> json) =
      _$PaginationInfoImpl.fromJson;

  @override
  int get current;
  @override
  int get total;
  @override
  int get pageSize;
  @override
  int get totalRecords;

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationInfoImplCopyWith<_$PaginationInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionistManagementOverview _$NutritionistManagementOverviewFromJson(
    Map<String, dynamic> json) {
  return _NutritionistManagementOverview.fromJson(json);
}

/// @nodoc
mixin _$NutritionistManagementOverview {
  OverviewStats get overview => throw _privateConstructorUsedError;
  DistributionStats get distributions => throw _privateConstructorUsedError;
  TrendStats get trends => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistManagementOverview value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistManagementOverview value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistManagementOverview value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionistManagementOverview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionistManagementOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionistManagementOverviewCopyWith<NutritionistManagementOverview>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionistManagementOverviewCopyWith<$Res> {
  factory $NutritionistManagementOverviewCopyWith(
          NutritionistManagementOverview value,
          $Res Function(NutritionistManagementOverview) then) =
      _$NutritionistManagementOverviewCopyWithImpl<$Res,
          NutritionistManagementOverview>;
  @useResult
  $Res call(
      {OverviewStats overview,
      DistributionStats distributions,
      TrendStats trends});

  $OverviewStatsCopyWith<$Res> get overview;
  $DistributionStatsCopyWith<$Res> get distributions;
  $TrendStatsCopyWith<$Res> get trends;
}

/// @nodoc
class _$NutritionistManagementOverviewCopyWithImpl<$Res,
        $Val extends NutritionistManagementOverview>
    implements $NutritionistManagementOverviewCopyWith<$Res> {
  _$NutritionistManagementOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionistManagementOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overview = null,
    Object? distributions = null,
    Object? trends = null,
  }) {
    return _then(_value.copyWith(
      overview: null == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as OverviewStats,
      distributions: null == distributions
          ? _value.distributions
          : distributions // ignore: cast_nullable_to_non_nullable
              as DistributionStats,
      trends: null == trends
          ? _value.trends
          : trends // ignore: cast_nullable_to_non_nullable
              as TrendStats,
    ) as $Val);
  }

  /// Create a copy of NutritionistManagementOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OverviewStatsCopyWith<$Res> get overview {
    return $OverviewStatsCopyWith<$Res>(_value.overview, (value) {
      return _then(_value.copyWith(overview: value) as $Val);
    });
  }

  /// Create a copy of NutritionistManagementOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DistributionStatsCopyWith<$Res> get distributions {
    return $DistributionStatsCopyWith<$Res>(_value.distributions, (value) {
      return _then(_value.copyWith(distributions: value) as $Val);
    });
  }

  /// Create a copy of NutritionistManagementOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrendStatsCopyWith<$Res> get trends {
    return $TrendStatsCopyWith<$Res>(_value.trends, (value) {
      return _then(_value.copyWith(trends: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionistManagementOverviewImplCopyWith<$Res>
    implements $NutritionistManagementOverviewCopyWith<$Res> {
  factory _$$NutritionistManagementOverviewImplCopyWith(
          _$NutritionistManagementOverviewImpl value,
          $Res Function(_$NutritionistManagementOverviewImpl) then) =
      __$$NutritionistManagementOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OverviewStats overview,
      DistributionStats distributions,
      TrendStats trends});

  @override
  $OverviewStatsCopyWith<$Res> get overview;
  @override
  $DistributionStatsCopyWith<$Res> get distributions;
  @override
  $TrendStatsCopyWith<$Res> get trends;
}

/// @nodoc
class __$$NutritionistManagementOverviewImplCopyWithImpl<$Res>
    extends _$NutritionistManagementOverviewCopyWithImpl<$Res,
        _$NutritionistManagementOverviewImpl>
    implements _$$NutritionistManagementOverviewImplCopyWith<$Res> {
  __$$NutritionistManagementOverviewImplCopyWithImpl(
      _$NutritionistManagementOverviewImpl _value,
      $Res Function(_$NutritionistManagementOverviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionistManagementOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overview = null,
    Object? distributions = null,
    Object? trends = null,
  }) {
    return _then(_$NutritionistManagementOverviewImpl(
      overview: null == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as OverviewStats,
      distributions: null == distributions
          ? _value.distributions
          : distributions // ignore: cast_nullable_to_non_nullable
              as DistributionStats,
      trends: null == trends
          ? _value.trends
          : trends // ignore: cast_nullable_to_non_nullable
              as TrendStats,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionistManagementOverviewImpl
    implements _NutritionistManagementOverview {
  const _$NutritionistManagementOverviewImpl(
      {required this.overview,
      required this.distributions,
      required this.trends});

  factory _$NutritionistManagementOverviewImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NutritionistManagementOverviewImplFromJson(json);

  @override
  final OverviewStats overview;
  @override
  final DistributionStats distributions;
  @override
  final TrendStats trends;

  @override
  String toString() {
    return 'NutritionistManagementOverview(overview: $overview, distributions: $distributions, trends: $trends)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionistManagementOverviewImpl &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            (identical(other.distributions, distributions) ||
                other.distributions == distributions) &&
            (identical(other.trends, trends) || other.trends == trends));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, overview, distributions, trends);

  /// Create a copy of NutritionistManagementOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionistManagementOverviewImplCopyWith<
          _$NutritionistManagementOverviewImpl>
      get copyWith => __$$NutritionistManagementOverviewImplCopyWithImpl<
          _$NutritionistManagementOverviewImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistManagementOverview value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistManagementOverview value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistManagementOverview value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionistManagementOverviewImplToJson(
      this,
    );
  }
}

abstract class _NutritionistManagementOverview
    implements NutritionistManagementOverview {
  const factory _NutritionistManagementOverview(
      {required final OverviewStats overview,
      required final DistributionStats distributions,
      required final TrendStats trends}) = _$NutritionistManagementOverviewImpl;

  factory _NutritionistManagementOverview.fromJson(Map<String, dynamic> json) =
      _$NutritionistManagementOverviewImpl.fromJson;

  @override
  OverviewStats get overview;
  @override
  DistributionStats get distributions;
  @override
  TrendStats get trends;

  /// Create a copy of NutritionistManagementOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionistManagementOverviewImplCopyWith<
          _$NutritionistManagementOverviewImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OverviewStats _$OverviewStatsFromJson(Map<String, dynamic> json) {
  return _OverviewStats.fromJson(json);
}

/// @nodoc
mixin _$OverviewStats {
  int get totalNutritionists => throw _privateConstructorUsedError;
  int get activeNutritionists => throw _privateConstructorUsedError;
  int get pendingVerification => throw _privateConstructorUsedError;
  int get onlineNutritionists => throw _privateConstructorUsedError;
  int get activeInMonth => throw _privateConstructorUsedError;
  String get activityRate => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OverviewStats value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OverviewStats value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OverviewStats value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OverviewStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OverviewStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OverviewStatsCopyWith<OverviewStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverviewStatsCopyWith<$Res> {
  factory $OverviewStatsCopyWith(
          OverviewStats value, $Res Function(OverviewStats) then) =
      _$OverviewStatsCopyWithImpl<$Res, OverviewStats>;
  @useResult
  $Res call(
      {int totalNutritionists,
      int activeNutritionists,
      int pendingVerification,
      int onlineNutritionists,
      int activeInMonth,
      String activityRate});
}

/// @nodoc
class _$OverviewStatsCopyWithImpl<$Res, $Val extends OverviewStats>
    implements $OverviewStatsCopyWith<$Res> {
  _$OverviewStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OverviewStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalNutritionists = null,
    Object? activeNutritionists = null,
    Object? pendingVerification = null,
    Object? onlineNutritionists = null,
    Object? activeInMonth = null,
    Object? activityRate = null,
  }) {
    return _then(_value.copyWith(
      totalNutritionists: null == totalNutritionists
          ? _value.totalNutritionists
          : totalNutritionists // ignore: cast_nullable_to_non_nullable
              as int,
      activeNutritionists: null == activeNutritionists
          ? _value.activeNutritionists
          : activeNutritionists // ignore: cast_nullable_to_non_nullable
              as int,
      pendingVerification: null == pendingVerification
          ? _value.pendingVerification
          : pendingVerification // ignore: cast_nullable_to_non_nullable
              as int,
      onlineNutritionists: null == onlineNutritionists
          ? _value.onlineNutritionists
          : onlineNutritionists // ignore: cast_nullable_to_non_nullable
              as int,
      activeInMonth: null == activeInMonth
          ? _value.activeInMonth
          : activeInMonth // ignore: cast_nullable_to_non_nullable
              as int,
      activityRate: null == activityRate
          ? _value.activityRate
          : activityRate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OverviewStatsImplCopyWith<$Res>
    implements $OverviewStatsCopyWith<$Res> {
  factory _$$OverviewStatsImplCopyWith(
          _$OverviewStatsImpl value, $Res Function(_$OverviewStatsImpl) then) =
      __$$OverviewStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalNutritionists,
      int activeNutritionists,
      int pendingVerification,
      int onlineNutritionists,
      int activeInMonth,
      String activityRate});
}

/// @nodoc
class __$$OverviewStatsImplCopyWithImpl<$Res>
    extends _$OverviewStatsCopyWithImpl<$Res, _$OverviewStatsImpl>
    implements _$$OverviewStatsImplCopyWith<$Res> {
  __$$OverviewStatsImplCopyWithImpl(
      _$OverviewStatsImpl _value, $Res Function(_$OverviewStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of OverviewStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalNutritionists = null,
    Object? activeNutritionists = null,
    Object? pendingVerification = null,
    Object? onlineNutritionists = null,
    Object? activeInMonth = null,
    Object? activityRate = null,
  }) {
    return _then(_$OverviewStatsImpl(
      totalNutritionists: null == totalNutritionists
          ? _value.totalNutritionists
          : totalNutritionists // ignore: cast_nullable_to_non_nullable
              as int,
      activeNutritionists: null == activeNutritionists
          ? _value.activeNutritionists
          : activeNutritionists // ignore: cast_nullable_to_non_nullable
              as int,
      pendingVerification: null == pendingVerification
          ? _value.pendingVerification
          : pendingVerification // ignore: cast_nullable_to_non_nullable
              as int,
      onlineNutritionists: null == onlineNutritionists
          ? _value.onlineNutritionists
          : onlineNutritionists // ignore: cast_nullable_to_non_nullable
              as int,
      activeInMonth: null == activeInMonth
          ? _value.activeInMonth
          : activeInMonth // ignore: cast_nullable_to_non_nullable
              as int,
      activityRate: null == activityRate
          ? _value.activityRate
          : activityRate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OverviewStatsImpl implements _OverviewStats {
  const _$OverviewStatsImpl(
      {this.totalNutritionists = 0,
      this.activeNutritionists = 0,
      this.pendingVerification = 0,
      this.onlineNutritionists = 0,
      this.activeInMonth = 0,
      this.activityRate = '0'});

  factory _$OverviewStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$OverviewStatsImplFromJson(json);

  @override
  @JsonKey()
  final int totalNutritionists;
  @override
  @JsonKey()
  final int activeNutritionists;
  @override
  @JsonKey()
  final int pendingVerification;
  @override
  @JsonKey()
  final int onlineNutritionists;
  @override
  @JsonKey()
  final int activeInMonth;
  @override
  @JsonKey()
  final String activityRate;

  @override
  String toString() {
    return 'OverviewStats(totalNutritionists: $totalNutritionists, activeNutritionists: $activeNutritionists, pendingVerification: $pendingVerification, onlineNutritionists: $onlineNutritionists, activeInMonth: $activeInMonth, activityRate: $activityRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverviewStatsImpl &&
            (identical(other.totalNutritionists, totalNutritionists) ||
                other.totalNutritionists == totalNutritionists) &&
            (identical(other.activeNutritionists, activeNutritionists) ||
                other.activeNutritionists == activeNutritionists) &&
            (identical(other.pendingVerification, pendingVerification) ||
                other.pendingVerification == pendingVerification) &&
            (identical(other.onlineNutritionists, onlineNutritionists) ||
                other.onlineNutritionists == onlineNutritionists) &&
            (identical(other.activeInMonth, activeInMonth) ||
                other.activeInMonth == activeInMonth) &&
            (identical(other.activityRate, activityRate) ||
                other.activityRate == activityRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalNutritionists,
      activeNutritionists,
      pendingVerification,
      onlineNutritionists,
      activeInMonth,
      activityRate);

  /// Create a copy of OverviewStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OverviewStatsImplCopyWith<_$OverviewStatsImpl> get copyWith =>
      __$$OverviewStatsImplCopyWithImpl<_$OverviewStatsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OverviewStats value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OverviewStats value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OverviewStats value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OverviewStatsImplToJson(
      this,
    );
  }
}

abstract class _OverviewStats implements OverviewStats {
  const factory _OverviewStats(
      {final int totalNutritionists,
      final int activeNutritionists,
      final int pendingVerification,
      final int onlineNutritionists,
      final int activeInMonth,
      final String activityRate}) = _$OverviewStatsImpl;

  factory _OverviewStats.fromJson(Map<String, dynamic> json) =
      _$OverviewStatsImpl.fromJson;

  @override
  int get totalNutritionists;
  @override
  int get activeNutritionists;
  @override
  int get pendingVerification;
  @override
  int get onlineNutritionists;
  @override
  int get activeInMonth;
  @override
  String get activityRate;

  /// Create a copy of OverviewStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OverviewStatsImplCopyWith<_$OverviewStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DistributionStats _$DistributionStatsFromJson(Map<String, dynamic> json) {
  return _DistributionStats.fromJson(json);
}

/// @nodoc
mixin _$DistributionStats {
  List<StatusDistribution> get status => throw _privateConstructorUsedError;
  List<SpecializationDistribution> get specialization =>
      throw _privateConstructorUsedError;
  List<LevelDistribution> get level => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DistributionStats value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DistributionStats value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DistributionStats value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this DistributionStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DistributionStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DistributionStatsCopyWith<DistributionStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DistributionStatsCopyWith<$Res> {
  factory $DistributionStatsCopyWith(
          DistributionStats value, $Res Function(DistributionStats) then) =
      _$DistributionStatsCopyWithImpl<$Res, DistributionStats>;
  @useResult
  $Res call(
      {List<StatusDistribution> status,
      List<SpecializationDistribution> specialization,
      List<LevelDistribution> level});
}

/// @nodoc
class _$DistributionStatsCopyWithImpl<$Res, $Val extends DistributionStats>
    implements $DistributionStatsCopyWith<$Res> {
  _$DistributionStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DistributionStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? specialization = null,
    Object? level = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as List<StatusDistribution>,
      specialization: null == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as List<SpecializationDistribution>,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as List<LevelDistribution>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DistributionStatsImplCopyWith<$Res>
    implements $DistributionStatsCopyWith<$Res> {
  factory _$$DistributionStatsImplCopyWith(_$DistributionStatsImpl value,
          $Res Function(_$DistributionStatsImpl) then) =
      __$$DistributionStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<StatusDistribution> status,
      List<SpecializationDistribution> specialization,
      List<LevelDistribution> level});
}

/// @nodoc
class __$$DistributionStatsImplCopyWithImpl<$Res>
    extends _$DistributionStatsCopyWithImpl<$Res, _$DistributionStatsImpl>
    implements _$$DistributionStatsImplCopyWith<$Res> {
  __$$DistributionStatsImplCopyWithImpl(_$DistributionStatsImpl _value,
      $Res Function(_$DistributionStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DistributionStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? specialization = null,
    Object? level = null,
  }) {
    return _then(_$DistributionStatsImpl(
      status: null == status
          ? _value._status
          : status // ignore: cast_nullable_to_non_nullable
              as List<StatusDistribution>,
      specialization: null == specialization
          ? _value._specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as List<SpecializationDistribution>,
      level: null == level
          ? _value._level
          : level // ignore: cast_nullable_to_non_nullable
              as List<LevelDistribution>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DistributionStatsImpl implements _DistributionStats {
  const _$DistributionStatsImpl(
      {final List<StatusDistribution> status = const [],
      final List<SpecializationDistribution> specialization = const [],
      final List<LevelDistribution> level = const []})
      : _status = status,
        _specialization = specialization,
        _level = level;

  factory _$DistributionStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DistributionStatsImplFromJson(json);

  final List<StatusDistribution> _status;
  @override
  @JsonKey()
  List<StatusDistribution> get status {
    if (_status is EqualUnmodifiableListView) return _status;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_status);
  }

  final List<SpecializationDistribution> _specialization;
  @override
  @JsonKey()
  List<SpecializationDistribution> get specialization {
    if (_specialization is EqualUnmodifiableListView) return _specialization;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialization);
  }

  final List<LevelDistribution> _level;
  @override
  @JsonKey()
  List<LevelDistribution> get level {
    if (_level is EqualUnmodifiableListView) return _level;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_level);
  }

  @override
  String toString() {
    return 'DistributionStats(status: $status, specialization: $specialization, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DistributionStatsImpl &&
            const DeepCollectionEquality().equals(other._status, _status) &&
            const DeepCollectionEquality()
                .equals(other._specialization, _specialization) &&
            const DeepCollectionEquality().equals(other._level, _level));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_status),
      const DeepCollectionEquality().hash(_specialization),
      const DeepCollectionEquality().hash(_level));

  /// Create a copy of DistributionStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DistributionStatsImplCopyWith<_$DistributionStatsImpl> get copyWith =>
      __$$DistributionStatsImplCopyWithImpl<_$DistributionStatsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DistributionStats value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DistributionStats value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DistributionStats value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DistributionStatsImplToJson(
      this,
    );
  }
}

abstract class _DistributionStats implements DistributionStats {
  const factory _DistributionStats(
      {final List<StatusDistribution> status,
      final List<SpecializationDistribution> specialization,
      final List<LevelDistribution> level}) = _$DistributionStatsImpl;

  factory _DistributionStats.fromJson(Map<String, dynamic> json) =
      _$DistributionStatsImpl.fromJson;

  @override
  List<StatusDistribution> get status;
  @override
  List<SpecializationDistribution> get specialization;
  @override
  List<LevelDistribution> get level;

  /// Create a copy of DistributionStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DistributionStatsImplCopyWith<_$DistributionStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StatusDistribution _$StatusDistributionFromJson(Map<String, dynamic> json) {
  return _StatusDistribution.fromJson(json);
}

/// @nodoc
mixin _$StatusDistribution {
  String get id => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StatusDistribution value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StatusDistribution value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StatusDistribution value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this StatusDistribution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StatusDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatusDistributionCopyWith<StatusDistribution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatusDistributionCopyWith<$Res> {
  factory $StatusDistributionCopyWith(
          StatusDistribution value, $Res Function(StatusDistribution) then) =
      _$StatusDistributionCopyWithImpl<$Res, StatusDistribution>;
  @useResult
  $Res call({String id, int count});
}

/// @nodoc
class _$StatusDistributionCopyWithImpl<$Res, $Val extends StatusDistribution>
    implements $StatusDistributionCopyWith<$Res> {
  _$StatusDistributionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatusDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatusDistributionImplCopyWith<$Res>
    implements $StatusDistributionCopyWith<$Res> {
  factory _$$StatusDistributionImplCopyWith(_$StatusDistributionImpl value,
          $Res Function(_$StatusDistributionImpl) then) =
      __$$StatusDistributionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, int count});
}

/// @nodoc
class __$$StatusDistributionImplCopyWithImpl<$Res>
    extends _$StatusDistributionCopyWithImpl<$Res, _$StatusDistributionImpl>
    implements _$$StatusDistributionImplCopyWith<$Res> {
  __$$StatusDistributionImplCopyWithImpl(_$StatusDistributionImpl _value,
      $Res Function(_$StatusDistributionImpl) _then)
      : super(_value, _then);

  /// Create a copy of StatusDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? count = null,
  }) {
    return _then(_$StatusDistributionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StatusDistributionImpl implements _StatusDistribution {
  const _$StatusDistributionImpl({required this.id, required this.count});

  factory _$StatusDistributionImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatusDistributionImplFromJson(json);

  @override
  final String id;
  @override
  final int count;

  @override
  String toString() {
    return 'StatusDistribution(id: $id, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatusDistributionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, count);

  /// Create a copy of StatusDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatusDistributionImplCopyWith<_$StatusDistributionImpl> get copyWith =>
      __$$StatusDistributionImplCopyWithImpl<_$StatusDistributionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StatusDistribution value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StatusDistribution value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StatusDistribution value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StatusDistributionImplToJson(
      this,
    );
  }
}

abstract class _StatusDistribution implements StatusDistribution {
  const factory _StatusDistribution(
      {required final String id,
      required final int count}) = _$StatusDistributionImpl;

  factory _StatusDistribution.fromJson(Map<String, dynamic> json) =
      _$StatusDistributionImpl.fromJson;

  @override
  String get id;
  @override
  int get count;

  /// Create a copy of StatusDistribution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatusDistributionImplCopyWith<_$StatusDistributionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpecializationDistribution _$SpecializationDistributionFromJson(
    Map<String, dynamic> json) {
  return _SpecializationDistribution.fromJson(json);
}

/// @nodoc
mixin _$SpecializationDistribution {
  String get id => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SpecializationDistribution value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SpecializationDistribution value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SpecializationDistribution value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this SpecializationDistribution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpecializationDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpecializationDistributionCopyWith<SpecializationDistribution>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpecializationDistributionCopyWith<$Res> {
  factory $SpecializationDistributionCopyWith(SpecializationDistribution value,
          $Res Function(SpecializationDistribution) then) =
      _$SpecializationDistributionCopyWithImpl<$Res,
          SpecializationDistribution>;
  @useResult
  $Res call({String id, int count});
}

/// @nodoc
class _$SpecializationDistributionCopyWithImpl<$Res,
        $Val extends SpecializationDistribution>
    implements $SpecializationDistributionCopyWith<$Res> {
  _$SpecializationDistributionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpecializationDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpecializationDistributionImplCopyWith<$Res>
    implements $SpecializationDistributionCopyWith<$Res> {
  factory _$$SpecializationDistributionImplCopyWith(
          _$SpecializationDistributionImpl value,
          $Res Function(_$SpecializationDistributionImpl) then) =
      __$$SpecializationDistributionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, int count});
}

/// @nodoc
class __$$SpecializationDistributionImplCopyWithImpl<$Res>
    extends _$SpecializationDistributionCopyWithImpl<$Res,
        _$SpecializationDistributionImpl>
    implements _$$SpecializationDistributionImplCopyWith<$Res> {
  __$$SpecializationDistributionImplCopyWithImpl(
      _$SpecializationDistributionImpl _value,
      $Res Function(_$SpecializationDistributionImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpecializationDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? count = null,
  }) {
    return _then(_$SpecializationDistributionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpecializationDistributionImpl implements _SpecializationDistribution {
  const _$SpecializationDistributionImpl(
      {required this.id, required this.count});

  factory _$SpecializationDistributionImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SpecializationDistributionImplFromJson(json);

  @override
  final String id;
  @override
  final int count;

  @override
  String toString() {
    return 'SpecializationDistribution(id: $id, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecializationDistributionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, count);

  /// Create a copy of SpecializationDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecializationDistributionImplCopyWith<_$SpecializationDistributionImpl>
      get copyWith => __$$SpecializationDistributionImplCopyWithImpl<
          _$SpecializationDistributionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SpecializationDistribution value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SpecializationDistribution value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SpecializationDistribution value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SpecializationDistributionImplToJson(
      this,
    );
  }
}

abstract class _SpecializationDistribution
    implements SpecializationDistribution {
  const factory _SpecializationDistribution(
      {required final String id,
      required final int count}) = _$SpecializationDistributionImpl;

  factory _SpecializationDistribution.fromJson(Map<String, dynamic> json) =
      _$SpecializationDistributionImpl.fromJson;

  @override
  String get id;
  @override
  int get count;

  /// Create a copy of SpecializationDistribution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecializationDistributionImplCopyWith<_$SpecializationDistributionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

LevelDistribution _$LevelDistributionFromJson(Map<String, dynamic> json) {
  return _LevelDistribution.fromJson(json);
}

/// @nodoc
mixin _$LevelDistribution {
  String get id => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_LevelDistribution value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LevelDistribution value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LevelDistribution value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this LevelDistribution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LevelDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LevelDistributionCopyWith<LevelDistribution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LevelDistributionCopyWith<$Res> {
  factory $LevelDistributionCopyWith(
          LevelDistribution value, $Res Function(LevelDistribution) then) =
      _$LevelDistributionCopyWithImpl<$Res, LevelDistribution>;
  @useResult
  $Res call({String id, int count});
}

/// @nodoc
class _$LevelDistributionCopyWithImpl<$Res, $Val extends LevelDistribution>
    implements $LevelDistributionCopyWith<$Res> {
  _$LevelDistributionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LevelDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LevelDistributionImplCopyWith<$Res>
    implements $LevelDistributionCopyWith<$Res> {
  factory _$$LevelDistributionImplCopyWith(_$LevelDistributionImpl value,
          $Res Function(_$LevelDistributionImpl) then) =
      __$$LevelDistributionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, int count});
}

/// @nodoc
class __$$LevelDistributionImplCopyWithImpl<$Res>
    extends _$LevelDistributionCopyWithImpl<$Res, _$LevelDistributionImpl>
    implements _$$LevelDistributionImplCopyWith<$Res> {
  __$$LevelDistributionImplCopyWithImpl(_$LevelDistributionImpl _value,
      $Res Function(_$LevelDistributionImpl) _then)
      : super(_value, _then);

  /// Create a copy of LevelDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? count = null,
  }) {
    return _then(_$LevelDistributionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LevelDistributionImpl implements _LevelDistribution {
  const _$LevelDistributionImpl({required this.id, required this.count});

  factory _$LevelDistributionImpl.fromJson(Map<String, dynamic> json) =>
      _$$LevelDistributionImplFromJson(json);

  @override
  final String id;
  @override
  final int count;

  @override
  String toString() {
    return 'LevelDistribution(id: $id, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LevelDistributionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, count);

  /// Create a copy of LevelDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LevelDistributionImplCopyWith<_$LevelDistributionImpl> get copyWith =>
      __$$LevelDistributionImplCopyWithImpl<_$LevelDistributionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_LevelDistribution value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LevelDistribution value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LevelDistribution value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LevelDistributionImplToJson(
      this,
    );
  }
}

abstract class _LevelDistribution implements LevelDistribution {
  const factory _LevelDistribution(
      {required final String id,
      required final int count}) = _$LevelDistributionImpl;

  factory _LevelDistribution.fromJson(Map<String, dynamic> json) =
      _$LevelDistributionImpl.fromJson;

  @override
  String get id;
  @override
  int get count;

  /// Create a copy of LevelDistribution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LevelDistributionImplCopyWith<_$LevelDistributionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrendStats _$TrendStatsFromJson(Map<String, dynamic> json) {
  return _TrendStats.fromJson(json);
}

/// @nodoc
mixin _$TrendStats {
  List<RegistrationTrend> get registration =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TrendStats value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TrendStats value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TrendStats value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this TrendStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrendStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrendStatsCopyWith<TrendStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrendStatsCopyWith<$Res> {
  factory $TrendStatsCopyWith(
          TrendStats value, $Res Function(TrendStats) then) =
      _$TrendStatsCopyWithImpl<$Res, TrendStats>;
  @useResult
  $Res call({List<RegistrationTrend> registration});
}

/// @nodoc
class _$TrendStatsCopyWithImpl<$Res, $Val extends TrendStats>
    implements $TrendStatsCopyWith<$Res> {
  _$TrendStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrendStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? registration = null,
  }) {
    return _then(_value.copyWith(
      registration: null == registration
          ? _value.registration
          : registration // ignore: cast_nullable_to_non_nullable
              as List<RegistrationTrend>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrendStatsImplCopyWith<$Res>
    implements $TrendStatsCopyWith<$Res> {
  factory _$$TrendStatsImplCopyWith(
          _$TrendStatsImpl value, $Res Function(_$TrendStatsImpl) then) =
      __$$TrendStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<RegistrationTrend> registration});
}

/// @nodoc
class __$$TrendStatsImplCopyWithImpl<$Res>
    extends _$TrendStatsCopyWithImpl<$Res, _$TrendStatsImpl>
    implements _$$TrendStatsImplCopyWith<$Res> {
  __$$TrendStatsImplCopyWithImpl(
      _$TrendStatsImpl _value, $Res Function(_$TrendStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrendStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? registration = null,
  }) {
    return _then(_$TrendStatsImpl(
      registration: null == registration
          ? _value._registration
          : registration // ignore: cast_nullable_to_non_nullable
              as List<RegistrationTrend>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrendStatsImpl implements _TrendStats {
  const _$TrendStatsImpl(
      {final List<RegistrationTrend> registration = const []})
      : _registration = registration;

  factory _$TrendStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrendStatsImplFromJson(json);

  final List<RegistrationTrend> _registration;
  @override
  @JsonKey()
  List<RegistrationTrend> get registration {
    if (_registration is EqualUnmodifiableListView) return _registration;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_registration);
  }

  @override
  String toString() {
    return 'TrendStats(registration: $registration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrendStatsImpl &&
            const DeepCollectionEquality()
                .equals(other._registration, _registration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_registration));

  /// Create a copy of TrendStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrendStatsImplCopyWith<_$TrendStatsImpl> get copyWith =>
      __$$TrendStatsImplCopyWithImpl<_$TrendStatsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TrendStats value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TrendStats value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TrendStats value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TrendStatsImplToJson(
      this,
    );
  }
}

abstract class _TrendStats implements TrendStats {
  const factory _TrendStats({final List<RegistrationTrend> registration}) =
      _$TrendStatsImpl;

  factory _TrendStats.fromJson(Map<String, dynamic> json) =
      _$TrendStatsImpl.fromJson;

  @override
  List<RegistrationTrend> get registration;

  /// Create a copy of TrendStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrendStatsImplCopyWith<_$TrendStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RegistrationTrend _$RegistrationTrendFromJson(Map<String, dynamic> json) {
  return _RegistrationTrend.fromJson(json);
}

/// @nodoc
mixin _$RegistrationTrend {
  TrendId get id => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RegistrationTrend value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RegistrationTrend value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RegistrationTrend value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this RegistrationTrend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegistrationTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegistrationTrendCopyWith<RegistrationTrend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationTrendCopyWith<$Res> {
  factory $RegistrationTrendCopyWith(
          RegistrationTrend value, $Res Function(RegistrationTrend) then) =
      _$RegistrationTrendCopyWithImpl<$Res, RegistrationTrend>;
  @useResult
  $Res call({TrendId id, int count});

  $TrendIdCopyWith<$Res> get id;
}

/// @nodoc
class _$RegistrationTrendCopyWithImpl<$Res, $Val extends RegistrationTrend>
    implements $RegistrationTrendCopyWith<$Res> {
  _$RegistrationTrendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegistrationTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as TrendId,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of RegistrationTrend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrendIdCopyWith<$Res> get id {
    return $TrendIdCopyWith<$Res>(_value.id, (value) {
      return _then(_value.copyWith(id: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RegistrationTrendImplCopyWith<$Res>
    implements $RegistrationTrendCopyWith<$Res> {
  factory _$$RegistrationTrendImplCopyWith(_$RegistrationTrendImpl value,
          $Res Function(_$RegistrationTrendImpl) then) =
      __$$RegistrationTrendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TrendId id, int count});

  @override
  $TrendIdCopyWith<$Res> get id;
}

/// @nodoc
class __$$RegistrationTrendImplCopyWithImpl<$Res>
    extends _$RegistrationTrendCopyWithImpl<$Res, _$RegistrationTrendImpl>
    implements _$$RegistrationTrendImplCopyWith<$Res> {
  __$$RegistrationTrendImplCopyWithImpl(_$RegistrationTrendImpl _value,
      $Res Function(_$RegistrationTrendImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegistrationTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? count = null,
  }) {
    return _then(_$RegistrationTrendImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as TrendId,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationTrendImpl implements _RegistrationTrend {
  const _$RegistrationTrendImpl({required this.id, required this.count});

  factory _$RegistrationTrendImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationTrendImplFromJson(json);

  @override
  final TrendId id;
  @override
  final int count;

  @override
  String toString() {
    return 'RegistrationTrend(id: $id, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationTrendImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, count);

  /// Create a copy of RegistrationTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationTrendImplCopyWith<_$RegistrationTrendImpl> get copyWith =>
      __$$RegistrationTrendImplCopyWithImpl<_$RegistrationTrendImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RegistrationTrend value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RegistrationTrend value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RegistrationTrend value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationTrendImplToJson(
      this,
    );
  }
}

abstract class _RegistrationTrend implements RegistrationTrend {
  const factory _RegistrationTrend(
      {required final TrendId id,
      required final int count}) = _$RegistrationTrendImpl;

  factory _RegistrationTrend.fromJson(Map<String, dynamic> json) =
      _$RegistrationTrendImpl.fromJson;

  @override
  TrendId get id;
  @override
  int get count;

  /// Create a copy of RegistrationTrend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegistrationTrendImplCopyWith<_$RegistrationTrendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrendId _$TrendIdFromJson(Map<String, dynamic> json) {
  return _TrendId.fromJson(json);
}

/// @nodoc
mixin _$TrendId {
  int get year => throw _privateConstructorUsedError;
  int get month => throw _privateConstructorUsedError;
  int get day => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TrendId value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TrendId value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TrendId value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this TrendId to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrendId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrendIdCopyWith<TrendId> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrendIdCopyWith<$Res> {
  factory $TrendIdCopyWith(TrendId value, $Res Function(TrendId) then) =
      _$TrendIdCopyWithImpl<$Res, TrendId>;
  @useResult
  $Res call({int year, int month, int day});
}

/// @nodoc
class _$TrendIdCopyWithImpl<$Res, $Val extends TrendId>
    implements $TrendIdCopyWith<$Res> {
  _$TrendIdCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrendId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? day = null,
  }) {
    return _then(_value.copyWith(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrendIdImplCopyWith<$Res> implements $TrendIdCopyWith<$Res> {
  factory _$$TrendIdImplCopyWith(
          _$TrendIdImpl value, $Res Function(_$TrendIdImpl) then) =
      __$$TrendIdImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int year, int month, int day});
}

/// @nodoc
class __$$TrendIdImplCopyWithImpl<$Res>
    extends _$TrendIdCopyWithImpl<$Res, _$TrendIdImpl>
    implements _$$TrendIdImplCopyWith<$Res> {
  __$$TrendIdImplCopyWithImpl(
      _$TrendIdImpl _value, $Res Function(_$TrendIdImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrendId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? day = null,
  }) {
    return _then(_$TrendIdImpl(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrendIdImpl implements _TrendId {
  const _$TrendIdImpl(
      {required this.year, required this.month, required this.day});

  factory _$TrendIdImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrendIdImplFromJson(json);

  @override
  final int year;
  @override
  final int month;
  @override
  final int day;

  @override
  String toString() {
    return 'TrendId(year: $year, month: $month, day: $day)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrendIdImpl &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.day, day) || other.day == day));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, year, month, day);

  /// Create a copy of TrendId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrendIdImplCopyWith<_$TrendIdImpl> get copyWith =>
      __$$TrendIdImplCopyWithImpl<_$TrendIdImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TrendId value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TrendId value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TrendId value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TrendIdImplToJson(
      this,
    );
  }
}

abstract class _TrendId implements TrendId {
  const factory _TrendId(
      {required final int year,
      required final int month,
      required final int day}) = _$TrendIdImpl;

  factory _TrendId.fromJson(Map<String, dynamic> json) = _$TrendIdImpl.fromJson;

  @override
  int get year;
  @override
  int get month;
  @override
  int get day;

  /// Create a copy of TrendId
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrendIdImplCopyWith<_$TrendIdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionistQuickSearchResult _$NutritionistQuickSearchResultFromJson(
    Map<String, dynamic> json) {
  return _NutritionistQuickSearchResult.fromJson(json);
}

/// @nodoc
mixin _$NutritionistQuickSearchResult {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String? get licenseNumber => throw _privateConstructorUsedError;
  List<String> get specializations => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get verificationStatus => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistQuickSearchResult value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistQuickSearchResult value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistQuickSearchResult value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionistQuickSearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionistQuickSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionistQuickSearchResultCopyWith<NutritionistQuickSearchResult>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionistQuickSearchResultCopyWith<$Res> {
  factory $NutritionistQuickSearchResultCopyWith(
          NutritionistQuickSearchResult value,
          $Res Function(NutritionistQuickSearchResult) then) =
      _$NutritionistQuickSearchResultCopyWithImpl<$Res,
          NutritionistQuickSearchResult>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? phone,
      String? email,
      String? avatar,
      String? licenseNumber,
      List<String> specializations,
      String status,
      String verificationStatus,
      bool isOnline});
}

/// @nodoc
class _$NutritionistQuickSearchResultCopyWithImpl<$Res,
        $Val extends NutritionistQuickSearchResult>
    implements $NutritionistQuickSearchResultCopyWith<$Res> {
  _$NutritionistQuickSearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionistQuickSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? avatar = freezed,
    Object? licenseNumber = freezed,
    Object? specializations = null,
    Object? status = null,
    Object? verificationStatus = null,
    Object? isOnline = null,
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
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseNumber: freezed == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      specializations: null == specializations
          ? _value.specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionistQuickSearchResultImplCopyWith<$Res>
    implements $NutritionistQuickSearchResultCopyWith<$Res> {
  factory _$$NutritionistQuickSearchResultImplCopyWith(
          _$NutritionistQuickSearchResultImpl value,
          $Res Function(_$NutritionistQuickSearchResultImpl) then) =
      __$$NutritionistQuickSearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? phone,
      String? email,
      String? avatar,
      String? licenseNumber,
      List<String> specializations,
      String status,
      String verificationStatus,
      bool isOnline});
}

/// @nodoc
class __$$NutritionistQuickSearchResultImplCopyWithImpl<$Res>
    extends _$NutritionistQuickSearchResultCopyWithImpl<$Res,
        _$NutritionistQuickSearchResultImpl>
    implements _$$NutritionistQuickSearchResultImplCopyWith<$Res> {
  __$$NutritionistQuickSearchResultImplCopyWithImpl(
      _$NutritionistQuickSearchResultImpl _value,
      $Res Function(_$NutritionistQuickSearchResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionistQuickSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? avatar = freezed,
    Object? licenseNumber = freezed,
    Object? specializations = null,
    Object? status = null,
    Object? verificationStatus = null,
    Object? isOnline = null,
  }) {
    return _then(_$NutritionistQuickSearchResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseNumber: freezed == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      specializations: null == specializations
          ? _value._specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionistQuickSearchResultImpl
    implements _NutritionistQuickSearchResult {
  const _$NutritionistQuickSearchResultImpl(
      {required this.id,
      required this.name,
      this.phone,
      this.email,
      this.avatar,
      this.licenseNumber,
      final List<String> specializations = const [],
      required this.status,
      required this.verificationStatus,
      this.isOnline = false})
      : _specializations = specializations;

  factory _$NutritionistQuickSearchResultImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NutritionistQuickSearchResultImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? avatar;
  @override
  final String? licenseNumber;
  final List<String> _specializations;
  @override
  @JsonKey()
  List<String> get specializations {
    if (_specializations is EqualUnmodifiableListView) return _specializations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specializations);
  }

  @override
  final String status;
  @override
  final String verificationStatus;
  @override
  @JsonKey()
  final bool isOnline;

  @override
  String toString() {
    return 'NutritionistQuickSearchResult(id: $id, name: $name, phone: $phone, email: $email, avatar: $avatar, licenseNumber: $licenseNumber, specializations: $specializations, status: $status, verificationStatus: $verificationStatus, isOnline: $isOnline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionistQuickSearchResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            const DeepCollectionEquality()
                .equals(other._specializations, _specializations) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      phone,
      email,
      avatar,
      licenseNumber,
      const DeepCollectionEquality().hash(_specializations),
      status,
      verificationStatus,
      isOnline);

  /// Create a copy of NutritionistQuickSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionistQuickSearchResultImplCopyWith<
          _$NutritionistQuickSearchResultImpl>
      get copyWith => __$$NutritionistQuickSearchResultImplCopyWithImpl<
          _$NutritionistQuickSearchResultImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistQuickSearchResult value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistQuickSearchResult value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistQuickSearchResult value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionistQuickSearchResultImplToJson(
      this,
    );
  }
}

abstract class _NutritionistQuickSearchResult
    implements NutritionistQuickSearchResult {
  const factory _NutritionistQuickSearchResult(
      {required final String id,
      required final String name,
      final String? phone,
      final String? email,
      final String? avatar,
      final String? licenseNumber,
      final List<String> specializations,
      required final String status,
      required final String verificationStatus,
      final bool isOnline}) = _$NutritionistQuickSearchResultImpl;

  factory _NutritionistQuickSearchResult.fromJson(Map<String, dynamic> json) =
      _$NutritionistQuickSearchResultImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get avatar;
  @override
  String? get licenseNumber;
  @override
  List<String> get specializations;
  @override
  String get status;
  @override
  String get verificationStatus;
  @override
  bool get isOnline;

  /// Create a copy of NutritionistQuickSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionistQuickSearchResultImplCopyWith<
          _$NutritionistQuickSearchResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NutritionistDetailEntity _$NutritionistDetailEntityFromJson(
    Map<String, dynamic> json) {
  return _NutritionistDetailEntity.fromJson(json);
}

/// @nodoc
mixin _$NutritionistDetailEntity {
  NutritionistManagementEntity get nutritionist =>
      throw _privateConstructorUsedError;
  NutritionistCertification? get certification =>
      throw _privateConstructorUsedError;
  NutritionistDetailStats get stats => throw _privateConstructorUsedError;
  List<RecentConsultation> get recentConsultations =>
      throw _privateConstructorUsedError;
  List<MonthlyTrend> get monthlyTrend => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistDetailEntity value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistDetailEntity value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistDetailEntity value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionistDetailEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionistDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionistDetailEntityCopyWith<NutritionistDetailEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionistDetailEntityCopyWith<$Res> {
  factory $NutritionistDetailEntityCopyWith(NutritionistDetailEntity value,
          $Res Function(NutritionistDetailEntity) then) =
      _$NutritionistDetailEntityCopyWithImpl<$Res, NutritionistDetailEntity>;
  @useResult
  $Res call(
      {NutritionistManagementEntity nutritionist,
      NutritionistCertification? certification,
      NutritionistDetailStats stats,
      List<RecentConsultation> recentConsultations,
      List<MonthlyTrend> monthlyTrend});

  $NutritionistManagementEntityCopyWith<$Res> get nutritionist;
  $NutritionistCertificationCopyWith<$Res>? get certification;
  $NutritionistDetailStatsCopyWith<$Res> get stats;
}

/// @nodoc
class _$NutritionistDetailEntityCopyWithImpl<$Res,
        $Val extends NutritionistDetailEntity>
    implements $NutritionistDetailEntityCopyWith<$Res> {
  _$NutritionistDetailEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionistDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nutritionist = null,
    Object? certification = freezed,
    Object? stats = null,
    Object? recentConsultations = null,
    Object? monthlyTrend = null,
  }) {
    return _then(_value.copyWith(
      nutritionist: null == nutritionist
          ? _value.nutritionist
          : nutritionist // ignore: cast_nullable_to_non_nullable
              as NutritionistManagementEntity,
      certification: freezed == certification
          ? _value.certification
          : certification // ignore: cast_nullable_to_non_nullable
              as NutritionistCertification?,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as NutritionistDetailStats,
      recentConsultations: null == recentConsultations
          ? _value.recentConsultations
          : recentConsultations // ignore: cast_nullable_to_non_nullable
              as List<RecentConsultation>,
      monthlyTrend: null == monthlyTrend
          ? _value.monthlyTrend
          : monthlyTrend // ignore: cast_nullable_to_non_nullable
              as List<MonthlyTrend>,
    ) as $Val);
  }

  /// Create a copy of NutritionistDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionistManagementEntityCopyWith<$Res> get nutritionist {
    return $NutritionistManagementEntityCopyWith<$Res>(_value.nutritionist,
        (value) {
      return _then(_value.copyWith(nutritionist: value) as $Val);
    });
  }

  /// Create a copy of NutritionistDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionistCertificationCopyWith<$Res>? get certification {
    if (_value.certification == null) {
      return null;
    }

    return $NutritionistCertificationCopyWith<$Res>(_value.certification!,
        (value) {
      return _then(_value.copyWith(certification: value) as $Val);
    });
  }

  /// Create a copy of NutritionistDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionistDetailStatsCopyWith<$Res> get stats {
    return $NutritionistDetailStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionistDetailEntityImplCopyWith<$Res>
    implements $NutritionistDetailEntityCopyWith<$Res> {
  factory _$$NutritionistDetailEntityImplCopyWith(
          _$NutritionistDetailEntityImpl value,
          $Res Function(_$NutritionistDetailEntityImpl) then) =
      __$$NutritionistDetailEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {NutritionistManagementEntity nutritionist,
      NutritionistCertification? certification,
      NutritionistDetailStats stats,
      List<RecentConsultation> recentConsultations,
      List<MonthlyTrend> monthlyTrend});

  @override
  $NutritionistManagementEntityCopyWith<$Res> get nutritionist;
  @override
  $NutritionistCertificationCopyWith<$Res>? get certification;
  @override
  $NutritionistDetailStatsCopyWith<$Res> get stats;
}

/// @nodoc
class __$$NutritionistDetailEntityImplCopyWithImpl<$Res>
    extends _$NutritionistDetailEntityCopyWithImpl<$Res,
        _$NutritionistDetailEntityImpl>
    implements _$$NutritionistDetailEntityImplCopyWith<$Res> {
  __$$NutritionistDetailEntityImplCopyWithImpl(
      _$NutritionistDetailEntityImpl _value,
      $Res Function(_$NutritionistDetailEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionistDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nutritionist = null,
    Object? certification = freezed,
    Object? stats = null,
    Object? recentConsultations = null,
    Object? monthlyTrend = null,
  }) {
    return _then(_$NutritionistDetailEntityImpl(
      nutritionist: null == nutritionist
          ? _value.nutritionist
          : nutritionist // ignore: cast_nullable_to_non_nullable
              as NutritionistManagementEntity,
      certification: freezed == certification
          ? _value.certification
          : certification // ignore: cast_nullable_to_non_nullable
              as NutritionistCertification?,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as NutritionistDetailStats,
      recentConsultations: null == recentConsultations
          ? _value._recentConsultations
          : recentConsultations // ignore: cast_nullable_to_non_nullable
              as List<RecentConsultation>,
      monthlyTrend: null == monthlyTrend
          ? _value._monthlyTrend
          : monthlyTrend // ignore: cast_nullable_to_non_nullable
              as List<MonthlyTrend>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionistDetailEntityImpl implements _NutritionistDetailEntity {
  const _$NutritionistDetailEntityImpl(
      {required this.nutritionist,
      this.certification,
      required this.stats,
      final List<RecentConsultation> recentConsultations = const [],
      final List<MonthlyTrend> monthlyTrend = const []})
      : _recentConsultations = recentConsultations,
        _monthlyTrend = monthlyTrend;

  factory _$NutritionistDetailEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionistDetailEntityImplFromJson(json);

  @override
  final NutritionistManagementEntity nutritionist;
  @override
  final NutritionistCertification? certification;
  @override
  final NutritionistDetailStats stats;
  final List<RecentConsultation> _recentConsultations;
  @override
  @JsonKey()
  List<RecentConsultation> get recentConsultations {
    if (_recentConsultations is EqualUnmodifiableListView)
      return _recentConsultations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentConsultations);
  }

  final List<MonthlyTrend> _monthlyTrend;
  @override
  @JsonKey()
  List<MonthlyTrend> get monthlyTrend {
    if (_monthlyTrend is EqualUnmodifiableListView) return _monthlyTrend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_monthlyTrend);
  }

  @override
  String toString() {
    return 'NutritionistDetailEntity(nutritionist: $nutritionist, certification: $certification, stats: $stats, recentConsultations: $recentConsultations, monthlyTrend: $monthlyTrend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionistDetailEntityImpl &&
            (identical(other.nutritionist, nutritionist) ||
                other.nutritionist == nutritionist) &&
            (identical(other.certification, certification) ||
                other.certification == certification) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            const DeepCollectionEquality()
                .equals(other._recentConsultations, _recentConsultations) &&
            const DeepCollectionEquality()
                .equals(other._monthlyTrend, _monthlyTrend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      nutritionist,
      certification,
      stats,
      const DeepCollectionEquality().hash(_recentConsultations),
      const DeepCollectionEquality().hash(_monthlyTrend));

  /// Create a copy of NutritionistDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionistDetailEntityImplCopyWith<_$NutritionistDetailEntityImpl>
      get copyWith => __$$NutritionistDetailEntityImplCopyWithImpl<
          _$NutritionistDetailEntityImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistDetailEntity value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistDetailEntity value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistDetailEntity value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionistDetailEntityImplToJson(
      this,
    );
  }
}

abstract class _NutritionistDetailEntity implements NutritionistDetailEntity {
  const factory _NutritionistDetailEntity(
      {required final NutritionistManagementEntity nutritionist,
      final NutritionistCertification? certification,
      required final NutritionistDetailStats stats,
      final List<RecentConsultation> recentConsultations,
      final List<MonthlyTrend> monthlyTrend}) = _$NutritionistDetailEntityImpl;

  factory _NutritionistDetailEntity.fromJson(Map<String, dynamic> json) =
      _$NutritionistDetailEntityImpl.fromJson;

  @override
  NutritionistManagementEntity get nutritionist;
  @override
  NutritionistCertification? get certification;
  @override
  NutritionistDetailStats get stats;
  @override
  List<RecentConsultation> get recentConsultations;
  @override
  List<MonthlyTrend> get monthlyTrend;

  /// Create a copy of NutritionistDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionistDetailEntityImplCopyWith<_$NutritionistDetailEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NutritionistCertification _$NutritionistCertificationFromJson(
    Map<String, dynamic> json) {
  return _NutritionistCertification.fromJson(json);
}

/// @nodoc
mixin _$NutritionistCertification {
  String get id => throw _privateConstructorUsedError;
  String get nutritionistId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get reviewedBy => throw _privateConstructorUsedError;
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  String? get reviewNotes => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistCertification value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistCertification value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistCertification value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionistCertification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionistCertification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionistCertificationCopyWith<NutritionistCertification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionistCertificationCopyWith<$Res> {
  factory $NutritionistCertificationCopyWith(NutritionistCertification value,
          $Res Function(NutritionistCertification) then) =
      _$NutritionistCertificationCopyWithImpl<$Res, NutritionistCertification>;
  @useResult
  $Res call(
      {String id,
      String nutritionistId,
      String status,
      String? reviewedBy,
      DateTime? reviewedAt,
      String? reviewNotes});
}

/// @nodoc
class _$NutritionistCertificationCopyWithImpl<$Res,
        $Val extends NutritionistCertification>
    implements $NutritionistCertificationCopyWith<$Res> {
  _$NutritionistCertificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionistCertification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nutritionistId = null,
    Object? status = null,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
    Object? reviewNotes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistId: null == nutritionistId
          ? _value.nutritionistId
          : nutritionistId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionistCertificationImplCopyWith<$Res>
    implements $NutritionistCertificationCopyWith<$Res> {
  factory _$$NutritionistCertificationImplCopyWith(
          _$NutritionistCertificationImpl value,
          $Res Function(_$NutritionistCertificationImpl) then) =
      __$$NutritionistCertificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nutritionistId,
      String status,
      String? reviewedBy,
      DateTime? reviewedAt,
      String? reviewNotes});
}

/// @nodoc
class __$$NutritionistCertificationImplCopyWithImpl<$Res>
    extends _$NutritionistCertificationCopyWithImpl<$Res,
        _$NutritionistCertificationImpl>
    implements _$$NutritionistCertificationImplCopyWith<$Res> {
  __$$NutritionistCertificationImplCopyWithImpl(
      _$NutritionistCertificationImpl _value,
      $Res Function(_$NutritionistCertificationImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionistCertification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nutritionistId = null,
    Object? status = null,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
    Object? reviewNotes = freezed,
  }) {
    return _then(_$NutritionistCertificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistId: null == nutritionistId
          ? _value.nutritionistId
          : nutritionistId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionistCertificationImpl implements _NutritionistCertification {
  const _$NutritionistCertificationImpl(
      {required this.id,
      required this.nutritionistId,
      required this.status,
      this.reviewedBy,
      this.reviewedAt,
      this.reviewNotes});

  factory _$NutritionistCertificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionistCertificationImplFromJson(json);

  @override
  final String id;
  @override
  final String nutritionistId;
  @override
  final String status;
  @override
  final String? reviewedBy;
  @override
  final DateTime? reviewedAt;
  @override
  final String? reviewNotes;

  @override
  String toString() {
    return 'NutritionistCertification(id: $id, nutritionistId: $nutritionistId, status: $status, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, reviewNotes: $reviewNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionistCertificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nutritionistId, nutritionistId) ||
                other.nutritionistId == nutritionistId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reviewedBy, reviewedBy) ||
                other.reviewedBy == reviewedBy) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.reviewNotes, reviewNotes) ||
                other.reviewNotes == reviewNotes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nutritionistId, status,
      reviewedBy, reviewedAt, reviewNotes);

  /// Create a copy of NutritionistCertification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionistCertificationImplCopyWith<_$NutritionistCertificationImpl>
      get copyWith => __$$NutritionistCertificationImplCopyWithImpl<
          _$NutritionistCertificationImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistCertification value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistCertification value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistCertification value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionistCertificationImplToJson(
      this,
    );
  }
}

abstract class _NutritionistCertification implements NutritionistCertification {
  const factory _NutritionistCertification(
      {required final String id,
      required final String nutritionistId,
      required final String status,
      final String? reviewedBy,
      final DateTime? reviewedAt,
      final String? reviewNotes}) = _$NutritionistCertificationImpl;

  factory _NutritionistCertification.fromJson(Map<String, dynamic> json) =
      _$NutritionistCertificationImpl.fromJson;

  @override
  String get id;
  @override
  String get nutritionistId;
  @override
  String get status;
  @override
  String? get reviewedBy;
  @override
  DateTime? get reviewedAt;
  @override
  String? get reviewNotes;

  /// Create a copy of NutritionistCertification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionistCertificationImplCopyWith<_$NutritionistCertificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NutritionistDetailStats _$NutritionistDetailStatsFromJson(
    Map<String, dynamic> json) {
  return _NutritionistDetailStats.fromJson(json);
}

/// @nodoc
mixin _$NutritionistDetailStats {
  int get totalConsultations => throw _privateConstructorUsedError;
  int get completedConsultations => throw _privateConstructorUsedError;
  int get cancelledConsultations => throw _privateConstructorUsedError;
  double get avgRating => throw _privateConstructorUsedError;
  int get totalRatings => throw _privateConstructorUsedError;
  double get totalIncome => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistDetailStats value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistDetailStats value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistDetailStats value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionistDetailStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionistDetailStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionistDetailStatsCopyWith<NutritionistDetailStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionistDetailStatsCopyWith<$Res> {
  factory $NutritionistDetailStatsCopyWith(NutritionistDetailStats value,
          $Res Function(NutritionistDetailStats) then) =
      _$NutritionistDetailStatsCopyWithImpl<$Res, NutritionistDetailStats>;
  @useResult
  $Res call(
      {int totalConsultations,
      int completedConsultations,
      int cancelledConsultations,
      double avgRating,
      int totalRatings,
      double totalIncome});
}

/// @nodoc
class _$NutritionistDetailStatsCopyWithImpl<$Res,
        $Val extends NutritionistDetailStats>
    implements $NutritionistDetailStatsCopyWith<$Res> {
  _$NutritionistDetailStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionistDetailStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalConsultations = null,
    Object? completedConsultations = null,
    Object? cancelledConsultations = null,
    Object? avgRating = null,
    Object? totalRatings = null,
    Object? totalIncome = null,
  }) {
    return _then(_value.copyWith(
      totalConsultations: null == totalConsultations
          ? _value.totalConsultations
          : totalConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      completedConsultations: null == completedConsultations
          ? _value.completedConsultations
          : completedConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      cancelledConsultations: null == cancelledConsultations
          ? _value.cancelledConsultations
          : cancelledConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      avgRating: null == avgRating
          ? _value.avgRating
          : avgRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalRatings: null == totalRatings
          ? _value.totalRatings
          : totalRatings // ignore: cast_nullable_to_non_nullable
              as int,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionistDetailStatsImplCopyWith<$Res>
    implements $NutritionistDetailStatsCopyWith<$Res> {
  factory _$$NutritionistDetailStatsImplCopyWith(
          _$NutritionistDetailStatsImpl value,
          $Res Function(_$NutritionistDetailStatsImpl) then) =
      __$$NutritionistDetailStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalConsultations,
      int completedConsultations,
      int cancelledConsultations,
      double avgRating,
      int totalRatings,
      double totalIncome});
}

/// @nodoc
class __$$NutritionistDetailStatsImplCopyWithImpl<$Res>
    extends _$NutritionistDetailStatsCopyWithImpl<$Res,
        _$NutritionistDetailStatsImpl>
    implements _$$NutritionistDetailStatsImplCopyWith<$Res> {
  __$$NutritionistDetailStatsImplCopyWithImpl(
      _$NutritionistDetailStatsImpl _value,
      $Res Function(_$NutritionistDetailStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionistDetailStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalConsultations = null,
    Object? completedConsultations = null,
    Object? cancelledConsultations = null,
    Object? avgRating = null,
    Object? totalRatings = null,
    Object? totalIncome = null,
  }) {
    return _then(_$NutritionistDetailStatsImpl(
      totalConsultations: null == totalConsultations
          ? _value.totalConsultations
          : totalConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      completedConsultations: null == completedConsultations
          ? _value.completedConsultations
          : completedConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      cancelledConsultations: null == cancelledConsultations
          ? _value.cancelledConsultations
          : cancelledConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      avgRating: null == avgRating
          ? _value.avgRating
          : avgRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalRatings: null == totalRatings
          ? _value.totalRatings
          : totalRatings // ignore: cast_nullable_to_non_nullable
              as int,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionistDetailStatsImpl implements _NutritionistDetailStats {
  const _$NutritionistDetailStatsImpl(
      {this.totalConsultations = 0,
      this.completedConsultations = 0,
      this.cancelledConsultations = 0,
      this.avgRating = 0.0,
      this.totalRatings = 0,
      this.totalIncome = 0.0});

  factory _$NutritionistDetailStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionistDetailStatsImplFromJson(json);

  @override
  @JsonKey()
  final int totalConsultations;
  @override
  @JsonKey()
  final int completedConsultations;
  @override
  @JsonKey()
  final int cancelledConsultations;
  @override
  @JsonKey()
  final double avgRating;
  @override
  @JsonKey()
  final int totalRatings;
  @override
  @JsonKey()
  final double totalIncome;

  @override
  String toString() {
    return 'NutritionistDetailStats(totalConsultations: $totalConsultations, completedConsultations: $completedConsultations, cancelledConsultations: $cancelledConsultations, avgRating: $avgRating, totalRatings: $totalRatings, totalIncome: $totalIncome)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionistDetailStatsImpl &&
            (identical(other.totalConsultations, totalConsultations) ||
                other.totalConsultations == totalConsultations) &&
            (identical(other.completedConsultations, completedConsultations) ||
                other.completedConsultations == completedConsultations) &&
            (identical(other.cancelledConsultations, cancelledConsultations) ||
                other.cancelledConsultations == cancelledConsultations) &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.totalRatings, totalRatings) ||
                other.totalRatings == totalRatings) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalConsultations,
      completedConsultations,
      cancelledConsultations,
      avgRating,
      totalRatings,
      totalIncome);

  /// Create a copy of NutritionistDetailStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionistDetailStatsImplCopyWith<_$NutritionistDetailStatsImpl>
      get copyWith => __$$NutritionistDetailStatsImplCopyWithImpl<
          _$NutritionistDetailStatsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistDetailStats value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistDetailStats value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistDetailStats value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionistDetailStatsImplToJson(
      this,
    );
  }
}

abstract class _NutritionistDetailStats implements NutritionistDetailStats {
  const factory _NutritionistDetailStats(
      {final int totalConsultations,
      final int completedConsultations,
      final int cancelledConsultations,
      final double avgRating,
      final int totalRatings,
      final double totalIncome}) = _$NutritionistDetailStatsImpl;

  factory _NutritionistDetailStats.fromJson(Map<String, dynamic> json) =
      _$NutritionistDetailStatsImpl.fromJson;

  @override
  int get totalConsultations;
  @override
  int get completedConsultations;
  @override
  int get cancelledConsultations;
  @override
  double get avgRating;
  @override
  int get totalRatings;
  @override
  double get totalIncome;

  /// Create a copy of NutritionistDetailStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionistDetailStatsImplCopyWith<_$NutritionistDetailStatsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RecentConsultation _$RecentConsultationFromJson(Map<String, dynamic> json) {
  return _RecentConsultation.fromJson(json);
}

/// @nodoc
mixin _$RecentConsultation {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;
  String? get userPhone => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RecentConsultation value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RecentConsultation value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RecentConsultation value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this RecentConsultation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecentConsultation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentConsultationCopyWith<RecentConsultation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentConsultationCopyWith<$Res> {
  factory $RecentConsultationCopyWith(
          RecentConsultation value, $Res Function(RecentConsultation) then) =
      _$RecentConsultationCopyWithImpl<$Res, RecentConsultation>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? userName,
      String? userAvatar,
      String? userPhone,
      String status,
      DateTime createdAt,
      double? amount,
      double? rating});
}

/// @nodoc
class _$RecentConsultationCopyWithImpl<$Res, $Val extends RecentConsultation>
    implements $RecentConsultationCopyWith<$Res> {
  _$RecentConsultationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentConsultation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = freezed,
    Object? userAvatar = freezed,
    Object? userPhone = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? amount = freezed,
    Object? rating = freezed,
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
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      userPhone: freezed == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentConsultationImplCopyWith<$Res>
    implements $RecentConsultationCopyWith<$Res> {
  factory _$$RecentConsultationImplCopyWith(_$RecentConsultationImpl value,
          $Res Function(_$RecentConsultationImpl) then) =
      __$$RecentConsultationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? userName,
      String? userAvatar,
      String? userPhone,
      String status,
      DateTime createdAt,
      double? amount,
      double? rating});
}

/// @nodoc
class __$$RecentConsultationImplCopyWithImpl<$Res>
    extends _$RecentConsultationCopyWithImpl<$Res, _$RecentConsultationImpl>
    implements _$$RecentConsultationImplCopyWith<$Res> {
  __$$RecentConsultationImplCopyWithImpl(_$RecentConsultationImpl _value,
      $Res Function(_$RecentConsultationImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecentConsultation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = freezed,
    Object? userAvatar = freezed,
    Object? userPhone = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? amount = freezed,
    Object? rating = freezed,
  }) {
    return _then(_$RecentConsultationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      userPhone: freezed == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentConsultationImpl implements _RecentConsultation {
  const _$RecentConsultationImpl(
      {required this.id,
      required this.userId,
      this.userName,
      this.userAvatar,
      this.userPhone,
      required this.status,
      required this.createdAt,
      this.amount,
      this.rating});

  factory _$RecentConsultationImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentConsultationImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? userName;
  @override
  final String? userAvatar;
  @override
  final String? userPhone;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final double? amount;
  @override
  final double? rating;

  @override
  String toString() {
    return 'RecentConsultation(id: $id, userId: $userId, userName: $userName, userAvatar: $userAvatar, userPhone: $userPhone, status: $status, createdAt: $createdAt, amount: $amount, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentConsultationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.userPhone, userPhone) ||
                other.userPhone == userPhone) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.rating, rating) || other.rating == rating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, userName, userAvatar,
      userPhone, status, createdAt, amount, rating);

  /// Create a copy of RecentConsultation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentConsultationImplCopyWith<_$RecentConsultationImpl> get copyWith =>
      __$$RecentConsultationImplCopyWithImpl<_$RecentConsultationImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RecentConsultation value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RecentConsultation value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RecentConsultation value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentConsultationImplToJson(
      this,
    );
  }
}

abstract class _RecentConsultation implements RecentConsultation {
  const factory _RecentConsultation(
      {required final String id,
      required final String userId,
      final String? userName,
      final String? userAvatar,
      final String? userPhone,
      required final String status,
      required final DateTime createdAt,
      final double? amount,
      final double? rating}) = _$RecentConsultationImpl;

  factory _RecentConsultation.fromJson(Map<String, dynamic> json) =
      _$RecentConsultationImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get userName;
  @override
  String? get userAvatar;
  @override
  String? get userPhone;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  double? get amount;
  @override
  double? get rating;

  /// Create a copy of RecentConsultation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentConsultationImplCopyWith<_$RecentConsultationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MonthlyTrend _$MonthlyTrendFromJson(Map<String, dynamic> json) {
  return _MonthlyTrend.fromJson(json);
}

/// @nodoc
mixin _$MonthlyTrend {
  TrendId get id => throw _privateConstructorUsedError;
  int get consultations => throw _privateConstructorUsedError;
  double get income => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MonthlyTrend value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MonthlyTrend value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MonthlyTrend value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MonthlyTrend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyTrendCopyWith<MonthlyTrend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyTrendCopyWith<$Res> {
  factory $MonthlyTrendCopyWith(
          MonthlyTrend value, $Res Function(MonthlyTrend) then) =
      _$MonthlyTrendCopyWithImpl<$Res, MonthlyTrend>;
  @useResult
  $Res call({TrendId id, int consultations, double income});

  $TrendIdCopyWith<$Res> get id;
}

/// @nodoc
class _$MonthlyTrendCopyWithImpl<$Res, $Val extends MonthlyTrend>
    implements $MonthlyTrendCopyWith<$Res> {
  _$MonthlyTrendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? consultations = null,
    Object? income = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as TrendId,
      consultations: null == consultations
          ? _value.consultations
          : consultations // ignore: cast_nullable_to_non_nullable
              as int,
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of MonthlyTrend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrendIdCopyWith<$Res> get id {
    return $TrendIdCopyWith<$Res>(_value.id, (value) {
      return _then(_value.copyWith(id: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MonthlyTrendImplCopyWith<$Res>
    implements $MonthlyTrendCopyWith<$Res> {
  factory _$$MonthlyTrendImplCopyWith(
          _$MonthlyTrendImpl value, $Res Function(_$MonthlyTrendImpl) then) =
      __$$MonthlyTrendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TrendId id, int consultations, double income});

  @override
  $TrendIdCopyWith<$Res> get id;
}

/// @nodoc
class __$$MonthlyTrendImplCopyWithImpl<$Res>
    extends _$MonthlyTrendCopyWithImpl<$Res, _$MonthlyTrendImpl>
    implements _$$MonthlyTrendImplCopyWith<$Res> {
  __$$MonthlyTrendImplCopyWithImpl(
      _$MonthlyTrendImpl _value, $Res Function(_$MonthlyTrendImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? consultations = null,
    Object? income = null,
  }) {
    return _then(_$MonthlyTrendImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as TrendId,
      consultations: null == consultations
          ? _value.consultations
          : consultations // ignore: cast_nullable_to_non_nullable
              as int,
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyTrendImpl implements _MonthlyTrend {
  const _$MonthlyTrendImpl(
      {required this.id, this.consultations = 0, this.income = 0.0});

  factory _$MonthlyTrendImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyTrendImplFromJson(json);

  @override
  final TrendId id;
  @override
  @JsonKey()
  final int consultations;
  @override
  @JsonKey()
  final double income;

  @override
  String toString() {
    return 'MonthlyTrend(id: $id, consultations: $consultations, income: $income)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyTrendImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.consultations, consultations) ||
                other.consultations == consultations) &&
            (identical(other.income, income) || other.income == income));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, consultations, income);

  /// Create a copy of MonthlyTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyTrendImplCopyWith<_$MonthlyTrendImpl> get copyWith =>
      __$$MonthlyTrendImplCopyWithImpl<_$MonthlyTrendImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MonthlyTrend value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MonthlyTrend value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MonthlyTrend value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyTrendImplToJson(
      this,
    );
  }
}

abstract class _MonthlyTrend implements MonthlyTrend {
  const factory _MonthlyTrend(
      {required final TrendId id,
      final int consultations,
      final double income}) = _$MonthlyTrendImpl;

  factory _MonthlyTrend.fromJson(Map<String, dynamic> json) =
      _$MonthlyTrendImpl.fromJson;

  @override
  TrendId get id;
  @override
  int get consultations;
  @override
  double get income;

  /// Create a copy of MonthlyTrend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyTrendImplCopyWith<_$MonthlyTrendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BatchOperationResult _$BatchOperationResultFromJson(Map<String, dynamic> json) {
  return _BatchOperationResult.fromJson(json);
}

/// @nodoc
mixin _$BatchOperationResult {
  String get message => throw _privateConstructorUsedError;
  int get affected => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BatchOperationResult value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BatchOperationResult value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BatchOperationResult value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this BatchOperationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BatchOperationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BatchOperationResultCopyWith<BatchOperationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchOperationResultCopyWith<$Res> {
  factory $BatchOperationResultCopyWith(BatchOperationResult value,
          $Res Function(BatchOperationResult) then) =
      _$BatchOperationResultCopyWithImpl<$Res, BatchOperationResult>;
  @useResult
  $Res call({String message, int affected, int total});
}

/// @nodoc
class _$BatchOperationResultCopyWithImpl<$Res,
        $Val extends BatchOperationResult>
    implements $BatchOperationResultCopyWith<$Res> {
  _$BatchOperationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BatchOperationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? affected = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      affected: null == affected
          ? _value.affected
          : affected // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchOperationResultImplCopyWith<$Res>
    implements $BatchOperationResultCopyWith<$Res> {
  factory _$$BatchOperationResultImplCopyWith(_$BatchOperationResultImpl value,
          $Res Function(_$BatchOperationResultImpl) then) =
      __$$BatchOperationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int affected, int total});
}

/// @nodoc
class __$$BatchOperationResultImplCopyWithImpl<$Res>
    extends _$BatchOperationResultCopyWithImpl<$Res, _$BatchOperationResultImpl>
    implements _$$BatchOperationResultImplCopyWith<$Res> {
  __$$BatchOperationResultImplCopyWithImpl(_$BatchOperationResultImpl _value,
      $Res Function(_$BatchOperationResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of BatchOperationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? affected = null,
    Object? total = null,
  }) {
    return _then(_$BatchOperationResultImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      affected: null == affected
          ? _value.affected
          : affected // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BatchOperationResultImpl implements _BatchOperationResult {
  const _$BatchOperationResultImpl(
      {required this.message, required this.affected, required this.total});

  factory _$BatchOperationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$BatchOperationResultImplFromJson(json);

  @override
  final String message;
  @override
  final int affected;
  @override
  final int total;

  @override
  String toString() {
    return 'BatchOperationResult(message: $message, affected: $affected, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchOperationResultImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.affected, affected) ||
                other.affected == affected) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, affected, total);

  /// Create a copy of BatchOperationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchOperationResultImplCopyWith<_$BatchOperationResultImpl>
      get copyWith =>
          __$$BatchOperationResultImplCopyWithImpl<_$BatchOperationResultImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BatchOperationResult value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BatchOperationResult value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BatchOperationResult value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchOperationResultImplToJson(
      this,
    );
  }
}

abstract class _BatchOperationResult implements BatchOperationResult {
  const factory _BatchOperationResult(
      {required final String message,
      required final int affected,
      required final int total}) = _$BatchOperationResultImpl;

  factory _BatchOperationResult.fromJson(Map<String, dynamic> json) =
      _$BatchOperationResultImpl.fromJson;

  @override
  String get message;
  @override
  int get affected;
  @override
  int get total;

  /// Create a copy of BatchOperationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BatchOperationResultImplCopyWith<_$BatchOperationResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}
