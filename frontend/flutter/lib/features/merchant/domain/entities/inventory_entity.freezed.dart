// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InventoryEntity _$InventoryEntityFromJson(Map<String, dynamic> json) {
  return _InventoryEntity.fromJson(json);
}

/// @nodoc
mixin _$InventoryEntity {
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
  List<StockBatch> get stockBatches => throw _privateConstructorUsedError;
  AlertSettings get alertSettings => throw _privateConstructorUsedError;
  UsageStats get usageStats => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_InventoryEntity value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InventoryEntity value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InventoryEntity value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this InventoryEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryEntityCopyWith<InventoryEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryEntityCopyWith<$Res> {
  factory $InventoryEntityCopyWith(
          InventoryEntity value, $Res Function(InventoryEntity) then) =
      _$InventoryEntityCopyWithImpl<$Res, InventoryEntity>;
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
      List<StockBatch> stockBatches,
      AlertSettings alertSettings,
      UsageStats usageStats,
      String status,
      DateTime? createdAt,
      DateTime? updatedAt});

  $AlertSettingsCopyWith<$Res> get alertSettings;
  $UsageStatsCopyWith<$Res> get usageStats;
}

/// @nodoc
class _$InventoryEntityCopyWithImpl<$Res, $Val extends InventoryEntity>
    implements $InventoryEntityCopyWith<$Res> {
  _$InventoryEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryEntity
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
              as List<StockBatch>,
      alertSettings: null == alertSettings
          ? _value.alertSettings
          : alertSettings // ignore: cast_nullable_to_non_nullable
              as AlertSettings,
      usageStats: null == usageStats
          ? _value.usageStats
          : usageStats // ignore: cast_nullable_to_non_nullable
              as UsageStats,
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

  /// Create a copy of InventoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AlertSettingsCopyWith<$Res> get alertSettings {
    return $AlertSettingsCopyWith<$Res>(_value.alertSettings, (value) {
      return _then(_value.copyWith(alertSettings: value) as $Val);
    });
  }

  /// Create a copy of InventoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsageStatsCopyWith<$Res> get usageStats {
    return $UsageStatsCopyWith<$Res>(_value.usageStats, (value) {
      return _then(_value.copyWith(usageStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InventoryEntityImplCopyWith<$Res>
    implements $InventoryEntityCopyWith<$Res> {
  factory _$$InventoryEntityImplCopyWith(_$InventoryEntityImpl value,
          $Res Function(_$InventoryEntityImpl) then) =
      __$$InventoryEntityImplCopyWithImpl<$Res>;
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
      List<StockBatch> stockBatches,
      AlertSettings alertSettings,
      UsageStats usageStats,
      String status,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $AlertSettingsCopyWith<$Res> get alertSettings;
  @override
  $UsageStatsCopyWith<$Res> get usageStats;
}

/// @nodoc
class __$$InventoryEntityImplCopyWithImpl<$Res>
    extends _$InventoryEntityCopyWithImpl<$Res, _$InventoryEntityImpl>
    implements _$$InventoryEntityImplCopyWith<$Res> {
  __$$InventoryEntityImplCopyWithImpl(
      _$InventoryEntityImpl _value, $Res Function(_$InventoryEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryEntity
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
    return _then(_$InventoryEntityImpl(
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
              as List<StockBatch>,
      alertSettings: null == alertSettings
          ? _value.alertSettings
          : alertSettings // ignore: cast_nullable_to_non_nullable
              as AlertSettings,
      usageStats: null == usageStats
          ? _value.usageStats
          : usageStats // ignore: cast_nullable_to_non_nullable
              as UsageStats,
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
class _$InventoryEntityImpl implements _InventoryEntity {
  const _$InventoryEntityImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.merchantId,
      required this.ingredientId,
      required this.ingredientName,
      required this.totalStock,
      required this.availableStock,
      required this.reservedStock,
      required this.minThreshold,
      required this.unit,
      final List<StockBatch> stockBatches = const [],
      required this.alertSettings,
      required this.usageStats,
      this.status = 'active',
      this.createdAt,
      this.updatedAt})
      : _stockBatches = stockBatches;

  factory _$InventoryEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryEntityImplFromJson(json);

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
  final List<StockBatch> _stockBatches;
  @override
  @JsonKey()
  List<StockBatch> get stockBatches {
    if (_stockBatches is EqualUnmodifiableListView) return _stockBatches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stockBatches);
  }

  @override
  final AlertSettings alertSettings;
  @override
  final UsageStats usageStats;
  @override
  @JsonKey()
  final String status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'InventoryEntity(id: $id, merchantId: $merchantId, ingredientId: $ingredientId, ingredientName: $ingredientName, totalStock: $totalStock, availableStock: $availableStock, reservedStock: $reservedStock, minThreshold: $minThreshold, unit: $unit, stockBatches: $stockBatches, alertSettings: $alertSettings, usageStats: $usageStats, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryEntityImpl &&
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

  /// Create a copy of InventoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryEntityImplCopyWith<_$InventoryEntityImpl> get copyWith =>
      __$$InventoryEntityImplCopyWithImpl<_$InventoryEntityImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_InventoryEntity value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InventoryEntity value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InventoryEntity value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryEntityImplToJson(
      this,
    );
  }
}

abstract class _InventoryEntity implements InventoryEntity {
  const factory _InventoryEntity(
      {@JsonKey(name: '_id') required final String id,
      required final String merchantId,
      required final String ingredientId,
      required final String ingredientName,
      required final double totalStock,
      required final double availableStock,
      required final double reservedStock,
      required final double minThreshold,
      required final String unit,
      final List<StockBatch> stockBatches,
      required final AlertSettings alertSettings,
      required final UsageStats usageStats,
      final String status,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$InventoryEntityImpl;

  factory _InventoryEntity.fromJson(Map<String, dynamic> json) =
      _$InventoryEntityImpl.fromJson;

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
  List<StockBatch> get stockBatches;
  @override
  AlertSettings get alertSettings;
  @override
  UsageStats get usageStats;
  @override
  String get status;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of InventoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryEntityImplCopyWith<_$InventoryEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockBatch _$StockBatchFromJson(Map<String, dynamic> json) {
  return _StockBatch.fromJson(json);
}

/// @nodoc
mixin _$StockBatch {
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
    TResult Function(_StockBatch value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StockBatch value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StockBatch value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this StockBatch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockBatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockBatchCopyWith<StockBatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockBatchCopyWith<$Res> {
  factory $StockBatchCopyWith(
          StockBatch value, $Res Function(StockBatch) then) =
      _$StockBatchCopyWithImpl<$Res, StockBatch>;
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
class _$StockBatchCopyWithImpl<$Res, $Val extends StockBatch>
    implements $StockBatchCopyWith<$Res> {
  _$StockBatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockBatch
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
abstract class _$$StockBatchImplCopyWith<$Res>
    implements $StockBatchCopyWith<$Res> {
  factory _$$StockBatchImplCopyWith(
          _$StockBatchImpl value, $Res Function(_$StockBatchImpl) then) =
      __$$StockBatchImplCopyWithImpl<$Res>;
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
class __$$StockBatchImplCopyWithImpl<$Res>
    extends _$StockBatchCopyWithImpl<$Res, _$StockBatchImpl>
    implements _$$StockBatchImplCopyWith<$Res> {
  __$$StockBatchImplCopyWithImpl(
      _$StockBatchImpl _value, $Res Function(_$StockBatchImpl) _then)
      : super(_value, _then);

  /// Create a copy of StockBatch
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
    return _then(_$StockBatchImpl(
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
class _$StockBatchImpl implements _StockBatch {
  const _$StockBatchImpl(
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

  factory _$StockBatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockBatchImplFromJson(json);

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
    return 'StockBatch(batchId: $batchId, quantity: $quantity, originalQuantity: $originalQuantity, receivedDate: $receivedDate, expiryDate: $expiryDate, unitCost: $unitCost, supplier: $supplier, qualityGrade: $qualityGrade, storageLocation: $storageLocation, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockBatchImpl &&
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

  /// Create a copy of StockBatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockBatchImplCopyWith<_$StockBatchImpl> get copyWith =>
      __$$StockBatchImplCopyWithImpl<_$StockBatchImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StockBatch value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StockBatch value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StockBatch value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StockBatchImplToJson(
      this,
    );
  }
}

abstract class _StockBatch implements StockBatch {
  const factory _StockBatch(
      {required final String batchId,
      required final double quantity,
      required final double originalQuantity,
      required final DateTime receivedDate,
      required final DateTime expiryDate,
      required final double unitCost,
      final String supplier,
      final String qualityGrade,
      final String storageLocation,
      final String status}) = _$StockBatchImpl;

  factory _StockBatch.fromJson(Map<String, dynamic> json) =
      _$StockBatchImpl.fromJson;

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

  /// Create a copy of StockBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockBatchImplCopyWith<_$StockBatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AlertSettings _$AlertSettingsFromJson(Map<String, dynamic> json) {
  return _AlertSettings.fromJson(json);
}

/// @nodoc
mixin _$AlertSettings {
  bool get lowStockAlert => throw _privateConstructorUsedError;
  bool get expiryAlert => throw _privateConstructorUsedError;
  bool get qualityAlert => throw _privateConstructorUsedError;
  int get expiryWarningDays => throw _privateConstructorUsedError;
  double get lowStockRatio => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AlertSettings value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AlertSettings value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AlertSettings value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this AlertSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertSettingsCopyWith<AlertSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertSettingsCopyWith<$Res> {
  factory $AlertSettingsCopyWith(
          AlertSettings value, $Res Function(AlertSettings) then) =
      _$AlertSettingsCopyWithImpl<$Res, AlertSettings>;
  @useResult
  $Res call(
      {bool lowStockAlert,
      bool expiryAlert,
      bool qualityAlert,
      int expiryWarningDays,
      double lowStockRatio});
}

/// @nodoc
class _$AlertSettingsCopyWithImpl<$Res, $Val extends AlertSettings>
    implements $AlertSettingsCopyWith<$Res> {
  _$AlertSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertSettings
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
abstract class _$$AlertSettingsImplCopyWith<$Res>
    implements $AlertSettingsCopyWith<$Res> {
  factory _$$AlertSettingsImplCopyWith(
          _$AlertSettingsImpl value, $Res Function(_$AlertSettingsImpl) then) =
      __$$AlertSettingsImplCopyWithImpl<$Res>;
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
class __$$AlertSettingsImplCopyWithImpl<$Res>
    extends _$AlertSettingsCopyWithImpl<$Res, _$AlertSettingsImpl>
    implements _$$AlertSettingsImplCopyWith<$Res> {
  __$$AlertSettingsImplCopyWithImpl(
      _$AlertSettingsImpl _value, $Res Function(_$AlertSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlertSettings
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
    return _then(_$AlertSettingsImpl(
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
class _$AlertSettingsImpl implements _AlertSettings {
  const _$AlertSettingsImpl(
      {this.lowStockAlert = true,
      this.expiryAlert = true,
      this.qualityAlert = true,
      this.expiryWarningDays = 3,
      this.lowStockRatio = 0.2});

  factory _$AlertSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertSettingsImplFromJson(json);

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
    return 'AlertSettings(lowStockAlert: $lowStockAlert, expiryAlert: $expiryAlert, qualityAlert: $qualityAlert, expiryWarningDays: $expiryWarningDays, lowStockRatio: $lowStockRatio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertSettingsImpl &&
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

  /// Create a copy of AlertSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertSettingsImplCopyWith<_$AlertSettingsImpl> get copyWith =>
      __$$AlertSettingsImplCopyWithImpl<_$AlertSettingsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AlertSettings value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AlertSettings value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AlertSettings value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertSettingsImplToJson(
      this,
    );
  }
}

abstract class _AlertSettings implements AlertSettings {
  const factory _AlertSettings(
      {final bool lowStockAlert,
      final bool expiryAlert,
      final bool qualityAlert,
      final int expiryWarningDays,
      final double lowStockRatio}) = _$AlertSettingsImpl;

  factory _AlertSettings.fromJson(Map<String, dynamic> json) =
      _$AlertSettingsImpl.fromJson;

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

  /// Create a copy of AlertSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertSettingsImplCopyWith<_$AlertSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UsageStats _$UsageStatsFromJson(Map<String, dynamic> json) {
  return _UsageStats.fromJson(json);
}

/// @nodoc
mixin _$UsageStats {
  double get averageDailyUsage => throw _privateConstructorUsedError;
  double get totalUsedThisMonth => throw _privateConstructorUsedError;
  double get totalWasteThisMonth => throw _privateConstructorUsedError;
  DateTime? get lastUsed => throw _privateConstructorUsedError;
  DateTime? get lastRestocked => throw _privateConstructorUsedError;
  int get restockCount => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UsageStats value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UsageStats value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UsageStats value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this UsageStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UsageStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsageStatsCopyWith<UsageStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsageStatsCopyWith<$Res> {
  factory $UsageStatsCopyWith(
          UsageStats value, $Res Function(UsageStats) then) =
      _$UsageStatsCopyWithImpl<$Res, UsageStats>;
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
class _$UsageStatsCopyWithImpl<$Res, $Val extends UsageStats>
    implements $UsageStatsCopyWith<$Res> {
  _$UsageStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsageStats
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
abstract class _$$UsageStatsImplCopyWith<$Res>
    implements $UsageStatsCopyWith<$Res> {
  factory _$$UsageStatsImplCopyWith(
          _$UsageStatsImpl value, $Res Function(_$UsageStatsImpl) then) =
      __$$UsageStatsImplCopyWithImpl<$Res>;
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
class __$$UsageStatsImplCopyWithImpl<$Res>
    extends _$UsageStatsCopyWithImpl<$Res, _$UsageStatsImpl>
    implements _$$UsageStatsImplCopyWith<$Res> {
  __$$UsageStatsImplCopyWithImpl(
      _$UsageStatsImpl _value, $Res Function(_$UsageStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UsageStats
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
    return _then(_$UsageStatsImpl(
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
class _$UsageStatsImpl implements _UsageStats {
  const _$UsageStatsImpl(
      {this.averageDailyUsage = 0.0,
      this.totalUsedThisMonth = 0.0,
      this.totalWasteThisMonth = 0.0,
      this.lastUsed,
      this.lastRestocked,
      this.restockCount = 0});

  factory _$UsageStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsageStatsImplFromJson(json);

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
    return 'UsageStats(averageDailyUsage: $averageDailyUsage, totalUsedThisMonth: $totalUsedThisMonth, totalWasteThisMonth: $totalWasteThisMonth, lastUsed: $lastUsed, lastRestocked: $lastRestocked, restockCount: $restockCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsageStatsImpl &&
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

  /// Create a copy of UsageStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsageStatsImplCopyWith<_$UsageStatsImpl> get copyWith =>
      __$$UsageStatsImplCopyWithImpl<_$UsageStatsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UsageStats value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UsageStats value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UsageStats value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UsageStatsImplToJson(
      this,
    );
  }
}

abstract class _UsageStats implements UsageStats {
  const factory _UsageStats(
      {final double averageDailyUsage,
      final double totalUsedThisMonth,
      final double totalWasteThisMonth,
      final DateTime? lastUsed,
      final DateTime? lastRestocked,
      final int restockCount}) = _$UsageStatsImpl;

  factory _UsageStats.fromJson(Map<String, dynamic> json) =
      _$UsageStatsImpl.fromJson;

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

  /// Create a copy of UsageStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsageStatsImplCopyWith<_$UsageStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryAlert _$InventoryAlertFromJson(Map<String, dynamic> json) {
  return _InventoryAlert.fromJson(json);
}

/// @nodoc
mixin _$InventoryAlert {
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
    TResult Function(_InventoryAlert value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InventoryAlert value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InventoryAlert value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this InventoryAlert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryAlertCopyWith<InventoryAlert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryAlertCopyWith<$Res> {
  factory $InventoryAlertCopyWith(
          InventoryAlert value, $Res Function(InventoryAlert) then) =
      _$InventoryAlertCopyWithImpl<$Res, InventoryAlert>;
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
class _$InventoryAlertCopyWithImpl<$Res, $Val extends InventoryAlert>
    implements $InventoryAlertCopyWith<$Res> {
  _$InventoryAlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryAlert
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
abstract class _$$InventoryAlertImplCopyWith<$Res>
    implements $InventoryAlertCopyWith<$Res> {
  factory _$$InventoryAlertImplCopyWith(_$InventoryAlertImpl value,
          $Res Function(_$InventoryAlertImpl) then) =
      __$$InventoryAlertImplCopyWithImpl<$Res>;
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
class __$$InventoryAlertImplCopyWithImpl<$Res>
    extends _$InventoryAlertCopyWithImpl<$Res, _$InventoryAlertImpl>
    implements _$$InventoryAlertImplCopyWith<$Res> {
  __$$InventoryAlertImplCopyWithImpl(
      _$InventoryAlertImpl _value, $Res Function(_$InventoryAlertImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryAlert
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
    return _then(_$InventoryAlertImpl(
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
class _$InventoryAlertImpl implements _InventoryAlert {
  const _$InventoryAlertImpl(
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

  factory _$InventoryAlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryAlertImplFromJson(json);

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
    return 'InventoryAlert(id: $id, inventoryId: $inventoryId, merchantId: $merchantId, type: $type, severity: $severity, message: $message, details: $details, isRead: $isRead, isResolved: $isResolved, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryAlertImpl &&
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

  /// Create a copy of InventoryAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryAlertImplCopyWith<_$InventoryAlertImpl> get copyWith =>
      __$$InventoryAlertImplCopyWithImpl<_$InventoryAlertImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_InventoryAlert value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InventoryAlert value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InventoryAlert value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryAlertImplToJson(
      this,
    );
  }
}

abstract class _InventoryAlert implements InventoryAlert {
  const factory _InventoryAlert(
      {@JsonKey(name: '_id') required final String id,
      required final String inventoryId,
      required final String merchantId,
      required final InventoryAlertType type,
      required final InventoryAlertSeverity severity,
      required final String message,
      required final Map<String, dynamic> details,
      final bool isRead,
      final bool isResolved,
      final DateTime? createdAt}) = _$InventoryAlertImpl;

  factory _InventoryAlert.fromJson(Map<String, dynamic> json) =
      _$InventoryAlertImpl.fromJson;

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

  /// Create a copy of InventoryAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryAlertImplCopyWith<_$InventoryAlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
