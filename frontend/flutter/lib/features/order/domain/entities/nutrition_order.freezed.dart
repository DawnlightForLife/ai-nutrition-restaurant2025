// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrition_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NutritionOrder _$NutritionOrderFromJson(Map<String, dynamic> json) {
  return _NutritionOrder.fromJson(json);
}

/// @nodoc
mixin _$NutritionOrder {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get profileId => throw _privateConstructorUsedError; // 关联的营养档案
  String? get cartId => throw _privateConstructorUsedError; // 原购物车ID
// 订单基本信息
  String get orderNumber => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // pending, confirmed, preparing, ready, delivering, completed, cancelled
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  DateTime? get estimatedDeliveryTime => throw _privateConstructorUsedError;
  DateTime? get actualDeliveryTime => throw _privateConstructorUsedError;
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  String? get cancellationReason => throw _privateConstructorUsedError; // 营养信息
  List<NutritionOrderItem> get items => throw _privateConstructorUsedError;
  Map<String, double> get totalNutrition =>
      throw _privateConstructorUsedError; // 总营养成分
  int get totalCalories => throw _privateConstructorUsedError;
  double get totalWeight => throw _privateConstructorUsedError;
  NutritionOrderAnalysis get nutritionAnalysis =>
      throw _privateConstructorUsedError; // 订单营养分析
// 商家信息（支持多商家订单）
  Map<String, MerchantOrderGroup> get merchantGroups =>
      throw _privateConstructorUsedError; // 价格信息
  double get subtotal => throw _privateConstructorUsedError;
  double get deliveryFee => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get taxAmount => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  List<String> get appliedCoupons => throw _privateConstructorUsedError; // 配送信息
  String get deliveryMethod =>
      throw _privateConstructorUsedError; // delivery, pickup
  String get deliveryAddress => throw _privateConstructorUsedError;
  String? get deliveryContact => throw _privateConstructorUsedError;
  String? get deliveryPhone => throw _privateConstructorUsedError;
  String? get deliveryNotes => throw _privateConstructorUsedError;
  Map<String, double> get deliveryLocation =>
      throw _privateConstructorUsedError; // lat, lng
// 支付信息
  String? get paymentMethod => throw _privateConstructorUsedError;
  String? get paymentId => throw _privateConstructorUsedError;
  String? get paymentStatus =>
      throw _privateConstructorUsedError; // pending, paid, failed, refunded
  DateTime? get paidAt => throw _privateConstructorUsedError; // 营养目标匹配
  Map<String, double> get nutritionGoals =>
      throw _privateConstructorUsedError; // 用户的营养目标
  double get nutritionMatchScore =>
      throw _privateConstructorUsedError; // 营养匹配评分 0-10
  List<String> get nutritionWarnings => throw _privateConstructorUsedError;
  List<String> get nutritionBenefits =>
      throw _privateConstructorUsedError; // 特殊要求
  List<String> get dietaryRequirements =>
      throw _privateConstructorUsedError; // vegetarian, vegan, gluten-free等
  List<String> get allergenAlerts => throw _privateConstructorUsedError;
  String? get specialInstructions => throw _privateConstructorUsedError; // 评价信息
  double? get rating => throw _privateConstructorUsedError;
  String? get review => throw _privateConstructorUsedError;
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  Map<String, double> get nutritionFeedback =>
      throw _privateConstructorUsedError; // 营养满意度反馈
// 系统信息
  String? get assignedDeliveryDriver => throw _privateConstructorUsedError;
  String? get trackingId => throw _privateConstructorUsedError;
  List<OrderStatusUpdate> get statusHistory =>
      throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionOrder value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionOrder value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionOrder value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionOrderCopyWith<NutritionOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionOrderCopyWith<$Res> {
  factory $NutritionOrderCopyWith(
          NutritionOrder value, $Res Function(NutritionOrder) then) =
      _$NutritionOrderCopyWithImpl<$Res, NutritionOrder>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? profileId,
      String? cartId,
      String orderNumber,
      String status,
      DateTime createdAt,
      DateTime? confirmedAt,
      DateTime? estimatedDeliveryTime,
      DateTime? actualDeliveryTime,
      DateTime? cancelledAt,
      String? cancellationReason,
      List<NutritionOrderItem> items,
      Map<String, double> totalNutrition,
      int totalCalories,
      double totalWeight,
      NutritionOrderAnalysis nutritionAnalysis,
      Map<String, MerchantOrderGroup> merchantGroups,
      double subtotal,
      double deliveryFee,
      double discountAmount,
      double taxAmount,
      double totalAmount,
      List<String> appliedCoupons,
      String deliveryMethod,
      String deliveryAddress,
      String? deliveryContact,
      String? deliveryPhone,
      String? deliveryNotes,
      Map<String, double> deliveryLocation,
      String? paymentMethod,
      String? paymentId,
      String? paymentStatus,
      DateTime? paidAt,
      Map<String, double> nutritionGoals,
      double nutritionMatchScore,
      List<String> nutritionWarnings,
      List<String> nutritionBenefits,
      List<String> dietaryRequirements,
      List<String> allergenAlerts,
      String? specialInstructions,
      double? rating,
      String? review,
      DateTime? reviewedAt,
      Map<String, double> nutritionFeedback,
      String? assignedDeliveryDriver,
      String? trackingId,
      List<OrderStatusUpdate> statusHistory,
      DateTime? updatedAt});

  $NutritionOrderAnalysisCopyWith<$Res> get nutritionAnalysis;
}

/// @nodoc
class _$NutritionOrderCopyWithImpl<$Res, $Val extends NutritionOrder>
    implements $NutritionOrderCopyWith<$Res> {
  _$NutritionOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? profileId = freezed,
    Object? cartId = freezed,
    Object? orderNumber = null,
    Object? status = null,
    Object? createdAt = null,
    Object? confirmedAt = freezed,
    Object? estimatedDeliveryTime = freezed,
    Object? actualDeliveryTime = freezed,
    Object? cancelledAt = freezed,
    Object? cancellationReason = freezed,
    Object? items = null,
    Object? totalNutrition = null,
    Object? totalCalories = null,
    Object? totalWeight = null,
    Object? nutritionAnalysis = null,
    Object? merchantGroups = null,
    Object? subtotal = null,
    Object? deliveryFee = null,
    Object? discountAmount = null,
    Object? taxAmount = null,
    Object? totalAmount = null,
    Object? appliedCoupons = null,
    Object? deliveryMethod = null,
    Object? deliveryAddress = null,
    Object? deliveryContact = freezed,
    Object? deliveryPhone = freezed,
    Object? deliveryNotes = freezed,
    Object? deliveryLocation = null,
    Object? paymentMethod = freezed,
    Object? paymentId = freezed,
    Object? paymentStatus = freezed,
    Object? paidAt = freezed,
    Object? nutritionGoals = null,
    Object? nutritionMatchScore = null,
    Object? nutritionWarnings = null,
    Object? nutritionBenefits = null,
    Object? dietaryRequirements = null,
    Object? allergenAlerts = null,
    Object? specialInstructions = freezed,
    Object? rating = freezed,
    Object? review = freezed,
    Object? reviewedAt = freezed,
    Object? nutritionFeedback = null,
    Object? assignedDeliveryDriver = freezed,
    Object? trackingId = freezed,
    Object? statusHistory = null,
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
      cartId: freezed == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String?,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedDeliveryTime: freezed == estimatedDeliveryTime
          ? _value.estimatedDeliveryTime
          : estimatedDeliveryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualDeliveryTime: freezed == actualDeliveryTime
          ? _value.actualDeliveryTime
          : actualDeliveryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NutritionOrderItem>,
      totalNutrition: null == totalNutrition
          ? _value.totalNutrition
          : totalNutrition // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      totalWeight: null == totalWeight
          ? _value.totalWeight
          : totalWeight // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionAnalysis: null == nutritionAnalysis
          ? _value.nutritionAnalysis
          : nutritionAnalysis // ignore: cast_nullable_to_non_nullable
              as NutritionOrderAnalysis,
      merchantGroups: null == merchantGroups
          ? _value.merchantGroups
          : merchantGroups // ignore: cast_nullable_to_non_nullable
              as Map<String, MerchantOrderGroup>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      appliedCoupons: null == appliedCoupons
          ? _value.appliedCoupons
          : appliedCoupons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      deliveryMethod: null == deliveryMethod
          ? _value.deliveryMethod
          : deliveryMethod // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryAddress: null == deliveryAddress
          ? _value.deliveryAddress
          : deliveryAddress // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryContact: freezed == deliveryContact
          ? _value.deliveryContact
          : deliveryContact // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryPhone: freezed == deliveryPhone
          ? _value.deliveryPhone
          : deliveryPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryNotes: freezed == deliveryNotes
          ? _value.deliveryNotes
          : deliveryNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryLocation: null == deliveryLocation
          ? _value.deliveryLocation
          : deliveryLocation // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nutritionGoals: null == nutritionGoals
          ? _value.nutritionGoals
          : nutritionGoals // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      nutritionMatchScore: null == nutritionMatchScore
          ? _value.nutritionMatchScore
          : nutritionMatchScore // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionWarnings: null == nutritionWarnings
          ? _value.nutritionWarnings
          : nutritionWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionBenefits: null == nutritionBenefits
          ? _value.nutritionBenefits
          : nutritionBenefits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dietaryRequirements: null == dietaryRequirements
          ? _value.dietaryRequirements
          : dietaryRequirements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergenAlerts: null == allergenAlerts
          ? _value.allergenAlerts
          : allergenAlerts // ignore: cast_nullable_to_non_nullable
              as List<String>,
      specialInstructions: freezed == specialInstructions
          ? _value.specialInstructions
          : specialInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      review: freezed == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nutritionFeedback: null == nutritionFeedback
          ? _value.nutritionFeedback
          : nutritionFeedback // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      assignedDeliveryDriver: freezed == assignedDeliveryDriver
          ? _value.assignedDeliveryDriver
          : assignedDeliveryDriver // ignore: cast_nullable_to_non_nullable
              as String?,
      trackingId: freezed == trackingId
          ? _value.trackingId
          : trackingId // ignore: cast_nullable_to_non_nullable
              as String?,
      statusHistory: null == statusHistory
          ? _value.statusHistory
          : statusHistory // ignore: cast_nullable_to_non_nullable
              as List<OrderStatusUpdate>,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of NutritionOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionOrderAnalysisCopyWith<$Res> get nutritionAnalysis {
    return $NutritionOrderAnalysisCopyWith<$Res>(_value.nutritionAnalysis,
        (value) {
      return _then(_value.copyWith(nutritionAnalysis: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionOrderImplCopyWith<$Res>
    implements $NutritionOrderCopyWith<$Res> {
  factory _$$NutritionOrderImplCopyWith(_$NutritionOrderImpl value,
          $Res Function(_$NutritionOrderImpl) then) =
      __$$NutritionOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? profileId,
      String? cartId,
      String orderNumber,
      String status,
      DateTime createdAt,
      DateTime? confirmedAt,
      DateTime? estimatedDeliveryTime,
      DateTime? actualDeliveryTime,
      DateTime? cancelledAt,
      String? cancellationReason,
      List<NutritionOrderItem> items,
      Map<String, double> totalNutrition,
      int totalCalories,
      double totalWeight,
      NutritionOrderAnalysis nutritionAnalysis,
      Map<String, MerchantOrderGroup> merchantGroups,
      double subtotal,
      double deliveryFee,
      double discountAmount,
      double taxAmount,
      double totalAmount,
      List<String> appliedCoupons,
      String deliveryMethod,
      String deliveryAddress,
      String? deliveryContact,
      String? deliveryPhone,
      String? deliveryNotes,
      Map<String, double> deliveryLocation,
      String? paymentMethod,
      String? paymentId,
      String? paymentStatus,
      DateTime? paidAt,
      Map<String, double> nutritionGoals,
      double nutritionMatchScore,
      List<String> nutritionWarnings,
      List<String> nutritionBenefits,
      List<String> dietaryRequirements,
      List<String> allergenAlerts,
      String? specialInstructions,
      double? rating,
      String? review,
      DateTime? reviewedAt,
      Map<String, double> nutritionFeedback,
      String? assignedDeliveryDriver,
      String? trackingId,
      List<OrderStatusUpdate> statusHistory,
      DateTime? updatedAt});

  @override
  $NutritionOrderAnalysisCopyWith<$Res> get nutritionAnalysis;
}

/// @nodoc
class __$$NutritionOrderImplCopyWithImpl<$Res>
    extends _$NutritionOrderCopyWithImpl<$Res, _$NutritionOrderImpl>
    implements _$$NutritionOrderImplCopyWith<$Res> {
  __$$NutritionOrderImplCopyWithImpl(
      _$NutritionOrderImpl _value, $Res Function(_$NutritionOrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? profileId = freezed,
    Object? cartId = freezed,
    Object? orderNumber = null,
    Object? status = null,
    Object? createdAt = null,
    Object? confirmedAt = freezed,
    Object? estimatedDeliveryTime = freezed,
    Object? actualDeliveryTime = freezed,
    Object? cancelledAt = freezed,
    Object? cancellationReason = freezed,
    Object? items = null,
    Object? totalNutrition = null,
    Object? totalCalories = null,
    Object? totalWeight = null,
    Object? nutritionAnalysis = null,
    Object? merchantGroups = null,
    Object? subtotal = null,
    Object? deliveryFee = null,
    Object? discountAmount = null,
    Object? taxAmount = null,
    Object? totalAmount = null,
    Object? appliedCoupons = null,
    Object? deliveryMethod = null,
    Object? deliveryAddress = null,
    Object? deliveryContact = freezed,
    Object? deliveryPhone = freezed,
    Object? deliveryNotes = freezed,
    Object? deliveryLocation = null,
    Object? paymentMethod = freezed,
    Object? paymentId = freezed,
    Object? paymentStatus = freezed,
    Object? paidAt = freezed,
    Object? nutritionGoals = null,
    Object? nutritionMatchScore = null,
    Object? nutritionWarnings = null,
    Object? nutritionBenefits = null,
    Object? dietaryRequirements = null,
    Object? allergenAlerts = null,
    Object? specialInstructions = freezed,
    Object? rating = freezed,
    Object? review = freezed,
    Object? reviewedAt = freezed,
    Object? nutritionFeedback = null,
    Object? assignedDeliveryDriver = freezed,
    Object? trackingId = freezed,
    Object? statusHistory = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$NutritionOrderImpl(
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
      cartId: freezed == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String?,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedDeliveryTime: freezed == estimatedDeliveryTime
          ? _value.estimatedDeliveryTime
          : estimatedDeliveryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualDeliveryTime: freezed == actualDeliveryTime
          ? _value.actualDeliveryTime
          : actualDeliveryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NutritionOrderItem>,
      totalNutrition: null == totalNutrition
          ? _value._totalNutrition
          : totalNutrition // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      totalWeight: null == totalWeight
          ? _value.totalWeight
          : totalWeight // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionAnalysis: null == nutritionAnalysis
          ? _value.nutritionAnalysis
          : nutritionAnalysis // ignore: cast_nullable_to_non_nullable
              as NutritionOrderAnalysis,
      merchantGroups: null == merchantGroups
          ? _value._merchantGroups
          : merchantGroups // ignore: cast_nullable_to_non_nullable
              as Map<String, MerchantOrderGroup>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      appliedCoupons: null == appliedCoupons
          ? _value._appliedCoupons
          : appliedCoupons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      deliveryMethod: null == deliveryMethod
          ? _value.deliveryMethod
          : deliveryMethod // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryAddress: null == deliveryAddress
          ? _value.deliveryAddress
          : deliveryAddress // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryContact: freezed == deliveryContact
          ? _value.deliveryContact
          : deliveryContact // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryPhone: freezed == deliveryPhone
          ? _value.deliveryPhone
          : deliveryPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryNotes: freezed == deliveryNotes
          ? _value.deliveryNotes
          : deliveryNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryLocation: null == deliveryLocation
          ? _value._deliveryLocation
          : deliveryLocation // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nutritionGoals: null == nutritionGoals
          ? _value._nutritionGoals
          : nutritionGoals // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      nutritionMatchScore: null == nutritionMatchScore
          ? _value.nutritionMatchScore
          : nutritionMatchScore // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionWarnings: null == nutritionWarnings
          ? _value._nutritionWarnings
          : nutritionWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionBenefits: null == nutritionBenefits
          ? _value._nutritionBenefits
          : nutritionBenefits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dietaryRequirements: null == dietaryRequirements
          ? _value._dietaryRequirements
          : dietaryRequirements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergenAlerts: null == allergenAlerts
          ? _value._allergenAlerts
          : allergenAlerts // ignore: cast_nullable_to_non_nullable
              as List<String>,
      specialInstructions: freezed == specialInstructions
          ? _value.specialInstructions
          : specialInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      review: freezed == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nutritionFeedback: null == nutritionFeedback
          ? _value._nutritionFeedback
          : nutritionFeedback // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      assignedDeliveryDriver: freezed == assignedDeliveryDriver
          ? _value.assignedDeliveryDriver
          : assignedDeliveryDriver // ignore: cast_nullable_to_non_nullable
              as String?,
      trackingId: freezed == trackingId
          ? _value.trackingId
          : trackingId // ignore: cast_nullable_to_non_nullable
              as String?,
      statusHistory: null == statusHistory
          ? _value._statusHistory
          : statusHistory // ignore: cast_nullable_to_non_nullable
              as List<OrderStatusUpdate>,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionOrderImpl implements _NutritionOrder {
  const _$NutritionOrderImpl(
      {required this.id,
      required this.userId,
      this.profileId,
      this.cartId,
      required this.orderNumber,
      required this.status,
      required this.createdAt,
      this.confirmedAt,
      this.estimatedDeliveryTime,
      this.actualDeliveryTime,
      this.cancelledAt,
      this.cancellationReason,
      required final List<NutritionOrderItem> items,
      required final Map<String, double> totalNutrition,
      required this.totalCalories,
      required this.totalWeight,
      required this.nutritionAnalysis,
      required final Map<String, MerchantOrderGroup> merchantGroups,
      required this.subtotal,
      required this.deliveryFee,
      required this.discountAmount,
      required this.taxAmount,
      required this.totalAmount,
      final List<String> appliedCoupons = const [],
      required this.deliveryMethod,
      required this.deliveryAddress,
      this.deliveryContact,
      this.deliveryPhone,
      this.deliveryNotes,
      final Map<String, double> deliveryLocation = const {},
      this.paymentMethod,
      this.paymentId,
      this.paymentStatus,
      this.paidAt,
      final Map<String, double> nutritionGoals = const {},
      this.nutritionMatchScore = 0.0,
      final List<String> nutritionWarnings = const [],
      final List<String> nutritionBenefits = const [],
      final List<String> dietaryRequirements = const [],
      final List<String> allergenAlerts = const [],
      this.specialInstructions,
      this.rating,
      this.review,
      this.reviewedAt,
      final Map<String, double> nutritionFeedback = const {},
      this.assignedDeliveryDriver,
      this.trackingId,
      final List<OrderStatusUpdate> statusHistory = const [],
      this.updatedAt})
      : _items = items,
        _totalNutrition = totalNutrition,
        _merchantGroups = merchantGroups,
        _appliedCoupons = appliedCoupons,
        _deliveryLocation = deliveryLocation,
        _nutritionGoals = nutritionGoals,
        _nutritionWarnings = nutritionWarnings,
        _nutritionBenefits = nutritionBenefits,
        _dietaryRequirements = dietaryRequirements,
        _allergenAlerts = allergenAlerts,
        _nutritionFeedback = nutritionFeedback,
        _statusHistory = statusHistory;

  factory _$NutritionOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionOrderImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? profileId;
// 关联的营养档案
  @override
  final String? cartId;
// 原购物车ID
// 订单基本信息
  @override
  final String orderNumber;
  @override
  final String status;
// pending, confirmed, preparing, ready, delivering, completed, cancelled
  @override
  final DateTime createdAt;
  @override
  final DateTime? confirmedAt;
  @override
  final DateTime? estimatedDeliveryTime;
  @override
  final DateTime? actualDeliveryTime;
  @override
  final DateTime? cancelledAt;
  @override
  final String? cancellationReason;
// 营养信息
  final List<NutritionOrderItem> _items;
// 营养信息
  @override
  List<NutritionOrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final Map<String, double> _totalNutrition;
  @override
  Map<String, double> get totalNutrition {
    if (_totalNutrition is EqualUnmodifiableMapView) return _totalNutrition;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_totalNutrition);
  }

// 总营养成分
  @override
  final int totalCalories;
  @override
  final double totalWeight;
  @override
  final NutritionOrderAnalysis nutritionAnalysis;
// 订单营养分析
// 商家信息（支持多商家订单）
  final Map<String, MerchantOrderGroup> _merchantGroups;
// 订单营养分析
// 商家信息（支持多商家订单）
  @override
  Map<String, MerchantOrderGroup> get merchantGroups {
    if (_merchantGroups is EqualUnmodifiableMapView) return _merchantGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_merchantGroups);
  }

// 价格信息
  @override
  final double subtotal;
  @override
  final double deliveryFee;
  @override
  final double discountAmount;
  @override
  final double taxAmount;
  @override
  final double totalAmount;
  final List<String> _appliedCoupons;
  @override
  @JsonKey()
  List<String> get appliedCoupons {
    if (_appliedCoupons is EqualUnmodifiableListView) return _appliedCoupons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appliedCoupons);
  }

// 配送信息
  @override
  final String deliveryMethod;
// delivery, pickup
  @override
  final String deliveryAddress;
  @override
  final String? deliveryContact;
  @override
  final String? deliveryPhone;
  @override
  final String? deliveryNotes;
  final Map<String, double> _deliveryLocation;
  @override
  @JsonKey()
  Map<String, double> get deliveryLocation {
    if (_deliveryLocation is EqualUnmodifiableMapView) return _deliveryLocation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_deliveryLocation);
  }

// lat, lng
// 支付信息
  @override
  final String? paymentMethod;
  @override
  final String? paymentId;
  @override
  final String? paymentStatus;
// pending, paid, failed, refunded
  @override
  final DateTime? paidAt;
// 营养目标匹配
  final Map<String, double> _nutritionGoals;
// 营养目标匹配
  @override
  @JsonKey()
  Map<String, double> get nutritionGoals {
    if (_nutritionGoals is EqualUnmodifiableMapView) return _nutritionGoals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionGoals);
  }

// 用户的营养目标
  @override
  @JsonKey()
  final double nutritionMatchScore;
// 营养匹配评分 0-10
  final List<String> _nutritionWarnings;
// 营养匹配评分 0-10
  @override
  @JsonKey()
  List<String> get nutritionWarnings {
    if (_nutritionWarnings is EqualUnmodifiableListView)
      return _nutritionWarnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionWarnings);
  }

  final List<String> _nutritionBenefits;
  @override
  @JsonKey()
  List<String> get nutritionBenefits {
    if (_nutritionBenefits is EqualUnmodifiableListView)
      return _nutritionBenefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionBenefits);
  }

// 特殊要求
  final List<String> _dietaryRequirements;
// 特殊要求
  @override
  @JsonKey()
  List<String> get dietaryRequirements {
    if (_dietaryRequirements is EqualUnmodifiableListView)
      return _dietaryRequirements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dietaryRequirements);
  }

// vegetarian, vegan, gluten-free等
  final List<String> _allergenAlerts;
// vegetarian, vegan, gluten-free等
  @override
  @JsonKey()
  List<String> get allergenAlerts {
    if (_allergenAlerts is EqualUnmodifiableListView) return _allergenAlerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergenAlerts);
  }

  @override
  final String? specialInstructions;
// 评价信息
  @override
  final double? rating;
  @override
  final String? review;
  @override
  final DateTime? reviewedAt;
  final Map<String, double> _nutritionFeedback;
  @override
  @JsonKey()
  Map<String, double> get nutritionFeedback {
    if (_nutritionFeedback is EqualUnmodifiableMapView)
      return _nutritionFeedback;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionFeedback);
  }

// 营养满意度反馈
// 系统信息
  @override
  final String? assignedDeliveryDriver;
  @override
  final String? trackingId;
  final List<OrderStatusUpdate> _statusHistory;
  @override
  @JsonKey()
  List<OrderStatusUpdate> get statusHistory {
    if (_statusHistory is EqualUnmodifiableListView) return _statusHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statusHistory);
  }

  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'NutritionOrder(id: $id, userId: $userId, profileId: $profileId, cartId: $cartId, orderNumber: $orderNumber, status: $status, createdAt: $createdAt, confirmedAt: $confirmedAt, estimatedDeliveryTime: $estimatedDeliveryTime, actualDeliveryTime: $actualDeliveryTime, cancelledAt: $cancelledAt, cancellationReason: $cancellationReason, items: $items, totalNutrition: $totalNutrition, totalCalories: $totalCalories, totalWeight: $totalWeight, nutritionAnalysis: $nutritionAnalysis, merchantGroups: $merchantGroups, subtotal: $subtotal, deliveryFee: $deliveryFee, discountAmount: $discountAmount, taxAmount: $taxAmount, totalAmount: $totalAmount, appliedCoupons: $appliedCoupons, deliveryMethod: $deliveryMethod, deliveryAddress: $deliveryAddress, deliveryContact: $deliveryContact, deliveryPhone: $deliveryPhone, deliveryNotes: $deliveryNotes, deliveryLocation: $deliveryLocation, paymentMethod: $paymentMethod, paymentId: $paymentId, paymentStatus: $paymentStatus, paidAt: $paidAt, nutritionGoals: $nutritionGoals, nutritionMatchScore: $nutritionMatchScore, nutritionWarnings: $nutritionWarnings, nutritionBenefits: $nutritionBenefits, dietaryRequirements: $dietaryRequirements, allergenAlerts: $allergenAlerts, specialInstructions: $specialInstructions, rating: $rating, review: $review, reviewedAt: $reviewedAt, nutritionFeedback: $nutritionFeedback, assignedDeliveryDriver: $assignedDeliveryDriver, trackingId: $trackingId, statusHistory: $statusHistory, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.cartId, cartId) || other.cartId == cartId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.estimatedDeliveryTime, estimatedDeliveryTime) ||
                other.estimatedDeliveryTime == estimatedDeliveryTime) &&
            (identical(other.actualDeliveryTime, actualDeliveryTime) ||
                other.actualDeliveryTime == actualDeliveryTime) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other._totalNutrition, _totalNutrition) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.totalWeight, totalWeight) ||
                other.totalWeight == totalWeight) &&
            (identical(other.nutritionAnalysis, nutritionAnalysis) ||
                other.nutritionAnalysis == nutritionAnalysis) &&
            const DeepCollectionEquality()
                .equals(other._merchantGroups, _merchantGroups) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality()
                .equals(other._appliedCoupons, _appliedCoupons) &&
            (identical(other.deliveryMethod, deliveryMethod) ||
                other.deliveryMethod == deliveryMethod) &&
            (identical(other.deliveryAddress, deliveryAddress) ||
                other.deliveryAddress == deliveryAddress) &&
            (identical(other.deliveryContact, deliveryContact) ||
                other.deliveryContact == deliveryContact) &&
            (identical(other.deliveryPhone, deliveryPhone) ||
                other.deliveryPhone == deliveryPhone) &&
            (identical(other.deliveryNotes, deliveryNotes) ||
                other.deliveryNotes == deliveryNotes) &&
            const DeepCollectionEquality()
                .equals(other._deliveryLocation, _deliveryLocation) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            const DeepCollectionEquality()
                .equals(other._nutritionGoals, _nutritionGoals) &&
            (identical(other.nutritionMatchScore, nutritionMatchScore) ||
                other.nutritionMatchScore == nutritionMatchScore) &&
            const DeepCollectionEquality()
                .equals(other._nutritionWarnings, _nutritionWarnings) &&
            const DeepCollectionEquality()
                .equals(other._nutritionBenefits, _nutritionBenefits) &&
            const DeepCollectionEquality()
                .equals(other._dietaryRequirements, _dietaryRequirements) &&
            const DeepCollectionEquality()
                .equals(other._allergenAlerts, _allergenAlerts) &&
            (identical(other.specialInstructions, specialInstructions) ||
                other.specialInstructions == specialInstructions) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.review, review) || other.review == review) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            const DeepCollectionEquality()
                .equals(other._nutritionFeedback, _nutritionFeedback) &&
            (identical(other.assignedDeliveryDriver, assignedDeliveryDriver) ||
                other.assignedDeliveryDriver == assignedDeliveryDriver) &&
            (identical(other.trackingId, trackingId) ||
                other.trackingId == trackingId) &&
            const DeepCollectionEquality()
                .equals(other._statusHistory, _statusHistory) &&
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
        cartId,
        orderNumber,
        status,
        createdAt,
        confirmedAt,
        estimatedDeliveryTime,
        actualDeliveryTime,
        cancelledAt,
        cancellationReason,
        const DeepCollectionEquality().hash(_items),
        const DeepCollectionEquality().hash(_totalNutrition),
        totalCalories,
        totalWeight,
        nutritionAnalysis,
        const DeepCollectionEquality().hash(_merchantGroups),
        subtotal,
        deliveryFee,
        discountAmount,
        taxAmount,
        totalAmount,
        const DeepCollectionEquality().hash(_appliedCoupons),
        deliveryMethod,
        deliveryAddress,
        deliveryContact,
        deliveryPhone,
        deliveryNotes,
        const DeepCollectionEquality().hash(_deliveryLocation),
        paymentMethod,
        paymentId,
        paymentStatus,
        paidAt,
        const DeepCollectionEquality().hash(_nutritionGoals),
        nutritionMatchScore,
        const DeepCollectionEquality().hash(_nutritionWarnings),
        const DeepCollectionEquality().hash(_nutritionBenefits),
        const DeepCollectionEquality().hash(_dietaryRequirements),
        const DeepCollectionEquality().hash(_allergenAlerts),
        specialInstructions,
        rating,
        review,
        reviewedAt,
        const DeepCollectionEquality().hash(_nutritionFeedback),
        assignedDeliveryDriver,
        trackingId,
        const DeepCollectionEquality().hash(_statusHistory),
        updatedAt
      ]);

  /// Create a copy of NutritionOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionOrderImplCopyWith<_$NutritionOrderImpl> get copyWith =>
      __$$NutritionOrderImplCopyWithImpl<_$NutritionOrderImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionOrder value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionOrder value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionOrder value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionOrderImplToJson(
      this,
    );
  }
}

abstract class _NutritionOrder implements NutritionOrder {
  const factory _NutritionOrder(
      {required final String id,
      required final String userId,
      final String? profileId,
      final String? cartId,
      required final String orderNumber,
      required final String status,
      required final DateTime createdAt,
      final DateTime? confirmedAt,
      final DateTime? estimatedDeliveryTime,
      final DateTime? actualDeliveryTime,
      final DateTime? cancelledAt,
      final String? cancellationReason,
      required final List<NutritionOrderItem> items,
      required final Map<String, double> totalNutrition,
      required final int totalCalories,
      required final double totalWeight,
      required final NutritionOrderAnalysis nutritionAnalysis,
      required final Map<String, MerchantOrderGroup> merchantGroups,
      required final double subtotal,
      required final double deliveryFee,
      required final double discountAmount,
      required final double taxAmount,
      required final double totalAmount,
      final List<String> appliedCoupons,
      required final String deliveryMethod,
      required final String deliveryAddress,
      final String? deliveryContact,
      final String? deliveryPhone,
      final String? deliveryNotes,
      final Map<String, double> deliveryLocation,
      final String? paymentMethod,
      final String? paymentId,
      final String? paymentStatus,
      final DateTime? paidAt,
      final Map<String, double> nutritionGoals,
      final double nutritionMatchScore,
      final List<String> nutritionWarnings,
      final List<String> nutritionBenefits,
      final List<String> dietaryRequirements,
      final List<String> allergenAlerts,
      final String? specialInstructions,
      final double? rating,
      final String? review,
      final DateTime? reviewedAt,
      final Map<String, double> nutritionFeedback,
      final String? assignedDeliveryDriver,
      final String? trackingId,
      final List<OrderStatusUpdate> statusHistory,
      final DateTime? updatedAt}) = _$NutritionOrderImpl;

  factory _NutritionOrder.fromJson(Map<String, dynamic> json) =
      _$NutritionOrderImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get profileId; // 关联的营养档案
  @override
  String? get cartId; // 原购物车ID
// 订单基本信息
  @override
  String get orderNumber;
  @override
  String
      get status; // pending, confirmed, preparing, ready, delivering, completed, cancelled
  @override
  DateTime get createdAt;
  @override
  DateTime? get confirmedAt;
  @override
  DateTime? get estimatedDeliveryTime;
  @override
  DateTime? get actualDeliveryTime;
  @override
  DateTime? get cancelledAt;
  @override
  String? get cancellationReason; // 营养信息
  @override
  List<NutritionOrderItem> get items;
  @override
  Map<String, double> get totalNutrition; // 总营养成分
  @override
  int get totalCalories;
  @override
  double get totalWeight;
  @override
  NutritionOrderAnalysis get nutritionAnalysis; // 订单营养分析
// 商家信息（支持多商家订单）
  @override
  Map<String, MerchantOrderGroup> get merchantGroups; // 价格信息
  @override
  double get subtotal;
  @override
  double get deliveryFee;
  @override
  double get discountAmount;
  @override
  double get taxAmount;
  @override
  double get totalAmount;
  @override
  List<String> get appliedCoupons; // 配送信息
  @override
  String get deliveryMethod; // delivery, pickup
  @override
  String get deliveryAddress;
  @override
  String? get deliveryContact;
  @override
  String? get deliveryPhone;
  @override
  String? get deliveryNotes;
  @override
  Map<String, double> get deliveryLocation; // lat, lng
// 支付信息
  @override
  String? get paymentMethod;
  @override
  String? get paymentId;
  @override
  String? get paymentStatus; // pending, paid, failed, refunded
  @override
  DateTime? get paidAt; // 营养目标匹配
  @override
  Map<String, double> get nutritionGoals; // 用户的营养目标
  @override
  double get nutritionMatchScore; // 营养匹配评分 0-10
  @override
  List<String> get nutritionWarnings;
  @override
  List<String> get nutritionBenefits; // 特殊要求
  @override
  List<String> get dietaryRequirements; // vegetarian, vegan, gluten-free等
  @override
  List<String> get allergenAlerts;
  @override
  String? get specialInstructions; // 评价信息
  @override
  double? get rating;
  @override
  String? get review;
  @override
  DateTime? get reviewedAt;
  @override
  Map<String, double> get nutritionFeedback; // 营养满意度反馈
// 系统信息
  @override
  String? get assignedDeliveryDriver;
  @override
  String? get trackingId;
  @override
  List<OrderStatusUpdate> get statusHistory;
  @override
  DateTime? get updatedAt;

  /// Create a copy of NutritionOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionOrderImplCopyWith<_$NutritionOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionOrderItem _$NutritionOrderItemFromJson(Map<String, dynamic> json) {
  return _NutritionOrderItem.fromJson(json);
}

/// @nodoc
mixin _$NutritionOrderItem {
  String get id => throw _privateConstructorUsedError;
  String get itemType =>
      throw _privateConstructorUsedError; // ingredient, dish, custom_meal
  String get itemId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get chineseName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError; // 商家信息
  String get merchantId => throw _privateConstructorUsedError;
  String get merchantName => throw _privateConstructorUsedError; // 数量和单位
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError; // 营养信息（按实际重量计算）
  Map<String, double> get nutritionPer100g =>
      throw _privateConstructorUsedError;
  Map<String, double> get totalNutrition => throw _privateConstructorUsedError;
  int get totalCalories => throw _privateConstructorUsedError; // 烹饪信息
  String? get cookingMethodId => throw _privateConstructorUsedError;
  String? get cookingMethodName => throw _privateConstructorUsedError;
  Map<String, double> get cookingAdjustments =>
      throw _privateConstructorUsedError;
  String? get cookingInstructions => throw _privateConstructorUsedError;
  String get cookingLevel =>
      throw _privateConstructorUsedError; // rare, medium, well-done等
// 定制选项
  List<String> get customizations => throw _privateConstructorUsedError;
  List<String> get addOns => throw _privateConstructorUsedError;
  List<String> get removedIngredients =>
      throw _privateConstructorUsedError; // 营养标签
  List<String> get nutritionTags =>
      throw _privateConstructorUsedError; // high-protein, low-fat等
  List<String> get dietaryTags => throw _privateConstructorUsedError;
  List<String> get allergenWarnings =>
      throw _privateConstructorUsedError; // 状态信息
  String get status =>
      throw _privateConstructorUsedError; // pending, confirmed, preparing, ready, completed
  DateTime? get preparedAt => throw _privateConstructorUsedError;
  String? get preparationNotes => throw _privateConstructorUsedError; // 营养匹配度
  double get nutritionMatchScore => throw _privateConstructorUsedError;
  List<String> get nutritionBenefits => throw _privateConstructorUsedError;
  DateTime get addedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionOrderItem value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionOrderItem value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionOrderItem value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionOrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionOrderItemCopyWith<NutritionOrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionOrderItemCopyWith<$Res> {
  factory $NutritionOrderItemCopyWith(
          NutritionOrderItem value, $Res Function(NutritionOrderItem) then) =
      _$NutritionOrderItemCopyWithImpl<$Res, NutritionOrderItem>;
  @useResult
  $Res call(
      {String id,
      String itemType,
      String itemId,
      String name,
      String chineseName,
      String? description,
      String? imageUrl,
      String merchantId,
      String merchantName,
      double quantity,
      String unit,
      double unitPrice,
      double totalPrice,
      Map<String, double> nutritionPer100g,
      Map<String, double> totalNutrition,
      int totalCalories,
      String? cookingMethodId,
      String? cookingMethodName,
      Map<String, double> cookingAdjustments,
      String? cookingInstructions,
      String cookingLevel,
      List<String> customizations,
      List<String> addOns,
      List<String> removedIngredients,
      List<String> nutritionTags,
      List<String> dietaryTags,
      List<String> allergenWarnings,
      String status,
      DateTime? preparedAt,
      String? preparationNotes,
      double nutritionMatchScore,
      List<String> nutritionBenefits,
      DateTime addedAt});
}

/// @nodoc
class _$NutritionOrderItemCopyWithImpl<$Res, $Val extends NutritionOrderItem>
    implements $NutritionOrderItemCopyWith<$Res> {
  _$NutritionOrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionOrderItem
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
    Object? merchantId = null,
    Object? merchantName = null,
    Object? quantity = null,
    Object? unit = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? nutritionPer100g = null,
    Object? totalNutrition = null,
    Object? totalCalories = null,
    Object? cookingMethodId = freezed,
    Object? cookingMethodName = freezed,
    Object? cookingAdjustments = null,
    Object? cookingInstructions = freezed,
    Object? cookingLevel = null,
    Object? customizations = null,
    Object? addOns = null,
    Object? removedIngredients = null,
    Object? nutritionTags = null,
    Object? dietaryTags = null,
    Object? allergenWarnings = null,
    Object? status = null,
    Object? preparedAt = freezed,
    Object? preparationNotes = freezed,
    Object? nutritionMatchScore = null,
    Object? nutritionBenefits = null,
    Object? addedAt = null,
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
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantName: null == merchantName
          ? _value.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String,
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
      cookingInstructions: freezed == cookingInstructions
          ? _value.cookingInstructions
          : cookingInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      cookingLevel: null == cookingLevel
          ? _value.cookingLevel
          : cookingLevel // ignore: cast_nullable_to_non_nullable
              as String,
      customizations: null == customizations
          ? _value.customizations
          : customizations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      addOns: null == addOns
          ? _value.addOns
          : addOns // ignore: cast_nullable_to_non_nullable
              as List<String>,
      removedIngredients: null == removedIngredients
          ? _value.removedIngredients
          : removedIngredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionTags: null == nutritionTags
          ? _value.nutritionTags
          : nutritionTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dietaryTags: null == dietaryTags
          ? _value.dietaryTags
          : dietaryTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergenWarnings: null == allergenWarnings
          ? _value.allergenWarnings
          : allergenWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      preparedAt: freezed == preparedAt
          ? _value.preparedAt
          : preparedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      preparationNotes: freezed == preparationNotes
          ? _value.preparationNotes
          : preparationNotes // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionOrderItemImplCopyWith<$Res>
    implements $NutritionOrderItemCopyWith<$Res> {
  factory _$$NutritionOrderItemImplCopyWith(_$NutritionOrderItemImpl value,
          $Res Function(_$NutritionOrderItemImpl) then) =
      __$$NutritionOrderItemImplCopyWithImpl<$Res>;
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
      String merchantId,
      String merchantName,
      double quantity,
      String unit,
      double unitPrice,
      double totalPrice,
      Map<String, double> nutritionPer100g,
      Map<String, double> totalNutrition,
      int totalCalories,
      String? cookingMethodId,
      String? cookingMethodName,
      Map<String, double> cookingAdjustments,
      String? cookingInstructions,
      String cookingLevel,
      List<String> customizations,
      List<String> addOns,
      List<String> removedIngredients,
      List<String> nutritionTags,
      List<String> dietaryTags,
      List<String> allergenWarnings,
      String status,
      DateTime? preparedAt,
      String? preparationNotes,
      double nutritionMatchScore,
      List<String> nutritionBenefits,
      DateTime addedAt});
}

/// @nodoc
class __$$NutritionOrderItemImplCopyWithImpl<$Res>
    extends _$NutritionOrderItemCopyWithImpl<$Res, _$NutritionOrderItemImpl>
    implements _$$NutritionOrderItemImplCopyWith<$Res> {
  __$$NutritionOrderItemImplCopyWithImpl(_$NutritionOrderItemImpl _value,
      $Res Function(_$NutritionOrderItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionOrderItem
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
    Object? merchantId = null,
    Object? merchantName = null,
    Object? quantity = null,
    Object? unit = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? nutritionPer100g = null,
    Object? totalNutrition = null,
    Object? totalCalories = null,
    Object? cookingMethodId = freezed,
    Object? cookingMethodName = freezed,
    Object? cookingAdjustments = null,
    Object? cookingInstructions = freezed,
    Object? cookingLevel = null,
    Object? customizations = null,
    Object? addOns = null,
    Object? removedIngredients = null,
    Object? nutritionTags = null,
    Object? dietaryTags = null,
    Object? allergenWarnings = null,
    Object? status = null,
    Object? preparedAt = freezed,
    Object? preparationNotes = freezed,
    Object? nutritionMatchScore = null,
    Object? nutritionBenefits = null,
    Object? addedAt = null,
  }) {
    return _then(_$NutritionOrderItemImpl(
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
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantName: null == merchantName
          ? _value.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String,
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
      cookingInstructions: freezed == cookingInstructions
          ? _value.cookingInstructions
          : cookingInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      cookingLevel: null == cookingLevel
          ? _value.cookingLevel
          : cookingLevel // ignore: cast_nullable_to_non_nullable
              as String,
      customizations: null == customizations
          ? _value._customizations
          : customizations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      addOns: null == addOns
          ? _value._addOns
          : addOns // ignore: cast_nullable_to_non_nullable
              as List<String>,
      removedIngredients: null == removedIngredients
          ? _value._removedIngredients
          : removedIngredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionTags: null == nutritionTags
          ? _value._nutritionTags
          : nutritionTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dietaryTags: null == dietaryTags
          ? _value._dietaryTags
          : dietaryTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergenWarnings: null == allergenWarnings
          ? _value._allergenWarnings
          : allergenWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      preparedAt: freezed == preparedAt
          ? _value.preparedAt
          : preparedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      preparationNotes: freezed == preparationNotes
          ? _value.preparationNotes
          : preparationNotes // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionOrderItemImpl implements _NutritionOrderItem {
  const _$NutritionOrderItemImpl(
      {required this.id,
      required this.itemType,
      required this.itemId,
      required this.name,
      required this.chineseName,
      this.description,
      this.imageUrl,
      required this.merchantId,
      required this.merchantName,
      required this.quantity,
      required this.unit,
      required this.unitPrice,
      required this.totalPrice,
      required final Map<String, double> nutritionPer100g,
      required final Map<String, double> totalNutrition,
      required this.totalCalories,
      this.cookingMethodId,
      this.cookingMethodName,
      final Map<String, double> cookingAdjustments = const {},
      this.cookingInstructions,
      this.cookingLevel = 'standard',
      final List<String> customizations = const [],
      final List<String> addOns = const [],
      final List<String> removedIngredients = const [],
      final List<String> nutritionTags = const [],
      final List<String> dietaryTags = const [],
      final List<String> allergenWarnings = const [],
      required this.status,
      this.preparedAt,
      this.preparationNotes,
      this.nutritionMatchScore = 0.0,
      final List<String> nutritionBenefits = const [],
      required this.addedAt})
      : _nutritionPer100g = nutritionPer100g,
        _totalNutrition = totalNutrition,
        _cookingAdjustments = cookingAdjustments,
        _customizations = customizations,
        _addOns = addOns,
        _removedIngredients = removedIngredients,
        _nutritionTags = nutritionTags,
        _dietaryTags = dietaryTags,
        _allergenWarnings = allergenWarnings,
        _nutritionBenefits = nutritionBenefits;

  factory _$NutritionOrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionOrderItemImplFromJson(json);

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
// 商家信息
  @override
  final String merchantId;
  @override
  final String merchantName;
// 数量和单位
  @override
  final double quantity;
  @override
  final String unit;
  @override
  final double unitPrice;
  @override
  final double totalPrice;
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
// 烹饪信息
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

  @override
  final String? cookingInstructions;
  @override
  @JsonKey()
  final String cookingLevel;
// rare, medium, well-done等
// 定制选项
  final List<String> _customizations;
// rare, medium, well-done等
// 定制选项
  @override
  @JsonKey()
  List<String> get customizations {
    if (_customizations is EqualUnmodifiableListView) return _customizations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customizations);
  }

  final List<String> _addOns;
  @override
  @JsonKey()
  List<String> get addOns {
    if (_addOns is EqualUnmodifiableListView) return _addOns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addOns);
  }

  final List<String> _removedIngredients;
  @override
  @JsonKey()
  List<String> get removedIngredients {
    if (_removedIngredients is EqualUnmodifiableListView)
      return _removedIngredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_removedIngredients);
  }

// 营养标签
  final List<String> _nutritionTags;
// 营养标签
  @override
  @JsonKey()
  List<String> get nutritionTags {
    if (_nutritionTags is EqualUnmodifiableListView) return _nutritionTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionTags);
  }

// high-protein, low-fat等
  final List<String> _dietaryTags;
// high-protein, low-fat等
  @override
  @JsonKey()
  List<String> get dietaryTags {
    if (_dietaryTags is EqualUnmodifiableListView) return _dietaryTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dietaryTags);
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

// 状态信息
  @override
  final String status;
// pending, confirmed, preparing, ready, completed
  @override
  final DateTime? preparedAt;
  @override
  final String? preparationNotes;
// 营养匹配度
  @override
  @JsonKey()
  final double nutritionMatchScore;
  final List<String> _nutritionBenefits;
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
  String toString() {
    return 'NutritionOrderItem(id: $id, itemType: $itemType, itemId: $itemId, name: $name, chineseName: $chineseName, description: $description, imageUrl: $imageUrl, merchantId: $merchantId, merchantName: $merchantName, quantity: $quantity, unit: $unit, unitPrice: $unitPrice, totalPrice: $totalPrice, nutritionPer100g: $nutritionPer100g, totalNutrition: $totalNutrition, totalCalories: $totalCalories, cookingMethodId: $cookingMethodId, cookingMethodName: $cookingMethodName, cookingAdjustments: $cookingAdjustments, cookingInstructions: $cookingInstructions, cookingLevel: $cookingLevel, customizations: $customizations, addOns: $addOns, removedIngredients: $removedIngredients, nutritionTags: $nutritionTags, dietaryTags: $dietaryTags, allergenWarnings: $allergenWarnings, status: $status, preparedAt: $preparedAt, preparationNotes: $preparationNotes, nutritionMatchScore: $nutritionMatchScore, nutritionBenefits: $nutritionBenefits, addedAt: $addedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionOrderItemImpl &&
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
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
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
            (identical(other.cookingInstructions, cookingInstructions) ||
                other.cookingInstructions == cookingInstructions) &&
            (identical(other.cookingLevel, cookingLevel) ||
                other.cookingLevel == cookingLevel) &&
            const DeepCollectionEquality()
                .equals(other._customizations, _customizations) &&
            const DeepCollectionEquality().equals(other._addOns, _addOns) &&
            const DeepCollectionEquality()
                .equals(other._removedIngredients, _removedIngredients) &&
            const DeepCollectionEquality()
                .equals(other._nutritionTags, _nutritionTags) &&
            const DeepCollectionEquality()
                .equals(other._dietaryTags, _dietaryTags) &&
            const DeepCollectionEquality()
                .equals(other._allergenWarnings, _allergenWarnings) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.preparedAt, preparedAt) ||
                other.preparedAt == preparedAt) &&
            (identical(other.preparationNotes, preparationNotes) ||
                other.preparationNotes == preparationNotes) &&
            (identical(other.nutritionMatchScore, nutritionMatchScore) ||
                other.nutritionMatchScore == nutritionMatchScore) &&
            const DeepCollectionEquality()
                .equals(other._nutritionBenefits, _nutritionBenefits) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt));
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
        merchantId,
        merchantName,
        quantity,
        unit,
        unitPrice,
        totalPrice,
        const DeepCollectionEquality().hash(_nutritionPer100g),
        const DeepCollectionEquality().hash(_totalNutrition),
        totalCalories,
        cookingMethodId,
        cookingMethodName,
        const DeepCollectionEquality().hash(_cookingAdjustments),
        cookingInstructions,
        cookingLevel,
        const DeepCollectionEquality().hash(_customizations),
        const DeepCollectionEquality().hash(_addOns),
        const DeepCollectionEquality().hash(_removedIngredients),
        const DeepCollectionEquality().hash(_nutritionTags),
        const DeepCollectionEquality().hash(_dietaryTags),
        const DeepCollectionEquality().hash(_allergenWarnings),
        status,
        preparedAt,
        preparationNotes,
        nutritionMatchScore,
        const DeepCollectionEquality().hash(_nutritionBenefits),
        addedAt
      ]);

  /// Create a copy of NutritionOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionOrderItemImplCopyWith<_$NutritionOrderItemImpl> get copyWith =>
      __$$NutritionOrderItemImplCopyWithImpl<_$NutritionOrderItemImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionOrderItem value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionOrderItem value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionOrderItem value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionOrderItemImplToJson(
      this,
    );
  }
}

abstract class _NutritionOrderItem implements NutritionOrderItem {
  const factory _NutritionOrderItem(
      {required final String id,
      required final String itemType,
      required final String itemId,
      required final String name,
      required final String chineseName,
      final String? description,
      final String? imageUrl,
      required final String merchantId,
      required final String merchantName,
      required final double quantity,
      required final String unit,
      required final double unitPrice,
      required final double totalPrice,
      required final Map<String, double> nutritionPer100g,
      required final Map<String, double> totalNutrition,
      required final int totalCalories,
      final String? cookingMethodId,
      final String? cookingMethodName,
      final Map<String, double> cookingAdjustments,
      final String? cookingInstructions,
      final String cookingLevel,
      final List<String> customizations,
      final List<String> addOns,
      final List<String> removedIngredients,
      final List<String> nutritionTags,
      final List<String> dietaryTags,
      final List<String> allergenWarnings,
      required final String status,
      final DateTime? preparedAt,
      final String? preparationNotes,
      final double nutritionMatchScore,
      final List<String> nutritionBenefits,
      required final DateTime addedAt}) = _$NutritionOrderItemImpl;

  factory _NutritionOrderItem.fromJson(Map<String, dynamic> json) =
      _$NutritionOrderItemImpl.fromJson;

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
  String? get imageUrl; // 商家信息
  @override
  String get merchantId;
  @override
  String get merchantName; // 数量和单位
  @override
  double get quantity;
  @override
  String get unit;
  @override
  double get unitPrice;
  @override
  double get totalPrice; // 营养信息（按实际重量计算）
  @override
  Map<String, double> get nutritionPer100g;
  @override
  Map<String, double> get totalNutrition;
  @override
  int get totalCalories; // 烹饪信息
  @override
  String? get cookingMethodId;
  @override
  String? get cookingMethodName;
  @override
  Map<String, double> get cookingAdjustments;
  @override
  String? get cookingInstructions;
  @override
  String get cookingLevel; // rare, medium, well-done等
// 定制选项
  @override
  List<String> get customizations;
  @override
  List<String> get addOns;
  @override
  List<String> get removedIngredients; // 营养标签
  @override
  List<String> get nutritionTags; // high-protein, low-fat等
  @override
  List<String> get dietaryTags;
  @override
  List<String> get allergenWarnings; // 状态信息
  @override
  String get status; // pending, confirmed, preparing, ready, completed
  @override
  DateTime? get preparedAt;
  @override
  String? get preparationNotes; // 营养匹配度
  @override
  double get nutritionMatchScore;
  @override
  List<String> get nutritionBenefits;
  @override
  DateTime get addedAt;

  /// Create a copy of NutritionOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionOrderItemImplCopyWith<_$NutritionOrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MerchantOrderGroup _$MerchantOrderGroupFromJson(Map<String, dynamic> json) {
  return _MerchantOrderGroup.fromJson(json);
}

/// @nodoc
mixin _$MerchantOrderGroup {
  String get merchantId => throw _privateConstructorUsedError;
  String get merchantName => throw _privateConstructorUsedError;
  String? get merchantPhone => throw _privateConstructorUsedError;
  String? get merchantAddress => throw _privateConstructorUsedError; // 订单项目
  List<NutritionOrderItem> get items =>
      throw _privateConstructorUsedError; // 价格信息
  double get subtotal => throw _privateConstructorUsedError;
  double get deliveryFee => throw _privateConstructorUsedError;
  double get merchantDiscount => throw _privateConstructorUsedError; // 时间信息
  int get estimatedPrepTime => throw _privateConstructorUsedError; // 预计准备时间（分钟）
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  DateTime? get readyAt => throw _privateConstructorUsedError; // 状态信息
  String get status =>
      throw _privateConstructorUsedError; // pending, confirmed, preparing, ready, picked_up
  List<String> get statusNotes => throw _privateConstructorUsedError; // 营养统计
  Map<String, double> get nutritionTotals => throw _privateConstructorUsedError;
  int get totalCalories => throw _privateConstructorUsedError; // 特殊要求
  List<String> get merchantNotes => throw _privateConstructorUsedError;
  String? get kitchenInstructions => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MerchantOrderGroup value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MerchantOrderGroup value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MerchantOrderGroup value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MerchantOrderGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MerchantOrderGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MerchantOrderGroupCopyWith<MerchantOrderGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MerchantOrderGroupCopyWith<$Res> {
  factory $MerchantOrderGroupCopyWith(
          MerchantOrderGroup value, $Res Function(MerchantOrderGroup) then) =
      _$MerchantOrderGroupCopyWithImpl<$Res, MerchantOrderGroup>;
  @useResult
  $Res call(
      {String merchantId,
      String merchantName,
      String? merchantPhone,
      String? merchantAddress,
      List<NutritionOrderItem> items,
      double subtotal,
      double deliveryFee,
      double merchantDiscount,
      int estimatedPrepTime,
      DateTime? confirmedAt,
      DateTime? readyAt,
      String status,
      List<String> statusNotes,
      Map<String, double> nutritionTotals,
      int totalCalories,
      List<String> merchantNotes,
      String? kitchenInstructions});
}

/// @nodoc
class _$MerchantOrderGroupCopyWithImpl<$Res, $Val extends MerchantOrderGroup>
    implements $MerchantOrderGroupCopyWith<$Res> {
  _$MerchantOrderGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MerchantOrderGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchantId = null,
    Object? merchantName = null,
    Object? merchantPhone = freezed,
    Object? merchantAddress = freezed,
    Object? items = null,
    Object? subtotal = null,
    Object? deliveryFee = null,
    Object? merchantDiscount = null,
    Object? estimatedPrepTime = null,
    Object? confirmedAt = freezed,
    Object? readyAt = freezed,
    Object? status = null,
    Object? statusNotes = null,
    Object? nutritionTotals = null,
    Object? totalCalories = null,
    Object? merchantNotes = null,
    Object? kitchenInstructions = freezed,
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
      merchantPhone: freezed == merchantPhone
          ? _value.merchantPhone
          : merchantPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantAddress: freezed == merchantAddress
          ? _value.merchantAddress
          : merchantAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NutritionOrderItem>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      merchantDiscount: null == merchantDiscount
          ? _value.merchantDiscount
          : merchantDiscount // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedPrepTime: null == estimatedPrepTime
          ? _value.estimatedPrepTime
          : estimatedPrepTime // ignore: cast_nullable_to_non_nullable
              as int,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readyAt: freezed == readyAt
          ? _value.readyAt
          : readyAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      statusNotes: null == statusNotes
          ? _value.statusNotes
          : statusNotes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionTotals: null == nutritionTotals
          ? _value.nutritionTotals
          : nutritionTotals // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      merchantNotes: null == merchantNotes
          ? _value.merchantNotes
          : merchantNotes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      kitchenInstructions: freezed == kitchenInstructions
          ? _value.kitchenInstructions
          : kitchenInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MerchantOrderGroupImplCopyWith<$Res>
    implements $MerchantOrderGroupCopyWith<$Res> {
  factory _$$MerchantOrderGroupImplCopyWith(_$MerchantOrderGroupImpl value,
          $Res Function(_$MerchantOrderGroupImpl) then) =
      __$$MerchantOrderGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String merchantId,
      String merchantName,
      String? merchantPhone,
      String? merchantAddress,
      List<NutritionOrderItem> items,
      double subtotal,
      double deliveryFee,
      double merchantDiscount,
      int estimatedPrepTime,
      DateTime? confirmedAt,
      DateTime? readyAt,
      String status,
      List<String> statusNotes,
      Map<String, double> nutritionTotals,
      int totalCalories,
      List<String> merchantNotes,
      String? kitchenInstructions});
}

/// @nodoc
class __$$MerchantOrderGroupImplCopyWithImpl<$Res>
    extends _$MerchantOrderGroupCopyWithImpl<$Res, _$MerchantOrderGroupImpl>
    implements _$$MerchantOrderGroupImplCopyWith<$Res> {
  __$$MerchantOrderGroupImplCopyWithImpl(_$MerchantOrderGroupImpl _value,
      $Res Function(_$MerchantOrderGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of MerchantOrderGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchantId = null,
    Object? merchantName = null,
    Object? merchantPhone = freezed,
    Object? merchantAddress = freezed,
    Object? items = null,
    Object? subtotal = null,
    Object? deliveryFee = null,
    Object? merchantDiscount = null,
    Object? estimatedPrepTime = null,
    Object? confirmedAt = freezed,
    Object? readyAt = freezed,
    Object? status = null,
    Object? statusNotes = null,
    Object? nutritionTotals = null,
    Object? totalCalories = null,
    Object? merchantNotes = null,
    Object? kitchenInstructions = freezed,
  }) {
    return _then(_$MerchantOrderGroupImpl(
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantName: null == merchantName
          ? _value.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String,
      merchantPhone: freezed == merchantPhone
          ? _value.merchantPhone
          : merchantPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantAddress: freezed == merchantAddress
          ? _value.merchantAddress
          : merchantAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NutritionOrderItem>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      merchantDiscount: null == merchantDiscount
          ? _value.merchantDiscount
          : merchantDiscount // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedPrepTime: null == estimatedPrepTime
          ? _value.estimatedPrepTime
          : estimatedPrepTime // ignore: cast_nullable_to_non_nullable
              as int,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readyAt: freezed == readyAt
          ? _value.readyAt
          : readyAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      statusNotes: null == statusNotes
          ? _value._statusNotes
          : statusNotes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionTotals: null == nutritionTotals
          ? _value._nutritionTotals
          : nutritionTotals // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      merchantNotes: null == merchantNotes
          ? _value._merchantNotes
          : merchantNotes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      kitchenInstructions: freezed == kitchenInstructions
          ? _value.kitchenInstructions
          : kitchenInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MerchantOrderGroupImpl implements _MerchantOrderGroup {
  const _$MerchantOrderGroupImpl(
      {required this.merchantId,
      required this.merchantName,
      this.merchantPhone,
      this.merchantAddress,
      required final List<NutritionOrderItem> items,
      required this.subtotal,
      required this.deliveryFee,
      required this.merchantDiscount,
      required this.estimatedPrepTime,
      this.confirmedAt,
      this.readyAt,
      required this.status,
      final List<String> statusNotes = const [],
      required final Map<String, double> nutritionTotals,
      required this.totalCalories,
      final List<String> merchantNotes = const [],
      this.kitchenInstructions})
      : _items = items,
        _statusNotes = statusNotes,
        _nutritionTotals = nutritionTotals,
        _merchantNotes = merchantNotes;

  factory _$MerchantOrderGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$MerchantOrderGroupImplFromJson(json);

  @override
  final String merchantId;
  @override
  final String merchantName;
  @override
  final String? merchantPhone;
  @override
  final String? merchantAddress;
// 订单项目
  final List<NutritionOrderItem> _items;
// 订单项目
  @override
  List<NutritionOrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

// 价格信息
  @override
  final double subtotal;
  @override
  final double deliveryFee;
  @override
  final double merchantDiscount;
// 时间信息
  @override
  final int estimatedPrepTime;
// 预计准备时间（分钟）
  @override
  final DateTime? confirmedAt;
  @override
  final DateTime? readyAt;
// 状态信息
  @override
  final String status;
// pending, confirmed, preparing, ready, picked_up
  final List<String> _statusNotes;
// pending, confirmed, preparing, ready, picked_up
  @override
  @JsonKey()
  List<String> get statusNotes {
    if (_statusNotes is EqualUnmodifiableListView) return _statusNotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statusNotes);
  }

// 营养统计
  final Map<String, double> _nutritionTotals;
// 营养统计
  @override
  Map<String, double> get nutritionTotals {
    if (_nutritionTotals is EqualUnmodifiableMapView) return _nutritionTotals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionTotals);
  }

  @override
  final int totalCalories;
// 特殊要求
  final List<String> _merchantNotes;
// 特殊要求
  @override
  @JsonKey()
  List<String> get merchantNotes {
    if (_merchantNotes is EqualUnmodifiableListView) return _merchantNotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_merchantNotes);
  }

  @override
  final String? kitchenInstructions;

  @override
  String toString() {
    return 'MerchantOrderGroup(merchantId: $merchantId, merchantName: $merchantName, merchantPhone: $merchantPhone, merchantAddress: $merchantAddress, items: $items, subtotal: $subtotal, deliveryFee: $deliveryFee, merchantDiscount: $merchantDiscount, estimatedPrepTime: $estimatedPrepTime, confirmedAt: $confirmedAt, readyAt: $readyAt, status: $status, statusNotes: $statusNotes, nutritionTotals: $nutritionTotals, totalCalories: $totalCalories, merchantNotes: $merchantNotes, kitchenInstructions: $kitchenInstructions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MerchantOrderGroupImpl &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            (identical(other.merchantPhone, merchantPhone) ||
                other.merchantPhone == merchantPhone) &&
            (identical(other.merchantAddress, merchantAddress) ||
                other.merchantAddress == merchantAddress) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.merchantDiscount, merchantDiscount) ||
                other.merchantDiscount == merchantDiscount) &&
            (identical(other.estimatedPrepTime, estimatedPrepTime) ||
                other.estimatedPrepTime == estimatedPrepTime) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.readyAt, readyAt) || other.readyAt == readyAt) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._statusNotes, _statusNotes) &&
            const DeepCollectionEquality()
                .equals(other._nutritionTotals, _nutritionTotals) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            const DeepCollectionEquality()
                .equals(other._merchantNotes, _merchantNotes) &&
            (identical(other.kitchenInstructions, kitchenInstructions) ||
                other.kitchenInstructions == kitchenInstructions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      merchantId,
      merchantName,
      merchantPhone,
      merchantAddress,
      const DeepCollectionEquality().hash(_items),
      subtotal,
      deliveryFee,
      merchantDiscount,
      estimatedPrepTime,
      confirmedAt,
      readyAt,
      status,
      const DeepCollectionEquality().hash(_statusNotes),
      const DeepCollectionEquality().hash(_nutritionTotals),
      totalCalories,
      const DeepCollectionEquality().hash(_merchantNotes),
      kitchenInstructions);

  /// Create a copy of MerchantOrderGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MerchantOrderGroupImplCopyWith<_$MerchantOrderGroupImpl> get copyWith =>
      __$$MerchantOrderGroupImplCopyWithImpl<_$MerchantOrderGroupImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MerchantOrderGroup value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MerchantOrderGroup value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MerchantOrderGroup value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MerchantOrderGroupImplToJson(
      this,
    );
  }
}

abstract class _MerchantOrderGroup implements MerchantOrderGroup {
  const factory _MerchantOrderGroup(
      {required final String merchantId,
      required final String merchantName,
      final String? merchantPhone,
      final String? merchantAddress,
      required final List<NutritionOrderItem> items,
      required final double subtotal,
      required final double deliveryFee,
      required final double merchantDiscount,
      required final int estimatedPrepTime,
      final DateTime? confirmedAt,
      final DateTime? readyAt,
      required final String status,
      final List<String> statusNotes,
      required final Map<String, double> nutritionTotals,
      required final int totalCalories,
      final List<String> merchantNotes,
      final String? kitchenInstructions}) = _$MerchantOrderGroupImpl;

  factory _MerchantOrderGroup.fromJson(Map<String, dynamic> json) =
      _$MerchantOrderGroupImpl.fromJson;

  @override
  String get merchantId;
  @override
  String get merchantName;
  @override
  String? get merchantPhone;
  @override
  String? get merchantAddress; // 订单项目
  @override
  List<NutritionOrderItem> get items; // 价格信息
  @override
  double get subtotal;
  @override
  double get deliveryFee;
  @override
  double get merchantDiscount; // 时间信息
  @override
  int get estimatedPrepTime; // 预计准备时间（分钟）
  @override
  DateTime? get confirmedAt;
  @override
  DateTime? get readyAt; // 状态信息
  @override
  String get status; // pending, confirmed, preparing, ready, picked_up
  @override
  List<String> get statusNotes; // 营养统计
  @override
  Map<String, double> get nutritionTotals;
  @override
  int get totalCalories; // 特殊要求
  @override
  List<String> get merchantNotes;
  @override
  String? get kitchenInstructions;

  /// Create a copy of MerchantOrderGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MerchantOrderGroupImplCopyWith<_$MerchantOrderGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionOrderAnalysis _$NutritionOrderAnalysisFromJson(
    Map<String, dynamic> json) {
  return _NutritionOrderAnalysis.fromJson(json);
}

/// @nodoc
mixin _$NutritionOrderAnalysis {
  String get orderId => throw _privateConstructorUsedError;
  DateTime get analysisTime => throw _privateConstructorUsedError; // 营养完整性分析
  Map<String, NutritionElementAnalysis> get elementAnalysis =>
      throw _privateConstructorUsedError;
  double get overallNutritionScore =>
      throw _privateConstructorUsedError; // 0-10
  String get nutritionStatus =>
      throw _privateConstructorUsedError; // excellent, good, fair, poor
// 餐次分析
  String get mealType =>
      throw _privateConstructorUsedError; // breakfast, lunch, dinner, snack
  double get mealAppropriatenessScore => throw _privateConstructorUsedError;
  List<String> get mealRecommendations =>
      throw _privateConstructorUsedError; // 热量分析
  CalorieAnalysis get calorieAnalysis =>
      throw _privateConstructorUsedError; // 宏量营养素分析
  MacronutrientAnalysis get macroAnalysis =>
      throw _privateConstructorUsedError; // 微量元素分析
  MicronutrientAnalysis get microAnalysis =>
      throw _privateConstructorUsedError; // 膳食平衡
  double get balanceScore => throw _privateConstructorUsedError;
  List<String> get balanceWarnings => throw _privateConstructorUsedError;
  List<String> get balanceStrengths =>
      throw _privateConstructorUsedError; // 健康建议
  List<String> get healthSuggestions => throw _privateConstructorUsedError;
  List<String> get nextMealRecommendations =>
      throw _privateConstructorUsedError; // 长期影响预测
  Map<String, double> get longTermNutritionImpact =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionOrderAnalysis value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionOrderAnalysis value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionOrderAnalysis value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionOrderAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionOrderAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionOrderAnalysisCopyWith<NutritionOrderAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionOrderAnalysisCopyWith<$Res> {
  factory $NutritionOrderAnalysisCopyWith(NutritionOrderAnalysis value,
          $Res Function(NutritionOrderAnalysis) then) =
      _$NutritionOrderAnalysisCopyWithImpl<$Res, NutritionOrderAnalysis>;
  @useResult
  $Res call(
      {String orderId,
      DateTime analysisTime,
      Map<String, NutritionElementAnalysis> elementAnalysis,
      double overallNutritionScore,
      String nutritionStatus,
      String mealType,
      double mealAppropriatenessScore,
      List<String> mealRecommendations,
      CalorieAnalysis calorieAnalysis,
      MacronutrientAnalysis macroAnalysis,
      MicronutrientAnalysis microAnalysis,
      double balanceScore,
      List<String> balanceWarnings,
      List<String> balanceStrengths,
      List<String> healthSuggestions,
      List<String> nextMealRecommendations,
      Map<String, double> longTermNutritionImpact});

  $CalorieAnalysisCopyWith<$Res> get calorieAnalysis;
  $MacronutrientAnalysisCopyWith<$Res> get macroAnalysis;
  $MicronutrientAnalysisCopyWith<$Res> get microAnalysis;
}

/// @nodoc
class _$NutritionOrderAnalysisCopyWithImpl<$Res,
        $Val extends NutritionOrderAnalysis>
    implements $NutritionOrderAnalysisCopyWith<$Res> {
  _$NutritionOrderAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionOrderAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? analysisTime = null,
    Object? elementAnalysis = null,
    Object? overallNutritionScore = null,
    Object? nutritionStatus = null,
    Object? mealType = null,
    Object? mealAppropriatenessScore = null,
    Object? mealRecommendations = null,
    Object? calorieAnalysis = null,
    Object? macroAnalysis = null,
    Object? microAnalysis = null,
    Object? balanceScore = null,
    Object? balanceWarnings = null,
    Object? balanceStrengths = null,
    Object? healthSuggestions = null,
    Object? nextMealRecommendations = null,
    Object? longTermNutritionImpact = null,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      analysisTime: null == analysisTime
          ? _value.analysisTime
          : analysisTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      elementAnalysis: null == elementAnalysis
          ? _value.elementAnalysis
          : elementAnalysis // ignore: cast_nullable_to_non_nullable
              as Map<String, NutritionElementAnalysis>,
      overallNutritionScore: null == overallNutritionScore
          ? _value.overallNutritionScore
          : overallNutritionScore // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionStatus: null == nutritionStatus
          ? _value.nutritionStatus
          : nutritionStatus // ignore: cast_nullable_to_non_nullable
              as String,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      mealAppropriatenessScore: null == mealAppropriatenessScore
          ? _value.mealAppropriatenessScore
          : mealAppropriatenessScore // ignore: cast_nullable_to_non_nullable
              as double,
      mealRecommendations: null == mealRecommendations
          ? _value.mealRecommendations
          : mealRecommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      calorieAnalysis: null == calorieAnalysis
          ? _value.calorieAnalysis
          : calorieAnalysis // ignore: cast_nullable_to_non_nullable
              as CalorieAnalysis,
      macroAnalysis: null == macroAnalysis
          ? _value.macroAnalysis
          : macroAnalysis // ignore: cast_nullable_to_non_nullable
              as MacronutrientAnalysis,
      microAnalysis: null == microAnalysis
          ? _value.microAnalysis
          : microAnalysis // ignore: cast_nullable_to_non_nullable
              as MicronutrientAnalysis,
      balanceScore: null == balanceScore
          ? _value.balanceScore
          : balanceScore // ignore: cast_nullable_to_non_nullable
              as double,
      balanceWarnings: null == balanceWarnings
          ? _value.balanceWarnings
          : balanceWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      balanceStrengths: null == balanceStrengths
          ? _value.balanceStrengths
          : balanceStrengths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      healthSuggestions: null == healthSuggestions
          ? _value.healthSuggestions
          : healthSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nextMealRecommendations: null == nextMealRecommendations
          ? _value.nextMealRecommendations
          : nextMealRecommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      longTermNutritionImpact: null == longTermNutritionImpact
          ? _value.longTermNutritionImpact
          : longTermNutritionImpact // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ) as $Val);
  }

  /// Create a copy of NutritionOrderAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CalorieAnalysisCopyWith<$Res> get calorieAnalysis {
    return $CalorieAnalysisCopyWith<$Res>(_value.calorieAnalysis, (value) {
      return _then(_value.copyWith(calorieAnalysis: value) as $Val);
    });
  }

  /// Create a copy of NutritionOrderAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MacronutrientAnalysisCopyWith<$Res> get macroAnalysis {
    return $MacronutrientAnalysisCopyWith<$Res>(_value.macroAnalysis, (value) {
      return _then(_value.copyWith(macroAnalysis: value) as $Val);
    });
  }

  /// Create a copy of NutritionOrderAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MicronutrientAnalysisCopyWith<$Res> get microAnalysis {
    return $MicronutrientAnalysisCopyWith<$Res>(_value.microAnalysis, (value) {
      return _then(_value.copyWith(microAnalysis: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionOrderAnalysisImplCopyWith<$Res>
    implements $NutritionOrderAnalysisCopyWith<$Res> {
  factory _$$NutritionOrderAnalysisImplCopyWith(
          _$NutritionOrderAnalysisImpl value,
          $Res Function(_$NutritionOrderAnalysisImpl) then) =
      __$$NutritionOrderAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String orderId,
      DateTime analysisTime,
      Map<String, NutritionElementAnalysis> elementAnalysis,
      double overallNutritionScore,
      String nutritionStatus,
      String mealType,
      double mealAppropriatenessScore,
      List<String> mealRecommendations,
      CalorieAnalysis calorieAnalysis,
      MacronutrientAnalysis macroAnalysis,
      MicronutrientAnalysis microAnalysis,
      double balanceScore,
      List<String> balanceWarnings,
      List<String> balanceStrengths,
      List<String> healthSuggestions,
      List<String> nextMealRecommendations,
      Map<String, double> longTermNutritionImpact});

  @override
  $CalorieAnalysisCopyWith<$Res> get calorieAnalysis;
  @override
  $MacronutrientAnalysisCopyWith<$Res> get macroAnalysis;
  @override
  $MicronutrientAnalysisCopyWith<$Res> get microAnalysis;
}

/// @nodoc
class __$$NutritionOrderAnalysisImplCopyWithImpl<$Res>
    extends _$NutritionOrderAnalysisCopyWithImpl<$Res,
        _$NutritionOrderAnalysisImpl>
    implements _$$NutritionOrderAnalysisImplCopyWith<$Res> {
  __$$NutritionOrderAnalysisImplCopyWithImpl(
      _$NutritionOrderAnalysisImpl _value,
      $Res Function(_$NutritionOrderAnalysisImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionOrderAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? analysisTime = null,
    Object? elementAnalysis = null,
    Object? overallNutritionScore = null,
    Object? nutritionStatus = null,
    Object? mealType = null,
    Object? mealAppropriatenessScore = null,
    Object? mealRecommendations = null,
    Object? calorieAnalysis = null,
    Object? macroAnalysis = null,
    Object? microAnalysis = null,
    Object? balanceScore = null,
    Object? balanceWarnings = null,
    Object? balanceStrengths = null,
    Object? healthSuggestions = null,
    Object? nextMealRecommendations = null,
    Object? longTermNutritionImpact = null,
  }) {
    return _then(_$NutritionOrderAnalysisImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      analysisTime: null == analysisTime
          ? _value.analysisTime
          : analysisTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      elementAnalysis: null == elementAnalysis
          ? _value._elementAnalysis
          : elementAnalysis // ignore: cast_nullable_to_non_nullable
              as Map<String, NutritionElementAnalysis>,
      overallNutritionScore: null == overallNutritionScore
          ? _value.overallNutritionScore
          : overallNutritionScore // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionStatus: null == nutritionStatus
          ? _value.nutritionStatus
          : nutritionStatus // ignore: cast_nullable_to_non_nullable
              as String,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      mealAppropriatenessScore: null == mealAppropriatenessScore
          ? _value.mealAppropriatenessScore
          : mealAppropriatenessScore // ignore: cast_nullable_to_non_nullable
              as double,
      mealRecommendations: null == mealRecommendations
          ? _value._mealRecommendations
          : mealRecommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      calorieAnalysis: null == calorieAnalysis
          ? _value.calorieAnalysis
          : calorieAnalysis // ignore: cast_nullable_to_non_nullable
              as CalorieAnalysis,
      macroAnalysis: null == macroAnalysis
          ? _value.macroAnalysis
          : macroAnalysis // ignore: cast_nullable_to_non_nullable
              as MacronutrientAnalysis,
      microAnalysis: null == microAnalysis
          ? _value.microAnalysis
          : microAnalysis // ignore: cast_nullable_to_non_nullable
              as MicronutrientAnalysis,
      balanceScore: null == balanceScore
          ? _value.balanceScore
          : balanceScore // ignore: cast_nullable_to_non_nullable
              as double,
      balanceWarnings: null == balanceWarnings
          ? _value._balanceWarnings
          : balanceWarnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      balanceStrengths: null == balanceStrengths
          ? _value._balanceStrengths
          : balanceStrengths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      healthSuggestions: null == healthSuggestions
          ? _value._healthSuggestions
          : healthSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nextMealRecommendations: null == nextMealRecommendations
          ? _value._nextMealRecommendations
          : nextMealRecommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      longTermNutritionImpact: null == longTermNutritionImpact
          ? _value._longTermNutritionImpact
          : longTermNutritionImpact // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionOrderAnalysisImpl implements _NutritionOrderAnalysis {
  const _$NutritionOrderAnalysisImpl(
      {required this.orderId,
      required this.analysisTime,
      required final Map<String, NutritionElementAnalysis> elementAnalysis,
      this.overallNutritionScore = 0.0,
      this.nutritionStatus = 'neutral',
      required this.mealType,
      this.mealAppropriatenessScore = 0.0,
      final List<String> mealRecommendations = const [],
      required this.calorieAnalysis,
      required this.macroAnalysis,
      required this.microAnalysis,
      this.balanceScore = 0.0,
      final List<String> balanceWarnings = const [],
      final List<String> balanceStrengths = const [],
      final List<String> healthSuggestions = const [],
      final List<String> nextMealRecommendations = const [],
      final Map<String, double> longTermNutritionImpact = const {}})
      : _elementAnalysis = elementAnalysis,
        _mealRecommendations = mealRecommendations,
        _balanceWarnings = balanceWarnings,
        _balanceStrengths = balanceStrengths,
        _healthSuggestions = healthSuggestions,
        _nextMealRecommendations = nextMealRecommendations,
        _longTermNutritionImpact = longTermNutritionImpact;

  factory _$NutritionOrderAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionOrderAnalysisImplFromJson(json);

  @override
  final String orderId;
  @override
  final DateTime analysisTime;
// 营养完整性分析
  final Map<String, NutritionElementAnalysis> _elementAnalysis;
// 营养完整性分析
  @override
  Map<String, NutritionElementAnalysis> get elementAnalysis {
    if (_elementAnalysis is EqualUnmodifiableMapView) return _elementAnalysis;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_elementAnalysis);
  }

  @override
  @JsonKey()
  final double overallNutritionScore;
// 0-10
  @override
  @JsonKey()
  final String nutritionStatus;
// excellent, good, fair, poor
// 餐次分析
  @override
  final String mealType;
// breakfast, lunch, dinner, snack
  @override
  @JsonKey()
  final double mealAppropriatenessScore;
  final List<String> _mealRecommendations;
  @override
  @JsonKey()
  List<String> get mealRecommendations {
    if (_mealRecommendations is EqualUnmodifiableListView)
      return _mealRecommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mealRecommendations);
  }

// 热量分析
  @override
  final CalorieAnalysis calorieAnalysis;
// 宏量营养素分析
  @override
  final MacronutrientAnalysis macroAnalysis;
// 微量元素分析
  @override
  final MicronutrientAnalysis microAnalysis;
// 膳食平衡
  @override
  @JsonKey()
  final double balanceScore;
  final List<String> _balanceWarnings;
  @override
  @JsonKey()
  List<String> get balanceWarnings {
    if (_balanceWarnings is EqualUnmodifiableListView) return _balanceWarnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_balanceWarnings);
  }

  final List<String> _balanceStrengths;
  @override
  @JsonKey()
  List<String> get balanceStrengths {
    if (_balanceStrengths is EqualUnmodifiableListView)
      return _balanceStrengths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_balanceStrengths);
  }

// 健康建议
  final List<String> _healthSuggestions;
// 健康建议
  @override
  @JsonKey()
  List<String> get healthSuggestions {
    if (_healthSuggestions is EqualUnmodifiableListView)
      return _healthSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_healthSuggestions);
  }

  final List<String> _nextMealRecommendations;
  @override
  @JsonKey()
  List<String> get nextMealRecommendations {
    if (_nextMealRecommendations is EqualUnmodifiableListView)
      return _nextMealRecommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nextMealRecommendations);
  }

// 长期影响预测
  final Map<String, double> _longTermNutritionImpact;
// 长期影响预测
  @override
  @JsonKey()
  Map<String, double> get longTermNutritionImpact {
    if (_longTermNutritionImpact is EqualUnmodifiableMapView)
      return _longTermNutritionImpact;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_longTermNutritionImpact);
  }

  @override
  String toString() {
    return 'NutritionOrderAnalysis(orderId: $orderId, analysisTime: $analysisTime, elementAnalysis: $elementAnalysis, overallNutritionScore: $overallNutritionScore, nutritionStatus: $nutritionStatus, mealType: $mealType, mealAppropriatenessScore: $mealAppropriatenessScore, mealRecommendations: $mealRecommendations, calorieAnalysis: $calorieAnalysis, macroAnalysis: $macroAnalysis, microAnalysis: $microAnalysis, balanceScore: $balanceScore, balanceWarnings: $balanceWarnings, balanceStrengths: $balanceStrengths, healthSuggestions: $healthSuggestions, nextMealRecommendations: $nextMealRecommendations, longTermNutritionImpact: $longTermNutritionImpact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionOrderAnalysisImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.analysisTime, analysisTime) ||
                other.analysisTime == analysisTime) &&
            const DeepCollectionEquality()
                .equals(other._elementAnalysis, _elementAnalysis) &&
            (identical(other.overallNutritionScore, overallNutritionScore) ||
                other.overallNutritionScore == overallNutritionScore) &&
            (identical(other.nutritionStatus, nutritionStatus) ||
                other.nutritionStatus == nutritionStatus) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(
                    other.mealAppropriatenessScore, mealAppropriatenessScore) ||
                other.mealAppropriatenessScore == mealAppropriatenessScore) &&
            const DeepCollectionEquality()
                .equals(other._mealRecommendations, _mealRecommendations) &&
            (identical(other.calorieAnalysis, calorieAnalysis) ||
                other.calorieAnalysis == calorieAnalysis) &&
            (identical(other.macroAnalysis, macroAnalysis) ||
                other.macroAnalysis == macroAnalysis) &&
            (identical(other.microAnalysis, microAnalysis) ||
                other.microAnalysis == microAnalysis) &&
            (identical(other.balanceScore, balanceScore) ||
                other.balanceScore == balanceScore) &&
            const DeepCollectionEquality()
                .equals(other._balanceWarnings, _balanceWarnings) &&
            const DeepCollectionEquality()
                .equals(other._balanceStrengths, _balanceStrengths) &&
            const DeepCollectionEquality()
                .equals(other._healthSuggestions, _healthSuggestions) &&
            const DeepCollectionEquality().equals(
                other._nextMealRecommendations, _nextMealRecommendations) &&
            const DeepCollectionEquality().equals(
                other._longTermNutritionImpact, _longTermNutritionImpact));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      orderId,
      analysisTime,
      const DeepCollectionEquality().hash(_elementAnalysis),
      overallNutritionScore,
      nutritionStatus,
      mealType,
      mealAppropriatenessScore,
      const DeepCollectionEquality().hash(_mealRecommendations),
      calorieAnalysis,
      macroAnalysis,
      microAnalysis,
      balanceScore,
      const DeepCollectionEquality().hash(_balanceWarnings),
      const DeepCollectionEquality().hash(_balanceStrengths),
      const DeepCollectionEquality().hash(_healthSuggestions),
      const DeepCollectionEquality().hash(_nextMealRecommendations),
      const DeepCollectionEquality().hash(_longTermNutritionImpact));

  /// Create a copy of NutritionOrderAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionOrderAnalysisImplCopyWith<_$NutritionOrderAnalysisImpl>
      get copyWith => __$$NutritionOrderAnalysisImplCopyWithImpl<
          _$NutritionOrderAnalysisImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionOrderAnalysis value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionOrderAnalysis value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionOrderAnalysis value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionOrderAnalysisImplToJson(
      this,
    );
  }
}

abstract class _NutritionOrderAnalysis implements NutritionOrderAnalysis {
  const factory _NutritionOrderAnalysis(
          {required final String orderId,
          required final DateTime analysisTime,
          required final Map<String, NutritionElementAnalysis> elementAnalysis,
          final double overallNutritionScore,
          final String nutritionStatus,
          required final String mealType,
          final double mealAppropriatenessScore,
          final List<String> mealRecommendations,
          required final CalorieAnalysis calorieAnalysis,
          required final MacronutrientAnalysis macroAnalysis,
          required final MicronutrientAnalysis microAnalysis,
          final double balanceScore,
          final List<String> balanceWarnings,
          final List<String> balanceStrengths,
          final List<String> healthSuggestions,
          final List<String> nextMealRecommendations,
          final Map<String, double> longTermNutritionImpact}) =
      _$NutritionOrderAnalysisImpl;

  factory _NutritionOrderAnalysis.fromJson(Map<String, dynamic> json) =
      _$NutritionOrderAnalysisImpl.fromJson;

  @override
  String get orderId;
  @override
  DateTime get analysisTime; // 营养完整性分析
  @override
  Map<String, NutritionElementAnalysis> get elementAnalysis;
  @override
  double get overallNutritionScore; // 0-10
  @override
  String get nutritionStatus; // excellent, good, fair, poor
// 餐次分析
  @override
  String get mealType; // breakfast, lunch, dinner, snack
  @override
  double get mealAppropriatenessScore;
  @override
  List<String> get mealRecommendations; // 热量分析
  @override
  CalorieAnalysis get calorieAnalysis; // 宏量营养素分析
  @override
  MacronutrientAnalysis get macroAnalysis; // 微量元素分析
  @override
  MicronutrientAnalysis get microAnalysis; // 膳食平衡
  @override
  double get balanceScore;
  @override
  List<String> get balanceWarnings;
  @override
  List<String> get balanceStrengths; // 健康建议
  @override
  List<String> get healthSuggestions;
  @override
  List<String> get nextMealRecommendations; // 长期影响预测
  @override
  Map<String, double> get longTermNutritionImpact;

  /// Create a copy of NutritionOrderAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionOrderAnalysisImplCopyWith<_$NutritionOrderAnalysisImpl>
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
  double get completionRate => throw _privateConstructorUsedError;
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
  double get completionRate;
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
  String get mealTypeSuitability => throw _privateConstructorUsedError;

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
      int recommendedAdjustment,
      String mealTypeSuitability});
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
    Object? mealTypeSuitability = null,
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
      mealTypeSuitability: null == mealTypeSuitability
          ? _value.mealTypeSuitability
          : mealTypeSuitability // ignore: cast_nullable_to_non_nullable
              as String,
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
      int recommendedAdjustment,
      String mealTypeSuitability});
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
    Object? mealTypeSuitability = null,
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
      mealTypeSuitability: null == mealTypeSuitability
          ? _value.mealTypeSuitability
          : mealTypeSuitability // ignore: cast_nullable_to_non_nullable
              as String,
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
      this.recommendedAdjustment = 0,
      this.mealTypeSuitability = ''});

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
  @JsonKey()
  final String mealTypeSuitability;

  @override
  String toString() {
    return 'CalorieAnalysis(targetCalories: $targetCalories, currentCalories: $currentCalories, completionRate: $completionRate, status: $status, recommendedAdjustment: $recommendedAdjustment, mealTypeSuitability: $mealTypeSuitability)';
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
                other.recommendedAdjustment == recommendedAdjustment) &&
            (identical(other.mealTypeSuitability, mealTypeSuitability) ||
                other.mealTypeSuitability == mealTypeSuitability));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, targetCalories, currentCalories,
      completionRate, status, recommendedAdjustment, mealTypeSuitability);

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
      final int recommendedAdjustment,
      final String mealTypeSuitability}) = _$CalorieAnalysisImpl;

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
  @override
  String get mealTypeSuitability;

  /// Create a copy of CalorieAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalorieAnalysisImplCopyWith<_$CalorieAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MacronutrientAnalysis _$MacronutrientAnalysisFromJson(
    Map<String, dynamic> json) {
  return _MacronutrientAnalysis.fromJson(json);
}

/// @nodoc
mixin _$MacronutrientAnalysis {
// 蛋白质
  double get proteinTarget => throw _privateConstructorUsedError;
  double get proteinCurrent => throw _privateConstructorUsedError;
  double get proteinPercentage => throw _privateConstructorUsedError; // 碳水化合物
  double get carbTarget => throw _privateConstructorUsedError;
  double get carbCurrent => throw _privateConstructorUsedError;
  double get carbPercentage => throw _privateConstructorUsedError; // 脂肪
  double get fatTarget => throw _privateConstructorUsedError;
  double get fatCurrent => throw _privateConstructorUsedError;
  double get fatPercentage => throw _privateConstructorUsedError; // 平衡评估
  String get balanceStatus => throw _privateConstructorUsedError;
  List<String> get adjustmentSuggestions => throw _privateConstructorUsedError;
  double get balanceScore => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MacronutrientAnalysis value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MacronutrientAnalysis value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MacronutrientAnalysis value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MacronutrientAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MacronutrientAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MacronutrientAnalysisCopyWith<MacronutrientAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MacronutrientAnalysisCopyWith<$Res> {
  factory $MacronutrientAnalysisCopyWith(MacronutrientAnalysis value,
          $Res Function(MacronutrientAnalysis) then) =
      _$MacronutrientAnalysisCopyWithImpl<$Res, MacronutrientAnalysis>;
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
      List<String> adjustmentSuggestions,
      double balanceScore});
}

/// @nodoc
class _$MacronutrientAnalysisCopyWithImpl<$Res,
        $Val extends MacronutrientAnalysis>
    implements $MacronutrientAnalysisCopyWith<$Res> {
  _$MacronutrientAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MacronutrientAnalysis
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
    Object? balanceScore = null,
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
      balanceScore: null == balanceScore
          ? _value.balanceScore
          : balanceScore // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MacronutrientAnalysisImplCopyWith<$Res>
    implements $MacronutrientAnalysisCopyWith<$Res> {
  factory _$$MacronutrientAnalysisImplCopyWith(
          _$MacronutrientAnalysisImpl value,
          $Res Function(_$MacronutrientAnalysisImpl) then) =
      __$$MacronutrientAnalysisImplCopyWithImpl<$Res>;
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
      List<String> adjustmentSuggestions,
      double balanceScore});
}

/// @nodoc
class __$$MacronutrientAnalysisImplCopyWithImpl<$Res>
    extends _$MacronutrientAnalysisCopyWithImpl<$Res,
        _$MacronutrientAnalysisImpl>
    implements _$$MacronutrientAnalysisImplCopyWith<$Res> {
  __$$MacronutrientAnalysisImplCopyWithImpl(_$MacronutrientAnalysisImpl _value,
      $Res Function(_$MacronutrientAnalysisImpl) _then)
      : super(_value, _then);

  /// Create a copy of MacronutrientAnalysis
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
    Object? balanceScore = null,
  }) {
    return _then(_$MacronutrientAnalysisImpl(
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
      balanceScore: null == balanceScore
          ? _value.balanceScore
          : balanceScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MacronutrientAnalysisImpl implements _MacronutrientAnalysis {
  const _$MacronutrientAnalysisImpl(
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
      final List<String> adjustmentSuggestions = const [],
      this.balanceScore = 0.0})
      : _adjustmentSuggestions = adjustmentSuggestions;

  factory _$MacronutrientAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$MacronutrientAnalysisImplFromJson(json);

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
// 平衡评估
  @override
  final String balanceStatus;
  final List<String> _adjustmentSuggestions;
  @override
  @JsonKey()
  List<String> get adjustmentSuggestions {
    if (_adjustmentSuggestions is EqualUnmodifiableListView)
      return _adjustmentSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adjustmentSuggestions);
  }

  @override
  @JsonKey()
  final double balanceScore;

  @override
  String toString() {
    return 'MacronutrientAnalysis(proteinTarget: $proteinTarget, proteinCurrent: $proteinCurrent, proteinPercentage: $proteinPercentage, carbTarget: $carbTarget, carbCurrent: $carbCurrent, carbPercentage: $carbPercentage, fatTarget: $fatTarget, fatCurrent: $fatCurrent, fatPercentage: $fatPercentage, balanceStatus: $balanceStatus, adjustmentSuggestions: $adjustmentSuggestions, balanceScore: $balanceScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MacronutrientAnalysisImpl &&
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
                .equals(other._adjustmentSuggestions, _adjustmentSuggestions) &&
            (identical(other.balanceScore, balanceScore) ||
                other.balanceScore == balanceScore));
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
      const DeepCollectionEquality().hash(_adjustmentSuggestions),
      balanceScore);

  /// Create a copy of MacronutrientAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MacronutrientAnalysisImplCopyWith<_$MacronutrientAnalysisImpl>
      get copyWith => __$$MacronutrientAnalysisImplCopyWithImpl<
          _$MacronutrientAnalysisImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MacronutrientAnalysis value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MacronutrientAnalysis value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MacronutrientAnalysis value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MacronutrientAnalysisImplToJson(
      this,
    );
  }
}

abstract class _MacronutrientAnalysis implements MacronutrientAnalysis {
  const factory _MacronutrientAnalysis(
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
      final List<String> adjustmentSuggestions,
      final double balanceScore}) = _$MacronutrientAnalysisImpl;

  factory _MacronutrientAnalysis.fromJson(Map<String, dynamic> json) =
      _$MacronutrientAnalysisImpl.fromJson;

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
  double get fatPercentage; // 平衡评估
  @override
  String get balanceStatus;
  @override
  List<String> get adjustmentSuggestions;
  @override
  double get balanceScore;

  /// Create a copy of MacronutrientAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MacronutrientAnalysisImplCopyWith<_$MacronutrientAnalysisImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MicronutrientAnalysis _$MicronutrientAnalysisFromJson(
    Map<String, dynamic> json) {
  return _MicronutrientAnalysis.fromJson(json);
}

/// @nodoc
mixin _$MicronutrientAnalysis {
// 维生素状态
  Map<String, String> get vitaminStatus => throw _privateConstructorUsedError;
  List<String> get vitaminDeficiencies => throw _privateConstructorUsedError;
  List<String> get vitaminExcesses =>
      throw _privateConstructorUsedError; // 矿物质状态
  Map<String, String> get mineralStatus => throw _privateConstructorUsedError;
  List<String> get mineralDeficiencies => throw _privateConstructorUsedError;
  List<String> get mineralExcesses =>
      throw _privateConstructorUsedError; // 膳食纤维
  double get fiberTarget => throw _privateConstructorUsedError;
  double get fiberCurrent => throw _privateConstructorUsedError;
  String get fiberStatus => throw _privateConstructorUsedError; // 抗氧化剂
  double get antioxidantScore => throw _privateConstructorUsedError;
  List<String> get antioxidantSources =>
      throw _privateConstructorUsedError; // 整体评分
  double get micronutrientScore => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MicronutrientAnalysis value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MicronutrientAnalysis value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MicronutrientAnalysis value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MicronutrientAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MicronutrientAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MicronutrientAnalysisCopyWith<MicronutrientAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MicronutrientAnalysisCopyWith<$Res> {
  factory $MicronutrientAnalysisCopyWith(MicronutrientAnalysis value,
          $Res Function(MicronutrientAnalysis) then) =
      _$MicronutrientAnalysisCopyWithImpl<$Res, MicronutrientAnalysis>;
  @useResult
  $Res call(
      {Map<String, String> vitaminStatus,
      List<String> vitaminDeficiencies,
      List<String> vitaminExcesses,
      Map<String, String> mineralStatus,
      List<String> mineralDeficiencies,
      List<String> mineralExcesses,
      double fiberTarget,
      double fiberCurrent,
      String fiberStatus,
      double antioxidantScore,
      List<String> antioxidantSources,
      double micronutrientScore});
}

/// @nodoc
class _$MicronutrientAnalysisCopyWithImpl<$Res,
        $Val extends MicronutrientAnalysis>
    implements $MicronutrientAnalysisCopyWith<$Res> {
  _$MicronutrientAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MicronutrientAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vitaminStatus = null,
    Object? vitaminDeficiencies = null,
    Object? vitaminExcesses = null,
    Object? mineralStatus = null,
    Object? mineralDeficiencies = null,
    Object? mineralExcesses = null,
    Object? fiberTarget = null,
    Object? fiberCurrent = null,
    Object? fiberStatus = null,
    Object? antioxidantScore = null,
    Object? antioxidantSources = null,
    Object? micronutrientScore = null,
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
      vitaminExcesses: null == vitaminExcesses
          ? _value.vitaminExcesses
          : vitaminExcesses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mineralStatus: null == mineralStatus
          ? _value.mineralStatus
          : mineralStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      mineralDeficiencies: null == mineralDeficiencies
          ? _value.mineralDeficiencies
          : mineralDeficiencies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mineralExcesses: null == mineralExcesses
          ? _value.mineralExcesses
          : mineralExcesses // ignore: cast_nullable_to_non_nullable
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
      antioxidantScore: null == antioxidantScore
          ? _value.antioxidantScore
          : antioxidantScore // ignore: cast_nullable_to_non_nullable
              as double,
      antioxidantSources: null == antioxidantSources
          ? _value.antioxidantSources
          : antioxidantSources // ignore: cast_nullable_to_non_nullable
              as List<String>,
      micronutrientScore: null == micronutrientScore
          ? _value.micronutrientScore
          : micronutrientScore // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MicronutrientAnalysisImplCopyWith<$Res>
    implements $MicronutrientAnalysisCopyWith<$Res> {
  factory _$$MicronutrientAnalysisImplCopyWith(
          _$MicronutrientAnalysisImpl value,
          $Res Function(_$MicronutrientAnalysisImpl) then) =
      __$$MicronutrientAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, String> vitaminStatus,
      List<String> vitaminDeficiencies,
      List<String> vitaminExcesses,
      Map<String, String> mineralStatus,
      List<String> mineralDeficiencies,
      List<String> mineralExcesses,
      double fiberTarget,
      double fiberCurrent,
      String fiberStatus,
      double antioxidantScore,
      List<String> antioxidantSources,
      double micronutrientScore});
}

/// @nodoc
class __$$MicronutrientAnalysisImplCopyWithImpl<$Res>
    extends _$MicronutrientAnalysisCopyWithImpl<$Res,
        _$MicronutrientAnalysisImpl>
    implements _$$MicronutrientAnalysisImplCopyWith<$Res> {
  __$$MicronutrientAnalysisImplCopyWithImpl(_$MicronutrientAnalysisImpl _value,
      $Res Function(_$MicronutrientAnalysisImpl) _then)
      : super(_value, _then);

  /// Create a copy of MicronutrientAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vitaminStatus = null,
    Object? vitaminDeficiencies = null,
    Object? vitaminExcesses = null,
    Object? mineralStatus = null,
    Object? mineralDeficiencies = null,
    Object? mineralExcesses = null,
    Object? fiberTarget = null,
    Object? fiberCurrent = null,
    Object? fiberStatus = null,
    Object? antioxidantScore = null,
    Object? antioxidantSources = null,
    Object? micronutrientScore = null,
  }) {
    return _then(_$MicronutrientAnalysisImpl(
      vitaminStatus: null == vitaminStatus
          ? _value._vitaminStatus
          : vitaminStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      vitaminDeficiencies: null == vitaminDeficiencies
          ? _value._vitaminDeficiencies
          : vitaminDeficiencies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      vitaminExcesses: null == vitaminExcesses
          ? _value._vitaminExcesses
          : vitaminExcesses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mineralStatus: null == mineralStatus
          ? _value._mineralStatus
          : mineralStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      mineralDeficiencies: null == mineralDeficiencies
          ? _value._mineralDeficiencies
          : mineralDeficiencies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mineralExcesses: null == mineralExcesses
          ? _value._mineralExcesses
          : mineralExcesses // ignore: cast_nullable_to_non_nullable
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
      antioxidantScore: null == antioxidantScore
          ? _value.antioxidantScore
          : antioxidantScore // ignore: cast_nullable_to_non_nullable
              as double,
      antioxidantSources: null == antioxidantSources
          ? _value._antioxidantSources
          : antioxidantSources // ignore: cast_nullable_to_non_nullable
              as List<String>,
      micronutrientScore: null == micronutrientScore
          ? _value.micronutrientScore
          : micronutrientScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MicronutrientAnalysisImpl implements _MicronutrientAnalysis {
  const _$MicronutrientAnalysisImpl(
      {final Map<String, String> vitaminStatus = const {},
      final List<String> vitaminDeficiencies = const [],
      final List<String> vitaminExcesses = const [],
      final Map<String, String> mineralStatus = const {},
      final List<String> mineralDeficiencies = const [],
      final List<String> mineralExcesses = const [],
      required this.fiberTarget,
      required this.fiberCurrent,
      required this.fiberStatus,
      this.antioxidantScore = 0.0,
      final List<String> antioxidantSources = const [],
      this.micronutrientScore = 0.0})
      : _vitaminStatus = vitaminStatus,
        _vitaminDeficiencies = vitaminDeficiencies,
        _vitaminExcesses = vitaminExcesses,
        _mineralStatus = mineralStatus,
        _mineralDeficiencies = mineralDeficiencies,
        _mineralExcesses = mineralExcesses,
        _antioxidantSources = antioxidantSources;

  factory _$MicronutrientAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$MicronutrientAnalysisImplFromJson(json);

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

  final List<String> _vitaminDeficiencies;
  @override
  @JsonKey()
  List<String> get vitaminDeficiencies {
    if (_vitaminDeficiencies is EqualUnmodifiableListView)
      return _vitaminDeficiencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vitaminDeficiencies);
  }

  final List<String> _vitaminExcesses;
  @override
  @JsonKey()
  List<String> get vitaminExcesses {
    if (_vitaminExcesses is EqualUnmodifiableListView) return _vitaminExcesses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vitaminExcesses);
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

  final List<String> _mineralDeficiencies;
  @override
  @JsonKey()
  List<String> get mineralDeficiencies {
    if (_mineralDeficiencies is EqualUnmodifiableListView)
      return _mineralDeficiencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mineralDeficiencies);
  }

  final List<String> _mineralExcesses;
  @override
  @JsonKey()
  List<String> get mineralExcesses {
    if (_mineralExcesses is EqualUnmodifiableListView) return _mineralExcesses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mineralExcesses);
  }

// 膳食纤维
  @override
  final double fiberTarget;
  @override
  final double fiberCurrent;
  @override
  final String fiberStatus;
// 抗氧化剂
  @override
  @JsonKey()
  final double antioxidantScore;
  final List<String> _antioxidantSources;
  @override
  @JsonKey()
  List<String> get antioxidantSources {
    if (_antioxidantSources is EqualUnmodifiableListView)
      return _antioxidantSources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_antioxidantSources);
  }

// 整体评分
  @override
  @JsonKey()
  final double micronutrientScore;

  @override
  String toString() {
    return 'MicronutrientAnalysis(vitaminStatus: $vitaminStatus, vitaminDeficiencies: $vitaminDeficiencies, vitaminExcesses: $vitaminExcesses, mineralStatus: $mineralStatus, mineralDeficiencies: $mineralDeficiencies, mineralExcesses: $mineralExcesses, fiberTarget: $fiberTarget, fiberCurrent: $fiberCurrent, fiberStatus: $fiberStatus, antioxidantScore: $antioxidantScore, antioxidantSources: $antioxidantSources, micronutrientScore: $micronutrientScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MicronutrientAnalysisImpl &&
            const DeepCollectionEquality()
                .equals(other._vitaminStatus, _vitaminStatus) &&
            const DeepCollectionEquality()
                .equals(other._vitaminDeficiencies, _vitaminDeficiencies) &&
            const DeepCollectionEquality()
                .equals(other._vitaminExcesses, _vitaminExcesses) &&
            const DeepCollectionEquality()
                .equals(other._mineralStatus, _mineralStatus) &&
            const DeepCollectionEquality()
                .equals(other._mineralDeficiencies, _mineralDeficiencies) &&
            const DeepCollectionEquality()
                .equals(other._mineralExcesses, _mineralExcesses) &&
            (identical(other.fiberTarget, fiberTarget) ||
                other.fiberTarget == fiberTarget) &&
            (identical(other.fiberCurrent, fiberCurrent) ||
                other.fiberCurrent == fiberCurrent) &&
            (identical(other.fiberStatus, fiberStatus) ||
                other.fiberStatus == fiberStatus) &&
            (identical(other.antioxidantScore, antioxidantScore) ||
                other.antioxidantScore == antioxidantScore) &&
            const DeepCollectionEquality()
                .equals(other._antioxidantSources, _antioxidantSources) &&
            (identical(other.micronutrientScore, micronutrientScore) ||
                other.micronutrientScore == micronutrientScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_vitaminStatus),
      const DeepCollectionEquality().hash(_vitaminDeficiencies),
      const DeepCollectionEquality().hash(_vitaminExcesses),
      const DeepCollectionEquality().hash(_mineralStatus),
      const DeepCollectionEquality().hash(_mineralDeficiencies),
      const DeepCollectionEquality().hash(_mineralExcesses),
      fiberTarget,
      fiberCurrent,
      fiberStatus,
      antioxidantScore,
      const DeepCollectionEquality().hash(_antioxidantSources),
      micronutrientScore);

  /// Create a copy of MicronutrientAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MicronutrientAnalysisImplCopyWith<_$MicronutrientAnalysisImpl>
      get copyWith => __$$MicronutrientAnalysisImplCopyWithImpl<
          _$MicronutrientAnalysisImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MicronutrientAnalysis value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MicronutrientAnalysis value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MicronutrientAnalysis value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MicronutrientAnalysisImplToJson(
      this,
    );
  }
}

abstract class _MicronutrientAnalysis implements MicronutrientAnalysis {
  const factory _MicronutrientAnalysis(
      {final Map<String, String> vitaminStatus,
      final List<String> vitaminDeficiencies,
      final List<String> vitaminExcesses,
      final Map<String, String> mineralStatus,
      final List<String> mineralDeficiencies,
      final List<String> mineralExcesses,
      required final double fiberTarget,
      required final double fiberCurrent,
      required final String fiberStatus,
      final double antioxidantScore,
      final List<String> antioxidantSources,
      final double micronutrientScore}) = _$MicronutrientAnalysisImpl;

  factory _MicronutrientAnalysis.fromJson(Map<String, dynamic> json) =
      _$MicronutrientAnalysisImpl.fromJson;

// 维生素状态
  @override
  Map<String, String> get vitaminStatus;
  @override
  List<String> get vitaminDeficiencies;
  @override
  List<String> get vitaminExcesses; // 矿物质状态
  @override
  Map<String, String> get mineralStatus;
  @override
  List<String> get mineralDeficiencies;
  @override
  List<String> get mineralExcesses; // 膳食纤维
  @override
  double get fiberTarget;
  @override
  double get fiberCurrent;
  @override
  String get fiberStatus; // 抗氧化剂
  @override
  double get antioxidantScore;
  @override
  List<String> get antioxidantSources; // 整体评分
  @override
  double get micronutrientScore;

  /// Create a copy of MicronutrientAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MicronutrientAnalysisImplCopyWith<_$MicronutrientAnalysisImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OrderStatusUpdate _$OrderStatusUpdateFromJson(Map<String, dynamic> json) {
  return _OrderStatusUpdate.fromJson(json);
}

/// @nodoc
mixin _$OrderStatusUpdate {
  String get id => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get operatorId => throw _privateConstructorUsedError;
  String? get operatorName => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderStatusUpdate value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderStatusUpdate value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderStatusUpdate value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderStatusUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderStatusUpdateCopyWith<OrderStatusUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderStatusUpdateCopyWith<$Res> {
  factory $OrderStatusUpdateCopyWith(
          OrderStatusUpdate value, $Res Function(OrderStatusUpdate) then) =
      _$OrderStatusUpdateCopyWithImpl<$Res, OrderStatusUpdate>;
  @useResult
  $Res call(
      {String id,
      String status,
      String message,
      DateTime timestamp,
      String? operatorId,
      String? operatorName,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$OrderStatusUpdateCopyWithImpl<$Res, $Val extends OrderStatusUpdate>
    implements $OrderStatusUpdateCopyWith<$Res> {
  _$OrderStatusUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? message = null,
    Object? timestamp = null,
    Object? operatorId = freezed,
    Object? operatorName = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      operatorId: freezed == operatorId
          ? _value.operatorId
          : operatorId // ignore: cast_nullable_to_non_nullable
              as String?,
      operatorName: freezed == operatorName
          ? _value.operatorName
          : operatorName // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderStatusUpdateImplCopyWith<$Res>
    implements $OrderStatusUpdateCopyWith<$Res> {
  factory _$$OrderStatusUpdateImplCopyWith(_$OrderStatusUpdateImpl value,
          $Res Function(_$OrderStatusUpdateImpl) then) =
      __$$OrderStatusUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String status,
      String message,
      DateTime timestamp,
      String? operatorId,
      String? operatorName,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$OrderStatusUpdateImplCopyWithImpl<$Res>
    extends _$OrderStatusUpdateCopyWithImpl<$Res, _$OrderStatusUpdateImpl>
    implements _$$OrderStatusUpdateImplCopyWith<$Res> {
  __$$OrderStatusUpdateImplCopyWithImpl(_$OrderStatusUpdateImpl _value,
      $Res Function(_$OrderStatusUpdateImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? message = null,
    Object? timestamp = null,
    Object? operatorId = freezed,
    Object? operatorName = freezed,
    Object? metadata = null,
  }) {
    return _then(_$OrderStatusUpdateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      operatorId: freezed == operatorId
          ? _value.operatorId
          : operatorId // ignore: cast_nullable_to_non_nullable
              as String?,
      operatorName: freezed == operatorName
          ? _value.operatorName
          : operatorName // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderStatusUpdateImpl implements _OrderStatusUpdate {
  const _$OrderStatusUpdateImpl(
      {required this.id,
      required this.status,
      required this.message,
      required this.timestamp,
      this.operatorId,
      this.operatorName,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata;

  factory _$OrderStatusUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderStatusUpdateImplFromJson(json);

  @override
  final String id;
  @override
  final String status;
  @override
  final String message;
  @override
  final DateTime timestamp;
  @override
  final String? operatorId;
  @override
  final String? operatorName;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'OrderStatusUpdate(id: $id, status: $status, message: $message, timestamp: $timestamp, operatorId: $operatorId, operatorName: $operatorName, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderStatusUpdateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.operatorId, operatorId) ||
                other.operatorId == operatorId) &&
            (identical(other.operatorName, operatorName) ||
                other.operatorName == operatorName) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, status, message, timestamp,
      operatorId, operatorName, const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of OrderStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderStatusUpdateImplCopyWith<_$OrderStatusUpdateImpl> get copyWith =>
      __$$OrderStatusUpdateImplCopyWithImpl<_$OrderStatusUpdateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderStatusUpdate value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderStatusUpdate value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderStatusUpdate value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderStatusUpdateImplToJson(
      this,
    );
  }
}

abstract class _OrderStatusUpdate implements OrderStatusUpdate {
  const factory _OrderStatusUpdate(
      {required final String id,
      required final String status,
      required final String message,
      required final DateTime timestamp,
      final String? operatorId,
      final String? operatorName,
      final Map<String, dynamic> metadata}) = _$OrderStatusUpdateImpl;

  factory _OrderStatusUpdate.fromJson(Map<String, dynamic> json) =
      _$OrderStatusUpdateImpl.fromJson;

  @override
  String get id;
  @override
  String get status;
  @override
  String get message;
  @override
  DateTime get timestamp;
  @override
  String? get operatorId;
  @override
  String? get operatorName;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of OrderStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderStatusUpdateImplCopyWith<_$OrderStatusUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeliveryInfo _$DeliveryInfoFromJson(Map<String, dynamic> json) {
  return _DeliveryInfo.fromJson(json);
}

/// @nodoc
mixin _$DeliveryInfo {
  String get orderId => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError; // delivery, pickup
  String get address => throw _privateConstructorUsedError;
  Map<String, double> get location =>
      throw _privateConstructorUsedError; // lat, lng
  String? get contact => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError; // 配送时间
  DateTime? get estimatedTime => throw _privateConstructorUsedError;
  DateTime? get actualTime => throw _privateConstructorUsedError;
  int get estimatedDuration => throw _privateConstructorUsedError; // 预计配送时间（分钟）
// 配送员信息
  String? get driverId => throw _privateConstructorUsedError;
  String? get driverName => throw _privateConstructorUsedError;
  String? get driverPhone => throw _privateConstructorUsedError;
  String? get vehicleInfo => throw _privateConstructorUsedError; // 配送状态
  String get status =>
      throw _privateConstructorUsedError; // pending, assigned, picked_up, in_transit, delivered
  List<DeliveryStatusUpdate> get statusHistory =>
      throw _privateConstructorUsedError; // 配送费用
  double get deliveryFee => throw _privateConstructorUsedError;
  double get tip => throw _privateConstructorUsedError; // 特殊信息
  List<String> get deliveryInstructions => throw _privateConstructorUsedError;
  String? get accessCode => throw _privateConstructorUsedError;
  String? get buildingInfo => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DeliveryInfo value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DeliveryInfo value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DeliveryInfo value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this DeliveryInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeliveryInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryInfoCopyWith<DeliveryInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryInfoCopyWith<$Res> {
  factory $DeliveryInfoCopyWith(
          DeliveryInfo value, $Res Function(DeliveryInfo) then) =
      _$DeliveryInfoCopyWithImpl<$Res, DeliveryInfo>;
  @useResult
  $Res call(
      {String orderId,
      String method,
      String address,
      Map<String, double> location,
      String? contact,
      String? phone,
      String? notes,
      DateTime? estimatedTime,
      DateTime? actualTime,
      int estimatedDuration,
      String? driverId,
      String? driverName,
      String? driverPhone,
      String? vehicleInfo,
      String status,
      List<DeliveryStatusUpdate> statusHistory,
      double deliveryFee,
      double tip,
      List<String> deliveryInstructions,
      String? accessCode,
      String? buildingInfo});
}

/// @nodoc
class _$DeliveryInfoCopyWithImpl<$Res, $Val extends DeliveryInfo>
    implements $DeliveryInfoCopyWith<$Res> {
  _$DeliveryInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? method = null,
    Object? address = null,
    Object? location = null,
    Object? contact = freezed,
    Object? phone = freezed,
    Object? notes = freezed,
    Object? estimatedTime = freezed,
    Object? actualTime = freezed,
    Object? estimatedDuration = null,
    Object? driverId = freezed,
    Object? driverName = freezed,
    Object? driverPhone = freezed,
    Object? vehicleInfo = freezed,
    Object? status = null,
    Object? statusHistory = null,
    Object? deliveryFee = null,
    Object? tip = null,
    Object? deliveryInstructions = null,
    Object? accessCode = freezed,
    Object? buildingInfo = freezed,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      contact: freezed == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedTime: freezed == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualTime: freezed == actualTime
          ? _value.actualTime
          : actualTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedDuration: null == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as int,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String?,
      driverName: freezed == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String?,
      driverPhone: freezed == driverPhone
          ? _value.driverPhone
          : driverPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleInfo: freezed == vehicleInfo
          ? _value.vehicleInfo
          : vehicleInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      statusHistory: null == statusHistory
          ? _value.statusHistory
          : statusHistory // ignore: cast_nullable_to_non_nullable
              as List<DeliveryStatusUpdate>,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      tip: null == tip
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryInstructions: null == deliveryInstructions
          ? _value.deliveryInstructions
          : deliveryInstructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      accessCode: freezed == accessCode
          ? _value.accessCode
          : accessCode // ignore: cast_nullable_to_non_nullable
              as String?,
      buildingInfo: freezed == buildingInfo
          ? _value.buildingInfo
          : buildingInfo // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeliveryInfoImplCopyWith<$Res>
    implements $DeliveryInfoCopyWith<$Res> {
  factory _$$DeliveryInfoImplCopyWith(
          _$DeliveryInfoImpl value, $Res Function(_$DeliveryInfoImpl) then) =
      __$$DeliveryInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String orderId,
      String method,
      String address,
      Map<String, double> location,
      String? contact,
      String? phone,
      String? notes,
      DateTime? estimatedTime,
      DateTime? actualTime,
      int estimatedDuration,
      String? driverId,
      String? driverName,
      String? driverPhone,
      String? vehicleInfo,
      String status,
      List<DeliveryStatusUpdate> statusHistory,
      double deliveryFee,
      double tip,
      List<String> deliveryInstructions,
      String? accessCode,
      String? buildingInfo});
}

/// @nodoc
class __$$DeliveryInfoImplCopyWithImpl<$Res>
    extends _$DeliveryInfoCopyWithImpl<$Res, _$DeliveryInfoImpl>
    implements _$$DeliveryInfoImplCopyWith<$Res> {
  __$$DeliveryInfoImplCopyWithImpl(
      _$DeliveryInfoImpl _value, $Res Function(_$DeliveryInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeliveryInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? method = null,
    Object? address = null,
    Object? location = null,
    Object? contact = freezed,
    Object? phone = freezed,
    Object? notes = freezed,
    Object? estimatedTime = freezed,
    Object? actualTime = freezed,
    Object? estimatedDuration = null,
    Object? driverId = freezed,
    Object? driverName = freezed,
    Object? driverPhone = freezed,
    Object? vehicleInfo = freezed,
    Object? status = null,
    Object? statusHistory = null,
    Object? deliveryFee = null,
    Object? tip = null,
    Object? deliveryInstructions = null,
    Object? accessCode = freezed,
    Object? buildingInfo = freezed,
  }) {
    return _then(_$DeliveryInfoImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value._location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      contact: freezed == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedTime: freezed == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualTime: freezed == actualTime
          ? _value.actualTime
          : actualTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedDuration: null == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as int,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String?,
      driverName: freezed == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String?,
      driverPhone: freezed == driverPhone
          ? _value.driverPhone
          : driverPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleInfo: freezed == vehicleInfo
          ? _value.vehicleInfo
          : vehicleInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      statusHistory: null == statusHistory
          ? _value._statusHistory
          : statusHistory // ignore: cast_nullable_to_non_nullable
              as List<DeliveryStatusUpdate>,
      deliveryFee: null == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double,
      tip: null == tip
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryInstructions: null == deliveryInstructions
          ? _value._deliveryInstructions
          : deliveryInstructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      accessCode: freezed == accessCode
          ? _value.accessCode
          : accessCode // ignore: cast_nullable_to_non_nullable
              as String?,
      buildingInfo: freezed == buildingInfo
          ? _value.buildingInfo
          : buildingInfo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryInfoImpl implements _DeliveryInfo {
  const _$DeliveryInfoImpl(
      {required this.orderId,
      required this.method,
      required this.address,
      final Map<String, double> location = const {},
      this.contact,
      this.phone,
      this.notes,
      this.estimatedTime,
      this.actualTime,
      this.estimatedDuration = 0,
      this.driverId,
      this.driverName,
      this.driverPhone,
      this.vehicleInfo,
      required this.status,
      final List<DeliveryStatusUpdate> statusHistory = const [],
      required this.deliveryFee,
      this.tip = 0.0,
      final List<String> deliveryInstructions = const [],
      this.accessCode,
      this.buildingInfo})
      : _location = location,
        _statusHistory = statusHistory,
        _deliveryInstructions = deliveryInstructions;

  factory _$DeliveryInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryInfoImplFromJson(json);

  @override
  final String orderId;
  @override
  final String method;
// delivery, pickup
  @override
  final String address;
  final Map<String, double> _location;
  @override
  @JsonKey()
  Map<String, double> get location {
    if (_location is EqualUnmodifiableMapView) return _location;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_location);
  }

// lat, lng
  @override
  final String? contact;
  @override
  final String? phone;
  @override
  final String? notes;
// 配送时间
  @override
  final DateTime? estimatedTime;
  @override
  final DateTime? actualTime;
  @override
  @JsonKey()
  final int estimatedDuration;
// 预计配送时间（分钟）
// 配送员信息
  @override
  final String? driverId;
  @override
  final String? driverName;
  @override
  final String? driverPhone;
  @override
  final String? vehicleInfo;
// 配送状态
  @override
  final String status;
// pending, assigned, picked_up, in_transit, delivered
  final List<DeliveryStatusUpdate> _statusHistory;
// pending, assigned, picked_up, in_transit, delivered
  @override
  @JsonKey()
  List<DeliveryStatusUpdate> get statusHistory {
    if (_statusHistory is EqualUnmodifiableListView) return _statusHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statusHistory);
  }

// 配送费用
  @override
  final double deliveryFee;
  @override
  @JsonKey()
  final double tip;
// 特殊信息
  final List<String> _deliveryInstructions;
// 特殊信息
  @override
  @JsonKey()
  List<String> get deliveryInstructions {
    if (_deliveryInstructions is EqualUnmodifiableListView)
      return _deliveryInstructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deliveryInstructions);
  }

  @override
  final String? accessCode;
  @override
  final String? buildingInfo;

  @override
  String toString() {
    return 'DeliveryInfo(orderId: $orderId, method: $method, address: $address, location: $location, contact: $contact, phone: $phone, notes: $notes, estimatedTime: $estimatedTime, actualTime: $actualTime, estimatedDuration: $estimatedDuration, driverId: $driverId, driverName: $driverName, driverPhone: $driverPhone, vehicleInfo: $vehicleInfo, status: $status, statusHistory: $statusHistory, deliveryFee: $deliveryFee, tip: $tip, deliveryInstructions: $deliveryInstructions, accessCode: $accessCode, buildingInfo: $buildingInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryInfoImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(other._location, _location) &&
            (identical(other.contact, contact) || other.contact == contact) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.estimatedTime, estimatedTime) ||
                other.estimatedTime == estimatedTime) &&
            (identical(other.actualTime, actualTime) ||
                other.actualTime == actualTime) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.driverPhone, driverPhone) ||
                other.driverPhone == driverPhone) &&
            (identical(other.vehicleInfo, vehicleInfo) ||
                other.vehicleInfo == vehicleInfo) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._statusHistory, _statusHistory) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.tip, tip) || other.tip == tip) &&
            const DeepCollectionEquality()
                .equals(other._deliveryInstructions, _deliveryInstructions) &&
            (identical(other.accessCode, accessCode) ||
                other.accessCode == accessCode) &&
            (identical(other.buildingInfo, buildingInfo) ||
                other.buildingInfo == buildingInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        orderId,
        method,
        address,
        const DeepCollectionEquality().hash(_location),
        contact,
        phone,
        notes,
        estimatedTime,
        actualTime,
        estimatedDuration,
        driverId,
        driverName,
        driverPhone,
        vehicleInfo,
        status,
        const DeepCollectionEquality().hash(_statusHistory),
        deliveryFee,
        tip,
        const DeepCollectionEquality().hash(_deliveryInstructions),
        accessCode,
        buildingInfo
      ]);

  /// Create a copy of DeliveryInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryInfoImplCopyWith<_$DeliveryInfoImpl> get copyWith =>
      __$$DeliveryInfoImplCopyWithImpl<_$DeliveryInfoImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DeliveryInfo value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DeliveryInfo value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DeliveryInfo value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryInfoImplToJson(
      this,
    );
  }
}

abstract class _DeliveryInfo implements DeliveryInfo {
  const factory _DeliveryInfo(
      {required final String orderId,
      required final String method,
      required final String address,
      final Map<String, double> location,
      final String? contact,
      final String? phone,
      final String? notes,
      final DateTime? estimatedTime,
      final DateTime? actualTime,
      final int estimatedDuration,
      final String? driverId,
      final String? driverName,
      final String? driverPhone,
      final String? vehicleInfo,
      required final String status,
      final List<DeliveryStatusUpdate> statusHistory,
      required final double deliveryFee,
      final double tip,
      final List<String> deliveryInstructions,
      final String? accessCode,
      final String? buildingInfo}) = _$DeliveryInfoImpl;

  factory _DeliveryInfo.fromJson(Map<String, dynamic> json) =
      _$DeliveryInfoImpl.fromJson;

  @override
  String get orderId;
  @override
  String get method; // delivery, pickup
  @override
  String get address;
  @override
  Map<String, double> get location; // lat, lng
  @override
  String? get contact;
  @override
  String? get phone;
  @override
  String? get notes; // 配送时间
  @override
  DateTime? get estimatedTime;
  @override
  DateTime? get actualTime;
  @override
  int get estimatedDuration; // 预计配送时间（分钟）
// 配送员信息
  @override
  String? get driverId;
  @override
  String? get driverName;
  @override
  String? get driverPhone;
  @override
  String? get vehicleInfo; // 配送状态
  @override
  String get status; // pending, assigned, picked_up, in_transit, delivered
  @override
  List<DeliveryStatusUpdate> get statusHistory; // 配送费用
  @override
  double get deliveryFee;
  @override
  double get tip; // 特殊信息
  @override
  List<String> get deliveryInstructions;
  @override
  String? get accessCode;
  @override
  String? get buildingInfo;

  /// Create a copy of DeliveryInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryInfoImplCopyWith<_$DeliveryInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeliveryStatusUpdate _$DeliveryStatusUpdateFromJson(Map<String, dynamic> json) {
  return _DeliveryStatusUpdate.fromJson(json);
}

/// @nodoc
mixin _$DeliveryStatusUpdate {
  String get id => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, double> get location => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DeliveryStatusUpdate value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DeliveryStatusUpdate value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DeliveryStatusUpdate value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this DeliveryStatusUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeliveryStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryStatusUpdateCopyWith<DeliveryStatusUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryStatusUpdateCopyWith<$Res> {
  factory $DeliveryStatusUpdateCopyWith(DeliveryStatusUpdate value,
          $Res Function(DeliveryStatusUpdate) then) =
      _$DeliveryStatusUpdateCopyWithImpl<$Res, DeliveryStatusUpdate>;
  @useResult
  $Res call(
      {String id,
      String status,
      DateTime timestamp,
      Map<String, double> location,
      String? message,
      String? photoUrl});
}

/// @nodoc
class _$DeliveryStatusUpdateCopyWithImpl<$Res,
        $Val extends DeliveryStatusUpdate>
    implements $DeliveryStatusUpdateCopyWith<$Res> {
  _$DeliveryStatusUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? timestamp = null,
    Object? location = null,
    Object? message = freezed,
    Object? photoUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeliveryStatusUpdateImplCopyWith<$Res>
    implements $DeliveryStatusUpdateCopyWith<$Res> {
  factory _$$DeliveryStatusUpdateImplCopyWith(_$DeliveryStatusUpdateImpl value,
          $Res Function(_$DeliveryStatusUpdateImpl) then) =
      __$$DeliveryStatusUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String status,
      DateTime timestamp,
      Map<String, double> location,
      String? message,
      String? photoUrl});
}

/// @nodoc
class __$$DeliveryStatusUpdateImplCopyWithImpl<$Res>
    extends _$DeliveryStatusUpdateCopyWithImpl<$Res, _$DeliveryStatusUpdateImpl>
    implements _$$DeliveryStatusUpdateImplCopyWith<$Res> {
  __$$DeliveryStatusUpdateImplCopyWithImpl(_$DeliveryStatusUpdateImpl _value,
      $Res Function(_$DeliveryStatusUpdateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeliveryStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? timestamp = null,
    Object? location = null,
    Object? message = freezed,
    Object? photoUrl = freezed,
  }) {
    return _then(_$DeliveryStatusUpdateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: null == location
          ? _value._location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryStatusUpdateImpl implements _DeliveryStatusUpdate {
  const _$DeliveryStatusUpdateImpl(
      {required this.id,
      required this.status,
      required this.timestamp,
      final Map<String, double> location = const {},
      this.message,
      this.photoUrl})
      : _location = location;

  factory _$DeliveryStatusUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryStatusUpdateImplFromJson(json);

  @override
  final String id;
  @override
  final String status;
  @override
  final DateTime timestamp;
  final Map<String, double> _location;
  @override
  @JsonKey()
  Map<String, double> get location {
    if (_location is EqualUnmodifiableMapView) return _location;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_location);
  }

  @override
  final String? message;
  @override
  final String? photoUrl;

  @override
  String toString() {
    return 'DeliveryStatusUpdate(id: $id, status: $status, timestamp: $timestamp, location: $location, message: $message, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryStatusUpdateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._location, _location) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, status, timestamp,
      const DeepCollectionEquality().hash(_location), message, photoUrl);

  /// Create a copy of DeliveryStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryStatusUpdateImplCopyWith<_$DeliveryStatusUpdateImpl>
      get copyWith =>
          __$$DeliveryStatusUpdateImplCopyWithImpl<_$DeliveryStatusUpdateImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DeliveryStatusUpdate value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DeliveryStatusUpdate value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DeliveryStatusUpdate value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryStatusUpdateImplToJson(
      this,
    );
  }
}

abstract class _DeliveryStatusUpdate implements DeliveryStatusUpdate {
  const factory _DeliveryStatusUpdate(
      {required final String id,
      required final String status,
      required final DateTime timestamp,
      final Map<String, double> location,
      final String? message,
      final String? photoUrl}) = _$DeliveryStatusUpdateImpl;

  factory _DeliveryStatusUpdate.fromJson(Map<String, dynamic> json) =
      _$DeliveryStatusUpdateImpl.fromJson;

  @override
  String get id;
  @override
  String get status;
  @override
  DateTime get timestamp;
  @override
  Map<String, double> get location;
  @override
  String? get message;
  @override
  String? get photoUrl;

  /// Create a copy of DeliveryStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryStatusUpdateImplCopyWith<_$DeliveryStatusUpdateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PaymentInfo _$PaymentInfoFromJson(Map<String, dynamic> json) {
  return _PaymentInfo.fromJson(json);
}

/// @nodoc
mixin _$PaymentInfo {
  String get orderId => throw _privateConstructorUsedError;
  String get paymentId => throw _privateConstructorUsedError;
  String get method =>
      throw _privateConstructorUsedError; // alipay, wechat, card, cash
  String get status =>
      throw _privateConstructorUsedError; // pending, processing, paid, failed, refunded
// 金额信息
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  double get refundedAmount => throw _privateConstructorUsedError; // 时间信息
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;
  DateTime? get refundedAt => throw _privateConstructorUsedError; // 第三方支付信息
  String? get transactionId => throw _privateConstructorUsedError;
  String? get platformPaymentId => throw _privateConstructorUsedError;
  Map<String, dynamic> get platformResponse =>
      throw _privateConstructorUsedError; // 退款信息
  String? get refundReason => throw _privateConstructorUsedError;
  List<RefundRecord> get refundHistory =>
      throw _privateConstructorUsedError; // 发票信息
  bool? get needInvoice => throw _privateConstructorUsedError;
  String? get invoiceTitle => throw _privateConstructorUsedError;
  String? get invoiceType =>
      throw _privateConstructorUsedError; // personal, company
  String? get invoiceTaxId => throw _privateConstructorUsedError;
  String? get invoiceEmail => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PaymentInfo value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PaymentInfo value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PaymentInfo value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this PaymentInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentInfoCopyWith<PaymentInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentInfoCopyWith<$Res> {
  factory $PaymentInfoCopyWith(
          PaymentInfo value, $Res Function(PaymentInfo) then) =
      _$PaymentInfoCopyWithImpl<$Res, PaymentInfo>;
  @useResult
  $Res call(
      {String orderId,
      String paymentId,
      String method,
      String status,
      double amount,
      String currency,
      double refundedAmount,
      DateTime createdAt,
      DateTime? paidAt,
      DateTime? refundedAt,
      String? transactionId,
      String? platformPaymentId,
      Map<String, dynamic> platformResponse,
      String? refundReason,
      List<RefundRecord> refundHistory,
      bool? needInvoice,
      String? invoiceTitle,
      String? invoiceType,
      String? invoiceTaxId,
      String? invoiceEmail});
}

/// @nodoc
class _$PaymentInfoCopyWithImpl<$Res, $Val extends PaymentInfo>
    implements $PaymentInfoCopyWith<$Res> {
  _$PaymentInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? paymentId = null,
    Object? method = null,
    Object? status = null,
    Object? amount = null,
    Object? currency = null,
    Object? refundedAmount = null,
    Object? createdAt = null,
    Object? paidAt = freezed,
    Object? refundedAt = freezed,
    Object? transactionId = freezed,
    Object? platformPaymentId = freezed,
    Object? platformResponse = null,
    Object? refundReason = freezed,
    Object? refundHistory = null,
    Object? needInvoice = freezed,
    Object? invoiceTitle = freezed,
    Object? invoiceType = freezed,
    Object? invoiceTaxId = freezed,
    Object? invoiceEmail = freezed,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentId: null == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      refundedAmount: null == refundedAmount
          ? _value.refundedAmount
          : refundedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      refundedAt: freezed == refundedAt
          ? _value.refundedAt
          : refundedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      platformPaymentId: freezed == platformPaymentId
          ? _value.platformPaymentId
          : platformPaymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      platformResponse: null == platformResponse
          ? _value.platformResponse
          : platformResponse // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      refundReason: freezed == refundReason
          ? _value.refundReason
          : refundReason // ignore: cast_nullable_to_non_nullable
              as String?,
      refundHistory: null == refundHistory
          ? _value.refundHistory
          : refundHistory // ignore: cast_nullable_to_non_nullable
              as List<RefundRecord>,
      needInvoice: freezed == needInvoice
          ? _value.needInvoice
          : needInvoice // ignore: cast_nullable_to_non_nullable
              as bool?,
      invoiceTitle: freezed == invoiceTitle
          ? _value.invoiceTitle
          : invoiceTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceType: freezed == invoiceType
          ? _value.invoiceType
          : invoiceType // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceTaxId: freezed == invoiceTaxId
          ? _value.invoiceTaxId
          : invoiceTaxId // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceEmail: freezed == invoiceEmail
          ? _value.invoiceEmail
          : invoiceEmail // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentInfoImplCopyWith<$Res>
    implements $PaymentInfoCopyWith<$Res> {
  factory _$$PaymentInfoImplCopyWith(
          _$PaymentInfoImpl value, $Res Function(_$PaymentInfoImpl) then) =
      __$$PaymentInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String orderId,
      String paymentId,
      String method,
      String status,
      double amount,
      String currency,
      double refundedAmount,
      DateTime createdAt,
      DateTime? paidAt,
      DateTime? refundedAt,
      String? transactionId,
      String? platformPaymentId,
      Map<String, dynamic> platformResponse,
      String? refundReason,
      List<RefundRecord> refundHistory,
      bool? needInvoice,
      String? invoiceTitle,
      String? invoiceType,
      String? invoiceTaxId,
      String? invoiceEmail});
}

/// @nodoc
class __$$PaymentInfoImplCopyWithImpl<$Res>
    extends _$PaymentInfoCopyWithImpl<$Res, _$PaymentInfoImpl>
    implements _$$PaymentInfoImplCopyWith<$Res> {
  __$$PaymentInfoImplCopyWithImpl(
      _$PaymentInfoImpl _value, $Res Function(_$PaymentInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? paymentId = null,
    Object? method = null,
    Object? status = null,
    Object? amount = null,
    Object? currency = null,
    Object? refundedAmount = null,
    Object? createdAt = null,
    Object? paidAt = freezed,
    Object? refundedAt = freezed,
    Object? transactionId = freezed,
    Object? platformPaymentId = freezed,
    Object? platformResponse = null,
    Object? refundReason = freezed,
    Object? refundHistory = null,
    Object? needInvoice = freezed,
    Object? invoiceTitle = freezed,
    Object? invoiceType = freezed,
    Object? invoiceTaxId = freezed,
    Object? invoiceEmail = freezed,
  }) {
    return _then(_$PaymentInfoImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentId: null == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      refundedAmount: null == refundedAmount
          ? _value.refundedAmount
          : refundedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      refundedAt: freezed == refundedAt
          ? _value.refundedAt
          : refundedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      platformPaymentId: freezed == platformPaymentId
          ? _value.platformPaymentId
          : platformPaymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      platformResponse: null == platformResponse
          ? _value._platformResponse
          : platformResponse // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      refundReason: freezed == refundReason
          ? _value.refundReason
          : refundReason // ignore: cast_nullable_to_non_nullable
              as String?,
      refundHistory: null == refundHistory
          ? _value._refundHistory
          : refundHistory // ignore: cast_nullable_to_non_nullable
              as List<RefundRecord>,
      needInvoice: freezed == needInvoice
          ? _value.needInvoice
          : needInvoice // ignore: cast_nullable_to_non_nullable
              as bool?,
      invoiceTitle: freezed == invoiceTitle
          ? _value.invoiceTitle
          : invoiceTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceType: freezed == invoiceType
          ? _value.invoiceType
          : invoiceType // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceTaxId: freezed == invoiceTaxId
          ? _value.invoiceTaxId
          : invoiceTaxId // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceEmail: freezed == invoiceEmail
          ? _value.invoiceEmail
          : invoiceEmail // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentInfoImpl implements _PaymentInfo {
  const _$PaymentInfoImpl(
      {required this.orderId,
      required this.paymentId,
      required this.method,
      required this.status,
      required this.amount,
      required this.currency,
      this.refundedAmount = 0.0,
      required this.createdAt,
      this.paidAt,
      this.refundedAt,
      this.transactionId,
      this.platformPaymentId,
      final Map<String, dynamic> platformResponse = const {},
      this.refundReason,
      final List<RefundRecord> refundHistory = const [],
      this.needInvoice,
      this.invoiceTitle,
      this.invoiceType,
      this.invoiceTaxId,
      this.invoiceEmail})
      : _platformResponse = platformResponse,
        _refundHistory = refundHistory;

  factory _$PaymentInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentInfoImplFromJson(json);

  @override
  final String orderId;
  @override
  final String paymentId;
  @override
  final String method;
// alipay, wechat, card, cash
  @override
  final String status;
// pending, processing, paid, failed, refunded
// 金额信息
  @override
  final double amount;
  @override
  final String currency;
  @override
  @JsonKey()
  final double refundedAmount;
// 时间信息
  @override
  final DateTime createdAt;
  @override
  final DateTime? paidAt;
  @override
  final DateTime? refundedAt;
// 第三方支付信息
  @override
  final String? transactionId;
  @override
  final String? platformPaymentId;
  final Map<String, dynamic> _platformResponse;
  @override
  @JsonKey()
  Map<String, dynamic> get platformResponse {
    if (_platformResponse is EqualUnmodifiableMapView) return _platformResponse;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_platformResponse);
  }

// 退款信息
  @override
  final String? refundReason;
  final List<RefundRecord> _refundHistory;
  @override
  @JsonKey()
  List<RefundRecord> get refundHistory {
    if (_refundHistory is EqualUnmodifiableListView) return _refundHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_refundHistory);
  }

// 发票信息
  @override
  final bool? needInvoice;
  @override
  final String? invoiceTitle;
  @override
  final String? invoiceType;
// personal, company
  @override
  final String? invoiceTaxId;
  @override
  final String? invoiceEmail;

  @override
  String toString() {
    return 'PaymentInfo(orderId: $orderId, paymentId: $paymentId, method: $method, status: $status, amount: $amount, currency: $currency, refundedAmount: $refundedAmount, createdAt: $createdAt, paidAt: $paidAt, refundedAt: $refundedAt, transactionId: $transactionId, platformPaymentId: $platformPaymentId, platformResponse: $platformResponse, refundReason: $refundReason, refundHistory: $refundHistory, needInvoice: $needInvoice, invoiceTitle: $invoiceTitle, invoiceType: $invoiceType, invoiceTaxId: $invoiceTaxId, invoiceEmail: $invoiceEmail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentInfoImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.refundedAmount, refundedAmount) ||
                other.refundedAmount == refundedAmount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.refundedAt, refundedAt) ||
                other.refundedAt == refundedAt) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.platformPaymentId, platformPaymentId) ||
                other.platformPaymentId == platformPaymentId) &&
            const DeepCollectionEquality()
                .equals(other._platformResponse, _platformResponse) &&
            (identical(other.refundReason, refundReason) ||
                other.refundReason == refundReason) &&
            const DeepCollectionEquality()
                .equals(other._refundHistory, _refundHistory) &&
            (identical(other.needInvoice, needInvoice) ||
                other.needInvoice == needInvoice) &&
            (identical(other.invoiceTitle, invoiceTitle) ||
                other.invoiceTitle == invoiceTitle) &&
            (identical(other.invoiceType, invoiceType) ||
                other.invoiceType == invoiceType) &&
            (identical(other.invoiceTaxId, invoiceTaxId) ||
                other.invoiceTaxId == invoiceTaxId) &&
            (identical(other.invoiceEmail, invoiceEmail) ||
                other.invoiceEmail == invoiceEmail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        orderId,
        paymentId,
        method,
        status,
        amount,
        currency,
        refundedAmount,
        createdAt,
        paidAt,
        refundedAt,
        transactionId,
        platformPaymentId,
        const DeepCollectionEquality().hash(_platformResponse),
        refundReason,
        const DeepCollectionEquality().hash(_refundHistory),
        needInvoice,
        invoiceTitle,
        invoiceType,
        invoiceTaxId,
        invoiceEmail
      ]);

  /// Create a copy of PaymentInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentInfoImplCopyWith<_$PaymentInfoImpl> get copyWith =>
      __$$PaymentInfoImplCopyWithImpl<_$PaymentInfoImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PaymentInfo value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PaymentInfo value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PaymentInfo value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentInfoImplToJson(
      this,
    );
  }
}

abstract class _PaymentInfo implements PaymentInfo {
  const factory _PaymentInfo(
      {required final String orderId,
      required final String paymentId,
      required final String method,
      required final String status,
      required final double amount,
      required final String currency,
      final double refundedAmount,
      required final DateTime createdAt,
      final DateTime? paidAt,
      final DateTime? refundedAt,
      final String? transactionId,
      final String? platformPaymentId,
      final Map<String, dynamic> platformResponse,
      final String? refundReason,
      final List<RefundRecord> refundHistory,
      final bool? needInvoice,
      final String? invoiceTitle,
      final String? invoiceType,
      final String? invoiceTaxId,
      final String? invoiceEmail}) = _$PaymentInfoImpl;

  factory _PaymentInfo.fromJson(Map<String, dynamic> json) =
      _$PaymentInfoImpl.fromJson;

  @override
  String get orderId;
  @override
  String get paymentId;
  @override
  String get method; // alipay, wechat, card, cash
  @override
  String get status; // pending, processing, paid, failed, refunded
// 金额信息
  @override
  double get amount;
  @override
  String get currency;
  @override
  double get refundedAmount; // 时间信息
  @override
  DateTime get createdAt;
  @override
  DateTime? get paidAt;
  @override
  DateTime? get refundedAt; // 第三方支付信息
  @override
  String? get transactionId;
  @override
  String? get platformPaymentId;
  @override
  Map<String, dynamic> get platformResponse; // 退款信息
  @override
  String? get refundReason;
  @override
  List<RefundRecord> get refundHistory; // 发票信息
  @override
  bool? get needInvoice;
  @override
  String? get invoiceTitle;
  @override
  String? get invoiceType; // personal, company
  @override
  String? get invoiceTaxId;
  @override
  String? get invoiceEmail;

  /// Create a copy of PaymentInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentInfoImplCopyWith<_$PaymentInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RefundRecord _$RefundRecordFromJson(Map<String, dynamic> json) {
  return _RefundRecord.fromJson(json);
}

/// @nodoc
mixin _$RefundRecord {
  String get id => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // pending, processed, failed
  String? get operatorId => throw _privateConstructorUsedError;
  String? get platformRefundId => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RefundRecord value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RefundRecord value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RefundRecord value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this RefundRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefundRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefundRecordCopyWith<RefundRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefundRecordCopyWith<$Res> {
  factory $RefundRecordCopyWith(
          RefundRecord value, $Res Function(RefundRecord) then) =
      _$RefundRecordCopyWithImpl<$Res, RefundRecord>;
  @useResult
  $Res call(
      {String id,
      double amount,
      String reason,
      DateTime timestamp,
      String status,
      String? operatorId,
      String? platformRefundId});
}

/// @nodoc
class _$RefundRecordCopyWithImpl<$Res, $Val extends RefundRecord>
    implements $RefundRecordCopyWith<$Res> {
  _$RefundRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefundRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? reason = null,
    Object? timestamp = null,
    Object? status = null,
    Object? operatorId = freezed,
    Object? platformRefundId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      operatorId: freezed == operatorId
          ? _value.operatorId
          : operatorId // ignore: cast_nullable_to_non_nullable
              as String?,
      platformRefundId: freezed == platformRefundId
          ? _value.platformRefundId
          : platformRefundId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefundRecordImplCopyWith<$Res>
    implements $RefundRecordCopyWith<$Res> {
  factory _$$RefundRecordImplCopyWith(
          _$RefundRecordImpl value, $Res Function(_$RefundRecordImpl) then) =
      __$$RefundRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      double amount,
      String reason,
      DateTime timestamp,
      String status,
      String? operatorId,
      String? platformRefundId});
}

/// @nodoc
class __$$RefundRecordImplCopyWithImpl<$Res>
    extends _$RefundRecordCopyWithImpl<$Res, _$RefundRecordImpl>
    implements _$$RefundRecordImplCopyWith<$Res> {
  __$$RefundRecordImplCopyWithImpl(
      _$RefundRecordImpl _value, $Res Function(_$RefundRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of RefundRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? reason = null,
    Object? timestamp = null,
    Object? status = null,
    Object? operatorId = freezed,
    Object? platformRefundId = freezed,
  }) {
    return _then(_$RefundRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      operatorId: freezed == operatorId
          ? _value.operatorId
          : operatorId // ignore: cast_nullable_to_non_nullable
              as String?,
      platformRefundId: freezed == platformRefundId
          ? _value.platformRefundId
          : platformRefundId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefundRecordImpl implements _RefundRecord {
  const _$RefundRecordImpl(
      {required this.id,
      required this.amount,
      required this.reason,
      required this.timestamp,
      required this.status,
      this.operatorId,
      this.platformRefundId});

  factory _$RefundRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefundRecordImplFromJson(json);

  @override
  final String id;
  @override
  final double amount;
  @override
  final String reason;
  @override
  final DateTime timestamp;
  @override
  final String status;
// pending, processed, failed
  @override
  final String? operatorId;
  @override
  final String? platformRefundId;

  @override
  String toString() {
    return 'RefundRecord(id: $id, amount: $amount, reason: $reason, timestamp: $timestamp, status: $status, operatorId: $operatorId, platformRefundId: $platformRefundId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefundRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.operatorId, operatorId) ||
                other.operatorId == operatorId) &&
            (identical(other.platformRefundId, platformRefundId) ||
                other.platformRefundId == platformRefundId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, amount, reason, timestamp,
      status, operatorId, platformRefundId);

  /// Create a copy of RefundRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefundRecordImplCopyWith<_$RefundRecordImpl> get copyWith =>
      __$$RefundRecordImplCopyWithImpl<_$RefundRecordImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RefundRecord value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RefundRecord value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RefundRecord value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RefundRecordImplToJson(
      this,
    );
  }
}

abstract class _RefundRecord implements RefundRecord {
  const factory _RefundRecord(
      {required final String id,
      required final double amount,
      required final String reason,
      required final DateTime timestamp,
      required final String status,
      final String? operatorId,
      final String? platformRefundId}) = _$RefundRecordImpl;

  factory _RefundRecord.fromJson(Map<String, dynamic> json) =
      _$RefundRecordImpl.fromJson;

  @override
  String get id;
  @override
  double get amount;
  @override
  String get reason;
  @override
  DateTime get timestamp;
  @override
  String get status; // pending, processed, failed
  @override
  String? get operatorId;
  @override
  String? get platformRefundId;

  /// Create a copy of RefundRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefundRecordImplCopyWith<_$RefundRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderReview _$OrderReviewFromJson(Map<String, dynamic> json) {
  return _OrderReview.fromJson(json);
}

/// @nodoc
mixin _$OrderReview {
  String get orderId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError; // 评分
  double get overallRating => throw _privateConstructorUsedError; // 1-5
  double get foodQualityRating => throw _privateConstructorUsedError;
  double get deliveryRating => throw _privateConstructorUsedError;
  double get serviceRating => throw _privateConstructorUsedError;
  double get nutritionSatisfactionRating =>
      throw _privateConstructorUsedError; // 营养满意度
// 评价内容
  String? get comment => throw _privateConstructorUsedError;
  List<String> get tags =>
      throw _privateConstructorUsedError; // 快速标签：delicious, fresh, on-time等
  List<String> get photos => throw _privateConstructorUsedError; // 营养反馈
  Map<String, double> get nutritionFeedback =>
      throw _privateConstructorUsedError; // 各营养元素满意度
  List<String> get nutritionComments => throw _privateConstructorUsedError;
  bool? get achievedNutritionGoals =>
      throw _privateConstructorUsedError; // 商家反馈
  Map<String, double> get merchantRatings =>
      throw _privateConstructorUsedError; // 按商家ID的评分
  Map<String, String> get merchantComments =>
      throw _privateConstructorUsedError; // 改进建议
  List<String> get improvementSuggestions => throw _privateConstructorUsedError;
  List<String> get wouldRecommendReasons => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError; // 系统信息
  bool get isVerified => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  int get helpfulVotes => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderReview value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderReview value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderReview value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderReview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderReview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderReviewCopyWith<OrderReview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderReviewCopyWith<$Res> {
  factory $OrderReviewCopyWith(
          OrderReview value, $Res Function(OrderReview) then) =
      _$OrderReviewCopyWithImpl<$Res, OrderReview>;
  @useResult
  $Res call(
      {String orderId,
      String userId,
      double overallRating,
      double foodQualityRating,
      double deliveryRating,
      double serviceRating,
      double nutritionSatisfactionRating,
      String? comment,
      List<String> tags,
      List<String> photos,
      Map<String, double> nutritionFeedback,
      List<String> nutritionComments,
      bool? achievedNutritionGoals,
      Map<String, double> merchantRatings,
      Map<String, String> merchantComments,
      List<String> improvementSuggestions,
      List<String> wouldRecommendReasons,
      DateTime createdAt,
      DateTime? updatedAt,
      bool isVerified,
      bool isPublic,
      int helpfulVotes});
}

/// @nodoc
class _$OrderReviewCopyWithImpl<$Res, $Val extends OrderReview>
    implements $OrderReviewCopyWith<$Res> {
  _$OrderReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderReview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? userId = null,
    Object? overallRating = null,
    Object? foodQualityRating = null,
    Object? deliveryRating = null,
    Object? serviceRating = null,
    Object? nutritionSatisfactionRating = null,
    Object? comment = freezed,
    Object? tags = null,
    Object? photos = null,
    Object? nutritionFeedback = null,
    Object? nutritionComments = null,
    Object? achievedNutritionGoals = freezed,
    Object? merchantRatings = null,
    Object? merchantComments = null,
    Object? improvementSuggestions = null,
    Object? wouldRecommendReasons = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isVerified = null,
    Object? isPublic = null,
    Object? helpfulVotes = null,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      overallRating: null == overallRating
          ? _value.overallRating
          : overallRating // ignore: cast_nullable_to_non_nullable
              as double,
      foodQualityRating: null == foodQualityRating
          ? _value.foodQualityRating
          : foodQualityRating // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryRating: null == deliveryRating
          ? _value.deliveryRating
          : deliveryRating // ignore: cast_nullable_to_non_nullable
              as double,
      serviceRating: null == serviceRating
          ? _value.serviceRating
          : serviceRating // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionSatisfactionRating: null == nutritionSatisfactionRating
          ? _value.nutritionSatisfactionRating
          : nutritionSatisfactionRating // ignore: cast_nullable_to_non_nullable
              as double,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      photos: null == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionFeedback: null == nutritionFeedback
          ? _value.nutritionFeedback
          : nutritionFeedback // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      nutritionComments: null == nutritionComments
          ? _value.nutritionComments
          : nutritionComments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      achievedNutritionGoals: freezed == achievedNutritionGoals
          ? _value.achievedNutritionGoals
          : achievedNutritionGoals // ignore: cast_nullable_to_non_nullable
              as bool?,
      merchantRatings: null == merchantRatings
          ? _value.merchantRatings
          : merchantRatings // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      merchantComments: null == merchantComments
          ? _value.merchantComments
          : merchantComments // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      improvementSuggestions: null == improvementSuggestions
          ? _value.improvementSuggestions
          : improvementSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      wouldRecommendReasons: null == wouldRecommendReasons
          ? _value.wouldRecommendReasons
          : wouldRecommendReasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      helpfulVotes: null == helpfulVotes
          ? _value.helpfulVotes
          : helpfulVotes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderReviewImplCopyWith<$Res>
    implements $OrderReviewCopyWith<$Res> {
  factory _$$OrderReviewImplCopyWith(
          _$OrderReviewImpl value, $Res Function(_$OrderReviewImpl) then) =
      __$$OrderReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String orderId,
      String userId,
      double overallRating,
      double foodQualityRating,
      double deliveryRating,
      double serviceRating,
      double nutritionSatisfactionRating,
      String? comment,
      List<String> tags,
      List<String> photos,
      Map<String, double> nutritionFeedback,
      List<String> nutritionComments,
      bool? achievedNutritionGoals,
      Map<String, double> merchantRatings,
      Map<String, String> merchantComments,
      List<String> improvementSuggestions,
      List<String> wouldRecommendReasons,
      DateTime createdAt,
      DateTime? updatedAt,
      bool isVerified,
      bool isPublic,
      int helpfulVotes});
}

/// @nodoc
class __$$OrderReviewImplCopyWithImpl<$Res>
    extends _$OrderReviewCopyWithImpl<$Res, _$OrderReviewImpl>
    implements _$$OrderReviewImplCopyWith<$Res> {
  __$$OrderReviewImplCopyWithImpl(
      _$OrderReviewImpl _value, $Res Function(_$OrderReviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderReview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? userId = null,
    Object? overallRating = null,
    Object? foodQualityRating = null,
    Object? deliveryRating = null,
    Object? serviceRating = null,
    Object? nutritionSatisfactionRating = null,
    Object? comment = freezed,
    Object? tags = null,
    Object? photos = null,
    Object? nutritionFeedback = null,
    Object? nutritionComments = null,
    Object? achievedNutritionGoals = freezed,
    Object? merchantRatings = null,
    Object? merchantComments = null,
    Object? improvementSuggestions = null,
    Object? wouldRecommendReasons = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isVerified = null,
    Object? isPublic = null,
    Object? helpfulVotes = null,
  }) {
    return _then(_$OrderReviewImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      overallRating: null == overallRating
          ? _value.overallRating
          : overallRating // ignore: cast_nullable_to_non_nullable
              as double,
      foodQualityRating: null == foodQualityRating
          ? _value.foodQualityRating
          : foodQualityRating // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryRating: null == deliveryRating
          ? _value.deliveryRating
          : deliveryRating // ignore: cast_nullable_to_non_nullable
              as double,
      serviceRating: null == serviceRating
          ? _value.serviceRating
          : serviceRating // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionSatisfactionRating: null == nutritionSatisfactionRating
          ? _value.nutritionSatisfactionRating
          : nutritionSatisfactionRating // ignore: cast_nullable_to_non_nullable
              as double,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      photos: null == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionFeedback: null == nutritionFeedback
          ? _value._nutritionFeedback
          : nutritionFeedback // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      nutritionComments: null == nutritionComments
          ? _value._nutritionComments
          : nutritionComments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      achievedNutritionGoals: freezed == achievedNutritionGoals
          ? _value.achievedNutritionGoals
          : achievedNutritionGoals // ignore: cast_nullable_to_non_nullable
              as bool?,
      merchantRatings: null == merchantRatings
          ? _value._merchantRatings
          : merchantRatings // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      merchantComments: null == merchantComments
          ? _value._merchantComments
          : merchantComments // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      improvementSuggestions: null == improvementSuggestions
          ? _value._improvementSuggestions
          : improvementSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      wouldRecommendReasons: null == wouldRecommendReasons
          ? _value._wouldRecommendReasons
          : wouldRecommendReasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      helpfulVotes: null == helpfulVotes
          ? _value.helpfulVotes
          : helpfulVotes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderReviewImpl implements _OrderReview {
  const _$OrderReviewImpl(
      {required this.orderId,
      required this.userId,
      required this.overallRating,
      required this.foodQualityRating,
      required this.deliveryRating,
      required this.serviceRating,
      this.nutritionSatisfactionRating = 0.0,
      this.comment,
      final List<String> tags = const [],
      final List<String> photos = const [],
      final Map<String, double> nutritionFeedback = const {},
      final List<String> nutritionComments = const [],
      this.achievedNutritionGoals,
      final Map<String, double> merchantRatings = const {},
      final Map<String, String> merchantComments = const {},
      final List<String> improvementSuggestions = const [],
      final List<String> wouldRecommendReasons = const [],
      required this.createdAt,
      this.updatedAt,
      this.isVerified = false,
      this.isPublic = false,
      this.helpfulVotes = 0})
      : _tags = tags,
        _photos = photos,
        _nutritionFeedback = nutritionFeedback,
        _nutritionComments = nutritionComments,
        _merchantRatings = merchantRatings,
        _merchantComments = merchantComments,
        _improvementSuggestions = improvementSuggestions,
        _wouldRecommendReasons = wouldRecommendReasons;

  factory _$OrderReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderReviewImplFromJson(json);

  @override
  final String orderId;
  @override
  final String userId;
// 评分
  @override
  final double overallRating;
// 1-5
  @override
  final double foodQualityRating;
  @override
  final double deliveryRating;
  @override
  final double serviceRating;
  @override
  @JsonKey()
  final double nutritionSatisfactionRating;
// 营养满意度
// 评价内容
  @override
  final String? comment;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

// 快速标签：delicious, fresh, on-time等
  final List<String> _photos;
// 快速标签：delicious, fresh, on-time等
  @override
  @JsonKey()
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

// 营养反馈
  final Map<String, double> _nutritionFeedback;
// 营养反馈
  @override
  @JsonKey()
  Map<String, double> get nutritionFeedback {
    if (_nutritionFeedback is EqualUnmodifiableMapView)
      return _nutritionFeedback;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionFeedback);
  }

// 各营养元素满意度
  final List<String> _nutritionComments;
// 各营养元素满意度
  @override
  @JsonKey()
  List<String> get nutritionComments {
    if (_nutritionComments is EqualUnmodifiableListView)
      return _nutritionComments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionComments);
  }

  @override
  final bool? achievedNutritionGoals;
// 商家反馈
  final Map<String, double> _merchantRatings;
// 商家反馈
  @override
  @JsonKey()
  Map<String, double> get merchantRatings {
    if (_merchantRatings is EqualUnmodifiableMapView) return _merchantRatings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_merchantRatings);
  }

// 按商家ID的评分
  final Map<String, String> _merchantComments;
// 按商家ID的评分
  @override
  @JsonKey()
  Map<String, String> get merchantComments {
    if (_merchantComments is EqualUnmodifiableMapView) return _merchantComments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_merchantComments);
  }

// 改进建议
  final List<String> _improvementSuggestions;
// 改进建议
  @override
  @JsonKey()
  List<String> get improvementSuggestions {
    if (_improvementSuggestions is EqualUnmodifiableListView)
      return _improvementSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_improvementSuggestions);
  }

  final List<String> _wouldRecommendReasons;
  @override
  @JsonKey()
  List<String> get wouldRecommendReasons {
    if (_wouldRecommendReasons is EqualUnmodifiableListView)
      return _wouldRecommendReasons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_wouldRecommendReasons);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
// 系统信息
  @override
  @JsonKey()
  final bool isVerified;
  @override
  @JsonKey()
  final bool isPublic;
  @override
  @JsonKey()
  final int helpfulVotes;

  @override
  String toString() {
    return 'OrderReview(orderId: $orderId, userId: $userId, overallRating: $overallRating, foodQualityRating: $foodQualityRating, deliveryRating: $deliveryRating, serviceRating: $serviceRating, nutritionSatisfactionRating: $nutritionSatisfactionRating, comment: $comment, tags: $tags, photos: $photos, nutritionFeedback: $nutritionFeedback, nutritionComments: $nutritionComments, achievedNutritionGoals: $achievedNutritionGoals, merchantRatings: $merchantRatings, merchantComments: $merchantComments, improvementSuggestions: $improvementSuggestions, wouldRecommendReasons: $wouldRecommendReasons, createdAt: $createdAt, updatedAt: $updatedAt, isVerified: $isVerified, isPublic: $isPublic, helpfulVotes: $helpfulVotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderReviewImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.overallRating, overallRating) ||
                other.overallRating == overallRating) &&
            (identical(other.foodQualityRating, foodQualityRating) ||
                other.foodQualityRating == foodQualityRating) &&
            (identical(other.deliveryRating, deliveryRating) ||
                other.deliveryRating == deliveryRating) &&
            (identical(other.serviceRating, serviceRating) ||
                other.serviceRating == serviceRating) &&
            (identical(other.nutritionSatisfactionRating,
                    nutritionSatisfactionRating) ||
                other.nutritionSatisfactionRating ==
                    nutritionSatisfactionRating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            const DeepCollectionEquality()
                .equals(other._nutritionFeedback, _nutritionFeedback) &&
            const DeepCollectionEquality()
                .equals(other._nutritionComments, _nutritionComments) &&
            (identical(other.achievedNutritionGoals, achievedNutritionGoals) ||
                other.achievedNutritionGoals == achievedNutritionGoals) &&
            const DeepCollectionEquality()
                .equals(other._merchantRatings, _merchantRatings) &&
            const DeepCollectionEquality()
                .equals(other._merchantComments, _merchantComments) &&
            const DeepCollectionEquality().equals(
                other._improvementSuggestions, _improvementSuggestions) &&
            const DeepCollectionEquality()
                .equals(other._wouldRecommendReasons, _wouldRecommendReasons) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.helpfulVotes, helpfulVotes) ||
                other.helpfulVotes == helpfulVotes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        orderId,
        userId,
        overallRating,
        foodQualityRating,
        deliveryRating,
        serviceRating,
        nutritionSatisfactionRating,
        comment,
        const DeepCollectionEquality().hash(_tags),
        const DeepCollectionEquality().hash(_photos),
        const DeepCollectionEquality().hash(_nutritionFeedback),
        const DeepCollectionEquality().hash(_nutritionComments),
        achievedNutritionGoals,
        const DeepCollectionEquality().hash(_merchantRatings),
        const DeepCollectionEquality().hash(_merchantComments),
        const DeepCollectionEquality().hash(_improvementSuggestions),
        const DeepCollectionEquality().hash(_wouldRecommendReasons),
        createdAt,
        updatedAt,
        isVerified,
        isPublic,
        helpfulVotes
      ]);

  /// Create a copy of OrderReview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderReviewImplCopyWith<_$OrderReviewImpl> get copyWith =>
      __$$OrderReviewImplCopyWithImpl<_$OrderReviewImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderReview value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderReview value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderReview value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderReviewImplToJson(
      this,
    );
  }
}

abstract class _OrderReview implements OrderReview {
  const factory _OrderReview(
      {required final String orderId,
      required final String userId,
      required final double overallRating,
      required final double foodQualityRating,
      required final double deliveryRating,
      required final double serviceRating,
      final double nutritionSatisfactionRating,
      final String? comment,
      final List<String> tags,
      final List<String> photos,
      final Map<String, double> nutritionFeedback,
      final List<String> nutritionComments,
      final bool? achievedNutritionGoals,
      final Map<String, double> merchantRatings,
      final Map<String, String> merchantComments,
      final List<String> improvementSuggestions,
      final List<String> wouldRecommendReasons,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final bool isVerified,
      final bool isPublic,
      final int helpfulVotes}) = _$OrderReviewImpl;

  factory _OrderReview.fromJson(Map<String, dynamic> json) =
      _$OrderReviewImpl.fromJson;

  @override
  String get orderId;
  @override
  String get userId; // 评分
  @override
  double get overallRating; // 1-5
  @override
  double get foodQualityRating;
  @override
  double get deliveryRating;
  @override
  double get serviceRating;
  @override
  double get nutritionSatisfactionRating; // 营养满意度
// 评价内容
  @override
  String? get comment;
  @override
  List<String> get tags; // 快速标签：delicious, fresh, on-time等
  @override
  List<String> get photos; // 营养反馈
  @override
  Map<String, double> get nutritionFeedback; // 各营养元素满意度
  @override
  List<String> get nutritionComments;
  @override
  bool? get achievedNutritionGoals; // 商家反馈
  @override
  Map<String, double> get merchantRatings; // 按商家ID的评分
  @override
  Map<String, String> get merchantComments; // 改进建议
  @override
  List<String> get improvementSuggestions;
  @override
  List<String> get wouldRecommendReasons;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt; // 系统信息
  @override
  bool get isVerified;
  @override
  bool get isPublic;
  @override
  int get helpfulVotes;

  /// Create a copy of OrderReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderReviewImplCopyWith<_$OrderReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
