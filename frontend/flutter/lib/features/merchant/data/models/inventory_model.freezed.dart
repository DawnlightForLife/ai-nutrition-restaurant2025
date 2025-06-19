// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InventoryModel _$InventoryModelFromJson(Map<String, dynamic> json) {
  return _InventoryModel.fromJson(json);
}

/// @nodoc
mixin _$InventoryModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get merchantId => throw _privateConstructorUsedError;
  String get ingredientId => throw _privateConstructorUsedError;
  String get ingredientName => throw _privateConstructorUsedError;
  double get totalStock => throw _privateConstructorUsedError;
  double get availableStock => throw _privateConstructorUsedError;
  double get reservedStock => throw _privateConstructorUsedError;
  double get minThreshold => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  List<StockBatchModel> get stockBatches => throw _privateConstructorUsedError;
  AlertSettingsModel get alertSettings => throw _privateConstructorUsedError;
  UsageStatsModel get usageStats => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_InventoryModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InventoryModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InventoryModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this InventoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryModelCopyWith<InventoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryModelCopyWith<$Res> {
  factory $InventoryModelCopyWith(
          InventoryModel value, $Res Function(InventoryModel) then) =
      _$InventoryModelCopyWithImpl<$Res, InventoryModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String merchantId,
      String ingredientId,
      String ingredientName,
      double totalStock,
      double availableStock,
      double reservedStock,
      double minThreshold,
      String unit,
      List<StockBatchModel> stockBatches,
      AlertSettingsModel alertSettings,
      UsageStatsModel usageStats,
      String status,
      DateTime? createdAt,
      DateTime? updatedAt});

  $AlertSettingsModelCopyWith<$Res> get alertSettings;
  $UsageStatsModelCopyWith<$Res> get usageStats;
}

/// @nodoc
class _$InventoryModelCopyWithImpl<$Res, $Val extends InventoryModel>
    implements $InventoryModelCopyWith<$Res> {
  _$InventoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? merchantId = null,
    Object? ingredientId = null,
    Object? ingredientName = null,
    Object? totalStock = null,
    Object? availableStock = null,
    Object? reservedStock = null,
    Object? minThreshold = null,
    Object? unit = null,
    Object? stockBatches = null,
    Object? alertSettings = null,
    Object? usageStats = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientName: null == ingredientName
          ? _value.ingredientName
          : ingredientName // ignore: cast_nullable_to_non_nullable
              as String,
      totalStock: null == totalStock
          ? _value.totalStock
          : totalStock // ignore: cast_nullable_to_non_nullable
              as double,
      availableStock: null == availableStock
          ? _value.availableStock
          : availableStock // ignore: cast_nullable_to_non_nullable
              as double,
      reservedStock: null == reservedStock
          ? _value.reservedStock
          : reservedStock // ignore: cast_nullable_to_non_nullable
              as double,
      minThreshold: null == minThreshold
          ? _value.minThreshold
          : minThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      stockBatches: null == stockBatches
          ? _value.stockBatches
          : stockBatches // ignore: cast_nullable_to_non_nullable
              as List<StockBatchModel>,
      alertSettings: null == alertSettings
          ? _value.alertSettings
          : alertSettings // ignore: cast_nullable_to_non_nullable
              as AlertSettingsModel,
      usageStats: null == usageStats
          ? _value.usageStats
          : usageStats // ignore: cast_nullable_to_non_nullable
              as UsageStatsModel,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AlertSettingsModelCopyWith<$Res> get alertSettings {
    return $AlertSettingsModelCopyWith<$Res>(_value.alertSettings, (value) {
      return _then(_value.copyWith(alertSettings: value) as $Val);
    });
  }

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsageStatsModelCopyWith<$Res> get usageStats {
    return $UsageStatsModelCopyWith<$Res>(_value.usageStats, (value) {
      return _then(_value.copyWith(usageStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InventoryModelImplCopyWith<$Res>
    implements $InventoryModelCopyWith<$Res> {
  factory _$$InventoryModelImplCopyWith(_$InventoryModelImpl value,
          $Res Function(_$InventoryModelImpl) then) =
      __$$InventoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String merchantId,
      String ingredientId,
      String ingredientName,
      double totalStock,
      double availableStock,
      double reservedStock,
      double minThreshold,
      String unit,
      List<StockBatchModel> stockBatches,
      AlertSettingsModel alertSettings,
      UsageStatsModel usageStats,
      String status,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $AlertSettingsModelCopyWith<$Res> get alertSettings;
  @override
  $UsageStatsModelCopyWith<$Res> get usageStats;
}

/// @nodoc
class __$$InventoryModelImplCopyWithImpl<$Res>
    extends _$InventoryModelCopyWithImpl<$Res, _$InventoryModelImpl>
    implements _$$InventoryModelImplCopyWith<$Res> {
  __$$InventoryModelImplCopyWithImpl(
      _$InventoryModelImpl _value, $Res Function(_$InventoryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? merchantId = null,
    Object? ingredientId = null,
    Object? ingredientName = null,
    Object? totalStock = null,
    Object? availableStock = null,
    Object? reservedStock = null,
    Object? minThreshold = null,
    Object? unit = null,
    Object? stockBatches = null,
    Object? alertSettings = null,
    Object? usageStats = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$InventoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientName: null == ingredientName
          ? _value.ingredientName
          : ingredientName // ignore: cast_nullable_to_non_nullable
              as String,
      totalStock: null == totalStock
          ? _value.totalStock
          : totalStock // ignore: cast_nullable_to_non_nullable
              as double,
      availableStock: null == availableStock
          ? _value.availableStock
          : availableStock // ignore: cast_nullable_to_non_nullable
              as double,
      reservedStock: null == reservedStock
          ? _value.reservedStock
          : reservedStock // ignore: cast_nullable_to_non_nullable
              as double,
      minThreshold: null == minThreshold
          ? _value.minThreshold
          : minThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      stockBatches: null == stockBatches
          ? _value._stockBatches
          : stockBatches // ignore: cast_nullable_to_non_nullable
              as List<StockBatchModel>,
      alertSettings: null == alertSettings
          ? _value.alertSettings
          : alertSettings // ignore: cast_nullable_to_non_nullable
              as AlertSettingsModel,
      usageStats: null == usageStats
          ? _value.usageStats
          : usageStats // ignore: cast_nullable_to_non_nullable
              as UsageStatsModel,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryModelImpl implements _InventoryModel {
  const _$InventoryModelImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.merchantId,
      required this.ingredientId,
      required this.ingredientName,
      required this.totalStock,
      required this.availableStock,
      required this.reservedStock,
      required this.minThreshold,
      required this.unit,
      final List<StockBatchModel> stockBatches = const [],
      required this.alertSettings,
      required this.usageStats,
      this.status = 'active',
      this.createdAt,
      this.updatedAt})
      : _stockBatches = stockBatches;

  factory _$InventoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String merchantId;
  @override
  final String ingredientId;
  @override
  final String ingredientName;
  @override
  final double totalStock;
  @override
  final double availableStock;
  @override
  final double reservedStock;
  @override
  final double minThreshold;
  @override
  final String unit;
  final List<StockBatchModel> _stockBatches;
  @override
  @JsonKey()
  List<StockBatchModel> get stockBatches {
    if (_stockBatches is EqualUnmodifiableListView) return _stockBatches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stockBatches);
  }

  @override
  final AlertSettingsModel alertSettings;
  @override
  final UsageStatsModel usageStats;
  @override
  @JsonKey()
  final String status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'InventoryModel(id: $id, merchantId: $merchantId, ingredientId: $ingredientId, ingredientName: $ingredientName, totalStock: $totalStock, availableStock: $availableStock, reservedStock: $reservedStock, minThreshold: $minThreshold, unit: $unit, stockBatches: $stockBatches, alertSettings: $alertSettings, usageStats: $usageStats, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.ingredientId, ingredientId) ||
                other.ingredientId == ingredientId) &&
            (identical(other.ingredientName, ingredientName) ||
                other.ingredientName == ingredientName) &&
            (identical(other.totalStock, totalStock) ||
                other.totalStock == totalStock) &&
            (identical(other.availableStock, availableStock) ||
                other.availableStock == availableStock) &&
            (identical(other.reservedStock, reservedStock) ||
                other.reservedStock == reservedStock) &&
            (identical(other.minThreshold, minThreshold) ||
                other.minThreshold == minThreshold) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            const DeepCollectionEquality()
                .equals(other._stockBatches, _stockBatches) &&
            (identical(other.alertSettings, alertSettings) ||
                other.alertSettings == alertSettings) &&
            (identical(other.usageStats, usageStats) ||
                other.usageStats == usageStats) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      merchantId,
      ingredientId,
      ingredientName,
      totalStock,
      availableStock,
      reservedStock,
      minThreshold,
      unit,
      const DeepCollectionEquality().hash(_stockBatches),
      alertSettings,
      usageStats,
      status,
      createdAt,
      updatedAt);

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryModelImplCopyWith<_$InventoryModelImpl> get copyWith =>
      __$$InventoryModelImplCopyWithImpl<_$InventoryModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_InventoryModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InventoryModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InventoryModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryModelImplToJson(
      this,
    );
  }
}

abstract class _InventoryModel implements InventoryModel {
  const factory _InventoryModel(
      {@JsonKey(name: '_id') required final String id,
      required final String merchantId,
      required final String ingredientId,
      required final String ingredientName,
      required final double totalStock,
      required final double availableStock,
      required final double reservedStock,
      required final double minThreshold,
      required final String unit,
      final List<StockBatchModel> stockBatches,
      required final AlertSettingsModel alertSettings,
      required final UsageStatsModel usageStats,
      final String status,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$InventoryModelImpl;

  factory _InventoryModel.fromJson(Map<String, dynamic> json) =
      _$InventoryModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get merchantId;
  @override
  String get ingredientId;
  @override
  String get ingredientName;
  @override
  double get totalStock;
  @override
  double get availableStock;
  @override
  double get reservedStock;
  @override
  double get minThreshold;
  @override
  String get unit;
  @override
  List<StockBatchModel> get stockBatches;
  @override
  AlertSettingsModel get alertSettings;
  @override
  UsageStatsModel get usageStats;
  @override
  String get status;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryModelImplCopyWith<_$InventoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockBatchModel _$StockBatchModelFromJson(Map<String, dynamic> json) {
  return _StockBatchModel.fromJson(json);
}

/// @nodoc
mixin _$StockBatchModel {
  String get batchId => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  double get originalQuantity => throw _privateConstructorUsedError;
  DateTime get receivedDate => throw _privateConstructorUsedError;
  DateTime get expiryDate => throw _privateConstructorUsedError;
  double get unitCost => throw _privateConstructorUsedError;
  String get supplier => throw _privateConstructorUsedError;
  String get qualityGrade => throw _privateConstructorUsedError;
  String get storageLocation => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StockBatchModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StockBatchModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StockBatchModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this StockBatchModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockBatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockBatchModelCopyWith<StockBatchModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockBatchModelCopyWith<$Res> {
  factory $StockBatchModelCopyWith(
          StockBatchModel value, $Res Function(StockBatchModel) then) =
      _$StockBatchModelCopyWithImpl<$Res, StockBatchModel>;
  @useResult
  $Res call(
      {String batchId,
      double quantity,
      double originalQuantity,
      DateTime receivedDate,
      DateTime expiryDate,
      double unitCost,
      String supplier,
      String qualityGrade,
      String storageLocation,
      String status});
}

/// @nodoc
class _$StockBatchModelCopyWithImpl<$Res, $Val extends StockBatchModel>
    implements $StockBatchModelCopyWith<$Res> {
  _$StockBatchModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockBatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? batchId = null,
    Object? quantity = null,
    Object? originalQuantity = null,
    Object? receivedDate = null,
    Object? expiryDate = null,
    Object? unitCost = null,
    Object? supplier = null,
    Object? qualityGrade = null,
    Object? storageLocation = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      batchId: null == batchId
          ? _value.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      originalQuantity: null == originalQuantity
          ? _value.originalQuantity
          : originalQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      receivedDate: null == receivedDate
          ? _value.receivedDate
          : receivedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiryDate: null == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      unitCost: null == unitCost
          ? _value.unitCost
          : unitCost // ignore: cast_nullable_to_non_nullable
              as double,
      supplier: null == supplier
          ? _value.supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as String,
      qualityGrade: null == qualityGrade
          ? _value.qualityGrade
          : qualityGrade // ignore: cast_nullable_to_non_nullable
              as String,
      storageLocation: null == storageLocation
          ? _value.storageLocation
          : storageLocation // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockBatchModelImplCopyWith<$Res>
    implements $StockBatchModelCopyWith<$Res> {
  factory _$$StockBatchModelImplCopyWith(_$StockBatchModelImpl value,
          $Res Function(_$StockBatchModelImpl) then) =
      __$$StockBatchModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String batchId,
      double quantity,
      double originalQuantity,
      DateTime receivedDate,
      DateTime expiryDate,
      double unitCost,
      String supplier,
      String qualityGrade,
      String storageLocation,
      String status});
}

/// @nodoc
class __$$StockBatchModelImplCopyWithImpl<$Res>
    extends _$StockBatchModelCopyWithImpl<$Res, _$StockBatchModelImpl>
    implements _$$StockBatchModelImplCopyWith<$Res> {
  __$$StockBatchModelImplCopyWithImpl(
      _$StockBatchModelImpl _value, $Res Function(_$StockBatchModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockBatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? batchId = null,
    Object? quantity = null,
    Object? originalQuantity = null,
    Object? receivedDate = null,
    Object? expiryDate = null,
    Object? unitCost = null,
    Object? supplier = null,
    Object? qualityGrade = null,
    Object? storageLocation = null,
    Object? status = null,
  }) {
    return _then(_$StockBatchModelImpl(
      batchId: null == batchId
          ? _value.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      originalQuantity: null == originalQuantity
          ? _value.originalQuantity
          : originalQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      receivedDate: null == receivedDate
          ? _value.receivedDate
          : receivedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiryDate: null == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      unitCost: null == unitCost
          ? _value.unitCost
          : unitCost // ignore: cast_nullable_to_non_nullable
              as double,
      supplier: null == supplier
          ? _value.supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as String,
      qualityGrade: null == qualityGrade
          ? _value.qualityGrade
          : qualityGrade // ignore: cast_nullable_to_non_nullable
              as String,
      storageLocation: null == storageLocation
          ? _value.storageLocation
          : storageLocation // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockBatchModelImpl implements _StockBatchModel {
  const _$StockBatchModelImpl(
      {required this.batchId,
      required this.quantity,
      required this.originalQuantity,
      required this.receivedDate,
      required this.expiryDate,
      required this.unitCost,
      this.supplier = '',
      this.qualityGrade = '',
      this.storageLocation = '',
      this.status = 'good'});

  factory _$StockBatchModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockBatchModelImplFromJson(json);

  @override
  final String batchId;
  @override
  final double quantity;
  @override
  final double originalQuantity;
  @override
  final DateTime receivedDate;
  @override
  final DateTime expiryDate;
  @override
  final double unitCost;
  @override
  @JsonKey()
  final String supplier;
  @override
  @JsonKey()
  final String qualityGrade;
  @override
  @JsonKey()
  final String storageLocation;
  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'StockBatchModel(batchId: $batchId, quantity: $quantity, originalQuantity: $originalQuantity, receivedDate: $receivedDate, expiryDate: $expiryDate, unitCost: $unitCost, supplier: $supplier, qualityGrade: $qualityGrade, storageLocation: $storageLocation, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockBatchModelImpl &&
            (identical(other.batchId, batchId) || other.batchId == batchId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.originalQuantity, originalQuantity) ||
                other.originalQuantity == originalQuantity) &&
            (identical(other.receivedDate, receivedDate) ||
                other.receivedDate == receivedDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.unitCost, unitCost) ||
                other.unitCost == unitCost) &&
            (identical(other.supplier, supplier) ||
                other.supplier == supplier) &&
            (identical(other.qualityGrade, qualityGrade) ||
                other.qualityGrade == qualityGrade) &&
            (identical(other.storageLocation, storageLocation) ||
                other.storageLocation == storageLocation) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      batchId,
      quantity,
      originalQuantity,
      receivedDate,
      expiryDate,
      unitCost,
      supplier,
      qualityGrade,
      storageLocation,
      status);

  /// Create a copy of StockBatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockBatchModelImplCopyWith<_$StockBatchModelImpl> get copyWith =>
      __$$StockBatchModelImplCopyWithImpl<_$StockBatchModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StockBatchModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StockBatchModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StockBatchModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StockBatchModelImplToJson(
      this,
    );
  }
}

abstract class _StockBatchModel implements StockBatchModel {
  const factory _StockBatchModel(
      {required final String batchId,
      required final double quantity,
      required final double originalQuantity,
      required final DateTime receivedDate,
      required final DateTime expiryDate,
      required final double unitCost,
      final String supplier,
      final String qualityGrade,
      final String storageLocation,
      final String status}) = _$StockBatchModelImpl;

  factory _StockBatchModel.fromJson(Map<String, dynamic> json) =
      _$StockBatchModelImpl.fromJson;

  @override
  String get batchId;
  @override
  double get quantity;
  @override
  double get originalQuantity;
  @override
  DateTime get receivedDate;
  @override
  DateTime get expiryDate;
  @override
  double get unitCost;
  @override
  String get supplier;
  @override
  String get qualityGrade;
  @override
  String get storageLocation;
  @override
  String get status;

  /// Create a copy of StockBatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockBatchModelImplCopyWith<_$StockBatchModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AlertSettingsModel _$AlertSettingsModelFromJson(Map<String, dynamic> json) {
  return _AlertSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$AlertSettingsModel {
  bool get lowStockAlert => throw _privateConstructorUsedError;
  bool get expiryAlert => throw _privateConstructorUsedError;
  bool get qualityAlert => throw _privateConstructorUsedError;
  int get expiryWarningDays => throw _privateConstructorUsedError;
  double get lowStockRatio => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AlertSettingsModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AlertSettingsModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AlertSettingsModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this AlertSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertSettingsModelCopyWith<AlertSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertSettingsModelCopyWith<$Res> {
  factory $AlertSettingsModelCopyWith(
          AlertSettingsModel value, $Res Function(AlertSettingsModel) then) =
      _$AlertSettingsModelCopyWithImpl<$Res, AlertSettingsModel>;
  @useResult
  $Res call(
      {bool lowStockAlert,
      bool expiryAlert,
      bool qualityAlert,
      int expiryWarningDays,
      double lowStockRatio});
}

/// @nodoc
class _$AlertSettingsModelCopyWithImpl<$Res, $Val extends AlertSettingsModel>
    implements $AlertSettingsModelCopyWith<$Res> {
  _$AlertSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lowStockAlert = null,
    Object? expiryAlert = null,
    Object? qualityAlert = null,
    Object? expiryWarningDays = null,
    Object? lowStockRatio = null,
  }) {
    return _then(_value.copyWith(
      lowStockAlert: null == lowStockAlert
          ? _value.lowStockAlert
          : lowStockAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      expiryAlert: null == expiryAlert
          ? _value.expiryAlert
          : expiryAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      qualityAlert: null == qualityAlert
          ? _value.qualityAlert
          : qualityAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      expiryWarningDays: null == expiryWarningDays
          ? _value.expiryWarningDays
          : expiryWarningDays // ignore: cast_nullable_to_non_nullable
              as int,
      lowStockRatio: null == lowStockRatio
          ? _value.lowStockRatio
          : lowStockRatio // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlertSettingsModelImplCopyWith<$Res>
    implements $AlertSettingsModelCopyWith<$Res> {
  factory _$$AlertSettingsModelImplCopyWith(_$AlertSettingsModelImpl value,
          $Res Function(_$AlertSettingsModelImpl) then) =
      __$$AlertSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool lowStockAlert,
      bool expiryAlert,
      bool qualityAlert,
      int expiryWarningDays,
      double lowStockRatio});
}

/// @nodoc
class __$$AlertSettingsModelImplCopyWithImpl<$Res>
    extends _$AlertSettingsModelCopyWithImpl<$Res, _$AlertSettingsModelImpl>
    implements _$$AlertSettingsModelImplCopyWith<$Res> {
  __$$AlertSettingsModelImplCopyWithImpl(_$AlertSettingsModelImpl _value,
      $Res Function(_$AlertSettingsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlertSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lowStockAlert = null,
    Object? expiryAlert = null,
    Object? qualityAlert = null,
    Object? expiryWarningDays = null,
    Object? lowStockRatio = null,
  }) {
    return _then(_$AlertSettingsModelImpl(
      lowStockAlert: null == lowStockAlert
          ? _value.lowStockAlert
          : lowStockAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      expiryAlert: null == expiryAlert
          ? _value.expiryAlert
          : expiryAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      qualityAlert: null == qualityAlert
          ? _value.qualityAlert
          : qualityAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      expiryWarningDays: null == expiryWarningDays
          ? _value.expiryWarningDays
          : expiryWarningDays // ignore: cast_nullable_to_non_nullable
              as int,
      lowStockRatio: null == lowStockRatio
          ? _value.lowStockRatio
          : lowStockRatio // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertSettingsModelImpl implements _AlertSettingsModel {
  const _$AlertSettingsModelImpl(
      {this.lowStockAlert = true,
      this.expiryAlert = true,
      this.qualityAlert = true,
      this.expiryWarningDays = 3,
      this.lowStockRatio = 0.2});

  factory _$AlertSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertSettingsModelImplFromJson(json);

  @override
  @JsonKey()
  final bool lowStockAlert;
  @override
  @JsonKey()
  final bool expiryAlert;
  @override
  @JsonKey()
  final bool qualityAlert;
  @override
  @JsonKey()
  final int expiryWarningDays;
  @override
  @JsonKey()
  final double lowStockRatio;

  @override
  String toString() {
    return 'AlertSettingsModel(lowStockAlert: $lowStockAlert, expiryAlert: $expiryAlert, qualityAlert: $qualityAlert, expiryWarningDays: $expiryWarningDays, lowStockRatio: $lowStockRatio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertSettingsModelImpl &&
            (identical(other.lowStockAlert, lowStockAlert) ||
                other.lowStockAlert == lowStockAlert) &&
            (identical(other.expiryAlert, expiryAlert) ||
                other.expiryAlert == expiryAlert) &&
            (identical(other.qualityAlert, qualityAlert) ||
                other.qualityAlert == qualityAlert) &&
            (identical(other.expiryWarningDays, expiryWarningDays) ||
                other.expiryWarningDays == expiryWarningDays) &&
            (identical(other.lowStockRatio, lowStockRatio) ||
                other.lowStockRatio == lowStockRatio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lowStockAlert, expiryAlert,
      qualityAlert, expiryWarningDays, lowStockRatio);

  /// Create a copy of AlertSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertSettingsModelImplCopyWith<_$AlertSettingsModelImpl> get copyWith =>
      __$$AlertSettingsModelImplCopyWithImpl<_$AlertSettingsModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AlertSettingsModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AlertSettingsModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AlertSettingsModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _AlertSettingsModel implements AlertSettingsModel {
  const factory _AlertSettingsModel(
      {final bool lowStockAlert,
      final bool expiryAlert,
      final bool qualityAlert,
      final int expiryWarningDays,
      final double lowStockRatio}) = _$AlertSettingsModelImpl;

  factory _AlertSettingsModel.fromJson(Map<String, dynamic> json) =
      _$AlertSettingsModelImpl.fromJson;

  @override
  bool get lowStockAlert;
  @override
  bool get expiryAlert;
  @override
  bool get qualityAlert;
  @override
  int get expiryWarningDays;
  @override
  double get lowStockRatio;

  /// Create a copy of AlertSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertSettingsModelImplCopyWith<_$AlertSettingsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UsageStatsModel _$UsageStatsModelFromJson(Map<String, dynamic> json) {
  return _UsageStatsModel.fromJson(json);
}

/// @nodoc
mixin _$UsageStatsModel {
  double get averageDailyUsage => throw _privateConstructorUsedError;
  double get totalUsedThisMonth => throw _privateConstructorUsedError;
  double get totalWasteThisMonth => throw _privateConstructorUsedError;
  DateTime? get lastUsed => throw _privateConstructorUsedError;
  DateTime? get lastRestocked => throw _privateConstructorUsedError;
  int get restockCount => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UsageStatsModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UsageStatsModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UsageStatsModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this UsageStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UsageStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsageStatsModelCopyWith<UsageStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsageStatsModelCopyWith<$Res> {
  factory $UsageStatsModelCopyWith(
          UsageStatsModel value, $Res Function(UsageStatsModel) then) =
      _$UsageStatsModelCopyWithImpl<$Res, UsageStatsModel>;
  @useResult
  $Res call(
      {double averageDailyUsage,
      double totalUsedThisMonth,
      double totalWasteThisMonth,
      DateTime? lastUsed,
      DateTime? lastRestocked,
      int restockCount});
}

/// @nodoc
class _$UsageStatsModelCopyWithImpl<$Res, $Val extends UsageStatsModel>
    implements $UsageStatsModelCopyWith<$Res> {
  _$UsageStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsageStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageDailyUsage = null,
    Object? totalUsedThisMonth = null,
    Object? totalWasteThisMonth = null,
    Object? lastUsed = freezed,
    Object? lastRestocked = freezed,
    Object? restockCount = null,
  }) {
    return _then(_value.copyWith(
      averageDailyUsage: null == averageDailyUsage
          ? _value.averageDailyUsage
          : averageDailyUsage // ignore: cast_nullable_to_non_nullable
              as double,
      totalUsedThisMonth: null == totalUsedThisMonth
          ? _value.totalUsedThisMonth
          : totalUsedThisMonth // ignore: cast_nullable_to_non_nullable
              as double,
      totalWasteThisMonth: null == totalWasteThisMonth
          ? _value.totalWasteThisMonth
          : totalWasteThisMonth // ignore: cast_nullable_to_non_nullable
              as double,
      lastUsed: freezed == lastUsed
          ? _value.lastUsed
          : lastUsed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastRestocked: freezed == lastRestocked
          ? _value.lastRestocked
          : lastRestocked // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      restockCount: null == restockCount
          ? _value.restockCount
          : restockCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UsageStatsModelImplCopyWith<$Res>
    implements $UsageStatsModelCopyWith<$Res> {
  factory _$$UsageStatsModelImplCopyWith(_$UsageStatsModelImpl value,
          $Res Function(_$UsageStatsModelImpl) then) =
      __$$UsageStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double averageDailyUsage,
      double totalUsedThisMonth,
      double totalWasteThisMonth,
      DateTime? lastUsed,
      DateTime? lastRestocked,
      int restockCount});
}

/// @nodoc
class __$$UsageStatsModelImplCopyWithImpl<$Res>
    extends _$UsageStatsModelCopyWithImpl<$Res, _$UsageStatsModelImpl>
    implements _$$UsageStatsModelImplCopyWith<$Res> {
  __$$UsageStatsModelImplCopyWithImpl(
      _$UsageStatsModelImpl _value, $Res Function(_$UsageStatsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UsageStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageDailyUsage = null,
    Object? totalUsedThisMonth = null,
    Object? totalWasteThisMonth = null,
    Object? lastUsed = freezed,
    Object? lastRestocked = freezed,
    Object? restockCount = null,
  }) {
    return _then(_$UsageStatsModelImpl(
      averageDailyUsage: null == averageDailyUsage
          ? _value.averageDailyUsage
          : averageDailyUsage // ignore: cast_nullable_to_non_nullable
              as double,
      totalUsedThisMonth: null == totalUsedThisMonth
          ? _value.totalUsedThisMonth
          : totalUsedThisMonth // ignore: cast_nullable_to_non_nullable
              as double,
      totalWasteThisMonth: null == totalWasteThisMonth
          ? _value.totalWasteThisMonth
          : totalWasteThisMonth // ignore: cast_nullable_to_non_nullable
              as double,
      lastUsed: freezed == lastUsed
          ? _value.lastUsed
          : lastUsed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastRestocked: freezed == lastRestocked
          ? _value.lastRestocked
          : lastRestocked // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      restockCount: null == restockCount
          ? _value.restockCount
          : restockCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UsageStatsModelImpl implements _UsageStatsModel {
  const _$UsageStatsModelImpl(
      {this.averageDailyUsage = 0.0,
      this.totalUsedThisMonth = 0.0,
      this.totalWasteThisMonth = 0.0,
      this.lastUsed,
      this.lastRestocked,
      this.restockCount = 0});

  factory _$UsageStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsageStatsModelImplFromJson(json);

  @override
  @JsonKey()
  final double averageDailyUsage;
  @override
  @JsonKey()
  final double totalUsedThisMonth;
  @override
  @JsonKey()
  final double totalWasteThisMonth;
  @override
  final DateTime? lastUsed;
  @override
  final DateTime? lastRestocked;
  @override
  @JsonKey()
  final int restockCount;

  @override
  String toString() {
    return 'UsageStatsModel(averageDailyUsage: $averageDailyUsage, totalUsedThisMonth: $totalUsedThisMonth, totalWasteThisMonth: $totalWasteThisMonth, lastUsed: $lastUsed, lastRestocked: $lastRestocked, restockCount: $restockCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsageStatsModelImpl &&
            (identical(other.averageDailyUsage, averageDailyUsage) ||
                other.averageDailyUsage == averageDailyUsage) &&
            (identical(other.totalUsedThisMonth, totalUsedThisMonth) ||
                other.totalUsedThisMonth == totalUsedThisMonth) &&
            (identical(other.totalWasteThisMonth, totalWasteThisMonth) ||
                other.totalWasteThisMonth == totalWasteThisMonth) &&
            (identical(other.lastUsed, lastUsed) ||
                other.lastUsed == lastUsed) &&
            (identical(other.lastRestocked, lastRestocked) ||
                other.lastRestocked == lastRestocked) &&
            (identical(other.restockCount, restockCount) ||
                other.restockCount == restockCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      averageDailyUsage,
      totalUsedThisMonth,
      totalWasteThisMonth,
      lastUsed,
      lastRestocked,
      restockCount);

  /// Create a copy of UsageStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsageStatsModelImplCopyWith<_$UsageStatsModelImpl> get copyWith =>
      __$$UsageStatsModelImplCopyWithImpl<_$UsageStatsModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UsageStatsModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UsageStatsModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UsageStatsModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UsageStatsModelImplToJson(
      this,
    );
  }
}

abstract class _UsageStatsModel implements UsageStatsModel {
  const factory _UsageStatsModel(
      {final double averageDailyUsage,
      final double totalUsedThisMonth,
      final double totalWasteThisMonth,
      final DateTime? lastUsed,
      final DateTime? lastRestocked,
      final int restockCount}) = _$UsageStatsModelImpl;

  factory _UsageStatsModel.fromJson(Map<String, dynamic> json) =
      _$UsageStatsModelImpl.fromJson;

  @override
  double get averageDailyUsage;
  @override
  double get totalUsedThisMonth;
  @override
  double get totalWasteThisMonth;
  @override
  DateTime? get lastUsed;
  @override
  DateTime? get lastRestocked;
  @override
  int get restockCount;

  /// Create a copy of UsageStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsageStatsModelImplCopyWith<_$UsageStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryAlertModel _$InventoryAlertModelFromJson(Map<String, dynamic> json) {
  return _InventoryAlertModel.fromJson(json);
}

/// @nodoc
mixin _$InventoryAlertModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get inventoryId => throw _privateConstructorUsedError;
  String get merchantId => throw _privateConstructorUsedError;
  InventoryAlertType get type => throw _privateConstructorUsedError;
  InventoryAlertSeverity get severity => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  Map<String, dynamic> get details => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  bool get isResolved => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_InventoryAlertModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InventoryAlertModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InventoryAlertModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this InventoryAlertModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryAlertModelCopyWith<InventoryAlertModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryAlertModelCopyWith<$Res> {
  factory $InventoryAlertModelCopyWith(
          InventoryAlertModel value, $Res Function(InventoryAlertModel) then) =
      _$InventoryAlertModelCopyWithImpl<$Res, InventoryAlertModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String inventoryId,
      String merchantId,
      InventoryAlertType type,
      InventoryAlertSeverity severity,
      String message,
      Map<String, dynamic> details,
      bool isRead,
      bool isResolved,
      DateTime? createdAt});
}

/// @nodoc
class _$InventoryAlertModelCopyWithImpl<$Res, $Val extends InventoryAlertModel>
    implements $InventoryAlertModelCopyWith<$Res> {
  _$InventoryAlertModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inventoryId = null,
    Object? merchantId = null,
    Object? type = null,
    Object? severity = null,
    Object? message = null,
    Object? details = null,
    Object? isRead = null,
    Object? isResolved = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      inventoryId: null == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as InventoryAlertType,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as InventoryAlertSeverity,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryAlertModelImplCopyWith<$Res>
    implements $InventoryAlertModelCopyWith<$Res> {
  factory _$$InventoryAlertModelImplCopyWith(_$InventoryAlertModelImpl value,
          $Res Function(_$InventoryAlertModelImpl) then) =
      __$$InventoryAlertModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String inventoryId,
      String merchantId,
      InventoryAlertType type,
      InventoryAlertSeverity severity,
      String message,
      Map<String, dynamic> details,
      bool isRead,
      bool isResolved,
      DateTime? createdAt});
}

/// @nodoc
class __$$InventoryAlertModelImplCopyWithImpl<$Res>
    extends _$InventoryAlertModelCopyWithImpl<$Res, _$InventoryAlertModelImpl>
    implements _$$InventoryAlertModelImplCopyWith<$Res> {
  __$$InventoryAlertModelImplCopyWithImpl(_$InventoryAlertModelImpl _value,
      $Res Function(_$InventoryAlertModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inventoryId = null,
    Object? merchantId = null,
    Object? type = null,
    Object? severity = null,
    Object? message = null,
    Object? details = null,
    Object? isRead = null,
    Object? isResolved = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$InventoryAlertModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      inventoryId: null == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as InventoryAlertType,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as InventoryAlertSeverity,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      details: null == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryAlertModelImpl implements _InventoryAlertModel {
  const _$InventoryAlertModelImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.inventoryId,
      required this.merchantId,
      required this.type,
      required this.severity,
      required this.message,
      required final Map<String, dynamic> details,
      this.isRead = false,
      this.isResolved = false,
      this.createdAt})
      : _details = details;

  factory _$InventoryAlertModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryAlertModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String inventoryId;
  @override
  final String merchantId;
  @override
  final InventoryAlertType type;
  @override
  final InventoryAlertSeverity severity;
  @override
  final String message;
  final Map<String, dynamic> _details;
  @override
  Map<String, dynamic> get details {
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_details);
  }

  @override
  @JsonKey()
  final bool isRead;
  @override
  @JsonKey()
  final bool isResolved;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'InventoryAlertModel(id: $id, inventoryId: $inventoryId, merchantId: $merchantId, type: $type, severity: $severity, message: $message, details: $details, isRead: $isRead, isResolved: $isResolved, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryAlertModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.inventoryId, inventoryId) ||
                other.inventoryId == inventoryId) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._details, _details) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isResolved, isResolved) ||
                other.isResolved == isResolved) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      inventoryId,
      merchantId,
      type,
      severity,
      message,
      const DeepCollectionEquality().hash(_details),
      isRead,
      isResolved,
      createdAt);

  /// Create a copy of InventoryAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryAlertModelImplCopyWith<_$InventoryAlertModelImpl> get copyWith =>
      __$$InventoryAlertModelImplCopyWithImpl<_$InventoryAlertModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_InventoryAlertModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InventoryAlertModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InventoryAlertModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryAlertModelImplToJson(
      this,
    );
  }
}

abstract class _InventoryAlertModel implements InventoryAlertModel {
  const factory _InventoryAlertModel(
      {@JsonKey(name: '_id') required final String id,
      required final String inventoryId,
      required final String merchantId,
      required final InventoryAlertType type,
      required final InventoryAlertSeverity severity,
      required final String message,
      required final Map<String, dynamic> details,
      final bool isRead,
      final bool isResolved,
      final DateTime? createdAt}) = _$InventoryAlertModelImpl;

  factory _InventoryAlertModel.fromJson(Map<String, dynamic> json) =
      _$InventoryAlertModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get inventoryId;
  @override
  String get merchantId;
  @override
  InventoryAlertType get type;
  @override
  InventoryAlertSeverity get severity;
  @override
  String get message;
  @override
  Map<String, dynamic> get details;
  @override
  bool get isRead;
  @override
  bool get isResolved;
  @override
  DateTime? get createdAt;

  /// Create a copy of InventoryAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryAlertModelImplCopyWith<_$InventoryAlertModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryCreateRequest _$InventoryCreateRequestFromJson(
    Map<String, dynamic> json) {
  return _InventoryCreateRequest.fromJson(json);
}

/// @nodoc
mixin _$InventoryCreateRequest {
  String get name => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  double get minThreshold => throw _privateConstructorUsedError;
  AlertSettingsModel get alertSettings => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_InventoryCreateRequest value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InventoryCreateRequest value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InventoryCreateRequest value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this InventoryCreateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryCreateRequestCopyWith<InventoryCreateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryCreateRequestCopyWith<$Res> {
  factory $InventoryCreateRequestCopyWith(InventoryCreateRequest value,
          $Res Function(InventoryCreateRequest) then) =
      _$InventoryCreateRequestCopyWithImpl<$Res, InventoryCreateRequest>;
  @useResult
  $Res call(
      {String name,
      String unit,
      String category,
      double minThreshold,
      AlertSettingsModel alertSettings});

  $AlertSettingsModelCopyWith<$Res> get alertSettings;
}

/// @nodoc
class _$InventoryCreateRequestCopyWithImpl<$Res,
        $Val extends InventoryCreateRequest>
    implements $InventoryCreateRequestCopyWith<$Res> {
  _$InventoryCreateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? unit = null,
    Object? category = null,
    Object? minThreshold = null,
    Object? alertSettings = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      minThreshold: null == minThreshold
          ? _value.minThreshold
          : minThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      alertSettings: null == alertSettings
          ? _value.alertSettings
          : alertSettings // ignore: cast_nullable_to_non_nullable
              as AlertSettingsModel,
    ) as $Val);
  }

  /// Create a copy of InventoryCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AlertSettingsModelCopyWith<$Res> get alertSettings {
    return $AlertSettingsModelCopyWith<$Res>(_value.alertSettings, (value) {
      return _then(_value.copyWith(alertSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InventoryCreateRequestImplCopyWith<$Res>
    implements $InventoryCreateRequestCopyWith<$Res> {
  factory _$$InventoryCreateRequestImplCopyWith(
          _$InventoryCreateRequestImpl value,
          $Res Function(_$InventoryCreateRequestImpl) then) =
      __$$InventoryCreateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String unit,
      String category,
      double minThreshold,
      AlertSettingsModel alertSettings});

  @override
  $AlertSettingsModelCopyWith<$Res> get alertSettings;
}

/// @nodoc
class __$$InventoryCreateRequestImplCopyWithImpl<$Res>
    extends _$InventoryCreateRequestCopyWithImpl<$Res,
        _$InventoryCreateRequestImpl>
    implements _$$InventoryCreateRequestImplCopyWith<$Res> {
  __$$InventoryCreateRequestImplCopyWithImpl(
      _$InventoryCreateRequestImpl _value,
      $Res Function(_$InventoryCreateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? unit = null,
    Object? category = null,
    Object? minThreshold = null,
    Object? alertSettings = null,
  }) {
    return _then(_$InventoryCreateRequestImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      minThreshold: null == minThreshold
          ? _value.minThreshold
          : minThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      alertSettings: null == alertSettings
          ? _value.alertSettings
          : alertSettings // ignore: cast_nullable_to_non_nullable
              as AlertSettingsModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryCreateRequestImpl implements _InventoryCreateRequest {
  const _$InventoryCreateRequestImpl(
      {required this.name,
      required this.unit,
      this.category = 'ingredient',
      required this.minThreshold,
      required this.alertSettings});

  factory _$InventoryCreateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryCreateRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String unit;
  @override
  @JsonKey()
  final String category;
  @override
  final double minThreshold;
  @override
  final AlertSettingsModel alertSettings;

  @override
  String toString() {
    return 'InventoryCreateRequest(name: $name, unit: $unit, category: $category, minThreshold: $minThreshold, alertSettings: $alertSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryCreateRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.minThreshold, minThreshold) ||
                other.minThreshold == minThreshold) &&
            (identical(other.alertSettings, alertSettings) ||
                other.alertSettings == alertSettings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, unit, category, minThreshold, alertSettings);

  /// Create a copy of InventoryCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryCreateRequestImplCopyWith<_$InventoryCreateRequestImpl>
      get copyWith => __$$InventoryCreateRequestImplCopyWithImpl<
          _$InventoryCreateRequestImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_InventoryCreateRequest value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InventoryCreateRequest value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InventoryCreateRequest value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryCreateRequestImplToJson(
      this,
    );
  }
}

abstract class _InventoryCreateRequest implements InventoryCreateRequest {
  const factory _InventoryCreateRequest(
          {required final String name,
          required final String unit,
          final String category,
          required final double minThreshold,
          required final AlertSettingsModel alertSettings}) =
      _$InventoryCreateRequestImpl;

  factory _InventoryCreateRequest.fromJson(Map<String, dynamic> json) =
      _$InventoryCreateRequestImpl.fromJson;

  @override
  String get name;
  @override
  String get unit;
  @override
  String get category;
  @override
  double get minThreshold;
  @override
  AlertSettingsModel get alertSettings;

  /// Create a copy of InventoryCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryCreateRequestImplCopyWith<_$InventoryCreateRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

StockAddRequest _$StockAddRequestFromJson(Map<String, dynamic> json) {
  return _StockAddRequest.fromJson(json);
}

/// @nodoc
mixin _$StockAddRequest {
  double get quantity => throw _privateConstructorUsedError;
  double get unitCost => throw _privateConstructorUsedError;
  DateTime get expiryDate => throw _privateConstructorUsedError;
  String get supplier => throw _privateConstructorUsedError;
  String get batchNumber => throw _privateConstructorUsedError;
  String get qualityGrade => throw _privateConstructorUsedError;
  String get storageLocation => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StockAddRequest value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StockAddRequest value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StockAddRequest value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this StockAddRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockAddRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockAddRequestCopyWith<StockAddRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockAddRequestCopyWith<$Res> {
  factory $StockAddRequestCopyWith(
          StockAddRequest value, $Res Function(StockAddRequest) then) =
      _$StockAddRequestCopyWithImpl<$Res, StockAddRequest>;
  @useResult
  $Res call(
      {double quantity,
      double unitCost,
      DateTime expiryDate,
      String supplier,
      String batchNumber,
      String qualityGrade,
      String storageLocation});
}

/// @nodoc
class _$StockAddRequestCopyWithImpl<$Res, $Val extends StockAddRequest>
    implements $StockAddRequestCopyWith<$Res> {
  _$StockAddRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockAddRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantity = null,
    Object? unitCost = null,
    Object? expiryDate = null,
    Object? supplier = null,
    Object? batchNumber = null,
    Object? qualityGrade = null,
    Object? storageLocation = null,
  }) {
    return _then(_value.copyWith(
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unitCost: null == unitCost
          ? _value.unitCost
          : unitCost // ignore: cast_nullable_to_non_nullable
              as double,
      expiryDate: null == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      supplier: null == supplier
          ? _value.supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as String,
      batchNumber: null == batchNumber
          ? _value.batchNumber
          : batchNumber // ignore: cast_nullable_to_non_nullable
              as String,
      qualityGrade: null == qualityGrade
          ? _value.qualityGrade
          : qualityGrade // ignore: cast_nullable_to_non_nullable
              as String,
      storageLocation: null == storageLocation
          ? _value.storageLocation
          : storageLocation // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockAddRequestImplCopyWith<$Res>
    implements $StockAddRequestCopyWith<$Res> {
  factory _$$StockAddRequestImplCopyWith(_$StockAddRequestImpl value,
          $Res Function(_$StockAddRequestImpl) then) =
      __$$StockAddRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double quantity,
      double unitCost,
      DateTime expiryDate,
      String supplier,
      String batchNumber,
      String qualityGrade,
      String storageLocation});
}

/// @nodoc
class __$$StockAddRequestImplCopyWithImpl<$Res>
    extends _$StockAddRequestCopyWithImpl<$Res, _$StockAddRequestImpl>
    implements _$$StockAddRequestImplCopyWith<$Res> {
  __$$StockAddRequestImplCopyWithImpl(
      _$StockAddRequestImpl _value, $Res Function(_$StockAddRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockAddRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantity = null,
    Object? unitCost = null,
    Object? expiryDate = null,
    Object? supplier = null,
    Object? batchNumber = null,
    Object? qualityGrade = null,
    Object? storageLocation = null,
  }) {
    return _then(_$StockAddRequestImpl(
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unitCost: null == unitCost
          ? _value.unitCost
          : unitCost // ignore: cast_nullable_to_non_nullable
              as double,
      expiryDate: null == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      supplier: null == supplier
          ? _value.supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as String,
      batchNumber: null == batchNumber
          ? _value.batchNumber
          : batchNumber // ignore: cast_nullable_to_non_nullable
              as String,
      qualityGrade: null == qualityGrade
          ? _value.qualityGrade
          : qualityGrade // ignore: cast_nullable_to_non_nullable
              as String,
      storageLocation: null == storageLocation
          ? _value.storageLocation
          : storageLocation // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockAddRequestImpl implements _StockAddRequest {
  const _$StockAddRequestImpl(
      {required this.quantity,
      required this.unitCost,
      required this.expiryDate,
      this.supplier = '',
      this.batchNumber = '',
      this.qualityGrade = '',
      this.storageLocation = ''});

  factory _$StockAddRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockAddRequestImplFromJson(json);

  @override
  final double quantity;
  @override
  final double unitCost;
  @override
  final DateTime expiryDate;
  @override
  @JsonKey()
  final String supplier;
  @override
  @JsonKey()
  final String batchNumber;
  @override
  @JsonKey()
  final String qualityGrade;
  @override
  @JsonKey()
  final String storageLocation;

  @override
  String toString() {
    return 'StockAddRequest(quantity: $quantity, unitCost: $unitCost, expiryDate: $expiryDate, supplier: $supplier, batchNumber: $batchNumber, qualityGrade: $qualityGrade, storageLocation: $storageLocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockAddRequestImpl &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitCost, unitCost) ||
                other.unitCost == unitCost) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.supplier, supplier) ||
                other.supplier == supplier) &&
            (identical(other.batchNumber, batchNumber) ||
                other.batchNumber == batchNumber) &&
            (identical(other.qualityGrade, qualityGrade) ||
                other.qualityGrade == qualityGrade) &&
            (identical(other.storageLocation, storageLocation) ||
                other.storageLocation == storageLocation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, quantity, unitCost, expiryDate,
      supplier, batchNumber, qualityGrade, storageLocation);

  /// Create a copy of StockAddRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockAddRequestImplCopyWith<_$StockAddRequestImpl> get copyWith =>
      __$$StockAddRequestImplCopyWithImpl<_$StockAddRequestImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StockAddRequest value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StockAddRequest value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StockAddRequest value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StockAddRequestImplToJson(
      this,
    );
  }
}

abstract class _StockAddRequest implements StockAddRequest {
  const factory _StockAddRequest(
      {required final double quantity,
      required final double unitCost,
      required final DateTime expiryDate,
      final String supplier,
      final String batchNumber,
      final String qualityGrade,
      final String storageLocation}) = _$StockAddRequestImpl;

  factory _StockAddRequest.fromJson(Map<String, dynamic> json) =
      _$StockAddRequestImpl.fromJson;

  @override
  double get quantity;
  @override
  double get unitCost;
  @override
  DateTime get expiryDate;
  @override
  String get supplier;
  @override
  String get batchNumber;
  @override
  String get qualityGrade;
  @override
  String get storageLocation;

  /// Create a copy of StockAddRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockAddRequestImplCopyWith<_$StockAddRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockConsumeRequest _$StockConsumeRequestFromJson(Map<String, dynamic> json) {
  return _StockConsumeRequest.fromJson(json);
}

/// @nodoc
mixin _$StockConsumeRequest {
  double get quantity => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StockConsumeRequest value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StockConsumeRequest value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StockConsumeRequest value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this StockConsumeRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockConsumeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockConsumeRequestCopyWith<StockConsumeRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockConsumeRequestCopyWith<$Res> {
  factory $StockConsumeRequestCopyWith(
          StockConsumeRequest value, $Res Function(StockConsumeRequest) then) =
      _$StockConsumeRequestCopyWithImpl<$Res, StockConsumeRequest>;
  @useResult
  $Res call({double quantity, String reason});
}

/// @nodoc
class _$StockConsumeRequestCopyWithImpl<$Res, $Val extends StockConsumeRequest>
    implements $StockConsumeRequestCopyWith<$Res> {
  _$StockConsumeRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockConsumeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantity = null,
    Object? reason = null,
  }) {
    return _then(_value.copyWith(
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockConsumeRequestImplCopyWith<$Res>
    implements $StockConsumeRequestCopyWith<$Res> {
  factory _$$StockConsumeRequestImplCopyWith(_$StockConsumeRequestImpl value,
          $Res Function(_$StockConsumeRequestImpl) then) =
      __$$StockConsumeRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double quantity, String reason});
}

/// @nodoc
class __$$StockConsumeRequestImplCopyWithImpl<$Res>
    extends _$StockConsumeRequestCopyWithImpl<$Res, _$StockConsumeRequestImpl>
    implements _$$StockConsumeRequestImplCopyWith<$Res> {
  __$$StockConsumeRequestImplCopyWithImpl(_$StockConsumeRequestImpl _value,
      $Res Function(_$StockConsumeRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockConsumeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantity = null,
    Object? reason = null,
  }) {
    return _then(_$StockConsumeRequestImpl(
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockConsumeRequestImpl implements _StockConsumeRequest {
  const _$StockConsumeRequestImpl({required this.quantity, this.reason = ''});

  factory _$StockConsumeRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockConsumeRequestImplFromJson(json);

  @override
  final double quantity;
  @override
  @JsonKey()
  final String reason;

  @override
  String toString() {
    return 'StockConsumeRequest(quantity: $quantity, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockConsumeRequestImpl &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, quantity, reason);

  /// Create a copy of StockConsumeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockConsumeRequestImplCopyWith<_$StockConsumeRequestImpl> get copyWith =>
      __$$StockConsumeRequestImplCopyWithImpl<_$StockConsumeRequestImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StockConsumeRequest value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StockConsumeRequest value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StockConsumeRequest value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StockConsumeRequestImplToJson(
      this,
    );
  }
}

abstract class _StockConsumeRequest implements StockConsumeRequest {
  const factory _StockConsumeRequest(
      {required final double quantity,
      final String reason}) = _$StockConsumeRequestImpl;

  factory _StockConsumeRequest.fromJson(Map<String, dynamic> json) =
      _$StockConsumeRequestImpl.fromJson;

  @override
  double get quantity;
  @override
  String get reason;

  /// Create a copy of StockConsumeRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockConsumeRequestImplCopyWith<_$StockConsumeRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
