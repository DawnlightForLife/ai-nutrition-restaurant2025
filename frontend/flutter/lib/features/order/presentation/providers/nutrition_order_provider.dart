/**
 * 营养订单状态提供者
 * 使用Riverpod管理营养订单状态
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/nutrition_order.dart';
import '../../domain/repositories/nutrition_order_repository.dart';
import '../../data/repositories/nutrition_order_repository_impl.dart';
import '../../data/datasources/nutrition_order_api.dart';
import 'package:dio/dio.dart';

part 'nutrition_order_provider.freezed.dart';

// Repository provider
final nutritionOrderRepositoryProvider = Provider<NutritionOrderRepository>((ref) {
  // TODO: 从全局Dio provider获取实例
  final dio = Dio(); // 临时创建，后续需要从依赖注入获取
  final api = NutritionOrderApi(dio);
  return NutritionOrderRepositoryImpl(api);
});

// 营养订单状态
@freezed
class NutritionOrderState with _$NutritionOrderState {
  const factory NutritionOrderState({
    @Default(false) bool isLoading,
    @Default(false) bool isCreating,
    @Default(false) bool isUpdating,
    @Default([]) List<NutritionOrder> orders,
    NutritionOrder? currentOrder,
    NutritionOrderAnalysis? currentAnalysis,
    PaymentInfo? paymentInfo,
    DeliveryInfo? deliveryInfo,
    OrderReview? orderReview,
    String? error,
    
    // 筛选和搜索状态
    @Default('') String searchQuery,
    String? statusFilter,
    DateTime? startDateFilter,
    DateTime? endDateFilter,
    @Default(false) bool showOnlyNutritionOrders,
    
    // 分页状态
    @Default(0) int currentPage,
    @Default(20) int pageSize,
    @Default(false) bool hasMore,
    
    // 统计数据
    @Default({}) Map<String, dynamic> orderStatistics,
    @Default({}) Map<String, double> nutritionTrends,
    
    // 实时状态
    @Default({}) Map<String, String> orderStatusUpdates,
    @Default({}) Map<String, String> deliveryStatusUpdates,
  }) = _NutritionOrderState;
}

// 营养订单管理提供者
class NutritionOrderNotifier extends StateNotifier<NutritionOrderState> {
  final NutritionOrderRepository _repository;
  final String userId;

  NutritionOrderNotifier(this._repository, this.userId) 
      : super(const NutritionOrderState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([
      loadUserOrders(),
      loadOrderStatistics(),
    ]);
  }

  // 创建订单
  Future<NutritionOrder?> createOrder(NutritionOrder order) async {
    try {
      state = state.copyWith(isCreating: true, error: null);
      final createdOrder = await _repository.createOrder(order);
      
      // 添加到订单列表
      final updatedOrders = [createdOrder, ...state.orders];
      state = state.copyWith(
        orders: updatedOrders,
        currentOrder: createdOrder,
        isCreating: false,
      );
      
      return createdOrder;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isCreating: false);
      return null;
    }
  }

  // 加载用户订单
  Future<void> loadUserOrders({
    bool refresh = false,
    String? status,
  }) async {
    try {
      if (refresh || state.currentPage == 0) {
        state = state.copyWith(isLoading: true, error: null);
      }
      
      final orders = await _repository.getUserOrders(
        userId,
        status: status ?? state.statusFilter,
        startDate: state.startDateFilter,
        endDate: state.endDateFilter,
        limit: state.pageSize,
        offset: refresh ? 0 : state.currentPage * state.pageSize,
      );
      
      final updatedOrders = refresh 
          ? orders 
          : [...state.orders, ...orders];
      
      state = state.copyWith(
        orders: updatedOrders,
        isLoading: false,
        currentPage: refresh ? 1 : state.currentPage + 1,
        hasMore: orders.length == state.pageSize,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // 获取订单详情
  Future<void> loadOrderDetail(String orderId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final order = await _repository.getOrder(orderId);
      if (order != null) {
        state = state.copyWith(currentOrder: order, isLoading: false);
        
        // 同时加载相关信息
        await Future.wait([
          loadOrderAnalysis(orderId),
          loadPaymentInfo(orderId),
          loadDeliveryInfo(orderId),
        ]);
      } else {
        state = state.copyWith(
          error: '订单不存在',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // 加载营养分析
  Future<void> loadOrderAnalysis(String orderId) async {
    try {
      final analysis = await _repository.analyzeOrderNutrition(orderId);
      state = state.copyWith(currentAnalysis: analysis);
    } catch (e) {
      // 营养分析失败不影响主流程
      state = state.copyWith(error: '营养分析加载失败: ${e.toString()}');
    }
  }

  // 加载支付信息
  Future<void> loadPaymentInfo(String orderId) async {
    try {
      final paymentInfo = await _repository.getPaymentInfo(orderId);
      state = state.copyWith(paymentInfo: paymentInfo);
    } catch (e) {
      // 支付信息加载失败不影响主流程
    }
  }

  // 加载配送信息
  Future<void> loadDeliveryInfo(String orderId) async {
    try {
      final deliveryInfo = await _repository.getDeliveryInfo(orderId);
      state = state.copyWith(deliveryInfo: deliveryInfo);
    } catch (e) {
      // 配送信息加载失败不影响主流程
    }
  }

  // 更新订单状态
  Future<void> updateOrderStatus(
    String orderId,
    String status, {
    String? message,
  }) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);
      
      await _repository.updateOrderStatus(
        orderId,
        status,
        message: message,
      );
      
      // 更新本地订单状态
      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(status: status);
        }
        return order;
      }).toList();
      
      state = state.copyWith(
        orders: updatedOrders,
        isUpdating: false,
      );
      
      // 如果是当前订单，也更新
      if (state.currentOrder?.id == orderId) {
        state = state.copyWith(
          currentOrder: state.currentOrder!.copyWith(status: status),
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdating: false);
    }
  }

  // 取消订单
  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);
      
      await _repository.cancelOrder(orderId, reason);
      
      // 更新本地状态
      await updateOrderStatus(orderId, 'cancelled');
      
      state = state.copyWith(isUpdating: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdating: false);
    }
  }

  // 创建支付
  Future<PaymentInfo?> createPayment(
    String orderId,
    String method,
    double amount,
  ) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);
      
      final paymentInfo = await _repository.createPayment(orderId, method, amount);
      
      state = state.copyWith(
        paymentInfo: paymentInfo,
        isUpdating: false,
      );
      
      return paymentInfo;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdating: false);
      return null;
    }
  }

  // 提交订单评价
  Future<void> submitReview(OrderReview review) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);
      
      await _repository.submitOrderReview(review);
      
      state = state.copyWith(
        orderReview: review,
        isUpdating: false,
      );
      
      // 更新订单的评价状态
      if (state.currentOrder?.id == review.orderId) {
        state = state.copyWith(
          currentOrder: state.currentOrder!.copyWith(
            rating: review.overallRating,
            review: review.comment,
            reviewedAt: review.createdAt,
          ),
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdating: false);
    }
  }

  // 重新下单
  Future<NutritionOrder?> reorderFromPrevious(String previousOrderId) async {
    try {
      state = state.copyWith(isCreating: true, error: null);
      
      final newOrder = await _repository.reorderFromPrevious(previousOrderId);
      
      // 添加到订单列表
      final updatedOrders = [newOrder, ...state.orders];
      state = state.copyWith(
        orders: updatedOrders,
        currentOrder: newOrder,
        isCreating: false,
      );
      
      return newOrder;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isCreating: false);
      return null;
    }
  }

  // 加载统计数据
  Future<void> loadOrderStatistics() async {
    try {
      final statistics = await _repository.getOrderStatistics(userId);
      state = state.copyWith(orderStatistics: statistics);
    } catch (e) {
      // 统计数据加载失败不影响主流程
    }
  }

  // 加载营养趋势
  Future<void> loadNutritionTrends({
    DateTime? startDate,
    DateTime? endDate,
    String period = 'daily',
  }) async {
    try {
      final trends = await _repository.getUserNutritionTrends(
        userId,
        startDate: startDate,
        endDate: endDate,
        period: period,
      );
      state = state.copyWith(nutritionTrends: trends);
    } catch (e) {
      // 趋势数据加载失败不影响主流程
    }
  }

  // 搜索和筛选
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _performSearch();
  }

  void updateStatusFilter(String? status) {
    state = state.copyWith(statusFilter: status, currentPage: 0);
    loadUserOrders(refresh: true, status: status);
  }

  void updateDateFilter(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(
      startDateFilter: startDate,
      endDateFilter: endDate,
      currentPage: 0,
    );
    loadUserOrders(refresh: true);
  }

  void toggleNutritionOrdersOnly() {
    state = state.copyWith(
      showOnlyNutritionOrders: !state.showOnlyNutritionOrders,
      currentPage: 0,
    );
    loadUserOrders(refresh: true);
  }

  // 执行搜索
  Future<void> _performSearch() async {
    if (state.searchQuery.isEmpty) {
      loadUserOrders(refresh: true);
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final orders = await _repository.searchOrders(
        userId: userId,
        keyword: state.searchQuery,
        status: state.statusFilter,
        startDate: state.startDateFilter,
        endDate: state.endDateFilter,
        limit: state.pageSize,
      );
      
      state = state.copyWith(
        orders: orders,
        isLoading: false,
        currentPage: 1,
        hasMore: orders.length == state.pageSize,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // 监听订单状态更新
  void watchOrderStatus(String orderId) {
    _repository.watchOrderStatus(orderId).listen(
      (update) {
        final updates = Map<String, String>.from(state.orderStatusUpdates);
        updates[orderId] = update.status;
        state = state.copyWith(orderStatusUpdates: updates);
        
        // 更新订单状态
        updateOrderStatus(orderId, update.status, message: update.message);
      },
      onError: (error) {
        state = state.copyWith(error: error.toString());
      },
    );
  }

  // 监听配送状态更新
  void watchDeliveryStatus(String orderId) {
    _repository.watchDeliveryStatus(orderId).listen(
      (update) {
        final updates = Map<String, String>.from(state.deliveryStatusUpdates);
        updates[orderId] = update.status;
        state = state.copyWith(deliveryStatusUpdates: updates);
      },
      onError: (error) {
        // 配送状态更新失败不影响主流程
      },
    );
  }

  // 获取筛选后的订单列表
  List<NutritionOrder> get filteredOrders {
    var orders = state.orders;
    
    if (state.showOnlyNutritionOrders) {
      orders = orders.where((order) => 
        order.nutritionAnalysis.overallNutritionScore > 0).toList();
    }
    
    return orders;
  }

  // 获取订单统计摘要
  Map<String, dynamic> get orderSummary {
    final orders = filteredOrders;
    final totalOrders = orders.length;
    final completedOrders = orders.where((o) => o.status == 'completed').length;
    final totalSpent = orders.fold<double>(
      0.0,
      (sum, order) => sum + order.totalAmount,
    );
    
    return {
      'totalOrders': totalOrders,
      'completedOrders': completedOrders,
      'totalSpent': totalSpent,
      'averageOrderValue': totalOrders > 0 ? totalSpent / totalOrders : 0.0,
      'completionRate': totalOrders > 0 ? completedOrders / totalOrders : 0.0,
    };
  }
}

// Provider instances
final nutritionOrderProvider = StateNotifierProvider.family<
    NutritionOrderNotifier, NutritionOrderState, String>(
  (ref, userId) {
    final repository = ref.read(nutritionOrderRepositoryProvider);
    return NutritionOrderNotifier(repository, userId);
  },
);