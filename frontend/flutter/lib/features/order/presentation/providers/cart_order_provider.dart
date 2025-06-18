import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/cart_order_remote_datasource.dart';
import '../../data/repositories/cart_order_repository_impl.dart';
import '../../domain/entities/cart_order.dart';
import '../../domain/repositories/cart_order_repository.dart';
import '../../domain/usecases/create_cart_order_usecase.dart';

part 'cart_order_provider.freezed.dart';

// Repository provider
final cartOrderRepositoryProvider = Provider<CartOrderRepository>((ref) {
  final dio = ApiClient().getDio();
  final remoteDataSource = CartOrderRemoteDataSourceImpl(dio);
  return CartOrderRepositoryImpl(remoteDataSource);
});

// UseCase provider
final createCartOrderUseCaseProvider = Provider<CreateCartOrderUseCase>((ref) {
  final repository = ref.read(cartOrderRepositoryProvider);
  return CreateCartOrderUseCase(repository);
});

// 订单创建状态
@freezed
class OrderCreationState with _$OrderCreationState {
  const factory OrderCreationState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    CartOrder? createdOrder,
    String? error,
  }) = _OrderCreationState;
}

// 订单创建Provider
class OrderCreationNotifier extends StateNotifier<OrderCreationState> {
  final CreateCartOrderUseCase _createOrderUseCase;

  OrderCreationNotifier(this._createOrderUseCase) 
      : super(const OrderCreationState());

  /// 创建订单
  Future<void> createOrder(CartOrder order) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);
    
    try {
      final params = CreateCartOrderParams(order: order);
      final createdOrder = await _createOrderUseCase(params);
      
      state = state.copyWith(
        isLoading: false,
        createdOrder: createdOrder,
        isSuccess: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isSuccess: false,
      );
    }
  }

  /// 重置状态
  void reset() {
    state = const OrderCreationState();
  }
}

final orderCreationProvider = StateNotifierProvider<OrderCreationNotifier, OrderCreationState>((ref) {
  final useCase = ref.read(createCartOrderUseCaseProvider);
  return OrderCreationNotifier(useCase);
});

// 订单列表状态
@freezed
class OrderListState with _$OrderListState {
  const factory OrderListState({
    @Default(false) bool isLoading,
    @Default([]) List<CartOrder> orders,
    String? error,
  }) = _OrderListState;
}

// 订单列表Provider
class OrderListNotifier extends StateNotifier<OrderListState> {
  final CartOrderRepository _repository;

  OrderListNotifier(this._repository) : super(const OrderListState());

  /// 加载用户订单列表
  Future<void> loadUserOrders(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final orders = await _repository.getUserOrders(userId);
      state = state.copyWith(
        isLoading: false,
        orders: orders,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 刷新订单列表
  Future<void> refresh(String userId) async {
    await loadUserOrders(userId);
  }
}

final orderListProvider = StateNotifierProvider<OrderListNotifier, OrderListState>((ref) {
  final repository = ref.read(cartOrderRepositoryProvider);
  return OrderListNotifier(repository);
});

// 订单详情状态
@freezed
class OrderDetailState with _$OrderDetailState {
  const factory OrderDetailState({
    @Default(false) bool isLoading,
    CartOrder? order,
    String? error,
  }) = _OrderDetailState;
}

// 订单详情Provider
class OrderDetailNotifier extends StateNotifier<OrderDetailState> {
  final CartOrderRepository _repository;

  OrderDetailNotifier(this._repository) : super(const OrderDetailState());

  /// 加载订单详情
  Future<void> loadOrder(String orderId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final order = await _repository.getOrder(orderId);
      state = state.copyWith(
        isLoading: false,
        order: order,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 更新订单状态
  Future<void> updateStatus(String orderId, String status) async {
    try {
      final updatedOrder = await _repository.updateOrderStatus(orderId, status);
      state = state.copyWith(order: updatedOrder);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 取消订单
  Future<bool> cancelOrder(String orderId) async {
    try {
      await _repository.cancelOrder(orderId);
      // 重新加载订单详情以获取最新状态
      loadOrder(orderId);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final orderDetailProvider = StateNotifierProvider.family<OrderDetailNotifier, OrderDetailState, String>((ref, orderId) {
  final repository = ref.read(cartOrderRepositoryProvider);
  final notifier = OrderDetailNotifier(repository);
  // 自动加载订单详情
  notifier.loadOrder(orderId);
  return notifier;
});