import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/order_entity.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/models/order_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';

// Repository provider
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrderRepositoryImpl(apiClient);
});

// Order list provider with filters
final orderListProvider = StateNotifierProvider.family<OrderListNotifier, AsyncValue<List<OrderEntity>>, OrderListParams>(
  (ref, params) => OrderListNotifier(ref.watch(orderRepositoryProvider), params),
);

// Single order provider
final orderProvider = StateNotifierProvider.family<OrderNotifier, AsyncValue<OrderEntity?>, String>(
  (ref, orderId) => OrderNotifier(ref.watch(orderRepositoryProvider), orderId),
);

// Production queue provider
final productionQueueProvider = StateNotifierProvider.family<ProductionQueueNotifier, AsyncValue<ProductionQueueEntity?>, String>(
  (ref, storeId) => ProductionQueueNotifier(ref.watch(orderRepositoryProvider), storeId),
);

// Delivery management provider
final deliveryManagementProvider = StateNotifierProvider.family<DeliveryManagementNotifier, AsyncValue<DeliveryManagementEntity?>, String>(
  (ref, storeId) => DeliveryManagementNotifier(ref.watch(orderRepositoryProvider), storeId),
);

// Order analytics provider
final orderAnalyticsProvider = StateNotifierProvider.family<OrderAnalyticsNotifier, AsyncValue<OrderAnalyticsEntity?>, OrderAnalyticsParams>(
  (ref, params) => OrderAnalyticsNotifier(ref.watch(orderRepositoryProvider), params),
);

// Order filter provider
final orderFilterProvider = StateNotifierProvider<OrderFilterNotifier, OrderFilterState>(
  (ref) => OrderFilterNotifier(),
);

// Order list parameters
class OrderListParams {
  final String? merchantId;
  final String? storeId;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;

  OrderListParams({
    this.merchantId,
    this.storeId,
    this.status,
    this.startDate,
    this.endDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderListParams &&
          merchantId == other.merchantId &&
          storeId == other.storeId &&
          status == other.status &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode =>
      merchantId.hashCode ^
      storeId.hashCode ^
      status.hashCode ^
      startDate.hashCode ^
      endDate.hashCode;
}

// Order analytics parameters
class OrderAnalyticsParams {
  final String? merchantId;
  final String? storeId;
  final DateTime? startDate;
  final DateTime? endDate;

  OrderAnalyticsParams({
    this.merchantId,
    this.storeId,
    this.startDate,
    this.endDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAnalyticsParams &&
          merchantId == other.merchantId &&
          storeId == other.storeId &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode =>
      merchantId.hashCode ^
      storeId.hashCode ^
      startDate.hashCode ^
      endDate.hashCode;
}

class OrderListNotifier extends StateNotifier<AsyncValue<List<OrderEntity>>> {
  final OrderRepository _repository;
  final OrderListParams params;

  OrderListNotifier(this._repository, this.params) : super(const AsyncValue.loading()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    state = const AsyncValue.loading();
    final result = await _repository.getOrderList(
      merchantId: params.merchantId,
      storeId: params.storeId,
      status: params.status,
      startDate: params.startDate,
      endDate: params.endDate,
    );
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (orders) => state = AsyncValue.data(orders),
    );
  }

  Future<void> refreshOrders() async {
    await loadOrders();
  }

  Future<bool> updateOrderStatus(String orderId, String newStatus, {String? cancelReason}) async {
    final request = OrderStatusUpdateRequest(
      newStatus: newStatus,
      cancelReason: cancelReason,
    );
    
    final result = await _repository.updateOrderStatus(orderId, request);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (updatedOrder) {
        // Update order in current state
        state.whenData((orders) {
          final updatedOrders = orders.map((order) => 
            order.id == orderId ? updatedOrder : order
          ).toList();
          state = AsyncValue.data(updatedOrders);
        });
        return true;
      },
    );
  }

  Future<bool> batchUpdateOrderStatus(List<String> orderIds, String newStatus) async {
    final request = BatchOrderStatusUpdateRequest(
      orderIds: orderIds,
      newStatus: newStatus,
    );
    
    final result = await _repository.batchUpdateOrderStatus(request);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (updatedOrders) {
        // Refresh the list
        loadOrders();
        return true;
      },
    );
  }
}

class OrderNotifier extends StateNotifier<AsyncValue<OrderEntity?>> {
  final OrderRepository _repository;
  final String orderId;

  OrderNotifier(this._repository, this.orderId) : super(const AsyncValue.loading()) {
    loadOrder();
  }

  Future<void> loadOrder() async {
    state = const AsyncValue.loading();
    final result = await _repository.getOrderById(orderId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (order) => state = AsyncValue.data(order),
    );
  }

  Future<void> refreshOrder() async {
    await loadOrder();
  }
}

class ProductionQueueNotifier extends StateNotifier<AsyncValue<ProductionQueueEntity?>> {
  final OrderRepository _repository;
  final String storeId;

  ProductionQueueNotifier(this._repository, this.storeId) : super(const AsyncValue.loading()) {
    loadProductionQueue();
  }

  Future<void> loadProductionQueue() async {
    state = const AsyncValue.loading();
    final result = await _repository.getProductionQueue(storeId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (queue) => state = AsyncValue.data(queue),
    );
  }

  Future<void> refreshProductionQueue() async {
    await loadProductionQueue();
  }
}

class DeliveryManagementNotifier extends StateNotifier<AsyncValue<DeliveryManagementEntity?>> {
  final OrderRepository _repository;
  final String storeId;

  DeliveryManagementNotifier(this._repository, this.storeId) : super(const AsyncValue.loading()) {
    loadDeliveryManagement();
  }

  Future<void> loadDeliveryManagement() async {
    state = const AsyncValue.loading();
    final result = await _repository.getDeliveryManagement(storeId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (delivery) => state = AsyncValue.data(delivery),
    );
  }

  Future<void> refreshDeliveryManagement() async {
    await loadDeliveryManagement();
  }
}

class OrderAnalyticsNotifier extends StateNotifier<AsyncValue<OrderAnalyticsEntity?>> {
  final OrderRepository _repository;
  final OrderAnalyticsParams params;

  OrderAnalyticsNotifier(this._repository, this.params) : super(const AsyncValue.loading()) {
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    state = const AsyncValue.loading();
    final result = await _repository.getOrderAnalytics(
      merchantId: params.merchantId,
      storeId: params.storeId,
      startDate: params.startDate,
      endDate: params.endDate,
    );
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (analytics) => state = AsyncValue.data(analytics),
    );
  }

  Future<void> refreshAnalytics() async {
    await loadAnalytics();
  }
}

// Filter state management
class OrderFilterNotifier extends StateNotifier<OrderFilterState> {
  OrderFilterNotifier() : super(const OrderFilterState());

  void updateFilter({
    OrderStatus? status,
    OrderType? orderType,
    PaymentStatus? paymentStatus,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) {
    state = state.copyWith(
      status: status ?? state.status,
      orderType: orderType ?? state.orderType,
      paymentStatus: paymentStatus ?? state.paymentStatus,
      startDate: startDate ?? state.startDate,
      endDate: endDate ?? state.endDate,
      searchQuery: searchQuery ?? state.searchQuery,
    );
  }

  void clearFilters() {
    state = const OrderFilterState();
  }

  void clearStatus() {
    state = state.copyWith(status: null);
  }

  void clearOrderType() {
    state = state.copyWith(orderType: null);
  }

  void clearPaymentStatus() {
    state = state.copyWith(paymentStatus: null);
  }
}

// Filter state
class OrderFilterState {
  final OrderStatus? status;
  final OrderType? orderType;
  final PaymentStatus? paymentStatus;
  final DateTime? startDate;
  final DateTime? endDate;
  final String searchQuery;

  const OrderFilterState({
    this.status,
    this.orderType,
    this.paymentStatus,
    this.startDate,
    this.endDate,
    this.searchQuery = '',
  });

  OrderFilterState copyWith({
    OrderStatus? status,
    OrderType? orderType,
    PaymentStatus? paymentStatus,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) {
    return OrderFilterState(
      status: status,
      orderType: orderType,
      paymentStatus: paymentStatus,
      startDate: startDate,
      endDate: endDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}