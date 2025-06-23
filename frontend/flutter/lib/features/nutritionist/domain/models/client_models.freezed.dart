// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NutritionistClient _$NutritionistClientFromJson(Map<String, dynamic> json) {
  return _NutritionistClient.fromJson(json);
}

/// @nodoc
mixin _$NutritionistClient {
  String get id => throw _privateConstructorUsedError;
  String get nutritionistId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  HealthOverview? get healthOverview => throw _privateConstructorUsedError;
  DateTime? get lastConsultation => throw _privateConstructorUsedError;
  int? get consultationCount => throw _privateConstructorUsedError;
  double? get totalSpent => throw _privateConstructorUsedError;
  List<Progress>? get progressHistory => throw _privateConstructorUsedError;
  List<Goal>? get goals => throw _privateConstructorUsedError;
  List<Reminder>? get reminders => throw _privateConstructorUsedError;
  List<String>? get nutritionPlanIds => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistClient value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistClient value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistClient value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionistClient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionistClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionistClientCopyWith<NutritionistClient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionistClientCopyWith<$Res> {
  factory $NutritionistClientCopyWith(
          NutritionistClient value, $Res Function(NutritionistClient) then) =
      _$NutritionistClientCopyWithImpl<$Res, NutritionistClient>;
  @useResult
  $Res call(
      {String id,
      String nutritionistId,
      String userId,
      String nickname,
      int? age,
      String? gender,
      HealthOverview? healthOverview,
      DateTime? lastConsultation,
      int? consultationCount,
      double? totalSpent,
      List<Progress>? progressHistory,
      List<Goal>? goals,
      List<Reminder>? reminders,
      List<String>? nutritionPlanIds,
      List<String>? tags,
      String? notes,
      bool? isActive,
      DateTime? createdAt,
      DateTime? updatedAt});

  $HealthOverviewCopyWith<$Res>? get healthOverview;
}

/// @nodoc
class _$NutritionistClientCopyWithImpl<$Res, $Val extends NutritionistClient>
    implements $NutritionistClientCopyWith<$Res> {
  _$NutritionistClientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionistClient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nutritionistId = null,
    Object? userId = null,
    Object? nickname = null,
    Object? age = freezed,
    Object? gender = freezed,
    Object? healthOverview = freezed,
    Object? lastConsultation = freezed,
    Object? consultationCount = freezed,
    Object? totalSpent = freezed,
    Object? progressHistory = freezed,
    Object? goals = freezed,
    Object? reminders = freezed,
    Object? nutritionPlanIds = freezed,
    Object? tags = freezed,
    Object? notes = freezed,
    Object? isActive = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      healthOverview: freezed == healthOverview
          ? _value.healthOverview
          : healthOverview // ignore: cast_nullable_to_non_nullable
              as HealthOverview?,
      lastConsultation: freezed == lastConsultation
          ? _value.lastConsultation
          : lastConsultation // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      consultationCount: freezed == consultationCount
          ? _value.consultationCount
          : consultationCount // ignore: cast_nullable_to_non_nullable
              as int?,
      totalSpent: freezed == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double?,
      progressHistory: freezed == progressHistory
          ? _value.progressHistory
          : progressHistory // ignore: cast_nullable_to_non_nullable
              as List<Progress>?,
      goals: freezed == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<Goal>?,
      reminders: freezed == reminders
          ? _value.reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as List<Reminder>?,
      nutritionPlanIds: freezed == nutritionPlanIds
          ? _value.nutritionPlanIds
          : nutritionPlanIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of NutritionistClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HealthOverviewCopyWith<$Res>? get healthOverview {
    if (_value.healthOverview == null) {
      return null;
    }

    return $HealthOverviewCopyWith<$Res>(_value.healthOverview!, (value) {
      return _then(_value.copyWith(healthOverview: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionistClientImplCopyWith<$Res>
    implements $NutritionistClientCopyWith<$Res> {
  factory _$$NutritionistClientImplCopyWith(_$NutritionistClientImpl value,
          $Res Function(_$NutritionistClientImpl) then) =
      __$$NutritionistClientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nutritionistId,
      String userId,
      String nickname,
      int? age,
      String? gender,
      HealthOverview? healthOverview,
      DateTime? lastConsultation,
      int? consultationCount,
      double? totalSpent,
      List<Progress>? progressHistory,
      List<Goal>? goals,
      List<Reminder>? reminders,
      List<String>? nutritionPlanIds,
      List<String>? tags,
      String? notes,
      bool? isActive,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $HealthOverviewCopyWith<$Res>? get healthOverview;
}

/// @nodoc
class __$$NutritionistClientImplCopyWithImpl<$Res>
    extends _$NutritionistClientCopyWithImpl<$Res, _$NutritionistClientImpl>
    implements _$$NutritionistClientImplCopyWith<$Res> {
  __$$NutritionistClientImplCopyWithImpl(_$NutritionistClientImpl _value,
      $Res Function(_$NutritionistClientImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionistClient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nutritionistId = null,
    Object? userId = null,
    Object? nickname = null,
    Object? age = freezed,
    Object? gender = freezed,
    Object? healthOverview = freezed,
    Object? lastConsultation = freezed,
    Object? consultationCount = freezed,
    Object? totalSpent = freezed,
    Object? progressHistory = freezed,
    Object? goals = freezed,
    Object? reminders = freezed,
    Object? nutritionPlanIds = freezed,
    Object? tags = freezed,
    Object? notes = freezed,
    Object? isActive = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$NutritionistClientImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistId: null == nutritionistId
          ? _value.nutritionistId
          : nutritionistId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      healthOverview: freezed == healthOverview
          ? _value.healthOverview
          : healthOverview // ignore: cast_nullable_to_non_nullable
              as HealthOverview?,
      lastConsultation: freezed == lastConsultation
          ? _value.lastConsultation
          : lastConsultation // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      consultationCount: freezed == consultationCount
          ? _value.consultationCount
          : consultationCount // ignore: cast_nullable_to_non_nullable
              as int?,
      totalSpent: freezed == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double?,
      progressHistory: freezed == progressHistory
          ? _value._progressHistory
          : progressHistory // ignore: cast_nullable_to_non_nullable
              as List<Progress>?,
      goals: freezed == goals
          ? _value._goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<Goal>?,
      reminders: freezed == reminders
          ? _value._reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as List<Reminder>?,
      nutritionPlanIds: freezed == nutritionPlanIds
          ? _value._nutritionPlanIds
          : nutritionPlanIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionistClientImpl implements _NutritionistClient {
  const _$NutritionistClientImpl(
      {required this.id,
      required this.nutritionistId,
      required this.userId,
      required this.nickname,
      this.age,
      this.gender,
      this.healthOverview,
      this.lastConsultation,
      this.consultationCount,
      this.totalSpent,
      final List<Progress>? progressHistory,
      final List<Goal>? goals,
      final List<Reminder>? reminders,
      final List<String>? nutritionPlanIds,
      final List<String>? tags,
      this.notes,
      this.isActive,
      this.createdAt,
      this.updatedAt})
      : _progressHistory = progressHistory,
        _goals = goals,
        _reminders = reminders,
        _nutritionPlanIds = nutritionPlanIds,
        _tags = tags;

  factory _$NutritionistClientImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionistClientImplFromJson(json);

  @override
  final String id;
  @override
  final String nutritionistId;
  @override
  final String userId;
  @override
  final String nickname;
  @override
  final int? age;
  @override
  final String? gender;
  @override
  final HealthOverview? healthOverview;
  @override
  final DateTime? lastConsultation;
  @override
  final int? consultationCount;
  @override
  final double? totalSpent;
  final List<Progress>? _progressHistory;
  @override
  List<Progress>? get progressHistory {
    final value = _progressHistory;
    if (value == null) return null;
    if (_progressHistory is EqualUnmodifiableListView) return _progressHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Goal>? _goals;
  @override
  List<Goal>? get goals {
    final value = _goals;
    if (value == null) return null;
    if (_goals is EqualUnmodifiableListView) return _goals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Reminder>? _reminders;
  @override
  List<Reminder>? get reminders {
    final value = _reminders;
    if (value == null) return null;
    if (_reminders is EqualUnmodifiableListView) return _reminders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _nutritionPlanIds;
  @override
  List<String>? get nutritionPlanIds {
    final value = _nutritionPlanIds;
    if (value == null) return null;
    if (_nutritionPlanIds is EqualUnmodifiableListView)
      return _nutritionPlanIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? notes;
  @override
  final bool? isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'NutritionistClient(id: $id, nutritionistId: $nutritionistId, userId: $userId, nickname: $nickname, age: $age, gender: $gender, healthOverview: $healthOverview, lastConsultation: $lastConsultation, consultationCount: $consultationCount, totalSpent: $totalSpent, progressHistory: $progressHistory, goals: $goals, reminders: $reminders, nutritionPlanIds: $nutritionPlanIds, tags: $tags, notes: $notes, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionistClientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nutritionistId, nutritionistId) ||
                other.nutritionistId == nutritionistId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.healthOverview, healthOverview) ||
                other.healthOverview == healthOverview) &&
            (identical(other.lastConsultation, lastConsultation) ||
                other.lastConsultation == lastConsultation) &&
            (identical(other.consultationCount, consultationCount) ||
                other.consultationCount == consultationCount) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            const DeepCollectionEquality()
                .equals(other._progressHistory, _progressHistory) &&
            const DeepCollectionEquality().equals(other._goals, _goals) &&
            const DeepCollectionEquality()
                .equals(other._reminders, _reminders) &&
            const DeepCollectionEquality()
                .equals(other._nutritionPlanIds, _nutritionPlanIds) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
        nutritionistId,
        userId,
        nickname,
        age,
        gender,
        healthOverview,
        lastConsultation,
        consultationCount,
        totalSpent,
        const DeepCollectionEquality().hash(_progressHistory),
        const DeepCollectionEquality().hash(_goals),
        const DeepCollectionEquality().hash(_reminders),
        const DeepCollectionEquality().hash(_nutritionPlanIds),
        const DeepCollectionEquality().hash(_tags),
        notes,
        isActive,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of NutritionistClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionistClientImplCopyWith<_$NutritionistClientImpl> get copyWith =>
      __$$NutritionistClientImplCopyWithImpl<_$NutritionistClientImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionistClient value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionistClient value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionistClient value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionistClientImplToJson(
      this,
    );
  }
}

abstract class _NutritionistClient implements NutritionistClient {
  const factory _NutritionistClient(
      {required final String id,
      required final String nutritionistId,
      required final String userId,
      required final String nickname,
      final int? age,
      final String? gender,
      final HealthOverview? healthOverview,
      final DateTime? lastConsultation,
      final int? consultationCount,
      final double? totalSpent,
      final List<Progress>? progressHistory,
      final List<Goal>? goals,
      final List<Reminder>? reminders,
      final List<String>? nutritionPlanIds,
      final List<String>? tags,
      final String? notes,
      final bool? isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$NutritionistClientImpl;

  factory _NutritionistClient.fromJson(Map<String, dynamic> json) =
      _$NutritionistClientImpl.fromJson;

  @override
  String get id;
  @override
  String get nutritionistId;
  @override
  String get userId;
  @override
  String get nickname;
  @override
  int? get age;
  @override
  String? get gender;
  @override
  HealthOverview? get healthOverview;
  @override
  DateTime? get lastConsultation;
  @override
  int? get consultationCount;
  @override
  double? get totalSpent;
  @override
  List<Progress>? get progressHistory;
  @override
  List<Goal>? get goals;
  @override
  List<Reminder>? get reminders;
  @override
  List<String>? get nutritionPlanIds;
  @override
  List<String>? get tags;
  @override
  String? get notes;
  @override
  bool? get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of NutritionistClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionistClientImplCopyWith<_$NutritionistClientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HealthOverview _$HealthOverviewFromJson(Map<String, dynamic> json) {
  return _HealthOverview.fromJson(json);
}

/// @nodoc
mixin _$HealthOverview {
  double? get currentWeight => throw _privateConstructorUsedError;
  double? get targetWeight => throw _privateConstructorUsedError;
  double? get height => throw _privateConstructorUsedError;
  double? get currentBMI => throw _privateConstructorUsedError;
  double? get targetBMI => throw _privateConstructorUsedError;
  double? get bodyFatPercentage => throw _privateConstructorUsedError;
  double? get muscleMass => throw _privateConstructorUsedError;
  List<String>? get medicalConditions => throw _privateConstructorUsedError;
  List<String>? get medications => throw _privateConstructorUsedError;
  List<String>? get allergies => throw _privateConstructorUsedError;
  List<String>? get dietaryRestrictions => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HealthOverview value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HealthOverview value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HealthOverview value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this HealthOverview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthOverviewCopyWith<HealthOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthOverviewCopyWith<$Res> {
  factory $HealthOverviewCopyWith(
          HealthOverview value, $Res Function(HealthOverview) then) =
      _$HealthOverviewCopyWithImpl<$Res, HealthOverview>;
  @useResult
  $Res call(
      {double? currentWeight,
      double? targetWeight,
      double? height,
      double? currentBMI,
      double? targetBMI,
      double? bodyFatPercentage,
      double? muscleMass,
      List<String>? medicalConditions,
      List<String>? medications,
      List<String>? allergies,
      List<String>? dietaryRestrictions});
}

/// @nodoc
class _$HealthOverviewCopyWithImpl<$Res, $Val extends HealthOverview>
    implements $HealthOverviewCopyWith<$Res> {
  _$HealthOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentWeight = freezed,
    Object? targetWeight = freezed,
    Object? height = freezed,
    Object? currentBMI = freezed,
    Object? targetBMI = freezed,
    Object? bodyFatPercentage = freezed,
    Object? muscleMass = freezed,
    Object? medicalConditions = freezed,
    Object? medications = freezed,
    Object? allergies = freezed,
    Object? dietaryRestrictions = freezed,
  }) {
    return _then(_value.copyWith(
      currentWeight: freezed == currentWeight
          ? _value.currentWeight
          : currentWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      targetWeight: freezed == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      currentBMI: freezed == currentBMI
          ? _value.currentBMI
          : currentBMI // ignore: cast_nullable_to_non_nullable
              as double?,
      targetBMI: freezed == targetBMI
          ? _value.targetBMI
          : targetBMI // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyFatPercentage: freezed == bodyFatPercentage
          ? _value.bodyFatPercentage
          : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      muscleMass: freezed == muscleMass
          ? _value.muscleMass
          : muscleMass // ignore: cast_nullable_to_non_nullable
              as double?,
      medicalConditions: freezed == medicalConditions
          ? _value.medicalConditions
          : medicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      medications: freezed == medications
          ? _value.medications
          : medications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      allergies: freezed == allergies
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dietaryRestrictions: freezed == dietaryRestrictions
          ? _value.dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthOverviewImplCopyWith<$Res>
    implements $HealthOverviewCopyWith<$Res> {
  factory _$$HealthOverviewImplCopyWith(_$HealthOverviewImpl value,
          $Res Function(_$HealthOverviewImpl) then) =
      __$$HealthOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? currentWeight,
      double? targetWeight,
      double? height,
      double? currentBMI,
      double? targetBMI,
      double? bodyFatPercentage,
      double? muscleMass,
      List<String>? medicalConditions,
      List<String>? medications,
      List<String>? allergies,
      List<String>? dietaryRestrictions});
}

/// @nodoc
class __$$HealthOverviewImplCopyWithImpl<$Res>
    extends _$HealthOverviewCopyWithImpl<$Res, _$HealthOverviewImpl>
    implements _$$HealthOverviewImplCopyWith<$Res> {
  __$$HealthOverviewImplCopyWithImpl(
      _$HealthOverviewImpl _value, $Res Function(_$HealthOverviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of HealthOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentWeight = freezed,
    Object? targetWeight = freezed,
    Object? height = freezed,
    Object? currentBMI = freezed,
    Object? targetBMI = freezed,
    Object? bodyFatPercentage = freezed,
    Object? muscleMass = freezed,
    Object? medicalConditions = freezed,
    Object? medications = freezed,
    Object? allergies = freezed,
    Object? dietaryRestrictions = freezed,
  }) {
    return _then(_$HealthOverviewImpl(
      currentWeight: freezed == currentWeight
          ? _value.currentWeight
          : currentWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      targetWeight: freezed == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      currentBMI: freezed == currentBMI
          ? _value.currentBMI
          : currentBMI // ignore: cast_nullable_to_non_nullable
              as double?,
      targetBMI: freezed == targetBMI
          ? _value.targetBMI
          : targetBMI // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyFatPercentage: freezed == bodyFatPercentage
          ? _value.bodyFatPercentage
          : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      muscleMass: freezed == muscleMass
          ? _value.muscleMass
          : muscleMass // ignore: cast_nullable_to_non_nullable
              as double?,
      medicalConditions: freezed == medicalConditions
          ? _value._medicalConditions
          : medicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      medications: freezed == medications
          ? _value._medications
          : medications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      allergies: freezed == allergies
          ? _value._allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dietaryRestrictions: freezed == dietaryRestrictions
          ? _value._dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthOverviewImpl implements _HealthOverview {
  const _$HealthOverviewImpl(
      {this.currentWeight,
      this.targetWeight,
      this.height,
      this.currentBMI,
      this.targetBMI,
      this.bodyFatPercentage,
      this.muscleMass,
      final List<String>? medicalConditions,
      final List<String>? medications,
      final List<String>? allergies,
      final List<String>? dietaryRestrictions})
      : _medicalConditions = medicalConditions,
        _medications = medications,
        _allergies = allergies,
        _dietaryRestrictions = dietaryRestrictions;

  factory _$HealthOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthOverviewImplFromJson(json);

  @override
  final double? currentWeight;
  @override
  final double? targetWeight;
  @override
  final double? height;
  @override
  final double? currentBMI;
  @override
  final double? targetBMI;
  @override
  final double? bodyFatPercentage;
  @override
  final double? muscleMass;
  final List<String>? _medicalConditions;
  @override
  List<String>? get medicalConditions {
    final value = _medicalConditions;
    if (value == null) return null;
    if (_medicalConditions is EqualUnmodifiableListView)
      return _medicalConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _medications;
  @override
  List<String>? get medications {
    final value = _medications;
    if (value == null) return null;
    if (_medications is EqualUnmodifiableListView) return _medications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _allergies;
  @override
  List<String>? get allergies {
    final value = _allergies;
    if (value == null) return null;
    if (_allergies is EqualUnmodifiableListView) return _allergies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _dietaryRestrictions;
  @override
  List<String>? get dietaryRestrictions {
    final value = _dietaryRestrictions;
    if (value == null) return null;
    if (_dietaryRestrictions is EqualUnmodifiableListView)
      return _dietaryRestrictions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'HealthOverview(currentWeight: $currentWeight, targetWeight: $targetWeight, height: $height, currentBMI: $currentBMI, targetBMI: $targetBMI, bodyFatPercentage: $bodyFatPercentage, muscleMass: $muscleMass, medicalConditions: $medicalConditions, medications: $medications, allergies: $allergies, dietaryRestrictions: $dietaryRestrictions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthOverviewImpl &&
            (identical(other.currentWeight, currentWeight) ||
                other.currentWeight == currentWeight) &&
            (identical(other.targetWeight, targetWeight) ||
                other.targetWeight == targetWeight) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.currentBMI, currentBMI) ||
                other.currentBMI == currentBMI) &&
            (identical(other.targetBMI, targetBMI) ||
                other.targetBMI == targetBMI) &&
            (identical(other.bodyFatPercentage, bodyFatPercentage) ||
                other.bodyFatPercentage == bodyFatPercentage) &&
            (identical(other.muscleMass, muscleMass) ||
                other.muscleMass == muscleMass) &&
            const DeepCollectionEquality()
                .equals(other._medicalConditions, _medicalConditions) &&
            const DeepCollectionEquality()
                .equals(other._medications, _medications) &&
            const DeepCollectionEquality()
                .equals(other._allergies, _allergies) &&
            const DeepCollectionEquality()
                .equals(other._dietaryRestrictions, _dietaryRestrictions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentWeight,
      targetWeight,
      height,
      currentBMI,
      targetBMI,
      bodyFatPercentage,
      muscleMass,
      const DeepCollectionEquality().hash(_medicalConditions),
      const DeepCollectionEquality().hash(_medications),
      const DeepCollectionEquality().hash(_allergies),
      const DeepCollectionEquality().hash(_dietaryRestrictions));

  /// Create a copy of HealthOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthOverviewImplCopyWith<_$HealthOverviewImpl> get copyWith =>
      __$$HealthOverviewImplCopyWithImpl<_$HealthOverviewImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HealthOverview value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HealthOverview value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HealthOverview value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthOverviewImplToJson(
      this,
    );
  }
}

abstract class _HealthOverview implements HealthOverview {
  const factory _HealthOverview(
      {final double? currentWeight,
      final double? targetWeight,
      final double? height,
      final double? currentBMI,
      final double? targetBMI,
      final double? bodyFatPercentage,
      final double? muscleMass,
      final List<String>? medicalConditions,
      final List<String>? medications,
      final List<String>? allergies,
      final List<String>? dietaryRestrictions}) = _$HealthOverviewImpl;

  factory _HealthOverview.fromJson(Map<String, dynamic> json) =
      _$HealthOverviewImpl.fromJson;

  @override
  double? get currentWeight;
  @override
  double? get targetWeight;
  @override
  double? get height;
  @override
  double? get currentBMI;
  @override
  double? get targetBMI;
  @override
  double? get bodyFatPercentage;
  @override
  double? get muscleMass;
  @override
  List<String>? get medicalConditions;
  @override
  List<String>? get medications;
  @override
  List<String>? get allergies;
  @override
  List<String>? get dietaryRestrictions;

  /// Create a copy of HealthOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthOverviewImplCopyWith<_$HealthOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Progress _$ProgressFromJson(Map<String, dynamic> json) {
  return _Progress.fromJson(json);
}

/// @nodoc
mixin _$Progress {
  DateTime get date => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  double? get bodyFatPercentage => throw _privateConstructorUsedError;
  double? get muscleMass => throw _privateConstructorUsedError;
  Map<String, double>? get measurements => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String>? get photos => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Progress value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Progress value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Progress value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this Progress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Progress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgressCopyWith<Progress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressCopyWith<$Res> {
  factory $ProgressCopyWith(Progress value, $Res Function(Progress) then) =
      _$ProgressCopyWithImpl<$Res, Progress>;
  @useResult
  $Res call(
      {DateTime date,
      double? weight,
      double? bodyFatPercentage,
      double? muscleMass,
      Map<String, double>? measurements,
      String? notes,
      List<String>? photos});
}

/// @nodoc
class _$ProgressCopyWithImpl<$Res, $Val extends Progress>
    implements $ProgressCopyWith<$Res> {
  _$ProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Progress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? weight = freezed,
    Object? bodyFatPercentage = freezed,
    Object? muscleMass = freezed,
    Object? measurements = freezed,
    Object? notes = freezed,
    Object? photos = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyFatPercentage: freezed == bodyFatPercentage
          ? _value.bodyFatPercentage
          : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      muscleMass: freezed == muscleMass
          ? _value.muscleMass
          : muscleMass // ignore: cast_nullable_to_non_nullable
              as double?,
      measurements: freezed == measurements
          ? _value.measurements
          : measurements // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      photos: freezed == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgressImplCopyWith<$Res>
    implements $ProgressCopyWith<$Res> {
  factory _$$ProgressImplCopyWith(
          _$ProgressImpl value, $Res Function(_$ProgressImpl) then) =
      __$$ProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      double? weight,
      double? bodyFatPercentage,
      double? muscleMass,
      Map<String, double>? measurements,
      String? notes,
      List<String>? photos});
}

/// @nodoc
class __$$ProgressImplCopyWithImpl<$Res>
    extends _$ProgressCopyWithImpl<$Res, _$ProgressImpl>
    implements _$$ProgressImplCopyWith<$Res> {
  __$$ProgressImplCopyWithImpl(
      _$ProgressImpl _value, $Res Function(_$ProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of Progress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? weight = freezed,
    Object? bodyFatPercentage = freezed,
    Object? muscleMass = freezed,
    Object? measurements = freezed,
    Object? notes = freezed,
    Object? photos = freezed,
  }) {
    return _then(_$ProgressImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyFatPercentage: freezed == bodyFatPercentage
          ? _value.bodyFatPercentage
          : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      muscleMass: freezed == muscleMass
          ? _value.muscleMass
          : muscleMass // ignore: cast_nullable_to_non_nullable
              as double?,
      measurements: freezed == measurements
          ? _value._measurements
          : measurements // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      photos: freezed == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgressImpl implements _Progress {
  const _$ProgressImpl(
      {required this.date,
      this.weight,
      this.bodyFatPercentage,
      this.muscleMass,
      final Map<String, double>? measurements,
      this.notes,
      final List<String>? photos})
      : _measurements = measurements,
        _photos = photos;

  factory _$ProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgressImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double? weight;
  @override
  final double? bodyFatPercentage;
  @override
  final double? muscleMass;
  final Map<String, double>? _measurements;
  @override
  Map<String, double>? get measurements {
    final value = _measurements;
    if (value == null) return null;
    if (_measurements is EqualUnmodifiableMapView) return _measurements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? notes;
  final List<String>? _photos;
  @override
  List<String>? get photos {
    final value = _photos;
    if (value == null) return null;
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Progress(date: $date, weight: $weight, bodyFatPercentage: $bodyFatPercentage, muscleMass: $muscleMass, measurements: $measurements, notes: $notes, photos: $photos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.bodyFatPercentage, bodyFatPercentage) ||
                other.bodyFatPercentage == bodyFatPercentage) &&
            (identical(other.muscleMass, muscleMass) ||
                other.muscleMass == muscleMass) &&
            const DeepCollectionEquality()
                .equals(other._measurements, _measurements) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._photos, _photos));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      weight,
      bodyFatPercentage,
      muscleMass,
      const DeepCollectionEquality().hash(_measurements),
      notes,
      const DeepCollectionEquality().hash(_photos));

  /// Create a copy of Progress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressImplCopyWith<_$ProgressImpl> get copyWith =>
      __$$ProgressImplCopyWithImpl<_$ProgressImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Progress value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Progress value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Progress value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgressImplToJson(
      this,
    );
  }
}

abstract class _Progress implements Progress {
  const factory _Progress(
      {required final DateTime date,
      final double? weight,
      final double? bodyFatPercentage,
      final double? muscleMass,
      final Map<String, double>? measurements,
      final String? notes,
      final List<String>? photos}) = _$ProgressImpl;

  factory _Progress.fromJson(Map<String, dynamic> json) =
      _$ProgressImpl.fromJson;

  @override
  DateTime get date;
  @override
  double? get weight;
  @override
  double? get bodyFatPercentage;
  @override
  double? get muscleMass;
  @override
  Map<String, double>? get measurements;
  @override
  String? get notes;
  @override
  List<String>? get photos;

  /// Create a copy of Progress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgressImplCopyWith<_$ProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Goal _$GoalFromJson(Map<String, dynamic> json) {
  return _Goal.fromJson(json);
}

/// @nodoc
mixin _$Goal {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double? get targetValue => throw _privateConstructorUsedError;
  double? get currentValue => throw _privateConstructorUsedError;
  DateTime? get targetDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Goal value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Goal value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Goal value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this Goal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalCopyWith<Goal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalCopyWith<$Res> {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) then) =
      _$GoalCopyWithImpl<$Res, Goal>;
  @useResult
  $Res call(
      {String id,
      String type,
      String description,
      double? targetValue,
      double? currentValue,
      DateTime? targetDate,
      String status,
      DateTime? createdAt,
      DateTime? completedAt});
}

/// @nodoc
class _$GoalCopyWithImpl<$Res, $Val extends Goal>
    implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? description = null,
    Object? targetValue = freezed,
    Object? currentValue = freezed,
    Object? targetDate = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      targetValue: freezed == targetValue
          ? _value.targetValue
          : targetValue // ignore: cast_nullable_to_non_nullable
              as double?,
      currentValue: freezed == currentValue
          ? _value.currentValue
          : currentValue // ignore: cast_nullable_to_non_nullable
              as double?,
      targetDate: freezed == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalImplCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$$GoalImplCopyWith(
          _$GoalImpl value, $Res Function(_$GoalImpl) then) =
      __$$GoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String description,
      double? targetValue,
      double? currentValue,
      DateTime? targetDate,
      String status,
      DateTime? createdAt,
      DateTime? completedAt});
}

/// @nodoc
class __$$GoalImplCopyWithImpl<$Res>
    extends _$GoalCopyWithImpl<$Res, _$GoalImpl>
    implements _$$GoalImplCopyWith<$Res> {
  __$$GoalImplCopyWithImpl(_$GoalImpl _value, $Res Function(_$GoalImpl) _then)
      : super(_value, _then);

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? description = null,
    Object? targetValue = freezed,
    Object? currentValue = freezed,
    Object? targetDate = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$GoalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      targetValue: freezed == targetValue
          ? _value.targetValue
          : targetValue // ignore: cast_nullable_to_non_nullable
              as double?,
      currentValue: freezed == currentValue
          ? _value.currentValue
          : currentValue // ignore: cast_nullable_to_non_nullable
              as double?,
      targetDate: freezed == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoalImpl implements _Goal {
  const _$GoalImpl(
      {required this.id,
      required this.type,
      required this.description,
      this.targetValue,
      this.currentValue,
      this.targetDate,
      required this.status,
      this.createdAt,
      this.completedAt});

  factory _$GoalImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final String description;
  @override
  final double? targetValue;
  @override
  final double? currentValue;
  @override
  final DateTime? targetDate;
  @override
  final String status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'Goal(id: $id, type: $type, description: $description, targetValue: $targetValue, currentValue: $currentValue, targetDate: $targetDate, status: $status, createdAt: $createdAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.targetValue, targetValue) ||
                other.targetValue == targetValue) &&
            (identical(other.currentValue, currentValue) ||
                other.currentValue == currentValue) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, description,
      targetValue, currentValue, targetDate, status, createdAt, completedAt);

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      __$$GoalImplCopyWithImpl<_$GoalImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Goal value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Goal value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Goal value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalImplToJson(
      this,
    );
  }
}

abstract class _Goal implements Goal {
  const factory _Goal(
      {required final String id,
      required final String type,
      required final String description,
      final double? targetValue,
      final double? currentValue,
      final DateTime? targetDate,
      required final String status,
      final DateTime? createdAt,
      final DateTime? completedAt}) = _$GoalImpl;

  factory _Goal.fromJson(Map<String, dynamic> json) = _$GoalImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  String get description;
  @override
  double? get targetValue;
  @override
  double? get currentValue;
  @override
  DateTime? get targetDate;
  @override
  String get status;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Reminder _$ReminderFromJson(Map<String, dynamic> json) {
  return _Reminder.fromJson(json);
}

/// @nodoc
mixin _$Reminder {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get reminderDate => throw _privateConstructorUsedError;
  bool? get isRecurring => throw _privateConstructorUsedError;
  String? get recurringPattern => throw _privateConstructorUsedError;
  bool? get isCompleted => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Reminder value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Reminder value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Reminder value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this Reminder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReminderCopyWith<Reminder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderCopyWith<$Res> {
  factory $ReminderCopyWith(Reminder value, $Res Function(Reminder) then) =
      _$ReminderCopyWithImpl<$Res, Reminder>;
  @useResult
  $Res call(
      {String id,
      String type,
      String title,
      String? description,
      DateTime reminderDate,
      bool? isRecurring,
      String? recurringPattern,
      bool? isCompleted,
      DateTime? completedAt});
}

/// @nodoc
class _$ReminderCopyWithImpl<$Res, $Val extends Reminder>
    implements $ReminderCopyWith<$Res> {
  _$ReminderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = freezed,
    Object? reminderDate = null,
    Object? isRecurring = freezed,
    Object? recurringPattern = freezed,
    Object? isCompleted = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      reminderDate: null == reminderDate
          ? _value.reminderDate
          : reminderDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRecurring: freezed == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool?,
      recurringPattern: freezed == recurringPattern
          ? _value.recurringPattern
          : recurringPattern // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: freezed == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReminderImplCopyWith<$Res>
    implements $ReminderCopyWith<$Res> {
  factory _$$ReminderImplCopyWith(
          _$ReminderImpl value, $Res Function(_$ReminderImpl) then) =
      __$$ReminderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String title,
      String? description,
      DateTime reminderDate,
      bool? isRecurring,
      String? recurringPattern,
      bool? isCompleted,
      DateTime? completedAt});
}

/// @nodoc
class __$$ReminderImplCopyWithImpl<$Res>
    extends _$ReminderCopyWithImpl<$Res, _$ReminderImpl>
    implements _$$ReminderImplCopyWith<$Res> {
  __$$ReminderImplCopyWithImpl(
      _$ReminderImpl _value, $Res Function(_$ReminderImpl) _then)
      : super(_value, _then);

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = freezed,
    Object? reminderDate = null,
    Object? isRecurring = freezed,
    Object? recurringPattern = freezed,
    Object? isCompleted = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$ReminderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      reminderDate: null == reminderDate
          ? _value.reminderDate
          : reminderDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRecurring: freezed == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool?,
      recurringPattern: freezed == recurringPattern
          ? _value.recurringPattern
          : recurringPattern // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: freezed == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReminderImpl implements _Reminder {
  const _$ReminderImpl(
      {required this.id,
      required this.type,
      required this.title,
      this.description,
      required this.reminderDate,
      this.isRecurring,
      this.recurringPattern,
      this.isCompleted,
      this.completedAt});

  factory _$ReminderImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReminderImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final String title;
  @override
  final String? description;
  @override
  final DateTime reminderDate;
  @override
  final bool? isRecurring;
  @override
  final String? recurringPattern;
  @override
  final bool? isCompleted;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'Reminder(id: $id, type: $type, title: $title, description: $description, reminderDate: $reminderDate, isRecurring: $isRecurring, recurringPattern: $recurringPattern, isCompleted: $isCompleted, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.reminderDate, reminderDate) ||
                other.reminderDate == reminderDate) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.recurringPattern, recurringPattern) ||
                other.recurringPattern == recurringPattern) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, title, description,
      reminderDate, isRecurring, recurringPattern, isCompleted, completedAt);

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderImplCopyWith<_$ReminderImpl> get copyWith =>
      __$$ReminderImplCopyWithImpl<_$ReminderImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Reminder value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Reminder value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Reminder value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ReminderImplToJson(
      this,
    );
  }
}

abstract class _Reminder implements Reminder {
  const factory _Reminder(
      {required final String id,
      required final String type,
      required final String title,
      final String? description,
      required final DateTime reminderDate,
      final bool? isRecurring,
      final String? recurringPattern,
      final bool? isCompleted,
      final DateTime? completedAt}) = _$ReminderImpl;

  factory _Reminder.fromJson(Map<String, dynamic> json) =
      _$ReminderImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  String get title;
  @override
  String? get description;
  @override
  DateTime get reminderDate;
  @override
  bool? get isRecurring;
  @override
  String? get recurringPattern;
  @override
  bool? get isCompleted;
  @override
  DateTime? get completedAt;

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReminderImplCopyWith<_$ReminderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClientDetail _$ClientDetailFromJson(Map<String, dynamic> json) {
  return _ClientDetail.fromJson(json);
}

/// @nodoc
mixin _$ClientDetail {
  NutritionistClient get client => throw _privateConstructorUsedError;
  List<ConsultationHistory> get consultationHistory =>
      throw _privateConstructorUsedError;
  ClientStats? get stats => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ClientDetail value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ClientDetail value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ClientDetail value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ClientDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClientDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClientDetailCopyWith<ClientDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClientDetailCopyWith<$Res> {
  factory $ClientDetailCopyWith(
          ClientDetail value, $Res Function(ClientDetail) then) =
      _$ClientDetailCopyWithImpl<$Res, ClientDetail>;
  @useResult
  $Res call(
      {NutritionistClient client,
      List<ConsultationHistory> consultationHistory,
      ClientStats? stats});

  $NutritionistClientCopyWith<$Res> get client;
  $ClientStatsCopyWith<$Res>? get stats;
}

/// @nodoc
class _$ClientDetailCopyWithImpl<$Res, $Val extends ClientDetail>
    implements $ClientDetailCopyWith<$Res> {
  _$ClientDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClientDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? client = null,
    Object? consultationHistory = null,
    Object? stats = freezed,
  }) {
    return _then(_value.copyWith(
      client: null == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as NutritionistClient,
      consultationHistory: null == consultationHistory
          ? _value.consultationHistory
          : consultationHistory // ignore: cast_nullable_to_non_nullable
              as List<ConsultationHistory>,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as ClientStats?,
    ) as $Val);
  }

  /// Create a copy of ClientDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionistClientCopyWith<$Res> get client {
    return $NutritionistClientCopyWith<$Res>(_value.client, (value) {
      return _then(_value.copyWith(client: value) as $Val);
    });
  }

  /// Create a copy of ClientDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClientStatsCopyWith<$Res>? get stats {
    if (_value.stats == null) {
      return null;
    }

    return $ClientStatsCopyWith<$Res>(_value.stats!, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ClientDetailImplCopyWith<$Res>
    implements $ClientDetailCopyWith<$Res> {
  factory _$$ClientDetailImplCopyWith(
          _$ClientDetailImpl value, $Res Function(_$ClientDetailImpl) then) =
      __$$ClientDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {NutritionistClient client,
      List<ConsultationHistory> consultationHistory,
      ClientStats? stats});

  @override
  $NutritionistClientCopyWith<$Res> get client;
  @override
  $ClientStatsCopyWith<$Res>? get stats;
}

/// @nodoc
class __$$ClientDetailImplCopyWithImpl<$Res>
    extends _$ClientDetailCopyWithImpl<$Res, _$ClientDetailImpl>
    implements _$$ClientDetailImplCopyWith<$Res> {
  __$$ClientDetailImplCopyWithImpl(
      _$ClientDetailImpl _value, $Res Function(_$ClientDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClientDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? client = null,
    Object? consultationHistory = null,
    Object? stats = freezed,
  }) {
    return _then(_$ClientDetailImpl(
      client: null == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as NutritionistClient,
      consultationHistory: null == consultationHistory
          ? _value._consultationHistory
          : consultationHistory // ignore: cast_nullable_to_non_nullable
              as List<ConsultationHistory>,
      stats: freezed == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as ClientStats?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClientDetailImpl implements _ClientDetail {
  const _$ClientDetailImpl(
      {required this.client,
      final List<ConsultationHistory> consultationHistory = const [],
      this.stats})
      : _consultationHistory = consultationHistory;

  factory _$ClientDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClientDetailImplFromJson(json);

  @override
  final NutritionistClient client;
  final List<ConsultationHistory> _consultationHistory;
  @override
  @JsonKey()
  List<ConsultationHistory> get consultationHistory {
    if (_consultationHistory is EqualUnmodifiableListView)
      return _consultationHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_consultationHistory);
  }

  @override
  final ClientStats? stats;

  @override
  String toString() {
    return 'ClientDetail(client: $client, consultationHistory: $consultationHistory, stats: $stats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClientDetailImpl &&
            (identical(other.client, client) || other.client == client) &&
            const DeepCollectionEquality()
                .equals(other._consultationHistory, _consultationHistory) &&
            (identical(other.stats, stats) || other.stats == stats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, client,
      const DeepCollectionEquality().hash(_consultationHistory), stats);

  /// Create a copy of ClientDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClientDetailImplCopyWith<_$ClientDetailImpl> get copyWith =>
      __$$ClientDetailImplCopyWithImpl<_$ClientDetailImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ClientDetail value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ClientDetail value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ClientDetail value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ClientDetailImplToJson(
      this,
    );
  }
}

abstract class _ClientDetail implements ClientDetail {
  const factory _ClientDetail(
      {required final NutritionistClient client,
      final List<ConsultationHistory> consultationHistory,
      final ClientStats? stats}) = _$ClientDetailImpl;

  factory _ClientDetail.fromJson(Map<String, dynamic> json) =
      _$ClientDetailImpl.fromJson;

  @override
  NutritionistClient get client;
  @override
  List<ConsultationHistory> get consultationHistory;
  @override
  ClientStats? get stats;

  /// Create a copy of ClientDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClientDetailImplCopyWith<_$ClientDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConsultationHistory _$ConsultationHistoryFromJson(Map<String, dynamic> json) {
  return _ConsultationHistory.fromJson(json);
}

/// @nodoc
mixin _$ConsultationHistory {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get topic => throw _privateConstructorUsedError;
  String? get summary => throw _privateConstructorUsedError;
  double? get duration => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  String? get feedback => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ConsultationHistory value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ConsultationHistory value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ConsultationHistory value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ConsultationHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConsultationHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConsultationHistoryCopyWith<ConsultationHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConsultationHistoryCopyWith<$Res> {
  factory $ConsultationHistoryCopyWith(
          ConsultationHistory value, $Res Function(ConsultationHistory) then) =
      _$ConsultationHistoryCopyWithImpl<$Res, ConsultationHistory>;
  @useResult
  $Res call(
      {String id,
      DateTime date,
      String? topic,
      String? summary,
      double? duration,
      double? price,
      String? status,
      double? rating,
      String? feedback});
}

/// @nodoc
class _$ConsultationHistoryCopyWithImpl<$Res, $Val extends ConsultationHistory>
    implements $ConsultationHistoryCopyWith<$Res> {
  _$ConsultationHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConsultationHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? topic = freezed,
    Object? summary = freezed,
    Object? duration = freezed,
    Object? price = freezed,
    Object? status = freezed,
    Object? rating = freezed,
    Object? feedback = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as double?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      feedback: freezed == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConsultationHistoryImplCopyWith<$Res>
    implements $ConsultationHistoryCopyWith<$Res> {
  factory _$$ConsultationHistoryImplCopyWith(_$ConsultationHistoryImpl value,
          $Res Function(_$ConsultationHistoryImpl) then) =
      __$$ConsultationHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime date,
      String? topic,
      String? summary,
      double? duration,
      double? price,
      String? status,
      double? rating,
      String? feedback});
}

/// @nodoc
class __$$ConsultationHistoryImplCopyWithImpl<$Res>
    extends _$ConsultationHistoryCopyWithImpl<$Res, _$ConsultationHistoryImpl>
    implements _$$ConsultationHistoryImplCopyWith<$Res> {
  __$$ConsultationHistoryImplCopyWithImpl(_$ConsultationHistoryImpl _value,
      $Res Function(_$ConsultationHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConsultationHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? topic = freezed,
    Object? summary = freezed,
    Object? duration = freezed,
    Object? price = freezed,
    Object? status = freezed,
    Object? rating = freezed,
    Object? feedback = freezed,
  }) {
    return _then(_$ConsultationHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as double?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      feedback: freezed == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConsultationHistoryImpl implements _ConsultationHistory {
  const _$ConsultationHistoryImpl(
      {required this.id,
      required this.date,
      this.topic,
      this.summary,
      this.duration,
      this.price,
      this.status,
      this.rating,
      this.feedback});

  factory _$ConsultationHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConsultationHistoryImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime date;
  @override
  final String? topic;
  @override
  final String? summary;
  @override
  final double? duration;
  @override
  final double? price;
  @override
  final String? status;
  @override
  final double? rating;
  @override
  final String? feedback;

  @override
  String toString() {
    return 'ConsultationHistory(id: $id, date: $date, topic: $topic, summary: $summary, duration: $duration, price: $price, status: $status, rating: $rating, feedback: $feedback)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConsultationHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.feedback, feedback) ||
                other.feedback == feedback));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, date, topic, summary,
      duration, price, status, rating, feedback);

  /// Create a copy of ConsultationHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConsultationHistoryImplCopyWith<_$ConsultationHistoryImpl> get copyWith =>
      __$$ConsultationHistoryImplCopyWithImpl<_$ConsultationHistoryImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ConsultationHistory value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ConsultationHistory value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ConsultationHistory value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ConsultationHistoryImplToJson(
      this,
    );
  }
}

abstract class _ConsultationHistory implements ConsultationHistory {
  const factory _ConsultationHistory(
      {required final String id,
      required final DateTime date,
      final String? topic,
      final String? summary,
      final double? duration,
      final double? price,
      final String? status,
      final double? rating,
      final String? feedback}) = _$ConsultationHistoryImpl;

  factory _ConsultationHistory.fromJson(Map<String, dynamic> json) =
      _$ConsultationHistoryImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  String? get topic;
  @override
  String? get summary;
  @override
  double? get duration;
  @override
  double? get price;
  @override
  String? get status;
  @override
  double? get rating;
  @override
  String? get feedback;

  /// Create a copy of ConsultationHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConsultationHistoryImplCopyWith<_$ConsultationHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClientStats _$ClientStatsFromJson(Map<String, dynamic> json) {
  return _ClientStats.fromJson(json);
}

/// @nodoc
mixin _$ClientStats {
  int get totalConsultations => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  int get goalsAchieved => throw _privateConstructorUsedError;
  int get activeDays => throw _privateConstructorUsedError;
  double? get weightProgress => throw _privateConstructorUsedError;
  double? get adherenceRate => throw _privateConstructorUsedError;
  DateTime? get firstConsultation => throw _privateConstructorUsedError;
  DateTime? get lastConsultation => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ClientStats value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ClientStats value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ClientStats value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ClientStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClientStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClientStatsCopyWith<ClientStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClientStatsCopyWith<$Res> {
  factory $ClientStatsCopyWith(
          ClientStats value, $Res Function(ClientStats) then) =
      _$ClientStatsCopyWithImpl<$Res, ClientStats>;
  @useResult
  $Res call(
      {int totalConsultations,
      double totalRevenue,
      double averageRating,
      int goalsAchieved,
      int activeDays,
      double? weightProgress,
      double? adherenceRate,
      DateTime? firstConsultation,
      DateTime? lastConsultation});
}

/// @nodoc
class _$ClientStatsCopyWithImpl<$Res, $Val extends ClientStats>
    implements $ClientStatsCopyWith<$Res> {
  _$ClientStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClientStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalConsultations = null,
    Object? totalRevenue = null,
    Object? averageRating = null,
    Object? goalsAchieved = null,
    Object? activeDays = null,
    Object? weightProgress = freezed,
    Object? adherenceRate = freezed,
    Object? firstConsultation = freezed,
    Object? lastConsultation = freezed,
  }) {
    return _then(_value.copyWith(
      totalConsultations: null == totalConsultations
          ? _value.totalConsultations
          : totalConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      goalsAchieved: null == goalsAchieved
          ? _value.goalsAchieved
          : goalsAchieved // ignore: cast_nullable_to_non_nullable
              as int,
      activeDays: null == activeDays
          ? _value.activeDays
          : activeDays // ignore: cast_nullable_to_non_nullable
              as int,
      weightProgress: freezed == weightProgress
          ? _value.weightProgress
          : weightProgress // ignore: cast_nullable_to_non_nullable
              as double?,
      adherenceRate: freezed == adherenceRate
          ? _value.adherenceRate
          : adherenceRate // ignore: cast_nullable_to_non_nullable
              as double?,
      firstConsultation: freezed == firstConsultation
          ? _value.firstConsultation
          : firstConsultation // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastConsultation: freezed == lastConsultation
          ? _value.lastConsultation
          : lastConsultation // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClientStatsImplCopyWith<$Res>
    implements $ClientStatsCopyWith<$Res> {
  factory _$$ClientStatsImplCopyWith(
          _$ClientStatsImpl value, $Res Function(_$ClientStatsImpl) then) =
      __$$ClientStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalConsultations,
      double totalRevenue,
      double averageRating,
      int goalsAchieved,
      int activeDays,
      double? weightProgress,
      double? adherenceRate,
      DateTime? firstConsultation,
      DateTime? lastConsultation});
}

/// @nodoc
class __$$ClientStatsImplCopyWithImpl<$Res>
    extends _$ClientStatsCopyWithImpl<$Res, _$ClientStatsImpl>
    implements _$$ClientStatsImplCopyWith<$Res> {
  __$$ClientStatsImplCopyWithImpl(
      _$ClientStatsImpl _value, $Res Function(_$ClientStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClientStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalConsultations = null,
    Object? totalRevenue = null,
    Object? averageRating = null,
    Object? goalsAchieved = null,
    Object? activeDays = null,
    Object? weightProgress = freezed,
    Object? adherenceRate = freezed,
    Object? firstConsultation = freezed,
    Object? lastConsultation = freezed,
  }) {
    return _then(_$ClientStatsImpl(
      totalConsultations: null == totalConsultations
          ? _value.totalConsultations
          : totalConsultations // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      goalsAchieved: null == goalsAchieved
          ? _value.goalsAchieved
          : goalsAchieved // ignore: cast_nullable_to_non_nullable
              as int,
      activeDays: null == activeDays
          ? _value.activeDays
          : activeDays // ignore: cast_nullable_to_non_nullable
              as int,
      weightProgress: freezed == weightProgress
          ? _value.weightProgress
          : weightProgress // ignore: cast_nullable_to_non_nullable
              as double?,
      adherenceRate: freezed == adherenceRate
          ? _value.adherenceRate
          : adherenceRate // ignore: cast_nullable_to_non_nullable
              as double?,
      firstConsultation: freezed == firstConsultation
          ? _value.firstConsultation
          : firstConsultation // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastConsultation: freezed == lastConsultation
          ? _value.lastConsultation
          : lastConsultation // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClientStatsImpl implements _ClientStats {
  const _$ClientStatsImpl(
      {this.totalConsultations = 0,
      this.totalRevenue = 0.0,
      this.averageRating = 0.0,
      this.goalsAchieved = 0,
      this.activeDays = 0,
      this.weightProgress,
      this.adherenceRate,
      this.firstConsultation,
      this.lastConsultation});

  factory _$ClientStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClientStatsImplFromJson(json);

  @override
  @JsonKey()
  final int totalConsultations;
  @override
  @JsonKey()
  final double totalRevenue;
  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final int goalsAchieved;
  @override
  @JsonKey()
  final int activeDays;
  @override
  final double? weightProgress;
  @override
  final double? adherenceRate;
  @override
  final DateTime? firstConsultation;
  @override
  final DateTime? lastConsultation;

  @override
  String toString() {
    return 'ClientStats(totalConsultations: $totalConsultations, totalRevenue: $totalRevenue, averageRating: $averageRating, goalsAchieved: $goalsAchieved, activeDays: $activeDays, weightProgress: $weightProgress, adherenceRate: $adherenceRate, firstConsultation: $firstConsultation, lastConsultation: $lastConsultation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClientStatsImpl &&
            (identical(other.totalConsultations, totalConsultations) ||
                other.totalConsultations == totalConsultations) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.goalsAchieved, goalsAchieved) ||
                other.goalsAchieved == goalsAchieved) &&
            (identical(other.activeDays, activeDays) ||
                other.activeDays == activeDays) &&
            (identical(other.weightProgress, weightProgress) ||
                other.weightProgress == weightProgress) &&
            (identical(other.adherenceRate, adherenceRate) ||
                other.adherenceRate == adherenceRate) &&
            (identical(other.firstConsultation, firstConsultation) ||
                other.firstConsultation == firstConsultation) &&
            (identical(other.lastConsultation, lastConsultation) ||
                other.lastConsultation == lastConsultation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalConsultations,
      totalRevenue,
      averageRating,
      goalsAchieved,
      activeDays,
      weightProgress,
      adherenceRate,
      firstConsultation,
      lastConsultation);

  /// Create a copy of ClientStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClientStatsImplCopyWith<_$ClientStatsImpl> get copyWith =>
      __$$ClientStatsImplCopyWithImpl<_$ClientStatsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ClientStats value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ClientStats value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ClientStats value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ClientStatsImplToJson(
      this,
    );
  }
}

abstract class _ClientStats implements ClientStats {
  const factory _ClientStats(
      {final int totalConsultations,
      final double totalRevenue,
      final double averageRating,
      final int goalsAchieved,
      final int activeDays,
      final double? weightProgress,
      final double? adherenceRate,
      final DateTime? firstConsultation,
      final DateTime? lastConsultation}) = _$ClientStatsImpl;

  factory _ClientStats.fromJson(Map<String, dynamic> json) =
      _$ClientStatsImpl.fromJson;

  @override
  int get totalConsultations;
  @override
  double get totalRevenue;
  @override
  double get averageRating;
  @override
  int get goalsAchieved;
  @override
  int get activeDays;
  @override
  double? get weightProgress;
  @override
  double? get adherenceRate;
  @override
  DateTime? get firstConsultation;
  @override
  DateTime? get lastConsultation;

  /// Create a copy of ClientStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClientStatsImplCopyWith<_$ClientStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ClientListParams {
  String? get search => throw _privateConstructorUsedError;
  String? get tag => throw _privateConstructorUsedError;
  String? get sortBy => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ClientListParams value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ClientListParams value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ClientListParams value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of ClientListParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClientListParamsCopyWith<ClientListParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClientListParamsCopyWith<$Res> {
  factory $ClientListParamsCopyWith(
          ClientListParams value, $Res Function(ClientListParams) then) =
      _$ClientListParamsCopyWithImpl<$Res, ClientListParams>;
  @useResult
  $Res call({String? search, String? tag, String? sortBy, int page, int limit});
}

/// @nodoc
class _$ClientListParamsCopyWithImpl<$Res, $Val extends ClientListParams>
    implements $ClientListParamsCopyWith<$Res> {
  _$ClientListParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClientListParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? search = freezed,
    Object? tag = freezed,
    Object? sortBy = freezed,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(_value.copyWith(
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      tag: freezed == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ClientListParamsImplCopyWith<$Res>
    implements $ClientListParamsCopyWith<$Res> {
  factory _$$ClientListParamsImplCopyWith(_$ClientListParamsImpl value,
          $Res Function(_$ClientListParamsImpl) then) =
      __$$ClientListParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? search, String? tag, String? sortBy, int page, int limit});
}

/// @nodoc
class __$$ClientListParamsImplCopyWithImpl<$Res>
    extends _$ClientListParamsCopyWithImpl<$Res, _$ClientListParamsImpl>
    implements _$$ClientListParamsImplCopyWith<$Res> {
  __$$ClientListParamsImplCopyWithImpl(_$ClientListParamsImpl _value,
      $Res Function(_$ClientListParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClientListParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? search = freezed,
    Object? tag = freezed,
    Object? sortBy = freezed,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(_$ClientListParamsImpl(
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      tag: freezed == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
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

class _$ClientListParamsImpl implements _ClientListParams {
  const _$ClientListParamsImpl(
      {this.search, this.tag, this.sortBy, this.page = 1, this.limit = 20});

  @override
  final String? search;
  @override
  final String? tag;
  @override
  final String? sortBy;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int limit;

  @override
  String toString() {
    return 'ClientListParams(search: $search, tag: $tag, sortBy: $sortBy, page: $page, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClientListParamsImpl &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, search, tag, sortBy, page, limit);

  /// Create a copy of ClientListParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClientListParamsImplCopyWith<_$ClientListParamsImpl> get copyWith =>
      __$$ClientListParamsImplCopyWithImpl<_$ClientListParamsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ClientListParams value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ClientListParams value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ClientListParams value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _ClientListParams implements ClientListParams {
  const factory _ClientListParams(
      {final String? search,
      final String? tag,
      final String? sortBy,
      final int page,
      final int limit}) = _$ClientListParamsImpl;

  @override
  String? get search;
  @override
  String? get tag;
  @override
  String? get sortBy;
  @override
  int get page;
  @override
  int get limit;

  /// Create a copy of ClientListParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClientListParamsImplCopyWith<_$ClientListParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BatchMessageParams {
  List<String> get clientIds => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BatchMessageParams value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BatchMessageParams value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BatchMessageParams value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of BatchMessageParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BatchMessageParamsCopyWith<BatchMessageParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchMessageParamsCopyWith<$Res> {
  factory $BatchMessageParamsCopyWith(
          BatchMessageParams value, $Res Function(BatchMessageParams) then) =
      _$BatchMessageParamsCopyWithImpl<$Res, BatchMessageParams>;
  @useResult
  $Res call({List<String> clientIds, String message, String type});
}

/// @nodoc
class _$BatchMessageParamsCopyWithImpl<$Res, $Val extends BatchMessageParams>
    implements $BatchMessageParamsCopyWith<$Res> {
  _$BatchMessageParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BatchMessageParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientIds = null,
    Object? message = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      clientIds: null == clientIds
          ? _value.clientIds
          : clientIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchMessageParamsImplCopyWith<$Res>
    implements $BatchMessageParamsCopyWith<$Res> {
  factory _$$BatchMessageParamsImplCopyWith(_$BatchMessageParamsImpl value,
          $Res Function(_$BatchMessageParamsImpl) then) =
      __$$BatchMessageParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> clientIds, String message, String type});
}

/// @nodoc
class __$$BatchMessageParamsImplCopyWithImpl<$Res>
    extends _$BatchMessageParamsCopyWithImpl<$Res, _$BatchMessageParamsImpl>
    implements _$$BatchMessageParamsImplCopyWith<$Res> {
  __$$BatchMessageParamsImplCopyWithImpl(_$BatchMessageParamsImpl _value,
      $Res Function(_$BatchMessageParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BatchMessageParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientIds = null,
    Object? message = null,
    Object? type = null,
  }) {
    return _then(_$BatchMessageParamsImpl(
      clientIds: null == clientIds
          ? _value._clientIds
          : clientIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$BatchMessageParamsImpl implements _BatchMessageParams {
  const _$BatchMessageParamsImpl(
      {required final List<String> clientIds,
      required this.message,
      this.type = 'notification'})
      : _clientIds = clientIds;

  final List<String> _clientIds;
  @override
  List<String> get clientIds {
    if (_clientIds is EqualUnmodifiableListView) return _clientIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_clientIds);
  }

  @override
  final String message;
  @override
  @JsonKey()
  final String type;

  @override
  String toString() {
    return 'BatchMessageParams(clientIds: $clientIds, message: $message, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchMessageParamsImpl &&
            const DeepCollectionEquality()
                .equals(other._clientIds, _clientIds) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_clientIds), message, type);

  /// Create a copy of BatchMessageParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchMessageParamsImplCopyWith<_$BatchMessageParamsImpl> get copyWith =>
      __$$BatchMessageParamsImplCopyWithImpl<_$BatchMessageParamsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BatchMessageParams value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BatchMessageParams value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BatchMessageParams value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _BatchMessageParams implements BatchMessageParams {
  const factory _BatchMessageParams(
      {required final List<String> clientIds,
      required final String message,
      final String type}) = _$BatchMessageParamsImpl;

  @override
  List<String> get clientIds;
  @override
  String get message;
  @override
  String get type;

  /// Create a copy of BatchMessageParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BatchMessageParamsImplCopyWith<_$BatchMessageParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProgressUpdateParams {
  double? get weight => throw _privateConstructorUsedError;
  double? get bodyFatPercentage => throw _privateConstructorUsedError;
  double? get muscleMass => throw _privateConstructorUsedError;
  Map<String, double>? get measurements => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String>? get photos => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProgressUpdateParams value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProgressUpdateParams value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProgressUpdateParams value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of ProgressUpdateParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgressUpdateParamsCopyWith<ProgressUpdateParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressUpdateParamsCopyWith<$Res> {
  factory $ProgressUpdateParamsCopyWith(ProgressUpdateParams value,
          $Res Function(ProgressUpdateParams) then) =
      _$ProgressUpdateParamsCopyWithImpl<$Res, ProgressUpdateParams>;
  @useResult
  $Res call(
      {double? weight,
      double? bodyFatPercentage,
      double? muscleMass,
      Map<String, double>? measurements,
      String? notes,
      List<String>? photos});
}

/// @nodoc
class _$ProgressUpdateParamsCopyWithImpl<$Res,
        $Val extends ProgressUpdateParams>
    implements $ProgressUpdateParamsCopyWith<$Res> {
  _$ProgressUpdateParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProgressUpdateParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weight = freezed,
    Object? bodyFatPercentage = freezed,
    Object? muscleMass = freezed,
    Object? measurements = freezed,
    Object? notes = freezed,
    Object? photos = freezed,
  }) {
    return _then(_value.copyWith(
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyFatPercentage: freezed == bodyFatPercentage
          ? _value.bodyFatPercentage
          : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      muscleMass: freezed == muscleMass
          ? _value.muscleMass
          : muscleMass // ignore: cast_nullable_to_non_nullable
              as double?,
      measurements: freezed == measurements
          ? _value.measurements
          : measurements // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      photos: freezed == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgressUpdateParamsImplCopyWith<$Res>
    implements $ProgressUpdateParamsCopyWith<$Res> {
  factory _$$ProgressUpdateParamsImplCopyWith(_$ProgressUpdateParamsImpl value,
          $Res Function(_$ProgressUpdateParamsImpl) then) =
      __$$ProgressUpdateParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? weight,
      double? bodyFatPercentage,
      double? muscleMass,
      Map<String, double>? measurements,
      String? notes,
      List<String>? photos});
}

/// @nodoc
class __$$ProgressUpdateParamsImplCopyWithImpl<$Res>
    extends _$ProgressUpdateParamsCopyWithImpl<$Res, _$ProgressUpdateParamsImpl>
    implements _$$ProgressUpdateParamsImplCopyWith<$Res> {
  __$$ProgressUpdateParamsImplCopyWithImpl(_$ProgressUpdateParamsImpl _value,
      $Res Function(_$ProgressUpdateParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProgressUpdateParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weight = freezed,
    Object? bodyFatPercentage = freezed,
    Object? muscleMass = freezed,
    Object? measurements = freezed,
    Object? notes = freezed,
    Object? photos = freezed,
  }) {
    return _then(_$ProgressUpdateParamsImpl(
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyFatPercentage: freezed == bodyFatPercentage
          ? _value.bodyFatPercentage
          : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      muscleMass: freezed == muscleMass
          ? _value.muscleMass
          : muscleMass // ignore: cast_nullable_to_non_nullable
              as double?,
      measurements: freezed == measurements
          ? _value._measurements
          : measurements // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      photos: freezed == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

class _$ProgressUpdateParamsImpl implements _ProgressUpdateParams {
  const _$ProgressUpdateParamsImpl(
      {this.weight,
      this.bodyFatPercentage,
      this.muscleMass,
      final Map<String, double>? measurements,
      this.notes,
      final List<String>? photos})
      : _measurements = measurements,
        _photos = photos;

  @override
  final double? weight;
  @override
  final double? bodyFatPercentage;
  @override
  final double? muscleMass;
  final Map<String, double>? _measurements;
  @override
  Map<String, double>? get measurements {
    final value = _measurements;
    if (value == null) return null;
    if (_measurements is EqualUnmodifiableMapView) return _measurements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? notes;
  final List<String>? _photos;
  @override
  List<String>? get photos {
    final value = _photos;
    if (value == null) return null;
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ProgressUpdateParams(weight: $weight, bodyFatPercentage: $bodyFatPercentage, muscleMass: $muscleMass, measurements: $measurements, notes: $notes, photos: $photos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressUpdateParamsImpl &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.bodyFatPercentage, bodyFatPercentage) ||
                other.bodyFatPercentage == bodyFatPercentage) &&
            (identical(other.muscleMass, muscleMass) ||
                other.muscleMass == muscleMass) &&
            const DeepCollectionEquality()
                .equals(other._measurements, _measurements) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._photos, _photos));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      weight,
      bodyFatPercentage,
      muscleMass,
      const DeepCollectionEquality().hash(_measurements),
      notes,
      const DeepCollectionEquality().hash(_photos));

  /// Create a copy of ProgressUpdateParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressUpdateParamsImplCopyWith<_$ProgressUpdateParamsImpl>
      get copyWith =>
          __$$ProgressUpdateParamsImplCopyWithImpl<_$ProgressUpdateParamsImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProgressUpdateParams value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProgressUpdateParams value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProgressUpdateParams value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _ProgressUpdateParams implements ProgressUpdateParams {
  const factory _ProgressUpdateParams(
      {final double? weight,
      final double? bodyFatPercentage,
      final double? muscleMass,
      final Map<String, double>? measurements,
      final String? notes,
      final List<String>? photos}) = _$ProgressUpdateParamsImpl;

  @override
  double? get weight;
  @override
  double? get bodyFatPercentage;
  @override
  double? get muscleMass;
  @override
  Map<String, double>? get measurements;
  @override
  String? get notes;
  @override
  List<String>? get photos;

  /// Create a copy of ProgressUpdateParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgressUpdateParamsImplCopyWith<_$ProgressUpdateParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
