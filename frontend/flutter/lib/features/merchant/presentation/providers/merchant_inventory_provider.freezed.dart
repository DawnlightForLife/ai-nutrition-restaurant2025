// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchant_inventory_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MerchantInventoryState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isUpdating => throw _privateConstructorUsedError;
  List<IngredientInventoryItem> get ingredients =>
      throw _privateConstructorUsedError;
  List<CookingMethodConfig> get cookingMethods =>
      throw _privateConstructorUsedError;
  List<NutritionBasedDish> get nutritionDishes =>
      throw _privateConstructorUsedError;
  List<InventoryAlert> get alerts => throw _privateConstructorUsedError;
  List<InventoryTransaction> get transactions =>
      throw _privateConstructorUsedError;
  NutritionMenuAnalysis? get nutritionAnalysis =>
      throw _privateConstructorUsedError;
  MerchantInfo? get merchantInfo => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError; // 筛选和搜索状态
  String get searchQuery => throw _privateConstructorUsedError;
  String? get selectedCategory => throw _privateConstructorUsedError;
  bool get showLowStockOnly => throw _privateConstructorUsedError;
  bool get showAvailableOnly => throw _privateConstructorUsedError; // 选中的项目
  List<String> get selectedIngredientIds => throw _privateConstructorUsedError;
  String? get selectedDishId => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MerchantInventoryState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MerchantInventoryState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MerchantInventoryState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of MerchantInventoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MerchantInventoryStateCopyWith<MerchantInventoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MerchantInventoryStateCopyWith<$Res> {
  factory $MerchantInventoryStateCopyWith(MerchantInventoryState value,
          $Res Function(MerchantInventoryState) then) =
      _$MerchantInventoryStateCopyWithImpl<$Res, MerchantInventoryState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isUpdating,
      List<IngredientInventoryItem> ingredients,
      List<CookingMethodConfig> cookingMethods,
      List<NutritionBasedDish> nutritionDishes,
      List<InventoryAlert> alerts,
      List<InventoryTransaction> transactions,
      NutritionMenuAnalysis? nutritionAnalysis,
      MerchantInfo? merchantInfo,
      String? error,
      String searchQuery,
      String? selectedCategory,
      bool showLowStockOnly,
      bool showAvailableOnly,
      List<String> selectedIngredientIds,
      String? selectedDishId});

  $NutritionMenuAnalysisCopyWith<$Res>? get nutritionAnalysis;
  $MerchantInfoCopyWith<$Res>? get merchantInfo;
}

/// @nodoc
class _$MerchantInventoryStateCopyWithImpl<$Res,
        $Val extends MerchantInventoryState>
    implements $MerchantInventoryStateCopyWith<$Res> {
  _$MerchantInventoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MerchantInventoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isUpdating = null,
    Object? ingredients = null,
    Object? cookingMethods = null,
    Object? nutritionDishes = null,
    Object? alerts = null,
    Object? transactions = null,
    Object? nutritionAnalysis = freezed,
    Object? merchantInfo = freezed,
    Object? error = freezed,
    Object? searchQuery = null,
    Object? selectedCategory = freezed,
    Object? showLowStockOnly = null,
    Object? showAvailableOnly = null,
    Object? selectedIngredientIds = null,
    Object? selectedDishId = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<IngredientInventoryItem>,
      cookingMethods: null == cookingMethods
          ? _value.cookingMethods
          : cookingMethods // ignore: cast_nullable_to_non_nullable
              as List<CookingMethodConfig>,
      nutritionDishes: null == nutritionDishes
          ? _value.nutritionDishes
          : nutritionDishes // ignore: cast_nullable_to_non_nullable
              as List<NutritionBasedDish>,
      alerts: null == alerts
          ? _value.alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<InventoryAlert>,
      transactions: null == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<InventoryTransaction>,
      nutritionAnalysis: freezed == nutritionAnalysis
          ? _value.nutritionAnalysis
          : nutritionAnalysis // ignore: cast_nullable_to_non_nullable
              as NutritionMenuAnalysis?,
      merchantInfo: freezed == merchantInfo
          ? _value.merchantInfo
          : merchantInfo // ignore: cast_nullable_to_non_nullable
              as MerchantInfo?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      showLowStockOnly: null == showLowStockOnly
          ? _value.showLowStockOnly
          : showLowStockOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      showAvailableOnly: null == showAvailableOnly
          ? _value.showAvailableOnly
          : showAvailableOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedIngredientIds: null == selectedIngredientIds
          ? _value.selectedIngredientIds
          : selectedIngredientIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedDishId: freezed == selectedDishId
          ? _value.selectedDishId
          : selectedDishId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of MerchantInventoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionMenuAnalysisCopyWith<$Res>? get nutritionAnalysis {
    if (_value.nutritionAnalysis == null) {
      return null;
    }

    return $NutritionMenuAnalysisCopyWith<$Res>(_value.nutritionAnalysis!,
        (value) {
      return _then(_value.copyWith(nutritionAnalysis: value) as $Val);
    });
  }

  /// Create a copy of MerchantInventoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MerchantInfoCopyWith<$Res>? get merchantInfo {
    if (_value.merchantInfo == null) {
      return null;
    }

    return $MerchantInfoCopyWith<$Res>(_value.merchantInfo!, (value) {
      return _then(_value.copyWith(merchantInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MerchantInventoryStateImplCopyWith<$Res>
    implements $MerchantInventoryStateCopyWith<$Res> {
  factory _$$MerchantInventoryStateImplCopyWith(
          _$MerchantInventoryStateImpl value,
          $Res Function(_$MerchantInventoryStateImpl) then) =
      __$$MerchantInventoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isUpdating,
      List<IngredientInventoryItem> ingredients,
      List<CookingMethodConfig> cookingMethods,
      List<NutritionBasedDish> nutritionDishes,
      List<InventoryAlert> alerts,
      List<InventoryTransaction> transactions,
      NutritionMenuAnalysis? nutritionAnalysis,
      MerchantInfo? merchantInfo,
      String? error,
      String searchQuery,
      String? selectedCategory,
      bool showLowStockOnly,
      bool showAvailableOnly,
      List<String> selectedIngredientIds,
      String? selectedDishId});

  @override
  $NutritionMenuAnalysisCopyWith<$Res>? get nutritionAnalysis;
  @override
  $MerchantInfoCopyWith<$Res>? get merchantInfo;
}

/// @nodoc
class __$$MerchantInventoryStateImplCopyWithImpl<$Res>
    extends _$MerchantInventoryStateCopyWithImpl<$Res,
        _$MerchantInventoryStateImpl>
    implements _$$MerchantInventoryStateImplCopyWith<$Res> {
  __$$MerchantInventoryStateImplCopyWithImpl(
      _$MerchantInventoryStateImpl _value,
      $Res Function(_$MerchantInventoryStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MerchantInventoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isUpdating = null,
    Object? ingredients = null,
    Object? cookingMethods = null,
    Object? nutritionDishes = null,
    Object? alerts = null,
    Object? transactions = null,
    Object? nutritionAnalysis = freezed,
    Object? merchantInfo = freezed,
    Object? error = freezed,
    Object? searchQuery = null,
    Object? selectedCategory = freezed,
    Object? showLowStockOnly = null,
    Object? showAvailableOnly = null,
    Object? selectedIngredientIds = null,
    Object? selectedDishId = freezed,
  }) {
    return _then(_$MerchantInventoryStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<IngredientInventoryItem>,
      cookingMethods: null == cookingMethods
          ? _value._cookingMethods
          : cookingMethods // ignore: cast_nullable_to_non_nullable
              as List<CookingMethodConfig>,
      nutritionDishes: null == nutritionDishes
          ? _value._nutritionDishes
          : nutritionDishes // ignore: cast_nullable_to_non_nullable
              as List<NutritionBasedDish>,
      alerts: null == alerts
          ? _value._alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<InventoryAlert>,
      transactions: null == transactions
          ? _value._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<InventoryTransaction>,
      nutritionAnalysis: freezed == nutritionAnalysis
          ? _value.nutritionAnalysis
          : nutritionAnalysis // ignore: cast_nullable_to_non_nullable
              as NutritionMenuAnalysis?,
      merchantInfo: freezed == merchantInfo
          ? _value.merchantInfo
          : merchantInfo // ignore: cast_nullable_to_non_nullable
              as MerchantInfo?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      showLowStockOnly: null == showLowStockOnly
          ? _value.showLowStockOnly
          : showLowStockOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      showAvailableOnly: null == showAvailableOnly
          ? _value.showAvailableOnly
          : showAvailableOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedIngredientIds: null == selectedIngredientIds
          ? _value._selectedIngredientIds
          : selectedIngredientIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedDishId: freezed == selectedDishId
          ? _value.selectedDishId
          : selectedDishId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MerchantInventoryStateImpl implements _MerchantInventoryState {
  const _$MerchantInventoryStateImpl(
      {this.isLoading = false,
      this.isUpdating = false,
      final List<IngredientInventoryItem> ingredients = const [],
      final List<CookingMethodConfig> cookingMethods = const [],
      final List<NutritionBasedDish> nutritionDishes = const [],
      final List<InventoryAlert> alerts = const [],
      final List<InventoryTransaction> transactions = const [],
      this.nutritionAnalysis,
      this.merchantInfo,
      this.error,
      this.searchQuery = '',
      this.selectedCategory,
      this.showLowStockOnly = false,
      this.showAvailableOnly = false,
      final List<String> selectedIngredientIds = const [],
      this.selectedDishId})
      : _ingredients = ingredients,
        _cookingMethods = cookingMethods,
        _nutritionDishes = nutritionDishes,
        _alerts = alerts,
        _transactions = transactions,
        _selectedIngredientIds = selectedIngredientIds;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isUpdating;
  final List<IngredientInventoryItem> _ingredients;
  @override
  @JsonKey()
  List<IngredientInventoryItem> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  final List<CookingMethodConfig> _cookingMethods;
  @override
  @JsonKey()
  List<CookingMethodConfig> get cookingMethods {
    if (_cookingMethods is EqualUnmodifiableListView) return _cookingMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cookingMethods);
  }

  final List<NutritionBasedDish> _nutritionDishes;
  @override
  @JsonKey()
  List<NutritionBasedDish> get nutritionDishes {
    if (_nutritionDishes is EqualUnmodifiableListView) return _nutritionDishes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionDishes);
  }

  final List<InventoryAlert> _alerts;
  @override
  @JsonKey()
  List<InventoryAlert> get alerts {
    if (_alerts is EqualUnmodifiableListView) return _alerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alerts);
  }

  final List<InventoryTransaction> _transactions;
  @override
  @JsonKey()
  List<InventoryTransaction> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  final NutritionMenuAnalysis? nutritionAnalysis;
  @override
  final MerchantInfo? merchantInfo;
  @override
  final String? error;
// 筛选和搜索状态
  @override
  @JsonKey()
  final String searchQuery;
  @override
  final String? selectedCategory;
  @override
  @JsonKey()
  final bool showLowStockOnly;
  @override
  @JsonKey()
  final bool showAvailableOnly;
// 选中的项目
  final List<String> _selectedIngredientIds;
// 选中的项目
  @override
  @JsonKey()
  List<String> get selectedIngredientIds {
    if (_selectedIngredientIds is EqualUnmodifiableListView)
      return _selectedIngredientIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedIngredientIds);
  }

  @override
  final String? selectedDishId;

  @override
  String toString() {
    return 'MerchantInventoryState(isLoading: $isLoading, isUpdating: $isUpdating, ingredients: $ingredients, cookingMethods: $cookingMethods, nutritionDishes: $nutritionDishes, alerts: $alerts, transactions: $transactions, nutritionAnalysis: $nutritionAnalysis, merchantInfo: $merchantInfo, error: $error, searchQuery: $searchQuery, selectedCategory: $selectedCategory, showLowStockOnly: $showLowStockOnly, showAvailableOnly: $showAvailableOnly, selectedIngredientIds: $selectedIngredientIds, selectedDishId: $selectedDishId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MerchantInventoryStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            const DeepCollectionEquality()
                .equals(other._cookingMethods, _cookingMethods) &&
            const DeepCollectionEquality()
                .equals(other._nutritionDishes, _nutritionDishes) &&
            const DeepCollectionEquality().equals(other._alerts, _alerts) &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions) &&
            (identical(other.nutritionAnalysis, nutritionAnalysis) ||
                other.nutritionAnalysis == nutritionAnalysis) &&
            (identical(other.merchantInfo, merchantInfo) ||
                other.merchantInfo == merchantInfo) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.showLowStockOnly, showLowStockOnly) ||
                other.showLowStockOnly == showLowStockOnly) &&
            (identical(other.showAvailableOnly, showAvailableOnly) ||
                other.showAvailableOnly == showAvailableOnly) &&
            const DeepCollectionEquality()
                .equals(other._selectedIngredientIds, _selectedIngredientIds) &&
            (identical(other.selectedDishId, selectedDishId) ||
                other.selectedDishId == selectedDishId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isUpdating,
      const DeepCollectionEquality().hash(_ingredients),
      const DeepCollectionEquality().hash(_cookingMethods),
      const DeepCollectionEquality().hash(_nutritionDishes),
      const DeepCollectionEquality().hash(_alerts),
      const DeepCollectionEquality().hash(_transactions),
      nutritionAnalysis,
      merchantInfo,
      error,
      searchQuery,
      selectedCategory,
      showLowStockOnly,
      showAvailableOnly,
      const DeepCollectionEquality().hash(_selectedIngredientIds),
      selectedDishId);

  /// Create a copy of MerchantInventoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MerchantInventoryStateImplCopyWith<_$MerchantInventoryStateImpl>
      get copyWith => __$$MerchantInventoryStateImplCopyWithImpl<
          _$MerchantInventoryStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MerchantInventoryState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MerchantInventoryState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MerchantInventoryState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _MerchantInventoryState implements MerchantInventoryState {
  const factory _MerchantInventoryState(
      {final bool isLoading,
      final bool isUpdating,
      final List<IngredientInventoryItem> ingredients,
      final List<CookingMethodConfig> cookingMethods,
      final List<NutritionBasedDish> nutritionDishes,
      final List<InventoryAlert> alerts,
      final List<InventoryTransaction> transactions,
      final NutritionMenuAnalysis? nutritionAnalysis,
      final MerchantInfo? merchantInfo,
      final String? error,
      final String searchQuery,
      final String? selectedCategory,
      final bool showLowStockOnly,
      final bool showAvailableOnly,
      final List<String> selectedIngredientIds,
      final String? selectedDishId}) = _$MerchantInventoryStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isUpdating;
  @override
  List<IngredientInventoryItem> get ingredients;
  @override
  List<CookingMethodConfig> get cookingMethods;
  @override
  List<NutritionBasedDish> get nutritionDishes;
  @override
  List<InventoryAlert> get alerts;
  @override
  List<InventoryTransaction> get transactions;
  @override
  NutritionMenuAnalysis? get nutritionAnalysis;
  @override
  MerchantInfo? get merchantInfo;
  @override
  String? get error; // 筛选和搜索状态
  @override
  String get searchQuery;
  @override
  String? get selectedCategory;
  @override
  bool get showLowStockOnly;
  @override
  bool get showAvailableOnly; // 选中的项目
  @override
  List<String> get selectedIngredientIds;
  @override
  String? get selectedDishId;

  /// Create a copy of MerchantInventoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MerchantInventoryStateImplCopyWith<_$MerchantInventoryStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
