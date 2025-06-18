// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrition_order_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NutritionOrderState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isCreating => throw _privateConstructorUsedError;
  bool get isUpdating => throw _privateConstructorUsedError;
  List<NutritionOrder> get orders => throw _privateConstructorUsedError;
  NutritionOrder? get currentOrder => throw _privateConstructorUsedError;
  NutritionOrderAnalysis? get currentAnalysis =>
      throw _privateConstructorUsedError;
  PaymentInfo? get paymentInfo => throw _privateConstructorUsedError;
  DeliveryInfo? get deliveryInfo => throw _privateConstructorUsedError;
  OrderReview? get orderReview => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError; // 筛选和搜索状态
  String get searchQuery => throw _privateConstructorUsedError;
  String? get statusFilter => throw _privateConstructorUsedError;
  DateTime? get startDateFilter => throw _privateConstructorUsedError;
  DateTime? get endDateFilter => throw _privateConstructorUsedError;
  bool get showOnlyNutritionOrders =>
      throw _privateConstructorUsedError; // 分页状态
  int get currentPage => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError; // 统计数据
  Map<String, dynamic> get orderStatistics =>
      throw _privateConstructorUsedError;
  Map<String, double> get nutritionTrends =>
      throw _privateConstructorUsedError; // 实时状态
  Map<String, String> get orderStatusUpdates =>
      throw _privateConstructorUsedError;
  Map<String, String> get deliveryStatusUpdates =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionOrderState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionOrderState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionOrderState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of NutritionOrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionOrderStateCopyWith<NutritionOrderState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionOrderStateCopyWith<$Res> {
  factory $NutritionOrderStateCopyWith(
          NutritionOrderState value, $Res Function(NutritionOrderState) then) =
      _$NutritionOrderStateCopyWithImpl<$Res, NutritionOrderState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isCreating,
      bool isUpdating,
      List<NutritionOrder> orders,
      NutritionOrder? currentOrder,
      NutritionOrderAnalysis? currentAnalysis,
      PaymentInfo? paymentInfo,
      DeliveryInfo? deliveryInfo,
      OrderReview? orderReview,
      String? error,
      String searchQuery,
      String? statusFilter,
      DateTime? startDateFilter,
      DateTime? endDateFilter,
      bool showOnlyNutritionOrders,
      int currentPage,
      int pageSize,
      bool hasMore,
      Map<String, dynamic> orderStatistics,
      Map<String, double> nutritionTrends,
      Map<String, String> orderStatusUpdates,
      Map<String, String> deliveryStatusUpdates});

  $NutritionOrderCopyWith<$Res>? get currentOrder;
  $NutritionOrderAnalysisCopyWith<$Res>? get currentAnalysis;
  $PaymentInfoCopyWith<$Res>? get paymentInfo;
  $DeliveryInfoCopyWith<$Res>? get deliveryInfo;
  $OrderReviewCopyWith<$Res>? get orderReview;
}

/// @nodoc
class _$NutritionOrderStateCopyWithImpl<$Res, $Val extends NutritionOrderState>
    implements $NutritionOrderStateCopyWith<$Res> {
  _$NutritionOrderStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionOrderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isCreating = null,
    Object? isUpdating = null,
    Object? orders = null,
    Object? currentOrder = freezed,
    Object? currentAnalysis = freezed,
    Object? paymentInfo = freezed,
    Object? deliveryInfo = freezed,
    Object? orderReview = freezed,
    Object? error = freezed,
    Object? searchQuery = null,
    Object? statusFilter = freezed,
    Object? startDateFilter = freezed,
    Object? endDateFilter = freezed,
    Object? showOnlyNutritionOrders = null,
    Object? currentPage = null,
    Object? pageSize = null,
    Object? hasMore = null,
    Object? orderStatistics = null,
    Object? nutritionTrends = null,
    Object? orderStatusUpdates = null,
    Object? deliveryStatusUpdates = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      orders: null == orders
          ? _value.orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<NutritionOrder>,
      currentOrder: freezed == currentOrder
          ? _value.currentOrder
          : currentOrder // ignore: cast_nullable_to_non_nullable
              as NutritionOrder?,
      currentAnalysis: freezed == currentAnalysis
          ? _value.currentAnalysis
          : currentAnalysis // ignore: cast_nullable_to_non_nullable
              as NutritionOrderAnalysis?,
      paymentInfo: freezed == paymentInfo
          ? _value.paymentInfo
          : paymentInfo // ignore: cast_nullable_to_non_nullable
              as PaymentInfo?,
      deliveryInfo: freezed == deliveryInfo
          ? _value.deliveryInfo
          : deliveryInfo // ignore: cast_nullable_to_non_nullable
              as DeliveryInfo?,
      orderReview: freezed == orderReview
          ? _value.orderReview
          : orderReview // ignore: cast_nullable_to_non_nullable
              as OrderReview?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      statusFilter: freezed == statusFilter
          ? _value.statusFilter
          : statusFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      startDateFilter: freezed == startDateFilter
          ? _value.startDateFilter
          : startDateFilter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDateFilter: freezed == endDateFilter
          ? _value.endDateFilter
          : endDateFilter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      showOnlyNutritionOrders: null == showOnlyNutritionOrders
          ? _value.showOnlyNutritionOrders
          : showOnlyNutritionOrders // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      orderStatistics: null == orderStatistics
          ? _value.orderStatistics
          : orderStatistics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      nutritionTrends: null == nutritionTrends
          ? _value.nutritionTrends
          : nutritionTrends // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      orderStatusUpdates: null == orderStatusUpdates
          ? _value.orderStatusUpdates
          : orderStatusUpdates // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      deliveryStatusUpdates: null == deliveryStatusUpdates
          ? _value.deliveryStatusUpdates
          : deliveryStatusUpdates // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }

  /// Create a copy of NutritionOrderState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionOrderCopyWith<$Res>? get currentOrder {
    if (_value.currentOrder == null) {
      return null;
    }

    return $NutritionOrderCopyWith<$Res>(_value.currentOrder!, (value) {
      return _then(_value.copyWith(currentOrder: value) as $Val);
    });
  }

  /// Create a copy of NutritionOrderState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionOrderAnalysisCopyWith<$Res>? get currentAnalysis {
    if (_value.currentAnalysis == null) {
      return null;
    }

    return $NutritionOrderAnalysisCopyWith<$Res>(_value.currentAnalysis!,
        (value) {
      return _then(_value.copyWith(currentAnalysis: value) as $Val);
    });
  }

  /// Create a copy of NutritionOrderState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentInfoCopyWith<$Res>? get paymentInfo {
    if (_value.paymentInfo == null) {
      return null;
    }

    return $PaymentInfoCopyWith<$Res>(_value.paymentInfo!, (value) {
      return _then(_value.copyWith(paymentInfo: value) as $Val);
    });
  }

  /// Create a copy of NutritionOrderState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeliveryInfoCopyWith<$Res>? get deliveryInfo {
    if (_value.deliveryInfo == null) {
      return null;
    }

    return $DeliveryInfoCopyWith<$Res>(_value.deliveryInfo!, (value) {
      return _then(_value.copyWith(deliveryInfo: value) as $Val);
    });
  }

  /// Create a copy of NutritionOrderState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderReviewCopyWith<$Res>? get orderReview {
    if (_value.orderReview == null) {
      return null;
    }

    return $OrderReviewCopyWith<$Res>(_value.orderReview!, (value) {
      return _then(_value.copyWith(orderReview: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NutritionOrderStateImplCopyWith<$Res>
    implements $NutritionOrderStateCopyWith<$Res> {
  factory _$$NutritionOrderStateImplCopyWith(_$NutritionOrderStateImpl value,
          $Res Function(_$NutritionOrderStateImpl) then) =
      __$$NutritionOrderStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isCreating,
      bool isUpdating,
      List<NutritionOrder> orders,
      NutritionOrder? currentOrder,
      NutritionOrderAnalysis? currentAnalysis,
      PaymentInfo? paymentInfo,
      DeliveryInfo? deliveryInfo,
      OrderReview? orderReview,
      String? error,
      String searchQuery,
      String? statusFilter,
      DateTime? startDateFilter,
      DateTime? endDateFilter,
      bool showOnlyNutritionOrders,
      int currentPage,
      int pageSize,
      bool hasMore,
      Map<String, dynamic> orderStatistics,
      Map<String, double> nutritionTrends,
      Map<String, String> orderStatusUpdates,
      Map<String, String> deliveryStatusUpdates});

  @override
  $NutritionOrderCopyWith<$Res>? get currentOrder;
  @override
  $NutritionOrderAnalysisCopyWith<$Res>? get currentAnalysis;
  @override
  $PaymentInfoCopyWith<$Res>? get paymentInfo;
  @override
  $DeliveryInfoCopyWith<$Res>? get deliveryInfo;
  @override
  $OrderReviewCopyWith<$Res>? get orderReview;
}

/// @nodoc
class __$$NutritionOrderStateImplCopyWithImpl<$Res>
    extends _$NutritionOrderStateCopyWithImpl<$Res, _$NutritionOrderStateImpl>
    implements _$$NutritionOrderStateImplCopyWith<$Res> {
  __$$NutritionOrderStateImplCopyWithImpl(_$NutritionOrderStateImpl _value,
      $Res Function(_$NutritionOrderStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionOrderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isCreating = null,
    Object? isUpdating = null,
    Object? orders = null,
    Object? currentOrder = freezed,
    Object? currentAnalysis = freezed,
    Object? paymentInfo = freezed,
    Object? deliveryInfo = freezed,
    Object? orderReview = freezed,
    Object? error = freezed,
    Object? searchQuery = null,
    Object? statusFilter = freezed,
    Object? startDateFilter = freezed,
    Object? endDateFilter = freezed,
    Object? showOnlyNutritionOrders = null,
    Object? currentPage = null,
    Object? pageSize = null,
    Object? hasMore = null,
    Object? orderStatistics = null,
    Object? nutritionTrends = null,
    Object? orderStatusUpdates = null,
    Object? deliveryStatusUpdates = null,
  }) {
    return _then(_$NutritionOrderStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      orders: null == orders
          ? _value._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<NutritionOrder>,
      currentOrder: freezed == currentOrder
          ? _value.currentOrder
          : currentOrder // ignore: cast_nullable_to_non_nullable
              as NutritionOrder?,
      currentAnalysis: freezed == currentAnalysis
          ? _value.currentAnalysis
          : currentAnalysis // ignore: cast_nullable_to_non_nullable
              as NutritionOrderAnalysis?,
      paymentInfo: freezed == paymentInfo
          ? _value.paymentInfo
          : paymentInfo // ignore: cast_nullable_to_non_nullable
              as PaymentInfo?,
      deliveryInfo: freezed == deliveryInfo
          ? _value.deliveryInfo
          : deliveryInfo // ignore: cast_nullable_to_non_nullable
              as DeliveryInfo?,
      orderReview: freezed == orderReview
          ? _value.orderReview
          : orderReview // ignore: cast_nullable_to_non_nullable
              as OrderReview?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      statusFilter: freezed == statusFilter
          ? _value.statusFilter
          : statusFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      startDateFilter: freezed == startDateFilter
          ? _value.startDateFilter
          : startDateFilter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDateFilter: freezed == endDateFilter
          ? _value.endDateFilter
          : endDateFilter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      showOnlyNutritionOrders: null == showOnlyNutritionOrders
          ? _value.showOnlyNutritionOrders
          : showOnlyNutritionOrders // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      orderStatistics: null == orderStatistics
          ? _value._orderStatistics
          : orderStatistics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      nutritionTrends: null == nutritionTrends
          ? _value._nutritionTrends
          : nutritionTrends // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      orderStatusUpdates: null == orderStatusUpdates
          ? _value._orderStatusUpdates
          : orderStatusUpdates // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      deliveryStatusUpdates: null == deliveryStatusUpdates
          ? _value._deliveryStatusUpdates
          : deliveryStatusUpdates // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc

class _$NutritionOrderStateImpl implements _NutritionOrderState {
  const _$NutritionOrderStateImpl(
      {this.isLoading = false,
      this.isCreating = false,
      this.isUpdating = false,
      final List<NutritionOrder> orders = const [],
      this.currentOrder,
      this.currentAnalysis,
      this.paymentInfo,
      this.deliveryInfo,
      this.orderReview,
      this.error,
      this.searchQuery = '',
      this.statusFilter,
      this.startDateFilter,
      this.endDateFilter,
      this.showOnlyNutritionOrders = false,
      this.currentPage = 0,
      this.pageSize = 20,
      this.hasMore = false,
      final Map<String, dynamic> orderStatistics = const {},
      final Map<String, double> nutritionTrends = const {},
      final Map<String, String> orderStatusUpdates = const {},
      final Map<String, String> deliveryStatusUpdates = const {}})
      : _orders = orders,
        _orderStatistics = orderStatistics,
        _nutritionTrends = nutritionTrends,
        _orderStatusUpdates = orderStatusUpdates,
        _deliveryStatusUpdates = deliveryStatusUpdates;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isCreating;
  @override
  @JsonKey()
  final bool isUpdating;
  final List<NutritionOrder> _orders;
  @override
  @JsonKey()
  List<NutritionOrder> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  @override
  final NutritionOrder? currentOrder;
  @override
  final NutritionOrderAnalysis? currentAnalysis;
  @override
  final PaymentInfo? paymentInfo;
  @override
  final DeliveryInfo? deliveryInfo;
  @override
  final OrderReview? orderReview;
  @override
  final String? error;
// 筛选和搜索状态
  @override
  @JsonKey()
  final String searchQuery;
  @override
  final String? statusFilter;
  @override
  final DateTime? startDateFilter;
  @override
  final DateTime? endDateFilter;
  @override
  @JsonKey()
  final bool showOnlyNutritionOrders;
// 分页状态
  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final int pageSize;
  @override
  @JsonKey()
  final bool hasMore;
// 统计数据
  final Map<String, dynamic> _orderStatistics;
// 统计数据
  @override
  @JsonKey()
  Map<String, dynamic> get orderStatistics {
    if (_orderStatistics is EqualUnmodifiableMapView) return _orderStatistics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_orderStatistics);
  }

  final Map<String, double> _nutritionTrends;
  @override
  @JsonKey()
  Map<String, double> get nutritionTrends {
    if (_nutritionTrends is EqualUnmodifiableMapView) return _nutritionTrends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionTrends);
  }

// 实时状态
  final Map<String, String> _orderStatusUpdates;
// 实时状态
  @override
  @JsonKey()
  Map<String, String> get orderStatusUpdates {
    if (_orderStatusUpdates is EqualUnmodifiableMapView)
      return _orderStatusUpdates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_orderStatusUpdates);
  }

  final Map<String, String> _deliveryStatusUpdates;
  @override
  @JsonKey()
  Map<String, String> get deliveryStatusUpdates {
    if (_deliveryStatusUpdates is EqualUnmodifiableMapView)
      return _deliveryStatusUpdates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_deliveryStatusUpdates);
  }

  @override
  String toString() {
    return 'NutritionOrderState(isLoading: $isLoading, isCreating: $isCreating, isUpdating: $isUpdating, orders: $orders, currentOrder: $currentOrder, currentAnalysis: $currentAnalysis, paymentInfo: $paymentInfo, deliveryInfo: $deliveryInfo, orderReview: $orderReview, error: $error, searchQuery: $searchQuery, statusFilter: $statusFilter, startDateFilter: $startDateFilter, endDateFilter: $endDateFilter, showOnlyNutritionOrders: $showOnlyNutritionOrders, currentPage: $currentPage, pageSize: $pageSize, hasMore: $hasMore, orderStatistics: $orderStatistics, nutritionTrends: $nutritionTrends, orderStatusUpdates: $orderStatusUpdates, deliveryStatusUpdates: $deliveryStatusUpdates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionOrderStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating) &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            (identical(other.currentOrder, currentOrder) ||
                other.currentOrder == currentOrder) &&
            (identical(other.currentAnalysis, currentAnalysis) ||
                other.currentAnalysis == currentAnalysis) &&
            (identical(other.paymentInfo, paymentInfo) ||
                other.paymentInfo == paymentInfo) &&
            (identical(other.deliveryInfo, deliveryInfo) ||
                other.deliveryInfo == deliveryInfo) &&
            (identical(other.orderReview, orderReview) ||
                other.orderReview == orderReview) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.statusFilter, statusFilter) ||
                other.statusFilter == statusFilter) &&
            (identical(other.startDateFilter, startDateFilter) ||
                other.startDateFilter == startDateFilter) &&
            (identical(other.endDateFilter, endDateFilter) ||
                other.endDateFilter == endDateFilter) &&
            (identical(
                    other.showOnlyNutritionOrders, showOnlyNutritionOrders) ||
                other.showOnlyNutritionOrders == showOnlyNutritionOrders) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            const DeepCollectionEquality()
                .equals(other._orderStatistics, _orderStatistics) &&
            const DeepCollectionEquality()
                .equals(other._nutritionTrends, _nutritionTrends) &&
            const DeepCollectionEquality()
                .equals(other._orderStatusUpdates, _orderStatusUpdates) &&
            const DeepCollectionEquality()
                .equals(other._deliveryStatusUpdates, _deliveryStatusUpdates));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        isLoading,
        isCreating,
        isUpdating,
        const DeepCollectionEquality().hash(_orders),
        currentOrder,
        currentAnalysis,
        paymentInfo,
        deliveryInfo,
        orderReview,
        error,
        searchQuery,
        statusFilter,
        startDateFilter,
        endDateFilter,
        showOnlyNutritionOrders,
        currentPage,
        pageSize,
        hasMore,
        const DeepCollectionEquality().hash(_orderStatistics),
        const DeepCollectionEquality().hash(_nutritionTrends),
        const DeepCollectionEquality().hash(_orderStatusUpdates),
        const DeepCollectionEquality().hash(_deliveryStatusUpdates)
      ]);

  /// Create a copy of NutritionOrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionOrderStateImplCopyWith<_$NutritionOrderStateImpl> get copyWith =>
      __$$NutritionOrderStateImplCopyWithImpl<_$NutritionOrderStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionOrderState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionOrderState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionOrderState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _NutritionOrderState implements NutritionOrderState {
  const factory _NutritionOrderState(
          {final bool isLoading,
          final bool isCreating,
          final bool isUpdating,
          final List<NutritionOrder> orders,
          final NutritionOrder? currentOrder,
          final NutritionOrderAnalysis? currentAnalysis,
          final PaymentInfo? paymentInfo,
          final DeliveryInfo? deliveryInfo,
          final OrderReview? orderReview,
          final String? error,
          final String searchQuery,
          final String? statusFilter,
          final DateTime? startDateFilter,
          final DateTime? endDateFilter,
          final bool showOnlyNutritionOrders,
          final int currentPage,
          final int pageSize,
          final bool hasMore,
          final Map<String, dynamic> orderStatistics,
          final Map<String, double> nutritionTrends,
          final Map<String, String> orderStatusUpdates,
          final Map<String, String> deliveryStatusUpdates}) =
      _$NutritionOrderStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isCreating;
  @override
  bool get isUpdating;
  @override
  List<NutritionOrder> get orders;
  @override
  NutritionOrder? get currentOrder;
  @override
  NutritionOrderAnalysis? get currentAnalysis;
  @override
  PaymentInfo? get paymentInfo;
  @override
  DeliveryInfo? get deliveryInfo;
  @override
  OrderReview? get orderReview;
  @override
  String? get error; // 筛选和搜索状态
  @override
  String get searchQuery;
  @override
  String? get statusFilter;
  @override
  DateTime? get startDateFilter;
  @override
  DateTime? get endDateFilter;
  @override
  bool get showOnlyNutritionOrders; // 分页状态
  @override
  int get currentPage;
  @override
  int get pageSize;
  @override
  bool get hasMore; // 统计数据
  @override
  Map<String, dynamic> get orderStatistics;
  @override
  Map<String, double> get nutritionTrends; // 实时状态
  @override
  Map<String, String> get orderStatusUpdates;
  @override
  Map<String, String> get deliveryStatusUpdates;

  /// Create a copy of NutritionOrderState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionOrderStateImplCopyWith<_$NutritionOrderStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
