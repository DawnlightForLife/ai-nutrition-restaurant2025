// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get merchantId => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;
  OrderStatus get status => throw _privateConstructorUsedError;
  OrderType get orderType => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get actualAmount => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  PaymentStatus get paymentStatus => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  List<OrderItemModel> get items => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String get customerPhone => throw _privateConstructorUsedError;
  String get deliveryAddress => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  String get cancelReason => throw _privateConstructorUsedError;
  DateTime? get estimatedPrepTime => throw _privateConstructorUsedError;
  DateTime? get actualPrepTime => throw _privateConstructorUsedError;
  DateTime? get estimatedDeliveryTime => throw _privateConstructorUsedError;
  DateTime? get actualDeliveryTime => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) then) =
      _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String orderNumber,
      String userId,
      String merchantId,
      String storeId,
      OrderStatus status,
      OrderType orderType,
      double totalAmount,
      double actualAmount,
      double discountAmount,
      PaymentStatus paymentStatus,
      String paymentMethod,
      List<OrderItemModel> items,
      String customerName,
      String customerPhone,
      String deliveryAddress,
      String notes,
      String cancelReason,
      DateTime? estimatedPrepTime,
      DateTime? actualPrepTime,
      DateTime? estimatedDeliveryTime,
      DateTime? actualDeliveryTime,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? userId = null,
    Object? merchantId = null,
    Object? storeId = null,
    Object? status = null,
    Object? orderType = null,
    Object? totalAmount = null,
    Object? actualAmount = null,
    Object? discountAmount = null,
    Object? paymentStatus = null,
    Object? paymentMethod = null,
    Object? items = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? deliveryAddress = null,
    Object? notes = null,
    Object? cancelReason = null,
    Object? estimatedPrepTime = freezed,
    Object? actualPrepTime = freezed,
    Object? estimatedDeliveryTime = freezed,
    Object? actualDeliveryTime = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      orderType: null == orderType
          ? _value.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as OrderType,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      actualAmount: null == actualAmount
          ? _value.actualAmount
          : actualAmount // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: null == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryAddress: null == deliveryAddress
          ? _value.deliveryAddress
          : deliveryAddress // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      cancelReason: null == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedPrepTime: freezed == estimatedPrepTime
          ? _value.estimatedPrepTime
          : estimatedPrepTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualPrepTime: freezed == actualPrepTime
          ? _value.actualPrepTime
          : actualPrepTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedDeliveryTime: freezed == estimatedDeliveryTime
          ? _value.estimatedDeliveryTime
          : estimatedDeliveryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualDeliveryTime: freezed == actualDeliveryTime
          ? _value.actualDeliveryTime
          : actualDeliveryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
          _$OrderModelImpl value, $Res Function(_$OrderModelImpl) then) =
      __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String orderNumber,
      String userId,
      String merchantId,
      String storeId,
      OrderStatus status,
      OrderType orderType,
      double totalAmount,
      double actualAmount,
      double discountAmount,
      PaymentStatus paymentStatus,
      String paymentMethod,
      List<OrderItemModel> items,
      String customerName,
      String customerPhone,
      String deliveryAddress,
      String notes,
      String cancelReason,
      DateTime? estimatedPrepTime,
      DateTime? actualPrepTime,
      DateTime? estimatedDeliveryTime,
      DateTime? actualDeliveryTime,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
      _$OrderModelImpl _value, $Res Function(_$OrderModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? userId = null,
    Object? merchantId = null,
    Object? storeId = null,
    Object? status = null,
    Object? orderType = null,
    Object? totalAmount = null,
    Object? actualAmount = null,
    Object? discountAmount = null,
    Object? paymentStatus = null,
    Object? paymentMethod = null,
    Object? items = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? deliveryAddress = null,
    Object? notes = null,
    Object? cancelReason = null,
    Object? estimatedPrepTime = freezed,
    Object? actualPrepTime = freezed,
    Object? estimatedDeliveryTime = freezed,
    Object? actualDeliveryTime = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$OrderModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      orderType: null == orderType
          ? _value.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as OrderType,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      actualAmount: null == actualAmount
          ? _value.actualAmount
          : actualAmount // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: null == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryAddress: null == deliveryAddress
          ? _value.deliveryAddress
          : deliveryAddress // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      cancelReason: null == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedPrepTime: freezed == estimatedPrepTime
          ? _value.estimatedPrepTime
          : estimatedPrepTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualPrepTime: freezed == actualPrepTime
          ? _value.actualPrepTime
          : actualPrepTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedDeliveryTime: freezed == estimatedDeliveryTime
          ? _value.estimatedDeliveryTime
          : estimatedDeliveryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualDeliveryTime: freezed == actualDeliveryTime
          ? _value.actualDeliveryTime
          : actualDeliveryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$OrderModelImpl implements _OrderModel {
  const _$OrderModelImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.orderNumber,
      required this.userId,
      required this.merchantId,
      required this.storeId,
      required this.status,
      required this.orderType,
      required this.totalAmount,
      required this.actualAmount,
      this.discountAmount = 0.0,
      required this.paymentStatus,
      this.paymentMethod = '',
      required final List<OrderItemModel> items,
      this.customerName = '',
      this.customerPhone = '',
      this.deliveryAddress = '',
      this.notes = '',
      this.cancelReason = '',
      this.estimatedPrepTime,
      this.actualPrepTime,
      this.estimatedDeliveryTime,
      this.actualDeliveryTime,
      required this.createdAt,
      this.updatedAt})
      : _items = items;

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String orderNumber;
  @override
  final String userId;
  @override
  final String merchantId;
  @override
  final String storeId;
  @override
  final OrderStatus status;
  @override
  final OrderType orderType;
  @override
  final double totalAmount;
  @override
  final double actualAmount;
  @override
  @JsonKey()
  final double discountAmount;
  @override
  final PaymentStatus paymentStatus;
  @override
  @JsonKey()
  final String paymentMethod;
  final List<OrderItemModel> _items;
  @override
  List<OrderItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final String customerName;
  @override
  @JsonKey()
  final String customerPhone;
  @override
  @JsonKey()
  final String deliveryAddress;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final String cancelReason;
  @override
  final DateTime? estimatedPrepTime;
  @override
  final DateTime? actualPrepTime;
  @override
  final DateTime? estimatedDeliveryTime;
  @override
  final DateTime? actualDeliveryTime;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'OrderModel(id: $id, orderNumber: $orderNumber, userId: $userId, merchantId: $merchantId, storeId: $storeId, status: $status, orderType: $orderType, totalAmount: $totalAmount, actualAmount: $actualAmount, discountAmount: $discountAmount, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, items: $items, customerName: $customerName, customerPhone: $customerPhone, deliveryAddress: $deliveryAddress, notes: $notes, cancelReason: $cancelReason, estimatedPrepTime: $estimatedPrepTime, actualPrepTime: $actualPrepTime, estimatedDeliveryTime: $estimatedDeliveryTime, actualDeliveryTime: $actualDeliveryTime, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.actualAmount, actualAmount) ||
                other.actualAmount == actualAmount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.deliveryAddress, deliveryAddress) ||
                other.deliveryAddress == deliveryAddress) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.cancelReason, cancelReason) ||
                other.cancelReason == cancelReason) &&
            (identical(other.estimatedPrepTime, estimatedPrepTime) ||
                other.estimatedPrepTime == estimatedPrepTime) &&
            (identical(other.actualPrepTime, actualPrepTime) ||
                other.actualPrepTime == actualPrepTime) &&
            (identical(other.estimatedDeliveryTime, estimatedDeliveryTime) ||
                other.estimatedDeliveryTime == estimatedDeliveryTime) &&
            (identical(other.actualDeliveryTime, actualDeliveryTime) ||
                other.actualDeliveryTime == actualDeliveryTime) &&
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
        orderNumber,
        userId,
        merchantId,
        storeId,
        status,
        orderType,
        totalAmount,
        actualAmount,
        discountAmount,
        paymentStatus,
        paymentMethod,
        const DeepCollectionEquality().hash(_items),
        customerName,
        customerPhone,
        deliveryAddress,
        notes,
        cancelReason,
        estimatedPrepTime,
        actualPrepTime,
        estimatedDeliveryTime,
        actualDeliveryTime,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(
      this,
    );
  }
}

abstract class _OrderModel implements OrderModel {
  const factory _OrderModel(
      {@JsonKey(name: '_id') required final String id,
      required final String orderNumber,
      required final String userId,
      required final String merchantId,
      required final String storeId,
      required final OrderStatus status,
      required final OrderType orderType,
      required final double totalAmount,
      required final double actualAmount,
      final double discountAmount,
      required final PaymentStatus paymentStatus,
      final String paymentMethod,
      required final List<OrderItemModel> items,
      final String customerName,
      final String customerPhone,
      final String deliveryAddress,
      final String notes,
      final String cancelReason,
      final DateTime? estimatedPrepTime,
      final DateTime? actualPrepTime,
      final DateTime? estimatedDeliveryTime,
      final DateTime? actualDeliveryTime,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get orderNumber;
  @override
  String get userId;
  @override
  String get merchantId;
  @override
  String get storeId;
  @override
  OrderStatus get status;
  @override
  OrderType get orderType;
  @override
  double get totalAmount;
  @override
  double get actualAmount;
  @override
  double get discountAmount;
  @override
  PaymentStatus get paymentStatus;
  @override
  String get paymentMethod;
  @override
  List<OrderItemModel> get items;
  @override
  String get customerName;
  @override
  String get customerPhone;
  @override
  String get deliveryAddress;
  @override
  String get notes;
  @override
  String get cancelReason;
  @override
  DateTime? get estimatedPrepTime;
  @override
  DateTime? get actualPrepTime;
  @override
  DateTime? get estimatedDeliveryTime;
  @override
  DateTime? get actualDeliveryTime;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) {
  return _OrderItemModel.fromJson(json);
}

/// @nodoc
mixin _$OrderItemModel {
  String get dishId => throw _privateConstructorUsedError;
  String get dishName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  List<String> get specialRequests => throw _privateConstructorUsedError;
  Map<String, dynamic> get nutritionInfo => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderItemModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderItemModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderItemModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemModelCopyWith<OrderItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemModelCopyWith<$Res> {
  factory $OrderItemModelCopyWith(
          OrderItemModel value, $Res Function(OrderItemModel) then) =
      _$OrderItemModelCopyWithImpl<$Res, OrderItemModel>;
  @useResult
  $Res call(
      {String dishId,
      String dishName,
      int quantity,
      double unitPrice,
      double totalPrice,
      List<String> specialRequests,
      Map<String, dynamic> nutritionInfo});
}

/// @nodoc
class _$OrderItemModelCopyWithImpl<$Res, $Val extends OrderItemModel>
    implements $OrderItemModelCopyWith<$Res> {
  _$OrderItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dishId = null,
    Object? dishName = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? specialRequests = null,
    Object? nutritionInfo = null,
  }) {
    return _then(_value.copyWith(
      dishId: null == dishId
          ? _value.dishId
          : dishId // ignore: cast_nullable_to_non_nullable
              as String,
      dishName: null == dishName
          ? _value.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      specialRequests: null == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionInfo: null == nutritionInfo
          ? _value.nutritionInfo
          : nutritionInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderItemModelImplCopyWith<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  factory _$$OrderItemModelImplCopyWith(_$OrderItemModelImpl value,
          $Res Function(_$OrderItemModelImpl) then) =
      __$$OrderItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String dishId,
      String dishName,
      int quantity,
      double unitPrice,
      double totalPrice,
      List<String> specialRequests,
      Map<String, dynamic> nutritionInfo});
}

/// @nodoc
class __$$OrderItemModelImplCopyWithImpl<$Res>
    extends _$OrderItemModelCopyWithImpl<$Res, _$OrderItemModelImpl>
    implements _$$OrderItemModelImplCopyWith<$Res> {
  __$$OrderItemModelImplCopyWithImpl(
      _$OrderItemModelImpl _value, $Res Function(_$OrderItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dishId = null,
    Object? dishName = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? specialRequests = null,
    Object? nutritionInfo = null,
  }) {
    return _then(_$OrderItemModelImpl(
      dishId: null == dishId
          ? _value.dishId
          : dishId // ignore: cast_nullable_to_non_nullable
              as String,
      dishName: null == dishName
          ? _value.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      specialRequests: null == specialRequests
          ? _value._specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionInfo: null == nutritionInfo
          ? _value._nutritionInfo
          : nutritionInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemModelImpl implements _OrderItemModel {
  const _$OrderItemModelImpl(
      {required this.dishId,
      required this.dishName,
      required this.quantity,
      required this.unitPrice,
      required this.totalPrice,
      final List<String> specialRequests = const [],
      final Map<String, dynamic> nutritionInfo = const {}})
      : _specialRequests = specialRequests,
        _nutritionInfo = nutritionInfo;

  factory _$OrderItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemModelImplFromJson(json);

  @override
  final String dishId;
  @override
  final String dishName;
  @override
  final int quantity;
  @override
  final double unitPrice;
  @override
  final double totalPrice;
  final List<String> _specialRequests;
  @override
  @JsonKey()
  List<String> get specialRequests {
    if (_specialRequests is EqualUnmodifiableListView) return _specialRequests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialRequests);
  }

  final Map<String, dynamic> _nutritionInfo;
  @override
  @JsonKey()
  Map<String, dynamic> get nutritionInfo {
    if (_nutritionInfo is EqualUnmodifiableMapView) return _nutritionInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionInfo);
  }

  @override
  String toString() {
    return 'OrderItemModel(dishId: $dishId, dishName: $dishName, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, specialRequests: $specialRequests, nutritionInfo: $nutritionInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemModelImpl &&
            (identical(other.dishId, dishId) || other.dishId == dishId) &&
            (identical(other.dishName, dishName) ||
                other.dishName == dishName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            const DeepCollectionEquality()
                .equals(other._specialRequests, _specialRequests) &&
            const DeepCollectionEquality()
                .equals(other._nutritionInfo, _nutritionInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dishId,
      dishName,
      quantity,
      unitPrice,
      totalPrice,
      const DeepCollectionEquality().hash(_specialRequests),
      const DeepCollectionEquality().hash(_nutritionInfo));

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      __$$OrderItemModelImplCopyWithImpl<_$OrderItemModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderItemModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderItemModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderItemModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemModelImplToJson(
      this,
    );
  }
}

abstract class _OrderItemModel implements OrderItemModel {
  const factory _OrderItemModel(
      {required final String dishId,
      required final String dishName,
      required final int quantity,
      required final double unitPrice,
      required final double totalPrice,
      final List<String> specialRequests,
      final Map<String, dynamic> nutritionInfo}) = _$OrderItemModelImpl;

  factory _OrderItemModel.fromJson(Map<String, dynamic> json) =
      _$OrderItemModelImpl.fromJson;

  @override
  String get dishId;
  @override
  String get dishName;
  @override
  int get quantity;
  @override
  double get unitPrice;
  @override
  double get totalPrice;
  @override
  List<String> get specialRequests;
  @override
  Map<String, dynamic> get nutritionInfo;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderStatusUpdateRequest _$OrderStatusUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return _OrderStatusUpdateRequest.fromJson(json);
}

/// @nodoc
mixin _$OrderStatusUpdateRequest {
  String get newStatus => throw _privateConstructorUsedError;
  String? get cancelReason => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderStatusUpdateRequest value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderStatusUpdateRequest value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderStatusUpdateRequest value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderStatusUpdateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderStatusUpdateRequestCopyWith<OrderStatusUpdateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderStatusUpdateRequestCopyWith<$Res> {
  factory $OrderStatusUpdateRequestCopyWith(OrderStatusUpdateRequest value,
          $Res Function(OrderStatusUpdateRequest) then) =
      _$OrderStatusUpdateRequestCopyWithImpl<$Res, OrderStatusUpdateRequest>;
  @useResult
  $Res call({String newStatus, String? cancelReason, String? notes});
}

/// @nodoc
class _$OrderStatusUpdateRequestCopyWithImpl<$Res,
        $Val extends OrderStatusUpdateRequest>
    implements $OrderStatusUpdateRequestCopyWith<$Res> {
  _$OrderStatusUpdateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newStatus = null,
    Object? cancelReason = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderStatusUpdateRequestImplCopyWith<$Res>
    implements $OrderStatusUpdateRequestCopyWith<$Res> {
  factory _$$OrderStatusUpdateRequestImplCopyWith(
          _$OrderStatusUpdateRequestImpl value,
          $Res Function(_$OrderStatusUpdateRequestImpl) then) =
      __$$OrderStatusUpdateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String newStatus, String? cancelReason, String? notes});
}

/// @nodoc
class __$$OrderStatusUpdateRequestImplCopyWithImpl<$Res>
    extends _$OrderStatusUpdateRequestCopyWithImpl<$Res,
        _$OrderStatusUpdateRequestImpl>
    implements _$$OrderStatusUpdateRequestImplCopyWith<$Res> {
  __$$OrderStatusUpdateRequestImplCopyWithImpl(
      _$OrderStatusUpdateRequestImpl _value,
      $Res Function(_$OrderStatusUpdateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newStatus = null,
    Object? cancelReason = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$OrderStatusUpdateRequestImpl(
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderStatusUpdateRequestImpl implements _OrderStatusUpdateRequest {
  const _$OrderStatusUpdateRequestImpl(
      {required this.newStatus, this.cancelReason, this.notes});

  factory _$OrderStatusUpdateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderStatusUpdateRequestImplFromJson(json);

  @override
  final String newStatus;
  @override
  final String? cancelReason;
  @override
  final String? notes;

  @override
  String toString() {
    return 'OrderStatusUpdateRequest(newStatus: $newStatus, cancelReason: $cancelReason, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderStatusUpdateRequestImpl &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus) &&
            (identical(other.cancelReason, cancelReason) ||
                other.cancelReason == cancelReason) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, newStatus, cancelReason, notes);

  /// Create a copy of OrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderStatusUpdateRequestImplCopyWith<_$OrderStatusUpdateRequestImpl>
      get copyWith => __$$OrderStatusUpdateRequestImplCopyWithImpl<
          _$OrderStatusUpdateRequestImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderStatusUpdateRequest value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderStatusUpdateRequest value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderStatusUpdateRequest value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderStatusUpdateRequestImplToJson(
      this,
    );
  }
}

abstract class _OrderStatusUpdateRequest implements OrderStatusUpdateRequest {
  const factory _OrderStatusUpdateRequest(
      {required final String newStatus,
      final String? cancelReason,
      final String? notes}) = _$OrderStatusUpdateRequestImpl;

  factory _OrderStatusUpdateRequest.fromJson(Map<String, dynamic> json) =
      _$OrderStatusUpdateRequestImpl.fromJson;

  @override
  String get newStatus;
  @override
  String? get cancelReason;
  @override
  String? get notes;

  /// Create a copy of OrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderStatusUpdateRequestImplCopyWith<_$OrderStatusUpdateRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BatchOrderStatusUpdateRequest _$BatchOrderStatusUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return _BatchOrderStatusUpdateRequest.fromJson(json);
}

/// @nodoc
mixin _$BatchOrderStatusUpdateRequest {
  List<String> get orderIds => throw _privateConstructorUsedError;
  String get newStatus => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BatchOrderStatusUpdateRequest value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BatchOrderStatusUpdateRequest value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BatchOrderStatusUpdateRequest value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this BatchOrderStatusUpdateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BatchOrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BatchOrderStatusUpdateRequestCopyWith<BatchOrderStatusUpdateRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchOrderStatusUpdateRequestCopyWith<$Res> {
  factory $BatchOrderStatusUpdateRequestCopyWith(
          BatchOrderStatusUpdateRequest value,
          $Res Function(BatchOrderStatusUpdateRequest) then) =
      _$BatchOrderStatusUpdateRequestCopyWithImpl<$Res,
          BatchOrderStatusUpdateRequest>;
  @useResult
  $Res call({List<String> orderIds, String newStatus, String? notes});
}

/// @nodoc
class _$BatchOrderStatusUpdateRequestCopyWithImpl<$Res,
        $Val extends BatchOrderStatusUpdateRequest>
    implements $BatchOrderStatusUpdateRequestCopyWith<$Res> {
  _$BatchOrderStatusUpdateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BatchOrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderIds = null,
    Object? newStatus = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      orderIds: null == orderIds
          ? _value.orderIds
          : orderIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchOrderStatusUpdateRequestImplCopyWith<$Res>
    implements $BatchOrderStatusUpdateRequestCopyWith<$Res> {
  factory _$$BatchOrderStatusUpdateRequestImplCopyWith(
          _$BatchOrderStatusUpdateRequestImpl value,
          $Res Function(_$BatchOrderStatusUpdateRequestImpl) then) =
      __$$BatchOrderStatusUpdateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> orderIds, String newStatus, String? notes});
}

/// @nodoc
class __$$BatchOrderStatusUpdateRequestImplCopyWithImpl<$Res>
    extends _$BatchOrderStatusUpdateRequestCopyWithImpl<$Res,
        _$BatchOrderStatusUpdateRequestImpl>
    implements _$$BatchOrderStatusUpdateRequestImplCopyWith<$Res> {
  __$$BatchOrderStatusUpdateRequestImplCopyWithImpl(
      _$BatchOrderStatusUpdateRequestImpl _value,
      $Res Function(_$BatchOrderStatusUpdateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of BatchOrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderIds = null,
    Object? newStatus = null,
    Object? notes = freezed,
  }) {
    return _then(_$BatchOrderStatusUpdateRequestImpl(
      orderIds: null == orderIds
          ? _value._orderIds
          : orderIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BatchOrderStatusUpdateRequestImpl
    implements _BatchOrderStatusUpdateRequest {
  const _$BatchOrderStatusUpdateRequestImpl(
      {required final List<String> orderIds,
      required this.newStatus,
      this.notes})
      : _orderIds = orderIds;

  factory _$BatchOrderStatusUpdateRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$BatchOrderStatusUpdateRequestImplFromJson(json);

  final List<String> _orderIds;
  @override
  List<String> get orderIds {
    if (_orderIds is EqualUnmodifiableListView) return _orderIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderIds);
  }

  @override
  final String newStatus;
  @override
  final String? notes;

  @override
  String toString() {
    return 'BatchOrderStatusUpdateRequest(orderIds: $orderIds, newStatus: $newStatus, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchOrderStatusUpdateRequestImpl &&
            const DeepCollectionEquality().equals(other._orderIds, _orderIds) &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_orderIds), newStatus, notes);

  /// Create a copy of BatchOrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchOrderStatusUpdateRequestImplCopyWith<
          _$BatchOrderStatusUpdateRequestImpl>
      get copyWith => __$$BatchOrderStatusUpdateRequestImplCopyWithImpl<
          _$BatchOrderStatusUpdateRequestImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BatchOrderStatusUpdateRequest value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BatchOrderStatusUpdateRequest value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BatchOrderStatusUpdateRequest value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchOrderStatusUpdateRequestImplToJson(
      this,
    );
  }
}

abstract class _BatchOrderStatusUpdateRequest
    implements BatchOrderStatusUpdateRequest {
  const factory _BatchOrderStatusUpdateRequest(
      {required final List<String> orderIds,
      required final String newStatus,
      final String? notes}) = _$BatchOrderStatusUpdateRequestImpl;

  factory _BatchOrderStatusUpdateRequest.fromJson(Map<String, dynamic> json) =
      _$BatchOrderStatusUpdateRequestImpl.fromJson;

  @override
  List<String> get orderIds;
  @override
  String get newStatus;
  @override
  String? get notes;

  /// Create a copy of BatchOrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BatchOrderStatusUpdateRequestImplCopyWith<
          _$BatchOrderStatusUpdateRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OrderStatusUpdateRequest _$OrderStatusUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return _OrderStatusUpdateRequest.fromJson(json);
}

/// @nodoc
mixin _$OrderStatusUpdateRequest {
  String get newStatus => throw _privateConstructorUsedError;
  String? get cancelReason => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderStatusUpdateRequest value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderStatusUpdateRequest value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderStatusUpdateRequest value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderStatusUpdateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderStatusUpdateRequestCopyWith<OrderStatusUpdateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderStatusUpdateRequestCopyWith<$Res> {
  factory $OrderStatusUpdateRequestCopyWith(OrderStatusUpdateRequest value,
          $Res Function(OrderStatusUpdateRequest) then) =
      _$OrderStatusUpdateRequestCopyWithImpl<$Res, OrderStatusUpdateRequest>;
  @useResult
  $Res call({String newStatus, String? cancelReason});
}

/// @nodoc
class _$OrderStatusUpdateRequestCopyWithImpl<$Res,
        $Val extends OrderStatusUpdateRequest>
    implements $OrderStatusUpdateRequestCopyWith<$Res> {
  _$OrderStatusUpdateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newStatus = null,
    Object? cancelReason = freezed,
  }) {
    return _then(_value.copyWith(
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderStatusUpdateRequestImplCopyWith<$Res>
    implements $OrderStatusUpdateRequestCopyWith<$Res> {
  factory _$$OrderStatusUpdateRequestImplCopyWith(
          _$OrderStatusUpdateRequestImpl value,
          $Res Function(_$OrderStatusUpdateRequestImpl) then) =
      __$$OrderStatusUpdateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String newStatus, String? cancelReason});
}

/// @nodoc
class __$$OrderStatusUpdateRequestImplCopyWithImpl<$Res>
    extends _$OrderStatusUpdateRequestCopyWithImpl<$Res,
        _$OrderStatusUpdateRequestImpl>
    implements _$$OrderStatusUpdateRequestImplCopyWith<$Res> {
  __$$OrderStatusUpdateRequestImplCopyWithImpl(
      _$OrderStatusUpdateRequestImpl _value,
      $Res Function(_$OrderStatusUpdateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newStatus = null,
    Object? cancelReason = freezed,
  }) {
    return _then(_$OrderStatusUpdateRequestImpl(
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderStatusUpdateRequestImpl implements _OrderStatusUpdateRequest {
  const _$OrderStatusUpdateRequestImpl(
      {required this.newStatus, this.cancelReason});

  factory _$OrderStatusUpdateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderStatusUpdateRequestImplFromJson(json);

  @override
  final String newStatus;
  @override
  final String? cancelReason;

  @override
  String toString() {
    return 'OrderStatusUpdateRequest(newStatus: $newStatus, cancelReason: $cancelReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderStatusUpdateRequestImpl &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus) &&
            (identical(other.cancelReason, cancelReason) ||
                other.cancelReason == cancelReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, newStatus, cancelReason);

  /// Create a copy of OrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderStatusUpdateRequestImplCopyWith<_$OrderStatusUpdateRequestImpl>
      get copyWith => __$$OrderStatusUpdateRequestImplCopyWithImpl<
          _$OrderStatusUpdateRequestImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderStatusUpdateRequest value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderStatusUpdateRequest value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderStatusUpdateRequest value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderStatusUpdateRequestImplToJson(
      this,
    );
  }
}

abstract class _OrderStatusUpdateRequest implements OrderStatusUpdateRequest {
  const factory _OrderStatusUpdateRequest(
      {required final String newStatus,
      final String? cancelReason}) = _$OrderStatusUpdateRequestImpl;

  factory _OrderStatusUpdateRequest.fromJson(Map<String, dynamic> json) =
      _$OrderStatusUpdateRequestImpl.fromJson;

  @override
  String get newStatus;
  @override
  String? get cancelReason;

  /// Create a copy of OrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderStatusUpdateRequestImplCopyWith<_$OrderStatusUpdateRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BatchOrderStatusUpdateRequest _$BatchOrderStatusUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return _BatchOrderStatusUpdateRequest.fromJson(json);
}

/// @nodoc
mixin _$BatchOrderStatusUpdateRequest {
  List<String> get orderIds => throw _privateConstructorUsedError;
  String get newStatus => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BatchOrderStatusUpdateRequest value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BatchOrderStatusUpdateRequest value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BatchOrderStatusUpdateRequest value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this BatchOrderStatusUpdateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BatchOrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BatchOrderStatusUpdateRequestCopyWith<BatchOrderStatusUpdateRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchOrderStatusUpdateRequestCopyWith<$Res> {
  factory $BatchOrderStatusUpdateRequestCopyWith(
          BatchOrderStatusUpdateRequest value,
          $Res Function(BatchOrderStatusUpdateRequest) then) =
      _$BatchOrderStatusUpdateRequestCopyWithImpl<$Res,
          BatchOrderStatusUpdateRequest>;
  @useResult
  $Res call({List<String> orderIds, String newStatus});
}

/// @nodoc
class _$BatchOrderStatusUpdateRequestCopyWithImpl<$Res,
        $Val extends BatchOrderStatusUpdateRequest>
    implements $BatchOrderStatusUpdateRequestCopyWith<$Res> {
  _$BatchOrderStatusUpdateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BatchOrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderIds = null,
    Object? newStatus = null,
  }) {
    return _then(_value.copyWith(
      orderIds: null == orderIds
          ? _value.orderIds
          : orderIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchOrderStatusUpdateRequestImplCopyWith<$Res>
    implements $BatchOrderStatusUpdateRequestCopyWith<$Res> {
  factory _$$BatchOrderStatusUpdateRequestImplCopyWith(
          _$BatchOrderStatusUpdateRequestImpl value,
          $Res Function(_$BatchOrderStatusUpdateRequestImpl) then) =
      __$$BatchOrderStatusUpdateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> orderIds, String newStatus});
}

/// @nodoc
class __$$BatchOrderStatusUpdateRequestImplCopyWithImpl<$Res>
    extends _$BatchOrderStatusUpdateRequestCopyWithImpl<$Res,
        _$BatchOrderStatusUpdateRequestImpl>
    implements _$$BatchOrderStatusUpdateRequestImplCopyWith<$Res> {
  __$$BatchOrderStatusUpdateRequestImplCopyWithImpl(
      _$BatchOrderStatusUpdateRequestImpl _value,
      $Res Function(_$BatchOrderStatusUpdateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of BatchOrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderIds = null,
    Object? newStatus = null,
  }) {
    return _then(_$BatchOrderStatusUpdateRequestImpl(
      orderIds: null == orderIds
          ? _value._orderIds
          : orderIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      newStatus: null == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BatchOrderStatusUpdateRequestImpl
    implements _BatchOrderStatusUpdateRequest {
  const _$BatchOrderStatusUpdateRequestImpl(
      {required final List<String> orderIds, required this.newStatus})
      : _orderIds = orderIds;

  factory _$BatchOrderStatusUpdateRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$BatchOrderStatusUpdateRequestImplFromJson(json);

  final List<String> _orderIds;
  @override
  List<String> get orderIds {
    if (_orderIds is EqualUnmodifiableListView) return _orderIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderIds);
  }

  @override
  final String newStatus;

  @override
  String toString() {
    return 'BatchOrderStatusUpdateRequest(orderIds: $orderIds, newStatus: $newStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchOrderStatusUpdateRequestImpl &&
            const DeepCollectionEquality().equals(other._orderIds, _orderIds) &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_orderIds), newStatus);

  /// Create a copy of BatchOrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchOrderStatusUpdateRequestImplCopyWith<
          _$BatchOrderStatusUpdateRequestImpl>
      get copyWith => __$$BatchOrderStatusUpdateRequestImplCopyWithImpl<
          _$BatchOrderStatusUpdateRequestImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BatchOrderStatusUpdateRequest value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BatchOrderStatusUpdateRequest value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BatchOrderStatusUpdateRequest value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchOrderStatusUpdateRequestImplToJson(
      this,
    );
  }
}

abstract class _BatchOrderStatusUpdateRequest
    implements BatchOrderStatusUpdateRequest {
  const factory _BatchOrderStatusUpdateRequest(
      {required final List<String> orderIds,
      required final String newStatus}) = _$BatchOrderStatusUpdateRequestImpl;

  factory _BatchOrderStatusUpdateRequest.fromJson(Map<String, dynamic> json) =
      _$BatchOrderStatusUpdateRequestImpl.fromJson;

  @override
  List<String> get orderIds;
  @override
  String get newStatus;

  /// Create a copy of BatchOrderStatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BatchOrderStatusUpdateRequestImplCopyWith<
          _$BatchOrderStatusUpdateRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
