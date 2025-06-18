// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrition_cart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NutritionCart _$NutritionCartFromJson(Map<String, dynamic> json) {
  return _NutritionCart.fromJson(json);
}

/// @nodoc
mixin _$NutritionCart {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get profileId => throw _privateConstructorUsedError; // 关联的营养档案
  List<NutritionCartItem> get items => throw _privateConstructorUsedError;
  Map<String, double> get targetNutritionGoals =>
      throw _privateConstructorUsedError; // 目标营养摄入
  Map<String, double> get currentNutritionTotals =>
      throw _privateConstructorUsedError; // 当前营养总量
  double get totalPrice => throw _privateConstructorUsedError;
  double get totalWeight => throw _privateConstructorUsedError;
  int get totalCalories => throw _privateConstructorUsedError; // 营养平衡状态
  String get nutritionStatus =>
      throw _privateConstructorUsedError; // balanced, under, over, imbalanced
  List<String> get nutritionWarnings => throw _privateConstructorUsedError;
  List<String> get nutritionSuggestions =>
      throw _privateConstructorUsedError; // 配送信息
  String? get deliveryAddress => throw _privateConstructorUsedError;
  DateTime? get preferredDeliveryTime => throw _privateConstructorUsedError;
  String get deliveryMethod =>
      throw _privateConstructorUsedError; // delivery, pickup
// 商家信息（支持多商家订单）
  Map<String, MerchantCartGroup> get merchantGroups =>
      throw _privateConstructorUsedError; // 优惠信息
  List<String> get appliedCoupons => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionCart value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionCart value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionCart value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionCart to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionCart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionCartCopyWith<NutritionCart> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionCartCopyWith<$Res> {
  factory $NutritionCartCopyWith(
          NutritionCart value, $Res Function(NutritionCart) then) =
      _$NutritionCartCopyWithImpl<$Res, NutritionCart>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? profileId,
      List<NutritionCartItem> items,
      Map<String, double> targetNutritionGoals,
      Map<String, double> currentNutritionTotals,
      double totalPrice,
      double totalWeight,
      int totalCalories,
      String nutritionStatus,
      List<String> nutritionWarnings,
      List<String> nutritionSuggestions,
      String? deliveryAddress,
      DateTime? preferredDeliveryTime,
      String deliveryMethod,
      Map<String, MerchantCartGroup> merchantGroups,
      List<String> appliedCoupons,
      double discountAmount,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$NutritionCartCopyWithImpl<$Res, $Val extends NutritionCart>
    implements $NutritionCartCopyWith<$Res> {
  _$NutritionCartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionCart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? profileId = freezed,
    Object? items = null,
    Object? targetNutritionGoals = null,
    Object? currentNutritionTotals = null,
    Object? totalPrice = null,
    Object? totalWeight = null,
    Object? totalCalories = null,
    Object? nutritionStatus = null,
    Object? nutritionWarnings = null,
    Object? nutritionSuggestions = null,
    Object? deliveryAddress = freezed,
    Object? preferredDeliveryTime = freezed,
    Object? deliveryMethod = null,
    Object? merchantGroups = null,
    Object? appliedCoupons = null,
    Object? discountAmount = null,
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
      profileId: freezed == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NutritionCartItem>,
      targetNutritionGoals: null == targetNutritionGoals
          ? _value.targetNutritionGoals
          : targetNutritionGoals // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      currentNutritionTotals: null == currentNutritionTotals
          ? _value.currentNutritionTotals
          : currentNutritionTotals // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalWeight: null == totalWeight
          ? _value.totalWeight
          : totalWeight // ignore: cast_nullable_to_non_nullable
              as double,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      nutritionStatus: null == nutritionStatus
          ? _value.nutritionStatus
          : nutritionStatus // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionWarnings: null == nutritionWarnings
          ? _value.nutritionWarnings
          : nutritionWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionSuggestions: null == nutritionSuggestions
          ? _value.nutritionSuggestions
          : nutritionSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      deliveryAddress: freezed == deliveryAddress
          ? _value.deliveryAddress
          : deliveryAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredDeliveryTime: freezed == preferredDeliveryTime
          ? _value.preferredDeliveryTime
          : preferredDeliveryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveryMethod: null == deliveryMethod
          ? _value.deliveryMethod
          : deliveryMethod // ignore: cast_nullable_to_non_nullable
              as String,
      merchantGroups: null == merchantGroups
          ? _value.merchantGroups
          : merchantGroups // ignore: cast_nullable_to_non_nullable
              as Map<String, MerchantCartGroup>,
      appliedCoupons: null == appliedCoupons
          ? _value.appliedCoupons
          : appliedCoupons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
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
}

/// @nodoc
abstract class _$$NutritionCartImplCopyWith<$Res>
    implements $NutritionCartCopyWith<$Res> {
  factory _$$NutritionCartImplCopyWith(
          _$NutritionCartImpl value, $Res Function(_$NutritionCartImpl) then) =
      __$$NutritionCartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? profileId,
      List<NutritionCartItem> items,
      Map<String, double> targetNutritionGoals,
      Map<String, double> currentNutritionTotals,
      double totalPrice,
      double totalWeight,
      int totalCalories,
      String nutritionStatus,
      List<String> nutritionWarnings,
      List<String> nutritionSuggestions,
      String? deliveryAddress,
      DateTime? preferredDeliveryTime,
      String deliveryMethod,
      Map<String, MerchantCartGroup> merchantGroups,
      List<String> appliedCoupons,
      double discountAmount,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$NutritionCartImplCopyWithImpl<$Res>
    extends _$NutritionCartCopyWithImpl<$Res, _$NutritionCartImpl>
    implements _$$NutritionCartImplCopyWith<$Res> {
  __$$NutritionCartImplCopyWithImpl(
      _$NutritionCartImpl _value, $Res Function(_$NutritionCartImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionCart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? profileId = freezed,
    Object? items = null,
    Object? targetNutritionGoals = null,
    Object? currentNutritionTotals = null,
    Object? totalPrice = null,
    Object? totalWeight = null,
    Object? totalCalories = null,
    Object? nutritionStatus = null,
    Object? nutritionWarnings = null,
    Object? nutritionSuggestions = null,
    Object? deliveryAddress = freezed,
    Object? preferredDeliveryTime = freezed,
    Object? deliveryMethod = null,
    Object? merchantGroups = null,
    Object? appliedCoupons = null,
    Object? discountAmount = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$NutritionCartImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      profileId: freezed == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NutritionCartItem>,
      targetNutritionGoals: null == targetNutritionGoals
          ? _value._targetNutritionGoals
          : targetNutritionGoals // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      currentNutritionTotals: null == currentNutritionTotals
          ? _value._currentNutritionTotals
          : currentNutritionTotals // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalWeight: null == totalWeight
          ? _value.totalWeight
          : totalWeight // ignore: cast_nullable_to_non_nullable
              as double,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      nutritionStatus: null == nutritionStatus
          ? _value.nutritionStatus
          : nutritionStatus // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionWarnings: null == nutritionWarnings
          ? _value._nutritionWarnings
          : nutritionWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionSuggestions: null == nutritionSuggestions
          ? _value._nutritionSuggestions
          : nutritionSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      deliveryAddress: freezed == deliveryAddress
          ? _value.deliveryAddress
          : deliveryAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredDeliveryTime: freezed == preferredDeliveryTime
          ? _value.preferredDeliveryTime
          : preferredDeliveryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveryMethod: null == deliveryMethod
          ? _value.deliveryMethod
          : deliveryMethod // ignore: cast_nullable_to_non_nullable
              as String,
      merchantGroups: null == merchantGroups
          ? _value._merchantGroups
          : merchantGroups // ignore: cast_nullable_to_non_nullable
              as Map<String, MerchantCartGroup>,
      appliedCoupons: null == appliedCoupons
          ? _value._appliedCoupons
          : appliedCoupons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
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
class _$NutritionCartImpl implements _NutritionCart {
  const _$NutritionCartImpl(
      {required this.id,
      required this.userId,
      this.profileId,
      final List<NutritionCartItem> items = const [],
      final Map<String, double> targetNutritionGoals = const {},
      final Map<String, double> currentNutritionTotals = const {},
      this.totalPrice = 0.0,
      this.totalWeight = 0.0,
      this.totalCalories = 0,
      this.nutritionStatus = 'balanced',
      final List<String> nutritionWarnings = const [],
      final List<String> nutritionSuggestions = const [],
      this.deliveryAddress,
      this.preferredDeliveryTime,
      this.deliveryMethod = 'delivery',
      final Map<String, MerchantCartGroup> merchantGroups = const {},
      final List<String> appliedCoupons = const [],
      this.discountAmount = 0.0,
      required this.createdAt,
      this.updatedAt})
      : _items = items,
        _targetNutritionGoals = targetNutritionGoals,
        _currentNutritionTotals = currentNutritionTotals,
        _nutritionWarnings = nutritionWarnings,
        _nutritionSuggestions = nutritionSuggestions,
        _merchantGroups = merchantGroups,
        _appliedCoupons = appliedCoupons;

  factory _$NutritionCartImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionCartImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? profileId;
// 关联的营养档案
  final List<NutritionCartItem> _items;
// 关联的营养档案
  @override
  @JsonKey()
  List<NutritionCartItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final Map<String, double> _targetNutritionGoals;
  @override
  @JsonKey()
  Map<String, double> get targetNutritionGoals {
    if (_targetNutritionGoals is EqualUnmodifiableMapView)
      return _targetNutritionGoals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_targetNutritionGoals);
  }

// 目标营养摄入
  final Map<String, double> _currentNutritionTotals;
// 目标营养摄入
  @override
  @JsonKey()
  Map<String, double> get currentNutritionTotals {
    if (_currentNutritionTotals is EqualUnmodifiableMapView)
      return _currentNutritionTotals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_currentNutritionTotals);
  }

// 当前营养总量
  @override
  @JsonKey()
  final double totalPrice;
  @override
  @JsonKey()
  final double totalWeight;
  @override
  @JsonKey()
  final int totalCalories;
// 营养平衡状态
  @override
  @JsonKey()
  final String nutritionStatus;
// balanced, under, over, imbalanced
  final List<String> _nutritionWarnings;
// balanced, under, over, imbalanced
  @override
  @JsonKey()
  List<String> get nutritionWarnings {
    if (_nutritionWarnings is EqualUnmodifiableListView)
      return _nutritionWarnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionWarnings);
  }

  final List<String> _nutritionSuggestions;
  @override
  @JsonKey()
  List<String> get nutritionSuggestions {
    if (_nutritionSuggestions is EqualUnmodifiableListView)
      return _nutritionSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionSuggestions);
  }

// 配送信息
  @override
  final String? deliveryAddress;
  @override
  final DateTime? preferredDeliveryTime;
  @override
  @JsonKey()
  final String deliveryMethod;
// delivery, pickup
// 商家信息（支持多商家订单）
  final Map<String, MerchantCartGroup> _merchantGroups;
// delivery, pickup
// 商家信息（支持多商家订单）
  @override
  @JsonKey()
  Map<String, MerchantCartGroup> get merchantGroups {
    if (_merchantGroups is EqualUnmodifiableMapView) return _merchantGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_merchantGroups);
  }

// 优惠信息
  final List<String> _appliedCoupons;
// 优惠信息
  @override
  @JsonKey()
  List<String> get appliedCoupons {
    if (_appliedCoupons is EqualUnmodifiableListView) return _appliedCoupons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appliedCoupons);
  }

  @override
  @JsonKey()
  final double discountAmount;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'NutritionCart(id: $id, userId: $userId, profileId: $profileId, items: $items, targetNutritionGoals: $targetNutritionGoals, currentNutritionTotals: $currentNutritionTotals, totalPrice: $totalPrice, totalWeight: $totalWeight, totalCalories: $totalCalories, nutritionStatus: $nutritionStatus, nutritionWarnings: $nutritionWarnings, nutritionSuggestions: $nutritionSuggestions, deliveryAddress: $deliveryAddress, preferredDeliveryTime: $preferredDeliveryTime, deliveryMethod: $deliveryMethod, merchantGroups: $merchantGroups, appliedCoupons: $appliedCoupons, discountAmount: $discountAmount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionCartImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other._targetNutritionGoals, _targetNutritionGoals) &&
            const DeepCollectionEquality().equals(
                other._currentNutritionTotals, _currentNutritionTotals) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.totalWeight, totalWeight) ||
                other.totalWeight == totalWeight) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.nutritionStatus, nutritionStatus) ||
                other.nutritionStatus == nutritionStatus) &&
            const DeepCollectionEquality()
                .equals(other._nutritionWarnings, _nutritionWarnings) &&
            const DeepCollectionEquality()
                .equals(other._nutritionSuggestions, _nutritionSuggestions) &&
            (identical(other.deliveryAddress, deliveryAddress) ||
                other.deliveryAddress == deliveryAddress) &&
            (identical(other.preferredDeliveryTime, preferredDeliveryTime) ||
                other.preferredDeliveryTime == preferredDeliveryTime) &&
            (identical(other.deliveryMethod, deliveryMethod) ||
                other.deliveryMethod == deliveryMethod) &&
            const DeepCollectionEquality()
                .equals(other._merchantGroups, _merchantGroups) &&
            const DeepCollectionEquality()
                .equals(other._appliedCoupons, _appliedCoupons) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
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
        profileId,
        const DeepCollectionEquality().hash(_items),
        const DeepCollectionEquality().hash(_targetNutritionGoals),
        const DeepCollectionEquality().hash(_currentNutritionTotals),
        totalPrice,
        totalWeight,
        totalCalories,
        nutritionStatus,
        const DeepCollectionEquality().hash(_nutritionWarnings),
        const DeepCollectionEquality().hash(_nutritionSuggestions),
        deliveryAddress,
        preferredDeliveryTime,
        deliveryMethod,
        const DeepCollectionEquality().hash(_merchantGroups),
        const DeepCollectionEquality().hash(_appliedCoupons),
        discountAmount,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of NutritionCart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionCartImplCopyWith<_$NutritionCartImpl> get copyWith =>
      __$$NutritionCartImplCopyWithImpl<_$NutritionCartImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionCart value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionCart value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionCart value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionCartImplToJson(
      this,
    );
  }
}

abstract class _NutritionCart implements NutritionCart {
  const factory _NutritionCart(
      {required final String id,
      required final String userId,
      final String? profileId,
      final List<NutritionCartItem> items,
      final Map<String, double> targetNutritionGoals,
      final Map<String, double> currentNutritionTotals,
      final double totalPrice,
      final double totalWeight,
      final int totalCalories,
      final String nutritionStatus,
      final List<String> nutritionWarnings,
      final List<String> nutritionSuggestions,
      final String? deliveryAddress,
      final DateTime? preferredDeliveryTime,
      final String deliveryMethod,
      final Map<String, MerchantCartGroup> merchantGroups,
      final List<String> appliedCoupons,
      final double discountAmount,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$NutritionCartImpl;

  factory _NutritionCart.fromJson(Map<String, dynamic> json) =
      _$NutritionCartImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get profileId; // 关联的营养档案
  @override
  List<NutritionCartItem> get items;
  @override
  Map<String, double> get targetNutritionGoals; // 目标营养摄入
  @override
  Map<String, double> get currentNutritionTotals; // 当前营养总量
  @override
  double get totalPrice;
  @override
  double get totalWeight;
  @override
  int get totalCalories; // 营养平衡状态
  @override
  String get nutritionStatus; // balanced, under, over, imbalanced
  @override
  List<String> get nutritionWarnings;
  @override
  List<String> get nutritionSuggestions; // 配送信息
  @override
  String? get deliveryAddress;
  @override
  DateTime? get preferredDeliveryTime;
  @override
  String get deliveryMethod; // delivery, pickup
// 商家信息（支持多商家订单）
  @override
  Map<String, MerchantCartGroup> get merchantGroups; // 优惠信息
  @override
  List<String> get appliedCoupons;
  @override
  double get discountAmount;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of NutritionCart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionCartImplCopyWith<_$NutritionCartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MerchantCartGroup _$MerchantCartGroupFromJson(Map<String, dynamic> json) {
  return _MerchantCartGroup.fromJson(json);
}

/// @nodoc
mixin _$MerchantCartGroup {
  String get merchantId => throw _privateConstructorUsedError;
  String get merchantName => throw _privateConstructorUsedError;
  List<NutritionCartItem> get items => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get deliveryFee => throw _privateConstructorUsedError;
  double get minimumOrder => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  String? get unavailableReason => throw _privateConstructorUsedError; // 营养统计
  Map<String, double> get nutritionTotals => throw _privateConstructorUsedError;
  int get totalCalories => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MerchantCartGroup value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MerchantCartGroup value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MerchantCartGroup value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MerchantCartGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MerchantCartGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MerchantCartGroupCopyWith<MerchantCartGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MerchantCartGroupCopyWith<$Res> {
  factory $MerchantCartGroupCopyWith(
          MerchantCartGroup value, $Res Function(MerchantCartGroup) then) =
      _$MerchantCartGroupCopyWithImpl<$Res, MerchantCartGroup>;
  @useResult
  $Res call(
      {String merchantId,
      String merchantName,
      List<NutritionCartItem> items,
      double subtotal,
      double deliveryFee,
      double minimumOrder,
      bool isAvailable,
      String? unavailableReason,
      Map<String, double> nutritionTotals,
      int totalCalories});
}

/// @nodoc
class _$MerchantCartGroupCopyWithImpl<$Res, $Val extends MerchantCartGroup>
    implements $MerchantCartGroupCopyWith<$Res> {
  _$MerchantCartGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MerchantCartGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchantId = null,
    Object? merchantName = null,
    Object? items = null,
    Object? subtotal = null,
    Object? deliveryFee = null,
    Object? minimumOrder = null,
    Object? isAvailable = null,
    Object? unavailableReason = freezed,
    Object? nutritionTotals = null,
    Object? totalCalories = null,
  }) {
    return _then(_value.copyWith(
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantName: null == merchantName
          ? _value.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NutritionCartItem>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      minimumOrder: null == minimumOrder
          ? _value.minimumOrder
          : minimumOrder // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      unavailableReason: freezed == unavailableReason
          ? _value.unavailableReason
          : unavailableReason // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionTotals: null == nutritionTotals
          ? _value.nutritionTotals
          : nutritionTotals // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MerchantCartGroupImplCopyWith<$Res>
    implements $MerchantCartGroupCopyWith<$Res> {
  factory _$$MerchantCartGroupImplCopyWith(_$MerchantCartGroupImpl value,
          $Res Function(_$MerchantCartGroupImpl) then) =
      __$$MerchantCartGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String merchantId,
      String merchantName,
      List<NutritionCartItem> items,
      double subtotal,
      double deliveryFee,
      double minimumOrder,
      bool isAvailable,
      String? unavailableReason,
      Map<String, double> nutritionTotals,
      int totalCalories});
}

/// @nodoc
class __$$MerchantCartGroupImplCopyWithImpl<$Res>
    extends _$MerchantCartGroupCopyWithImpl<$Res, _$MerchantCartGroupImpl>
    implements _$$MerchantCartGroupImplCopyWith<$Res> {
  __$$MerchantCartGroupImplCopyWithImpl(_$MerchantCartGroupImpl _value,
      $Res Function(_$MerchantCartGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of MerchantCartGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchantId = null,
    Object? merchantName = null,
    Object? items = null,
    Object? subtotal = null,
    Object? deliveryFee = null,
    Object? minimumOrder = null,
    Object? isAvailable = null,
    Object? unavailableReason = freezed,
    Object? nutritionTotals = null,
    Object? totalCalories = null,
  }) {
    return _then(_$MerchantCartGroupImpl(
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantName: null == merchantName
          ? _value.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NutritionCartItem>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      minimumOrder: null == minimumOrder
          ? _value.minimumOrder
          : minimumOrder // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      unavailableReason: freezed == unavailableReason
          ? _value.unavailableReason
          : unavailableReason // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionTotals: null == nutritionTotals
          ? _value._nutritionTotals
          : nutritionTotals // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MerchantCartGroupImpl implements _MerchantCartGroup {
  const _$MerchantCartGroupImpl(
      {required this.merchantId,
      required this.merchantName,
      final List<NutritionCartItem> items = const [],
      this.subtotal = 0.0,
      this.deliveryFee = 0.0,
      this.minimumOrder = 0.0,
      this.isAvailable = true,
      this.unavailableReason,
      final Map<String, double> nutritionTotals = const {},
      this.totalCalories = 0})
      : _items = items,
        _nutritionTotals = nutritionTotals;

  factory _$MerchantCartGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$MerchantCartGroupImplFromJson(json);

  @override
  final String merchantId;
  @override
  final String merchantName;
  final List<NutritionCartItem> _items;
  @override
  @JsonKey()
  List<NutritionCartItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final double subtotal;
  @override
  @JsonKey()
  final double deliveryFee;
  @override
  @JsonKey()
  final double minimumOrder;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  final String? unavailableReason;
// 营养统计
  final Map<String, double> _nutritionTotals;
// 营养统计
  @override
  @JsonKey()
  Map<String, double> get nutritionTotals {
    if (_nutritionTotals is EqualUnmodifiableMapView) return _nutritionTotals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionTotals);
  }

  @override
  @JsonKey()
  final int totalCalories;

  @override
  String toString() {
    return 'MerchantCartGroup(merchantId: $merchantId, merchantName: $merchantName, items: $items, subtotal: $subtotal, deliveryFee: $deliveryFee, minimumOrder: $minimumOrder, isAvailable: $isAvailable, unavailableReason: $unavailableReason, nutritionTotals: $nutritionTotals, totalCalories: $totalCalories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MerchantCartGroupImpl &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.minimumOrder, minimumOrder) ||
                other.minimumOrder == minimumOrder) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.unavailableReason, unavailableReason) ||
                other.unavailableReason == unavailableReason) &&
            const DeepCollectionEquality()
                .equals(other._nutritionTotals, _nutritionTotals) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      merchantId,
      merchantName,
      const DeepCollectionEquality().hash(_items),
      subtotal,
      deliveryFee,
      minimumOrder,
      isAvailable,
      unavailableReason,
      const DeepCollectionEquality().hash(_nutritionTotals),
      totalCalories);

  /// Create a copy of MerchantCartGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MerchantCartGroupImplCopyWith<_$MerchantCartGroupImpl> get copyWith =>
      __$$MerchantCartGroupImplCopyWithImpl<_$MerchantCartGroupImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MerchantCartGroup value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MerchantCartGroup value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MerchantCartGroup value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MerchantCartGroupImplToJson(
      this,
    );
  }
}

abstract class _MerchantCartGroup implements MerchantCartGroup {
  const factory _MerchantCartGroup(
      {required final String merchantId,
      required final String merchantName,
      final List<NutritionCartItem> items,
      final double subtotal,
      final double deliveryFee,
      final double minimumOrder,
      final bool isAvailable,
      final String? unavailableReason,
      final Map<String, double> nutritionTotals,
      final int totalCalories}) = _$MerchantCartGroupImpl;

  factory _MerchantCartGroup.fromJson(Map<String, dynamic> json) =
      _$MerchantCartGroupImpl.fromJson;

  @override
  String get merchantId;
  @override
  String get merchantName;
  @override
  List<NutritionCartItem> get items;
  @override
  double get subtotal;
  @override
  double get deliveryFee;
  @override
  double get minimumOrder;
  @override
  bool get isAvailable;
  @override
  String? get unavailableReason; // 营养统计
  @override
  Map<String, double> get nutritionTotals;
  @override
  int get totalCalories;

  /// Create a copy of MerchantCartGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MerchantCartGroupImplCopyWith<_$MerchantCartGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionCartItem _$NutritionCartItemFromJson(Map<String, dynamic> json) {
  return _NutritionCartItem.fromJson(json);
}

/// @nodoc
mixin _$NutritionCartItem {
  String get id => throw _privateConstructorUsedError;
  String get itemType =>
      throw _privateConstructorUsedError; // ingredient, dish, custom_meal
  String get itemId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get chineseName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError; // 数量和单位
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError; // 商家信息
  String get merchantId => throw _privateConstructorUsedError;
  String get merchantName =>
      throw _privateConstructorUsedError; // 营养信息（按实际重量计算）
  Map<String, double> get nutritionPer100g =>
      throw _privateConstructorUsedError;
  Map<String, double> get totalNutrition => throw _privateConstructorUsedError;
  int get totalCalories => throw _privateConstructorUsedError; // 烹饪方式（如果适用）
  String? get cookingMethodId => throw _privateConstructorUsedError;
  String? get cookingMethodName => throw _privateConstructorUsedError;
  Map<String, double> get cookingAdjustments =>
      throw _privateConstructorUsedError; // 烹饪对营养的影响
// 定制选项
  List<String> get customizations => throw _privateConstructorUsedError;
  List<String> get allergenWarnings => throw _privateConstructorUsedError;
  List<String> get dietaryTags =>
      throw _privateConstructorUsedError; // vegetarian, vegan, gluten-free等
// 库存状态
  bool get isAvailable => throw _privateConstructorUsedError;
  String? get unavailableReason => throw _privateConstructorUsedError;
  double? get maxAvailableQuantity =>
      throw _privateConstructorUsedError; // 营养目标匹配度
  double get nutritionMatchScore =>
      throw _privateConstructorUsedError; // 0-1，与用户营养目标的匹配度
  List<String> get nutritionBenefits => throw _privateConstructorUsedError;
  DateTime get addedAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionCartItem value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionCartItem value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionCartItem value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionCartItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionCartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionCartItemCopyWith<NutritionCartItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionCartItemCopyWith<$Res> {
  factory $NutritionCartItemCopyWith(
          NutritionCartItem value, $Res Function(NutritionCartItem) then) =
      _$NutritionCartItemCopyWithImpl<$Res, NutritionCartItem>;
  @useResult
  $Res call(
      {String id,
      String itemType,
      String itemId,
      String name,
      String chineseName,
      String? description,
      String? imageUrl,
      double quantity,
      String unit,
      double unitPrice,
      double totalPrice,
      String merchantId,
      String merchantName,
      Map<String, double> nutritionPer100g,
      Map<String, double> totalNutrition,
      int totalCalories,
      String? cookingMethodId,
      String? cookingMethodName,
      Map<String, double> cookingAdjustments,
      List<String> customizations,
      List<String> allergenWarnings,
      List<String> dietaryTags,
      bool isAvailable,
      String? unavailableReason,
      double? maxAvailableQuantity,
      double nutritionMatchScore,
      List<String> nutritionBenefits,
      DateTime addedAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$NutritionCartItemCopyWithImpl<$Res, $Val extends NutritionCartItem>
    implements $NutritionCartItemCopyWith<$Res> {
  _$NutritionCartItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionCartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemType = null,
    Object? itemId = null,
    Object? name = null,
    Object? chineseName = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? quantity = null,
    Object? unit = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? merchantId = null,
    Object? merchantName = null,
    Object? nutritionPer100g = null,
    Object? totalNutrition = null,
    Object? totalCalories = null,
    Object? cookingMethodId = freezed,
    Object? cookingMethodName = freezed,
    Object? cookingAdjustments = null,
    Object? customizations = null,
    Object? allergenWarnings = null,
    Object? dietaryTags = null,
    Object? isAvailable = null,
    Object? unavailableReason = freezed,
    Object? maxAvailableQuantity = freezed,
    Object? nutritionMatchScore = null,
    Object? nutritionBenefits = null,
    Object? addedAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemType: null == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      chineseName: null == chineseName
          ? _value.chineseName
          : chineseName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantName: null == merchantName
          ? _value.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionPer100g: null == nutritionPer100g
          ? _value.nutritionPer100g
          : nutritionPer100g // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalNutrition: null == totalNutrition
          ? _value.totalNutrition
          : totalNutrition // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      cookingMethodId: freezed == cookingMethodId
          ? _value.cookingMethodId
          : cookingMethodId // ignore: cast_nullable_to_non_nullable
              as String?,
      cookingMethodName: freezed == cookingMethodName
          ? _value.cookingMethodName
          : cookingMethodName // ignore: cast_nullable_to_non_nullable
              as String?,
      cookingAdjustments: null == cookingAdjustments
          ? _value.cookingAdjustments
          : cookingAdjustments // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      customizations: null == customizations
          ? _value.customizations
          : customizations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergenWarnings: null == allergenWarnings
          ? _value.allergenWarnings
          : allergenWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dietaryTags: null == dietaryTags
          ? _value.dietaryTags
          : dietaryTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      unavailableReason: freezed == unavailableReason
          ? _value.unavailableReason
          : unavailableReason // ignore: cast_nullable_to_non_nullable
              as String?,
      maxAvailableQuantity: freezed == maxAvailableQuantity
          ? _value.maxAvailableQuantity
          : maxAvailableQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      nutritionMatchScore: null == nutritionMatchScore
          ? _value.nutritionMatchScore
          : nutritionMatchScore // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionBenefits: null == nutritionBenefits
          ? _value.nutritionBenefits
          : nutritionBenefits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionCartItemImplCopyWith<$Res>
    implements $NutritionCartItemCopyWith<$Res> {
  factory _$$NutritionCartItemImplCopyWith(_$NutritionCartItemImpl value,
          $Res Function(_$NutritionCartItemImpl) then) =
      __$$NutritionCartItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String itemType,
      String itemId,
      String name,
      String chineseName,
      String? description,
      String? imageUrl,
      double quantity,
      String unit,
      double unitPrice,
      double totalPrice,
      String merchantId,
      String merchantName,
      Map<String, double> nutritionPer100g,
      Map<String, double> totalNutrition,
      int totalCalories,
      String? cookingMethodId,
      String? cookingMethodName,
      Map<String, double> cookingAdjustments,
      List<String> customizations,
      List<String> allergenWarnings,
      List<String> dietaryTags,
      bool isAvailable,
      String? unavailableReason,
      double? maxAvailableQuantity,
      double nutritionMatchScore,
      List<String> nutritionBenefits,
      DateTime addedAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$NutritionCartItemImplCopyWithImpl<$Res>
    extends _$NutritionCartItemCopyWithImpl<$Res, _$NutritionCartItemImpl>
    implements _$$NutritionCartItemImplCopyWith<$Res> {
  __$$NutritionCartItemImplCopyWithImpl(_$NutritionCartItemImpl _value,
      $Res Function(_$NutritionCartItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionCartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemType = null,
    Object? itemId = null,
    Object? name = null,
    Object? chineseName = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? quantity = null,
    Object? unit = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? merchantId = null,
    Object? merchantName = null,
    Object? nutritionPer100g = null,
    Object? totalNutrition = null,
    Object? totalCalories = null,
    Object? cookingMethodId = freezed,
    Object? cookingMethodName = freezed,
    Object? cookingAdjustments = null,
    Object? customizations = null,
    Object? allergenWarnings = null,
    Object? dietaryTags = null,
    Object? isAvailable = null,
    Object? unavailableReason = freezed,
    Object? maxAvailableQuantity = freezed,
    Object? nutritionMatchScore = null,
    Object? nutritionBenefits = null,
    Object? addedAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$NutritionCartItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemType: null == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      chineseName: null == chineseName
          ? _value.chineseName
          : chineseName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantName: null == merchantName
          ? _value.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionPer100g: null == nutritionPer100g
          ? _value._nutritionPer100g
          : nutritionPer100g // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalNutrition: null == totalNutrition
          ? _value._totalNutrition
          : totalNutrition // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      cookingMethodId: freezed == cookingMethodId
          ? _value.cookingMethodId
          : cookingMethodId // ignore: cast_nullable_to_non_nullable
              as String?,
      cookingMethodName: freezed == cookingMethodName
          ? _value.cookingMethodName
          : cookingMethodName // ignore: cast_nullable_to_non_nullable
              as String?,
      cookingAdjustments: null == cookingAdjustments
          ? _value._cookingAdjustments
          : cookingAdjustments // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      customizations: null == customizations
          ? _value._customizations
          : customizations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergenWarnings: null == allergenWarnings
          ? _value._allergenWarnings
          : allergenWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dietaryTags: null == dietaryTags
          ? _value._dietaryTags
          : dietaryTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      unavailableReason: freezed == unavailableReason
          ? _value.unavailableReason
          : unavailableReason // ignore: cast_nullable_to_non_nullable
              as String?,
      maxAvailableQuantity: freezed == maxAvailableQuantity
          ? _value.maxAvailableQuantity
          : maxAvailableQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      nutritionMatchScore: null == nutritionMatchScore
          ? _value.nutritionMatchScore
          : nutritionMatchScore // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionBenefits: null == nutritionBenefits
          ? _value._nutritionBenefits
          : nutritionBenefits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
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
class _$NutritionCartItemImpl implements _NutritionCartItem {
  const _$NutritionCartItemImpl(
      {required this.id,
      required this.itemType,
      required this.itemId,
      required this.name,
      required this.chineseName,
      this.description,
      this.imageUrl,
      required this.quantity,
      required this.unit,
      required this.unitPrice,
      this.totalPrice = 0.0,
      required this.merchantId,
      required this.merchantName,
      required final Map<String, double> nutritionPer100g,
      required final Map<String, double> totalNutrition,
      required this.totalCalories,
      this.cookingMethodId,
      this.cookingMethodName,
      final Map<String, double> cookingAdjustments = const {},
      final List<String> customizations = const [],
      final List<String> allergenWarnings = const [],
      final List<String> dietaryTags = const [],
      this.isAvailable = true,
      this.unavailableReason,
      this.maxAvailableQuantity,
      this.nutritionMatchScore = 0.0,
      final List<String> nutritionBenefits = const [],
      required this.addedAt,
      this.updatedAt})
      : _nutritionPer100g = nutritionPer100g,
        _totalNutrition = totalNutrition,
        _cookingAdjustments = cookingAdjustments,
        _customizations = customizations,
        _allergenWarnings = allergenWarnings,
        _dietaryTags = dietaryTags,
        _nutritionBenefits = nutritionBenefits;

  factory _$NutritionCartItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionCartItemImplFromJson(json);

  @override
  final String id;
  @override
  final String itemType;
// ingredient, dish, custom_meal
  @override
  final String itemId;
  @override
  final String name;
  @override
  final String chineseName;
  @override
  final String? description;
  @override
  final String? imageUrl;
// 数量和单位
  @override
  final double quantity;
  @override
  final String unit;
  @override
  final double unitPrice;
  @override
  @JsonKey()
  final double totalPrice;
// 商家信息
  @override
  final String merchantId;
  @override
  final String merchantName;
// 营养信息（按实际重量计算）
  final Map<String, double> _nutritionPer100g;
// 营养信息（按实际重量计算）
  @override
  Map<String, double> get nutritionPer100g {
    if (_nutritionPer100g is EqualUnmodifiableMapView) return _nutritionPer100g;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionPer100g);
  }

  final Map<String, double> _totalNutrition;
  @override
  Map<String, double> get totalNutrition {
    if (_totalNutrition is EqualUnmodifiableMapView) return _totalNutrition;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_totalNutrition);
  }

  @override
  final int totalCalories;
// 烹饪方式（如果适用）
  @override
  final String? cookingMethodId;
  @override
  final String? cookingMethodName;
  final Map<String, double> _cookingAdjustments;
  @override
  @JsonKey()
  Map<String, double> get cookingAdjustments {
    if (_cookingAdjustments is EqualUnmodifiableMapView)
      return _cookingAdjustments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_cookingAdjustments);
  }

// 烹饪对营养的影响
// 定制选项
  final List<String> _customizations;
// 烹饪对营养的影响
// 定制选项
  @override
  @JsonKey()
  List<String> get customizations {
    if (_customizations is EqualUnmodifiableListView) return _customizations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customizations);
  }

  final List<String> _allergenWarnings;
  @override
  @JsonKey()
  List<String> get allergenWarnings {
    if (_allergenWarnings is EqualUnmodifiableListView)
      return _allergenWarnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergenWarnings);
  }

  final List<String> _dietaryTags;
  @override
  @JsonKey()
  List<String> get dietaryTags {
    if (_dietaryTags is EqualUnmodifiableListView) return _dietaryTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dietaryTags);
  }

// vegetarian, vegan, gluten-free等
// 库存状态
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  final String? unavailableReason;
  @override
  final double? maxAvailableQuantity;
// 营养目标匹配度
  @override
  @JsonKey()
  final double nutritionMatchScore;
// 0-1，与用户营养目标的匹配度
  final List<String> _nutritionBenefits;
// 0-1，与用户营养目标的匹配度
  @override
  @JsonKey()
  List<String> get nutritionBenefits {
    if (_nutritionBenefits is EqualUnmodifiableListView)
      return _nutritionBenefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionBenefits);
  }

  @override
  final DateTime addedAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'NutritionCartItem(id: $id, itemType: $itemType, itemId: $itemId, name: $name, chineseName: $chineseName, description: $description, imageUrl: $imageUrl, quantity: $quantity, unit: $unit, unitPrice: $unitPrice, totalPrice: $totalPrice, merchantId: $merchantId, merchantName: $merchantName, nutritionPer100g: $nutritionPer100g, totalNutrition: $totalNutrition, totalCalories: $totalCalories, cookingMethodId: $cookingMethodId, cookingMethodName: $cookingMethodName, cookingAdjustments: $cookingAdjustments, customizations: $customizations, allergenWarnings: $allergenWarnings, dietaryTags: $dietaryTags, isAvailable: $isAvailable, unavailableReason: $unavailableReason, maxAvailableQuantity: $maxAvailableQuantity, nutritionMatchScore: $nutritionMatchScore, nutritionBenefits: $nutritionBenefits, addedAt: $addedAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionCartItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemType, itemType) ||
                other.itemType == itemType) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.chineseName, chineseName) ||
                other.chineseName == chineseName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            const DeepCollectionEquality()
                .equals(other._nutritionPer100g, _nutritionPer100g) &&
            const DeepCollectionEquality()
                .equals(other._totalNutrition, _totalNutrition) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.cookingMethodId, cookingMethodId) ||
                other.cookingMethodId == cookingMethodId) &&
            (identical(other.cookingMethodName, cookingMethodName) ||
                other.cookingMethodName == cookingMethodName) &&
            const DeepCollectionEquality()
                .equals(other._cookingAdjustments, _cookingAdjustments) &&
            const DeepCollectionEquality()
                .equals(other._customizations, _customizations) &&
            const DeepCollectionEquality()
                .equals(other._allergenWarnings, _allergenWarnings) &&
            const DeepCollectionEquality()
                .equals(other._dietaryTags, _dietaryTags) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.unavailableReason, unavailableReason) ||
                other.unavailableReason == unavailableReason) &&
            (identical(other.maxAvailableQuantity, maxAvailableQuantity) ||
                other.maxAvailableQuantity == maxAvailableQuantity) &&
            (identical(other.nutritionMatchScore, nutritionMatchScore) ||
                other.nutritionMatchScore == nutritionMatchScore) &&
            const DeepCollectionEquality()
                .equals(other._nutritionBenefits, _nutritionBenefits) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        itemType,
        itemId,
        name,
        chineseName,
        description,
        imageUrl,
        quantity,
        unit,
        unitPrice,
        totalPrice,
        merchantId,
        merchantName,
        const DeepCollectionEquality().hash(_nutritionPer100g),
        const DeepCollectionEquality().hash(_totalNutrition),
        totalCalories,
        cookingMethodId,
        cookingMethodName,
        const DeepCollectionEquality().hash(_cookingAdjustments),
        const DeepCollectionEquality().hash(_customizations),
        const DeepCollectionEquality().hash(_allergenWarnings),
        const DeepCollectionEquality().hash(_dietaryTags),
        isAvailable,
        unavailableReason,
        maxAvailableQuantity,
        nutritionMatchScore,
        const DeepCollectionEquality().hash(_nutritionBenefits),
        addedAt,
        updatedAt
      ]);

  /// Create a copy of NutritionCartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionCartItemImplCopyWith<_$NutritionCartItemImpl> get copyWith =>
      __$$NutritionCartItemImplCopyWithImpl<_$NutritionCartItemImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionCartItem value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionCartItem value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionCartItem value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionCartItemImplToJson(
      this,
    );
  }
}

abstract class _NutritionCartItem implements NutritionCartItem {
  const factory _NutritionCartItem(
      {required final String id,
      required final String itemType,
      required final String itemId,
      required final String name,
      required final String chineseName,
      final String? description,
      final String? imageUrl,
      required final double quantity,
      required final String unit,
      required final double unitPrice,
      final double totalPrice,
      required final String merchantId,
      required final String merchantName,
      required final Map<String, double> nutritionPer100g,
      required final Map<String, double> totalNutrition,
      required final int totalCalories,
      final String? cookingMethodId,
      final String? cookingMethodName,
      final Map<String, double> cookingAdjustments,
      final List<String> customizations,
      final List<String> allergenWarnings,
      final List<String> dietaryTags,
      final bool isAvailable,
      final String? unavailableReason,
      final double? maxAvailableQuantity,
      final double nutritionMatchScore,
      final List<String> nutritionBenefits,
      required final DateTime addedAt,
      final DateTime? updatedAt}) = _$NutritionCartItemImpl;

  factory _NutritionCartItem.fromJson(Map<String, dynamic> json) =
      _$NutritionCartItemImpl.fromJson;

  @override
  String get id;
  @override
  String get itemType; // ingredient, dish, custom_meal
  @override
  String get itemId;
  @override
  String get name;
  @override
  String get chineseName;
  @override
  String? get description;
  @override
  String? get imageUrl; // 数量和单位
  @override
  double get quantity;
  @override
  String get unit;
  @override
  double get unitPrice;
  @override
  double get totalPrice; // 商家信息
  @override
  String get merchantId;
  @override
  String get merchantName; // 营养信息（按实际重量计算）
  @override
  Map<String, double> get nutritionPer100g;
  @override
  Map<String, double> get totalNutrition;
  @override
  int get totalCalories; // 烹饪方式（如果适用）
  @override
  String? get cookingMethodId;
  @override
  String? get cookingMethodName;
  @override
  Map<String, double> get cookingAdjustments; // 烹饪对营养的影响
// 定制选项
  @override
  List<String> get customizations;
  @override
  List<String> get allergenWarnings;
  @override
  List<String> get dietaryTags; // vegetarian, vegan, gluten-free等
// 库存状态
  @override
  bool get isAvailable;
  @override
  String? get unavailableReason;
  @override
  double? get maxAvailableQuantity; // 营养目标匹配度
  @override
  double get nutritionMatchScore; // 0-1，与用户营养目标的匹配度
  @override
  List<String> get nutritionBenefits;
  @override
  DateTime get addedAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of NutritionCartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionCartItemImplCopyWith<_$NutritionCartItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionBalanceAnalysis _$NutritionBalanceAnalysisFromJson(
    Map<String, dynamic> json) {
  return _NutritionBalanceAnalysis.fromJson(json);
}

/// @nodoc
mixin _$NutritionBalanceAnalysis {
  String get cartId => throw _privateConstructorUsedError;
  DateTime get analysisTime => throw _privateConstructorUsedError; // 营养元素分析
  Map<String, NutritionElementAnalysis> get elementAnalysis =>
      throw _privateConstructorUsedError; // 整体评分
  double get overallScore => throw _privateConstructorUsedError; // 0-10
  String get overallStatus =>
      throw _privateConstructorUsedError; // excellent, good, fair, poor
// 建议
  List<String> get improvements => throw _privateConstructorUsedError;
  List<String> get warnings => throw _privateConstructorUsedError;
  List<RecommendedItem> get recommendations =>
      throw _privateConstructorUsedError; // 热量分析
  CalorieAnalysis get calorieAnalysis =>
      throw _privateConstructorUsedError; // 膳食平衡
  MacronutrientBalance get macroBalance =>
      throw _privateConstructorUsedError; // 微量元素状态
  MicronutrientStatus get microStatus => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionBalanceAnalysis value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionBalanceAnalysis value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionBalanceAnalysis value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionBalanceAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionBalanceAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionBalanceAnalysisCopyWith<NutritionBalanceAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionBalanceAnalysisCopyWith<$Res> {
  factory $NutritionBalanceAnalysisCopyWith(NutritionBalanceAnalysis value,
          $Res Function(NutritionBalanceAnalysis) then) =
      _$NutritionBalanceAnalysisCopyWithImpl<$Res, NutritionBalanceAnalysis>;
  @useResult
  $Res call(
      {String cartId,
      DateTime analysisTime,
      Map<String, NutritionElementAnalysis> elementAnalysis,
      double overallScore,
      String overallStatus,
      List<String> improvements,
      List<String> warnings,
      List<RecommendedItem> recommendations,
      CalorieAnalysis calorieAnalysis,
      MacronutrientBalance macroBalance,
      MicronutrientStatus microStatus});

  $CalorieAnalysisCopyWith<$Res> get calorieAnalysis;
  $MacronutrientBalanceCopyWith<$Res> get macroBalance;
  $MicronutrientStatusCopyWith<$Res> get microStatus;
}

/// @nodoc
class _$NutritionBalanceAnalysisCopyWithImpl<$Res,
        $Val extends NutritionBalanceAnalysis>
    implements $NutritionBalanceAnalysisCopyWith<$Res> {
  _$NutritionBalanceAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionBalanceAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cartId = null,
    Object? analysisTime = null,
    Object? elementAnalysis = null,
    Object? overallScore = null,
    Object? overallStatus = null,
    Object? improvements = null,
    Object? warnings = null,
    Object? recommendations = null,
    Object? calorieAnalysis = null,
    Object? macroBalance = null,
    Object? microStatus = null,
  }) {
    return _then(_value.copyWith(
      cartId: null == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String,
      analysisTime: null == analysisTime
          ? _value.analysisTime
          : analysisTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      elementAnalysis: null == elementAnalysis
          ? _value.elementAnalysis
          : elementAnalysis // ignore: cast_nullable_to_non_nullable
              as Map<String, NutritionElementAnalysis>,
      overallScore: null == overallScore
          ? _value.overallScore
          : overallScore // ignore: cast_nullable_to_non_nullable
              as double,
      overallStatus: null == overallStatus
          ? _value.overallStatus
          : overallStatus // ignore: cast_nullable_to_non_nullable
              as String,
      improvements: null == improvements
          ? _value.improvements
          : improvements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      warnings: null == warnings
          ? _value.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<RecommendedItem>,
      calorieAnalysis: null == calorieAnalysis
          ? _value.calorieAnalysis
          : calorieAnalysis // ignore: cast_nullable_to_non_nullable
              as CalorieAnalysis,
      macroBalance: null == macroBalance
          ? _value.macroBalance
          : macroBalance // ignore: cast_nullable_to_non_nullable
              as MacronutrientBalance,
      microStatus: null == microStatus
          ? _value.microStatus
          : microStatus // ignore: cast_nullable_to_non_nullable
              as MicronutrientStatus,
    ) as $Val);
  }

  /// Create a copy of NutritionBalanceAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CalorieAnalysisCopyWith<$Res> get calorieAnalysis {
    return $CalorieAnalysisCopyWith<$Res>(_value.calorieAnalysis, (value) {
      return _then(_value.copyWith(calorieAnalysis: value) as $Val);
    });
  }

  /// Create a copy of NutritionBalanceAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MacronutrientBalanceCopyWith<$Res> get macroBalance {
    return $MacronutrientBalanceCopyWith<$Res>(_value.macroBalance, (value) {
      return _then(_value.copyWith(macroBalance: value) as $Val);
    });
  }

  /// Create a copy of NutritionBalanceAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MicronutrientStatusCopyWith<$Res> get microStatus {
    return $MicronutrientStatusCopyWith<$Res>(_value.microStatus, (value) {
      return _then(_value.copyWith(microStatus: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionBalanceAnalysisImplCopyWith<$Res>
    implements $NutritionBalanceAnalysisCopyWith<$Res> {
  factory _$$NutritionBalanceAnalysisImplCopyWith(
          _$NutritionBalanceAnalysisImpl value,
          $Res Function(_$NutritionBalanceAnalysisImpl) then) =
      __$$NutritionBalanceAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String cartId,
      DateTime analysisTime,
      Map<String, NutritionElementAnalysis> elementAnalysis,
      double overallScore,
      String overallStatus,
      List<String> improvements,
      List<String> warnings,
      List<RecommendedItem> recommendations,
      CalorieAnalysis calorieAnalysis,
      MacronutrientBalance macroBalance,
      MicronutrientStatus microStatus});

  @override
  $CalorieAnalysisCopyWith<$Res> get calorieAnalysis;
  @override
  $MacronutrientBalanceCopyWith<$Res> get macroBalance;
  @override
  $MicronutrientStatusCopyWith<$Res> get microStatus;
}

/// @nodoc
class __$$NutritionBalanceAnalysisImplCopyWithImpl<$Res>
    extends _$NutritionBalanceAnalysisCopyWithImpl<$Res,
        _$NutritionBalanceAnalysisImpl>
    implements _$$NutritionBalanceAnalysisImplCopyWith<$Res> {
  __$$NutritionBalanceAnalysisImplCopyWithImpl(
      _$NutritionBalanceAnalysisImpl _value,
      $Res Function(_$NutritionBalanceAnalysisImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionBalanceAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cartId = null,
    Object? analysisTime = null,
    Object? elementAnalysis = null,
    Object? overallScore = null,
    Object? overallStatus = null,
    Object? improvements = null,
    Object? warnings = null,
    Object? recommendations = null,
    Object? calorieAnalysis = null,
    Object? macroBalance = null,
    Object? microStatus = null,
  }) {
    return _then(_$NutritionBalanceAnalysisImpl(
      cartId: null == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String,
      analysisTime: null == analysisTime
          ? _value.analysisTime
          : analysisTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      elementAnalysis: null == elementAnalysis
          ? _value._elementAnalysis
          : elementAnalysis // ignore: cast_nullable_to_non_nullable
              as Map<String, NutritionElementAnalysis>,
      overallScore: null == overallScore
          ? _value.overallScore
          : overallScore // ignore: cast_nullable_to_non_nullable
              as double,
      overallStatus: null == overallStatus
          ? _value.overallStatus
          : overallStatus // ignore: cast_nullable_to_non_nullable
              as String,
      improvements: null == improvements
          ? _value._improvements
          : improvements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      warnings: null == warnings
          ? _value._warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<RecommendedItem>,
      calorieAnalysis: null == calorieAnalysis
          ? _value.calorieAnalysis
          : calorieAnalysis // ignore: cast_nullable_to_non_nullable
              as CalorieAnalysis,
      macroBalance: null == macroBalance
          ? _value.macroBalance
          : macroBalance // ignore: cast_nullable_to_non_nullable
              as MacronutrientBalance,
      microStatus: null == microStatus
          ? _value.microStatus
          : microStatus // ignore: cast_nullable_to_non_nullable
              as MicronutrientStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionBalanceAnalysisImpl implements _NutritionBalanceAnalysis {
  const _$NutritionBalanceAnalysisImpl(
      {required this.cartId,
      required this.analysisTime,
      required final Map<String, NutritionElementAnalysis> elementAnalysis,
      this.overallScore = 0.0,
      this.overallStatus = 'neutral',
      final List<String> improvements = const [],
      final List<String> warnings = const [],
      final List<RecommendedItem> recommendations = const [],
      required this.calorieAnalysis,
      required this.macroBalance,
      required this.microStatus})
      : _elementAnalysis = elementAnalysis,
        _improvements = improvements,
        _warnings = warnings,
        _recommendations = recommendations;

  factory _$NutritionBalanceAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionBalanceAnalysisImplFromJson(json);

  @override
  final String cartId;
  @override
  final DateTime analysisTime;
// 营养元素分析
  final Map<String, NutritionElementAnalysis> _elementAnalysis;
// 营养元素分析
  @override
  Map<String, NutritionElementAnalysis> get elementAnalysis {
    if (_elementAnalysis is EqualUnmodifiableMapView) return _elementAnalysis;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_elementAnalysis);
  }

// 整体评分
  @override
  @JsonKey()
  final double overallScore;
// 0-10
  @override
  @JsonKey()
  final String overallStatus;
// excellent, good, fair, poor
// 建议
  final List<String> _improvements;
// excellent, good, fair, poor
// 建议
  @override
  @JsonKey()
  List<String> get improvements {
    if (_improvements is EqualUnmodifiableListView) return _improvements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_improvements);
  }

  final List<String> _warnings;
  @override
  @JsonKey()
  List<String> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  final List<RecommendedItem> _recommendations;
  @override
  @JsonKey()
  List<RecommendedItem> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

// 热量分析
  @override
  final CalorieAnalysis calorieAnalysis;
// 膳食平衡
  @override
  final MacronutrientBalance macroBalance;
// 微量元素状态
  @override
  final MicronutrientStatus microStatus;

  @override
  String toString() {
    return 'NutritionBalanceAnalysis(cartId: $cartId, analysisTime: $analysisTime, elementAnalysis: $elementAnalysis, overallScore: $overallScore, overallStatus: $overallStatus, improvements: $improvements, warnings: $warnings, recommendations: $recommendations, calorieAnalysis: $calorieAnalysis, macroBalance: $macroBalance, microStatus: $microStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionBalanceAnalysisImpl &&
            (identical(other.cartId, cartId) || other.cartId == cartId) &&
            (identical(other.analysisTime, analysisTime) ||
                other.analysisTime == analysisTime) &&
            const DeepCollectionEquality()
                .equals(other._elementAnalysis, _elementAnalysis) &&
            (identical(other.overallScore, overallScore) ||
                other.overallScore == overallScore) &&
            (identical(other.overallStatus, overallStatus) ||
                other.overallStatus == overallStatus) &&
            const DeepCollectionEquality()
                .equals(other._improvements, _improvements) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            (identical(other.calorieAnalysis, calorieAnalysis) ||
                other.calorieAnalysis == calorieAnalysis) &&
            (identical(other.macroBalance, macroBalance) ||
                other.macroBalance == macroBalance) &&
            (identical(other.microStatus, microStatus) ||
                other.microStatus == microStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      cartId,
      analysisTime,
      const DeepCollectionEquality().hash(_elementAnalysis),
      overallScore,
      overallStatus,
      const DeepCollectionEquality().hash(_improvements),
      const DeepCollectionEquality().hash(_warnings),
      const DeepCollectionEquality().hash(_recommendations),
      calorieAnalysis,
      macroBalance,
      microStatus);

  /// Create a copy of NutritionBalanceAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionBalanceAnalysisImplCopyWith<_$NutritionBalanceAnalysisImpl>
      get copyWith => __$$NutritionBalanceAnalysisImplCopyWithImpl<
          _$NutritionBalanceAnalysisImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionBalanceAnalysis value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionBalanceAnalysis value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionBalanceAnalysis value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionBalanceAnalysisImplToJson(
      this,
    );
  }
}

abstract class _NutritionBalanceAnalysis implements NutritionBalanceAnalysis {
  const factory _NutritionBalanceAnalysis(
          {required final String cartId,
          required final DateTime analysisTime,
          required final Map<String, NutritionElementAnalysis> elementAnalysis,
          final double overallScore,
          final String overallStatus,
          final List<String> improvements,
          final List<String> warnings,
          final List<RecommendedItem> recommendations,
          required final CalorieAnalysis calorieAnalysis,
          required final MacronutrientBalance macroBalance,
          required final MicronutrientStatus microStatus}) =
      _$NutritionBalanceAnalysisImpl;

  factory _NutritionBalanceAnalysis.fromJson(Map<String, dynamic> json) =
      _$NutritionBalanceAnalysisImpl.fromJson;

  @override
  String get cartId;
  @override
  DateTime get analysisTime; // 营养元素分析
  @override
  Map<String, NutritionElementAnalysis> get elementAnalysis; // 整体评分
  @override
  double get overallScore; // 0-10
  @override
  String get overallStatus; // excellent, good, fair, poor
// 建议
  @override
  List<String> get improvements;
  @override
  List<String> get warnings;
  @override
  List<RecommendedItem> get recommendations; // 热量分析
  @override
  CalorieAnalysis get calorieAnalysis; // 膳食平衡
  @override
  MacronutrientBalance get macroBalance; // 微量元素状态
  @override
  MicronutrientStatus get microStatus;

  /// Create a copy of NutritionBalanceAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionBalanceAnalysisImplCopyWith<_$NutritionBalanceAnalysisImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NutritionElementAnalysis _$NutritionElementAnalysisFromJson(
    Map<String, dynamic> json) {
  return _NutritionElementAnalysis.fromJson(json);
}

/// @nodoc
mixin _$NutritionElementAnalysis {
  String get elementId => throw _privateConstructorUsedError;
  String get elementName => throw _privateConstructorUsedError;
  double get targetAmount => throw _privateConstructorUsedError;
  double get currentAmount => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  double get completionRate => throw _privateConstructorUsedError; // 完成率 0-1+
  String get status =>
      throw _privateConstructorUsedError; // deficient, adequate, excessive
  String? get recommendation => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionElementAnalysis value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionElementAnalysis value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionElementAnalysis value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionElementAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionElementAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionElementAnalysisCopyWith<NutritionElementAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionElementAnalysisCopyWith<$Res> {
  factory $NutritionElementAnalysisCopyWith(NutritionElementAnalysis value,
          $Res Function(NutritionElementAnalysis) then) =
      _$NutritionElementAnalysisCopyWithImpl<$Res, NutritionElementAnalysis>;
  @useResult
  $Res call(
      {String elementId,
      String elementName,
      double targetAmount,
      double currentAmount,
      String unit,
      double completionRate,
      String status,
      String? recommendation});
}

/// @nodoc
class _$NutritionElementAnalysisCopyWithImpl<$Res,
        $Val extends NutritionElementAnalysis>
    implements $NutritionElementAnalysisCopyWith<$Res> {
  _$NutritionElementAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionElementAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? elementId = null,
    Object? elementName = null,
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? unit = null,
    Object? completionRate = null,
    Object? status = null,
    Object? recommendation = freezed,
  }) {
    return _then(_value.copyWith(
      elementId: null == elementId
          ? _value.elementId
          : elementId // ignore: cast_nullable_to_non_nullable
              as String,
      elementName: null == elementName
          ? _value.elementName
          : elementName // ignore: cast_nullable_to_non_nullable
              as String,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currentAmount: null == currentAmount
          ? _value.currentAmount
          : currentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      recommendation: freezed == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionElementAnalysisImplCopyWith<$Res>
    implements $NutritionElementAnalysisCopyWith<$Res> {
  factory _$$NutritionElementAnalysisImplCopyWith(
          _$NutritionElementAnalysisImpl value,
          $Res Function(_$NutritionElementAnalysisImpl) then) =
      __$$NutritionElementAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String elementId,
      String elementName,
      double targetAmount,
      double currentAmount,
      String unit,
      double completionRate,
      String status,
      String? recommendation});
}

/// @nodoc
class __$$NutritionElementAnalysisImplCopyWithImpl<$Res>
    extends _$NutritionElementAnalysisCopyWithImpl<$Res,
        _$NutritionElementAnalysisImpl>
    implements _$$NutritionElementAnalysisImplCopyWith<$Res> {
  __$$NutritionElementAnalysisImplCopyWithImpl(
      _$NutritionElementAnalysisImpl _value,
      $Res Function(_$NutritionElementAnalysisImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionElementAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? elementId = null,
    Object? elementName = null,
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? unit = null,
    Object? completionRate = null,
    Object? status = null,
    Object? recommendation = freezed,
  }) {
    return _then(_$NutritionElementAnalysisImpl(
      elementId: null == elementId
          ? _value.elementId
          : elementId // ignore: cast_nullable_to_non_nullable
              as String,
      elementName: null == elementName
          ? _value.elementName
          : elementName // ignore: cast_nullable_to_non_nullable
              as String,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currentAmount: null == currentAmount
          ? _value.currentAmount
          : currentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      recommendation: freezed == recommendation
          ? _value.recommendation
          : recommendation // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionElementAnalysisImpl implements _NutritionElementAnalysis {
  const _$NutritionElementAnalysisImpl(
      {required this.elementId,
      required this.elementName,
      required this.targetAmount,
      required this.currentAmount,
      required this.unit,
      this.completionRate = 0.0,
      required this.status,
      this.recommendation});

  factory _$NutritionElementAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionElementAnalysisImplFromJson(json);

  @override
  final String elementId;
  @override
  final String elementName;
  @override
  final double targetAmount;
  @override
  final double currentAmount;
  @override
  final String unit;
  @override
  @JsonKey()
  final double completionRate;
// 完成率 0-1+
  @override
  final String status;
// deficient, adequate, excessive
  @override
  final String? recommendation;

  @override
  String toString() {
    return 'NutritionElementAnalysis(elementId: $elementId, elementName: $elementName, targetAmount: $targetAmount, currentAmount: $currentAmount, unit: $unit, completionRate: $completionRate, status: $status, recommendation: $recommendation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionElementAnalysisImpl &&
            (identical(other.elementId, elementId) ||
                other.elementId == elementId) &&
            (identical(other.elementName, elementName) ||
                other.elementName == elementName) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.recommendation, recommendation) ||
                other.recommendation == recommendation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      elementId,
      elementName,
      targetAmount,
      currentAmount,
      unit,
      completionRate,
      status,
      recommendation);

  /// Create a copy of NutritionElementAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionElementAnalysisImplCopyWith<_$NutritionElementAnalysisImpl>
      get copyWith => __$$NutritionElementAnalysisImplCopyWithImpl<
          _$NutritionElementAnalysisImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionElementAnalysis value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionElementAnalysis value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionElementAnalysis value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionElementAnalysisImplToJson(
      this,
    );
  }
}

abstract class _NutritionElementAnalysis implements NutritionElementAnalysis {
  const factory _NutritionElementAnalysis(
      {required final String elementId,
      required final String elementName,
      required final double targetAmount,
      required final double currentAmount,
      required final String unit,
      final double completionRate,
      required final String status,
      final String? recommendation}) = _$NutritionElementAnalysisImpl;

  factory _NutritionElementAnalysis.fromJson(Map<String, dynamic> json) =
      _$NutritionElementAnalysisImpl.fromJson;

  @override
  String get elementId;
  @override
  String get elementName;
  @override
  double get targetAmount;
  @override
  double get currentAmount;
  @override
  String get unit;
  @override
  double get completionRate; // 完成率 0-1+
  @override
  String get status; // deficient, adequate, excessive
  @override
  String? get recommendation;

  /// Create a copy of NutritionElementAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionElementAnalysisImplCopyWith<_$NutritionElementAnalysisImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CalorieAnalysis _$CalorieAnalysisFromJson(Map<String, dynamic> json) {
  return _CalorieAnalysis.fromJson(json);
}

/// @nodoc
mixin _$CalorieAnalysis {
  int get targetCalories => throw _privateConstructorUsedError;
  int get currentCalories => throw _privateConstructorUsedError;
  double get completionRate => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // under, adequate, over
  int get recommendedAdjustment => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CalorieAnalysis value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CalorieAnalysis value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CalorieAnalysis value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this CalorieAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CalorieAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalorieAnalysisCopyWith<CalorieAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalorieAnalysisCopyWith<$Res> {
  factory $CalorieAnalysisCopyWith(
          CalorieAnalysis value, $Res Function(CalorieAnalysis) then) =
      _$CalorieAnalysisCopyWithImpl<$Res, CalorieAnalysis>;
  @useResult
  $Res call(
      {int targetCalories,
      int currentCalories,
      double completionRate,
      String status,
      int recommendedAdjustment});
}

/// @nodoc
class _$CalorieAnalysisCopyWithImpl<$Res, $Val extends CalorieAnalysis>
    implements $CalorieAnalysisCopyWith<$Res> {
  _$CalorieAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalorieAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetCalories = null,
    Object? currentCalories = null,
    Object? completionRate = null,
    Object? status = null,
    Object? recommendedAdjustment = null,
  }) {
    return _then(_value.copyWith(
      targetCalories: null == targetCalories
          ? _value.targetCalories
          : targetCalories // ignore: cast_nullable_to_non_nullable
              as int,
      currentCalories: null == currentCalories
          ? _value.currentCalories
          : currentCalories // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      recommendedAdjustment: null == recommendedAdjustment
          ? _value.recommendedAdjustment
          : recommendedAdjustment // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalorieAnalysisImplCopyWith<$Res>
    implements $CalorieAnalysisCopyWith<$Res> {
  factory _$$CalorieAnalysisImplCopyWith(_$CalorieAnalysisImpl value,
          $Res Function(_$CalorieAnalysisImpl) then) =
      __$$CalorieAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int targetCalories,
      int currentCalories,
      double completionRate,
      String status,
      int recommendedAdjustment});
}

/// @nodoc
class __$$CalorieAnalysisImplCopyWithImpl<$Res>
    extends _$CalorieAnalysisCopyWithImpl<$Res, _$CalorieAnalysisImpl>
    implements _$$CalorieAnalysisImplCopyWith<$Res> {
  __$$CalorieAnalysisImplCopyWithImpl(
      _$CalorieAnalysisImpl _value, $Res Function(_$CalorieAnalysisImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalorieAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetCalories = null,
    Object? currentCalories = null,
    Object? completionRate = null,
    Object? status = null,
    Object? recommendedAdjustment = null,
  }) {
    return _then(_$CalorieAnalysisImpl(
      targetCalories: null == targetCalories
          ? _value.targetCalories
          : targetCalories // ignore: cast_nullable_to_non_nullable
              as int,
      currentCalories: null == currentCalories
          ? _value.currentCalories
          : currentCalories // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      recommendedAdjustment: null == recommendedAdjustment
          ? _value.recommendedAdjustment
          : recommendedAdjustment // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CalorieAnalysisImpl implements _CalorieAnalysis {
  const _$CalorieAnalysisImpl(
      {required this.targetCalories,
      required this.currentCalories,
      this.completionRate = 0.0,
      required this.status,
      this.recommendedAdjustment = 0});

  factory _$CalorieAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalorieAnalysisImplFromJson(json);

  @override
  final int targetCalories;
  @override
  final int currentCalories;
  @override
  @JsonKey()
  final double completionRate;
  @override
  final String status;
// under, adequate, over
  @override
  @JsonKey()
  final int recommendedAdjustment;

  @override
  String toString() {
    return 'CalorieAnalysis(targetCalories: $targetCalories, currentCalories: $currentCalories, completionRate: $completionRate, status: $status, recommendedAdjustment: $recommendedAdjustment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalorieAnalysisImpl &&
            (identical(other.targetCalories, targetCalories) ||
                other.targetCalories == targetCalories) &&
            (identical(other.currentCalories, currentCalories) ||
                other.currentCalories == currentCalories) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.recommendedAdjustment, recommendedAdjustment) ||
                other.recommendedAdjustment == recommendedAdjustment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, targetCalories, currentCalories,
      completionRate, status, recommendedAdjustment);

  /// Create a copy of CalorieAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalorieAnalysisImplCopyWith<_$CalorieAnalysisImpl> get copyWith =>
      __$$CalorieAnalysisImplCopyWithImpl<_$CalorieAnalysisImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CalorieAnalysis value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CalorieAnalysis value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CalorieAnalysis value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CalorieAnalysisImplToJson(
      this,
    );
  }
}

abstract class _CalorieAnalysis implements CalorieAnalysis {
  const factory _CalorieAnalysis(
      {required final int targetCalories,
      required final int currentCalories,
      final double completionRate,
      required final String status,
      final int recommendedAdjustment}) = _$CalorieAnalysisImpl;

  factory _CalorieAnalysis.fromJson(Map<String, dynamic> json) =
      _$CalorieAnalysisImpl.fromJson;

  @override
  int get targetCalories;
  @override
  int get currentCalories;
  @override
  double get completionRate;
  @override
  String get status; // under, adequate, over
  @override
  int get recommendedAdjustment;

  /// Create a copy of CalorieAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalorieAnalysisImplCopyWith<_$CalorieAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MacronutrientBalance _$MacronutrientBalanceFromJson(Map<String, dynamic> json) {
  return _MacronutrientBalance.fromJson(json);
}

/// @nodoc
mixin _$MacronutrientBalance {
// 蛋白质
  double get proteinTarget => throw _privateConstructorUsedError;
  double get proteinCurrent => throw _privateConstructorUsedError;
  double get proteinPercentage => throw _privateConstructorUsedError; // 碳水化合物
  double get carbTarget => throw _privateConstructorUsedError;
  double get carbCurrent => throw _privateConstructorUsedError;
  double get carbPercentage => throw _privateConstructorUsedError; // 脂肪
  double get fatTarget => throw _privateConstructorUsedError;
  double get fatCurrent => throw _privateConstructorUsedError;
  double get fatPercentage => throw _privateConstructorUsedError; // 平衡状态
  String get balanceStatus =>
      throw _privateConstructorUsedError; // balanced, high_protein, high_carb, high_fat
  List<String> get adjustmentSuggestions => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MacronutrientBalance value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MacronutrientBalance value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MacronutrientBalance value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MacronutrientBalance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MacronutrientBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MacronutrientBalanceCopyWith<MacronutrientBalance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MacronutrientBalanceCopyWith<$Res> {
  factory $MacronutrientBalanceCopyWith(MacronutrientBalance value,
          $Res Function(MacronutrientBalance) then) =
      _$MacronutrientBalanceCopyWithImpl<$Res, MacronutrientBalance>;
  @useResult
  $Res call(
      {double proteinTarget,
      double proteinCurrent,
      double proteinPercentage,
      double carbTarget,
      double carbCurrent,
      double carbPercentage,
      double fatTarget,
      double fatCurrent,
      double fatPercentage,
      String balanceStatus,
      List<String> adjustmentSuggestions});
}

/// @nodoc
class _$MacronutrientBalanceCopyWithImpl<$Res,
        $Val extends MacronutrientBalance>
    implements $MacronutrientBalanceCopyWith<$Res> {
  _$MacronutrientBalanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MacronutrientBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? proteinTarget = null,
    Object? proteinCurrent = null,
    Object? proteinPercentage = null,
    Object? carbTarget = null,
    Object? carbCurrent = null,
    Object? carbPercentage = null,
    Object? fatTarget = null,
    Object? fatCurrent = null,
    Object? fatPercentage = null,
    Object? balanceStatus = null,
    Object? adjustmentSuggestions = null,
  }) {
    return _then(_value.copyWith(
      proteinTarget: null == proteinTarget
          ? _value.proteinTarget
          : proteinTarget // ignore: cast_nullable_to_non_nullable
              as double,
      proteinCurrent: null == proteinCurrent
          ? _value.proteinCurrent
          : proteinCurrent // ignore: cast_nullable_to_non_nullable
              as double,
      proteinPercentage: null == proteinPercentage
          ? _value.proteinPercentage
          : proteinPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      carbTarget: null == carbTarget
          ? _value.carbTarget
          : carbTarget // ignore: cast_nullable_to_non_nullable
              as double,
      carbCurrent: null == carbCurrent
          ? _value.carbCurrent
          : carbCurrent // ignore: cast_nullable_to_non_nullable
              as double,
      carbPercentage: null == carbPercentage
          ? _value.carbPercentage
          : carbPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      fatTarget: null == fatTarget
          ? _value.fatTarget
          : fatTarget // ignore: cast_nullable_to_non_nullable
              as double,
      fatCurrent: null == fatCurrent
          ? _value.fatCurrent
          : fatCurrent // ignore: cast_nullable_to_non_nullable
              as double,
      fatPercentage: null == fatPercentage
          ? _value.fatPercentage
          : fatPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      balanceStatus: null == balanceStatus
          ? _value.balanceStatus
          : balanceStatus // ignore: cast_nullable_to_non_nullable
              as String,
      adjustmentSuggestions: null == adjustmentSuggestions
          ? _value.adjustmentSuggestions
          : adjustmentSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MacronutrientBalanceImplCopyWith<$Res>
    implements $MacronutrientBalanceCopyWith<$Res> {
  factory _$$MacronutrientBalanceImplCopyWith(_$MacronutrientBalanceImpl value,
          $Res Function(_$MacronutrientBalanceImpl) then) =
      __$$MacronutrientBalanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double proteinTarget,
      double proteinCurrent,
      double proteinPercentage,
      double carbTarget,
      double carbCurrent,
      double carbPercentage,
      double fatTarget,
      double fatCurrent,
      double fatPercentage,
      String balanceStatus,
      List<String> adjustmentSuggestions});
}

/// @nodoc
class __$$MacronutrientBalanceImplCopyWithImpl<$Res>
    extends _$MacronutrientBalanceCopyWithImpl<$Res, _$MacronutrientBalanceImpl>
    implements _$$MacronutrientBalanceImplCopyWith<$Res> {
  __$$MacronutrientBalanceImplCopyWithImpl(_$MacronutrientBalanceImpl _value,
      $Res Function(_$MacronutrientBalanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of MacronutrientBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? proteinTarget = null,
    Object? proteinCurrent = null,
    Object? proteinPercentage = null,
    Object? carbTarget = null,
    Object? carbCurrent = null,
    Object? carbPercentage = null,
    Object? fatTarget = null,
    Object? fatCurrent = null,
    Object? fatPercentage = null,
    Object? balanceStatus = null,
    Object? adjustmentSuggestions = null,
  }) {
    return _then(_$MacronutrientBalanceImpl(
      proteinTarget: null == proteinTarget
          ? _value.proteinTarget
          : proteinTarget // ignore: cast_nullable_to_non_nullable
              as double,
      proteinCurrent: null == proteinCurrent
          ? _value.proteinCurrent
          : proteinCurrent // ignore: cast_nullable_to_non_nullable
              as double,
      proteinPercentage: null == proteinPercentage
          ? _value.proteinPercentage
          : proteinPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      carbTarget: null == carbTarget
          ? _value.carbTarget
          : carbTarget // ignore: cast_nullable_to_non_nullable
              as double,
      carbCurrent: null == carbCurrent
          ? _value.carbCurrent
          : carbCurrent // ignore: cast_nullable_to_non_nullable
              as double,
      carbPercentage: null == carbPercentage
          ? _value.carbPercentage
          : carbPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      fatTarget: null == fatTarget
          ? _value.fatTarget
          : fatTarget // ignore: cast_nullable_to_non_nullable
              as double,
      fatCurrent: null == fatCurrent
          ? _value.fatCurrent
          : fatCurrent // ignore: cast_nullable_to_non_nullable
              as double,
      fatPercentage: null == fatPercentage
          ? _value.fatPercentage
          : fatPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      balanceStatus: null == balanceStatus
          ? _value.balanceStatus
          : balanceStatus // ignore: cast_nullable_to_non_nullable
              as String,
      adjustmentSuggestions: null == adjustmentSuggestions
          ? _value._adjustmentSuggestions
          : adjustmentSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MacronutrientBalanceImpl implements _MacronutrientBalance {
  const _$MacronutrientBalanceImpl(
      {required this.proteinTarget,
      required this.proteinCurrent,
      this.proteinPercentage = 0.0,
      required this.carbTarget,
      required this.carbCurrent,
      this.carbPercentage = 0.0,
      required this.fatTarget,
      required this.fatCurrent,
      this.fatPercentage = 0.0,
      required this.balanceStatus,
      final List<String> adjustmentSuggestions = const []})
      : _adjustmentSuggestions = adjustmentSuggestions;

  factory _$MacronutrientBalanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$MacronutrientBalanceImplFromJson(json);

// 蛋白质
  @override
  final double proteinTarget;
  @override
  final double proteinCurrent;
  @override
  @JsonKey()
  final double proteinPercentage;
// 碳水化合物
  @override
  final double carbTarget;
  @override
  final double carbCurrent;
  @override
  @JsonKey()
  final double carbPercentage;
// 脂肪
  @override
  final double fatTarget;
  @override
  final double fatCurrent;
  @override
  @JsonKey()
  final double fatPercentage;
// 平衡状态
  @override
  final String balanceStatus;
// balanced, high_protein, high_carb, high_fat
  final List<String> _adjustmentSuggestions;
// balanced, high_protein, high_carb, high_fat
  @override
  @JsonKey()
  List<String> get adjustmentSuggestions {
    if (_adjustmentSuggestions is EqualUnmodifiableListView)
      return _adjustmentSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adjustmentSuggestions);
  }

  @override
  String toString() {
    return 'MacronutrientBalance(proteinTarget: $proteinTarget, proteinCurrent: $proteinCurrent, proteinPercentage: $proteinPercentage, carbTarget: $carbTarget, carbCurrent: $carbCurrent, carbPercentage: $carbPercentage, fatTarget: $fatTarget, fatCurrent: $fatCurrent, fatPercentage: $fatPercentage, balanceStatus: $balanceStatus, adjustmentSuggestions: $adjustmentSuggestions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MacronutrientBalanceImpl &&
            (identical(other.proteinTarget, proteinTarget) ||
                other.proteinTarget == proteinTarget) &&
            (identical(other.proteinCurrent, proteinCurrent) ||
                other.proteinCurrent == proteinCurrent) &&
            (identical(other.proteinPercentage, proteinPercentage) ||
                other.proteinPercentage == proteinPercentage) &&
            (identical(other.carbTarget, carbTarget) ||
                other.carbTarget == carbTarget) &&
            (identical(other.carbCurrent, carbCurrent) ||
                other.carbCurrent == carbCurrent) &&
            (identical(other.carbPercentage, carbPercentage) ||
                other.carbPercentage == carbPercentage) &&
            (identical(other.fatTarget, fatTarget) ||
                other.fatTarget == fatTarget) &&
            (identical(other.fatCurrent, fatCurrent) ||
                other.fatCurrent == fatCurrent) &&
            (identical(other.fatPercentage, fatPercentage) ||
                other.fatPercentage == fatPercentage) &&
            (identical(other.balanceStatus, balanceStatus) ||
                other.balanceStatus == balanceStatus) &&
            const DeepCollectionEquality()
                .equals(other._adjustmentSuggestions, _adjustmentSuggestions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      proteinTarget,
      proteinCurrent,
      proteinPercentage,
      carbTarget,
      carbCurrent,
      carbPercentage,
      fatTarget,
      fatCurrent,
      fatPercentage,
      balanceStatus,
      const DeepCollectionEquality().hash(_adjustmentSuggestions));

  /// Create a copy of MacronutrientBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MacronutrientBalanceImplCopyWith<_$MacronutrientBalanceImpl>
      get copyWith =>
          __$$MacronutrientBalanceImplCopyWithImpl<_$MacronutrientBalanceImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MacronutrientBalance value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MacronutrientBalance value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MacronutrientBalance value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MacronutrientBalanceImplToJson(
      this,
    );
  }
}

abstract class _MacronutrientBalance implements MacronutrientBalance {
  const factory _MacronutrientBalance(
      {required final double proteinTarget,
      required final double proteinCurrent,
      final double proteinPercentage,
      required final double carbTarget,
      required final double carbCurrent,
      final double carbPercentage,
      required final double fatTarget,
      required final double fatCurrent,
      final double fatPercentage,
      required final String balanceStatus,
      final List<String> adjustmentSuggestions}) = _$MacronutrientBalanceImpl;

  factory _MacronutrientBalance.fromJson(Map<String, dynamic> json) =
      _$MacronutrientBalanceImpl.fromJson;

// 蛋白质
  @override
  double get proteinTarget;
  @override
  double get proteinCurrent;
  @override
  double get proteinPercentage; // 碳水化合物
  @override
  double get carbTarget;
  @override
  double get carbCurrent;
  @override
  double get carbPercentage; // 脂肪
  @override
  double get fatTarget;
  @override
  double get fatCurrent;
  @override
  double get fatPercentage; // 平衡状态
  @override
  String get balanceStatus; // balanced, high_protein, high_carb, high_fat
  @override
  List<String> get adjustmentSuggestions;

  /// Create a copy of MacronutrientBalance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MacronutrientBalanceImplCopyWith<_$MacronutrientBalanceImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MicronutrientStatus _$MicronutrientStatusFromJson(Map<String, dynamic> json) {
  return _MicronutrientStatus.fromJson(json);
}

/// @nodoc
mixin _$MicronutrientStatus {
// 维生素状态
  Map<String, String> get vitaminStatus =>
      throw _privateConstructorUsedError; // A, C, D, etc. -> adequate/deficient/excessive
  List<String> get vitaminDeficiencies =>
      throw _privateConstructorUsedError; // 矿物质状态
  Map<String, String> get mineralStatus =>
      throw _privateConstructorUsedError; // calcium, iron, etc.
  List<String> get mineralDeficiencies =>
      throw _privateConstructorUsedError; // 膳食纤维
  double get fiberTarget => throw _privateConstructorUsedError;
  double get fiberCurrent => throw _privateConstructorUsedError;
  String get fiberStatus => throw _privateConstructorUsedError; // 水分
  double get hydrationNeeds => throw _privateConstructorUsedError;
  double get estimatedHydration => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MicronutrientStatus value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MicronutrientStatus value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MicronutrientStatus value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MicronutrientStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MicronutrientStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MicronutrientStatusCopyWith<MicronutrientStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MicronutrientStatusCopyWith<$Res> {
  factory $MicronutrientStatusCopyWith(
          MicronutrientStatus value, $Res Function(MicronutrientStatus) then) =
      _$MicronutrientStatusCopyWithImpl<$Res, MicronutrientStatus>;
  @useResult
  $Res call(
      {Map<String, String> vitaminStatus,
      List<String> vitaminDeficiencies,
      Map<String, String> mineralStatus,
      List<String> mineralDeficiencies,
      double fiberTarget,
      double fiberCurrent,
      String fiberStatus,
      double hydrationNeeds,
      double estimatedHydration});
}

/// @nodoc
class _$MicronutrientStatusCopyWithImpl<$Res, $Val extends MicronutrientStatus>
    implements $MicronutrientStatusCopyWith<$Res> {
  _$MicronutrientStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MicronutrientStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vitaminStatus = null,
    Object? vitaminDeficiencies = null,
    Object? mineralStatus = null,
    Object? mineralDeficiencies = null,
    Object? fiberTarget = null,
    Object? fiberCurrent = null,
    Object? fiberStatus = null,
    Object? hydrationNeeds = null,
    Object? estimatedHydration = null,
  }) {
    return _then(_value.copyWith(
      vitaminStatus: null == vitaminStatus
          ? _value.vitaminStatus
          : vitaminStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      vitaminDeficiencies: null == vitaminDeficiencies
          ? _value.vitaminDeficiencies
          : vitaminDeficiencies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mineralStatus: null == mineralStatus
          ? _value.mineralStatus
          : mineralStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      mineralDeficiencies: null == mineralDeficiencies
          ? _value.mineralDeficiencies
          : mineralDeficiencies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fiberTarget: null == fiberTarget
          ? _value.fiberTarget
          : fiberTarget // ignore: cast_nullable_to_non_nullable
              as double,
      fiberCurrent: null == fiberCurrent
          ? _value.fiberCurrent
          : fiberCurrent // ignore: cast_nullable_to_non_nullable
              as double,
      fiberStatus: null == fiberStatus
          ? _value.fiberStatus
          : fiberStatus // ignore: cast_nullable_to_non_nullable
              as String,
      hydrationNeeds: null == hydrationNeeds
          ? _value.hydrationNeeds
          : hydrationNeeds // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedHydration: null == estimatedHydration
          ? _value.estimatedHydration
          : estimatedHydration // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MicronutrientStatusImplCopyWith<$Res>
    implements $MicronutrientStatusCopyWith<$Res> {
  factory _$$MicronutrientStatusImplCopyWith(_$MicronutrientStatusImpl value,
          $Res Function(_$MicronutrientStatusImpl) then) =
      __$$MicronutrientStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, String> vitaminStatus,
      List<String> vitaminDeficiencies,
      Map<String, String> mineralStatus,
      List<String> mineralDeficiencies,
      double fiberTarget,
      double fiberCurrent,
      String fiberStatus,
      double hydrationNeeds,
      double estimatedHydration});
}

/// @nodoc
class __$$MicronutrientStatusImplCopyWithImpl<$Res>
    extends _$MicronutrientStatusCopyWithImpl<$Res, _$MicronutrientStatusImpl>
    implements _$$MicronutrientStatusImplCopyWith<$Res> {
  __$$MicronutrientStatusImplCopyWithImpl(_$MicronutrientStatusImpl _value,
      $Res Function(_$MicronutrientStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of MicronutrientStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vitaminStatus = null,
    Object? vitaminDeficiencies = null,
    Object? mineralStatus = null,
    Object? mineralDeficiencies = null,
    Object? fiberTarget = null,
    Object? fiberCurrent = null,
    Object? fiberStatus = null,
    Object? hydrationNeeds = null,
    Object? estimatedHydration = null,
  }) {
    return _then(_$MicronutrientStatusImpl(
      vitaminStatus: null == vitaminStatus
          ? _value._vitaminStatus
          : vitaminStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      vitaminDeficiencies: null == vitaminDeficiencies
          ? _value._vitaminDeficiencies
          : vitaminDeficiencies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mineralStatus: null == mineralStatus
          ? _value._mineralStatus
          : mineralStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      mineralDeficiencies: null == mineralDeficiencies
          ? _value._mineralDeficiencies
          : mineralDeficiencies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fiberTarget: null == fiberTarget
          ? _value.fiberTarget
          : fiberTarget // ignore: cast_nullable_to_non_nullable
              as double,
      fiberCurrent: null == fiberCurrent
          ? _value.fiberCurrent
          : fiberCurrent // ignore: cast_nullable_to_non_nullable
              as double,
      fiberStatus: null == fiberStatus
          ? _value.fiberStatus
          : fiberStatus // ignore: cast_nullable_to_non_nullable
              as String,
      hydrationNeeds: null == hydrationNeeds
          ? _value.hydrationNeeds
          : hydrationNeeds // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedHydration: null == estimatedHydration
          ? _value.estimatedHydration
          : estimatedHydration // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MicronutrientStatusImpl implements _MicronutrientStatus {
  const _$MicronutrientStatusImpl(
      {final Map<String, String> vitaminStatus = const {},
      final List<String> vitaminDeficiencies = const [],
      final Map<String, String> mineralStatus = const {},
      final List<String> mineralDeficiencies = const [],
      required this.fiberTarget,
      required this.fiberCurrent,
      required this.fiberStatus,
      required this.hydrationNeeds,
      this.estimatedHydration = 0.0})
      : _vitaminStatus = vitaminStatus,
        _vitaminDeficiencies = vitaminDeficiencies,
        _mineralStatus = mineralStatus,
        _mineralDeficiencies = mineralDeficiencies;

  factory _$MicronutrientStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$MicronutrientStatusImplFromJson(json);

// 维生素状态
  final Map<String, String> _vitaminStatus;
// 维生素状态
  @override
  @JsonKey()
  Map<String, String> get vitaminStatus {
    if (_vitaminStatus is EqualUnmodifiableMapView) return _vitaminStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_vitaminStatus);
  }

// A, C, D, etc. -> adequate/deficient/excessive
  final List<String> _vitaminDeficiencies;
// A, C, D, etc. -> adequate/deficient/excessive
  @override
  @JsonKey()
  List<String> get vitaminDeficiencies {
    if (_vitaminDeficiencies is EqualUnmodifiableListView)
      return _vitaminDeficiencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vitaminDeficiencies);
  }

// 矿物质状态
  final Map<String, String> _mineralStatus;
// 矿物质状态
  @override
  @JsonKey()
  Map<String, String> get mineralStatus {
    if (_mineralStatus is EqualUnmodifiableMapView) return _mineralStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_mineralStatus);
  }

// calcium, iron, etc.
  final List<String> _mineralDeficiencies;
// calcium, iron, etc.
  @override
  @JsonKey()
  List<String> get mineralDeficiencies {
    if (_mineralDeficiencies is EqualUnmodifiableListView)
      return _mineralDeficiencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mineralDeficiencies);
  }

// 膳食纤维
  @override
  final double fiberTarget;
  @override
  final double fiberCurrent;
  @override
  final String fiberStatus;
// 水分
  @override
  final double hydrationNeeds;
  @override
  @JsonKey()
  final double estimatedHydration;

  @override
  String toString() {
    return 'MicronutrientStatus(vitaminStatus: $vitaminStatus, vitaminDeficiencies: $vitaminDeficiencies, mineralStatus: $mineralStatus, mineralDeficiencies: $mineralDeficiencies, fiberTarget: $fiberTarget, fiberCurrent: $fiberCurrent, fiberStatus: $fiberStatus, hydrationNeeds: $hydrationNeeds, estimatedHydration: $estimatedHydration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MicronutrientStatusImpl &&
            const DeepCollectionEquality()
                .equals(other._vitaminStatus, _vitaminStatus) &&
            const DeepCollectionEquality()
                .equals(other._vitaminDeficiencies, _vitaminDeficiencies) &&
            const DeepCollectionEquality()
                .equals(other._mineralStatus, _mineralStatus) &&
            const DeepCollectionEquality()
                .equals(other._mineralDeficiencies, _mineralDeficiencies) &&
            (identical(other.fiberTarget, fiberTarget) ||
                other.fiberTarget == fiberTarget) &&
            (identical(other.fiberCurrent, fiberCurrent) ||
                other.fiberCurrent == fiberCurrent) &&
            (identical(other.fiberStatus, fiberStatus) ||
                other.fiberStatus == fiberStatus) &&
            (identical(other.hydrationNeeds, hydrationNeeds) ||
                other.hydrationNeeds == hydrationNeeds) &&
            (identical(other.estimatedHydration, estimatedHydration) ||
                other.estimatedHydration == estimatedHydration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_vitaminStatus),
      const DeepCollectionEquality().hash(_vitaminDeficiencies),
      const DeepCollectionEquality().hash(_mineralStatus),
      const DeepCollectionEquality().hash(_mineralDeficiencies),
      fiberTarget,
      fiberCurrent,
      fiberStatus,
      hydrationNeeds,
      estimatedHydration);

  /// Create a copy of MicronutrientStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MicronutrientStatusImplCopyWith<_$MicronutrientStatusImpl> get copyWith =>
      __$$MicronutrientStatusImplCopyWithImpl<_$MicronutrientStatusImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MicronutrientStatus value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MicronutrientStatus value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MicronutrientStatus value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MicronutrientStatusImplToJson(
      this,
    );
  }
}

abstract class _MicronutrientStatus implements MicronutrientStatus {
  const factory _MicronutrientStatus(
      {final Map<String, String> vitaminStatus,
      final List<String> vitaminDeficiencies,
      final Map<String, String> mineralStatus,
      final List<String> mineralDeficiencies,
      required final double fiberTarget,
      required final double fiberCurrent,
      required final String fiberStatus,
      required final double hydrationNeeds,
      final double estimatedHydration}) = _$MicronutrientStatusImpl;

  factory _MicronutrientStatus.fromJson(Map<String, dynamic> json) =
      _$MicronutrientStatusImpl.fromJson;

// 维生素状态
  @override
  Map<String, String>
      get vitaminStatus; // A, C, D, etc. -> adequate/deficient/excessive
  @override
  List<String> get vitaminDeficiencies; // 矿物质状态
  @override
  Map<String, String> get mineralStatus; // calcium, iron, etc.
  @override
  List<String> get mineralDeficiencies; // 膳食纤维
  @override
  double get fiberTarget;
  @override
  double get fiberCurrent;
  @override
  String get fiberStatus; // 水分
  @override
  double get hydrationNeeds;
  @override
  double get estimatedHydration;

  /// Create a copy of MicronutrientStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MicronutrientStatusImplCopyWith<_$MicronutrientStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecommendedItem _$RecommendedItemFromJson(Map<String, dynamic> json) {
  return _RecommendedItem.fromJson(json);
}

/// @nodoc
mixin _$RecommendedItem {
  String get itemId => throw _privateConstructorUsedError;
  String get itemType => throw _privateConstructorUsedError; // ingredient, dish
  String get name => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  Map<String, double> get nutritionBenefit =>
      throw _privateConstructorUsedError;
  double get improvementScore => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RecommendedItem value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RecommendedItem value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RecommendedItem value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this RecommendedItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendedItemCopyWith<RecommendedItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendedItemCopyWith<$Res> {
  factory $RecommendedItemCopyWith(
          RecommendedItem value, $Res Function(RecommendedItem) then) =
      _$RecommendedItemCopyWithImpl<$Res, RecommendedItem>;
  @useResult
  $Res call(
      {String itemId,
      String itemType,
      String name,
      String reason,
      double quantity,
      String? unit,
      Map<String, double> nutritionBenefit,
      double improvementScore});
}

/// @nodoc
class _$RecommendedItemCopyWithImpl<$Res, $Val extends RecommendedItem>
    implements $RecommendedItemCopyWith<$Res> {
  _$RecommendedItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? itemType = null,
    Object? name = null,
    Object? reason = null,
    Object? quantity = null,
    Object? unit = freezed,
    Object? nutritionBenefit = null,
    Object? improvementScore = null,
  }) {
    return _then(_value.copyWith(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      itemType: null == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionBenefit: null == nutritionBenefit
          ? _value.nutritionBenefit
          : nutritionBenefit // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      improvementScore: null == improvementScore
          ? _value.improvementScore
          : improvementScore // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendedItemImplCopyWith<$Res>
    implements $RecommendedItemCopyWith<$Res> {
  factory _$$RecommendedItemImplCopyWith(_$RecommendedItemImpl value,
          $Res Function(_$RecommendedItemImpl) then) =
      __$$RecommendedItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String itemId,
      String itemType,
      String name,
      String reason,
      double quantity,
      String? unit,
      Map<String, double> nutritionBenefit,
      double improvementScore});
}

/// @nodoc
class __$$RecommendedItemImplCopyWithImpl<$Res>
    extends _$RecommendedItemCopyWithImpl<$Res, _$RecommendedItemImpl>
    implements _$$RecommendedItemImplCopyWith<$Res> {
  __$$RecommendedItemImplCopyWithImpl(
      _$RecommendedItemImpl _value, $Res Function(_$RecommendedItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? itemType = null,
    Object? name = null,
    Object? reason = null,
    Object? quantity = null,
    Object? unit = freezed,
    Object? nutritionBenefit = null,
    Object? improvementScore = null,
  }) {
    return _then(_$RecommendedItemImpl(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      itemType: null == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionBenefit: null == nutritionBenefit
          ? _value._nutritionBenefit
          : nutritionBenefit // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      improvementScore: null == improvementScore
          ? _value.improvementScore
          : improvementScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendedItemImpl implements _RecommendedItem {
  const _$RecommendedItemImpl(
      {required this.itemId,
      required this.itemType,
      required this.name,
      required this.reason,
      this.quantity = 0.0,
      this.unit,
      final Map<String, double> nutritionBenefit = const {},
      this.improvementScore = 0.0})
      : _nutritionBenefit = nutritionBenefit;

  factory _$RecommendedItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendedItemImplFromJson(json);

  @override
  final String itemId;
  @override
  final String itemType;
// ingredient, dish
  @override
  final String name;
  @override
  final String reason;
  @override
  @JsonKey()
  final double quantity;
  @override
  final String? unit;
  final Map<String, double> _nutritionBenefit;
  @override
  @JsonKey()
  Map<String, double> get nutritionBenefit {
    if (_nutritionBenefit is EqualUnmodifiableMapView) return _nutritionBenefit;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionBenefit);
  }

  @override
  @JsonKey()
  final double improvementScore;

  @override
  String toString() {
    return 'RecommendedItem(itemId: $itemId, itemType: $itemType, name: $name, reason: $reason, quantity: $quantity, unit: $unit, nutritionBenefit: $nutritionBenefit, improvementScore: $improvementScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendedItemImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.itemType, itemType) ||
                other.itemType == itemType) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            const DeepCollectionEquality()
                .equals(other._nutritionBenefit, _nutritionBenefit) &&
            (identical(other.improvementScore, improvementScore) ||
                other.improvementScore == improvementScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      itemId,
      itemType,
      name,
      reason,
      quantity,
      unit,
      const DeepCollectionEquality().hash(_nutritionBenefit),
      improvementScore);

  /// Create a copy of RecommendedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendedItemImplCopyWith<_$RecommendedItemImpl> get copyWith =>
      __$$RecommendedItemImplCopyWithImpl<_$RecommendedItemImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RecommendedItem value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RecommendedItem value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RecommendedItem value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendedItemImplToJson(
      this,
    );
  }
}

abstract class _RecommendedItem implements RecommendedItem {
  const factory _RecommendedItem(
      {required final String itemId,
      required final String itemType,
      required final String name,
      required final String reason,
      final double quantity,
      final String? unit,
      final Map<String, double> nutritionBenefit,
      final double improvementScore}) = _$RecommendedItemImpl;

  factory _RecommendedItem.fromJson(Map<String, dynamic> json) =
      _$RecommendedItemImpl.fromJson;

  @override
  String get itemId;
  @override
  String get itemType; // ingredient, dish
  @override
  String get name;
  @override
  String get reason;
  @override
  double get quantity;
  @override
  String? get unit;
  @override
  Map<String, double> get nutritionBenefit;
  @override
  double get improvementScore;

  /// Create a copy of RecommendedItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendedItemImplCopyWith<_$RecommendedItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartOperation _$CartOperationFromJson(Map<String, dynamic> json) {
  return _CartOperation.fromJson(json);
}

/// @nodoc
mixin _$CartOperation {
  String get id => throw _privateConstructorUsedError;
  String get cartId => throw _privateConstructorUsedError;
  String get operation =>
      throw _privateConstructorUsedError; // add, remove, update, clear
  String get itemId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get operationData => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CartOperation value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CartOperation value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CartOperation value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this CartOperation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartOperationCopyWith<CartOperation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartOperationCopyWith<$Res> {
  factory $CartOperationCopyWith(
          CartOperation value, $Res Function(CartOperation) then) =
      _$CartOperationCopyWithImpl<$Res, CartOperation>;
  @useResult
  $Res call(
      {String id,
      String cartId,
      String operation,
      String itemId,
      Map<String, dynamic>? operationData,
      DateTime timestamp,
      String? userId});
}

/// @nodoc
class _$CartOperationCopyWithImpl<$Res, $Val extends CartOperation>
    implements $CartOperationCopyWith<$Res> {
  _$CartOperationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cartId = null,
    Object? operation = null,
    Object? itemId = null,
    Object? operationData = freezed,
    Object? timestamp = null,
    Object? userId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      cartId: null == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String,
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      operationData: freezed == operationData
          ? _value.operationData
          : operationData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartOperationImplCopyWith<$Res>
    implements $CartOperationCopyWith<$Res> {
  factory _$$CartOperationImplCopyWith(
          _$CartOperationImpl value, $Res Function(_$CartOperationImpl) then) =
      __$$CartOperationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String cartId,
      String operation,
      String itemId,
      Map<String, dynamic>? operationData,
      DateTime timestamp,
      String? userId});
}

/// @nodoc
class __$$CartOperationImplCopyWithImpl<$Res>
    extends _$CartOperationCopyWithImpl<$Res, _$CartOperationImpl>
    implements _$$CartOperationImplCopyWith<$Res> {
  __$$CartOperationImplCopyWithImpl(
      _$CartOperationImpl _value, $Res Function(_$CartOperationImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cartId = null,
    Object? operation = null,
    Object? itemId = null,
    Object? operationData = freezed,
    Object? timestamp = null,
    Object? userId = freezed,
  }) {
    return _then(_$CartOperationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      cartId: null == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String,
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      operationData: freezed == operationData
          ? _value._operationData
          : operationData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartOperationImpl implements _CartOperation {
  const _$CartOperationImpl(
      {required this.id,
      required this.cartId,
      required this.operation,
      required this.itemId,
      final Map<String, dynamic>? operationData,
      required this.timestamp,
      this.userId})
      : _operationData = operationData;

  factory _$CartOperationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartOperationImplFromJson(json);

  @override
  final String id;
  @override
  final String cartId;
  @override
  final String operation;
// add, remove, update, clear
  @override
  final String itemId;
  final Map<String, dynamic>? _operationData;
  @override
  Map<String, dynamic>? get operationData {
    final value = _operationData;
    if (value == null) return null;
    if (_operationData is EqualUnmodifiableMapView) return _operationData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime timestamp;
  @override
  final String? userId;

  @override
  String toString() {
    return 'CartOperation(id: $id, cartId: $cartId, operation: $operation, itemId: $itemId, operationData: $operationData, timestamp: $timestamp, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartOperationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cartId, cartId) || other.cartId == cartId) &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            const DeepCollectionEquality()
                .equals(other._operationData, _operationData) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, cartId, operation, itemId,
      const DeepCollectionEquality().hash(_operationData), timestamp, userId);

  /// Create a copy of CartOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartOperationImplCopyWith<_$CartOperationImpl> get copyWith =>
      __$$CartOperationImplCopyWithImpl<_$CartOperationImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CartOperation value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CartOperation value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CartOperation value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CartOperationImplToJson(
      this,
    );
  }
}

abstract class _CartOperation implements CartOperation {
  const factory _CartOperation(
      {required final String id,
      required final String cartId,
      required final String operation,
      required final String itemId,
      final Map<String, dynamic>? operationData,
      required final DateTime timestamp,
      final String? userId}) = _$CartOperationImpl;

  factory _CartOperation.fromJson(Map<String, dynamic> json) =
      _$CartOperationImpl.fromJson;

  @override
  String get id;
  @override
  String get cartId;
  @override
  String get operation; // add, remove, update, clear
  @override
  String get itemId;
  @override
  Map<String, dynamic>? get operationData;
  @override
  DateTime get timestamp;
  @override
  String? get userId;

  /// Create a copy of CartOperation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartOperationImplCopyWith<_$CartOperationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionGoalTemplate _$NutritionGoalTemplateFromJson(
    Map<String, dynamic> json) {
  return _NutritionGoalTemplate.fromJson(json);
}

/// @nodoc
mixin _$NutritionGoalTemplate {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get targetGroup =>
      throw _privateConstructorUsedError; // weight_loss, muscle_gain, health_maintenance等
  Map<String, double> get nutritionTargets =>
      throw _privateConstructorUsedError;
  int get calorieTarget => throw _privateConstructorUsedError;
  List<String> get recommendedFoods => throw _privateConstructorUsedError;
  List<String> get avoidFoods => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionGoalTemplate value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionGoalTemplate value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionGoalTemplate value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionGoalTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionGoalTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionGoalTemplateCopyWith<NutritionGoalTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionGoalTemplateCopyWith<$Res> {
  factory $NutritionGoalTemplateCopyWith(NutritionGoalTemplate value,
          $Res Function(NutritionGoalTemplate) then) =
      _$NutritionGoalTemplateCopyWithImpl<$Res, NutritionGoalTemplate>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String targetGroup,
      Map<String, double> nutritionTargets,
      int calorieTarget,
      List<String> recommendedFoods,
      List<String> avoidFoods,
      bool isDefault});
}

/// @nodoc
class _$NutritionGoalTemplateCopyWithImpl<$Res,
        $Val extends NutritionGoalTemplate>
    implements $NutritionGoalTemplateCopyWith<$Res> {
  _$NutritionGoalTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionGoalTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? targetGroup = null,
    Object? nutritionTargets = null,
    Object? calorieTarget = null,
    Object? recommendedFoods = null,
    Object? avoidFoods = null,
    Object? isDefault = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      targetGroup: null == targetGroup
          ? _value.targetGroup
          : targetGroup // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionTargets: null == nutritionTargets
          ? _value.nutritionTargets
          : nutritionTargets // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      calorieTarget: null == calorieTarget
          ? _value.calorieTarget
          : calorieTarget // ignore: cast_nullable_to_non_nullable
              as int,
      recommendedFoods: null == recommendedFoods
          ? _value.recommendedFoods
          : recommendedFoods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avoidFoods: null == avoidFoods
          ? _value.avoidFoods
          : avoidFoods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionGoalTemplateImplCopyWith<$Res>
    implements $NutritionGoalTemplateCopyWith<$Res> {
  factory _$$NutritionGoalTemplateImplCopyWith(
          _$NutritionGoalTemplateImpl value,
          $Res Function(_$NutritionGoalTemplateImpl) then) =
      __$$NutritionGoalTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String targetGroup,
      Map<String, double> nutritionTargets,
      int calorieTarget,
      List<String> recommendedFoods,
      List<String> avoidFoods,
      bool isDefault});
}

/// @nodoc
class __$$NutritionGoalTemplateImplCopyWithImpl<$Res>
    extends _$NutritionGoalTemplateCopyWithImpl<$Res,
        _$NutritionGoalTemplateImpl>
    implements _$$NutritionGoalTemplateImplCopyWith<$Res> {
  __$$NutritionGoalTemplateImplCopyWithImpl(_$NutritionGoalTemplateImpl _value,
      $Res Function(_$NutritionGoalTemplateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionGoalTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? targetGroup = null,
    Object? nutritionTargets = null,
    Object? calorieTarget = null,
    Object? recommendedFoods = null,
    Object? avoidFoods = null,
    Object? isDefault = null,
  }) {
    return _then(_$NutritionGoalTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      targetGroup: null == targetGroup
          ? _value.targetGroup
          : targetGroup // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionTargets: null == nutritionTargets
          ? _value._nutritionTargets
          : nutritionTargets // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      calorieTarget: null == calorieTarget
          ? _value.calorieTarget
          : calorieTarget // ignore: cast_nullable_to_non_nullable
              as int,
      recommendedFoods: null == recommendedFoods
          ? _value._recommendedFoods
          : recommendedFoods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avoidFoods: null == avoidFoods
          ? _value._avoidFoods
          : avoidFoods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionGoalTemplateImpl implements _NutritionGoalTemplate {
  const _$NutritionGoalTemplateImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.targetGroup,
      required final Map<String, double> nutritionTargets,
      required this.calorieTarget,
      final List<String> recommendedFoods = const [],
      final List<String> avoidFoods = const [],
      this.isDefault = false})
      : _nutritionTargets = nutritionTargets,
        _recommendedFoods = recommendedFoods,
        _avoidFoods = avoidFoods;

  factory _$NutritionGoalTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionGoalTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String targetGroup;
// weight_loss, muscle_gain, health_maintenance等
  final Map<String, double> _nutritionTargets;
// weight_loss, muscle_gain, health_maintenance等
  @override
  Map<String, double> get nutritionTargets {
    if (_nutritionTargets is EqualUnmodifiableMapView) return _nutritionTargets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionTargets);
  }

  @override
  final int calorieTarget;
  final List<String> _recommendedFoods;
  @override
  @JsonKey()
  List<String> get recommendedFoods {
    if (_recommendedFoods is EqualUnmodifiableListView)
      return _recommendedFoods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedFoods);
  }

  final List<String> _avoidFoods;
  @override
  @JsonKey()
  List<String> get avoidFoods {
    if (_avoidFoods is EqualUnmodifiableListView) return _avoidFoods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_avoidFoods);
  }

  @override
  @JsonKey()
  final bool isDefault;

  @override
  String toString() {
    return 'NutritionGoalTemplate(id: $id, name: $name, description: $description, targetGroup: $targetGroup, nutritionTargets: $nutritionTargets, calorieTarget: $calorieTarget, recommendedFoods: $recommendedFoods, avoidFoods: $avoidFoods, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionGoalTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.targetGroup, targetGroup) ||
                other.targetGroup == targetGroup) &&
            const DeepCollectionEquality()
                .equals(other._nutritionTargets, _nutritionTargets) &&
            (identical(other.calorieTarget, calorieTarget) ||
                other.calorieTarget == calorieTarget) &&
            const DeepCollectionEquality()
                .equals(other._recommendedFoods, _recommendedFoods) &&
            const DeepCollectionEquality()
                .equals(other._avoidFoods, _avoidFoods) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      targetGroup,
      const DeepCollectionEquality().hash(_nutritionTargets),
      calorieTarget,
      const DeepCollectionEquality().hash(_recommendedFoods),
      const DeepCollectionEquality().hash(_avoidFoods),
      isDefault);

  /// Create a copy of NutritionGoalTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionGoalTemplateImplCopyWith<_$NutritionGoalTemplateImpl>
      get copyWith => __$$NutritionGoalTemplateImplCopyWithImpl<
          _$NutritionGoalTemplateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionGoalTemplate value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionGoalTemplate value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionGoalTemplate value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionGoalTemplateImplToJson(
      this,
    );
  }
}

abstract class _NutritionGoalTemplate implements NutritionGoalTemplate {
  const factory _NutritionGoalTemplate(
      {required final String id,
      required final String name,
      required final String description,
      required final String targetGroup,
      required final Map<String, double> nutritionTargets,
      required final int calorieTarget,
      final List<String> recommendedFoods,
      final List<String> avoidFoods,
      final bool isDefault}) = _$NutritionGoalTemplateImpl;

  factory _NutritionGoalTemplate.fromJson(Map<String, dynamic> json) =
      _$NutritionGoalTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get targetGroup; // weight_loss, muscle_gain, health_maintenance等
  @override
  Map<String, double> get nutritionTargets;
  @override
  int get calorieTarget;
  @override
  List<String> get recommendedFoods;
  @override
  List<String> get avoidFoods;
  @override
  bool get isDefault;

  /// Create a copy of NutritionGoalTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionGoalTemplateImplCopyWith<_$NutritionGoalTemplateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
