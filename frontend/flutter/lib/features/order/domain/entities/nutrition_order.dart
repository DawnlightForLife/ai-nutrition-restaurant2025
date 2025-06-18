/**
 * 营养订单领域实体
 * 基于营养元素的革命性订单管理系统
 */

import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition_order.freezed.dart';
part 'nutrition_order.g.dart';

/// 营养订单
@freezed
class NutritionOrder with _$NutritionOrder {
  const factory NutritionOrder({
    required String id,
    required String userId,
    String? profileId, // 关联的营养档案
    String? cartId, // 原购物车ID
    
    // 订单基本信息
    required String orderNumber,
    required String status, // pending, confirmed, preparing, ready, delivering, completed, cancelled
    required DateTime createdAt,
    DateTime? confirmedAt,
    DateTime? estimatedDeliveryTime,
    DateTime? actualDeliveryTime,
    DateTime? cancelledAt,
    String? cancellationReason,
    
    // 营养信息
    required List<NutritionOrderItem> items,
    required Map<String, double> totalNutrition, // 总营养成分
    required int totalCalories,
    required double totalWeight,
    required NutritionOrderAnalysis nutritionAnalysis, // 订单营养分析
    
    // 商家信息（支持多商家订单）
    required Map<String, MerchantOrderGroup> merchantGroups,
    
    // 价格信息
    required double subtotal,
    required double deliveryFee,
    required double discountAmount,
    required double taxAmount,
    required double totalAmount,
    @Default([]) List<String> appliedCoupons,
    
    // 配送信息
    required String deliveryMethod, // delivery, pickup
    required String deliveryAddress,
    String? deliveryContact,
    String? deliveryPhone,
    String? deliveryNotes,
    @Default({}) Map<String, double> deliveryLocation, // lat, lng
    
    // 支付信息
    String? paymentMethod,
    String? paymentId,
    String? paymentStatus, // pending, paid, failed, refunded
    DateTime? paidAt,
    
    // 营养目标匹配
    @Default({}) Map<String, double> nutritionGoals, // 用户的营养目标
    @Default(0.0) double nutritionMatchScore, // 营养匹配评分 0-10
    @Default([]) List<String> nutritionWarnings,
    @Default([]) List<String> nutritionBenefits,
    
    // 特殊要求
    @Default([]) List<String> dietaryRequirements, // vegetarian, vegan, gluten-free等
    @Default([]) List<String> allergenAlerts,
    String? specialInstructions,
    
    // 评价信息
    double? rating,
    String? review,
    DateTime? reviewedAt,
    @Default({}) Map<String, double> nutritionFeedback, // 营养满意度反馈
    
    // 系统信息
    String? assignedDeliveryDriver,
    String? trackingId,
    @Default([]) List<OrderStatusUpdate> statusHistory,
    
    DateTime? updatedAt,
  }) = _NutritionOrder;

  factory NutritionOrder.fromJson(Map<String, dynamic> json) =>
      _$NutritionOrderFromJson(json);
}

/// 营养订单项目
@freezed
class NutritionOrderItem with _$NutritionOrderItem {
  const factory NutritionOrderItem({
    required String id,
    required String itemType, // ingredient, dish, custom_meal
    required String itemId,
    required String name,
    required String chineseName,
    String? description,
    String? imageUrl,
    
    // 商家信息
    required String merchantId,
    required String merchantName,
    
    // 数量和单位
    required double quantity,
    required String unit,
    required double unitPrice,
    required double totalPrice,
    
    // 营养信息（按实际重量计算）
    required Map<String, double> nutritionPer100g,
    required Map<String, double> totalNutrition,
    required int totalCalories,
    
    // 烹饪信息
    String? cookingMethodId,
    String? cookingMethodName,
    @Default({}) Map<String, double> cookingAdjustments,
    String? cookingInstructions,
    @Default('standard') String cookingLevel, // rare, medium, well-done等
    
    // 定制选项
    @Default([]) List<String> customizations,
    @Default([]) List<String> addOns,
    @Default([]) List<String> removedIngredients,
    
    // 营养标签
    @Default([]) List<String> nutritionTags, // high-protein, low-fat等
    @Default([]) List<String> dietaryTags,
    @Default([]) List<String> allergenWarnings,
    
    // 状态信息
    required String status, // pending, confirmed, preparing, ready, completed
    DateTime? preparedAt,
    String? preparationNotes,
    
    // 营养匹配度
    @Default(0.0) double nutritionMatchScore,
    @Default([]) List<String> nutritionBenefits,
    
    required DateTime addedAt,
  }) = _NutritionOrderItem;

  factory NutritionOrderItem.fromJson(Map<String, dynamic> json) =>
      _$NutritionOrderItemFromJson(json);
}

/// 商家订单分组
@freezed
class MerchantOrderGroup with _$MerchantOrderGroup {
  const factory MerchantOrderGroup({
    required String merchantId,
    required String merchantName,
    String? merchantPhone,
    String? merchantAddress,
    
    // 订单项目
    required List<NutritionOrderItem> items,
    
    // 价格信息
    required double subtotal,
    required double deliveryFee,
    required double merchantDiscount,
    
    // 时间信息
    required int estimatedPrepTime, // 预计准备时间（分钟）
    DateTime? confirmedAt,
    DateTime? readyAt,
    
    // 状态信息
    required String status, // pending, confirmed, preparing, ready, picked_up
    @Default([]) List<String> statusNotes,
    
    // 营养统计
    required Map<String, double> nutritionTotals,
    required int totalCalories,
    
    // 特殊要求
    @Default([]) List<String> merchantNotes,
    String? kitchenInstructions,
  }) = _MerchantOrderGroup;

  factory MerchantOrderGroup.fromJson(Map<String, dynamic> json) =>
      _$MerchantOrderGroupFromJson(json);
}

/// 营养订单分析
@freezed
class NutritionOrderAnalysis with _$NutritionOrderAnalysis {
  const factory NutritionOrderAnalysis({
    required String orderId,
    required DateTime analysisTime,
    
    // 营养完整性分析
    required Map<String, NutritionElementAnalysis> elementAnalysis,
    @Default(0.0) double overallNutritionScore, // 0-10
    @Default('neutral') String nutritionStatus, // excellent, good, fair, poor
    
    // 餐次分析
    required String mealType, // breakfast, lunch, dinner, snack
    @Default(0.0) double mealAppropriatenessScore,
    @Default([]) List<String> mealRecommendations,
    
    // 热量分析
    required CalorieAnalysis calorieAnalysis,
    
    // 宏量营养素分析
    required MacronutrientAnalysis macroAnalysis,
    
    // 微量元素分析
    required MicronutrientAnalysis microAnalysis,
    
    // 膳食平衡
    @Default(0.0) double balanceScore,
    @Default([]) List<String> balanceWarnings,
    @Default([]) List<String> balanceStrengths,
    
    // 健康建议
    @Default([]) List<String> healthSuggestions,
    @Default([]) List<String> nextMealRecommendations,
    
    // 长期影响预测
    @Default({}) Map<String, double> longTermNutritionImpact,
  }) = _NutritionOrderAnalysis;

  factory NutritionOrderAnalysis.fromJson(Map<String, dynamic> json) =>
      _$NutritionOrderAnalysisFromJson(json);
}

/// 营养元素分析（复用购物车的定义）
@freezed
class NutritionElementAnalysis with _$NutritionElementAnalysis {
  const factory NutritionElementAnalysis({
    required String elementId,
    required String elementName,
    required double targetAmount,
    required double currentAmount,
    required String unit,
    @Default(0.0) double completionRate,
    required String status, // deficient, adequate, excessive
    String? recommendation,
  }) = _NutritionElementAnalysis;

  factory NutritionElementAnalysis.fromJson(Map<String, dynamic> json) =>
      _$NutritionElementAnalysisFromJson(json);
}

/// 热量分析
@freezed
class CalorieAnalysis with _$CalorieAnalysis {
  const factory CalorieAnalysis({
    required int targetCalories,
    required int currentCalories,
    @Default(0.0) double completionRate,
    required String status, // under, adequate, over
    @Default(0) int recommendedAdjustment,
    @Default('') String mealTypeSuitability,
  }) = _CalorieAnalysis;

  factory CalorieAnalysis.fromJson(Map<String, dynamic> json) =>
      _$CalorieAnalysisFromJson(json);
}

/// 宏量营养素分析
@freezed
class MacronutrientAnalysis with _$MacronutrientAnalysis {
  const factory MacronutrientAnalysis({
    // 蛋白质
    required double proteinTarget,
    required double proteinCurrent,
    @Default(0.0) double proteinPercentage,
    
    // 碳水化合物
    required double carbTarget,
    required double carbCurrent,
    @Default(0.0) double carbPercentage,
    
    // 脂肪
    required double fatTarget,
    required double fatCurrent,
    @Default(0.0) double fatPercentage,
    
    // 平衡评估
    required String balanceStatus,
    @Default([]) List<String> adjustmentSuggestions,
    @Default(0.0) double balanceScore,
  }) = _MacronutrientAnalysis;

  factory MacronutrientAnalysis.fromJson(Map<String, dynamic> json) =>
      _$MacronutrientAnalysisFromJson(json);
}

/// 微量元素分析
@freezed
class MicronutrientAnalysis with _$MicronutrientAnalysis {
  const factory MicronutrientAnalysis({
    // 维生素状态
    @Default({}) Map<String, String> vitaminStatus,
    @Default([]) List<String> vitaminDeficiencies,
    @Default([]) List<String> vitaminExcesses,
    
    // 矿物质状态
    @Default({}) Map<String, String> mineralStatus,
    @Default([]) List<String> mineralDeficiencies,
    @Default([]) List<String> mineralExcesses,
    
    // 膳食纤维
    required double fiberTarget,
    required double fiberCurrent,
    required String fiberStatus,
    
    // 抗氧化剂
    @Default(0.0) double antioxidantScore,
    @Default([]) List<String> antioxidantSources,
    
    // 整体评分
    @Default(0.0) double micronutrientScore,
  }) = _MicronutrientAnalysis;

  factory MicronutrientAnalysis.fromJson(Map<String, dynamic> json) =>
      _$MicronutrientAnalysisFromJson(json);
}

/// 订单状态更新
@freezed
class OrderStatusUpdate with _$OrderStatusUpdate {
  const factory OrderStatusUpdate({
    required String id,
    required String status,
    required String message,
    required DateTime timestamp,
    String? operatorId,
    String? operatorName,
    @Default({}) Map<String, dynamic> metadata,
  }) = _OrderStatusUpdate;

  factory OrderStatusUpdate.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusUpdateFromJson(json);
}

/// 配送信息
@freezed
class DeliveryInfo with _$DeliveryInfo {
  const factory DeliveryInfo({
    required String orderId,
    required String method, // delivery, pickup
    required String address,
    @Default({}) Map<String, double> location, // lat, lng
    String? contact,
    String? phone,
    String? notes,
    
    // 配送时间
    DateTime? estimatedTime,
    DateTime? actualTime,
    @Default(0) int estimatedDuration, // 预计配送时间（分钟）
    
    // 配送员信息
    String? driverId,
    String? driverName,
    String? driverPhone,
    String? vehicleInfo,
    
    // 配送状态
    required String status, // pending, assigned, picked_up, in_transit, delivered
    @Default([]) List<DeliveryStatusUpdate> statusHistory,
    
    // 配送费用
    required double deliveryFee,
    @Default(0.0) double tip,
    
    // 特殊信息
    @Default([]) List<String> deliveryInstructions,
    String? accessCode,
    String? buildingInfo,
  }) = _DeliveryInfo;

  factory DeliveryInfo.fromJson(Map<String, dynamic> json) =>
      _$DeliveryInfoFromJson(json);
}

/// 配送状态更新
@freezed
class DeliveryStatusUpdate with _$DeliveryStatusUpdate {
  const factory DeliveryStatusUpdate({
    required String id,
    required String status,
    required DateTime timestamp,
    @Default({}) Map<String, double> location,
    String? message,
    String? photoUrl,
  }) = _DeliveryStatusUpdate;

  factory DeliveryStatusUpdate.fromJson(Map<String, dynamic> json) =>
      _$DeliveryStatusUpdateFromJson(json);
}

/// 支付信息
@freezed
class PaymentInfo with _$PaymentInfo {
  const factory PaymentInfo({
    required String orderId,
    required String paymentId,
    required String method, // alipay, wechat, card, cash
    required String status, // pending, processing, paid, failed, refunded
    
    // 金额信息
    required double amount,
    required String currency,
    @Default(0.0) double refundedAmount,
    
    // 时间信息
    required DateTime createdAt,
    DateTime? paidAt,
    DateTime? refundedAt,
    
    // 第三方支付信息
    String? transactionId,
    String? platformPaymentId,
    @Default({}) Map<String, dynamic> platformResponse,
    
    // 退款信息
    String? refundReason,
    @Default([]) List<RefundRecord> refundHistory,
    
    // 发票信息
    bool? needInvoice,
    String? invoiceTitle,
    String? invoiceType, // personal, company
    String? invoiceTaxId,
    String? invoiceEmail,
  }) = _PaymentInfo;

  factory PaymentInfo.fromJson(Map<String, dynamic> json) =>
      _$PaymentInfoFromJson(json);
}

/// 退款记录
@freezed
class RefundRecord with _$RefundRecord {
  const factory RefundRecord({
    required String id,
    required double amount,
    required String reason,
    required DateTime timestamp,
    required String status, // pending, processed, failed
    String? operatorId,
    String? platformRefundId,
  }) = _RefundRecord;

  factory RefundRecord.fromJson(Map<String, dynamic> json) =>
      _$RefundRecordFromJson(json);
}

/// 订单评价
@freezed
class OrderReview with _$OrderReview {
  const factory OrderReview({
    required String orderId,
    required String userId,
    
    // 评分
    required double overallRating, // 1-5
    required double foodQualityRating,
    required double deliveryRating,
    required double serviceRating,
    @Default(0.0) double nutritionSatisfactionRating, // 营养满意度
    
    // 评价内容
    String? comment,
    @Default([]) List<String> tags, // 快速标签：delicious, fresh, on-time等
    @Default([]) List<String> photos,
    
    // 营养反馈
    @Default({}) Map<String, double> nutritionFeedback, // 各营养元素满意度
    @Default([]) List<String> nutritionComments,
    bool? achievedNutritionGoals,
    
    // 商家反馈
    @Default({}) Map<String, double> merchantRatings, // 按商家ID的评分
    @Default({}) Map<String, String> merchantComments,
    
    // 改进建议
    @Default([]) List<String> improvementSuggestions,
    @Default([]) List<String> wouldRecommendReasons,
    
    required DateTime createdAt,
    DateTime? updatedAt,
    
    // 系统信息
    @Default(false) bool isVerified,
    @Default(false) bool isPublic,
    @Default(0) int helpfulVotes,
  }) = _OrderReview;

  factory OrderReview.fromJson(Map<String, dynamic> json) =>
      _$OrderReviewFromJson(json);
}