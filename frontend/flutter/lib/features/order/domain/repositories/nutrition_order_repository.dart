/**
 * 营养订单仓储接口
 * 定义营养订单的数据访问抽象
 */

import '../entities/nutrition_order.dart';

abstract class NutritionOrderRepository {
  // 订单创建和管理
  Future<NutritionOrder> createOrder(NutritionOrder order);
  Future<NutritionOrder?> getOrder(String orderId);
  Future<List<NutritionOrder>> getUserOrders(
    String userId, {
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });
  Future<void> updateOrder(NutritionOrder order);
  Future<void> cancelOrder(String orderId, String reason);

  // 订单状态管理
  Future<void> updateOrderStatus(String orderId, String status, {
    String? message,
    String? operatorId,
    Map<String, dynamic>? metadata,
  });
  Future<List<OrderStatusUpdate>> getOrderStatusHistory(String orderId);
  
  // 商家订单管理
  Future<List<NutritionOrder>> getMerchantOrders(
    String merchantId, {
    String? status,
    DateTime? date,
    int? limit,
  });
  Future<void> confirmMerchantOrder(String orderId, String merchantId, {
    int? estimatedPrepTime,
    String? notes,
  });
  Future<void> updateMerchantOrderStatus(
    String orderId,
    String merchantId,
    String status, {
    String? notes,
  });

  // 营养分析
  Future<NutritionOrderAnalysis> analyzeOrderNutrition(String orderId);
  Future<NutritionOrderAnalysis> analyzeOrderWithProfile(
    String orderId,
    String profileId,
  );
  Future<void> saveNutritionAnalysis(
    String orderId,
    NutritionOrderAnalysis analysis,
  );

  // 支付管理
  Future<PaymentInfo> createPayment(String orderId, String method, double amount);
  Future<PaymentInfo?> getPaymentInfo(String orderId);
  Future<void> updatePaymentStatus(String paymentId, String status, {
    String? transactionId,
    Map<String, dynamic>? platformResponse,
  });
  Future<void> processRefund(String orderId, double amount, String reason);

  // 配送管理
  Future<DeliveryInfo> createDeliveryInfo(String orderId, DeliveryInfo delivery);
  Future<DeliveryInfo?> getDeliveryInfo(String orderId);
  Future<void> updateDeliveryStatus(String orderId, String status, {
    Map<String, double>? location,
    String? message,
  });
  Future<void> assignDeliveryDriver(String orderId, String driverId);
  Future<List<DateTime>> getAvailableDeliveryTimes(
    String merchantId,
    String address,
  );

  // 订单搜索和筛选
  Future<List<NutritionOrder>> searchOrders({
    String? userId,
    String? merchantId,
    String? keyword,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    List<String>? nutritionTags,
    int? limit,
    int? offset,
  });

  // 订单统计
  Future<Map<String, dynamic>> getOrderStatistics(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<Map<String, dynamic>> getMerchantOrderStatistics(
    String merchantId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  // 营养追踪
  Future<Map<String, double>> getUserNutritionTrends(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    String? period, // daily, weekly, monthly
  });
  Future<List<String>> getNutritionRecommendationsBasedOnHistory(
    String userId,
    int daysBack,
  );

  // 订单评价
  Future<void> submitOrderReview(OrderReview review);
  Future<OrderReview?> getOrderReview(String orderId);
  Future<List<OrderReview>> getMerchantReviews(
    String merchantId, {
    int? limit,
    double? minRating,
  });
  Future<void> updateReviewHelpfulness(String reviewId, bool isHelpful);

  // 重复订单
  Future<NutritionOrder> reorderFromPrevious(String previousOrderId);
  Future<List<NutritionOrder>> getSimilarOrders(String orderId);
  Future<void> saveOrderAsTemplate(String orderId, String templateName);
  Future<List<Map<String, dynamic>>> getUserOrderTemplates(String userId);

  // 订单分享
  Future<String> shareOrder(String orderId);
  Future<NutritionOrder?> getSharedOrder(String shareCode);

  // 实时订单追踪
  Stream<OrderStatusUpdate> watchOrderStatus(String orderId);
  Stream<DeliveryStatusUpdate> watchDeliveryStatus(String orderId);

  // 批量操作
  Future<void> batchUpdateOrderStatus(
    List<String> orderIds,
    String status, {
    String? reason,
  });
  Future<List<NutritionOrder>> batchGetOrders(List<String> orderIds);

  // 订单验证
  Future<bool> validateOrderBeforePayment(String orderId);
  Future<List<String>> checkIngredientAvailability(String orderId);
  Future<double> calculateOrderNutritionScore(String orderId);

  // 智能推荐
  Future<List<String>> getOrderCompletionSuggestions(String orderId);
  Future<List<Map<String, dynamic>>> getUpgradeOptions(String orderId);
  Future<List<String>> getSideRecommendations(String orderId);

  // 营养目标追踪
  Future<Map<String, double>> trackDailyNutritionProgress(
    String userId,
    DateTime date,
  );
  Future<bool> checkNutritionGoalsAchievement(
    String userId,
    String orderId,
  );

  // 订单通知
  Future<void> sendOrderNotification(
    String orderId,
    String type, // created, confirmed, ready, delivered等
    {Map<String, dynamic>? data}
  );
  Future<void> scheduleOrderReminders(String orderId);

  // 数据导出
  Future<String> exportOrderHistory(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    String? format, // csv, pdf, excel
  });
  Future<String> exportNutritionReport(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  });
}