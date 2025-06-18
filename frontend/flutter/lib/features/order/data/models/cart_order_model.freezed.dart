// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CartOrderItemModel _$CartOrderItemModelFromJson(Map<String, dynamic> json) {
  return _CartOrderItemModel.fromJson(json);
}

/// @nodoc
mixin _$CartOrderItemModel {
  String get dishId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get itemTotal => throw _privateConstructorUsedError;
  String? get specifications => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CartOrderItemModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CartOrderItemModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CartOrderItemModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this CartOrderItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartOrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartOrderItemModelCopyWith<CartOrderItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartOrderItemModelCopyWith<$Res> {
  factory $CartOrderItemModelCopyWith(
          CartOrderItemModel value, $Res Function(CartOrderItemModel) then) =
      _$CartOrderItemModelCopyWithImpl<$Res, CartOrderItemModel>;
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
class _$CartOrderItemModelCopyWithImpl<$Res, $Val extends CartOrderItemModel>
    implements $CartOrderItemModelCopyWith<$Res> {
  _$CartOrderItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartOrderItemModel
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
abstract class _$$CartOrderItemModelImplCopyWith<$Res>
    implements $CartOrderItemModelCopyWith<$Res> {
  factory _$$CartOrderItemModelImplCopyWith(_$CartOrderItemModelImpl value,
          $Res Function(_$CartOrderItemModelImpl) then) =
      __$$CartOrderItemModelImplCopyWithImpl<$Res>;
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
class __$$CartOrderItemModelImplCopyWithImpl<$Res>
    extends _$CartOrderItemModelCopyWithImpl<$Res, _$CartOrderItemModelImpl>
    implements _$$CartOrderItemModelImplCopyWith<$Res> {
  __$$CartOrderItemModelImplCopyWithImpl(_$CartOrderItemModelImpl _value,
      $Res Function(_$CartOrderItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartOrderItemModel
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
    return _then(_$CartOrderItemModelImpl(
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
@JsonSerializable()
class _$CartOrderItemModelImpl extends _CartOrderItemModel {
  const _$CartOrderItemModelImpl(
      {required this.dishId,
      required this.name,
      required this.price,
      required this.quantity,
      required this.itemTotal,
      this.specifications,
      this.imageUrl})
      : super._();

  factory _$CartOrderItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartOrderItemModelImplFromJson(json);

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
    return 'CartOrderItemModel(dishId: $dishId, name: $name, price: $price, quantity: $quantity, itemTotal: $itemTotal, specifications: $specifications, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartOrderItemModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dishId, name, price, quantity,
      itemTotal, specifications, imageUrl);

  /// Create a copy of CartOrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartOrderItemModelImplCopyWith<_$CartOrderItemModelImpl> get copyWith =>
      __$$CartOrderItemModelImplCopyWithImpl<_$CartOrderItemModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CartOrderItemModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CartOrderItemModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CartOrderItemModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CartOrderItemModelImplToJson(
      this,
    );
  }
}

abstract class _CartOrderItemModel extends CartOrderItemModel {
  const factory _CartOrderItemModel(
      {required final String dishId,
      required final String name,
      required final double price,
      required final int quantity,
      required final double itemTotal,
      final String? specifications,
      final String? imageUrl}) = _$CartOrderItemModelImpl;
  const _CartOrderItemModel._() : super._();

  factory _CartOrderItemModel.fromJson(Map<String, dynamic> json) =
      _$CartOrderItemModelImpl.fromJson;

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

  /// Create a copy of CartOrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartOrderItemModelImplCopyWith<_$CartOrderItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderPriceDetailsModel _$OrderPriceDetailsModelFromJson(
    Map<String, dynamic> json) {
  return _OrderPriceDetailsModel.fromJson(json);
}

/// @nodoc
mixin _$OrderPriceDetailsModel {
  double get subtotal => throw _privateConstructorUsedError;
  double get serviceCharge => throw _privateConstructorUsedError;
  double get tax => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  double? get discount => throw _privateConstructorUsedError;
  String? get couponCode => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderPriceDetailsModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderPriceDetailsModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderPriceDetailsModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderPriceDetailsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderPriceDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderPriceDetailsModelCopyWith<OrderPriceDetailsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderPriceDetailsModelCopyWith<$Res> {
  factory $OrderPriceDetailsModelCopyWith(OrderPriceDetailsModel value,
          $Res Function(OrderPriceDetailsModel) then) =
      _$OrderPriceDetailsModelCopyWithImpl<$Res, OrderPriceDetailsModel>;
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
class _$OrderPriceDetailsModelCopyWithImpl<$Res,
        $Val extends OrderPriceDetailsModel>
    implements $OrderPriceDetailsModelCopyWith<$Res> {
  _$OrderPriceDetailsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderPriceDetailsModel
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
abstract class _$$OrderPriceDetailsModelImplCopyWith<$Res>
    implements $OrderPriceDetailsModelCopyWith<$Res> {
  factory _$$OrderPriceDetailsModelImplCopyWith(
          _$OrderPriceDetailsModelImpl value,
          $Res Function(_$OrderPriceDetailsModelImpl) then) =
      __$$OrderPriceDetailsModelImplCopyWithImpl<$Res>;
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
class __$$OrderPriceDetailsModelImplCopyWithImpl<$Res>
    extends _$OrderPriceDetailsModelCopyWithImpl<$Res,
        _$OrderPriceDetailsModelImpl>
    implements _$$OrderPriceDetailsModelImplCopyWith<$Res> {
  __$$OrderPriceDetailsModelImplCopyWithImpl(
      _$OrderPriceDetailsModelImpl _value,
      $Res Function(_$OrderPriceDetailsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderPriceDetailsModel
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
    return _then(_$OrderPriceDetailsModelImpl(
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
@JsonSerializable()
class _$OrderPriceDetailsModelImpl extends _OrderPriceDetailsModel {
  const _$OrderPriceDetailsModelImpl(
      {required this.subtotal,
      required this.serviceCharge,
      required this.tax,
      required this.total,
      this.discount,
      this.couponCode})
      : super._();

  factory _$OrderPriceDetailsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderPriceDetailsModelImplFromJson(json);

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
    return 'OrderPriceDetailsModel(subtotal: $subtotal, serviceCharge: $serviceCharge, tax: $tax, total: $total, discount: $discount, couponCode: $couponCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderPriceDetailsModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, subtotal, serviceCharge, tax, total, discount, couponCode);

  /// Create a copy of OrderPriceDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderPriceDetailsModelImplCopyWith<_$OrderPriceDetailsModelImpl>
      get copyWith => __$$OrderPriceDetailsModelImplCopyWithImpl<
          _$OrderPriceDetailsModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderPriceDetailsModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderPriceDetailsModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderPriceDetailsModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderPriceDetailsModelImplToJson(
      this,
    );
  }
}

abstract class _OrderPriceDetailsModel extends OrderPriceDetailsModel {
  const factory _OrderPriceDetailsModel(
      {required final double subtotal,
      required final double serviceCharge,
      required final double tax,
      required final double total,
      final double? discount,
      final String? couponCode}) = _$OrderPriceDetailsModelImpl;
  const _OrderPriceDetailsModel._() : super._();

  factory _OrderPriceDetailsModel.fromJson(Map<String, dynamic> json) =
      _$OrderPriceDetailsModelImpl.fromJson;

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

  /// Create a copy of OrderPriceDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderPriceDetailsModelImplCopyWith<_$OrderPriceDetailsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OrderPaymentModel _$OrderPaymentModelFromJson(Map<String, dynamic> json) {
  return _OrderPaymentModel.fromJson(json);
}

/// @nodoc
mixin _$OrderPaymentModel {
  String get method => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get transactionId => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderPaymentModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderPaymentModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderPaymentModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderPaymentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderPaymentModelCopyWith<OrderPaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderPaymentModelCopyWith<$Res> {
  factory $OrderPaymentModelCopyWith(
          OrderPaymentModel value, $Res Function(OrderPaymentModel) then) =
      _$OrderPaymentModelCopyWithImpl<$Res, OrderPaymentModel>;
  @useResult
  $Res call(
      {String method, String status, String? transactionId, DateTime? paidAt});
}

/// @nodoc
class _$OrderPaymentModelCopyWithImpl<$Res, $Val extends OrderPaymentModel>
    implements $OrderPaymentModelCopyWith<$Res> {
  _$OrderPaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderPaymentModel
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
abstract class _$$OrderPaymentModelImplCopyWith<$Res>
    implements $OrderPaymentModelCopyWith<$Res> {
  factory _$$OrderPaymentModelImplCopyWith(_$OrderPaymentModelImpl value,
          $Res Function(_$OrderPaymentModelImpl) then) =
      __$$OrderPaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String method, String status, String? transactionId, DateTime? paidAt});
}

/// @nodoc
class __$$OrderPaymentModelImplCopyWithImpl<$Res>
    extends _$OrderPaymentModelCopyWithImpl<$Res, _$OrderPaymentModelImpl>
    implements _$$OrderPaymentModelImplCopyWith<$Res> {
  __$$OrderPaymentModelImplCopyWithImpl(_$OrderPaymentModelImpl _value,
      $Res Function(_$OrderPaymentModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? status = null,
    Object? transactionId = freezed,
    Object? paidAt = freezed,
  }) {
    return _then(_$OrderPaymentModelImpl(
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
@JsonSerializable()
class _$OrderPaymentModelImpl extends _OrderPaymentModel {
  const _$OrderPaymentModelImpl(
      {required this.method,
      required this.status,
      this.transactionId,
      this.paidAt})
      : super._();

  factory _$OrderPaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderPaymentModelImplFromJson(json);

  @override
  final String method;
  @override
  final String status;
  @override
  final String? transactionId;
  @override
  final DateTime? paidAt;

  @override
  String toString() {
    return 'OrderPaymentModel(method: $method, status: $status, transactionId: $transactionId, paidAt: $paidAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderPaymentModelImpl &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, method, status, transactionId, paidAt);

  /// Create a copy of OrderPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderPaymentModelImplCopyWith<_$OrderPaymentModelImpl> get copyWith =>
      __$$OrderPaymentModelImplCopyWithImpl<_$OrderPaymentModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderPaymentModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderPaymentModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderPaymentModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderPaymentModelImplToJson(
      this,
    );
  }
}

abstract class _OrderPaymentModel extends OrderPaymentModel {
  const factory _OrderPaymentModel(
      {required final String method,
      required final String status,
      final String? transactionId,
      final DateTime? paidAt}) = _$OrderPaymentModelImpl;
  const _OrderPaymentModel._() : super._();

  factory _OrderPaymentModel.fromJson(Map<String, dynamic> json) =
      _$OrderPaymentModelImpl.fromJson;

  @override
  String get method;
  @override
  String get status;
  @override
  String? get transactionId;
  @override
  DateTime? get paidAt;

  /// Create a copy of OrderPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderPaymentModelImplCopyWith<_$OrderPaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartOrderModel _$CartOrderModelFromJson(Map<String, dynamic> json) {
  return _CartOrderModel.fromJson(json);
}

/// @nodoc
mixin _$CartOrderModel {
  String? get id => throw _privateConstructorUsedError;
  String? get orderNumber => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get merchantId => throw _privateConstructorUsedError;
  List<CartOrderItemModel> get items => throw _privateConstructorUsedError;
  OrderPriceDetailsModel get priceDetails => throw _privateConstructorUsedError;
  OrderPaymentModel get payment => throw _privateConstructorUsedError;
  String get orderType => throw _privateConstructorUsedError;
  String? get tableNumber => throw _privateConstructorUsedError;
  String? get specialNotes => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get estimatedTime => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CartOrderModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CartOrderModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CartOrderModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this CartOrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartOrderModelCopyWith<CartOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartOrderModelCopyWith<$Res> {
  factory $CartOrderModelCopyWith(
          CartOrderModel value, $Res Function(CartOrderModel) then) =
      _$CartOrderModelCopyWithImpl<$Res, CartOrderModel>;
  @useResult
  $Res call(
      {String? id,
      String? orderNumber,
      String userId,
      String merchantId,
      List<CartOrderItemModel> items,
      OrderPriceDetailsModel priceDetails,
      OrderPaymentModel payment,
      String orderType,
      String? tableNumber,
      String? specialNotes,
      String status,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? estimatedTime});

  $OrderPriceDetailsModelCopyWith<$Res> get priceDetails;
  $OrderPaymentModelCopyWith<$Res> get payment;
}

/// @nodoc
class _$CartOrderModelCopyWithImpl<$Res, $Val extends CartOrderModel>
    implements $CartOrderModelCopyWith<$Res> {
  _$CartOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartOrderModel
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
              as List<CartOrderItemModel>,
      priceDetails: null == priceDetails
          ? _value.priceDetails
          : priceDetails // ignore: cast_nullable_to_non_nullable
              as OrderPriceDetailsModel,
      payment: null == payment
          ? _value.payment
          : payment // ignore: cast_nullable_to_non_nullable
              as OrderPaymentModel,
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

  /// Create a copy of CartOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderPriceDetailsModelCopyWith<$Res> get priceDetails {
    return $OrderPriceDetailsModelCopyWith<$Res>(_value.priceDetails, (value) {
      return _then(_value.copyWith(priceDetails: value) as $Val);
    });
  }

  /// Create a copy of CartOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderPaymentModelCopyWith<$Res> get payment {
    return $OrderPaymentModelCopyWith<$Res>(_value.payment, (value) {
      return _then(_value.copyWith(payment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CartOrderModelImplCopyWith<$Res>
    implements $CartOrderModelCopyWith<$Res> {
  factory _$$CartOrderModelImplCopyWith(_$CartOrderModelImpl value,
          $Res Function(_$CartOrderModelImpl) then) =
      __$$CartOrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? orderNumber,
      String userId,
      String merchantId,
      List<CartOrderItemModel> items,
      OrderPriceDetailsModel priceDetails,
      OrderPaymentModel payment,
      String orderType,
      String? tableNumber,
      String? specialNotes,
      String status,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? estimatedTime});

  @override
  $OrderPriceDetailsModelCopyWith<$Res> get priceDetails;
  @override
  $OrderPaymentModelCopyWith<$Res> get payment;
}

/// @nodoc
class __$$CartOrderModelImplCopyWithImpl<$Res>
    extends _$CartOrderModelCopyWithImpl<$Res, _$CartOrderModelImpl>
    implements _$$CartOrderModelImplCopyWith<$Res> {
  __$$CartOrderModelImplCopyWithImpl(
      _$CartOrderModelImpl _value, $Res Function(_$CartOrderModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartOrderModel
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
    return _then(_$CartOrderModelImpl(
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
              as List<CartOrderItemModel>,
      priceDetails: null == priceDetails
          ? _value.priceDetails
          : priceDetails // ignore: cast_nullable_to_non_nullable
              as OrderPriceDetailsModel,
      payment: null == payment
          ? _value.payment
          : payment // ignore: cast_nullable_to_non_nullable
              as OrderPaymentModel,
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
@JsonSerializable()
class _$CartOrderModelImpl extends _CartOrderModel {
  const _$CartOrderModelImpl(
      {this.id,
      this.orderNumber,
      required this.userId,
      required this.merchantId,
      required final List<CartOrderItemModel> items,
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

  factory _$CartOrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartOrderModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String? orderNumber;
  @override
  final String userId;
  @override
  final String merchantId;
  final List<CartOrderItemModel> _items;
  @override
  List<CartOrderItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final OrderPriceDetailsModel priceDetails;
  @override
  final OrderPaymentModel payment;
  @override
  final String orderType;
  @override
  final String? tableNumber;
  @override
  final String? specialNotes;
  @override
  final String status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? estimatedTime;

  @override
  String toString() {
    return 'CartOrderModel(id: $id, orderNumber: $orderNumber, userId: $userId, merchantId: $merchantId, items: $items, priceDetails: $priceDetails, payment: $payment, orderType: $orderType, tableNumber: $tableNumber, specialNotes: $specialNotes, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, estimatedTime: $estimatedTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartOrderModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of CartOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartOrderModelImplCopyWith<_$CartOrderModelImpl> get copyWith =>
      __$$CartOrderModelImplCopyWithImpl<_$CartOrderModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CartOrderModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CartOrderModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CartOrderModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CartOrderModelImplToJson(
      this,
    );
  }
}

abstract class _CartOrderModel extends CartOrderModel {
  const factory _CartOrderModel(
      {final String? id,
      final String? orderNumber,
      required final String userId,
      required final String merchantId,
      required final List<CartOrderItemModel> items,
      required final OrderPriceDetailsModel priceDetails,
      required final OrderPaymentModel payment,
      required final String orderType,
      final String? tableNumber,
      final String? specialNotes,
      required final String status,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? estimatedTime}) = _$CartOrderModelImpl;
  const _CartOrderModel._() : super._();

  factory _CartOrderModel.fromJson(Map<String, dynamic> json) =
      _$CartOrderModelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get orderNumber;
  @override
  String get userId;
  @override
  String get merchantId;
  @override
  List<CartOrderItemModel> get items;
  @override
  OrderPriceDetailsModel get priceDetails;
  @override
  OrderPaymentModel get payment;
  @override
  String get orderType;
  @override
  String? get tableNumber;
  @override
  String? get specialNotes;
  @override
  String get status;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get estimatedTime;

  /// Create a copy of CartOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartOrderModelImplCopyWith<_$CartOrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
