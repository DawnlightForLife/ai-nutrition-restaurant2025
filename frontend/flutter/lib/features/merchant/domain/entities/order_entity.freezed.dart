// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderEntity _$OrderEntityFromJson(Map<String, dynamic> json) {
  return _OrderEntity.fromJson(json);
}

/// @nodoc
mixin _$OrderEntity {
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
  List<OrderItemEntity> get items => throw _privateConstructorUsedError;
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
    TResult Function(_OrderEntity value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderEntity value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderEntity value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderEntityCopyWith<OrderEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderEntityCopyWith<$Res> {
  factory $OrderEntityCopyWith(
          OrderEntity value, $Res Function(OrderEntity) then) =
      _$OrderEntityCopyWithImpl<$Res, OrderEntity>;
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
      List<OrderItemEntity> items,
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
class _$OrderEntityCopyWithImpl<$Res, $Val extends OrderEntity>
    implements $OrderEntityCopyWith<$Res> {
  _$OrderEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderEntity
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
              as List<OrderItemEntity>,
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
abstract class _$$OrderEntityImplCopyWith<$Res>
    implements $OrderEntityCopyWith<$Res> {
  factory _$$OrderEntityImplCopyWith(
          _$OrderEntityImpl value, $Res Function(_$OrderEntityImpl) then) =
      __$$OrderEntityImplCopyWithImpl<$Res>;
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
      List<OrderItemEntity> items,
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
class __$$OrderEntityImplCopyWithImpl<$Res>
    extends _$OrderEntityCopyWithImpl<$Res, _$OrderEntityImpl>
    implements _$$OrderEntityImplCopyWith<$Res> {
  __$$OrderEntityImplCopyWithImpl(
      _$OrderEntityImpl _value, $Res Function(_$OrderEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderEntity
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
    return _then(_$OrderEntityImpl(
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
              as List<OrderItemEntity>,
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
class _$OrderEntityImpl implements _OrderEntity {
  const _$OrderEntityImpl(
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
      required final List<OrderItemEntity> items,
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

  factory _$OrderEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderEntityImplFromJson(json);

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
  final List<OrderItemEntity> _items;
  @override
  List<OrderItemEntity> get items {
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
    return 'OrderEntity(id: $id, orderNumber: $orderNumber, userId: $userId, merchantId: $merchantId, storeId: $storeId, status: $status, orderType: $orderType, totalAmount: $totalAmount, actualAmount: $actualAmount, discountAmount: $discountAmount, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, items: $items, customerName: $customerName, customerPhone: $customerPhone, deliveryAddress: $deliveryAddress, notes: $notes, cancelReason: $cancelReason, estimatedPrepTime: $estimatedPrepTime, actualPrepTime: $actualPrepTime, estimatedDeliveryTime: $estimatedDeliveryTime, actualDeliveryTime: $actualDeliveryTime, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderEntityImpl &&
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

  /// Create a copy of OrderEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderEntityImplCopyWith<_$OrderEntityImpl> get copyWith =>
      __$$OrderEntityImplCopyWithImpl<_$OrderEntityImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderEntity value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderEntity value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderEntity value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderEntityImplToJson(
      this,
    );
  }
}

abstract class _OrderEntity implements OrderEntity {
  const factory _OrderEntity(
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
      required final List<OrderItemEntity> items,
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
      final DateTime? updatedAt}) = _$OrderEntityImpl;

  factory _OrderEntity.fromJson(Map<String, dynamic> json) =
      _$OrderEntityImpl.fromJson;

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
  List<OrderItemEntity> get items;
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

  /// Create a copy of OrderEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderEntityImplCopyWith<_$OrderEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItemEntity _$OrderItemEntityFromJson(Map<String, dynamic> json) {
  return _OrderItemEntity.fromJson(json);
}

/// @nodoc
mixin _$OrderItemEntity {
  String get dishId => throw _privateConstructorUsedError;
  String get dishName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  List<String> get specialRequests => throw _privateConstructorUsedError;
  Map<String, dynamic> get nutritionInfo => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderItemEntity value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderItemEntity value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderItemEntity value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderItemEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemEntityCopyWith<OrderItemEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemEntityCopyWith<$Res> {
  factory $OrderItemEntityCopyWith(
          OrderItemEntity value, $Res Function(OrderItemEntity) then) =
      _$OrderItemEntityCopyWithImpl<$Res, OrderItemEntity>;
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
class _$OrderItemEntityCopyWithImpl<$Res, $Val extends OrderItemEntity>
    implements $OrderItemEntityCopyWith<$Res> {
  _$OrderItemEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItemEntity
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
abstract class _$$OrderItemEntityImplCopyWith<$Res>
    implements $OrderItemEntityCopyWith<$Res> {
  factory _$$OrderItemEntityImplCopyWith(_$OrderItemEntityImpl value,
          $Res Function(_$OrderItemEntityImpl) then) =
      __$$OrderItemEntityImplCopyWithImpl<$Res>;
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
class __$$OrderItemEntityImplCopyWithImpl<$Res>
    extends _$OrderItemEntityCopyWithImpl<$Res, _$OrderItemEntityImpl>
    implements _$$OrderItemEntityImplCopyWith<$Res> {
  __$$OrderItemEntityImplCopyWithImpl(
      _$OrderItemEntityImpl _value, $Res Function(_$OrderItemEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderItemEntity
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
    return _then(_$OrderItemEntityImpl(
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
class _$OrderItemEntityImpl implements _OrderItemEntity {
  const _$OrderItemEntityImpl(
      {required this.dishId,
      required this.dishName,
      required this.quantity,
      required this.unitPrice,
      required this.totalPrice,
      final List<String> specialRequests = const [],
      final Map<String, dynamic> nutritionInfo = const {}})
      : _specialRequests = specialRequests,
        _nutritionInfo = nutritionInfo;

  factory _$OrderItemEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemEntityImplFromJson(json);

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
    return 'OrderItemEntity(dishId: $dishId, dishName: $dishName, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, specialRequests: $specialRequests, nutritionInfo: $nutritionInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemEntityImpl &&
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

  /// Create a copy of OrderItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemEntityImplCopyWith<_$OrderItemEntityImpl> get copyWith =>
      __$$OrderItemEntityImplCopyWithImpl<_$OrderItemEntityImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderItemEntity value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderItemEntity value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderItemEntity value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemEntityImplToJson(
      this,
    );
  }
}

abstract class _OrderItemEntity implements OrderItemEntity {
  const factory _OrderItemEntity(
      {required final String dishId,
      required final String dishName,
      required final int quantity,
      required final double unitPrice,
      required final double totalPrice,
      final List<String> specialRequests,
      final Map<String, dynamic> nutritionInfo}) = _$OrderItemEntityImpl;

  factory _OrderItemEntity.fromJson(Map<String, dynamic> json) =
      _$OrderItemEntityImpl.fromJson;

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

  /// Create a copy of OrderItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemEntityImplCopyWith<_$OrderItemEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductionQueueEntity _$ProductionQueueEntityFromJson(
    Map<String, dynamic> json) {
  return _ProductionQueueEntity.fromJson(json);
}

/// @nodoc
mixin _$ProductionQueueEntity {
  List<OrderEntity> get pendingOrders => throw _privateConstructorUsedError;
  List<OrderEntity> get preparingOrders => throw _privateConstructorUsedError;
  List<OrderEntity> get readyOrders => throw _privateConstructorUsedError;
  int get totalOrders => throw _privateConstructorUsedError;
  double get averagePrepTime => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProductionQueueEntity value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProductionQueueEntity value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProductionQueueEntity value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ProductionQueueEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductionQueueEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductionQueueEntityCopyWith<ProductionQueueEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductionQueueEntityCopyWith<$Res> {
  factory $ProductionQueueEntityCopyWith(ProductionQueueEntity value,
          $Res Function(ProductionQueueEntity) then) =
      _$ProductionQueueEntityCopyWithImpl<$Res, ProductionQueueEntity>;
  @useResult
  $Res call(
      {List<OrderEntity> pendingOrders,
      List<OrderEntity> preparingOrders,
      List<OrderEntity> readyOrders,
      int totalOrders,
      double averagePrepTime,
      DateTime lastUpdated});
}

/// @nodoc
class _$ProductionQueueEntityCopyWithImpl<$Res,
        $Val extends ProductionQueueEntity>
    implements $ProductionQueueEntityCopyWith<$Res> {
  _$ProductionQueueEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductionQueueEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingOrders = null,
    Object? preparingOrders = null,
    Object? readyOrders = null,
    Object? totalOrders = null,
    Object? averagePrepTime = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      pendingOrders: null == pendingOrders
          ? _value.pendingOrders
          : pendingOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      preparingOrders: null == preparingOrders
          ? _value.preparingOrders
          : preparingOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      readyOrders: null == readyOrders
          ? _value.readyOrders
          : readyOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      averagePrepTime: null == averagePrepTime
          ? _value.averagePrepTime
          : averagePrepTime // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductionQueueEntityImplCopyWith<$Res>
    implements $ProductionQueueEntityCopyWith<$Res> {
  factory _$$ProductionQueueEntityImplCopyWith(
          _$ProductionQueueEntityImpl value,
          $Res Function(_$ProductionQueueEntityImpl) then) =
      __$$ProductionQueueEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<OrderEntity> pendingOrders,
      List<OrderEntity> preparingOrders,
      List<OrderEntity> readyOrders,
      int totalOrders,
      double averagePrepTime,
      DateTime lastUpdated});
}

/// @nodoc
class __$$ProductionQueueEntityImplCopyWithImpl<$Res>
    extends _$ProductionQueueEntityCopyWithImpl<$Res,
        _$ProductionQueueEntityImpl>
    implements _$$ProductionQueueEntityImplCopyWith<$Res> {
  __$$ProductionQueueEntityImplCopyWithImpl(_$ProductionQueueEntityImpl _value,
      $Res Function(_$ProductionQueueEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductionQueueEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingOrders = null,
    Object? preparingOrders = null,
    Object? readyOrders = null,
    Object? totalOrders = null,
    Object? averagePrepTime = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$ProductionQueueEntityImpl(
      pendingOrders: null == pendingOrders
          ? _value._pendingOrders
          : pendingOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      preparingOrders: null == preparingOrders
          ? _value._preparingOrders
          : preparingOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      readyOrders: null == readyOrders
          ? _value._readyOrders
          : readyOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      averagePrepTime: null == averagePrepTime
          ? _value.averagePrepTime
          : averagePrepTime // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductionQueueEntityImpl implements _ProductionQueueEntity {
  const _$ProductionQueueEntityImpl(
      {required final List<OrderEntity> pendingOrders,
      required final List<OrderEntity> preparingOrders,
      required final List<OrderEntity> readyOrders,
      required this.totalOrders,
      required this.averagePrepTime,
      required this.lastUpdated})
      : _pendingOrders = pendingOrders,
        _preparingOrders = preparingOrders,
        _readyOrders = readyOrders;

  factory _$ProductionQueueEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductionQueueEntityImplFromJson(json);

  final List<OrderEntity> _pendingOrders;
  @override
  List<OrderEntity> get pendingOrders {
    if (_pendingOrders is EqualUnmodifiableListView) return _pendingOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingOrders);
  }

  final List<OrderEntity> _preparingOrders;
  @override
  List<OrderEntity> get preparingOrders {
    if (_preparingOrders is EqualUnmodifiableListView) return _preparingOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preparingOrders);
  }

  final List<OrderEntity> _readyOrders;
  @override
  List<OrderEntity> get readyOrders {
    if (_readyOrders is EqualUnmodifiableListView) return _readyOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_readyOrders);
  }

  @override
  final int totalOrders;
  @override
  final double averagePrepTime;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'ProductionQueueEntity(pendingOrders: $pendingOrders, preparingOrders: $preparingOrders, readyOrders: $readyOrders, totalOrders: $totalOrders, averagePrepTime: $averagePrepTime, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductionQueueEntityImpl &&
            const DeepCollectionEquality()
                .equals(other._pendingOrders, _pendingOrders) &&
            const DeepCollectionEquality()
                .equals(other._preparingOrders, _preparingOrders) &&
            const DeepCollectionEquality()
                .equals(other._readyOrders, _readyOrders) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.averagePrepTime, averagePrepTime) ||
                other.averagePrepTime == averagePrepTime) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_pendingOrders),
      const DeepCollectionEquality().hash(_preparingOrders),
      const DeepCollectionEquality().hash(_readyOrders),
      totalOrders,
      averagePrepTime,
      lastUpdated);

  /// Create a copy of ProductionQueueEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductionQueueEntityImplCopyWith<_$ProductionQueueEntityImpl>
      get copyWith => __$$ProductionQueueEntityImplCopyWithImpl<
          _$ProductionQueueEntityImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProductionQueueEntity value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProductionQueueEntity value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProductionQueueEntity value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductionQueueEntityImplToJson(
      this,
    );
  }
}

abstract class _ProductionQueueEntity implements ProductionQueueEntity {
  const factory _ProductionQueueEntity(
      {required final List<OrderEntity> pendingOrders,
      required final List<OrderEntity> preparingOrders,
      required final List<OrderEntity> readyOrders,
      required final int totalOrders,
      required final double averagePrepTime,
      required final DateTime lastUpdated}) = _$ProductionQueueEntityImpl;

  factory _ProductionQueueEntity.fromJson(Map<String, dynamic> json) =
      _$ProductionQueueEntityImpl.fromJson;

  @override
  List<OrderEntity> get pendingOrders;
  @override
  List<OrderEntity> get preparingOrders;
  @override
  List<OrderEntity> get readyOrders;
  @override
  int get totalOrders;
  @override
  double get averagePrepTime;
  @override
  DateTime get lastUpdated;

  /// Create a copy of ProductionQueueEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductionQueueEntityImplCopyWith<_$ProductionQueueEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

DeliveryManagementEntity _$DeliveryManagementEntityFromJson(
    Map<String, dynamic> json) {
  return _DeliveryManagementEntity.fromJson(json);
}

/// @nodoc
mixin _$DeliveryManagementEntity {
  List<OrderEntity> get readyForDelivery => throw _privateConstructorUsedError;
  List<OrderEntity> get outForDelivery => throw _privateConstructorUsedError;
  List<OrderEntity> get delivered => throw _privateConstructorUsedError;
  int get totalDeliveries => throw _privateConstructorUsedError;
  double get averageDeliveryTime => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DeliveryManagementEntity value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DeliveryManagementEntity value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DeliveryManagementEntity value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this DeliveryManagementEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeliveryManagementEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryManagementEntityCopyWith<DeliveryManagementEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryManagementEntityCopyWith<$Res> {
  factory $DeliveryManagementEntityCopyWith(DeliveryManagementEntity value,
          $Res Function(DeliveryManagementEntity) then) =
      _$DeliveryManagementEntityCopyWithImpl<$Res, DeliveryManagementEntity>;
  @useResult
  $Res call(
      {List<OrderEntity> readyForDelivery,
      List<OrderEntity> outForDelivery,
      List<OrderEntity> delivered,
      int totalDeliveries,
      double averageDeliveryTime,
      DateTime lastUpdated});
}

/// @nodoc
class _$DeliveryManagementEntityCopyWithImpl<$Res,
        $Val extends DeliveryManagementEntity>
    implements $DeliveryManagementEntityCopyWith<$Res> {
  _$DeliveryManagementEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryManagementEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? readyForDelivery = null,
    Object? outForDelivery = null,
    Object? delivered = null,
    Object? totalDeliveries = null,
    Object? averageDeliveryTime = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      readyForDelivery: null == readyForDelivery
          ? _value.readyForDelivery
          : readyForDelivery // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      outForDelivery: null == outForDelivery
          ? _value.outForDelivery
          : outForDelivery // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      delivered: null == delivered
          ? _value.delivered
          : delivered // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      totalDeliveries: null == totalDeliveries
          ? _value.totalDeliveries
          : totalDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      averageDeliveryTime: null == averageDeliveryTime
          ? _value.averageDeliveryTime
          : averageDeliveryTime // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeliveryManagementEntityImplCopyWith<$Res>
    implements $DeliveryManagementEntityCopyWith<$Res> {
  factory _$$DeliveryManagementEntityImplCopyWith(
          _$DeliveryManagementEntityImpl value,
          $Res Function(_$DeliveryManagementEntityImpl) then) =
      __$$DeliveryManagementEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<OrderEntity> readyForDelivery,
      List<OrderEntity> outForDelivery,
      List<OrderEntity> delivered,
      int totalDeliveries,
      double averageDeliveryTime,
      DateTime lastUpdated});
}

/// @nodoc
class __$$DeliveryManagementEntityImplCopyWithImpl<$Res>
    extends _$DeliveryManagementEntityCopyWithImpl<$Res,
        _$DeliveryManagementEntityImpl>
    implements _$$DeliveryManagementEntityImplCopyWith<$Res> {
  __$$DeliveryManagementEntityImplCopyWithImpl(
      _$DeliveryManagementEntityImpl _value,
      $Res Function(_$DeliveryManagementEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeliveryManagementEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? readyForDelivery = null,
    Object? outForDelivery = null,
    Object? delivered = null,
    Object? totalDeliveries = null,
    Object? averageDeliveryTime = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$DeliveryManagementEntityImpl(
      readyForDelivery: null == readyForDelivery
          ? _value._readyForDelivery
          : readyForDelivery // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      outForDelivery: null == outForDelivery
          ? _value._outForDelivery
          : outForDelivery // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      delivered: null == delivered
          ? _value._delivered
          : delivered // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      totalDeliveries: null == totalDeliveries
          ? _value.totalDeliveries
          : totalDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      averageDeliveryTime: null == averageDeliveryTime
          ? _value.averageDeliveryTime
          : averageDeliveryTime // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryManagementEntityImpl implements _DeliveryManagementEntity {
  const _$DeliveryManagementEntityImpl(
      {required final List<OrderEntity> readyForDelivery,
      required final List<OrderEntity> outForDelivery,
      required final List<OrderEntity> delivered,
      required this.totalDeliveries,
      required this.averageDeliveryTime,
      required this.lastUpdated})
      : _readyForDelivery = readyForDelivery,
        _outForDelivery = outForDelivery,
        _delivered = delivered;

  factory _$DeliveryManagementEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryManagementEntityImplFromJson(json);

  final List<OrderEntity> _readyForDelivery;
  @override
  List<OrderEntity> get readyForDelivery {
    if (_readyForDelivery is EqualUnmodifiableListView)
      return _readyForDelivery;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_readyForDelivery);
  }

  final List<OrderEntity> _outForDelivery;
  @override
  List<OrderEntity> get outForDelivery {
    if (_outForDelivery is EqualUnmodifiableListView) return _outForDelivery;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_outForDelivery);
  }

  final List<OrderEntity> _delivered;
  @override
  List<OrderEntity> get delivered {
    if (_delivered is EqualUnmodifiableListView) return _delivered;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_delivered);
  }

  @override
  final int totalDeliveries;
  @override
  final double averageDeliveryTime;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'DeliveryManagementEntity(readyForDelivery: $readyForDelivery, outForDelivery: $outForDelivery, delivered: $delivered, totalDeliveries: $totalDeliveries, averageDeliveryTime: $averageDeliveryTime, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryManagementEntityImpl &&
            const DeepCollectionEquality()
                .equals(other._readyForDelivery, _readyForDelivery) &&
            const DeepCollectionEquality()
                .equals(other._outForDelivery, _outForDelivery) &&
            const DeepCollectionEquality()
                .equals(other._delivered, _delivered) &&
            (identical(other.totalDeliveries, totalDeliveries) ||
                other.totalDeliveries == totalDeliveries) &&
            (identical(other.averageDeliveryTime, averageDeliveryTime) ||
                other.averageDeliveryTime == averageDeliveryTime) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_readyForDelivery),
      const DeepCollectionEquality().hash(_outForDelivery),
      const DeepCollectionEquality().hash(_delivered),
      totalDeliveries,
      averageDeliveryTime,
      lastUpdated);

  /// Create a copy of DeliveryManagementEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryManagementEntityImplCopyWith<_$DeliveryManagementEntityImpl>
      get copyWith => __$$DeliveryManagementEntityImplCopyWithImpl<
          _$DeliveryManagementEntityImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DeliveryManagementEntity value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DeliveryManagementEntity value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DeliveryManagementEntity value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryManagementEntityImplToJson(
      this,
    );
  }
}

abstract class _DeliveryManagementEntity implements DeliveryManagementEntity {
  const factory _DeliveryManagementEntity(
      {required final List<OrderEntity> readyForDelivery,
      required final List<OrderEntity> outForDelivery,
      required final List<OrderEntity> delivered,
      required final int totalDeliveries,
      required final double averageDeliveryTime,
      required final DateTime lastUpdated}) = _$DeliveryManagementEntityImpl;

  factory _DeliveryManagementEntity.fromJson(Map<String, dynamic> json) =
      _$DeliveryManagementEntityImpl.fromJson;

  @override
  List<OrderEntity> get readyForDelivery;
  @override
  List<OrderEntity> get outForDelivery;
  @override
  List<OrderEntity> get delivered;
  @override
  int get totalDeliveries;
  @override
  double get averageDeliveryTime;
  @override
  DateTime get lastUpdated;

  /// Create a copy of DeliveryManagementEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryManagementEntityImplCopyWith<_$DeliveryManagementEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OrderAnalyticsEntity _$OrderAnalyticsEntityFromJson(Map<String, dynamic> json) {
  return _OrderAnalyticsEntity.fromJson(json);
}

/// @nodoc
mixin _$OrderAnalyticsEntity {
  int get totalOrders => throw _privateConstructorUsedError;
  int get completedOrders => throw _privateConstructorUsedError;
  int get cancelledOrders => throw _privateConstructorUsedError;
  int get pendingOrders => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;
  double get averageOrderValue => throw _privateConstructorUsedError;
  double get averagePrepTime => throw _privateConstructorUsedError;
  Map<String, int> get ordersByStatus => throw _privateConstructorUsedError;
  Map<String, double> get revenueByDay => throw _privateConstructorUsedError;
  List<TopDishEntity> get topDishes => throw _privateConstructorUsedError;
  DateTime get periodStart => throw _privateConstructorUsedError;
  DateTime get periodEnd => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderAnalyticsEntity value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderAnalyticsEntity value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderAnalyticsEntity value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderAnalyticsEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderAnalyticsEntityCopyWith<OrderAnalyticsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderAnalyticsEntityCopyWith<$Res> {
  factory $OrderAnalyticsEntityCopyWith(OrderAnalyticsEntity value,
          $Res Function(OrderAnalyticsEntity) then) =
      _$OrderAnalyticsEntityCopyWithImpl<$Res, OrderAnalyticsEntity>;
  @useResult
  $Res call(
      {int totalOrders,
      int completedOrders,
      int cancelledOrders,
      int pendingOrders,
      double totalRevenue,
      double averageOrderValue,
      double averagePrepTime,
      Map<String, int> ordersByStatus,
      Map<String, double> revenueByDay,
      List<TopDishEntity> topDishes,
      DateTime periodStart,
      DateTime periodEnd});
}

/// @nodoc
class _$OrderAnalyticsEntityCopyWithImpl<$Res,
        $Val extends OrderAnalyticsEntity>
    implements $OrderAnalyticsEntityCopyWith<$Res> {
  _$OrderAnalyticsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalOrders = null,
    Object? completedOrders = null,
    Object? cancelledOrders = null,
    Object? pendingOrders = null,
    Object? totalRevenue = null,
    Object? averageOrderValue = null,
    Object? averagePrepTime = null,
    Object? ordersByStatus = null,
    Object? revenueByDay = null,
    Object? topDishes = null,
    Object? periodStart = null,
    Object? periodEnd = null,
  }) {
    return _then(_value.copyWith(
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      completedOrders: null == completedOrders
          ? _value.completedOrders
          : completedOrders // ignore: cast_nullable_to_non_nullable
              as int,
      cancelledOrders: null == cancelledOrders
          ? _value.cancelledOrders
          : cancelledOrders // ignore: cast_nullable_to_non_nullable
              as int,
      pendingOrders: null == pendingOrders
          ? _value.pendingOrders
          : pendingOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      averageOrderValue: null == averageOrderValue
          ? _value.averageOrderValue
          : averageOrderValue // ignore: cast_nullable_to_non_nullable
              as double,
      averagePrepTime: null == averagePrepTime
          ? _value.averagePrepTime
          : averagePrepTime // ignore: cast_nullable_to_non_nullable
              as double,
      ordersByStatus: null == ordersByStatus
          ? _value.ordersByStatus
          : ordersByStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      revenueByDay: null == revenueByDay
          ? _value.revenueByDay
          : revenueByDay // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      topDishes: null == topDishes
          ? _value.topDishes
          : topDishes // ignore: cast_nullable_to_non_nullable
              as List<TopDishEntity>,
      periodStart: null == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      periodEnd: null == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderAnalyticsEntityImplCopyWith<$Res>
    implements $OrderAnalyticsEntityCopyWith<$Res> {
  factory _$$OrderAnalyticsEntityImplCopyWith(_$OrderAnalyticsEntityImpl value,
          $Res Function(_$OrderAnalyticsEntityImpl) then) =
      __$$OrderAnalyticsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalOrders,
      int completedOrders,
      int cancelledOrders,
      int pendingOrders,
      double totalRevenue,
      double averageOrderValue,
      double averagePrepTime,
      Map<String, int> ordersByStatus,
      Map<String, double> revenueByDay,
      List<TopDishEntity> topDishes,
      DateTime periodStart,
      DateTime periodEnd});
}

/// @nodoc
class __$$OrderAnalyticsEntityImplCopyWithImpl<$Res>
    extends _$OrderAnalyticsEntityCopyWithImpl<$Res, _$OrderAnalyticsEntityImpl>
    implements _$$OrderAnalyticsEntityImplCopyWith<$Res> {
  __$$OrderAnalyticsEntityImplCopyWithImpl(_$OrderAnalyticsEntityImpl _value,
      $Res Function(_$OrderAnalyticsEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalOrders = null,
    Object? completedOrders = null,
    Object? cancelledOrders = null,
    Object? pendingOrders = null,
    Object? totalRevenue = null,
    Object? averageOrderValue = null,
    Object? averagePrepTime = null,
    Object? ordersByStatus = null,
    Object? revenueByDay = null,
    Object? topDishes = null,
    Object? periodStart = null,
    Object? periodEnd = null,
  }) {
    return _then(_$OrderAnalyticsEntityImpl(
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      completedOrders: null == completedOrders
          ? _value.completedOrders
          : completedOrders // ignore: cast_nullable_to_non_nullable
              as int,
      cancelledOrders: null == cancelledOrders
          ? _value.cancelledOrders
          : cancelledOrders // ignore: cast_nullable_to_non_nullable
              as int,
      pendingOrders: null == pendingOrders
          ? _value.pendingOrders
          : pendingOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      averageOrderValue: null == averageOrderValue
          ? _value.averageOrderValue
          : averageOrderValue // ignore: cast_nullable_to_non_nullable
              as double,
      averagePrepTime: null == averagePrepTime
          ? _value.averagePrepTime
          : averagePrepTime // ignore: cast_nullable_to_non_nullable
              as double,
      ordersByStatus: null == ordersByStatus
          ? _value._ordersByStatus
          : ordersByStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      revenueByDay: null == revenueByDay
          ? _value._revenueByDay
          : revenueByDay // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      topDishes: null == topDishes
          ? _value._topDishes
          : topDishes // ignore: cast_nullable_to_non_nullable
              as List<TopDishEntity>,
      periodStart: null == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      periodEnd: null == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderAnalyticsEntityImpl implements _OrderAnalyticsEntity {
  const _$OrderAnalyticsEntityImpl(
      {required this.totalOrders,
      required this.completedOrders,
      required this.cancelledOrders,
      required this.pendingOrders,
      required this.totalRevenue,
      required this.averageOrderValue,
      required this.averagePrepTime,
      required final Map<String, int> ordersByStatus,
      required final Map<String, double> revenueByDay,
      required final List<TopDishEntity> topDishes,
      required this.periodStart,
      required this.periodEnd})
      : _ordersByStatus = ordersByStatus,
        _revenueByDay = revenueByDay,
        _topDishes = topDishes;

  factory _$OrderAnalyticsEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderAnalyticsEntityImplFromJson(json);

  @override
  final int totalOrders;
  @override
  final int completedOrders;
  @override
  final int cancelledOrders;
  @override
  final int pendingOrders;
  @override
  final double totalRevenue;
  @override
  final double averageOrderValue;
  @override
  final double averagePrepTime;
  final Map<String, int> _ordersByStatus;
  @override
  Map<String, int> get ordersByStatus {
    if (_ordersByStatus is EqualUnmodifiableMapView) return _ordersByStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ordersByStatus);
  }

  final Map<String, double> _revenueByDay;
  @override
  Map<String, double> get revenueByDay {
    if (_revenueByDay is EqualUnmodifiableMapView) return _revenueByDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_revenueByDay);
  }

  final List<TopDishEntity> _topDishes;
  @override
  List<TopDishEntity> get topDishes {
    if (_topDishes is EqualUnmodifiableListView) return _topDishes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topDishes);
  }

  @override
  final DateTime periodStart;
  @override
  final DateTime periodEnd;

  @override
  String toString() {
    return 'OrderAnalyticsEntity(totalOrders: $totalOrders, completedOrders: $completedOrders, cancelledOrders: $cancelledOrders, pendingOrders: $pendingOrders, totalRevenue: $totalRevenue, averageOrderValue: $averageOrderValue, averagePrepTime: $averagePrepTime, ordersByStatus: $ordersByStatus, revenueByDay: $revenueByDay, topDishes: $topDishes, periodStart: $periodStart, periodEnd: $periodEnd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderAnalyticsEntityImpl &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.completedOrders, completedOrders) ||
                other.completedOrders == completedOrders) &&
            (identical(other.cancelledOrders, cancelledOrders) ||
                other.cancelledOrders == cancelledOrders) &&
            (identical(other.pendingOrders, pendingOrders) ||
                other.pendingOrders == pendingOrders) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.averageOrderValue, averageOrderValue) ||
                other.averageOrderValue == averageOrderValue) &&
            (identical(other.averagePrepTime, averagePrepTime) ||
                other.averagePrepTime == averagePrepTime) &&
            const DeepCollectionEquality()
                .equals(other._ordersByStatus, _ordersByStatus) &&
            const DeepCollectionEquality()
                .equals(other._revenueByDay, _revenueByDay) &&
            const DeepCollectionEquality()
                .equals(other._topDishes, _topDishes) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalOrders,
      completedOrders,
      cancelledOrders,
      pendingOrders,
      totalRevenue,
      averageOrderValue,
      averagePrepTime,
      const DeepCollectionEquality().hash(_ordersByStatus),
      const DeepCollectionEquality().hash(_revenueByDay),
      const DeepCollectionEquality().hash(_topDishes),
      periodStart,
      periodEnd);

  /// Create a copy of OrderAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderAnalyticsEntityImplCopyWith<_$OrderAnalyticsEntityImpl>
      get copyWith =>
          __$$OrderAnalyticsEntityImplCopyWithImpl<_$OrderAnalyticsEntityImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderAnalyticsEntity value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderAnalyticsEntity value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderAnalyticsEntity value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderAnalyticsEntityImplToJson(
      this,
    );
  }
}

abstract class _OrderAnalyticsEntity implements OrderAnalyticsEntity {
  const factory _OrderAnalyticsEntity(
      {required final int totalOrders,
      required final int completedOrders,
      required final int cancelledOrders,
      required final int pendingOrders,
      required final double totalRevenue,
      required final double averageOrderValue,
      required final double averagePrepTime,
      required final Map<String, int> ordersByStatus,
      required final Map<String, double> revenueByDay,
      required final List<TopDishEntity> topDishes,
      required final DateTime periodStart,
      required final DateTime periodEnd}) = _$OrderAnalyticsEntityImpl;

  factory _OrderAnalyticsEntity.fromJson(Map<String, dynamic> json) =
      _$OrderAnalyticsEntityImpl.fromJson;

  @override
  int get totalOrders;
  @override
  int get completedOrders;
  @override
  int get cancelledOrders;
  @override
  int get pendingOrders;
  @override
  double get totalRevenue;
  @override
  double get averageOrderValue;
  @override
  double get averagePrepTime;
  @override
  Map<String, int> get ordersByStatus;
  @override
  Map<String, double> get revenueByDay;
  @override
  List<TopDishEntity> get topDishes;
  @override
  DateTime get periodStart;
  @override
  DateTime get periodEnd;

  /// Create a copy of OrderAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderAnalyticsEntityImplCopyWith<_$OrderAnalyticsEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TopDishEntity _$TopDishEntityFromJson(Map<String, dynamic> json) {
  return _TopDishEntity.fromJson(json);
}

/// @nodoc
mixin _$TopDishEntity {
  String get dishId => throw _privateConstructorUsedError;
  String get dishName => throw _privateConstructorUsedError;
  int get orderCount => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TopDishEntity value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TopDishEntity value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TopDishEntity value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this TopDishEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopDishEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopDishEntityCopyWith<TopDishEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopDishEntityCopyWith<$Res> {
  factory $TopDishEntityCopyWith(
          TopDishEntity value, $Res Function(TopDishEntity) then) =
      _$TopDishEntityCopyWithImpl<$Res, TopDishEntity>;
  @useResult
  $Res call({String dishId, String dishName, int orderCount, double revenue});
}

/// @nodoc
class _$TopDishEntityCopyWithImpl<$Res, $Val extends TopDishEntity>
    implements $TopDishEntityCopyWith<$Res> {
  _$TopDishEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopDishEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dishId = null,
    Object? dishName = null,
    Object? orderCount = null,
    Object? revenue = null,
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
      orderCount: null == orderCount
          ? _value.orderCount
          : orderCount // ignore: cast_nullable_to_non_nullable
              as int,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopDishEntityImplCopyWith<$Res>
    implements $TopDishEntityCopyWith<$Res> {
  factory _$$TopDishEntityImplCopyWith(
          _$TopDishEntityImpl value, $Res Function(_$TopDishEntityImpl) then) =
      __$$TopDishEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String dishId, String dishName, int orderCount, double revenue});
}

/// @nodoc
class __$$TopDishEntityImplCopyWithImpl<$Res>
    extends _$TopDishEntityCopyWithImpl<$Res, _$TopDishEntityImpl>
    implements _$$TopDishEntityImplCopyWith<$Res> {
  __$$TopDishEntityImplCopyWithImpl(
      _$TopDishEntityImpl _value, $Res Function(_$TopDishEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of TopDishEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dishId = null,
    Object? dishName = null,
    Object? orderCount = null,
    Object? revenue = null,
  }) {
    return _then(_$TopDishEntityImpl(
      dishId: null == dishId
          ? _value.dishId
          : dishId // ignore: cast_nullable_to_non_nullable
              as String,
      dishName: null == dishName
          ? _value.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String,
      orderCount: null == orderCount
          ? _value.orderCount
          : orderCount // ignore: cast_nullable_to_non_nullable
              as int,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopDishEntityImpl implements _TopDishEntity {
  const _$TopDishEntityImpl(
      {required this.dishId,
      required this.dishName,
      required this.orderCount,
      required this.revenue});

  factory _$TopDishEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopDishEntityImplFromJson(json);

  @override
  final String dishId;
  @override
  final String dishName;
  @override
  final int orderCount;
  @override
  final double revenue;

  @override
  String toString() {
    return 'TopDishEntity(dishId: $dishId, dishName: $dishName, orderCount: $orderCount, revenue: $revenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopDishEntityImpl &&
            (identical(other.dishId, dishId) || other.dishId == dishId) &&
            (identical(other.dishName, dishName) ||
                other.dishName == dishName) &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount) &&
            (identical(other.revenue, revenue) || other.revenue == revenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, dishId, dishName, orderCount, revenue);

  /// Create a copy of TopDishEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopDishEntityImplCopyWith<_$TopDishEntityImpl> get copyWith =>
      __$$TopDishEntityImplCopyWithImpl<_$TopDishEntityImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TopDishEntity value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TopDishEntity value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TopDishEntity value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TopDishEntityImplToJson(
      this,
    );
  }
}

abstract class _TopDishEntity implements TopDishEntity {
  const factory _TopDishEntity(
      {required final String dishId,
      required final String dishName,
      required final int orderCount,
      required final double revenue}) = _$TopDishEntityImpl;

  factory _TopDishEntity.fromJson(Map<String, dynamic> json) =
      _$TopDishEntityImpl.fromJson;

  @override
  String get dishId;
  @override
  String get dishName;
  @override
  int get orderCount;
  @override
  double get revenue;

  /// Create a copy of TopDishEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopDishEntityImplCopyWith<_$TopDishEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
