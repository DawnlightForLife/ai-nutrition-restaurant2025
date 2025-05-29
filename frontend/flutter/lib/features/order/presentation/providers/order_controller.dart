import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'order_controller.freezed.dart';
part 'order_controller.g.dart';

/// 订单状态
@freezed
class OrderState with _$OrderState {
  const factory OrderState({
    @Default([]) List<Uorder> orders,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _OrderState;
}

/// 订单控制器 - 使用新的 AsyncNotifier 模式
@riverpod
class OrderController extends _$OrderController {
  @override
  Future<List<Uorder>> build() async {
    final useCase = ref.read(getOrdersUseCaseProvider);
    final result = await useCase(NoParams());
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (orders) => orders,
    );
  }

  /// 刷新订单列表
  Future<void> refreshOrders() async {
    ref.invalidateSelf();
    await future;
  }

  /// 加载订单（兼容旧接口）
  Future<void> loadOrders() async {
    return refreshOrders();
  }

  /// 添加新订单到列表
  void addOrder(Uorder order) {
    final currentOrders = state.valueOrNull ?? [];
    state = AsyncValue.data([order, ...currentOrders]);
  }

  /// 更新订单状态
  void updateOrder(Uorder updatedOrder) {
    final currentOrders = state.valueOrNull ?? [];
    final updatedOrders = currentOrders.map((order) {
      return order.id == updatedOrder.id ? updatedOrder : order;
    }).toList();
    
    state = AsyncValue.data(updatedOrders);
  }

  /// 删除订单
  void removeOrder(String orderId) {
    final currentOrders = state.valueOrNull ?? [];
    final filteredOrders = currentOrders.where((order) => order.id != orderId).toList();
    state = AsyncValue.data(filteredOrders);
  }
}

/// 单个订单控制器
@riverpod
class SingleOrderController extends _$SingleOrderController {
  @override
  Future<Uorder?> build(String orderId) async {
    final orders = await ref.watch(orderControllerProvider.future);
    return orders.firstWhere(
      (order) => order.id == orderId,
      orElse: () => throw Exception('订单不存在'),
    );
  }

  /// 刷新单个订单
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

/// 订单状态过滤器
@riverpod
List<Uorder> filteredOrders(FilteredOrdersRef ref, String? status) {
  final orders = ref.watch(orderControllerProvider).valueOrNull ?? [];
  
  if (status == null || status.isEmpty) {
    return orders;
  }
  
  return orders.where((order) => order.status == status).toList();
}

/// 订单统计
@riverpod
Map<String, int> orderStats(OrderStatsRef ref) {
  final orders = ref.watch(orderControllerProvider).valueOrNull ?? [];
  
  final stats = <String, int>{};
  for (final order in orders) {
    stats[order.status] = (stats[order.status] ?? 0) + 1;
  }
  
  return stats;
}

/// UseCase Provider
@riverpod
GetUordersUseCase getOrdersUseCase(GetOrdersUseCaseRef ref) {
  final repository = ref.read(orderRepositoryProvider);
  return GetUordersUseCase(repository);
}

/// Repository Provider
@riverpod
UorderRepository orderRepository(OrderRepositoryRef ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
}

/// 便捷访问器
@riverpod
List<Uorder> currentOrders(CurrentOrdersRef ref) {
  return ref.watch(orderControllerProvider).valueOrNull ?? [];
}

@riverpod
bool hasOrders(HasOrdersRef ref) {
  final orders = ref.watch(currentOrdersProvider);
  return orders.isNotEmpty;
}

@riverpod
int orderCount(OrderCountRef ref) {
  final orders = ref.watch(currentOrdersProvider);
  return orders.length;
}