// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecommendationItem _$RecommendationItemFromJson(Map<String, dynamic> json) {
  return _RecommendationItem.fromJson(json);
}

/// @nodoc
mixin _$RecommendationItem {
  /// 推荐项目ID
  String get id => throw _privateConstructorUsedError;

  /// 推荐类型（dish/meal/plan等）
  String get type => throw _privateConstructorUsedError;

  /// 推荐项目标题
  String get title => throw _privateConstructorUsedError;

  /// 推荐项目描述
  String get description => throw _privateConstructorUsedError;

  /// 推荐项目图片URL
  String? get imageUrl => throw _privateConstructorUsedError;

  /// 推荐评分（1-5分）
  double get score => throw _privateConstructorUsedError;

  /// 推荐置信度（0-1）
  double get confidence => throw _privateConstructorUsedError;

  /// 营养信息
  NutritionInfo? get nutritionInfo => throw _privateConstructorUsedError;

  /// 价格信息
  PriceInfo? get priceInfo => throw _privateConstructorUsedError;

  /// 推荐原因
  List<String> get reasons => throw _privateConstructorUsedError;

  /// 标签
  List<String> get tags => throw _privateConstructorUsedError;

  /// 是否可用
  bool get isAvailable => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// 扩展数据
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RecommendationItem value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RecommendationItem value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RecommendationItem value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this RecommendationItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationItemCopyWith<RecommendationItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationItemCopyWith<$Res> {
  factory $RecommendationItemCopyWith(
          RecommendationItem value, $Res Function(RecommendationItem) then) =
      _$RecommendationItemCopyWithImpl<$Res, RecommendationItem>;
  @useResult
  $Res call(
      {String id,
      String type,
      String title,
      String description,
      String? imageUrl,
      double score,
      double confidence,
      NutritionInfo? nutritionInfo,
      PriceInfo? priceInfo,
      List<String> reasons,
      List<String> tags,
      bool isAvailable,
      DateTime? createdAt,
      DateTime? updatedAt,
      Map<String, dynamic> metadata});

  $NutritionInfoCopyWith<$Res>? get nutritionInfo;
  $PriceInfoCopyWith<$Res>? get priceInfo;
}

/// @nodoc
class _$RecommendationItemCopyWithImpl<$Res, $Val extends RecommendationItem>
    implements $RecommendationItemCopyWith<$Res> {
  _$RecommendationItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? score = null,
    Object? confidence = null,
    Object? nutritionInfo = freezed,
    Object? priceInfo = freezed,
    Object? reasons = null,
    Object? tags = null,
    Object? isAvailable = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionInfo: freezed == nutritionInfo
          ? _value.nutritionInfo
          : nutritionInfo // ignore: cast_nullable_to_non_nullable
              as NutritionInfo?,
      priceInfo: freezed == priceInfo
          ? _value.priceInfo
          : priceInfo // ignore: cast_nullable_to_non_nullable
              as PriceInfo?,
      reasons: null == reasons
          ? _value.reasons
          : reasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }

  /// Create a copy of RecommendationItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionInfoCopyWith<$Res>? get nutritionInfo {
    if (_value.nutritionInfo == null) {
      return null;
    }

    return $NutritionInfoCopyWith<$Res>(_value.nutritionInfo!, (value) {
      return _then(_value.copyWith(nutritionInfo: value) as $Val);
    });
  }

  /// Create a copy of RecommendationItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PriceInfoCopyWith<$Res>? get priceInfo {
    if (_value.priceInfo == null) {
      return null;
    }

    return $PriceInfoCopyWith<$Res>(_value.priceInfo!, (value) {
      return _then(_value.copyWith(priceInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecommendationItemImplCopyWith<$Res>
    implements $RecommendationItemCopyWith<$Res> {
  factory _$$RecommendationItemImplCopyWith(_$RecommendationItemImpl value,
          $Res Function(_$RecommendationItemImpl) then) =
      __$$RecommendationItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String title,
      String description,
      String? imageUrl,
      double score,
      double confidence,
      NutritionInfo? nutritionInfo,
      PriceInfo? priceInfo,
      List<String> reasons,
      List<String> tags,
      bool isAvailable,
      DateTime? createdAt,
      DateTime? updatedAt,
      Map<String, dynamic> metadata});

  @override
  $NutritionInfoCopyWith<$Res>? get nutritionInfo;
  @override
  $PriceInfoCopyWith<$Res>? get priceInfo;
}

/// @nodoc
class __$$RecommendationItemImplCopyWithImpl<$Res>
    extends _$RecommendationItemCopyWithImpl<$Res, _$RecommendationItemImpl>
    implements _$$RecommendationItemImplCopyWith<$Res> {
  __$$RecommendationItemImplCopyWithImpl(_$RecommendationItemImpl _value,
      $Res Function(_$RecommendationItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? score = null,
    Object? confidence = null,
    Object? nutritionInfo = freezed,
    Object? priceInfo = freezed,
    Object? reasons = null,
    Object? tags = null,
    Object? isAvailable = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? metadata = null,
  }) {
    return _then(_$RecommendationItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      nutritionInfo: freezed == nutritionInfo
          ? _value.nutritionInfo
          : nutritionInfo // ignore: cast_nullable_to_non_nullable
              as NutritionInfo?,
      priceInfo: freezed == priceInfo
          ? _value.priceInfo
          : priceInfo // ignore: cast_nullable_to_non_nullable
              as PriceInfo?,
      reasons: null == reasons
          ? _value._reasons
          : reasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationItemImpl implements _RecommendationItem {
  const _$RecommendationItemImpl(
      {required this.id,
      required this.type,
      required this.title,
      required this.description,
      this.imageUrl,
      this.score = 0.0,
      this.confidence = 0.0,
      this.nutritionInfo,
      this.priceInfo,
      final List<String> reasons = const [],
      final List<String> tags = const [],
      this.isAvailable = true,
      this.createdAt,
      this.updatedAt,
      final Map<String, dynamic> metadata = const {}})
      : _reasons = reasons,
        _tags = tags,
        _metadata = metadata;

  factory _$RecommendationItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationItemImplFromJson(json);

  /// 推荐项目ID
  @override
  final String id;

  /// 推荐类型（dish/meal/plan等）
  @override
  final String type;

  /// 推荐项目标题
  @override
  final String title;

  /// 推荐项目描述
  @override
  final String description;

  /// 推荐项目图片URL
  @override
  final String? imageUrl;

  /// 推荐评分（1-5分）
  @override
  @JsonKey()
  final double score;

  /// 推荐置信度（0-1）
  @override
  @JsonKey()
  final double confidence;

  /// 营养信息
  @override
  final NutritionInfo? nutritionInfo;

  /// 价格信息
  @override
  final PriceInfo? priceInfo;

  /// 推荐原因
  final List<String> _reasons;

  /// 推荐原因
  @override
  @JsonKey()
  List<String> get reasons {
    if (_reasons is EqualUnmodifiableListView) return _reasons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reasons);
  }

  /// 标签
  final List<String> _tags;

  /// 标签
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// 是否可用
  @override
  @JsonKey()
  final bool isAvailable;

  /// 创建时间
  @override
  final DateTime? createdAt;

  /// 更新时间
  @override
  final DateTime? updatedAt;

  /// 扩展数据
  final Map<String, dynamic> _metadata;

  /// 扩展数据
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'RecommendationItem(id: $id, type: $type, title: $title, description: $description, imageUrl: $imageUrl, score: $score, confidence: $confidence, nutritionInfo: $nutritionInfo, priceInfo: $priceInfo, reasons: $reasons, tags: $tags, isAvailable: $isAvailable, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.nutritionInfo, nutritionInfo) ||
                other.nutritionInfo == nutritionInfo) &&
            (identical(other.priceInfo, priceInfo) ||
                other.priceInfo == priceInfo) &&
            const DeepCollectionEquality().equals(other._reasons, _reasons) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      title,
      description,
      imageUrl,
      score,
      confidence,
      nutritionInfo,
      priceInfo,
      const DeepCollectionEquality().hash(_reasons),
      const DeepCollectionEquality().hash(_tags),
      isAvailable,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of RecommendationItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationItemImplCopyWith<_$RecommendationItemImpl> get copyWith =>
      __$$RecommendationItemImplCopyWithImpl<_$RecommendationItemImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RecommendationItem value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RecommendationItem value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RecommendationItem value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationItemImplToJson(
      this,
    );
  }
}

abstract class _RecommendationItem implements RecommendationItem {
  const factory _RecommendationItem(
      {required final String id,
      required final String type,
      required final String title,
      required final String description,
      final String? imageUrl,
      final double score,
      final double confidence,
      final NutritionInfo? nutritionInfo,
      final PriceInfo? priceInfo,
      final List<String> reasons,
      final List<String> tags,
      final bool isAvailable,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final Map<String, dynamic> metadata}) = _$RecommendationItemImpl;

  factory _RecommendationItem.fromJson(Map<String, dynamic> json) =
      _$RecommendationItemImpl.fromJson;

  /// 推荐项目ID
  @override
  String get id;

  /// 推荐类型（dish/meal/plan等）
  @override
  String get type;

  /// 推荐项目标题
  @override
  String get title;

  /// 推荐项目描述
  @override
  String get description;

  /// 推荐项目图片URL
  @override
  String? get imageUrl;

  /// 推荐评分（1-5分）
  @override
  double get score;

  /// 推荐置信度（0-1）
  @override
  double get confidence;

  /// 营养信息
  @override
  NutritionInfo? get nutritionInfo;

  /// 价格信息
  @override
  PriceInfo? get priceInfo;

  /// 推荐原因
  @override
  List<String> get reasons;

  /// 标签
  @override
  List<String> get tags;

  /// 是否可用
  @override
  bool get isAvailable;

  /// 创建时间
  @override
  DateTime? get createdAt;

  /// 更新时间
  @override
  DateTime? get updatedAt;

  /// 扩展数据
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of RecommendationItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationItemImplCopyWith<_$RecommendationItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionInfo _$NutritionInfoFromJson(Map<String, dynamic> json) {
  return _NutritionInfo.fromJson(json);
}

/// @nodoc
mixin _$NutritionInfo {
  /// 热量（千卡）
  double get calories => throw _privateConstructorUsedError;

  /// 蛋白质（克）
  double get protein => throw _privateConstructorUsedError;

  /// 脂肪（克）
  double get fat => throw _privateConstructorUsedError;

  /// 碳水化合物（克）
  double get carbs => throw _privateConstructorUsedError;

  /// 纤维（克）
  double get fiber => throw _privateConstructorUsedError;

  /// 糖分（克）
  double get sugar => throw _privateConstructorUsedError;

  /// 钠（毫克）
  double get sodium => throw _privateConstructorUsedError;

  /// 其他营养成分
  Map<String, double> get others => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionInfo value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionInfo value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionInfo value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NutritionInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionInfoCopyWith<NutritionInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionInfoCopyWith<$Res> {
  factory $NutritionInfoCopyWith(
          NutritionInfo value, $Res Function(NutritionInfo) then) =
      _$NutritionInfoCopyWithImpl<$Res, NutritionInfo>;
  @useResult
  $Res call(
      {double calories,
      double protein,
      double fat,
      double carbs,
      double fiber,
      double sugar,
      double sodium,
      Map<String, double> others});
}

/// @nodoc
class _$NutritionInfoCopyWithImpl<$Res, $Val extends NutritionInfo>
    implements $NutritionInfoCopyWith<$Res> {
  _$NutritionInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? calories = null,
    Object? protein = null,
    Object? fat = null,
    Object? carbs = null,
    Object? fiber = null,
    Object? sugar = null,
    Object? sodium = null,
    Object? others = null,
  }) {
    return _then(_value.copyWith(
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
      protein: null == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      fat: null == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double,
      carbs: null == carbs
          ? _value.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as double,
      fiber: null == fiber
          ? _value.fiber
          : fiber // ignore: cast_nullable_to_non_nullable
              as double,
      sugar: null == sugar
          ? _value.sugar
          : sugar // ignore: cast_nullable_to_non_nullable
              as double,
      sodium: null == sodium
          ? _value.sodium
          : sodium // ignore: cast_nullable_to_non_nullable
              as double,
      others: null == others
          ? _value.others
          : others // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionInfoImplCopyWith<$Res>
    implements $NutritionInfoCopyWith<$Res> {
  factory _$$NutritionInfoImplCopyWith(
          _$NutritionInfoImpl value, $Res Function(_$NutritionInfoImpl) then) =
      __$$NutritionInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double calories,
      double protein,
      double fat,
      double carbs,
      double fiber,
      double sugar,
      double sodium,
      Map<String, double> others});
}

/// @nodoc
class __$$NutritionInfoImplCopyWithImpl<$Res>
    extends _$NutritionInfoCopyWithImpl<$Res, _$NutritionInfoImpl>
    implements _$$NutritionInfoImplCopyWith<$Res> {
  __$$NutritionInfoImplCopyWithImpl(
      _$NutritionInfoImpl _value, $Res Function(_$NutritionInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? calories = null,
    Object? protein = null,
    Object? fat = null,
    Object? carbs = null,
    Object? fiber = null,
    Object? sugar = null,
    Object? sodium = null,
    Object? others = null,
  }) {
    return _then(_$NutritionInfoImpl(
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
      protein: null == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      fat: null == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double,
      carbs: null == carbs
          ? _value.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as double,
      fiber: null == fiber
          ? _value.fiber
          : fiber // ignore: cast_nullable_to_non_nullable
              as double,
      sugar: null == sugar
          ? _value.sugar
          : sugar // ignore: cast_nullable_to_non_nullable
              as double,
      sodium: null == sodium
          ? _value.sodium
          : sodium // ignore: cast_nullable_to_non_nullable
              as double,
      others: null == others
          ? _value._others
          : others // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionInfoImpl implements _NutritionInfo {
  const _$NutritionInfoImpl(
      {this.calories = 0.0,
      this.protein = 0.0,
      this.fat = 0.0,
      this.carbs = 0.0,
      this.fiber = 0.0,
      this.sugar = 0.0,
      this.sodium = 0.0,
      final Map<String, double> others = const {}})
      : _others = others;

  factory _$NutritionInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionInfoImplFromJson(json);

  /// 热量（千卡）
  @override
  @JsonKey()
  final double calories;

  /// 蛋白质（克）
  @override
  @JsonKey()
  final double protein;

  /// 脂肪（克）
  @override
  @JsonKey()
  final double fat;

  /// 碳水化合物（克）
  @override
  @JsonKey()
  final double carbs;

  /// 纤维（克）
  @override
  @JsonKey()
  final double fiber;

  /// 糖分（克）
  @override
  @JsonKey()
  final double sugar;

  /// 钠（毫克）
  @override
  @JsonKey()
  final double sodium;

  /// 其他营养成分
  final Map<String, double> _others;

  /// 其他营养成分
  @override
  @JsonKey()
  Map<String, double> get others {
    if (_others is EqualUnmodifiableMapView) return _others;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_others);
  }

  @override
  String toString() {
    return 'NutritionInfo(calories: $calories, protein: $protein, fat: $fat, carbs: $carbs, fiber: $fiber, sugar: $sugar, sodium: $sodium, others: $others)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionInfoImpl &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.fat, fat) || other.fat == fat) &&
            (identical(other.carbs, carbs) || other.carbs == carbs) &&
            (identical(other.fiber, fiber) || other.fiber == fiber) &&
            (identical(other.sugar, sugar) || other.sugar == sugar) &&
            (identical(other.sodium, sodium) || other.sodium == sodium) &&
            const DeepCollectionEquality().equals(other._others, _others));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, calories, protein, fat, carbs,
      fiber, sugar, sodium, const DeepCollectionEquality().hash(_others));

  /// Create a copy of NutritionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionInfoImplCopyWith<_$NutritionInfoImpl> get copyWith =>
      __$$NutritionInfoImplCopyWithImpl<_$NutritionInfoImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionInfo value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionInfo value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionInfo value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionInfoImplToJson(
      this,
    );
  }
}

abstract class _NutritionInfo implements NutritionInfo {
  const factory _NutritionInfo(
      {final double calories,
      final double protein,
      final double fat,
      final double carbs,
      final double fiber,
      final double sugar,
      final double sodium,
      final Map<String, double> others}) = _$NutritionInfoImpl;

  factory _NutritionInfo.fromJson(Map<String, dynamic> json) =
      _$NutritionInfoImpl.fromJson;

  /// 热量（千卡）
  @override
  double get calories;

  /// 蛋白质（克）
  @override
  double get protein;

  /// 脂肪（克）
  @override
  double get fat;

  /// 碳水化合物（克）
  @override
  double get carbs;

  /// 纤维（克）
  @override
  double get fiber;

  /// 糖分（克）
  @override
  double get sugar;

  /// 钠（毫克）
  @override
  double get sodium;

  /// 其他营养成分
  @override
  Map<String, double> get others;

  /// Create a copy of NutritionInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionInfoImplCopyWith<_$NutritionInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PriceInfo _$PriceInfoFromJson(Map<String, dynamic> json) {
  return _PriceInfo.fromJson(json);
}

/// @nodoc
mixin _$PriceInfo {
  /// 原价
  double get originalPrice => throw _privateConstructorUsedError;

  /// 现价
  double get currentPrice => throw _privateConstructorUsedError;

  /// 折扣（0-1）
  double get discount => throw _privateConstructorUsedError;

  /// 货币代码
  String get currency => throw _privateConstructorUsedError;

  /// 价格单位
  String get unit => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PriceInfo value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PriceInfo value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PriceInfo value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this PriceInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceInfoCopyWith<PriceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceInfoCopyWith<$Res> {
  factory $PriceInfoCopyWith(PriceInfo value, $Res Function(PriceInfo) then) =
      _$PriceInfoCopyWithImpl<$Res, PriceInfo>;
  @useResult
  $Res call(
      {double originalPrice,
      double currentPrice,
      double discount,
      String currency,
      String unit});
}

/// @nodoc
class _$PriceInfoCopyWithImpl<$Res, $Val extends PriceInfo>
    implements $PriceInfoCopyWith<$Res> {
  _$PriceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalPrice = null,
    Object? currentPrice = null,
    Object? discount = null,
    Object? currency = null,
    Object? unit = null,
  }) {
    return _then(_value.copyWith(
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currentPrice: null == currentPrice
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PriceInfoImplCopyWith<$Res>
    implements $PriceInfoCopyWith<$Res> {
  factory _$$PriceInfoImplCopyWith(
          _$PriceInfoImpl value, $Res Function(_$PriceInfoImpl) then) =
      __$$PriceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double originalPrice,
      double currentPrice,
      double discount,
      String currency,
      String unit});
}

/// @nodoc
class __$$PriceInfoImplCopyWithImpl<$Res>
    extends _$PriceInfoCopyWithImpl<$Res, _$PriceInfoImpl>
    implements _$$PriceInfoImplCopyWith<$Res> {
  __$$PriceInfoImplCopyWithImpl(
      _$PriceInfoImpl _value, $Res Function(_$PriceInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PriceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalPrice = null,
    Object? currentPrice = null,
    Object? discount = null,
    Object? currency = null,
    Object? unit = null,
  }) {
    return _then(_$PriceInfoImpl(
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currentPrice: null == currentPrice
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceInfoImpl implements _PriceInfo {
  const _$PriceInfoImpl(
      {this.originalPrice = 0.0,
      this.currentPrice = 0.0,
      this.discount = 0.0,
      this.currency = 'CNY',
      this.unit = '份'});

  factory _$PriceInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceInfoImplFromJson(json);

  /// 原价
  @override
  @JsonKey()
  final double originalPrice;

  /// 现价
  @override
  @JsonKey()
  final double currentPrice;

  /// 折扣（0-1）
  @override
  @JsonKey()
  final double discount;

  /// 货币代码
  @override
  @JsonKey()
  final String currency;

  /// 价格单位
  @override
  @JsonKey()
  final String unit;

  @override
  String toString() {
    return 'PriceInfo(originalPrice: $originalPrice, currentPrice: $currentPrice, discount: $discount, currency: $currency, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceInfoImpl &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.currentPrice, currentPrice) ||
                other.currentPrice == currentPrice) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, originalPrice, currentPrice, discount, currency, unit);

  /// Create a copy of PriceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceInfoImplCopyWith<_$PriceInfoImpl> get copyWith =>
      __$$PriceInfoImplCopyWithImpl<_$PriceInfoImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PriceInfo value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PriceInfo value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PriceInfo value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceInfoImplToJson(
      this,
    );
  }
}

abstract class _PriceInfo implements PriceInfo {
  const factory _PriceInfo(
      {final double originalPrice,
      final double currentPrice,
      final double discount,
      final String currency,
      final String unit}) = _$PriceInfoImpl;

  factory _PriceInfo.fromJson(Map<String, dynamic> json) =
      _$PriceInfoImpl.fromJson;

  /// 原价
  @override
  double get originalPrice;

  /// 现价
  @override
  double get currentPrice;

  /// 折扣（0-1）
  @override
  double get discount;

  /// 货币代码
  @override
  String get currency;

  /// 价格单位
  @override
  String get unit;

  /// Create a copy of PriceInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceInfoImplCopyWith<_$PriceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
