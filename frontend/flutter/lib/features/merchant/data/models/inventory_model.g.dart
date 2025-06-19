// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryModelImpl _$$InventoryModelImplFromJson(Map<String, dynamic> json) =>
    _$InventoryModelImpl(
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
              ?.map((e) => StockBatchModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      alertSettings: AlertSettingsModel.fromJson(
          json['alert_settings'] as Map<String, dynamic>),
      usageStats:
          UsageStatsModel.fromJson(json['usage_stats'] as Map<String, dynamic>),
      status: json['status'] as String? ?? 'active',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$InventoryModelImplToJson(
        _$InventoryModelImpl instance) =>
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

_$StockBatchModelImpl _$$StockBatchModelImplFromJson(
        Map<String, dynamic> json) =>
    _$StockBatchModelImpl(
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

Map<String, dynamic> _$$StockBatchModelImplToJson(
        _$StockBatchModelImpl instance) =>
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

_$AlertSettingsModelImpl _$$AlertSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AlertSettingsModelImpl(
      lowStockAlert: json['low_stock_alert'] as bool? ?? true,
      expiryAlert: json['expiry_alert'] as bool? ?? true,
      qualityAlert: json['quality_alert'] as bool? ?? true,
      expiryWarningDays: (json['expiry_warning_days'] as num?)?.toInt() ?? 3,
      lowStockRatio: (json['low_stock_ratio'] as num?)?.toDouble() ?? 0.2,
    );

Map<String, dynamic> _$$AlertSettingsModelImplToJson(
        _$AlertSettingsModelImpl instance) =>
    <String, dynamic>{
      'low_stock_alert': instance.lowStockAlert,
      'expiry_alert': instance.expiryAlert,
      'quality_alert': instance.qualityAlert,
      'expiry_warning_days': instance.expiryWarningDays,
      'low_stock_ratio': instance.lowStockRatio,
    };

_$UsageStatsModelImpl _$$UsageStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UsageStatsModelImpl(
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

Map<String, dynamic> _$$UsageStatsModelImplToJson(
        _$UsageStatsModelImpl instance) =>
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

_$InventoryAlertModelImpl _$$InventoryAlertModelImplFromJson(
        Map<String, dynamic> json) =>
    _$InventoryAlertModelImpl(
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

Map<String, dynamic> _$$InventoryAlertModelImplToJson(
        _$InventoryAlertModelImpl instance) =>
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

_$InventoryCreateRequestImpl _$$InventoryCreateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$InventoryCreateRequestImpl(
      name: json['name'] as String,
      unit: json['unit'] as String,
      category: json['category'] as String? ?? 'ingredient',
      minThreshold: (json['min_threshold'] as num).toDouble(),
      alertSettings: AlertSettingsModel.fromJson(
          json['alert_settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$InventoryCreateRequestImplToJson(
        _$InventoryCreateRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'unit': instance.unit,
      'category': instance.category,
      'min_threshold': instance.minThreshold,
      'alert_settings': instance.alertSettings.toJson(),
    };

_$StockAddRequestImpl _$$StockAddRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$StockAddRequestImpl(
      quantity: (json['quantity'] as num).toDouble(),
      unitCost: (json['unit_cost'] as num).toDouble(),
      expiryDate: DateTime.parse(json['expiry_date'] as String),
      supplier: json['supplier'] as String? ?? '',
      batchNumber: json['batch_number'] as String? ?? '',
      qualityGrade: json['quality_grade'] as String? ?? '',
      storageLocation: json['storage_location'] as String? ?? '',
    );

Map<String, dynamic> _$$StockAddRequestImplToJson(
        _$StockAddRequestImpl instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'unit_cost': instance.unitCost,
      'expiry_date': instance.expiryDate.toIso8601String(),
      'supplier': instance.supplier,
      'batch_number': instance.batchNumber,
      'quality_grade': instance.qualityGrade,
      'storage_location': instance.storageLocation,
    };

_$StockConsumeRequestImpl _$$StockConsumeRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$StockConsumeRequestImpl(
      quantity: (json['quantity'] as num).toDouble(),
      reason: json['reason'] as String? ?? '',
    );

Map<String, dynamic> _$$StockConsumeRequestImplToJson(
        _$StockConsumeRequestImpl instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'reason': instance.reason,
    };
