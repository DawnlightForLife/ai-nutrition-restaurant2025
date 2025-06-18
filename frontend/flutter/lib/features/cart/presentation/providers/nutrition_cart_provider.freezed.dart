// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrition_cart_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NutritionCartState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isAnalyzing => throw _privateConstructorUsedError;
  bool get isUpdating => throw _privateConstructorUsedError;
  NutritionCart? get cart => throw _privateConstructorUsedError;
  NutritionBalanceAnalysis? get analysis => throw _privateConstructorUsedError;
  List<RecommendedItem> get recommendations =>
      throw _privateConstructorUsedError;
  List<NutritionGoalTemplate> get goalTemplates =>
      throw _privateConstructorUsedError;
  List<String> get availableCoupons => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError; // UI状态
  bool get showNutritionPanel => throw _privateConstructorUsedError;
  bool get showRecommendations => throw _privateConstructorUsedError;
  String get currentView =>
      throw _privateConstructorUsedError; // cart, nutrition, recommendations
  String? get selectedMerchantId =>
      throw _privateConstructorUsedError; // 分析结果缓存
  DateTime? get lastAnalysisTime => throw _privateConstructorUsedError;
  Map<String, double> get nutritionGoals =>
      throw _privateConstructorUsedError; // 操作状态
  Map<String, bool> get itemUpdatingStatus =>
      throw _privateConstructorUsedError;
  List<String> get unavailableItems => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionCartState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionCartState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionCartState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of NutritionCartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionCartStateCopyWith<NutritionCartState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionCartStateCopyWith<$Res> {
  factory $NutritionCartStateCopyWith(
          NutritionCartState value, $Res Function(NutritionCartState) then) =
      _$NutritionCartStateCopyWithImpl<$Res, NutritionCartState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isAnalyzing,
      bool isUpdating,
      NutritionCart? cart,
      NutritionBalanceAnalysis? analysis,
      List<RecommendedItem> recommendations,
      List<NutritionGoalTemplate> goalTemplates,
      List<String> availableCoupons,
      String? error,
      bool showNutritionPanel,
      bool showRecommendations,
      String currentView,
      String? selectedMerchantId,
      DateTime? lastAnalysisTime,
      Map<String, double> nutritionGoals,
      Map<String, bool> itemUpdatingStatus,
      List<String> unavailableItems});

  $NutritionCartCopyWith<$Res>? get cart;
  $NutritionBalanceAnalysisCopyWith<$Res>? get analysis;
}

/// @nodoc
class _$NutritionCartStateCopyWithImpl<$Res, $Val extends NutritionCartState>
    implements $NutritionCartStateCopyWith<$Res> {
  _$NutritionCartStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionCartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isAnalyzing = null,
    Object? isUpdating = null,
    Object? cart = freezed,
    Object? analysis = freezed,
    Object? recommendations = null,
    Object? goalTemplates = null,
    Object? availableCoupons = null,
    Object? error = freezed,
    Object? showNutritionPanel = null,
    Object? showRecommendations = null,
    Object? currentView = null,
    Object? selectedMerchantId = freezed,
    Object? lastAnalysisTime = freezed,
    Object? nutritionGoals = null,
    Object? itemUpdatingStatus = null,
    Object? unavailableItems = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isAnalyzing: null == isAnalyzing
          ? _value.isAnalyzing
          : isAnalyzing // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      cart: freezed == cart
          ? _value.cart
          : cart // ignore: cast_nullable_to_non_nullable
              as NutritionCart?,
      analysis: freezed == analysis
          ? _value.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as NutritionBalanceAnalysis?,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<RecommendedItem>,
      goalTemplates: null == goalTemplates
          ? _value.goalTemplates
          : goalTemplates // ignore: cast_nullable_to_non_nullable
              as List<NutritionGoalTemplate>,
      availableCoupons: null == availableCoupons
          ? _value.availableCoupons
          : availableCoupons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      showNutritionPanel: null == showNutritionPanel
          ? _value.showNutritionPanel
          : showNutritionPanel // ignore: cast_nullable_to_non_nullable
              as bool,
      showRecommendations: null == showRecommendations
          ? _value.showRecommendations
          : showRecommendations // ignore: cast_nullable_to_non_nullable
              as bool,
      currentView: null == currentView
          ? _value.currentView
          : currentView // ignore: cast_nullable_to_non_nullable
              as String,
      selectedMerchantId: freezed == selectedMerchantId
          ? _value.selectedMerchantId
          : selectedMerchantId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastAnalysisTime: freezed == lastAnalysisTime
          ? _value.lastAnalysisTime
          : lastAnalysisTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nutritionGoals: null == nutritionGoals
          ? _value.nutritionGoals
          : nutritionGoals // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      itemUpdatingStatus: null == itemUpdatingStatus
          ? _value.itemUpdatingStatus
          : itemUpdatingStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      unavailableItems: null == unavailableItems
          ? _value.unavailableItems
          : unavailableItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  /// Create a copy of NutritionCartState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionCartCopyWith<$Res>? get cart {
    if (_value.cart == null) {
      return null;
    }

    return $NutritionCartCopyWith<$Res>(_value.cart!, (value) {
      return _then(_value.copyWith(cart: value) as $Val);
    });
  }

  /// Create a copy of NutritionCartState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionBalanceAnalysisCopyWith<$Res>? get analysis {
    if (_value.analysis == null) {
      return null;
    }

    return $NutritionBalanceAnalysisCopyWith<$Res>(_value.analysis!, (value) {
      return _then(_value.copyWith(analysis: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionCartStateImplCopyWith<$Res>
    implements $NutritionCartStateCopyWith<$Res> {
  factory _$$NutritionCartStateImplCopyWith(_$NutritionCartStateImpl value,
          $Res Function(_$NutritionCartStateImpl) then) =
      __$$NutritionCartStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isAnalyzing,
      bool isUpdating,
      NutritionCart? cart,
      NutritionBalanceAnalysis? analysis,
      List<RecommendedItem> recommendations,
      List<NutritionGoalTemplate> goalTemplates,
      List<String> availableCoupons,
      String? error,
      bool showNutritionPanel,
      bool showRecommendations,
      String currentView,
      String? selectedMerchantId,
      DateTime? lastAnalysisTime,
      Map<String, double> nutritionGoals,
      Map<String, bool> itemUpdatingStatus,
      List<String> unavailableItems});

  @override
  $NutritionCartCopyWith<$Res>? get cart;
  @override
  $NutritionBalanceAnalysisCopyWith<$Res>? get analysis;
}

/// @nodoc
class __$$NutritionCartStateImplCopyWithImpl<$Res>
    extends _$NutritionCartStateCopyWithImpl<$Res, _$NutritionCartStateImpl>
    implements _$$NutritionCartStateImplCopyWith<$Res> {
  __$$NutritionCartStateImplCopyWithImpl(_$NutritionCartStateImpl _value,
      $Res Function(_$NutritionCartStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionCartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isAnalyzing = null,
    Object? isUpdating = null,
    Object? cart = freezed,
    Object? analysis = freezed,
    Object? recommendations = null,
    Object? goalTemplates = null,
    Object? availableCoupons = null,
    Object? error = freezed,
    Object? showNutritionPanel = null,
    Object? showRecommendations = null,
    Object? currentView = null,
    Object? selectedMerchantId = freezed,
    Object? lastAnalysisTime = freezed,
    Object? nutritionGoals = null,
    Object? itemUpdatingStatus = null,
    Object? unavailableItems = null,
  }) {
    return _then(_$NutritionCartStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isAnalyzing: null == isAnalyzing
          ? _value.isAnalyzing
          : isAnalyzing // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      cart: freezed == cart
          ? _value.cart
          : cart // ignore: cast_nullable_to_non_nullable
              as NutritionCart?,
      analysis: freezed == analysis
          ? _value.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as NutritionBalanceAnalysis?,
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<RecommendedItem>,
      goalTemplates: null == goalTemplates
          ? _value._goalTemplates
          : goalTemplates // ignore: cast_nullable_to_non_nullable
              as List<NutritionGoalTemplate>,
      availableCoupons: null == availableCoupons
          ? _value._availableCoupons
          : availableCoupons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      showNutritionPanel: null == showNutritionPanel
          ? _value.showNutritionPanel
          : showNutritionPanel // ignore: cast_nullable_to_non_nullable
              as bool,
      showRecommendations: null == showRecommendations
          ? _value.showRecommendations
          : showRecommendations // ignore: cast_nullable_to_non_nullable
              as bool,
      currentView: null == currentView
          ? _value.currentView
          : currentView // ignore: cast_nullable_to_non_nullable
              as String,
      selectedMerchantId: freezed == selectedMerchantId
          ? _value.selectedMerchantId
          : selectedMerchantId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastAnalysisTime: freezed == lastAnalysisTime
          ? _value.lastAnalysisTime
          : lastAnalysisTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nutritionGoals: null == nutritionGoals
          ? _value._nutritionGoals
          : nutritionGoals // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      itemUpdatingStatus: null == itemUpdatingStatus
          ? _value._itemUpdatingStatus
          : itemUpdatingStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      unavailableItems: null == unavailableItems
          ? _value._unavailableItems
          : unavailableItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$NutritionCartStateImpl implements _NutritionCartState {
  const _$NutritionCartStateImpl(
      {this.isLoading = false,
      this.isAnalyzing = false,
      this.isUpdating = false,
      this.cart,
      this.analysis,
      final List<RecommendedItem> recommendations = const [],
      final List<NutritionGoalTemplate> goalTemplates = const [],
      final List<String> availableCoupons = const [],
      this.error,
      this.showNutritionPanel = false,
      this.showRecommendations = false,
      this.currentView = 'cart',
      this.selectedMerchantId,
      this.lastAnalysisTime,
      final Map<String, double> nutritionGoals = const {},
      final Map<String, bool> itemUpdatingStatus = const {},
      final List<String> unavailableItems = const []})
      : _recommendations = recommendations,
        _goalTemplates = goalTemplates,
        _availableCoupons = availableCoupons,
        _nutritionGoals = nutritionGoals,
        _itemUpdatingStatus = itemUpdatingStatus,
        _unavailableItems = unavailableItems;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isAnalyzing;
  @override
  @JsonKey()
  final bool isUpdating;
  @override
  final NutritionCart? cart;
  @override
  final NutritionBalanceAnalysis? analysis;
  final List<RecommendedItem> _recommendations;
  @override
  @JsonKey()
  List<RecommendedItem> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  final List<NutritionGoalTemplate> _goalTemplates;
  @override
  @JsonKey()
  List<NutritionGoalTemplate> get goalTemplates {
    if (_goalTemplates is EqualUnmodifiableListView) return _goalTemplates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_goalTemplates);
  }

  final List<String> _availableCoupons;
  @override
  @JsonKey()
  List<String> get availableCoupons {
    if (_availableCoupons is EqualUnmodifiableListView)
      return _availableCoupons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableCoupons);
  }

  @override
  final String? error;
// UI状态
  @override
  @JsonKey()
  final bool showNutritionPanel;
  @override
  @JsonKey()
  final bool showRecommendations;
  @override
  @JsonKey()
  final String currentView;
// cart, nutrition, recommendations
  @override
  final String? selectedMerchantId;
// 分析结果缓存
  @override
  final DateTime? lastAnalysisTime;
  final Map<String, double> _nutritionGoals;
  @override
  @JsonKey()
  Map<String, double> get nutritionGoals {
    if (_nutritionGoals is EqualUnmodifiableMapView) return _nutritionGoals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionGoals);
  }

// 操作状态
  final Map<String, bool> _itemUpdatingStatus;
// 操作状态
  @override
  @JsonKey()
  Map<String, bool> get itemUpdatingStatus {
    if (_itemUpdatingStatus is EqualUnmodifiableMapView)
      return _itemUpdatingStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_itemUpdatingStatus);
  }

  final List<String> _unavailableItems;
  @override
  @JsonKey()
  List<String> get unavailableItems {
    if (_unavailableItems is EqualUnmodifiableListView)
      return _unavailableItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unavailableItems);
  }

  @override
  String toString() {
    return 'NutritionCartState(isLoading: $isLoading, isAnalyzing: $isAnalyzing, isUpdating: $isUpdating, cart: $cart, analysis: $analysis, recommendations: $recommendations, goalTemplates: $goalTemplates, availableCoupons: $availableCoupons, error: $error, showNutritionPanel: $showNutritionPanel, showRecommendations: $showRecommendations, currentView: $currentView, selectedMerchantId: $selectedMerchantId, lastAnalysisTime: $lastAnalysisTime, nutritionGoals: $nutritionGoals, itemUpdatingStatus: $itemUpdatingStatus, unavailableItems: $unavailableItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionCartStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isAnalyzing, isAnalyzing) ||
                other.isAnalyzing == isAnalyzing) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating) &&
            (identical(other.cart, cart) || other.cart == cart) &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            const DeepCollectionEquality()
                .equals(other._goalTemplates, _goalTemplates) &&
            const DeepCollectionEquality()
                .equals(other._availableCoupons, _availableCoupons) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.showNutritionPanel, showNutritionPanel) ||
                other.showNutritionPanel == showNutritionPanel) &&
            (identical(other.showRecommendations, showRecommendations) ||
                other.showRecommendations == showRecommendations) &&
            (identical(other.currentView, currentView) ||
                other.currentView == currentView) &&
            (identical(other.selectedMerchantId, selectedMerchantId) ||
                other.selectedMerchantId == selectedMerchantId) &&
            (identical(other.lastAnalysisTime, lastAnalysisTime) ||
                other.lastAnalysisTime == lastAnalysisTime) &&
            const DeepCollectionEquality()
                .equals(other._nutritionGoals, _nutritionGoals) &&
            const DeepCollectionEquality()
                .equals(other._itemUpdatingStatus, _itemUpdatingStatus) &&
            const DeepCollectionEquality()
                .equals(other._unavailableItems, _unavailableItems));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isAnalyzing,
      isUpdating,
      cart,
      analysis,
      const DeepCollectionEquality().hash(_recommendations),
      const DeepCollectionEquality().hash(_goalTemplates),
      const DeepCollectionEquality().hash(_availableCoupons),
      error,
      showNutritionPanel,
      showRecommendations,
      currentView,
      selectedMerchantId,
      lastAnalysisTime,
      const DeepCollectionEquality().hash(_nutritionGoals),
      const DeepCollectionEquality().hash(_itemUpdatingStatus),
      const DeepCollectionEquality().hash(_unavailableItems));

  /// Create a copy of NutritionCartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionCartStateImplCopyWith<_$NutritionCartStateImpl> get copyWith =>
      __$$NutritionCartStateImplCopyWithImpl<_$NutritionCartStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionCartState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionCartState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionCartState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _NutritionCartState implements NutritionCartState {
  const factory _NutritionCartState(
      {final bool isLoading,
      final bool isAnalyzing,
      final bool isUpdating,
      final NutritionCart? cart,
      final NutritionBalanceAnalysis? analysis,
      final List<RecommendedItem> recommendations,
      final List<NutritionGoalTemplate> goalTemplates,
      final List<String> availableCoupons,
      final String? error,
      final bool showNutritionPanel,
      final bool showRecommendations,
      final String currentView,
      final String? selectedMerchantId,
      final DateTime? lastAnalysisTime,
      final Map<String, double> nutritionGoals,
      final Map<String, bool> itemUpdatingStatus,
      final List<String> unavailableItems}) = _$NutritionCartStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isAnalyzing;
  @override
  bool get isUpdating;
  @override
  NutritionCart? get cart;
  @override
  NutritionBalanceAnalysis? get analysis;
  @override
  List<RecommendedItem> get recommendations;
  @override
  List<NutritionGoalTemplate> get goalTemplates;
  @override
  List<String> get availableCoupons;
  @override
  String? get error; // UI状态
  @override
  bool get showNutritionPanel;
  @override
  bool get showRecommendations;
  @override
  String get currentView; // cart, nutrition, recommendations
  @override
  String? get selectedMerchantId; // 分析结果缓存
  @override
  DateTime? get lastAnalysisTime;
  @override
  Map<String, double> get nutritionGoals; // 操作状态
  @override
  Map<String, bool> get itemUpdatingStatus;
  @override
  List<String> get unavailableItems;

  /// Create a copy of NutritionCartState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionCartStateImplCopyWith<_$NutritionCartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
