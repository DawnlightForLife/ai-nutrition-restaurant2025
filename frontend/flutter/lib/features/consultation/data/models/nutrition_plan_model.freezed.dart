// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrition_plan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NutritionPlanModel _$NutritionPlanModelFromJson(Map<String, dynamic> json) {
  return _NutritionPlanModel.fromJson(json);
}

/// @nodoc
mixin _$NutritionPlanModel {
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
  NutritionGoalsModel get goals => throw _privateConstructorUsedError;
  List<DailyPlanModel> get dailyPlans => throw _privateConstructorUsedError;
  List<FoodRecommendationModel> get recommendedFoods =>
      throw _privateConstructorUsedError;
  List<FoodRestrictionModel> get restrictedFoods =>
      throw _privateConstructorUsedError;
  MealTimingModel get mealTiming => throw _privateConstructorUsedError;
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
    TResult Function(_NutritionPlanModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionPlanModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionPlanModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionPlanModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionPlanModelCopyWith<NutritionPlanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionPlanModelCopyWith<$Res> {
  factory $NutritionPlanModelCopyWith(
          NutritionPlanModel value, $Res Function(NutritionPlanModel) then) =
      _$NutritionPlanModelCopyWithImpl<$Res, NutritionPlanModel>;
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
      NutritionGoalsModel goals,
      List<DailyPlanModel> dailyPlans,
      List<FoodRecommendationModel> recommendedFoods,
      List<FoodRestrictionModel> restrictedFoods,
      MealTimingModel mealTiming,
      Map<String, dynamic> nutritionTargets,
      List<String> healthConditions,
      List<String> allergies,
      List<String> preferences,
      Map<String, dynamic> progressTracking,
      List<String> notes,
      List<String> attachments,
      DateTime createdAt,
      DateTime? updatedAt});

  $NutritionGoalsModelCopyWith<$Res> get goals;
  $MealTimingModelCopyWith<$Res> get mealTiming;
}

/// @nodoc
class _$NutritionPlanModelCopyWithImpl<$Res, $Val extends NutritionPlanModel>
    implements $NutritionPlanModelCopyWith<$Res> {
  _$NutritionPlanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionPlanModel
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
              as NutritionGoalsModel,
      dailyPlans: null == dailyPlans
          ? _value.dailyPlans
          : dailyPlans // ignore: cast_nullable_to_non_nullable
              as List<DailyPlanModel>,
      recommendedFoods: null == recommendedFoods
          ? _value.recommendedFoods
          : recommendedFoods // ignore: cast_nullable_to_non_nullable
              as List<FoodRecommendationModel>,
      restrictedFoods: null == restrictedFoods
          ? _value.restrictedFoods
          : restrictedFoods // ignore: cast_nullable_to_non_nullable
              as List<FoodRestrictionModel>,
      mealTiming: null == mealTiming
          ? _value.mealTiming
          : mealTiming // ignore: cast_nullable_to_non_nullable
              as MealTimingModel,
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

  /// Create a copy of NutritionPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionGoalsModelCopyWith<$Res> get goals {
    return $NutritionGoalsModelCopyWith<$Res>(_value.goals, (value) {
      return _then(_value.copyWith(goals: value) as $Val);
    });
  }

  /// Create a copy of NutritionPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MealTimingModelCopyWith<$Res> get mealTiming {
    return $MealTimingModelCopyWith<$Res>(_value.mealTiming, (value) {
      return _then(_value.copyWith(mealTiming: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionPlanModelImplCopyWith<$Res>
    implements $NutritionPlanModelCopyWith<$Res> {
  factory _$$NutritionPlanModelImplCopyWith(_$NutritionPlanModelImpl value,
          $Res Function(_$NutritionPlanModelImpl) then) =
      __$$NutritionPlanModelImplCopyWithImpl<$Res>;
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
      NutritionGoalsModel goals,
      List<DailyPlanModel> dailyPlans,
      List<FoodRecommendationModel> recommendedFoods,
      List<FoodRestrictionModel> restrictedFoods,
      MealTimingModel mealTiming,
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
  $NutritionGoalsModelCopyWith<$Res> get goals;
  @override
  $MealTimingModelCopyWith<$Res> get mealTiming;
}

/// @nodoc
class __$$NutritionPlanModelImplCopyWithImpl<$Res>
    extends _$NutritionPlanModelCopyWithImpl<$Res, _$NutritionPlanModelImpl>
    implements _$$NutritionPlanModelImplCopyWith<$Res> {
  __$$NutritionPlanModelImplCopyWithImpl(_$NutritionPlanModelImpl _value,
      $Res Function(_$NutritionPlanModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionPlanModel
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
    return _then(_$NutritionPlanModelImpl(
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
              as NutritionGoalsModel,
      dailyPlans: null == dailyPlans
          ? _value._dailyPlans
          : dailyPlans // ignore: cast_nullable_to_non_nullable
              as List<DailyPlanModel>,
      recommendedFoods: null == recommendedFoods
          ? _value._recommendedFoods
          : recommendedFoods // ignore: cast_nullable_to_non_nullable
              as List<FoodRecommendationModel>,
      restrictedFoods: null == restrictedFoods
          ? _value._restrictedFoods
          : restrictedFoods // ignore: cast_nullable_to_non_nullable
              as List<FoodRestrictionModel>,
      mealTiming: null == mealTiming
          ? _value.mealTiming
          : mealTiming // ignore: cast_nullable_to_non_nullable
              as MealTimingModel,
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
class _$NutritionPlanModelImpl implements _NutritionPlanModel {
  const _$NutritionPlanModelImpl(
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
      required final List<DailyPlanModel> dailyPlans,
      required final List<FoodRecommendationModel> recommendedFoods,
      required final List<FoodRestrictionModel> restrictedFoods,
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

  factory _$NutritionPlanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionPlanModelImplFromJson(json);

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
  final NutritionGoalsModel goals;
  final List<DailyPlanModel> _dailyPlans;
  @override
  List<DailyPlanModel> get dailyPlans {
    if (_dailyPlans is EqualUnmodifiableListView) return _dailyPlans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyPlans);
  }

  final List<FoodRecommendationModel> _recommendedFoods;
  @override
  List<FoodRecommendationModel> get recommendedFoods {
    if (_recommendedFoods is EqualUnmodifiableListView)
      return _recommendedFoods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedFoods);
  }

  final List<FoodRestrictionModel> _restrictedFoods;
  @override
  List<FoodRestrictionModel> get restrictedFoods {
    if (_restrictedFoods is EqualUnmodifiableListView) return _restrictedFoods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_restrictedFoods);
  }

  @override
  final MealTimingModel mealTiming;
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
    return 'NutritionPlanModel(id: $id, userId: $userId, nutritionistId: $nutritionistId, consultationId: $consultationId, title: $title, description: $description, status: $status, startDate: $startDate, endDate: $endDate, goals: $goals, dailyPlans: $dailyPlans, recommendedFoods: $recommendedFoods, restrictedFoods: $restrictedFoods, mealTiming: $mealTiming, nutritionTargets: $nutritionTargets, healthConditions: $healthConditions, allergies: $allergies, preferences: $preferences, progressTracking: $progressTracking, notes: $notes, attachments: $attachments, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionPlanModelImpl &&
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

  /// Create a copy of NutritionPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionPlanModelImplCopyWith<_$NutritionPlanModelImpl> get copyWith =>
      __$$NutritionPlanModelImplCopyWithImpl<_$NutritionPlanModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionPlanModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionPlanModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionPlanModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionPlanModelImplToJson(
      this,
    );
  }
}

abstract class _NutritionPlanModel implements NutritionPlanModel {
  const factory _NutritionPlanModel(
      {@JsonKey(name: '_id') required final String id,
      required final String userId,
      required final String nutritionistId,
      final String? consultationId,
      required final String title,
      required final String description,
      required final PlanStatus status,
      required final DateTime startDate,
      required final DateTime endDate,
      required final NutritionGoalsModel goals,
      required final List<DailyPlanModel> dailyPlans,
      required final List<FoodRecommendationModel> recommendedFoods,
      required final List<FoodRestrictionModel> restrictedFoods,
      required final MealTimingModel mealTiming,
      final Map<String, dynamic> nutritionTargets,
      final List<String> healthConditions,
      final List<String> allergies,
      final List<String> preferences,
      final Map<String, dynamic> progressTracking,
      final List<String> notes,
      final List<String> attachments,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$NutritionPlanModelImpl;

  factory _NutritionPlanModel.fromJson(Map<String, dynamic> json) =
      _$NutritionPlanModelImpl.fromJson;

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
  NutritionGoalsModel get goals;
  @override
  List<DailyPlanModel> get dailyPlans;
  @override
  List<FoodRecommendationModel> get recommendedFoods;
  @override
  List<FoodRestrictionModel> get restrictedFoods;
  @override
  MealTimingModel get mealTiming;
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

  /// Create a copy of NutritionPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionPlanModelImplCopyWith<_$NutritionPlanModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionGoalsModel _$NutritionGoalsModelFromJson(Map<String, dynamic> json) {
  return _NutritionGoalsModel.fromJson(json);
}

/// @nodoc
mixin _$NutritionGoalsModel {
  GoalType get primaryGoal => throw _privateConstructorUsedError;
  List<GoalType> get secondaryGoals => throw _privateConstructorUsedError;
  double? get targetWeight => throw _privateConstructorUsedError;
  double? get targetBodyFat => throw _privateConstructorUsedError;
  int? get targetCalories => throw _privateConstructorUsedError;
  Map<String, double> get macroTargets => throw _privateConstructorUsedError;
  Map<String, double> get microTargets => throw _privateConstructorUsedError;
  String? get specificTarget => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionGoalsModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionGoalsModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionGoalsModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionGoalsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionGoalsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionGoalsModelCopyWith<NutritionGoalsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionGoalsModelCopyWith<$Res> {
  factory $NutritionGoalsModelCopyWith(
          NutritionGoalsModel value, $Res Function(NutritionGoalsModel) then) =
      _$NutritionGoalsModelCopyWithImpl<$Res, NutritionGoalsModel>;
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
class _$NutritionGoalsModelCopyWithImpl<$Res, $Val extends NutritionGoalsModel>
    implements $NutritionGoalsModelCopyWith<$Res> {
  _$NutritionGoalsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionGoalsModel
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
abstract class _$$NutritionGoalsModelImplCopyWith<$Res>
    implements $NutritionGoalsModelCopyWith<$Res> {
  factory _$$NutritionGoalsModelImplCopyWith(_$NutritionGoalsModelImpl value,
          $Res Function(_$NutritionGoalsModelImpl) then) =
      __$$NutritionGoalsModelImplCopyWithImpl<$Res>;
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
class __$$NutritionGoalsModelImplCopyWithImpl<$Res>
    extends _$NutritionGoalsModelCopyWithImpl<$Res, _$NutritionGoalsModelImpl>
    implements _$$NutritionGoalsModelImplCopyWith<$Res> {
  __$$NutritionGoalsModelImplCopyWithImpl(_$NutritionGoalsModelImpl _value,
      $Res Function(_$NutritionGoalsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionGoalsModel
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
    return _then(_$NutritionGoalsModelImpl(
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
class _$NutritionGoalsModelImpl implements _NutritionGoalsModel {
  const _$NutritionGoalsModelImpl(
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

  factory _$NutritionGoalsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionGoalsModelImplFromJson(json);

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

  final Map<String, double> _microTargets;
  @override
  @JsonKey()
  Map<String, double> get microTargets {
    if (_microTargets is EqualUnmodifiableMapView) return _microTargets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_microTargets);
  }

  @override
  final String? specificTarget;

  @override
  String toString() {
    return 'NutritionGoalsModel(primaryGoal: $primaryGoal, secondaryGoals: $secondaryGoals, targetWeight: $targetWeight, targetBodyFat: $targetBodyFat, targetCalories: $targetCalories, macroTargets: $macroTargets, microTargets: $microTargets, specificTarget: $specificTarget)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionGoalsModelImpl &&
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

  /// Create a copy of NutritionGoalsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionGoalsModelImplCopyWith<_$NutritionGoalsModelImpl> get copyWith =>
      __$$NutritionGoalsModelImplCopyWithImpl<_$NutritionGoalsModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionGoalsModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionGoalsModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionGoalsModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionGoalsModelImplToJson(
      this,
    );
  }
}

abstract class _NutritionGoalsModel implements NutritionGoalsModel {
  const factory _NutritionGoalsModel(
      {required final GoalType primaryGoal,
      final List<GoalType> secondaryGoals,
      final double? targetWeight,
      final double? targetBodyFat,
      final int? targetCalories,
      final Map<String, double> macroTargets,
      final Map<String, double> microTargets,
      final String? specificTarget}) = _$NutritionGoalsModelImpl;

  factory _NutritionGoalsModel.fromJson(Map<String, dynamic> json) =
      _$NutritionGoalsModelImpl.fromJson;

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
  Map<String, double> get macroTargets;
  @override
  Map<String, double> get microTargets;
  @override
  String? get specificTarget;

  /// Create a copy of NutritionGoalsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionGoalsModelImplCopyWith<_$NutritionGoalsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyPlanModel _$DailyPlanModelFromJson(Map<String, dynamic> json) {
  return _DailyPlanModel.fromJson(json);
}

/// @nodoc
mixin _$DailyPlanModel {
  int get dayNumber => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  List<MealPlanModel> get meals => throw _privateConstructorUsedError;
  int get totalCalories => throw _privateConstructorUsedError;
  Map<String, double> get totalMacros => throw _privateConstructorUsedError;
  List<String> get notes => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  Map<String, dynamic> get actualIntake => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DailyPlanModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DailyPlanModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DailyPlanModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this DailyPlanModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyPlanModelCopyWith<DailyPlanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyPlanModelCopyWith<$Res> {
  factory $DailyPlanModelCopyWith(
          DailyPlanModel value, $Res Function(DailyPlanModel) then) =
      _$DailyPlanModelCopyWithImpl<$Res, DailyPlanModel>;
  @useResult
  $Res call(
      {int dayNumber,
      DateTime date,
      List<MealPlanModel> meals,
      int totalCalories,
      Map<String, double> totalMacros,
      List<String> notes,
      bool isCompleted,
      Map<String, dynamic> actualIntake});
}

/// @nodoc
class _$DailyPlanModelCopyWithImpl<$Res, $Val extends DailyPlanModel>
    implements $DailyPlanModelCopyWith<$Res> {
  _$DailyPlanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyPlanModel
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
              as List<MealPlanModel>,
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
abstract class _$$DailyPlanModelImplCopyWith<$Res>
    implements $DailyPlanModelCopyWith<$Res> {
  factory _$$DailyPlanModelImplCopyWith(_$DailyPlanModelImpl value,
          $Res Function(_$DailyPlanModelImpl) then) =
      __$$DailyPlanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int dayNumber,
      DateTime date,
      List<MealPlanModel> meals,
      int totalCalories,
      Map<String, double> totalMacros,
      List<String> notes,
      bool isCompleted,
      Map<String, dynamic> actualIntake});
}

/// @nodoc
class __$$DailyPlanModelImplCopyWithImpl<$Res>
    extends _$DailyPlanModelCopyWithImpl<$Res, _$DailyPlanModelImpl>
    implements _$$DailyPlanModelImplCopyWith<$Res> {
  __$$DailyPlanModelImplCopyWithImpl(
      _$DailyPlanModelImpl _value, $Res Function(_$DailyPlanModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyPlanModel
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
    return _then(_$DailyPlanModelImpl(
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
              as List<MealPlanModel>,
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
class _$DailyPlanModelImpl implements _DailyPlanModel {
  const _$DailyPlanModelImpl(
      {required this.dayNumber,
      required this.date,
      required final List<MealPlanModel> meals,
      required this.totalCalories,
      required final Map<String, double> totalMacros,
      final List<String> notes = const [],
      this.isCompleted = false,
      final Map<String, dynamic> actualIntake = const {}})
      : _meals = meals,
        _totalMacros = totalMacros,
        _notes = notes,
        _actualIntake = actualIntake;

  factory _$DailyPlanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyPlanModelImplFromJson(json);

  @override
  final int dayNumber;
  @override
  final DateTime date;
  final List<MealPlanModel> _meals;
  @override
  List<MealPlanModel> get meals {
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
    return 'DailyPlanModel(dayNumber: $dayNumber, date: $date, meals: $meals, totalCalories: $totalCalories, totalMacros: $totalMacros, notes: $notes, isCompleted: $isCompleted, actualIntake: $actualIntake)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyPlanModelImpl &&
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

  /// Create a copy of DailyPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyPlanModelImplCopyWith<_$DailyPlanModelImpl> get copyWith =>
      __$$DailyPlanModelImplCopyWithImpl<_$DailyPlanModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DailyPlanModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DailyPlanModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DailyPlanModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyPlanModelImplToJson(
      this,
    );
  }
}

abstract class _DailyPlanModel implements DailyPlanModel {
  const factory _DailyPlanModel(
      {required final int dayNumber,
      required final DateTime date,
      required final List<MealPlanModel> meals,
      required final int totalCalories,
      required final Map<String, double> totalMacros,
      final List<String> notes,
      final bool isCompleted,
      final Map<String, dynamic> actualIntake}) = _$DailyPlanModelImpl;

  factory _DailyPlanModel.fromJson(Map<String, dynamic> json) =
      _$DailyPlanModelImpl.fromJson;

  @override
  int get dayNumber;
  @override
  DateTime get date;
  @override
  List<MealPlanModel> get meals;
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

  /// Create a copy of DailyPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyPlanModelImplCopyWith<_$DailyPlanModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MealPlanModel _$MealPlanModelFromJson(Map<String, dynamic> json) {
  return _MealPlanModel.fromJson(json);
}

/// @nodoc
mixin _$MealPlanModel {
  MealType get mealType => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  List<FoodItemModel> get foods => throw _privateConstructorUsedError;
  int get calories => throw _privateConstructorUsedError;
  Map<String, double> get macros => throw _privateConstructorUsedError;
  List<String> get cookingInstructions => throw _privateConstructorUsedError;
  List<String> get notes => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MealPlanModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MealPlanModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MealPlanModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MealPlanModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealPlanModelCopyWith<MealPlanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealPlanModelCopyWith<$Res> {
  factory $MealPlanModelCopyWith(
          MealPlanModel value, $Res Function(MealPlanModel) then) =
      _$MealPlanModelCopyWithImpl<$Res, MealPlanModel>;
  @useResult
  $Res call(
      {MealType mealType,
      String time,
      List<FoodItemModel> foods,
      int calories,
      Map<String, double> macros,
      List<String> cookingInstructions,
      List<String> notes});
}

/// @nodoc
class _$MealPlanModelCopyWithImpl<$Res, $Val extends MealPlanModel>
    implements $MealPlanModelCopyWith<$Res> {
  _$MealPlanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealPlanModel
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
              as List<FoodItemModel>,
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
abstract class _$$MealPlanModelImplCopyWith<$Res>
    implements $MealPlanModelCopyWith<$Res> {
  factory _$$MealPlanModelImplCopyWith(
          _$MealPlanModelImpl value, $Res Function(_$MealPlanModelImpl) then) =
      __$$MealPlanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {MealType mealType,
      String time,
      List<FoodItemModel> foods,
      int calories,
      Map<String, double> macros,
      List<String> cookingInstructions,
      List<String> notes});
}

/// @nodoc
class __$$MealPlanModelImplCopyWithImpl<$Res>
    extends _$MealPlanModelCopyWithImpl<$Res, _$MealPlanModelImpl>
    implements _$$MealPlanModelImplCopyWith<$Res> {
  __$$MealPlanModelImplCopyWithImpl(
      _$MealPlanModelImpl _value, $Res Function(_$MealPlanModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MealPlanModel
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
    return _then(_$MealPlanModelImpl(
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
              as List<FoodItemModel>,
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
class _$MealPlanModelImpl implements _MealPlanModel {
  const _$MealPlanModelImpl(
      {required this.mealType,
      required this.time,
      required final List<FoodItemModel> foods,
      required this.calories,
      required final Map<String, double> macros,
      final List<String> cookingInstructions = const [],
      final List<String> notes = const []})
      : _foods = foods,
        _macros = macros,
        _cookingInstructions = cookingInstructions,
        _notes = notes;

  factory _$MealPlanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealPlanModelImplFromJson(json);

  @override
  final MealType mealType;
  @override
  final String time;
  final List<FoodItemModel> _foods;
  @override
  List<FoodItemModel> get foods {
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
    return 'MealPlanModel(mealType: $mealType, time: $time, foods: $foods, calories: $calories, macros: $macros, cookingInstructions: $cookingInstructions, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealPlanModelImpl &&
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

  /// Create a copy of MealPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealPlanModelImplCopyWith<_$MealPlanModelImpl> get copyWith =>
      __$$MealPlanModelImplCopyWithImpl<_$MealPlanModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MealPlanModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MealPlanModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MealPlanModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MealPlanModelImplToJson(
      this,
    );
  }
}

abstract class _MealPlanModel implements MealPlanModel {
  const factory _MealPlanModel(
      {required final MealType mealType,
      required final String time,
      required final List<FoodItemModel> foods,
      required final int calories,
      required final Map<String, double> macros,
      final List<String> cookingInstructions,
      final List<String> notes}) = _$MealPlanModelImpl;

  factory _MealPlanModel.fromJson(Map<String, dynamic> json) =
      _$MealPlanModelImpl.fromJson;

  @override
  MealType get mealType;
  @override
  String get time;
  @override
  List<FoodItemModel> get foods;
  @override
  int get calories;
  @override
  Map<String, double> get macros;
  @override
  List<String> get cookingInstructions;
  @override
  List<String> get notes;

  /// Create a copy of MealPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealPlanModelImplCopyWith<_$MealPlanModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FoodItemModel _$FoodItemModelFromJson(Map<String, dynamic> json) {
  return _FoodItemModel.fromJson(json);
}

/// @nodoc
mixin _$FoodItemModel {
  String get name => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  int get calories => throw _privateConstructorUsedError;
  Map<String, double> get nutrition => throw _privateConstructorUsedError;
  String get preparation => throw _privateConstructorUsedError;
  List<String> get alternatives => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FoodItemModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FoodItemModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FoodItemModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this FoodItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodItemModelCopyWith<FoodItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodItemModelCopyWith<$Res> {
  factory $FoodItemModelCopyWith(
          FoodItemModel value, $Res Function(FoodItemModel) then) =
      _$FoodItemModelCopyWithImpl<$Res, FoodItemModel>;
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
class _$FoodItemModelCopyWithImpl<$Res, $Val extends FoodItemModel>
    implements $FoodItemModelCopyWith<$Res> {
  _$FoodItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodItemModel
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
abstract class _$$FoodItemModelImplCopyWith<$Res>
    implements $FoodItemModelCopyWith<$Res> {
  factory _$$FoodItemModelImplCopyWith(
          _$FoodItemModelImpl value, $Res Function(_$FoodItemModelImpl) then) =
      __$$FoodItemModelImplCopyWithImpl<$Res>;
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
class __$$FoodItemModelImplCopyWithImpl<$Res>
    extends _$FoodItemModelCopyWithImpl<$Res, _$FoodItemModelImpl>
    implements _$$FoodItemModelImplCopyWith<$Res> {
  __$$FoodItemModelImplCopyWithImpl(
      _$FoodItemModelImpl _value, $Res Function(_$FoodItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodItemModel
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
    return _then(_$FoodItemModelImpl(
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
class _$FoodItemModelImpl implements _FoodItemModel {
  const _$FoodItemModelImpl(
      {required this.name,
      required this.quantity,
      required this.unit,
      required this.calories,
      required final Map<String, double> nutrition,
      this.preparation = '',
      final List<String> alternatives = const []})
      : _nutrition = nutrition,
        _alternatives = alternatives;

  factory _$FoodItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodItemModelImplFromJson(json);

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
    return 'FoodItemModel(name: $name, quantity: $quantity, unit: $unit, calories: $calories, nutrition: $nutrition, preparation: $preparation, alternatives: $alternatives)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodItemModelImpl &&
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

  /// Create a copy of FoodItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodItemModelImplCopyWith<_$FoodItemModelImpl> get copyWith =>
      __$$FoodItemModelImplCopyWithImpl<_$FoodItemModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FoodItemModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FoodItemModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FoodItemModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodItemModelImplToJson(
      this,
    );
  }
}

abstract class _FoodItemModel implements FoodItemModel {
  const factory _FoodItemModel(
      {required final String name,
      required final double quantity,
      required final String unit,
      required final int calories,
      required final Map<String, double> nutrition,
      final String preparation,
      final List<String> alternatives}) = _$FoodItemModelImpl;

  factory _FoodItemModel.fromJson(Map<String, dynamic> json) =
      _$FoodItemModelImpl.fromJson;

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

  /// Create a copy of FoodItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodItemModelImplCopyWith<_$FoodItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FoodRecommendationModel _$FoodRecommendationModelFromJson(
    Map<String, dynamic> json) {
  return _FoodRecommendationModel.fromJson(json);
}

/// @nodoc
mixin _$FoodRecommendationModel {
  String get foodName => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  RecommendationFrequency get frequency => throw _privateConstructorUsedError;
  String get servingSize => throw _privateConstructorUsedError;
  List<String> get benefits => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FoodRecommendationModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FoodRecommendationModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FoodRecommendationModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this FoodRecommendationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodRecommendationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodRecommendationModelCopyWith<FoodRecommendationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodRecommendationModelCopyWith<$Res> {
  factory $FoodRecommendationModelCopyWith(FoodRecommendationModel value,
          $Res Function(FoodRecommendationModel) then) =
      _$FoodRecommendationModelCopyWithImpl<$Res, FoodRecommendationModel>;
  @useResult
  $Res call(
      {String foodName,
      String reason,
      RecommendationFrequency frequency,
      String servingSize,
      List<String> benefits});
}

/// @nodoc
class _$FoodRecommendationModelCopyWithImpl<$Res,
        $Val extends FoodRecommendationModel>
    implements $FoodRecommendationModelCopyWith<$Res> {
  _$FoodRecommendationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodRecommendationModel
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
abstract class _$$FoodRecommendationModelImplCopyWith<$Res>
    implements $FoodRecommendationModelCopyWith<$Res> {
  factory _$$FoodRecommendationModelImplCopyWith(
          _$FoodRecommendationModelImpl value,
          $Res Function(_$FoodRecommendationModelImpl) then) =
      __$$FoodRecommendationModelImplCopyWithImpl<$Res>;
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
class __$$FoodRecommendationModelImplCopyWithImpl<$Res>
    extends _$FoodRecommendationModelCopyWithImpl<$Res,
        _$FoodRecommendationModelImpl>
    implements _$$FoodRecommendationModelImplCopyWith<$Res> {
  __$$FoodRecommendationModelImplCopyWithImpl(
      _$FoodRecommendationModelImpl _value,
      $Res Function(_$FoodRecommendationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodRecommendationModel
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
    return _then(_$FoodRecommendationModelImpl(
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
class _$FoodRecommendationModelImpl implements _FoodRecommendationModel {
  const _$FoodRecommendationModelImpl(
      {required this.foodName,
      required this.reason,
      required this.frequency,
      this.servingSize = '',
      final List<String> benefits = const []})
      : _benefits = benefits;

  factory _$FoodRecommendationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodRecommendationModelImplFromJson(json);

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
    return 'FoodRecommendationModel(foodName: $foodName, reason: $reason, frequency: $frequency, servingSize: $servingSize, benefits: $benefits)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodRecommendationModelImpl &&
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

  /// Create a copy of FoodRecommendationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodRecommendationModelImplCopyWith<_$FoodRecommendationModelImpl>
      get copyWith => __$$FoodRecommendationModelImplCopyWithImpl<
          _$FoodRecommendationModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FoodRecommendationModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FoodRecommendationModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FoodRecommendationModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodRecommendationModelImplToJson(
      this,
    );
  }
}

abstract class _FoodRecommendationModel implements FoodRecommendationModel {
  const factory _FoodRecommendationModel(
      {required final String foodName,
      required final String reason,
      required final RecommendationFrequency frequency,
      final String servingSize,
      final List<String> benefits}) = _$FoodRecommendationModelImpl;

  factory _FoodRecommendationModel.fromJson(Map<String, dynamic> json) =
      _$FoodRecommendationModelImpl.fromJson;

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

  /// Create a copy of FoodRecommendationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodRecommendationModelImplCopyWith<_$FoodRecommendationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FoodRestrictionModel _$FoodRestrictionModelFromJson(Map<String, dynamic> json) {
  return _FoodRestrictionModel.fromJson(json);
}

/// @nodoc
mixin _$FoodRestrictionModel {
  String get foodName => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  RestrictionLevel get level => throw _privateConstructorUsedError;
  List<String> get alternatives => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FoodRestrictionModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FoodRestrictionModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FoodRestrictionModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this FoodRestrictionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodRestrictionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodRestrictionModelCopyWith<FoodRestrictionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodRestrictionModelCopyWith<$Res> {
  factory $FoodRestrictionModelCopyWith(FoodRestrictionModel value,
          $Res Function(FoodRestrictionModel) then) =
      _$FoodRestrictionModelCopyWithImpl<$Res, FoodRestrictionModel>;
  @useResult
  $Res call(
      {String foodName,
      String reason,
      RestrictionLevel level,
      List<String> alternatives});
}

/// @nodoc
class _$FoodRestrictionModelCopyWithImpl<$Res,
        $Val extends FoodRestrictionModel>
    implements $FoodRestrictionModelCopyWith<$Res> {
  _$FoodRestrictionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodRestrictionModel
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
abstract class _$$FoodRestrictionModelImplCopyWith<$Res>
    implements $FoodRestrictionModelCopyWith<$Res> {
  factory _$$FoodRestrictionModelImplCopyWith(_$FoodRestrictionModelImpl value,
          $Res Function(_$FoodRestrictionModelImpl) then) =
      __$$FoodRestrictionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String foodName,
      String reason,
      RestrictionLevel level,
      List<String> alternatives});
}

/// @nodoc
class __$$FoodRestrictionModelImplCopyWithImpl<$Res>
    extends _$FoodRestrictionModelCopyWithImpl<$Res, _$FoodRestrictionModelImpl>
    implements _$$FoodRestrictionModelImplCopyWith<$Res> {
  __$$FoodRestrictionModelImplCopyWithImpl(_$FoodRestrictionModelImpl _value,
      $Res Function(_$FoodRestrictionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodRestrictionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodName = null,
    Object? reason = null,
    Object? level = null,
    Object? alternatives = null,
  }) {
    return _then(_$FoodRestrictionModelImpl(
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
class _$FoodRestrictionModelImpl implements _FoodRestrictionModel {
  const _$FoodRestrictionModelImpl(
      {required this.foodName,
      required this.reason,
      required this.level,
      final List<String> alternatives = const []})
      : _alternatives = alternatives;

  factory _$FoodRestrictionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodRestrictionModelImplFromJson(json);

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
    return 'FoodRestrictionModel(foodName: $foodName, reason: $reason, level: $level, alternatives: $alternatives)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodRestrictionModelImpl &&
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

  /// Create a copy of FoodRestrictionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodRestrictionModelImplCopyWith<_$FoodRestrictionModelImpl>
      get copyWith =>
          __$$FoodRestrictionModelImplCopyWithImpl<_$FoodRestrictionModelImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FoodRestrictionModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FoodRestrictionModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FoodRestrictionModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodRestrictionModelImplToJson(
      this,
    );
  }
}

abstract class _FoodRestrictionModel implements FoodRestrictionModel {
  const factory _FoodRestrictionModel(
      {required final String foodName,
      required final String reason,
      required final RestrictionLevel level,
      final List<String> alternatives}) = _$FoodRestrictionModelImpl;

  factory _FoodRestrictionModel.fromJson(Map<String, dynamic> json) =
      _$FoodRestrictionModelImpl.fromJson;

  @override
  String get foodName;
  @override
  String get reason;
  @override
  RestrictionLevel get level;
  @override
  List<String> get alternatives;

  /// Create a copy of FoodRestrictionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodRestrictionModelImplCopyWith<_$FoodRestrictionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MealTimingModel _$MealTimingModelFromJson(Map<String, dynamic> json) {
  return _MealTimingModel.fromJson(json);
}

/// @nodoc
mixin _$MealTimingModel {
  String get breakfast => throw _privateConstructorUsedError;
  String get lunch => throw _privateConstructorUsedError;
  String get dinner => throw _privateConstructorUsedError;
  List<String> get snacks => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MealTimingModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MealTimingModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MealTimingModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MealTimingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealTimingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealTimingModelCopyWith<MealTimingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealTimingModelCopyWith<$Res> {
  factory $MealTimingModelCopyWith(
          MealTimingModel value, $Res Function(MealTimingModel) then) =
      _$MealTimingModelCopyWithImpl<$Res, MealTimingModel>;
  @useResult
  $Res call(
      {String breakfast,
      String lunch,
      String dinner,
      List<String> snacks,
      String notes});
}

/// @nodoc
class _$MealTimingModelCopyWithImpl<$Res, $Val extends MealTimingModel>
    implements $MealTimingModelCopyWith<$Res> {
  _$MealTimingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealTimingModel
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
abstract class _$$MealTimingModelImplCopyWith<$Res>
    implements $MealTimingModelCopyWith<$Res> {
  factory _$$MealTimingModelImplCopyWith(_$MealTimingModelImpl value,
          $Res Function(_$MealTimingModelImpl) then) =
      __$$MealTimingModelImplCopyWithImpl<$Res>;
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
class __$$MealTimingModelImplCopyWithImpl<$Res>
    extends _$MealTimingModelCopyWithImpl<$Res, _$MealTimingModelImpl>
    implements _$$MealTimingModelImplCopyWith<$Res> {
  __$$MealTimingModelImplCopyWithImpl(
      _$MealTimingModelImpl _value, $Res Function(_$MealTimingModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MealTimingModel
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
    return _then(_$MealTimingModelImpl(
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
class _$MealTimingModelImpl implements _MealTimingModel {
  const _$MealTimingModelImpl(
      {required this.breakfast,
      required this.lunch,
      required this.dinner,
      final List<String> snacks = const [],
      this.notes = ''})
      : _snacks = snacks;

  factory _$MealTimingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealTimingModelImplFromJson(json);

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
    return 'MealTimingModel(breakfast: $breakfast, lunch: $lunch, dinner: $dinner, snacks: $snacks, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealTimingModelImpl &&
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

  /// Create a copy of MealTimingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealTimingModelImplCopyWith<_$MealTimingModelImpl> get copyWith =>
      __$$MealTimingModelImplCopyWithImpl<_$MealTimingModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MealTimingModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MealTimingModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MealTimingModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MealTimingModelImplToJson(
      this,
    );
  }
}

abstract class _MealTimingModel implements MealTimingModel {
  const factory _MealTimingModel(
      {required final String breakfast,
      required final String lunch,
      required final String dinner,
      final List<String> snacks,
      final String notes}) = _$MealTimingModelImpl;

  factory _MealTimingModel.fromJson(Map<String, dynamic> json) =
      _$MealTimingModelImpl.fromJson;

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

  /// Create a copy of MealTimingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealTimingModelImplCopyWith<_$MealTimingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
