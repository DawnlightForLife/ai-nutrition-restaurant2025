// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_order_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OrderCreationState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  CartOrder? get createdOrder => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderCreationState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderCreationState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderCreationState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of OrderCreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCreationStateCopyWith<OrderCreationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCreationStateCopyWith<$Res> {
  factory $OrderCreationStateCopyWith(
          OrderCreationState value, $Res Function(OrderCreationState) then) =
      _$OrderCreationStateCopyWithImpl<$Res, OrderCreationState>;
  @useResult
  $Res call(
      {bool isLoading, bool isSuccess, CartOrder? createdOrder, String? error});

  $CartOrderCopyWith<$Res>? get createdOrder;
}

/// @nodoc
class _$OrderCreationStateCopyWithImpl<$Res, $Val extends OrderCreationState>
    implements $OrderCreationStateCopyWith<$Res> {
  _$OrderCreationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderCreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? createdOrder = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      createdOrder: freezed == createdOrder
          ? _value.createdOrder
          : createdOrder // ignore: cast_nullable_to_non_nullable
              as CartOrder?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of OrderCreationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartOrderCopyWith<$Res>? get createdOrder {
    if (_value.createdOrder == null) {
      return null;
    }

    return $CartOrderCopyWith<$Res>(_value.createdOrder!, (value) {
      return _then(_value.copyWith(createdOrder: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderCreationStateImplCopyWith<$Res>
    implements $OrderCreationStateCopyWith<$Res> {
  factory _$$OrderCreationStateImplCopyWith(_$OrderCreationStateImpl value,
          $Res Function(_$OrderCreationStateImpl) then) =
      __$$OrderCreationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading, bool isSuccess, CartOrder? createdOrder, String? error});

  @override
  $CartOrderCopyWith<$Res>? get createdOrder;
}

/// @nodoc
class __$$OrderCreationStateImplCopyWithImpl<$Res>
    extends _$OrderCreationStateCopyWithImpl<$Res, _$OrderCreationStateImpl>
    implements _$$OrderCreationStateImplCopyWith<$Res> {
  __$$OrderCreationStateImplCopyWithImpl(_$OrderCreationStateImpl _value,
      $Res Function(_$OrderCreationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderCreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? createdOrder = freezed,
    Object? error = freezed,
  }) {
    return _then(_$OrderCreationStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      createdOrder: freezed == createdOrder
          ? _value.createdOrder
          : createdOrder // ignore: cast_nullable_to_non_nullable
              as CartOrder?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OrderCreationStateImpl implements _OrderCreationState {
  const _$OrderCreationStateImpl(
      {this.isLoading = false,
      this.isSuccess = false,
      this.createdOrder,
      this.error});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSuccess;
  @override
  final CartOrder? createdOrder;
  @override
  final String? error;

  @override
  String toString() {
    return 'OrderCreationState(isLoading: $isLoading, isSuccess: $isSuccess, createdOrder: $createdOrder, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderCreationStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.createdOrder, createdOrder) ||
                other.createdOrder == createdOrder) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, isSuccess, createdOrder, error);

  /// Create a copy of OrderCreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderCreationStateImplCopyWith<_$OrderCreationStateImpl> get copyWith =>
      __$$OrderCreationStateImplCopyWithImpl<_$OrderCreationStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderCreationState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderCreationState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderCreationState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _OrderCreationState implements OrderCreationState {
  const factory _OrderCreationState(
      {final bool isLoading,
      final bool isSuccess,
      final CartOrder? createdOrder,
      final String? error}) = _$OrderCreationStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  CartOrder? get createdOrder;
  @override
  String? get error;

  /// Create a copy of OrderCreationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderCreationStateImplCopyWith<_$OrderCreationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrderListState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<CartOrder> get orders => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderListState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderListState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderListState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of OrderListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderListStateCopyWith<OrderListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderListStateCopyWith<$Res> {
  factory $OrderListStateCopyWith(
          OrderListState value, $Res Function(OrderListState) then) =
      _$OrderListStateCopyWithImpl<$Res, OrderListState>;
  @useResult
  $Res call({bool isLoading, List<CartOrder> orders, String? error});
}

/// @nodoc
class _$OrderListStateCopyWithImpl<$Res, $Val extends OrderListState>
    implements $OrderListStateCopyWith<$Res> {
  _$OrderListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? orders = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      orders: null == orders
          ? _value.orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<CartOrder>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderListStateImplCopyWith<$Res>
    implements $OrderListStateCopyWith<$Res> {
  factory _$$OrderListStateImplCopyWith(_$OrderListStateImpl value,
          $Res Function(_$OrderListStateImpl) then) =
      __$$OrderListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<CartOrder> orders, String? error});
}

/// @nodoc
class __$$OrderListStateImplCopyWithImpl<$Res>
    extends _$OrderListStateCopyWithImpl<$Res, _$OrderListStateImpl>
    implements _$$OrderListStateImplCopyWith<$Res> {
  __$$OrderListStateImplCopyWithImpl(
      _$OrderListStateImpl _value, $Res Function(_$OrderListStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? orders = null,
    Object? error = freezed,
  }) {
    return _then(_$OrderListStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      orders: null == orders
          ? _value._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<CartOrder>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OrderListStateImpl implements _OrderListState {
  const _$OrderListStateImpl(
      {this.isLoading = false,
      final List<CartOrder> orders = const [],
      this.error})
      : _orders = orders;

  @override
  @JsonKey()
  final bool isLoading;
  final List<CartOrder> _orders;
  @override
  @JsonKey()
  List<CartOrder> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  @override
  final String? error;

  @override
  String toString() {
    return 'OrderListState(isLoading: $isLoading, orders: $orders, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderListStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading,
      const DeepCollectionEquality().hash(_orders), error);

  /// Create a copy of OrderListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderListStateImplCopyWith<_$OrderListStateImpl> get copyWith =>
      __$$OrderListStateImplCopyWithImpl<_$OrderListStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderListState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderListState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderListState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _OrderListState implements OrderListState {
  const factory _OrderListState(
      {final bool isLoading,
      final List<CartOrder> orders,
      final String? error}) = _$OrderListStateImpl;

  @override
  bool get isLoading;
  @override
  List<CartOrder> get orders;
  @override
  String? get error;

  /// Create a copy of OrderListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderListStateImplCopyWith<_$OrderListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrderDetailState {
  bool get isLoading => throw _privateConstructorUsedError;
  CartOrder? get order => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderDetailState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderDetailState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderDetailState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderDetailStateCopyWith<OrderDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderDetailStateCopyWith<$Res> {
  factory $OrderDetailStateCopyWith(
          OrderDetailState value, $Res Function(OrderDetailState) then) =
      _$OrderDetailStateCopyWithImpl<$Res, OrderDetailState>;
  @useResult
  $Res call({bool isLoading, CartOrder? order, String? error});

  $CartOrderCopyWith<$Res>? get order;
}

/// @nodoc
class _$OrderDetailStateCopyWithImpl<$Res, $Val extends OrderDetailState>
    implements $OrderDetailStateCopyWith<$Res> {
  _$OrderDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? order = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      order: freezed == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as CartOrder?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartOrderCopyWith<$Res>? get order {
    if (_value.order == null) {
      return null;
    }

    return $CartOrderCopyWith<$Res>(_value.order!, (value) {
      return _then(_value.copyWith(order: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderDetailStateImplCopyWith<$Res>
    implements $OrderDetailStateCopyWith<$Res> {
  factory _$$OrderDetailStateImplCopyWith(_$OrderDetailStateImpl value,
          $Res Function(_$OrderDetailStateImpl) then) =
      __$$OrderDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, CartOrder? order, String? error});

  @override
  $CartOrderCopyWith<$Res>? get order;
}

/// @nodoc
class __$$OrderDetailStateImplCopyWithImpl<$Res>
    extends _$OrderDetailStateCopyWithImpl<$Res, _$OrderDetailStateImpl>
    implements _$$OrderDetailStateImplCopyWith<$Res> {
  __$$OrderDetailStateImplCopyWithImpl(_$OrderDetailStateImpl _value,
      $Res Function(_$OrderDetailStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? order = freezed,
    Object? error = freezed,
  }) {
    return _then(_$OrderDetailStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      order: freezed == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as CartOrder?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OrderDetailStateImpl implements _OrderDetailState {
  const _$OrderDetailStateImpl(
      {this.isLoading = false, this.order, this.error});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final CartOrder? order;
  @override
  final String? error;

  @override
  String toString() {
    return 'OrderDetailState(isLoading: $isLoading, order: $order, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderDetailStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, order, error);

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderDetailStateImplCopyWith<_$OrderDetailStateImpl> get copyWith =>
      __$$OrderDetailStateImplCopyWithImpl<_$OrderDetailStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OrderDetailState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OrderDetailState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OrderDetailState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _OrderDetailState implements OrderDetailState {
  const factory _OrderDetailState(
      {final bool isLoading,
      final CartOrder? order,
      final String? error}) = _$OrderDetailStateImpl;

  @override
  bool get isLoading;
  @override
  CartOrder? get order;
  @override
  String? get error;

  /// Create a copy of OrderDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderDetailStateImplCopyWith<_$OrderDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
