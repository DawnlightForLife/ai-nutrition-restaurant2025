// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrition_ordering_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NutritionOrderingState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<NutritionElement> get nutritionElements =>
      throw _privateConstructorUsedError;
  List<IngredientNutrition> get ingredients =>
      throw _privateConstructorUsedError;
  List<CookingMethod> get cookingMethods => throw _privateConstructorUsedError;
  List<OrderingSelection> get selections => throw _privateConstructorUsedError;
  NutritionNeedsAnalysis? get nutritionNeeds =>
      throw _privateConstructorUsedError;
  NutritionBalanceAnalysis? get balanceAnalysis =>
      throw _privateConstructorUsedError;
  List<IngredientRecommendation> get recommendations =>
      throw _privateConstructorUsedError;
  NutritionScore? get nutritionScore => throw _privateConstructorUsedError;
  Map<String, dynamic>? get constants => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  Map<String, List<NutritionElement>> get elementsByCategory =>
      throw _privateConstructorUsedError;
  Map<String, List<IngredientNutrition>> get ingredientsByCategory =>
      throw _privateConstructorUsedError;
  Map<String, List<CookingMethod>> get cookingMethodsByCategory =>
      throw _privateConstructorUsedError;
  Map<String, double> get currentNutritionIntake =>
      throw _privateConstructorUsedError;
  Map<String, double> get targetNutritionIntake =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionOrderingState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionOrderingState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionOrderingState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of NutritionOrderingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionOrderingStateCopyWith<NutritionOrderingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionOrderingStateCopyWith<$Res> {
  factory $NutritionOrderingStateCopyWith(NutritionOrderingState value,
          $Res Function(NutritionOrderingState) then) =
      _$NutritionOrderingStateCopyWithImpl<$Res, NutritionOrderingState>;
  @useResult
  $Res call(
      {bool isLoading,
      List<NutritionElement> nutritionElements,
      List<IngredientNutrition> ingredients,
      List<CookingMethod> cookingMethods,
      List<OrderingSelection> selections,
      NutritionNeedsAnalysis? nutritionNeeds,
      NutritionBalanceAnalysis? balanceAnalysis,
      List<IngredientRecommendation> recommendations,
      NutritionScore? nutritionScore,
      Map<String, dynamic>? constants,
      String? errorMessage,
      Map<String, List<NutritionElement>> elementsByCategory,
      Map<String, List<IngredientNutrition>> ingredientsByCategory,
      Map<String, List<CookingMethod>> cookingMethodsByCategory,
      Map<String, double> currentNutritionIntake,
      Map<String, double> targetNutritionIntake});

  $NutritionNeedsAnalysisCopyWith<$Res>? get nutritionNeeds;
  $NutritionBalanceAnalysisCopyWith<$Res>? get balanceAnalysis;
  $NutritionScoreCopyWith<$Res>? get nutritionScore;
}

/// @nodoc
class _$NutritionOrderingStateCopyWithImpl<$Res,
        $Val extends NutritionOrderingState>
    implements $NutritionOrderingStateCopyWith<$Res> {
  _$NutritionOrderingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionOrderingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? nutritionElements = null,
    Object? ingredients = null,
    Object? cookingMethods = null,
    Object? selections = null,
    Object? nutritionNeeds = freezed,
    Object? balanceAnalysis = freezed,
    Object? recommendations = null,
    Object? nutritionScore = freezed,
    Object? constants = freezed,
    Object? errorMessage = freezed,
    Object? elementsByCategory = null,
    Object? ingredientsByCategory = null,
    Object? cookingMethodsByCategory = null,
    Object? currentNutritionIntake = null,
    Object? targetNutritionIntake = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      nutritionElements: null == nutritionElements
          ? _value.nutritionElements
          : nutritionElements // ignore: cast_nullable_to_non_nullable
              as List<NutritionElement>,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<IngredientNutrition>,
      cookingMethods: null == cookingMethods
          ? _value.cookingMethods
          : cookingMethods // ignore: cast_nullable_to_non_nullable
              as List<CookingMethod>,
      selections: null == selections
          ? _value.selections
          : selections // ignore: cast_nullable_to_non_nullable
              as List<OrderingSelection>,
      nutritionNeeds: freezed == nutritionNeeds
          ? _value.nutritionNeeds
          : nutritionNeeds // ignore: cast_nullable_to_non_nullable
              as NutritionNeedsAnalysis?,
      balanceAnalysis: freezed == balanceAnalysis
          ? _value.balanceAnalysis
          : balanceAnalysis // ignore: cast_nullable_to_non_nullable
              as NutritionBalanceAnalysis?,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<IngredientRecommendation>,
      nutritionScore: freezed == nutritionScore
          ? _value.nutritionScore
          : nutritionScore // ignore: cast_nullable_to_non_nullable
              as NutritionScore?,
      constants: freezed == constants
          ? _value.constants
          : constants // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      elementsByCategory: null == elementsByCategory
          ? _value.elementsByCategory
          : elementsByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, List<NutritionElement>>,
      ingredientsByCategory: null == ingredientsByCategory
          ? _value.ingredientsByCategory
          : ingredientsByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, List<IngredientNutrition>>,
      cookingMethodsByCategory: null == cookingMethodsByCategory
          ? _value.cookingMethodsByCategory
          : cookingMethodsByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, List<CookingMethod>>,
      currentNutritionIntake: null == currentNutritionIntake
          ? _value.currentNutritionIntake
          : currentNutritionIntake // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      targetNutritionIntake: null == targetNutritionIntake
          ? _value.targetNutritionIntake
          : targetNutritionIntake // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ) as $Val);
  }

  /// Create a copy of NutritionOrderingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionNeedsAnalysisCopyWith<$Res>? get nutritionNeeds {
    if (_value.nutritionNeeds == null) {
      return null;
    }

    return $NutritionNeedsAnalysisCopyWith<$Res>(_value.nutritionNeeds!,
        (value) {
      return _then(_value.copyWith(nutritionNeeds: value) as $Val);
    });
  }

  /// Create a copy of NutritionOrderingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionBalanceAnalysisCopyWith<$Res>? get balanceAnalysis {
    if (_value.balanceAnalysis == null) {
      return null;
    }

    return $NutritionBalanceAnalysisCopyWith<$Res>(_value.balanceAnalysis!,
        (value) {
      return _then(_value.copyWith(balanceAnalysis: value) as $Val);
    });
  }

  /// Create a copy of NutritionOrderingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionScoreCopyWith<$Res>? get nutritionScore {
    if (_value.nutritionScore == null) {
      return null;
    }

    return $NutritionScoreCopyWith<$Res>(_value.nutritionScore!, (value) {
      return _then(_value.copyWith(nutritionScore: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionOrderingStateImplCopyWith<$Res>
    implements $NutritionOrderingStateCopyWith<$Res> {
  factory _$$NutritionOrderingStateImplCopyWith(
          _$NutritionOrderingStateImpl value,
          $Res Function(_$NutritionOrderingStateImpl) then) =
      __$$NutritionOrderingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      List<NutritionElement> nutritionElements,
      List<IngredientNutrition> ingredients,
      List<CookingMethod> cookingMethods,
      List<OrderingSelection> selections,
      NutritionNeedsAnalysis? nutritionNeeds,
      NutritionBalanceAnalysis? balanceAnalysis,
      List<IngredientRecommendation> recommendations,
      NutritionScore? nutritionScore,
      Map<String, dynamic>? constants,
      String? errorMessage,
      Map<String, List<NutritionElement>> elementsByCategory,
      Map<String, List<IngredientNutrition>> ingredientsByCategory,
      Map<String, List<CookingMethod>> cookingMethodsByCategory,
      Map<String, double> currentNutritionIntake,
      Map<String, double> targetNutritionIntake});

  @override
  $NutritionNeedsAnalysisCopyWith<$Res>? get nutritionNeeds;
  @override
  $NutritionBalanceAnalysisCopyWith<$Res>? get balanceAnalysis;
  @override
  $NutritionScoreCopyWith<$Res>? get nutritionScore;
}

/// @nodoc
class __$$NutritionOrderingStateImplCopyWithImpl<$Res>
    extends _$NutritionOrderingStateCopyWithImpl<$Res,
        _$NutritionOrderingStateImpl>
    implements _$$NutritionOrderingStateImplCopyWith<$Res> {
  __$$NutritionOrderingStateImplCopyWithImpl(
      _$NutritionOrderingStateImpl _value,
      $Res Function(_$NutritionOrderingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionOrderingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? nutritionElements = null,
    Object? ingredients = null,
    Object? cookingMethods = null,
    Object? selections = null,
    Object? nutritionNeeds = freezed,
    Object? balanceAnalysis = freezed,
    Object? recommendations = null,
    Object? nutritionScore = freezed,
    Object? constants = freezed,
    Object? errorMessage = freezed,
    Object? elementsByCategory = null,
    Object? ingredientsByCategory = null,
    Object? cookingMethodsByCategory = null,
    Object? currentNutritionIntake = null,
    Object? targetNutritionIntake = null,
  }) {
    return _then(_$NutritionOrderingStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      nutritionElements: null == nutritionElements
          ? _value._nutritionElements
          : nutritionElements // ignore: cast_nullable_to_non_nullable
              as List<NutritionElement>,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<IngredientNutrition>,
      cookingMethods: null == cookingMethods
          ? _value._cookingMethods
          : cookingMethods // ignore: cast_nullable_to_non_nullable
              as List<CookingMethod>,
      selections: null == selections
          ? _value._selections
          : selections // ignore: cast_nullable_to_non_nullable
              as List<OrderingSelection>,
      nutritionNeeds: freezed == nutritionNeeds
          ? _value.nutritionNeeds
          : nutritionNeeds // ignore: cast_nullable_to_non_nullable
              as NutritionNeedsAnalysis?,
      balanceAnalysis: freezed == balanceAnalysis
          ? _value.balanceAnalysis
          : balanceAnalysis // ignore: cast_nullable_to_non_nullable
              as NutritionBalanceAnalysis?,
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<IngredientRecommendation>,
      nutritionScore: freezed == nutritionScore
          ? _value.nutritionScore
          : nutritionScore // ignore: cast_nullable_to_non_nullable
              as NutritionScore?,
      constants: freezed == constants
          ? _value._constants
          : constants // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      elementsByCategory: null == elementsByCategory
          ? _value._elementsByCategory
          : elementsByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, List<NutritionElement>>,
      ingredientsByCategory: null == ingredientsByCategory
          ? _value._ingredientsByCategory
          : ingredientsByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, List<IngredientNutrition>>,
      cookingMethodsByCategory: null == cookingMethodsByCategory
          ? _value._cookingMethodsByCategory
          : cookingMethodsByCategory // ignore: cast_nullable_to_non_nullable
              as Map<String, List<CookingMethod>>,
      currentNutritionIntake: null == currentNutritionIntake
          ? _value._currentNutritionIntake
          : currentNutritionIntake // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      targetNutritionIntake: null == targetNutritionIntake
          ? _value._targetNutritionIntake
          : targetNutritionIntake // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ));
  }
}

/// @nodoc

class _$NutritionOrderingStateImpl implements _NutritionOrderingState {
  const _$NutritionOrderingStateImpl(
      {this.isLoading = false,
      final List<NutritionElement> nutritionElements = const [],
      final List<IngredientNutrition> ingredients = const [],
      final List<CookingMethod> cookingMethods = const [],
      final List<OrderingSelection> selections = const [],
      this.nutritionNeeds,
      this.balanceAnalysis,
      final List<IngredientRecommendation> recommendations = const [],
      this.nutritionScore,
      final Map<String, dynamic>? constants,
      this.errorMessage,
      final Map<String, List<NutritionElement>> elementsByCategory = const {},
      final Map<String, List<IngredientNutrition>> ingredientsByCategory =
          const {},
      final Map<String, List<CookingMethod>> cookingMethodsByCategory =
          const {},
      final Map<String, double> currentNutritionIntake = const {},
      final Map<String, double> targetNutritionIntake = const {}})
      : _nutritionElements = nutritionElements,
        _ingredients = ingredients,
        _cookingMethods = cookingMethods,
        _selections = selections,
        _recommendations = recommendations,
        _constants = constants,
        _elementsByCategory = elementsByCategory,
        _ingredientsByCategory = ingredientsByCategory,
        _cookingMethodsByCategory = cookingMethodsByCategory,
        _currentNutritionIntake = currentNutritionIntake,
        _targetNutritionIntake = targetNutritionIntake;

  @override
  @JsonKey()
  final bool isLoading;
  final List<NutritionElement> _nutritionElements;
  @override
  @JsonKey()
  List<NutritionElement> get nutritionElements {
    if (_nutritionElements is EqualUnmodifiableListView)
      return _nutritionElements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionElements);
  }

  final List<IngredientNutrition> _ingredients;
  @override
  @JsonKey()
  List<IngredientNutrition> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  final List<CookingMethod> _cookingMethods;
  @override
  @JsonKey()
  List<CookingMethod> get cookingMethods {
    if (_cookingMethods is EqualUnmodifiableListView) return _cookingMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cookingMethods);
  }

  final List<OrderingSelection> _selections;
  @override
  @JsonKey()
  List<OrderingSelection> get selections {
    if (_selections is EqualUnmodifiableListView) return _selections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selections);
  }

  @override
  final NutritionNeedsAnalysis? nutritionNeeds;
  @override
  final NutritionBalanceAnalysis? balanceAnalysis;
  final List<IngredientRecommendation> _recommendations;
  @override
  @JsonKey()
  List<IngredientRecommendation> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  final NutritionScore? nutritionScore;
  final Map<String, dynamic>? _constants;
  @override
  Map<String, dynamic>? get constants {
    final value = _constants;
    if (value == null) return null;
    if (_constants is EqualUnmodifiableMapView) return _constants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? errorMessage;
  final Map<String, List<NutritionElement>> _elementsByCategory;
  @override
  @JsonKey()
  Map<String, List<NutritionElement>> get elementsByCategory {
    if (_elementsByCategory is EqualUnmodifiableMapView)
      return _elementsByCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_elementsByCategory);
  }

  final Map<String, List<IngredientNutrition>> _ingredientsByCategory;
  @override
  @JsonKey()
  Map<String, List<IngredientNutrition>> get ingredientsByCategory {
    if (_ingredientsByCategory is EqualUnmodifiableMapView)
      return _ingredientsByCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ingredientsByCategory);
  }

  final Map<String, List<CookingMethod>> _cookingMethodsByCategory;
  @override
  @JsonKey()
  Map<String, List<CookingMethod>> get cookingMethodsByCategory {
    if (_cookingMethodsByCategory is EqualUnmodifiableMapView)
      return _cookingMethodsByCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_cookingMethodsByCategory);
  }

  final Map<String, double> _currentNutritionIntake;
  @override
  @JsonKey()
  Map<String, double> get currentNutritionIntake {
    if (_currentNutritionIntake is EqualUnmodifiableMapView)
      return _currentNutritionIntake;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_currentNutritionIntake);
  }

  final Map<String, double> _targetNutritionIntake;
  @override
  @JsonKey()
  Map<String, double> get targetNutritionIntake {
    if (_targetNutritionIntake is EqualUnmodifiableMapView)
      return _targetNutritionIntake;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_targetNutritionIntake);
  }

  @override
  String toString() {
    return 'NutritionOrderingState(isLoading: $isLoading, nutritionElements: $nutritionElements, ingredients: $ingredients, cookingMethods: $cookingMethods, selections: $selections, nutritionNeeds: $nutritionNeeds, balanceAnalysis: $balanceAnalysis, recommendations: $recommendations, nutritionScore: $nutritionScore, constants: $constants, errorMessage: $errorMessage, elementsByCategory: $elementsByCategory, ingredientsByCategory: $ingredientsByCategory, cookingMethodsByCategory: $cookingMethodsByCategory, currentNutritionIntake: $currentNutritionIntake, targetNutritionIntake: $targetNutritionIntake)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionOrderingStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._nutritionElements, _nutritionElements) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            const DeepCollectionEquality()
                .equals(other._cookingMethods, _cookingMethods) &&
            const DeepCollectionEquality()
                .equals(other._selections, _selections) &&
            (identical(other.nutritionNeeds, nutritionNeeds) ||
                other.nutritionNeeds == nutritionNeeds) &&
            (identical(other.balanceAnalysis, balanceAnalysis) ||
                other.balanceAnalysis == balanceAnalysis) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            (identical(other.nutritionScore, nutritionScore) ||
                other.nutritionScore == nutritionScore) &&
            const DeepCollectionEquality()
                .equals(other._constants, _constants) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._elementsByCategory, _elementsByCategory) &&
            const DeepCollectionEquality()
                .equals(other._ingredientsByCategory, _ingredientsByCategory) &&
            const DeepCollectionEquality().equals(
                other._cookingMethodsByCategory, _cookingMethodsByCategory) &&
            const DeepCollectionEquality().equals(
                other._currentNutritionIntake, _currentNutritionIntake) &&
            const DeepCollectionEquality()
                .equals(other._targetNutritionIntake, _targetNutritionIntake));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(_nutritionElements),
      const DeepCollectionEquality().hash(_ingredients),
      const DeepCollectionEquality().hash(_cookingMethods),
      const DeepCollectionEquality().hash(_selections),
      nutritionNeeds,
      balanceAnalysis,
      const DeepCollectionEquality().hash(_recommendations),
      nutritionScore,
      const DeepCollectionEquality().hash(_constants),
      errorMessage,
      const DeepCollectionEquality().hash(_elementsByCategory),
      const DeepCollectionEquality().hash(_ingredientsByCategory),
      const DeepCollectionEquality().hash(_cookingMethodsByCategory),
      const DeepCollectionEquality().hash(_currentNutritionIntake),
      const DeepCollectionEquality().hash(_targetNutritionIntake));

  /// Create a copy of NutritionOrderingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionOrderingStateImplCopyWith<_$NutritionOrderingStateImpl>
      get copyWith => __$$NutritionOrderingStateImplCopyWithImpl<
          _$NutritionOrderingStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionOrderingState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionOrderingState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionOrderingState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _NutritionOrderingState implements NutritionOrderingState {
  const factory _NutritionOrderingState(
          {final bool isLoading,
          final List<NutritionElement> nutritionElements,
          final List<IngredientNutrition> ingredients,
          final List<CookingMethod> cookingMethods,
          final List<OrderingSelection> selections,
          final NutritionNeedsAnalysis? nutritionNeeds,
          final NutritionBalanceAnalysis? balanceAnalysis,
          final List<IngredientRecommendation> recommendations,
          final NutritionScore? nutritionScore,
          final Map<String, dynamic>? constants,
          final String? errorMessage,
          final Map<String, List<NutritionElement>> elementsByCategory,
          final Map<String, List<IngredientNutrition>> ingredientsByCategory,
          final Map<String, List<CookingMethod>> cookingMethodsByCategory,
          final Map<String, double> currentNutritionIntake,
          final Map<String, double> targetNutritionIntake}) =
      _$NutritionOrderingStateImpl;

  @override
  bool get isLoading;
  @override
  List<NutritionElement> get nutritionElements;
  @override
  List<IngredientNutrition> get ingredients;
  @override
  List<CookingMethod> get cookingMethods;
  @override
  List<OrderingSelection> get selections;
  @override
  NutritionNeedsAnalysis? get nutritionNeeds;
  @override
  NutritionBalanceAnalysis? get balanceAnalysis;
  @override
  List<IngredientRecommendation> get recommendations;
  @override
  NutritionScore? get nutritionScore;
  @override
  Map<String, dynamic>? get constants;
  @override
  String? get errorMessage;
  @override
  Map<String, List<NutritionElement>> get elementsByCategory;
  @override
  Map<String, List<IngredientNutrition>> get ingredientsByCategory;
  @override
  Map<String, List<CookingMethod>> get cookingMethodsByCategory;
  @override
  Map<String, double> get currentNutritionIntake;
  @override
  Map<String, double> get targetNutritionIntake;

  /// Create a copy of NutritionOrderingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionOrderingStateImplCopyWith<_$NutritionOrderingStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
