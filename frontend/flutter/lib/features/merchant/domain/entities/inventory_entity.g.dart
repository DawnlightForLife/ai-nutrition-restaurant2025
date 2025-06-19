// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryEntityImpl _$$InventoryEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$InventoryEntityImpl(
      id: json['_id'] as String,
      merchantId: json['merchant_id'] as String,
      ingredientId: json['ingredient_id'] as String,
      ingredientName: json['ingredient_name'] as String,
      totalStock: (json['total_stock'] as num).toDouble(),
      availableStock: (json['available_stock'] as num).toDouble(),
      reservedStock: (json['reserved_stock'] as num).toDouble(),
      minThreshold: (json['min_threshold'] as num).toDouble(),
      unit: json['unit'] as String,
      stockBatches: (json['stock_batches'] as List<dynamic>?)
              ?.map((e) => StockBatch.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      alertSettings: AlertSettings.fromJson(
          json['alert_settings'] as Map<String, dynamic>),
      usageStats:
          UsageStats.fromJson(json['usage_stats'] as Map<String, dynamic>),
      status: json['status'] as String? ?? 'active',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$InventoryEntityImplToJson(
        _$InventoryEntityImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'merchant_id': instance.merchantId,
      'ingredient_id': instance.ingredientId,
      'ingredient_name': instance.ingredientName,
      'total_stock': instance.totalStock,
      'available_stock': instance.availableStock,
      'reserved_stock': instance.reservedStock,
      'min_threshold': instance.minThreshold,
      'unit': instance.unit,
      'stock_batches': instance.stockBatches.map((e) => e.toJson()).toList(),
      'alert_settings': instance.alertSettings.toJson(),
      'usage_stats': instance.usageStats.toJson(),
      'status': instance.status,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

_$StockBatchImpl _$$StockBatchImplFromJson(Map<String, dynamic> json) =>
    _$StockBatchImpl(
      batchId: json['batch_id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      originalQuantity: (json['original_quantity'] as num).toDouble(),
      receivedDate: DateTime.parse(json['received_date'] as String),
      expiryDate: DateTime.parse(json['expiry_date'] as String),
      unitCost: (json['unit_cost'] as num).toDouble(),
      supplier: json['supplier'] as String? ?? '',
      qualityGrade: json['quality_grade'] as String? ?? '',
      storageLocation: json['storage_location'] as String? ?? '',
      status: json['status'] as String? ?? 'good',
    );

Map<String, dynamic> _$$StockBatchImplToJson(_$StockBatchImpl instance) =>
    <String, dynamic>{
      'batch_id': instance.batchId,
      'quantity': instance.quantity,
      'original_quantity': instance.originalQuantity,
      'received_date': instance.receivedDate.toIso8601String(),
      'expiry_date': instance.expiryDate.toIso8601String(),
      'unit_cost': instance.unitCost,
      'supplier': instance.supplier,
      'quality_grade': instance.qualityGrade,
      'storage_location': instance.storageLocation,
      'status': instance.status,
    };

_$AlertSettingsImpl _$$AlertSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AlertSettingsImpl(
      lowStockAlert: json['low_stock_alert'] as bool? ?? true,
      expiryAlert: json['expiry_alert'] as bool? ?? true,
      qualityAlert: json['quality_alert'] as bool? ?? true,
      expiryWarningDays: (json['expiry_warning_days'] as num?)?.toInt() ?? 3,
      lowStockRatio: (json['low_stock_ratio'] as num?)?.toDouble() ?? 0.2,
    );

Map<String, dynamic> _$$AlertSettingsImplToJson(_$AlertSettingsImpl instance) =>
    <String, dynamic>{
      'low_stock_alert': instance.lowStockAlert,
      'expiry_alert': instance.expiryAlert,
      'quality_alert': instance.qualityAlert,
      'expiry_warning_days': instance.expiryWarningDays,
      'low_stock_ratio': instance.lowStockRatio,
    };

_$UsageStatsImpl _$$UsageStatsImplFromJson(Map<String, dynamic> json) =>
    _$UsageStatsImpl(
      averageDailyUsage:
          (json['average_daily_usage'] as num?)?.toDouble() ?? 0.0,
      totalUsedThisMonth:
          (json['total_used_this_month'] as num?)?.toDouble() ?? 0.0,
      totalWasteThisMonth:
          (json['total_waste_this_month'] as num?)?.toDouble() ?? 0.0,
      lastUsed: json['last_used'] == null
          ? null
          : DateTime.parse(json['last_used'] as String),
      lastRestocked: json['last_restocked'] == null
          ? null
          : DateTime.parse(json['last_restocked'] as String),
      restockCount: (json['restock_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UsageStatsImplToJson(_$UsageStatsImpl instance) =>
    <String, dynamic>{
      'average_daily_usage': instance.averageDailyUsage,
      'total_used_this_month': instance.totalUsedThisMonth,
      'total_waste_this_month': instance.totalWasteThisMonth,
      if (instance.lastUsed?.toIso8601String() case final value?)
        'last_used': value,
      if (instance.lastRestocked?.toIso8601String() case final value?)
        'last_restocked': value,
      'restock_count': instance.restockCount,
    };

_$InventoryAlertImpl _$$InventoryAlertImplFromJson(Map<String, dynamic> json) =>
    _$InventoryAlertImpl(
      id: json['_id'] as String,
      inventoryId: json['inventory_id'] as String,
      merchantId: json['merchant_id'] as String,
      type: $enumDecode(_$InventoryAlertTypeEnumMap, json['type']),
      severity: $enumDecode(_$InventoryAlertSeverityEnumMap, json['severity']),
      message: json['message'] as String,
      details: json['details'] as Map<String, dynamic>,
      isRead: json['is_read'] as bool? ?? false,
      isResolved: json['is_resolved'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$InventoryAlertImplToJson(
        _$InventoryAlertImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'inventory_id': instance.inventoryId,
      'merchant_id': instance.merchantId,
      'type': _$InventoryAlertTypeEnumMap[instance.type]!,
      'severity': _$InventoryAlertSeverityEnumMap[instance.severity]!,
      'message': instance.message,
      'details': instance.details,
      'is_read': instance.isRead,
      'is_resolved': instance.isResolved,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
    };

const _$InventoryAlertTypeEnumMap = {
  InventoryAlertType.lowStock: 'low_stock',
  InventoryAlertType.expiryWarning: 'expiry_warning',
  InventoryAlertType.expired: 'expired',
  InventoryAlertType.qualityIssue: 'quality_issue',
  InventoryAlertType.autoReorder: 'auto_reorder',
  InventoryAlertType.stockOut: 'stock_out',
};

const _$InventoryAlertSeverityEnumMap = {
  InventoryAlertSeverity.low: 'low',
  InventoryAlertSeverity.medium: 'medium',
  InventoryAlertSeverity.high: 'high',
  InventoryAlertSeverity.critical: 'critical',
};
