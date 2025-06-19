import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/inventory_entity.dart';

part 'inventory_model.freezed.dart';
part 'inventory_model.g.dart';

@freezed
class InventoryModel with _$InventoryModel {
  const factory InventoryModel({
    @JsonKey(name: '_id') required String id,
    required String merchantId,
    required String ingredientId,
    required String ingredientName,
    required double totalStock,
    required double availableStock,
    required double reservedStock,
    required double minThreshold,
    required String unit,
    @Default([]) List<StockBatchModel> stockBatches,
    required AlertSettingsModel alertSettings,
    required UsageStatsModel usageStats,
    @Default('active') String status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _InventoryModel;

  factory InventoryModel.fromJson(Map<String, dynamic> json) => _$InventoryModelFromJson(json);
}

@freezed
class StockBatchModel with _$StockBatchModel {
  const factory StockBatchModel({
    required String batchId,
    required double quantity,
    required double originalQuantity,
    required DateTime receivedDate,
    required DateTime expiryDate,
    required double unitCost,
    @Default('') String supplier,
    @Default('') String qualityGrade,
    @Default('') String storageLocation,
    @Default('good') String status,
  }) = _StockBatchModel;

  factory StockBatchModel.fromJson(Map<String, dynamic> json) => _$StockBatchModelFromJson(json);
}

@freezed
class AlertSettingsModel with _$AlertSettingsModel {
  const factory AlertSettingsModel({
    @Default(true) bool lowStockAlert,
    @Default(true) bool expiryAlert,
    @Default(true) bool qualityAlert,
    @Default(3) int expiryWarningDays,
    @Default(0.2) double lowStockRatio,
  }) = _AlertSettingsModel;

  factory AlertSettingsModel.fromJson(Map<String, dynamic> json) => _$AlertSettingsModelFromJson(json);
}

@freezed
class UsageStatsModel with _$UsageStatsModel {
  const factory UsageStatsModel({
    @Default(0.0) double averageDailyUsage,
    @Default(0.0) double totalUsedThisMonth,
    @Default(0.0) double totalWasteThisMonth,
    DateTime? lastUsed,
    DateTime? lastRestocked,
    @Default(0) int restockCount,
  }) = _UsageStatsModel;

  factory UsageStatsModel.fromJson(Map<String, dynamic> json) => _$UsageStatsModelFromJson(json);
}

@freezed
class InventoryAlertModel with _$InventoryAlertModel {
  const factory InventoryAlertModel({
    @JsonKey(name: '_id') required String id,
    required String inventoryId,
    required String merchantId,
    required InventoryAlertType type,
    required InventoryAlertSeverity severity,
    required String message,
    required Map<String, dynamic> details,
    @Default(false) bool isRead,
    @Default(false) bool isResolved,
    DateTime? createdAt,
  }) = _InventoryAlertModel;

  factory InventoryAlertModel.fromJson(Map<String, dynamic> json) => _$InventoryAlertModelFromJson(json);
}

// 请求数据模型
@freezed
class InventoryCreateRequest with _$InventoryCreateRequest {
  const factory InventoryCreateRequest({
    required String name,
    required String unit,
    @Default('ingredient') String category,
    required double minThreshold,
    required AlertSettingsModel alertSettings,
  }) = _InventoryCreateRequest;

  factory InventoryCreateRequest.fromJson(Map<String, dynamic> json) => _$InventoryCreateRequestFromJson(json);
}

@freezed
class StockAddRequest with _$StockAddRequest {
  const factory StockAddRequest({
    required double quantity,
    required double unitCost,
    required DateTime expiryDate,
    @Default('') String supplier,
    @Default('') String batchNumber,
    @Default('') String qualityGrade,
    @Default('') String storageLocation,
  }) = _StockAddRequest;

  factory StockAddRequest.fromJson(Map<String, dynamic> json) => _$StockAddRequestFromJson(json);
}

@freezed
class StockConsumeRequest with _$StockConsumeRequest {
  const factory StockConsumeRequest({
    required double quantity,
    @Default('') String reason,
  }) = _StockConsumeRequest;

  factory StockConsumeRequest.fromJson(Map<String, dynamic> json) => _$StockConsumeRequestFromJson(json);
}

// Extension methods to convert between models and entities
extension InventoryModelX on InventoryModel {
  InventoryEntity toEntity() {
    return InventoryEntity(
      id: id,
      merchantId: merchantId,
      ingredientId: ingredientId,
      ingredientName: ingredientName,
      totalStock: totalStock,
      availableStock: availableStock,
      reservedStock: reservedStock,
      minThreshold: minThreshold,
      unit: unit,
      stockBatches: stockBatches.map((b) => b.toEntity()).toList(),
      alertSettings: alertSettings.toEntity(),
      usageStats: usageStats.toEntity(),
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension StockBatchModelX on StockBatchModel {
  StockBatch toEntity() {
    return StockBatch(
      batchId: batchId,
      quantity: quantity,
      originalQuantity: originalQuantity,
      receivedDate: receivedDate,
      expiryDate: expiryDate,
      unitCost: unitCost,
      supplier: supplier,
      qualityGrade: qualityGrade,
      storageLocation: storageLocation,
      status: status,
    );
  }
}

extension AlertSettingsModelX on AlertSettingsModel {
  AlertSettings toEntity() {
    return AlertSettings(
      lowStockAlert: lowStockAlert,
      expiryAlert: expiryAlert,
      qualityAlert: qualityAlert,
      expiryWarningDays: expiryWarningDays,
      lowStockRatio: lowStockRatio,
    );
  }
}

extension UsageStatsModelX on UsageStatsModel {
  UsageStats toEntity() {
    return UsageStats(
      averageDailyUsage: averageDailyUsage,
      totalUsedThisMonth: totalUsedThisMonth,
      totalWasteThisMonth: totalWasteThisMonth,
      lastUsed: lastUsed,
      lastRestocked: lastRestocked,
      restockCount: restockCount,
    );
  }
}

extension InventoryAlertModelX on InventoryAlertModel {
  InventoryAlert toEntity() {
    return InventoryAlert(
      id: id,
      inventoryId: inventoryId,
      merchantId: merchantId,
      type: type,
      severity: severity,
      message: message,
      details: details,
      isRead: isRead,
      isResolved: isResolved,
      createdAt: createdAt,
    );
  }
}