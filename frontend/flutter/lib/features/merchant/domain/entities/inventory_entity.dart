import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_entity.freezed.dart';
part 'inventory_entity.g.dart';

@freezed
class InventoryEntity with _$InventoryEntity {
  const factory InventoryEntity({
    @JsonKey(name: '_id') required String id,
    required String merchantId,
    required String ingredientId,
    required String ingredientName,
    required double totalStock,
    required double availableStock,
    required double reservedStock,
    required double minThreshold,
    required String unit,
    @Default([]) List<StockBatch> stockBatches,
    required AlertSettings alertSettings,
    required UsageStats usageStats,
    @Default('active') String status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _InventoryEntity;

  factory InventoryEntity.fromJson(Map<String, dynamic> json) => _$InventoryEntityFromJson(json);
}

@freezed
class StockBatch with _$StockBatch {
  const factory StockBatch({
    required String batchId,
    required double quantity,
    required double originalQuantity,
    required DateTime receivedDate,
    required DateTime expiryDate,
    required double unitCost,
    @Default('') String supplier,
    @Default('') String qualityGrade,
    @Default('') String storageLocation,
    @Default('good') String status, // good, warning, expired, recalled
  }) = _StockBatch;

  factory StockBatch.fromJson(Map<String, dynamic> json) => _$StockBatchFromJson(json);
}

@freezed
class AlertSettings with _$AlertSettings {
  const factory AlertSettings({
    @Default(true) bool lowStockAlert,
    @Default(true) bool expiryAlert,
    @Default(true) bool qualityAlert,
    @Default(3) int expiryWarningDays,
    @Default(0.2) double lowStockRatio,
  }) = _AlertSettings;

  factory AlertSettings.fromJson(Map<String, dynamic> json) => _$AlertSettingsFromJson(json);
}

@freezed
class UsageStats with _$UsageStats {
  const factory UsageStats({
    @Default(0.0) double averageDailyUsage,
    @Default(0.0) double totalUsedThisMonth,
    @Default(0.0) double totalWasteThisMonth,
    DateTime? lastUsed,
    DateTime? lastRestocked,
    @Default(0) int restockCount,
  }) = _UsageStats;

  factory UsageStats.fromJson(Map<String, dynamic> json) => _$UsageStatsFromJson(json);
}

@freezed
class InventoryAlert with _$InventoryAlert {
  const factory InventoryAlert({
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
  }) = _InventoryAlert;

  factory InventoryAlert.fromJson(Map<String, dynamic> json) => _$InventoryAlertFromJson(json);
}

enum InventoryAlertType {
  @JsonValue('low_stock')
  lowStock,
  @JsonValue('expiry_warning')
  expiryWarning,
  @JsonValue('expired')
  expired,
  @JsonValue('quality_issue')
  qualityIssue,
  @JsonValue('auto_reorder')
  autoReorder,
  @JsonValue('stock_out')
  stockOut,
}

enum InventoryAlertSeverity {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
  @JsonValue('critical')
  critical,
}

// Extension methods for enums
extension InventoryAlertTypeX on InventoryAlertType {
  String get displayName {
    switch (this) {
      case InventoryAlertType.lowStock:
        return '库存不足';
      case InventoryAlertType.expiryWarning:
        return '即将过期';
      case InventoryAlertType.expired:
        return '已过期';
      case InventoryAlertType.qualityIssue:
        return '质量问题';
      case InventoryAlertType.autoReorder:
        return '自动补货';
      case InventoryAlertType.stockOut:
        return '缺货';
    }
  }

  String get value {
    switch (this) {
      case InventoryAlertType.lowStock:
        return 'low_stock';
      case InventoryAlertType.expiryWarning:
        return 'expiry_warning';
      case InventoryAlertType.expired:
        return 'expired';
      case InventoryAlertType.qualityIssue:
        return 'quality_issue';
      case InventoryAlertType.autoReorder:
        return 'auto_reorder';
      case InventoryAlertType.stockOut:
        return 'stock_out';
    }
  }
}

extension InventoryAlertSeverityX on InventoryAlertSeverity {
  String get displayName {
    switch (this) {
      case InventoryAlertSeverity.low:
        return '低';
      case InventoryAlertSeverity.medium:
        return '中';
      case InventoryAlertSeverity.high:
        return '高';
      case InventoryAlertSeverity.critical:
        return '紧急';
    }
  }

  String get value {
    switch (this) {
      case InventoryAlertSeverity.low:
        return 'low';
      case InventoryAlertSeverity.medium:
        return 'medium';
      case InventoryAlertSeverity.high:
        return 'high';
      case InventoryAlertSeverity.critical:
        return 'critical';
    }
  }
}

// Computed properties for InventoryEntity
extension InventoryEntityX on InventoryEntity {
  bool get isLowStock => availableStock <= minThreshold;
  
  bool get hasExpiringSoon {
    final now = DateTime.now();
    return stockBatches.any((batch) => 
      batch.expiryDate.difference(now).inDays <= alertSettings.expiryWarningDays
    );
  }
  
  bool get hasExpired {
    final now = DateTime.now();
    return stockBatches.any((batch) => batch.expiryDate.isBefore(now));
  }
  
  double get stockValue {
    return stockBatches.fold(0.0, (sum, batch) => sum + (batch.quantity * batch.unitCost));
  }
  
  int get daysUntilStockOut {
    if (usageStats.averageDailyUsage <= 0) return 999;
    return (availableStock / usageStats.averageDailyUsage).round();
  }
  
  List<StockBatch> get expiringBatches {
    final now = DateTime.now();
    final warningDate = now.add(Duration(days: alertSettings.expiryWarningDays));
    return stockBatches
        .where((batch) => batch.expiryDate.isBefore(warningDate) && batch.expiryDate.isAfter(now))
        .toList();
  }
  
  List<StockBatch> get expiredBatches {
    final now = DateTime.now();
    return stockBatches.where((batch) => batch.expiryDate.isBefore(now)).toList();
  }
}