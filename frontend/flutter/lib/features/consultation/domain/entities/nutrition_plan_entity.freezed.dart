// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrition_plan_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NutritionPlanEntity _$NutritionPlanEntityFromJson(Map<String, dynamic> json) {
  return _NutritionPlanEntity.fromJson(json);
}

/// @nodoc
mixin _$NutritionPlanEntity {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get nutritionistId => throw _privateConstructorUsedError;
  String? get consultationId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  PlanStatus get status => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  NutritionGoals get goals => throw _privateConstructorUsedError;
  List<DailyPlan> get dailyPlans => throw _privateConstructorUsedError;
  List<FoodRecommendation> get recommendedFoods =>
      throw _privateConstructorUsedError;
  List<FoodRestriction> get restrictedFoods =>
      throw _privateConstructorUsedError;
  MealTiming get mealTiming => throw _privateConstructorUsedError;
  Map<String, dynamic> get nutritionTargets =>
      throw _privateConstructorUsedError;
  List<String> get healthConditions => throw _privateConstructorUsedError;
  List<String> get allergies => throw _privateConstructorUsedError;
  List<String> get preferences => throw _privateConstructorUsedError;
  Map<String, dynamic> get progressTracking =>
      throw _privateConstructorUsedError;
  List<String> get notes => throw _privateConstructorUsedError;
  List<String> get attachments => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionPlanEntity value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionPlanEntity value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionPlanEntity value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionPlanEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionPlanEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionPlanEntityCopyWith<NutritionPlanEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionPlanEntityCopyWith<$Res> {
  factory $NutritionPlanEntityCopyWith(
          NutritionPlanEntity value, $Res Function(NutritionPlanEntity) then) =
      _$NutritionPlanEntityCopyWithImpl<$Res, NutritionPlanEntity>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String userId,
      String nutritionistId,
      String? consultationId,
      String title,
      String description,
      PlanStatus status,
      DateTime startDate,
      DateTime endDate,
      NutritionGoals goals,
      List<DailyPlan> dailyPlans,
      List<FoodRecommendation> recommendedFoods,
      List<FoodRestriction> restrictedFoods,
      MealTiming mealTiming,
      Map<String, dynamic> nutritionTargets,
      List<String> healthConditions,
      List<String> allergies,
      List<String> preferences,
      Map<String, dynamic> progressTracking,
      List<String> notes,
      List<String> attachments,
      DateTime createdAt,
      DateTime? updatedAt});

  $NutritionGoalsCopyWith<$Res> get goals;
  $MealTimingCopyWith<$Res> get mealTiming;
}

/// @nodoc
class _$NutritionPlanEntityCopyWithImpl<$Res, $Val extends NutritionPlanEntity>
    implements $NutritionPlanEntityCopyWith<$Res> {
  _$NutritionPlanEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionPlanEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? nutritionistId = null,
    Object? consultationId = freezed,
    Object? title = null,
    Object? description = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? goals = null,
    Object? dailyPlans = null,
    Object? recommendedFoods = null,
    Object? restrictedFoods = null,
    Object? mealTiming = null,
    Object? nutritionTargets = null,
    Object? healthConditions = null,
    Object? allergies = null,
    Object? preferences = null,
    Object? progressTracking = null,
    Object? notes = null,
    Object? attachments = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
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
      nutritionistId: null == nutritionistId
          ? _value.nutritionistId
          : nutritionistId // ignore: cast_nullable_to_non_nullable
              as String,
      consultationId: freezed == consultationId
          ? _value.consultationId
          : consultationId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlanStatus,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      goals: null == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as NutritionGoals,
      dailyPlans: null == dailyPlans
          ? _value.dailyPlans
          : dailyPlans // ignore: cast_nullable_to_non_nullable
              as List<DailyPlan>,
      recommendedFoods: null == recommendedFoods
          ? _value.recommendedFoods
          : recommendedFoods // ignore: cast_nullable_to_non_nullable
              as List<FoodRecommendation>,
      restrictedFoods: null == restrictedFoods
          ? _value.restrictedFoods
          : restrictedFoods // ignore: cast_nullable_to_non_nullable
              as List<FoodRestriction>,
      mealTiming: null == mealTiming
          ? _value.mealTiming
          : mealTiming // ignore: cast_nullable_to_non_nullable
              as MealTiming,
      nutritionTargets: null == nutritionTargets
          ? _value.nutritionTargets
          : nutritionTargets // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      healthConditions: null == healthConditions
          ? _value.healthConditions
          : healthConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergies: null == allergies
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as List<String>,
      progressTracking: null == progressTracking
          ? _value.progressTracking
          : progressTracking // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of NutritionPlanEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionGoalsCopyWith<$Res> get goals {
    return $NutritionGoalsCopyWith<$Res>(_value.goals, (value) {
      return _then(_value.copyWith(goals: value) as $Val);
    });
  }

  /// Create a copy of NutritionPlanEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealTimingCopyWith<$Res> get mealTiming {
    return $MealTimingCopyWith<$Res>(_value.mealTiming, (value) {
      return _then(_value.copyWith(mealTiming: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionPlanEntityImplCopyWith<$Res>
    implements $NutritionPlanEntityCopyWith<$Res> {
  factory _$$NutritionPlanEntityImplCopyWith(_$NutritionPlanEntityImpl value,
          $Res Function(_$NutritionPlanEntityImpl) then) =
      __$$NutritionPlanEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String userId,
      String nutritionistId,
      String? consultationId,
      String title,
      String description,
      PlanStatus status,
      DateTime startDate,
      DateTime endDate,
      NutritionGoals goals,
      List<DailyPlan> dailyPlans,
      List<FoodRecommendation> recommendedFoods,
      List<FoodRestriction> restrictedFoods,
      MealTiming mealTiming,
      Map<String, dynamic> nutritionTargets,
      List<String> healthConditions,
      List<String> allergies,
      List<String> preferences,
      Map<String, dynamic> progressTracking,
      List<String> notes,
      List<String> attachments,
      DateTime createdAt,
      DateTime? updatedAt});

  @override
  $NutritionGoalsCopyWith<$Res> get goals;
  @override
  $MealTimingCopyWith<$Res> get mealTiming;
}

/// @nodoc
class __$$NutritionPlanEntityImplCopyWithImpl<$Res>
    extends _$NutritionPlanEntityCopyWithImpl<$Res, _$NutritionPlanEntityImpl>
    implements _$$NutritionPlanEntityImplCopyWith<$Res> {
  __$$NutritionPlanEntityImplCopyWithImpl(_$NutritionPlanEntityImpl _value,
      $Res Function(_$NutritionPlanEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionPlanEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? nutritionistId = null,
    Object? consultationId = freezed,
    Object? title = null,
    Object? description = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? goals = null,
    Object? dailyPlans = null,
    Object? recommendedFoods = null,
    Object? restrictedFoods = null,
    Object? mealTiming = null,
    Object? nutritionTargets = null,
    Object? healthConditions = null,
    Object? allergies = null,
    Object? preferences = null,
    Object? progressTracking = null,
    Object? notes = null,
    Object? attachments = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$NutritionPlanEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionistId: null == nutritionistId
          ? _value.nutritionistId
          : nutritionistId // ignore: cast_nullable_to_non_nullable
              as String,
      consultationId: freezed == consultationId
          ? _value.consultationId
          : consultationId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlanStatus,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      goals: null == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as NutritionGoals,
      dailyPlans: null == dailyPlans
          ? _value._dailyPlans
          : dailyPlans // ignore: cast_nullable_to_non_nullable
              as List<DailyPlan>,
      recommendedFoods: null == recommendedFoods
          ? _value._recommendedFoods
          : recommendedFoods // ignore: cast_nullable_to_non_nullable
              as List<FoodRecommendation>,
      restrictedFoods: null == restrictedFoods
          ? _value._restrictedFoods
          : restrictedFoods // ignore: cast_nullable_to_non_nullable
              as List<FoodRestriction>,
      mealTiming: null == mealTiming
          ? _value.mealTiming
          : mealTiming // ignore: cast_nullable_to_non_nullable
              as MealTiming,
      nutritionTargets: null == nutritionTargets
          ? _value._nutritionTargets
          : nutritionTargets // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      healthConditions: null == healthConditions
          ? _value._healthConditions
          : healthConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergies: null == allergies
          ? _value._allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      preferences: null == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as List<String>,
      progressTracking: null == progressTracking
          ? _value._progressTracking
          : progressTracking // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      notes: null == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
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
class _$NutritionPlanEntityImpl implements _NutritionPlanEntity {
  const _$NutritionPlanEntityImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.userId,
      required this.nutritionistId,
      this.consultationId,
      required this.title,
      required this.description,
      required this.status,
      required this.startDate,
      required this.endDate,
      required this.goals,
      required final List<DailyPlan> dailyPlans,
      required final List<FoodRecommendation> recommendedFoods,
      required final List<FoodRestriction> restrictedFoods,
      required this.mealTiming,
      final Map<String, dynamic> nutritionTargets = const {},
      final List<String> healthConditions = const [],
      final List<String> allergies = const [],
      final List<String> preferences = const [],
      final Map<String, dynamic> progressTracking = const {},
      final List<String> notes = const [],
      final List<String> attachments = const [],
      required this.createdAt,
      this.updatedAt})
      : _dailyPlans = dailyPlans,
        _recommendedFoods = recommendedFoods,
        _restrictedFoods = restrictedFoods,
        _nutritionTargets = nutritionTargets,
        _healthConditions = healthConditions,
        _allergies = allergies,
        _preferences = preferences,
        _progressTracking = progressTracking,
        _notes = notes,
        _attachments = attachments;

  factory _$NutritionPlanEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionPlanEntityImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String userId;
  @override
  final String nutritionistId;
  @override
  final String? consultationId;
  @override
  final String title;
  @override
  final String description;
  @override
  final PlanStatus status;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final NutritionGoals goals;
  final List<DailyPlan> _dailyPlans;
  @override
  List<DailyPlan> get dailyPlans {
    if (_dailyPlans is EqualUnmodifiableListView) return _dailyPlans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyPlans);
  }

  final List<FoodRecommendation> _recommendedFoods;
  @override
  List<FoodRecommendation> get recommendedFoods {
    if (_recommendedFoods is EqualUnmodifiableListView)
      return _recommendedFoods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedFoods);
  }

  final List<FoodRestriction> _restrictedFoods;
  @override
  List<FoodRestriction> get restrictedFoods {
    if (_restrictedFoods is EqualUnmodifiableListView) return _restrictedFoods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_restrictedFoods);
  }

  @override
  final MealTiming mealTiming;
  final Map<String, dynamic> _nutritionTargets;
  @override
  @JsonKey()
  Map<String, dynamic> get nutritionTargets {
    if (_nutritionTargets is EqualUnmodifiableMapView) return _nutritionTargets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionTargets);
  }

  final List<String> _healthConditions;
  @override
  @JsonKey()
  List<String> get healthConditions {
    if (_healthConditions is EqualUnmodifiableListView)
      return _healthConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_healthConditions);
  }

  final List<String> _allergies;
  @override
  @JsonKey()
  List<String> get allergies {
    if (_allergies is EqualUnmodifiableListView) return _allergies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergies);
  }

  final List<String> _preferences;
  @override
  @JsonKey()
  List<String> get preferences {
    if (_preferences is EqualUnmodifiableListView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preferences);
  }

  final Map<String, dynamic> _progressTracking;
  @override
  @JsonKey()
  Map<String, dynamic> get progressTracking {
    if (_progressTracking is EqualUnmodifiableMapView) return _progressTracking;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_progressTracking);
  }

  final List<String> _notes;
  @override
  @JsonKey()
  List<String> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  final List<String> _attachments;
  @override
  @JsonKey()
  List<String> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'NutritionPlanEntity(id: $id, userId: $userId, nutritionistId: $nutritionistId, consultationId: $consultationId, title: $title, description: $description, status: $status, startDate: $startDate, endDate: $endDate, goals: $goals, dailyPlans: $dailyPlans, recommendedFoods: $recommendedFoods, restrictedFoods: $restrictedFoods, mealTiming: $mealTiming, nutritionTargets: $nutritionTargets, healthConditions: $healthConditions, allergies: $allergies, preferences: $preferences, progressTracking: $progressTracking, notes: $notes, attachments: $attachments, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionPlanEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nutritionistId, nutritionistId) ||
                other.nutritionistId == nutritionistId) &&
            (identical(other.consultationId, consultationId) ||
                other.consultationId == consultationId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.goals, goals) || other.goals == goals) &&
            const DeepCollectionEquality()
                .equals(other._dailyPlans, _dailyPlans) &&
            const DeepCollectionEquality()
                .equals(other._recommendedFoods, _recommendedFoods) &&
            const DeepCollectionEquality()
                .equals(other._restrictedFoods, _restrictedFoods) &&
            (identical(other.mealTiming, mealTiming) ||
                other.mealTiming == mealTiming) &&
            const DeepCollectionEquality()
                .equals(other._nutritionTargets, _nutritionTargets) &&
            const DeepCollectionEquality()
                .equals(other._healthConditions, _healthConditions) &&
            const DeepCollectionEquality()
                .equals(other._allergies, _allergies) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences) &&
            const DeepCollectionEquality()
                .equals(other._progressTracking, _progressTracking) &&
            const DeepCollectionEquality().equals(other._notes, _notes) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
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
        userId,
        nutritionistId,
        consultationId,
        title,
        description,
        status,
        startDate,
        endDate,
        goals,
        const DeepCollectionEquality().hash(_dailyPlans),
        const DeepCollectionEquality().hash(_recommendedFoods),
        const DeepCollectionEquality().hash(_restrictedFoods),
        mealTiming,
        const DeepCollectionEquality().hash(_nutritionTargets),
        const DeepCollectionEquality().hash(_healthConditions),
        const DeepCollectionEquality().hash(_allergies),
        const DeepCollectionEquality().hash(_preferences),
        const DeepCollectionEquality().hash(_progressTracking),
        const DeepCollectionEquality().hash(_notes),
        const DeepCollectionEquality().hash(_attachments),
        createdAt,
        updatedAt
      ]);

  /// Create a copy of NutritionPlanEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionPlanEntityImplCopyWith<_$NutritionPlanEntityImpl> get copyWith =>
      __$$NutritionPlanEntityImplCopyWithImpl<_$NutritionPlanEntityImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionPlanEntity value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionPlanEntity value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionPlanEntity value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionPlanEntityImplToJson(
      this,
    );
  }
}

abstract class _NutritionPlanEntity implements NutritionPlanEntity {
  const factory _NutritionPlanEntity(
      {@JsonKey(name: '_id') required final String id,
      required final String userId,
      required final String nutritionistId,
      final String? consultationId,
      required final String title,
      required final String description,
      required final PlanStatus status,
      required final DateTime startDate,
      required final DateTime endDate,
      required final NutritionGoals goals,
      required final List<DailyPlan> dailyPlans,
      required final List<FoodRecommendation> recommendedFoods,
      required final List<FoodRestriction> restrictedFoods,
      required final MealTiming mealTiming,
      final Map<String, dynamic> nutritionTargets,
      final List<String> healthConditions,
      final List<String> allergies,
      final List<String> preferences,
      final Map<String, dynamic> progressTracking,
      final List<String> notes,
      final List<String> attachments,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$NutritionPlanEntityImpl;

  factory _NutritionPlanEntity.fromJson(Map<String, dynamic> json) =
      _$NutritionPlanEntityImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get userId;
  @override
  String get nutritionistId;
  @override
  String? get consultationId;
  @override
  String get title;
  @override
  String get description;
  @override
  PlanStatus get status;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  NutritionGoals get goals;
  @override
  List<DailyPlan> get dailyPlans;
  @override
  List<FoodRecommendation> get recommendedFoods;
  @override
  List<FoodRestriction> get restrictedFoods;
  @override
  MealTiming get mealTiming;
  @override
  Map<String, dynamic> get nutritionTargets;
  @override
  List<String> get healthConditions;
  @override
  List<String> get allergies;
  @override
  List<String> get preferences;
  @override
  Map<String, dynamic> get progressTracking;
  @override
  List<String> get notes;
  @override
  List<String> get attachments;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of NutritionPlanEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionPlanEntityImplCopyWith<_$NutritionPlanEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionGoals _$NutritionGoalsFromJson(Map<String, dynamic> json) {
  return _NutritionGoals.fromJson(json);
}

/// @nodoc
mixin _$NutritionGoals {
  GoalType get primaryGoal => throw _privateConstructorUsedError;
  List<GoalType> get secondaryGoals => throw _privateConstructorUsedError;
  double? get targetWeight => throw _privateConstructorUsedError;
  double? get targetBodyFat => throw _privateConstructorUsedError;
  int? get targetCalories => throw _privateConstructorUsedError;
  Map<String, double> get macroTargets =>
      throw _privateConstructorUsedError; // protein, carbs, fat
  Map<String, double> get microTargets =>
      throw _privateConstructorUsedError; // vitamins, minerals
  String? get specificTarget => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionGoals value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionGoals value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionGoals value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionGoals to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionGoals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionGoalsCopyWith<NutritionGoals> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionGoalsCopyWith<$Res> {
  factory $NutritionGoalsCopyWith(
          NutritionGoals value, $Res Function(NutritionGoals) then) =
      _$NutritionGoalsCopyWithImpl<$Res, NutritionGoals>;
  @useResult
  $Res call(
      {GoalType primaryGoal,
      List<GoalType> secondaryGoals,
      double? targetWeight,
      double? targetBodyFat,
      int? targetCalories,
      Map<String, double> macroTargets,
      Map<String, double> microTargets,
      String? specificTarget});
}

/// @nodoc
class _$NutritionGoalsCopyWithImpl<$Res, $Val extends NutritionGoals>
    implements $NutritionGoalsCopyWith<$Res> {
  _$NutritionGoalsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionGoals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryGoal = null,
    Object? secondaryGoals = null,
    Object? targetWeight = freezed,
    Object? targetBodyFat = freezed,
    Object? targetCalories = freezed,
    Object? macroTargets = null,
    Object? microTargets = null,
    Object? specificTarget = freezed,
  }) {
    return _then(_value.copyWith(
      primaryGoal: null == primaryGoal
          ? _value.primaryGoal
          : primaryGoal // ignore: cast_nullable_to_non_nullable
              as GoalType,
      secondaryGoals: null == secondaryGoals
          ? _value.secondaryGoals
          : secondaryGoals // ignore: cast_nullable_to_non_nullable
              as List<GoalType>,
      targetWeight: freezed == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      targetBodyFat: freezed == targetBodyFat
          ? _value.targetBodyFat
          : targetBodyFat // ignore: cast_nullable_to_non_nullable
              as double?,
      targetCalories: freezed == targetCalories
          ? _value.targetCalories
          : targetCalories // ignore: cast_nullable_to_non_nullable
              as int?,
      macroTargets: null == macroTargets
          ? _value.macroTargets
          : macroTargets // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      microTargets: null == microTargets
          ? _value.microTargets
          : microTargets // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      specificTarget: freezed == specificTarget
          ? _value.specificTarget
          : specificTarget // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionGoalsImplCopyWith<$Res>
    implements $NutritionGoalsCopyWith<$Res> {
  factory _$$NutritionGoalsImplCopyWith(_$NutritionGoalsImpl value,
          $Res Function(_$NutritionGoalsImpl) then) =
      __$$NutritionGoalsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GoalType primaryGoal,
      List<GoalType> secondaryGoals,
      double? targetWeight,
      double? targetBodyFat,
      int? targetCalories,
      Map<String, double> macroTargets,
      Map<String, double> microTargets,
      String? specificTarget});
}

/// @nodoc
class __$$NutritionGoalsImplCopyWithImpl<$Res>
    extends _$NutritionGoalsCopyWithImpl<$Res, _$NutritionGoalsImpl>
    implements _$$NutritionGoalsImplCopyWith<$Res> {
  __$$NutritionGoalsImplCopyWithImpl(
      _$NutritionGoalsImpl _value, $Res Function(_$NutritionGoalsImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionGoals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryGoal = null,
    Object? secondaryGoals = null,
    Object? targetWeight = freezed,
    Object? targetBodyFat = freezed,
    Object? targetCalories = freezed,
    Object? macroTargets = null,
    Object? microTargets = null,
    Object? specificTarget = freezed,
  }) {
    return _then(_$NutritionGoalsImpl(
      primaryGoal: null == primaryGoal
          ? _value.primaryGoal
          : primaryGoal // ignore: cast_nullable_to_non_nullable
              as GoalType,
      secondaryGoals: null == secondaryGoals
          ? _value._secondaryGoals
          : secondaryGoals // ignore: cast_nullable_to_non_nullable
              as List<GoalType>,
      targetWeight: freezed == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      targetBodyFat: freezed == targetBodyFat
          ? _value.targetBodyFat
          : targetBodyFat // ignore: cast_nullable_to_non_nullable
              as double?,
      targetCalories: freezed == targetCalories
          ? _value.targetCalories
          : targetCalories // ignore: cast_nullable_to_non_nullable
              as int?,
      macroTargets: null == macroTargets
          ? _value._macroTargets
          : macroTargets // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      microTargets: null == microTargets
          ? _value._microTargets
          : microTargets // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      specificTarget: freezed == specificTarget
          ? _value.specificTarget
          : specificTarget // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionGoalsImpl implements _NutritionGoals {
  const _$NutritionGoalsImpl(
      {required this.primaryGoal,
      final List<GoalType> secondaryGoals = const [],
      this.targetWeight,
      this.targetBodyFat,
      this.targetCalories,
      final Map<String, double> macroTargets = const {},
      final Map<String, double> microTargets = const {},
      this.specificTarget})
      : _secondaryGoals = secondaryGoals,
        _macroTargets = macroTargets,
        _microTargets = microTargets;

  factory _$NutritionGoalsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionGoalsImplFromJson(json);

  @override
  final GoalType primaryGoal;
  final List<GoalType> _secondaryGoals;
  @override
  @JsonKey()
  List<GoalType> get secondaryGoals {
    if (_secondaryGoals is EqualUnmodifiableListView) return _secondaryGoals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_secondaryGoals);
  }

  @override
  final double? targetWeight;
  @override
  final double? targetBodyFat;
  @override
  final int? targetCalories;
  final Map<String, double> _macroTargets;
  @override
  @JsonKey()
  Map<String, double> get macroTargets {
    if (_macroTargets is EqualUnmodifiableMapView) return _macroTargets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_macroTargets);
  }

// protein, carbs, fat
  final Map<String, double> _microTargets;
// protein, carbs, fat
  @override
  @JsonKey()
  Map<String, double> get microTargets {
    if (_microTargets is EqualUnmodifiableMapView) return _microTargets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_microTargets);
  }

// vitamins, minerals
  @override
  final String? specificTarget;

  @override
  String toString() {
    return 'NutritionGoals(primaryGoal: $primaryGoal, secondaryGoals: $secondaryGoals, targetWeight: $targetWeight, targetBodyFat: $targetBodyFat, targetCalories: $targetCalories, macroTargets: $macroTargets, microTargets: $microTargets, specificTarget: $specificTarget)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionGoalsImpl &&
            (identical(other.primaryGoal, primaryGoal) ||
                other.primaryGoal == primaryGoal) &&
            const DeepCollectionEquality()
                .equals(other._secondaryGoals, _secondaryGoals) &&
            (identical(other.targetWeight, targetWeight) ||
                other.targetWeight == targetWeight) &&
            (identical(other.targetBodyFat, targetBodyFat) ||
                other.targetBodyFat == targetBodyFat) &&
            (identical(other.targetCalories, targetCalories) ||
                other.targetCalories == targetCalories) &&
            const DeepCollectionEquality()
                .equals(other._macroTargets, _macroTargets) &&
            const DeepCollectionEquality()
                .equals(other._microTargets, _microTargets) &&
            (identical(other.specificTarget, specificTarget) ||
                other.specificTarget == specificTarget));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      primaryGoal,
      const DeepCollectionEquality().hash(_secondaryGoals),
      targetWeight,
      targetBodyFat,
      targetCalories,
      const DeepCollectionEquality().hash(_macroTargets),
      const DeepCollectionEquality().hash(_microTargets),
      specificTarget);

  /// Create a copy of NutritionGoals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionGoalsImplCopyWith<_$NutritionGoalsImpl> get copyWith =>
      __$$NutritionGoalsImplCopyWithImpl<_$NutritionGoalsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionGoals value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionGoals value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionGoals value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionGoalsImplToJson(
      this,
    );
  }
}

abstract class _NutritionGoals implements NutritionGoals {
  const factory _NutritionGoals(
      {required final GoalType primaryGoal,
      final List<GoalType> secondaryGoals,
      final double? targetWeight,
      final double? targetBodyFat,
      final int? targetCalories,
      final Map<String, double> macroTargets,
      final Map<String, double> microTargets,
      final String? specificTarget}) = _$NutritionGoalsImpl;

  factory _NutritionGoals.fromJson(Map<String, dynamic> json) =
      _$NutritionGoalsImpl.fromJson;

  @override
  GoalType get primaryGoal;
  @override
  List<GoalType> get secondaryGoals;
  @override
  double? get targetWeight;
  @override
  double? get targetBodyFat;
  @override
  int? get targetCalories;
  @override
  Map<String, double> get macroTargets; // protein, carbs, fat
  @override
  Map<String, double> get microTargets; // vitamins, minerals
  @override
  String? get specificTarget;

  /// Create a copy of NutritionGoals
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionGoalsImplCopyWith<_$NutritionGoalsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyPlan _$DailyPlanFromJson(Map<String, dynamic> json) {
  return _DailyPlan.fromJson(json);
}

/// @nodoc
mixin _$DailyPlan {
  int get dayNumber => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  List<MealPlan> get meals => throw _privateConstructorUsedError;
  int get totalCalories => throw _privateConstructorUsedError;
  Map<String, double> get totalMacros => throw _privateConstructorUsedError;
  List<String> get notes => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  Map<String, dynamic> get actualIntake => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DailyPlan value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DailyPlan value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DailyPlan value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this DailyPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyPlanCopyWith<DailyPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyPlanCopyWith<$Res> {
  factory $DailyPlanCopyWith(DailyPlan value, $Res Function(DailyPlan) then) =
      _$DailyPlanCopyWithImpl<$Res, DailyPlan>;
  @useResult
  $Res call(
      {int dayNumber,
      DateTime date,
      List<MealPlan> meals,
      int totalCalories,
      Map<String, double> totalMacros,
      List<String> notes,
      bool isCompleted,
      Map<String, dynamic> actualIntake});
}

/// @nodoc
class _$DailyPlanCopyWithImpl<$Res, $Val extends DailyPlan>
    implements $DailyPlanCopyWith<$Res> {
  _$DailyPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayNumber = null,
    Object? date = null,
    Object? meals = null,
    Object? totalCalories = null,
    Object? totalMacros = null,
    Object? notes = null,
    Object? isCompleted = null,
    Object? actualIntake = null,
  }) {
    return _then(_value.copyWith(
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      meals: null == meals
          ? _value.meals
          : meals // ignore: cast_nullable_to_non_nullable
              as List<MealPlan>,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      totalMacros: null == totalMacros
          ? _value.totalMacros
          : totalMacros // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      actualIntake: null == actualIntake
          ? _value.actualIntake
          : actualIntake // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyPlanImplCopyWith<$Res>
    implements $DailyPlanCopyWith<$Res> {
  factory _$$DailyPlanImplCopyWith(
          _$DailyPlanImpl value, $Res Function(_$DailyPlanImpl) then) =
      __$$DailyPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int dayNumber,
      DateTime date,
      List<MealPlan> meals,
      int totalCalories,
      Map<String, double> totalMacros,
      List<String> notes,
      bool isCompleted,
      Map<String, dynamic> actualIntake});
}

/// @nodoc
class __$$DailyPlanImplCopyWithImpl<$Res>
    extends _$DailyPlanCopyWithImpl<$Res, _$DailyPlanImpl>
    implements _$$DailyPlanImplCopyWith<$Res> {
  __$$DailyPlanImplCopyWithImpl(
      _$DailyPlanImpl _value, $Res Function(_$DailyPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayNumber = null,
    Object? date = null,
    Object? meals = null,
    Object? totalCalories = null,
    Object? totalMacros = null,
    Object? notes = null,
    Object? isCompleted = null,
    Object? actualIntake = null,
  }) {
    return _then(_$DailyPlanImpl(
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      meals: null == meals
          ? _value._meals
          : meals // ignore: cast_nullable_to_non_nullable
              as List<MealPlan>,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      totalMacros: null == totalMacros
          ? _value._totalMacros
          : totalMacros // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      notes: null == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      actualIntake: null == actualIntake
          ? _value._actualIntake
          : actualIntake // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyPlanImpl implements _DailyPlan {
  const _$DailyPlanImpl(
      {required this.dayNumber,
      required this.date,
      required final List<MealPlan> meals,
      required this.totalCalories,
      required final Map<String, double> totalMacros,
      final List<String> notes = const [],
      this.isCompleted = false,
      final Map<String, dynamic> actualIntake = const {}})
      : _meals = meals,
        _totalMacros = totalMacros,
        _notes = notes,
        _actualIntake = actualIntake;

  factory _$DailyPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyPlanImplFromJson(json);

  @override
  final int dayNumber;
  @override
  final DateTime date;
  final List<MealPlan> _meals;
  @override
  List<MealPlan> get meals {
    if (_meals is EqualUnmodifiableListView) return _meals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_meals);
  }

  @override
  final int totalCalories;
  final Map<String, double> _totalMacros;
  @override
  Map<String, double> get totalMacros {
    if (_totalMacros is EqualUnmodifiableMapView) return _totalMacros;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_totalMacros);
  }

  final List<String> _notes;
  @override
  @JsonKey()
  List<String> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  @override
  @JsonKey()
  final bool isCompleted;
  final Map<String, dynamic> _actualIntake;
  @override
  @JsonKey()
  Map<String, dynamic> get actualIntake {
    if (_actualIntake is EqualUnmodifiableMapView) return _actualIntake;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_actualIntake);
  }

  @override
  String toString() {
    return 'DailyPlan(dayNumber: $dayNumber, date: $date, meals: $meals, totalCalories: $totalCalories, totalMacros: $totalMacros, notes: $notes, isCompleted: $isCompleted, actualIntake: $actualIntake)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyPlanImpl &&
            (identical(other.dayNumber, dayNumber) ||
                other.dayNumber == dayNumber) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._meals, _meals) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            const DeepCollectionEquality()
                .equals(other._totalMacros, _totalMacros) &&
            const DeepCollectionEquality().equals(other._notes, _notes) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            const DeepCollectionEquality()
                .equals(other._actualIntake, _actualIntake));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dayNumber,
      date,
      const DeepCollectionEquality().hash(_meals),
      totalCalories,
      const DeepCollectionEquality().hash(_totalMacros),
      const DeepCollectionEquality().hash(_notes),
      isCompleted,
      const DeepCollectionEquality().hash(_actualIntake));

  /// Create a copy of DailyPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyPlanImplCopyWith<_$DailyPlanImpl> get copyWith =>
      __$$DailyPlanImplCopyWithImpl<_$DailyPlanImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DailyPlan value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DailyPlan value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DailyPlan value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyPlanImplToJson(
      this,
    );
  }
}

abstract class _DailyPlan implements DailyPlan {
  const factory _DailyPlan(
      {required final int dayNumber,
      required final DateTime date,
      required final List<MealPlan> meals,
      required final int totalCalories,
      required final Map<String, double> totalMacros,
      final List<String> notes,
      final bool isCompleted,
      final Map<String, dynamic> actualIntake}) = _$DailyPlanImpl;

  factory _DailyPlan.fromJson(Map<String, dynamic> json) =
      _$DailyPlanImpl.fromJson;

  @override
  int get dayNumber;
  @override
  DateTime get date;
  @override
  List<MealPlan> get meals;
  @override
  int get totalCalories;
  @override
  Map<String, double> get totalMacros;
  @override
  List<String> get notes;
  @override
  bool get isCompleted;
  @override
  Map<String, dynamic> get actualIntake;

  /// Create a copy of DailyPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyPlanImplCopyWith<_$DailyPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MealPlan _$MealPlanFromJson(Map<String, dynamic> json) {
  return _MealPlan.fromJson(json);
}

/// @nodoc
mixin _$MealPlan {
  MealType get mealType => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  List<FoodItem> get foods => throw _privateConstructorUsedError;
  int get calories => throw _privateConstructorUsedError;
  Map<String, double> get macros => throw _privateConstructorUsedError;
  List<String> get cookingInstructions => throw _privateConstructorUsedError;
  List<String> get notes => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MealPlan value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MealPlan value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MealPlan value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MealPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealPlanCopyWith<MealPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealPlanCopyWith<$Res> {
  factory $MealPlanCopyWith(MealPlan value, $Res Function(MealPlan) then) =
      _$MealPlanCopyWithImpl<$Res, MealPlan>;
  @useResult
  $Res call(
      {MealType mealType,
      String time,
      List<FoodItem> foods,
      int calories,
      Map<String, double> macros,
      List<String> cookingInstructions,
      List<String> notes});
}

/// @nodoc
class _$MealPlanCopyWithImpl<$Res, $Val extends MealPlan>
    implements $MealPlanCopyWith<$Res> {
  _$MealPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealType = null,
    Object? time = null,
    Object? foods = null,
    Object? calories = null,
    Object? macros = null,
    Object? cookingInstructions = null,
    Object? notes = null,
  }) {
    return _then(_value.copyWith(
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      foods: null == foods
          ? _value.foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodItem>,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int,
      macros: null == macros
          ? _value.macros
          : macros // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      cookingInstructions: null == cookingInstructions
          ? _value.cookingInstructions
          : cookingInstructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MealPlanImplCopyWith<$Res>
    implements $MealPlanCopyWith<$Res> {
  factory _$$MealPlanImplCopyWith(
          _$MealPlanImpl value, $Res Function(_$MealPlanImpl) then) =
      __$$MealPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {MealType mealType,
      String time,
      List<FoodItem> foods,
      int calories,
      Map<String, double> macros,
      List<String> cookingInstructions,
      List<String> notes});
}

/// @nodoc
class __$$MealPlanImplCopyWithImpl<$Res>
    extends _$MealPlanCopyWithImpl<$Res, _$MealPlanImpl>
    implements _$$MealPlanImplCopyWith<$Res> {
  __$$MealPlanImplCopyWithImpl(
      _$MealPlanImpl _value, $Res Function(_$MealPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mealType = null,
    Object? time = null,
    Object? foods = null,
    Object? calories = null,
    Object? macros = null,
    Object? cookingInstructions = null,
    Object? notes = null,
  }) {
    return _then(_$MealPlanImpl(
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      foods: null == foods
          ? _value._foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodItem>,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int,
      macros: null == macros
          ? _value._macros
          : macros // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      cookingInstructions: null == cookingInstructions
          ? _value._cookingInstructions
          : cookingInstructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: null == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MealPlanImpl implements _MealPlan {
  const _$MealPlanImpl(
      {required this.mealType,
      required this.time,
      required final List<FoodItem> foods,
      required this.calories,
      required final Map<String, double> macros,
      final List<String> cookingInstructions = const [],
      final List<String> notes = const []})
      : _foods = foods,
        _macros = macros,
        _cookingInstructions = cookingInstructions,
        _notes = notes;

  factory _$MealPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealPlanImplFromJson(json);

  @override
  final MealType mealType;
  @override
  final String time;
  final List<FoodItem> _foods;
  @override
  List<FoodItem> get foods {
    if (_foods is EqualUnmodifiableListView) return _foods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foods);
  }

  @override
  final int calories;
  final Map<String, double> _macros;
  @override
  Map<String, double> get macros {
    if (_macros is EqualUnmodifiableMapView) return _macros;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_macros);
  }

  final List<String> _cookingInstructions;
  @override
  @JsonKey()
  List<String> get cookingInstructions {
    if (_cookingInstructions is EqualUnmodifiableListView)
      return _cookingInstructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cookingInstructions);
  }

  final List<String> _notes;
  @override
  @JsonKey()
  List<String> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  @override
  String toString() {
    return 'MealPlan(mealType: $mealType, time: $time, foods: $foods, calories: $calories, macros: $macros, cookingInstructions: $cookingInstructions, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealPlanImpl &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.time, time) || other.time == time) &&
            const DeepCollectionEquality().equals(other._foods, _foods) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            const DeepCollectionEquality().equals(other._macros, _macros) &&
            const DeepCollectionEquality()
                .equals(other._cookingInstructions, _cookingInstructions) &&
            const DeepCollectionEquality().equals(other._notes, _notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      mealType,
      time,
      const DeepCollectionEquality().hash(_foods),
      calories,
      const DeepCollectionEquality().hash(_macros),
      const DeepCollectionEquality().hash(_cookingInstructions),
      const DeepCollectionEquality().hash(_notes));

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealPlanImplCopyWith<_$MealPlanImpl> get copyWith =>
      __$$MealPlanImplCopyWithImpl<_$MealPlanImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MealPlan value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MealPlan value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MealPlan value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MealPlanImplToJson(
      this,
    );
  }
}

abstract class _MealPlan implements MealPlan {
  const factory _MealPlan(
      {required final MealType mealType,
      required final String time,
      required final List<FoodItem> foods,
      required final int calories,
      required final Map<String, double> macros,
      final List<String> cookingInstructions,
      final List<String> notes}) = _$MealPlanImpl;

  factory _MealPlan.fromJson(Map<String, dynamic> json) =
      _$MealPlanImpl.fromJson;

  @override
  MealType get mealType;
  @override
  String get time;
  @override
  List<FoodItem> get foods;
  @override
  int get calories;
  @override
  Map<String, double> get macros;
  @override
  List<String> get cookingInstructions;
  @override
  List<String> get notes;

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealPlanImplCopyWith<_$MealPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FoodItem _$FoodItemFromJson(Map<String, dynamic> json) {
  return _FoodItem.fromJson(json);
}

/// @nodoc
mixin _$FoodItem {
  String get name => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  int get calories => throw _privateConstructorUsedError;
  Map<String, double> get nutrition => throw _privateConstructorUsedError;
  String get preparation => throw _privateConstructorUsedError;
  List<String> get alternatives => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FoodItem value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FoodItem value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FoodItem value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this FoodItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodItemCopyWith<FoodItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodItemCopyWith<$Res> {
  factory $FoodItemCopyWith(FoodItem value, $Res Function(FoodItem) then) =
      _$FoodItemCopyWithImpl<$Res, FoodItem>;
  @useResult
  $Res call(
      {String name,
      double quantity,
      String unit,
      int calories,
      Map<String, double> nutrition,
      String preparation,
      List<String> alternatives});
}

/// @nodoc
class _$FoodItemCopyWithImpl<$Res, $Val extends FoodItem>
    implements $FoodItemCopyWith<$Res> {
  _$FoodItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? quantity = null,
    Object? unit = null,
    Object? calories = null,
    Object? nutrition = null,
    Object? preparation = null,
    Object? alternatives = null,
  }) {
    return _then(_value.copyWith(
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
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int,
      nutrition: null == nutrition
          ? _value.nutrition
          : nutrition // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      preparation: null == preparation
          ? _value.preparation
          : preparation // ignore: cast_nullable_to_non_nullable
              as String,
      alternatives: null == alternatives
          ? _value.alternatives
          : alternatives // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodItemImplCopyWith<$Res>
    implements $FoodItemCopyWith<$Res> {
  factory _$$FoodItemImplCopyWith(
          _$FoodItemImpl value, $Res Function(_$FoodItemImpl) then) =
      __$$FoodItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      double quantity,
      String unit,
      int calories,
      Map<String, double> nutrition,
      String preparation,
      List<String> alternatives});
}

/// @nodoc
class __$$FoodItemImplCopyWithImpl<$Res>
    extends _$FoodItemCopyWithImpl<$Res, _$FoodItemImpl>
    implements _$$FoodItemImplCopyWith<$Res> {
  __$$FoodItemImplCopyWithImpl(
      _$FoodItemImpl _value, $Res Function(_$FoodItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? quantity = null,
    Object? unit = null,
    Object? calories = null,
    Object? nutrition = null,
    Object? preparation = null,
    Object? alternatives = null,
  }) {
    return _then(_$FoodItemImpl(
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
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int,
      nutrition: null == nutrition
          ? _value._nutrition
          : nutrition // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      preparation: null == preparation
          ? _value.preparation
          : preparation // ignore: cast_nullable_to_non_nullable
              as String,
      alternatives: null == alternatives
          ? _value._alternatives
          : alternatives // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodItemImpl implements _FoodItem {
  const _$FoodItemImpl(
      {required this.name,
      required this.quantity,
      required this.unit,
      required this.calories,
      required final Map<String, double> nutrition,
      this.preparation = '',
      final List<String> alternatives = const []})
      : _nutrition = nutrition,
        _alternatives = alternatives;

  factory _$FoodItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodItemImplFromJson(json);

  @override
  final String name;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  final int calories;
  final Map<String, double> _nutrition;
  @override
  Map<String, double> get nutrition {
    if (_nutrition is EqualUnmodifiableMapView) return _nutrition;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutrition);
  }

  @override
  @JsonKey()
  final String preparation;
  final List<String> _alternatives;
  @override
  @JsonKey()
  List<String> get alternatives {
    if (_alternatives is EqualUnmodifiableListView) return _alternatives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alternatives);
  }

  @override
  String toString() {
    return 'FoodItem(name: $name, quantity: $quantity, unit: $unit, calories: $calories, nutrition: $nutrition, preparation: $preparation, alternatives: $alternatives)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            const DeepCollectionEquality()
                .equals(other._nutrition, _nutrition) &&
            (identical(other.preparation, preparation) ||
                other.preparation == preparation) &&
            const DeepCollectionEquality()
                .equals(other._alternatives, _alternatives));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      quantity,
      unit,
      calories,
      const DeepCollectionEquality().hash(_nutrition),
      preparation,
      const DeepCollectionEquality().hash(_alternatives));

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodItemImplCopyWith<_$FoodItemImpl> get copyWith =>
      __$$FoodItemImplCopyWithImpl<_$FoodItemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FoodItem value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FoodItem value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FoodItem value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodItemImplToJson(
      this,
    );
  }
}

abstract class _FoodItem implements FoodItem {
  const factory _FoodItem(
      {required final String name,
      required final double quantity,
      required final String unit,
      required final int calories,
      required final Map<String, double> nutrition,
      final String preparation,
      final List<String> alternatives}) = _$FoodItemImpl;

  factory _FoodItem.fromJson(Map<String, dynamic> json) =
      _$FoodItemImpl.fromJson;

  @override
  String get name;
  @override
  double get quantity;
  @override
  String get unit;
  @override
  int get calories;
  @override
  Map<String, double> get nutrition;
  @override
  String get preparation;
  @override
  List<String> get alternatives;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodItemImplCopyWith<_$FoodItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FoodRecommendation _$FoodRecommendationFromJson(Map<String, dynamic> json) {
  return _FoodRecommendation.fromJson(json);
}

/// @nodoc
mixin _$FoodRecommendation {
  String get foodName => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  RecommendationFrequency get frequency => throw _privateConstructorUsedError;
  String get servingSize => throw _privateConstructorUsedError;
  List<String> get benefits => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FoodRecommendation value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FoodRecommendation value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FoodRecommendation value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this FoodRecommendation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodRecommendationCopyWith<FoodRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodRecommendationCopyWith<$Res> {
  factory $FoodRecommendationCopyWith(
          FoodRecommendation value, $Res Function(FoodRecommendation) then) =
      _$FoodRecommendationCopyWithImpl<$Res, FoodRecommendation>;
  @useResult
  $Res call(
      {String foodName,
      String reason,
      RecommendationFrequency frequency,
      String servingSize,
      List<String> benefits});
}

/// @nodoc
class _$FoodRecommendationCopyWithImpl<$Res, $Val extends FoodRecommendation>
    implements $FoodRecommendationCopyWith<$Res> {
  _$FoodRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodName = null,
    Object? reason = null,
    Object? frequency = null,
    Object? servingSize = null,
    Object? benefits = null,
  }) {
    return _then(_value.copyWith(
      foodName: null == foodName
          ? _value.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as RecommendationFrequency,
      servingSize: null == servingSize
          ? _value.servingSize
          : servingSize // ignore: cast_nullable_to_non_nullable
              as String,
      benefits: null == benefits
          ? _value.benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodRecommendationImplCopyWith<$Res>
    implements $FoodRecommendationCopyWith<$Res> {
  factory _$$FoodRecommendationImplCopyWith(_$FoodRecommendationImpl value,
          $Res Function(_$FoodRecommendationImpl) then) =
      __$$FoodRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String foodName,
      String reason,
      RecommendationFrequency frequency,
      String servingSize,
      List<String> benefits});
}

/// @nodoc
class __$$FoodRecommendationImplCopyWithImpl<$Res>
    extends _$FoodRecommendationCopyWithImpl<$Res, _$FoodRecommendationImpl>
    implements _$$FoodRecommendationImplCopyWith<$Res> {
  __$$FoodRecommendationImplCopyWithImpl(_$FoodRecommendationImpl _value,
      $Res Function(_$FoodRecommendationImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodName = null,
    Object? reason = null,
    Object? frequency = null,
    Object? servingSize = null,
    Object? benefits = null,
  }) {
    return _then(_$FoodRecommendationImpl(
      foodName: null == foodName
          ? _value.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as RecommendationFrequency,
      servingSize: null == servingSize
          ? _value.servingSize
          : servingSize // ignore: cast_nullable_to_non_nullable
              as String,
      benefits: null == benefits
          ? _value._benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodRecommendationImpl implements _FoodRecommendation {
  const _$FoodRecommendationImpl(
      {required this.foodName,
      required this.reason,
      required this.frequency,
      this.servingSize = '',
      final List<String> benefits = const []})
      : _benefits = benefits;

  factory _$FoodRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodRecommendationImplFromJson(json);

  @override
  final String foodName;
  @override
  final String reason;
  @override
  final RecommendationFrequency frequency;
  @override
  @JsonKey()
  final String servingSize;
  final List<String> _benefits;
  @override
  @JsonKey()
  List<String> get benefits {
    if (_benefits is EqualUnmodifiableListView) return _benefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_benefits);
  }

  @override
  String toString() {
    return 'FoodRecommendation(foodName: $foodName, reason: $reason, frequency: $frequency, servingSize: $servingSize, benefits: $benefits)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodRecommendationImpl &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.servingSize, servingSize) ||
                other.servingSize == servingSize) &&
            const DeepCollectionEquality().equals(other._benefits, _benefits));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, foodName, reason, frequency,
      servingSize, const DeepCollectionEquality().hash(_benefits));

  /// Create a copy of FoodRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodRecommendationImplCopyWith<_$FoodRecommendationImpl> get copyWith =>
      __$$FoodRecommendationImplCopyWithImpl<_$FoodRecommendationImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FoodRecommendation value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FoodRecommendation value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FoodRecommendation value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodRecommendationImplToJson(
      this,
    );
  }
}

abstract class _FoodRecommendation implements FoodRecommendation {
  const factory _FoodRecommendation(
      {required final String foodName,
      required final String reason,
      required final RecommendationFrequency frequency,
      final String servingSize,
      final List<String> benefits}) = _$FoodRecommendationImpl;

  factory _FoodRecommendation.fromJson(Map<String, dynamic> json) =
      _$FoodRecommendationImpl.fromJson;

  @override
  String get foodName;
  @override
  String get reason;
  @override
  RecommendationFrequency get frequency;
  @override
  String get servingSize;
  @override
  List<String> get benefits;

  /// Create a copy of FoodRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodRecommendationImplCopyWith<_$FoodRecommendationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FoodRestriction _$FoodRestrictionFromJson(Map<String, dynamic> json) {
  return _FoodRestriction.fromJson(json);
}

/// @nodoc
mixin _$FoodRestriction {
  String get foodName => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  RestrictionLevel get level => throw _privateConstructorUsedError;
  List<String> get alternatives => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FoodRestriction value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FoodRestriction value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FoodRestriction value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this FoodRestriction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodRestriction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodRestrictionCopyWith<FoodRestriction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodRestrictionCopyWith<$Res> {
  factory $FoodRestrictionCopyWith(
          FoodRestriction value, $Res Function(FoodRestriction) then) =
      _$FoodRestrictionCopyWithImpl<$Res, FoodRestriction>;
  @useResult
  $Res call(
      {String foodName,
      String reason,
      RestrictionLevel level,
      List<String> alternatives});
}

/// @nodoc
class _$FoodRestrictionCopyWithImpl<$Res, $Val extends FoodRestriction>
    implements $FoodRestrictionCopyWith<$Res> {
  _$FoodRestrictionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodRestriction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodName = null,
    Object? reason = null,
    Object? level = null,
    Object? alternatives = null,
  }) {
    return _then(_value.copyWith(
      foodName: null == foodName
          ? _value.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as RestrictionLevel,
      alternatives: null == alternatives
          ? _value.alternatives
          : alternatives // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodRestrictionImplCopyWith<$Res>
    implements $FoodRestrictionCopyWith<$Res> {
  factory _$$FoodRestrictionImplCopyWith(_$FoodRestrictionImpl value,
          $Res Function(_$FoodRestrictionImpl) then) =
      __$$FoodRestrictionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String foodName,
      String reason,
      RestrictionLevel level,
      List<String> alternatives});
}

/// @nodoc
class __$$FoodRestrictionImplCopyWithImpl<$Res>
    extends _$FoodRestrictionCopyWithImpl<$Res, _$FoodRestrictionImpl>
    implements _$$FoodRestrictionImplCopyWith<$Res> {
  __$$FoodRestrictionImplCopyWithImpl(
      _$FoodRestrictionImpl _value, $Res Function(_$FoodRestrictionImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodRestriction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodName = null,
    Object? reason = null,
    Object? level = null,
    Object? alternatives = null,
  }) {
    return _then(_$FoodRestrictionImpl(
      foodName: null == foodName
          ? _value.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as RestrictionLevel,
      alternatives: null == alternatives
          ? _value._alternatives
          : alternatives // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodRestrictionImpl implements _FoodRestriction {
  const _$FoodRestrictionImpl(
      {required this.foodName,
      required this.reason,
      required this.level,
      final List<String> alternatives = const []})
      : _alternatives = alternatives;

  factory _$FoodRestrictionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodRestrictionImplFromJson(json);

  @override
  final String foodName;
  @override
  final String reason;
  @override
  final RestrictionLevel level;
  final List<String> _alternatives;
  @override
  @JsonKey()
  List<String> get alternatives {
    if (_alternatives is EqualUnmodifiableListView) return _alternatives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alternatives);
  }

  @override
  String toString() {
    return 'FoodRestriction(foodName: $foodName, reason: $reason, level: $level, alternatives: $alternatives)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodRestrictionImpl &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.level, level) || other.level == level) &&
            const DeepCollectionEquality()
                .equals(other._alternatives, _alternatives));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, foodName, reason, level,
      const DeepCollectionEquality().hash(_alternatives));

  /// Create a copy of FoodRestriction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodRestrictionImplCopyWith<_$FoodRestrictionImpl> get copyWith =>
      __$$FoodRestrictionImplCopyWithImpl<_$FoodRestrictionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FoodRestriction value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FoodRestriction value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FoodRestriction value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodRestrictionImplToJson(
      this,
    );
  }
}

abstract class _FoodRestriction implements FoodRestriction {
  const factory _FoodRestriction(
      {required final String foodName,
      required final String reason,
      required final RestrictionLevel level,
      final List<String> alternatives}) = _$FoodRestrictionImpl;

  factory _FoodRestriction.fromJson(Map<String, dynamic> json) =
      _$FoodRestrictionImpl.fromJson;

  @override
  String get foodName;
  @override
  String get reason;
  @override
  RestrictionLevel get level;
  @override
  List<String> get alternatives;

  /// Create a copy of FoodRestriction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodRestrictionImplCopyWith<_$FoodRestrictionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MealTiming _$MealTimingFromJson(Map<String, dynamic> json) {
  return _MealTiming.fromJson(json);
}

/// @nodoc
mixin _$MealTiming {
  String get breakfast => throw _privateConstructorUsedError;
  String get lunch => throw _privateConstructorUsedError;
  String get dinner => throw _privateConstructorUsedError;
  List<String> get snacks => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MealTiming value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MealTiming value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MealTiming value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MealTiming to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealTiming
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealTimingCopyWith<MealTiming> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealTimingCopyWith<$Res> {
  factory $MealTimingCopyWith(
          MealTiming value, $Res Function(MealTiming) then) =
      _$MealTimingCopyWithImpl<$Res, MealTiming>;
  @useResult
  $Res call(
      {String breakfast,
      String lunch,
      String dinner,
      List<String> snacks,
      String notes});
}

/// @nodoc
class _$MealTimingCopyWithImpl<$Res, $Val extends MealTiming>
    implements $MealTimingCopyWith<$Res> {
  _$MealTimingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealTiming
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breakfast = null,
    Object? lunch = null,
    Object? dinner = null,
    Object? snacks = null,
    Object? notes = null,
  }) {
    return _then(_value.copyWith(
      breakfast: null == breakfast
          ? _value.breakfast
          : breakfast // ignore: cast_nullable_to_non_nullable
              as String,
      lunch: null == lunch
          ? _value.lunch
          : lunch // ignore: cast_nullable_to_non_nullable
              as String,
      dinner: null == dinner
          ? _value.dinner
          : dinner // ignore: cast_nullable_to_non_nullable
              as String,
      snacks: null == snacks
          ? _value.snacks
          : snacks // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MealTimingImplCopyWith<$Res>
    implements $MealTimingCopyWith<$Res> {
  factory _$$MealTimingImplCopyWith(
          _$MealTimingImpl value, $Res Function(_$MealTimingImpl) then) =
      __$$MealTimingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String breakfast,
      String lunch,
      String dinner,
      List<String> snacks,
      String notes});
}

/// @nodoc
class __$$MealTimingImplCopyWithImpl<$Res>
    extends _$MealTimingCopyWithImpl<$Res, _$MealTimingImpl>
    implements _$$MealTimingImplCopyWith<$Res> {
  __$$MealTimingImplCopyWithImpl(
      _$MealTimingImpl _value, $Res Function(_$MealTimingImpl) _then)
      : super(_value, _then);

  /// Create a copy of MealTiming
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breakfast = null,
    Object? lunch = null,
    Object? dinner = null,
    Object? snacks = null,
    Object? notes = null,
  }) {
    return _then(_$MealTimingImpl(
      breakfast: null == breakfast
          ? _value.breakfast
          : breakfast // ignore: cast_nullable_to_non_nullable
              as String,
      lunch: null == lunch
          ? _value.lunch
          : lunch // ignore: cast_nullable_to_non_nullable
              as String,
      dinner: null == dinner
          ? _value.dinner
          : dinner // ignore: cast_nullable_to_non_nullable
              as String,
      snacks: null == snacks
          ? _value._snacks
          : snacks // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MealTimingImpl implements _MealTiming {
  const _$MealTimingImpl(
      {required this.breakfast,
      required this.lunch,
      required this.dinner,
      final List<String> snacks = const [],
      this.notes = ''})
      : _snacks = snacks;

  factory _$MealTimingImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealTimingImplFromJson(json);

  @override
  final String breakfast;
  @override
  final String lunch;
  @override
  final String dinner;
  final List<String> _snacks;
  @override
  @JsonKey()
  List<String> get snacks {
    if (_snacks is EqualUnmodifiableListView) return _snacks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_snacks);
  }

  @override
  @JsonKey()
  final String notes;

  @override
  String toString() {
    return 'MealTiming(breakfast: $breakfast, lunch: $lunch, dinner: $dinner, snacks: $snacks, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealTimingImpl &&
            (identical(other.breakfast, breakfast) ||
                other.breakfast == breakfast) &&
            (identical(other.lunch, lunch) || other.lunch == lunch) &&
            (identical(other.dinner, dinner) || other.dinner == dinner) &&
            const DeepCollectionEquality().equals(other._snacks, _snacks) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, breakfast, lunch, dinner,
      const DeepCollectionEquality().hash(_snacks), notes);

  /// Create a copy of MealTiming
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealTimingImplCopyWith<_$MealTimingImpl> get copyWith =>
      __$$MealTimingImplCopyWithImpl<_$MealTimingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MealTiming value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MealTiming value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MealTiming value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MealTimingImplToJson(
      this,
    );
  }
}

abstract class _MealTiming implements MealTiming {
  const factory _MealTiming(
      {required final String breakfast,
      required final String lunch,
      required final String dinner,
      final List<String> snacks,
      final String notes}) = _$MealTimingImpl;

  factory _MealTiming.fromJson(Map<String, dynamic> json) =
      _$MealTimingImpl.fromJson;

  @override
  String get breakfast;
  @override
  String get lunch;
  @override
  String get dinner;
  @override
  List<String> get snacks;
  @override
  String get notes;

  /// Create a copy of MealTiming
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealTimingImplCopyWith<_$MealTimingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
