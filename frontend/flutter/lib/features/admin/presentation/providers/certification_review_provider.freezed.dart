// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'certification_review_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CertificationFilterParams {
  String get status => throw _privateConstructorUsedError;
  String? get certificationLevel => throw _privateConstructorUsedError;
  String? get specialization => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CertificationFilterParams value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CertificationFilterParams value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CertificationFilterParams value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of CertificationFilterParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CertificationFilterParamsCopyWith<CertificationFilterParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CertificationFilterParamsCopyWith<$Res> {
  factory $CertificationFilterParamsCopyWith(CertificationFilterParams value,
          $Res Function(CertificationFilterParams) then) =
      _$CertificationFilterParamsCopyWithImpl<$Res, CertificationFilterParams>;
  @useResult
  $Res call(
      {String status,
      String? certificationLevel,
      String? specialization,
      String? searchQuery,
      int page,
      int limit});
}

/// @nodoc
class _$CertificationFilterParamsCopyWithImpl<$Res,
        $Val extends CertificationFilterParams>
    implements $CertificationFilterParamsCopyWith<$Res> {
  _$CertificationFilterParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CertificationFilterParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? certificationLevel = freezed,
    Object? specialization = freezed,
    Object? searchQuery = freezed,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      certificationLevel: freezed == certificationLevel
          ? _value.certificationLevel
          : certificationLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      specialization: freezed == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CertificationFilterParamsImplCopyWith<$Res>
    implements $CertificationFilterParamsCopyWith<$Res> {
  factory _$$CertificationFilterParamsImplCopyWith(
          _$CertificationFilterParamsImpl value,
          $Res Function(_$CertificationFilterParamsImpl) then) =
      __$$CertificationFilterParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      String? certificationLevel,
      String? specialization,
      String? searchQuery,
      int page,
      int limit});
}

/// @nodoc
class __$$CertificationFilterParamsImplCopyWithImpl<$Res>
    extends _$CertificationFilterParamsCopyWithImpl<$Res,
        _$CertificationFilterParamsImpl>
    implements _$$CertificationFilterParamsImplCopyWith<$Res> {
  __$$CertificationFilterParamsImplCopyWithImpl(
      _$CertificationFilterParamsImpl _value,
      $Res Function(_$CertificationFilterParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CertificationFilterParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? certificationLevel = freezed,
    Object? specialization = freezed,
    Object? searchQuery = freezed,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(_$CertificationFilterParamsImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      certificationLevel: freezed == certificationLevel
          ? _value.certificationLevel
          : certificationLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      specialization: freezed == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$CertificationFilterParamsImpl implements _CertificationFilterParams {
  const _$CertificationFilterParamsImpl(
      {this.status = 'pending',
      this.certificationLevel,
      this.specialization,
      this.searchQuery,
      this.page = 1,
      this.limit = 20});

  @override
  @JsonKey()
  final String status;
  @override
  final String? certificationLevel;
  @override
  final String? specialization;
  @override
  final String? searchQuery;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int limit;

  @override
  String toString() {
    return 'CertificationFilterParams(status: $status, certificationLevel: $certificationLevel, specialization: $specialization, searchQuery: $searchQuery, page: $page, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CertificationFilterParamsImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.certificationLevel, certificationLevel) ||
                other.certificationLevel == certificationLevel) &&
            (identical(other.specialization, specialization) ||
                other.specialization == specialization) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, certificationLevel,
      specialization, searchQuery, page, limit);

  /// Create a copy of CertificationFilterParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CertificationFilterParamsImplCopyWith<_$CertificationFilterParamsImpl>
      get copyWith => __$$CertificationFilterParamsImplCopyWithImpl<
          _$CertificationFilterParamsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CertificationFilterParams value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CertificationFilterParams value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CertificationFilterParams value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _CertificationFilterParams implements CertificationFilterParams {
  const factory _CertificationFilterParams(
      {final String status,
      final String? certificationLevel,
      final String? specialization,
      final String? searchQuery,
      final int page,
      final int limit}) = _$CertificationFilterParamsImpl;

  @override
  String get status;
  @override
  String? get certificationLevel;
  @override
  String? get specialization;
  @override
  String? get searchQuery;
  @override
  int get page;
  @override
  int get limit;

  /// Create a copy of CertificationFilterParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CertificationFilterParamsImplCopyWith<_$CertificationFilterParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CertificationApplication _$CertificationApplicationFromJson(
    Map<String, dynamic> json) {
  return _CertificationApplication.fromJson(json);
}

/// @nodoc
mixin _$CertificationApplication {
  String get id => throw _privateConstructorUsedError;
  String get nutritionistId => throw _privateConstructorUsedError;
  String get nutritionistName => throw _privateConstructorUsedError;
  String? get nutritionistAvatar => throw _privateConstructorUsedError;
  String get certificationLevel => throw _privateConstructorUsedError;
  List<String> get specializations => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get submittedAt => throw _privateConstructorUsedError;
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  String? get reviewerId => throw _privateConstructorUsedError;
  String? get reviewerName => throw _privateConstructorUsedError;
  String? get reviewNotes => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  Map<String, dynamic>? get documents => throw _privateConstructorUsedError;
  Map<String, dynamic>? get educationInfo => throw _privateConstructorUsedError;
  Map<String, dynamic>? get experienceInfo =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CertificationApplication value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CertificationApplication value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CertificationApplication value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this CertificationApplication to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CertificationApplication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CertificationApplicationCopyWith<CertificationApplication> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CertificationApplicationCopyWith<$Res> {
  factory $CertificationApplicationCopyWith(CertificationApplication value,
          $Res Function(CertificationApplication) then) =
      _$CertificationApplicationCopyWithImpl<$Res, CertificationApplication>;
  @useResult
  $Res call(
      {String id,
      String nutritionistId,
      String nutritionistName,
      String? nutritionistAvatar,
      String certificationLevel,
      List<String> specializations,
      String status,
      DateTime submittedAt,
      DateTime? reviewedAt,
      String? reviewerId,
      String? reviewerName,
      String? reviewNotes,
      String priority,
      Map<String, dynamic>? documents,
      Map<String, dynamic>? educationInfo,
      Map<String, dynamic>? experienceInfo});
}

/// @nodoc
class _$CertificationApplicationCopyWithImpl<$Res,
        $Val extends CertificationApplication>
    implements $CertificationApplicationCopyWith<$Res> {
  _$CertificationApplicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CertificationApplication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nutritionistId = null,
    Object? nutritionistName = null,
    Object? nutritionistAvatar = freezed,
    Object? certificationLevel = null,
    Object? specializations = null,
    Object? status = null,
    Object? submittedAt = null,
    Object? reviewedAt = freezed,
    Object? reviewerId = freezed,
    Object? reviewerName = freezed,
    Object? reviewNotes = freezed,
    Object? priority = null,
    Object? documents = freezed,
    Object? educationInfo = freezed,
    Object? experienceInfo = freezed,
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
      nutritionistName: null == nutritionistName
          ? _value.nutritionistName
          : nutritionistName // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistAvatar: freezed == nutritionistAvatar
          ? _value.nutritionistAvatar
          : nutritionistAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      certificationLevel: null == certificationLevel
          ? _value.certificationLevel
          : certificationLevel // ignore: cast_nullable_to_non_nullable
              as String,
      specializations: null == specializations
          ? _value.specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      submittedAt: null == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewerId: freezed == reviewerId
          ? _value.reviewerId
          : reviewerId // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewerName: freezed == reviewerName
          ? _value.reviewerName
          : reviewerName // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewNotes: freezed == reviewNotes
          ? _value.reviewNotes
          : reviewNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      documents: freezed == documents
          ? _value.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      educationInfo: freezed == educationInfo
          ? _value.educationInfo
          : educationInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      experienceInfo: freezed == experienceInfo
          ? _value.experienceInfo
          : experienceInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CertificationApplicationImplCopyWith<$Res>
    implements $CertificationApplicationCopyWith<$Res> {
  factory _$$CertificationApplicationImplCopyWith(
          _$CertificationApplicationImpl value,
          $Res Function(_$CertificationApplicationImpl) then) =
      __$$CertificationApplicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nutritionistId,
      String nutritionistName,
      String? nutritionistAvatar,
      String certificationLevel,
      List<String> specializations,
      String status,
      DateTime submittedAt,
      DateTime? reviewedAt,
      String? reviewerId,
      String? reviewerName,
      String? reviewNotes,
      String priority,
      Map<String, dynamic>? documents,
      Map<String, dynamic>? educationInfo,
      Map<String, dynamic>? experienceInfo});
}

/// @nodoc
class __$$CertificationApplicationImplCopyWithImpl<$Res>
    extends _$CertificationApplicationCopyWithImpl<$Res,
        _$CertificationApplicationImpl>
    implements _$$CertificationApplicationImplCopyWith<$Res> {
  __$$CertificationApplicationImplCopyWithImpl(
      _$CertificationApplicationImpl _value,
      $Res Function(_$CertificationApplicationImpl) _then)
      : super(_value, _then);

  /// Create a copy of CertificationApplication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nutritionistId = null,
    Object? nutritionistName = null,
    Object? nutritionistAvatar = freezed,
    Object? certificationLevel = null,
    Object? specializations = null,
    Object? status = null,
    Object? submittedAt = null,
    Object? reviewedAt = freezed,
    Object? reviewerId = freezed,
    Object? reviewerName = freezed,
    Object? reviewNotes = freezed,
    Object? priority = null,
    Object? documents = freezed,
    Object? educationInfo = freezed,
    Object? experienceInfo = freezed,
  }) {
    return _then(_$CertificationApplicationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistId: null == nutritionistId
          ? _value.nutritionistId
          : nutritionistId // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistName: null == nutritionistName
          ? _value.nutritionistName
          : nutritionistName // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistAvatar: freezed == nutritionistAvatar
          ? _value.nutritionistAvatar
          : nutritionistAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      certificationLevel: null == certificationLevel
          ? _value.certificationLevel
          : certificationLevel // ignore: cast_nullable_to_non_nullable
              as String,
      specializations: null == specializations
          ? _value._specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      submittedAt: null == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewerId: freezed == reviewerId
          ? _value.reviewerId
          : reviewerId // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewerName: freezed == reviewerName
          ? _value.reviewerName
          : reviewerName // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewNotes: freezed == reviewNotes
          ? _value.reviewNotes
          : reviewNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      documents: freezed == documents
          ? _value._documents
          : documents // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      educationInfo: freezed == educationInfo
          ? _value._educationInfo
          : educationInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      experienceInfo: freezed == experienceInfo
          ? _value._experienceInfo
          : experienceInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CertificationApplicationImpl implements _CertificationApplication {
  const _$CertificationApplicationImpl(
      {required this.id,
      required this.nutritionistId,
      required this.nutritionistName,
      this.nutritionistAvatar,
      required this.certificationLevel,
      required final List<String> specializations,
      required this.status,
      required this.submittedAt,
      this.reviewedAt,
      this.reviewerId,
      this.reviewerName,
      this.reviewNotes,
      this.priority = 'normal',
      final Map<String, dynamic>? documents,
      final Map<String, dynamic>? educationInfo,
      final Map<String, dynamic>? experienceInfo})
      : _specializations = specializations,
        _documents = documents,
        _educationInfo = educationInfo,
        _experienceInfo = experienceInfo;

  factory _$CertificationApplicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CertificationApplicationImplFromJson(json);

  @override
  final String id;
  @override
  final String nutritionistId;
  @override
  final String nutritionistName;
  @override
  final String? nutritionistAvatar;
  @override
  final String certificationLevel;
  final List<String> _specializations;
  @override
  List<String> get specializations {
    if (_specializations is EqualUnmodifiableListView) return _specializations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specializations);
  }

  @override
  final String status;
  @override
  final DateTime submittedAt;
  @override
  final DateTime? reviewedAt;
  @override
  final String? reviewerId;
  @override
  final String? reviewerName;
  @override
  final String? reviewNotes;
  @override
  @JsonKey()
  final String priority;
  final Map<String, dynamic>? _documents;
  @override
  Map<String, dynamic>? get documents {
    final value = _documents;
    if (value == null) return null;
    if (_documents is EqualUnmodifiableMapView) return _documents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _educationInfo;
  @override
  Map<String, dynamic>? get educationInfo {
    final value = _educationInfo;
    if (value == null) return null;
    if (_educationInfo is EqualUnmodifiableMapView) return _educationInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _experienceInfo;
  @override
  Map<String, dynamic>? get experienceInfo {
    final value = _experienceInfo;
    if (value == null) return null;
    if (_experienceInfo is EqualUnmodifiableMapView) return _experienceInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CertificationApplication(id: $id, nutritionistId: $nutritionistId, nutritionistName: $nutritionistName, nutritionistAvatar: $nutritionistAvatar, certificationLevel: $certificationLevel, specializations: $specializations, status: $status, submittedAt: $submittedAt, reviewedAt: $reviewedAt, reviewerId: $reviewerId, reviewerName: $reviewerName, reviewNotes: $reviewNotes, priority: $priority, documents: $documents, educationInfo: $educationInfo, experienceInfo: $experienceInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CertificationApplicationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nutritionistId, nutritionistId) ||
                other.nutritionistId == nutritionistId) &&
            (identical(other.nutritionistName, nutritionistName) ||
                other.nutritionistName == nutritionistName) &&
            (identical(other.nutritionistAvatar, nutritionistAvatar) ||
                other.nutritionistAvatar == nutritionistAvatar) &&
            (identical(other.certificationLevel, certificationLevel) ||
                other.certificationLevel == certificationLevel) &&
            const DeepCollectionEquality()
                .equals(other._specializations, _specializations) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId) &&
            (identical(other.reviewerName, reviewerName) ||
                other.reviewerName == reviewerName) &&
            (identical(other.reviewNotes, reviewNotes) ||
                other.reviewNotes == reviewNotes) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            const DeepCollectionEquality()
                .equals(other._documents, _documents) &&
            const DeepCollectionEquality()
                .equals(other._educationInfo, _educationInfo) &&
            const DeepCollectionEquality()
                .equals(other._experienceInfo, _experienceInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nutritionistId,
      nutritionistName,
      nutritionistAvatar,
      certificationLevel,
      const DeepCollectionEquality().hash(_specializations),
      status,
      submittedAt,
      reviewedAt,
      reviewerId,
      reviewerName,
      reviewNotes,
      priority,
      const DeepCollectionEquality().hash(_documents),
      const DeepCollectionEquality().hash(_educationInfo),
      const DeepCollectionEquality().hash(_experienceInfo));

  /// Create a copy of CertificationApplication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CertificationApplicationImplCopyWith<_$CertificationApplicationImpl>
      get copyWith => __$$CertificationApplicationImplCopyWithImpl<
          _$CertificationApplicationImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CertificationApplication value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CertificationApplication value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CertificationApplication value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CertificationApplicationImplToJson(
      this,
    );
  }
}

abstract class _CertificationApplication implements CertificationApplication {
  const factory _CertificationApplication(
          {required final String id,
          required final String nutritionistId,
          required final String nutritionistName,
          final String? nutritionistAvatar,
          required final String certificationLevel,
          required final List<String> specializations,
          required final String status,
          required final DateTime submittedAt,
          final DateTime? reviewedAt,
          final String? reviewerId,
          final String? reviewerName,
          final String? reviewNotes,
          final String priority,
          final Map<String, dynamic>? documents,
          final Map<String, dynamic>? educationInfo,
          final Map<String, dynamic>? experienceInfo}) =
      _$CertificationApplicationImpl;

  factory _CertificationApplication.fromJson(Map<String, dynamic> json) =
      _$CertificationApplicationImpl.fromJson;

  @override
  String get id;
  @override
  String get nutritionistId;
  @override
  String get nutritionistName;
  @override
  String? get nutritionistAvatar;
  @override
  String get certificationLevel;
  @override
  List<String> get specializations;
  @override
  String get status;
  @override
  DateTime get submittedAt;
  @override
  DateTime? get reviewedAt;
  @override
  String? get reviewerId;
  @override
  String? get reviewerName;
  @override
  String? get reviewNotes;
  @override
  String get priority;
  @override
  Map<String, dynamic>? get documents;
  @override
  Map<String, dynamic>? get educationInfo;
  @override
  Map<String, dynamic>? get experienceInfo;

  /// Create a copy of CertificationApplication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CertificationApplicationImplCopyWith<_$CertificationApplicationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
