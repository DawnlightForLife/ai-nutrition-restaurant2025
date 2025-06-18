// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CartOrderItem {
  String get dishId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get itemTotal => throw _privateConstructorUsedError;
  String? get specifications => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CartOrderItem value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CartOrderItem value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CartOrderItem value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of CartOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartOrderItemCopyWith<CartOrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartOrderItemCopyWith<$Res> {
  factory $CartOrderItemCopyWith(
          CartOrderItem value, $Res Function(CartOrderItem) then) =
      _$CartOrderItemCopyWithImpl<$Res, CartOrderItem>;
  @useResult
  $Res call(
      {String dishId,
      String name,
      double price,
      int quantity,
      double itemTotal,
      String? specifications,
      String? imageUrl});
}

/// @nodoc
class _$CartOrderItemCopyWithImpl<$Res, $Val extends CartOrderItem>
    implements $CartOrderItemCopyWith<$Res> {
  _$CartOrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dishId = null,
    Object? name = null,
    Object? price = null,
    Object? quantity = null,
    Object? itemTotal = null,
    Object? specifications = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      dishId: null == dishId
          ? _value.dishId
          : dishId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      itemTotal: null == itemTotal
          ? _value.itemTotal
          : itemTotal // ignore: cast_nullable_to_non_nullable
              as double,
      specifications: freezed == specifications
          ? _value.specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartOrderItemImplCopyWith<$Res>
    implements $CartOrderItemCopyWith<$Res> {
  factory _$$CartOrderItemImplCopyWith(
          _$CartOrderItemImpl value, $Res Function(_$CartOrderItemImpl) then) =
      __$$CartOrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String dishId,
      String name,
      double price,
      int quantity,
      double itemTotal,
      String? specifications,
      String? imageUrl});
}

/// @nodoc
class __$$CartOrderItemImplCopyWithImpl<$Res>
    extends _$CartOrderItemCopyWithImpl<$Res, _$CartOrderItemImpl>
    implements _$$CartOrderItemImplCopyWith<$Res> {
  __$$CartOrderItemImplCopyWithImpl(
      _$CartOrderItemImpl _value, $Res Function(_$CartOrderItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dishId = null,
    Object? name = null,
    Object? price = null,
    Object? quantity = null,
    Object? itemTotal = null,
    Object? specifications = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_$CartOrderItemImpl(
      dishId: null == dishId
          ? _value.dishId
          : dishId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      itemTotal: null == itemTotal
          ? _value.itemTotal
          : itemTotal // ignore: cast_nullable_to_non_nullable
              as double,
      specifications: freezed == specifications
          ? _value.specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CartOrderItemImpl implements _CartOrderItem {
  const _$CartOrderItemImpl(
      {required this.dishId,
      required this.name,
      required this.price,
      required this.quantity,
      required this.itemTotal,
      this.specifications,
      this.imageUrl});

  @override
  final String dishId;
  @override
  final String name;
  @override
  final double price;
  @override
  final int quantity;
  @override
  final double itemTotal;
  @override
  final String? specifications;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'CartOrderItem(dishId: $dishId, name: $name, price: $price, quantity: $quantity, itemTotal: $itemTotal, specifications: $specifications, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartOrderItemImpl &&
            (identical(other.dishId, dishId) || other.dishId == dishId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.itemTotal, itemTotal) ||
                other.itemTotal == itemTotal) &&
            (identical(other.specifications, specifications) ||
                other.specifications == specifications) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dishId, name, price, quantity,
      itemTotal, specifications, imageUrl);

  /// Create a copy of CartOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartOrderItemImplCopyWith<_$CartOrderItemImpl> get copyWith =>
      __$$CartOrderItemImplCopyWithImpl<_$CartOrderItemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CartOrderItem value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CartOrderItem value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CartOrderItem value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _CartOrderItem implements CartOrderItem {
  const factory _CartOrderItem(
      {required final String dishId,
      required final String name,
      required final double price,
      required final int quantity,
      required final double itemTotal,
      final String? specifications,
      final String? imageUrl}) = _$CartOrderItemImpl;

  @override
  String get dishId;
  @override
  String get name;
  @override
  double get price;
  @override
  int get quantity;
  @override
  double get itemTotal;
  @override
  String? get specifications;
  @override
  String? get imageUrl;

  /// Create a copy of CartOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartOrderItemImplCopyWith<_$CartOrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrderPriceDetails {
  double get subtotal => throw _privateConstructorUsedError;
  double get serviceCharge => throw _privateConstructorUsedError;
  double get tax => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  double? get discount => throw _privateConstructorUsedError;
  String? get couponCode => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderPriceDetails value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderPriceDetails value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderPriceDetails value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of OrderPriceDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderPriceDetailsCopyWith<OrderPriceDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderPriceDetailsCopyWith<$Res> {
  factory $OrderPriceDetailsCopyWith(
          OrderPriceDetails value, $Res Function(OrderPriceDetails) then) =
      _$OrderPriceDetailsCopyWithImpl<$Res, OrderPriceDetails>;
  @useResult
  $Res call(
      {double subtotal,
      double serviceCharge,
      double tax,
      double total,
      double? discount,
      String? couponCode});
}

/// @nodoc
class _$OrderPriceDetailsCopyWithImpl<$Res, $Val extends OrderPriceDetails>
    implements $OrderPriceDetailsCopyWith<$Res> {
  _$OrderPriceDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderPriceDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? serviceCharge = null,
    Object? tax = null,
    Object? total = null,
    Object? discount = freezed,
    Object? couponCode = freezed,
  }) {
    return _then(_value.copyWith(
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      serviceCharge: null == serviceCharge
          ? _value.serviceCharge
          : serviceCharge // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double?,
      couponCode: freezed == couponCode
          ? _value.couponCode
          : couponCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderPriceDetailsImplCopyWith<$Res>
    implements $OrderPriceDetailsCopyWith<$Res> {
  factory _$$OrderPriceDetailsImplCopyWith(_$OrderPriceDetailsImpl value,
          $Res Function(_$OrderPriceDetailsImpl) then) =
      __$$OrderPriceDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double subtotal,
      double serviceCharge,
      double tax,
      double total,
      double? discount,
      String? couponCode});
}

/// @nodoc
class __$$OrderPriceDetailsImplCopyWithImpl<$Res>
    extends _$OrderPriceDetailsCopyWithImpl<$Res, _$OrderPriceDetailsImpl>
    implements _$$OrderPriceDetailsImplCopyWith<$Res> {
  __$$OrderPriceDetailsImplCopyWithImpl(_$OrderPriceDetailsImpl _value,
      $Res Function(_$OrderPriceDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderPriceDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? serviceCharge = null,
    Object? tax = null,
    Object? total = null,
    Object? discount = freezed,
    Object? couponCode = freezed,
  }) {
    return _then(_$OrderPriceDetailsImpl(
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      serviceCharge: null == serviceCharge
          ? _value.serviceCharge
          : serviceCharge // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double?,
      couponCode: freezed == couponCode
          ? _value.couponCode
          : couponCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OrderPriceDetailsImpl implements _OrderPriceDetails {
  const _$OrderPriceDetailsImpl(
      {required this.subtotal,
      required this.serviceCharge,
      required this.tax,
      required this.total,
      this.discount,
      this.couponCode});

  @override
  final double subtotal;
  @override
  final double serviceCharge;
  @override
  final double tax;
  @override
  final double total;
  @override
  final double? discount;
  @override
  final String? couponCode;

  @override
  String toString() {
    return 'OrderPriceDetails(subtotal: $subtotal, serviceCharge: $serviceCharge, tax: $tax, total: $total, discount: $discount, couponCode: $couponCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderPriceDetailsImpl &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.serviceCharge, serviceCharge) ||
                other.serviceCharge == serviceCharge) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.couponCode, couponCode) ||
                other.couponCode == couponCode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, subtotal, serviceCharge, tax, total, discount, couponCode);

  /// Create a copy of OrderPriceDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderPriceDetailsImplCopyWith<_$OrderPriceDetailsImpl> get copyWith =>
      __$$OrderPriceDetailsImplCopyWithImpl<_$OrderPriceDetailsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderPriceDetails value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderPriceDetails value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderPriceDetails value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _OrderPriceDetails implements OrderPriceDetails {
  const factory _OrderPriceDetails(
      {required final double subtotal,
      required final double serviceCharge,
      required final double tax,
      required final double total,
      final double? discount,
      final String? couponCode}) = _$OrderPriceDetailsImpl;

  @override
  double get subtotal;
  @override
  double get serviceCharge;
  @override
  double get tax;
  @override
  double get total;
  @override
  double? get discount;
  @override
  String? get couponCode;

  /// Create a copy of OrderPriceDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderPriceDetailsImplCopyWith<_$OrderPriceDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrderPayment {
  String get method =>
      throw _privateConstructorUsedError; // 'cash', 'wechat', 'alipay'
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'paid', 'failed'
  String? get transactionId => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderPayment value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderPayment value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderPayment value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderPaymentCopyWith<OrderPayment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderPaymentCopyWith<$Res> {
  factory $OrderPaymentCopyWith(
          OrderPayment value, $Res Function(OrderPayment) then) =
      _$OrderPaymentCopyWithImpl<$Res, OrderPayment>;
  @useResult
  $Res call(
      {String method, String status, String? transactionId, DateTime? paidAt});
}

/// @nodoc
class _$OrderPaymentCopyWithImpl<$Res, $Val extends OrderPayment>
    implements $OrderPaymentCopyWith<$Res> {
  _$OrderPaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? status = null,
    Object? transactionId = freezed,
    Object? paidAt = freezed,
  }) {
    return _then(_value.copyWith(
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderPaymentImplCopyWith<$Res>
    implements $OrderPaymentCopyWith<$Res> {
  factory _$$OrderPaymentImplCopyWith(
          _$OrderPaymentImpl value, $Res Function(_$OrderPaymentImpl) then) =
      __$$OrderPaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String method, String status, String? transactionId, DateTime? paidAt});
}

/// @nodoc
class __$$OrderPaymentImplCopyWithImpl<$Res>
    extends _$OrderPaymentCopyWithImpl<$Res, _$OrderPaymentImpl>
    implements _$$OrderPaymentImplCopyWith<$Res> {
  __$$OrderPaymentImplCopyWithImpl(
      _$OrderPaymentImpl _value, $Res Function(_$OrderPaymentImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? status = null,
    Object? transactionId = freezed,
    Object? paidAt = freezed,
  }) {
    return _then(_$OrderPaymentImpl(
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$OrderPaymentImpl implements _OrderPayment {
  const _$OrderPaymentImpl(
      {required this.method,
      required this.status,
      this.transactionId,
      this.paidAt});

  @override
  final String method;
// 'cash', 'wechat', 'alipay'
  @override
  final String status;
// 'pending', 'paid', 'failed'
  @override
  final String? transactionId;
  @override
  final DateTime? paidAt;

  @override
  String toString() {
    return 'OrderPayment(method: $method, status: $status, transactionId: $transactionId, paidAt: $paidAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderPaymentImpl &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, method, status, transactionId, paidAt);

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderPaymentImplCopyWith<_$OrderPaymentImpl> get copyWith =>
      __$$OrderPaymentImplCopyWithImpl<_$OrderPaymentImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderPayment value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderPayment value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderPayment value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _OrderPayment implements OrderPayment {
  const factory _OrderPayment(
      {required final String method,
      required final String status,
      final String? transactionId,
      final DateTime? paidAt}) = _$OrderPaymentImpl;

  @override
  String get method; // 'cash', 'wechat', 'alipay'
  @override
  String get status; // 'pending', 'paid', 'failed'
  @override
  String? get transactionId;
  @override
  DateTime? get paidAt;

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderPaymentImplCopyWith<_$OrderPaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CartOrder {
  String? get id => throw _privateConstructorUsedError;
  String? get orderNumber => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get merchantId => throw _privateConstructorUsedError;
  List<CartOrderItem> get items => throw _privateConstructorUsedError;
  OrderPriceDetails get priceDetails => throw _privateConstructorUsedError;
  OrderPayment get payment => throw _privateConstructorUsedError;
  String get orderType =>
      throw _privateConstructorUsedError; // 'dine_in', 'takeaway'
  String? get tableNumber => throw _privateConstructorUsedError;
  String? get specialNotes => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'confirmed', 'preparing', 'ready', 'completed', 'cancelled'
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get estimatedTime => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CartOrder value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CartOrder value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CartOrder value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of CartOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartOrderCopyWith<CartOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartOrderCopyWith<$Res> {
  factory $CartOrderCopyWith(CartOrder value, $Res Function(CartOrder) then) =
      _$CartOrderCopyWithImpl<$Res, CartOrder>;
  @useResult
  $Res call(
      {String? id,
      String? orderNumber,
      String userId,
      String merchantId,
      List<CartOrderItem> items,
      OrderPriceDetails priceDetails,
      OrderPayment payment,
      String orderType,
      String? tableNumber,
      String? specialNotes,
      String status,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? estimatedTime});

  $OrderPriceDetailsCopyWith<$Res> get priceDetails;
  $OrderPaymentCopyWith<$Res> get payment;
}

/// @nodoc
class _$CartOrderCopyWithImpl<$Res, $Val extends CartOrder>
    implements $CartOrderCopyWith<$Res> {
  _$CartOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderNumber = freezed,
    Object? userId = null,
    Object? merchantId = null,
    Object? items = null,
    Object? priceDetails = null,
    Object? payment = null,
    Object? orderType = null,
    Object? tableNumber = freezed,
    Object? specialNotes = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? estimatedTime = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      orderNumber: freezed == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartOrderItem>,
      priceDetails: null == priceDetails
          ? _value.priceDetails
          : priceDetails // ignore: cast_nullable_to_non_nullable
              as OrderPriceDetails,
      payment: null == payment
          ? _value.payment
          : payment // ignore: cast_nullable_to_non_nullable
              as OrderPayment,
      orderType: null == orderType
          ? _value.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as String,
      tableNumber: freezed == tableNumber
          ? _value.tableNumber
          : tableNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      specialNotes: freezed == specialNotes
          ? _value.specialNotes
          : specialNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedTime: freezed == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of CartOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderPriceDetailsCopyWith<$Res> get priceDetails {
    return $OrderPriceDetailsCopyWith<$Res>(_value.priceDetails, (value) {
      return _then(_value.copyWith(priceDetails: value) as $Val);
    });
  }

  /// Create a copy of CartOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderPaymentCopyWith<$Res> get payment {
    return $OrderPaymentCopyWith<$Res>(_value.payment, (value) {
      return _then(_value.copyWith(payment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CartOrderImplCopyWith<$Res>
    implements $CartOrderCopyWith<$Res> {
  factory _$$CartOrderImplCopyWith(
          _$CartOrderImpl value, $Res Function(_$CartOrderImpl) then) =
      __$$CartOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? orderNumber,
      String userId,
      String merchantId,
      List<CartOrderItem> items,
      OrderPriceDetails priceDetails,
      OrderPayment payment,
      String orderType,
      String? tableNumber,
      String? specialNotes,
      String status,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? estimatedTime});

  @override
  $OrderPriceDetailsCopyWith<$Res> get priceDetails;
  @override
  $OrderPaymentCopyWith<$Res> get payment;
}

/// @nodoc
class __$$CartOrderImplCopyWithImpl<$Res>
    extends _$CartOrderCopyWithImpl<$Res, _$CartOrderImpl>
    implements _$$CartOrderImplCopyWith<$Res> {
  __$$CartOrderImplCopyWithImpl(
      _$CartOrderImpl _value, $Res Function(_$CartOrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderNumber = freezed,
    Object? userId = null,
    Object? merchantId = null,
    Object? items = null,
    Object? priceDetails = null,
    Object? payment = null,
    Object? orderType = null,
    Object? tableNumber = freezed,
    Object? specialNotes = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? estimatedTime = freezed,
  }) {
    return _then(_$CartOrderImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      orderNumber: freezed == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartOrderItem>,
      priceDetails: null == priceDetails
          ? _value.priceDetails
          : priceDetails // ignore: cast_nullable_to_non_nullable
              as OrderPriceDetails,
      payment: null == payment
          ? _value.payment
          : payment // ignore: cast_nullable_to_non_nullable
              as OrderPayment,
      orderType: null == orderType
          ? _value.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as String,
      tableNumber: freezed == tableNumber
          ? _value.tableNumber
          : tableNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      specialNotes: freezed == specialNotes
          ? _value.specialNotes
          : specialNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedTime: freezed == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CartOrderImpl extends _CartOrder {
  const _$CartOrderImpl(
      {this.id,
      this.orderNumber,
      required this.userId,
      required this.merchantId,
      required final List<CartOrderItem> items,
      required this.priceDetails,
      required this.payment,
      required this.orderType,
      this.tableNumber,
      this.specialNotes,
      required this.status,
      this.createdAt,
      this.updatedAt,
      this.estimatedTime})
      : _items = items,
        super._();

  @override
  final String? id;
  @override
  final String? orderNumber;
  @override
  final String userId;
  @override
  final String merchantId;
  final List<CartOrderItem> _items;
  @override
  List<CartOrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final OrderPriceDetails priceDetails;
  @override
  final OrderPayment payment;
  @override
  final String orderType;
// 'dine_in', 'takeaway'
  @override
  final String? tableNumber;
  @override
  final String? specialNotes;
  @override
  final String status;
// 'pending', 'confirmed', 'preparing', 'ready', 'completed', 'cancelled'
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? estimatedTime;

  @override
  String toString() {
    return 'CartOrder(id: $id, orderNumber: $orderNumber, userId: $userId, merchantId: $merchantId, items: $items, priceDetails: $priceDetails, payment: $payment, orderType: $orderType, tableNumber: $tableNumber, specialNotes: $specialNotes, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, estimatedTime: $estimatedTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.priceDetails, priceDetails) ||
                other.priceDetails == priceDetails) &&
            (identical(other.payment, payment) || other.payment == payment) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.tableNumber, tableNumber) ||
                other.tableNumber == tableNumber) &&
            (identical(other.specialNotes, specialNotes) ||
                other.specialNotes == specialNotes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.estimatedTime, estimatedTime) ||
                other.estimatedTime == estimatedTime));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderNumber,
      userId,
      merchantId,
      const DeepCollectionEquality().hash(_items),
      priceDetails,
      payment,
      orderType,
      tableNumber,
      specialNotes,
      status,
      createdAt,
      updatedAt,
      estimatedTime);

  /// Create a copy of CartOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartOrderImplCopyWith<_$CartOrderImpl> get copyWith =>
      __$$CartOrderImplCopyWithImpl<_$CartOrderImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CartOrder value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CartOrder value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CartOrder value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _CartOrder extends CartOrder {
  const factory _CartOrder(
      {final String? id,
      final String? orderNumber,
      required final String userId,
      required final String merchantId,
      required final List<CartOrderItem> items,
      required final OrderPriceDetails priceDetails,
      required final OrderPayment payment,
      required final String orderType,
      final String? tableNumber,
      final String? specialNotes,
      required final String status,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? estimatedTime}) = _$CartOrderImpl;
  const _CartOrder._() : super._();

  @override
  String? get id;
  @override
  String? get orderNumber;
  @override
  String get userId;
  @override
  String get merchantId;
  @override
  List<CartOrderItem> get items;
  @override
  OrderPriceDetails get priceDetails;
  @override
  OrderPayment get payment;
  @override
  String get orderType; // 'dine_in', 'takeaway'
  @override
  String? get tableNumber;
  @override
  String? get specialNotes;
  @override
  String
      get status; // 'pending', 'confirmed', 'preparing', 'ready', 'completed', 'cancelled'
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get estimatedTime;

  /// Create a copy of CartOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartOrderImplCopyWith<_$CartOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
