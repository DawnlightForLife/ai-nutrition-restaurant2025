// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dish_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DishModel _$DishModelFromJson(Map<String, dynamic> json) {
  return _DishModel.fromJson(json);
}

/// @nodoc
mixin _$DishModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get merchantId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<String> get allergens => throw _privateConstructorUsedError;
  List<String> get dietaryRestrictions => throw _privateConstructorUsedError;
  SpicyLevel get spicyLevel => throw _privateConstructorUsedError;
  int get estimatedPrepTime => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;
  Map<String, dynamic> get nutritionFacts => throw _privateConstructorUsedError;
  List<IngredientUsage> get ingredients => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DishModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DishModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DishModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this DishModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DishModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DishModelCopyWith<DishModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DishModelCopyWith<$Res> {
  factory $DishModelCopyWith(DishModel value, $Res Function(DishModel) then) =
      _$DishModelCopyWithImpl<$Res, DishModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String merchantId,
      String name,
      String description,
      double price,
      String category,
      List<String> tags,
      List<String> allergens,
      List<String> dietaryRestrictions,
      SpicyLevel spicyLevel,
      int estimatedPrepTime,
      bool isAvailable,
      List<String> imageUrls,
      Map<String, dynamic> nutritionFacts,
      List<IngredientUsage> ingredients,
      bool isFeatured,
      int sortOrder,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$DishModelCopyWithImpl<$Res, $Val extends DishModel>
    implements $DishModelCopyWith<$Res> {
  _$DishModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DishModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? merchantId = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? category = null,
    Object? tags = null,
    Object? allergens = null,
    Object? dietaryRestrictions = null,
    Object? spicyLevel = null,
    Object? estimatedPrepTime = null,
    Object? isAvailable = null,
    Object? imageUrls = null,
    Object? nutritionFacts = null,
    Object? ingredients = null,
    Object? isFeatured = null,
    Object? sortOrder = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergens: null == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dietaryRestrictions: null == dietaryRestrictions
          ? _value.dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      spicyLevel: null == spicyLevel
          ? _value.spicyLevel
          : spicyLevel // ignore: cast_nullable_to_non_nullable
              as SpicyLevel,
      estimatedPrepTime: null == estimatedPrepTime
          ? _value.estimatedPrepTime
          : estimatedPrepTime // ignore: cast_nullable_to_non_nullable
              as int,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionFacts: null == nutritionFacts
          ? _value.nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<IngredientUsage>,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
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
}

/// @nodoc
abstract class _$$DishModelImplCopyWith<$Res>
    implements $DishModelCopyWith<$Res> {
  factory _$$DishModelImplCopyWith(
          _$DishModelImpl value, $Res Function(_$DishModelImpl) then) =
      __$$DishModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String merchantId,
      String name,
      String description,
      double price,
      String category,
      List<String> tags,
      List<String> allergens,
      List<String> dietaryRestrictions,
      SpicyLevel spicyLevel,
      int estimatedPrepTime,
      bool isAvailable,
      List<String> imageUrls,
      Map<String, dynamic> nutritionFacts,
      List<IngredientUsage> ingredients,
      bool isFeatured,
      int sortOrder,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$DishModelImplCopyWithImpl<$Res>
    extends _$DishModelCopyWithImpl<$Res, _$DishModelImpl>
    implements _$$DishModelImplCopyWith<$Res> {
  __$$DishModelImplCopyWithImpl(
      _$DishModelImpl _value, $Res Function(_$DishModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DishModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? merchantId = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? category = null,
    Object? tags = null,
    Object? allergens = null,
    Object? dietaryRestrictions = null,
    Object? spicyLevel = null,
    Object? estimatedPrepTime = null,
    Object? isAvailable = null,
    Object? imageUrls = null,
    Object? nutritionFacts = null,
    Object? ingredients = null,
    Object? isFeatured = null,
    Object? sortOrder = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$DishModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergens: null == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dietaryRestrictions: null == dietaryRestrictions
          ? _value._dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      spicyLevel: null == spicyLevel
          ? _value.spicyLevel
          : spicyLevel // ignore: cast_nullable_to_non_nullable
              as SpicyLevel,
      estimatedPrepTime: null == estimatedPrepTime
          ? _value.estimatedPrepTime
          : estimatedPrepTime // ignore: cast_nullable_to_non_nullable
              as int,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionFacts: null == nutritionFacts
          ? _value._nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<IngredientUsage>,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$DishModelImpl implements _DishModel {
  const _$DishModelImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.merchantId,
      required this.name,
      required this.description,
      required this.price,
      this.category = '',
      final List<String> tags = const [],
      final List<String> allergens = const [],
      final List<String> dietaryRestrictions = const [],
      this.spicyLevel = SpicyLevel.none,
      this.estimatedPrepTime = 0,
      this.isAvailable = true,
      final List<String> imageUrls = const [],
      final Map<String, dynamic> nutritionFacts = const {},
      final List<IngredientUsage> ingredients = const [],
      this.isFeatured = false,
      this.sortOrder = 0,
      this.createdAt,
      this.updatedAt})
      : _tags = tags,
        _allergens = allergens,
        _dietaryRestrictions = dietaryRestrictions,
        _imageUrls = imageUrls,
        _nutritionFacts = nutritionFacts,
        _ingredients = ingredients;

  factory _$DishModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DishModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String merchantId;
  @override
  final String name;
  @override
  final String description;
  @override
  final double price;
  @override
  @JsonKey()
  final String category;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<String> _allergens;
  @override
  @JsonKey()
  List<String> get allergens {
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergens);
  }

  final List<String> _dietaryRestrictions;
  @override
  @JsonKey()
  List<String> get dietaryRestrictions {
    if (_dietaryRestrictions is EqualUnmodifiableListView)
      return _dietaryRestrictions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dietaryRestrictions);
  }

  @override
  @JsonKey()
  final SpicyLevel spicyLevel;
  @override
  @JsonKey()
  final int estimatedPrepTime;
  @override
  @JsonKey()
  final bool isAvailable;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  final Map<String, dynamic> _nutritionFacts;
  @override
  @JsonKey()
  Map<String, dynamic> get nutritionFacts {
    if (_nutritionFacts is EqualUnmodifiableMapView) return _nutritionFacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionFacts);
  }

  final List<IngredientUsage> _ingredients;
  @override
  @JsonKey()
  List<IngredientUsage> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  @override
  @JsonKey()
  final bool isFeatured;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'DishModel(id: $id, merchantId: $merchantId, name: $name, description: $description, price: $price, category: $category, tags: $tags, allergens: $allergens, dietaryRestrictions: $dietaryRestrictions, spicyLevel: $spicyLevel, estimatedPrepTime: $estimatedPrepTime, isAvailable: $isAvailable, imageUrls: $imageUrls, nutritionFacts: $nutritionFacts, ingredients: $ingredients, isFeatured: $isFeatured, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DishModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens) &&
            const DeepCollectionEquality()
                .equals(other._dietaryRestrictions, _dietaryRestrictions) &&
            (identical(other.spicyLevel, spicyLevel) ||
                other.spicyLevel == spicyLevel) &&
            (identical(other.estimatedPrepTime, estimatedPrepTime) ||
                other.estimatedPrepTime == estimatedPrepTime) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            const DeepCollectionEquality()
                .equals(other._nutritionFacts, _nutritionFacts) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        merchantId,
        name,
        description,
        price,
        category,
        const DeepCollectionEquality().hash(_tags),
        const DeepCollectionEquality().hash(_allergens),
        const DeepCollectionEquality().hash(_dietaryRestrictions),
        spicyLevel,
        estimatedPrepTime,
        isAvailable,
        const DeepCollectionEquality().hash(_imageUrls),
        const DeepCollectionEquality().hash(_nutritionFacts),
        const DeepCollectionEquality().hash(_ingredients),
        isFeatured,
        sortOrder,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of DishModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DishModelImplCopyWith<_$DishModelImpl> get copyWith =>
      __$$DishModelImplCopyWithImpl<_$DishModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DishModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DishModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DishModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DishModelImplToJson(
      this,
    );
  }
}

abstract class _DishModel implements DishModel {
  const factory _DishModel(
      {@JsonKey(name: '_id') required final String id,
      required final String merchantId,
      required final String name,
      required final String description,
      required final double price,
      final String category,
      final List<String> tags,
      final List<String> allergens,
      final List<String> dietaryRestrictions,
      final SpicyLevel spicyLevel,
      final int estimatedPrepTime,
      final bool isAvailable,
      final List<String> imageUrls,
      final Map<String, dynamic> nutritionFacts,
      final List<IngredientUsage> ingredients,
      final bool isFeatured,
      final int sortOrder,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$DishModelImpl;

  factory _DishModel.fromJson(Map<String, dynamic> json) =
      _$DishModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get merchantId;
  @override
  String get name;
  @override
  String get description;
  @override
  double get price;
  @override
  String get category;
  @override
  List<String> get tags;
  @override
  List<String> get allergens;
  @override
  List<String> get dietaryRestrictions;
  @override
  SpicyLevel get spicyLevel;
  @override
  int get estimatedPrepTime;
  @override
  bool get isAvailable;
  @override
  List<String> get imageUrls;
  @override
  Map<String, dynamic> get nutritionFacts;
  @override
  List<IngredientUsage> get ingredients;
  @override
  bool get isFeatured;
  @override
  int get sortOrder;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of DishModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DishModelImplCopyWith<_$DishModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoreDishModel _$StoreDishModelFromJson(Map<String, dynamic> json) {
  return _StoreDishModel.fromJson(json);
}

/// @nodoc
mixin _$StoreDishModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;
  String get dishId => throw _privateConstructorUsedError;
  String get merchantId => throw _privateConstructorUsedError;
  double get localPrice => throw _privateConstructorUsedError;
  bool get isAvailableInStore => throw _privateConstructorUsedError;
  int get dailyLimit => throw _privateConstructorUsedError;
  int get currentSold => throw _privateConstructorUsedError;
  Map<String, dynamic> get storeSpecificInfo =>
      throw _privateConstructorUsedError;
  List<String> get localTags => throw _privateConstructorUsedError;
  DishModel get dish => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StoreDishModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StoreDishModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StoreDishModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this StoreDishModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreDishModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreDishModelCopyWith<StoreDishModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreDishModelCopyWith<$Res> {
  factory $StoreDishModelCopyWith(
          StoreDishModel value, $Res Function(StoreDishModel) then) =
      _$StoreDishModelCopyWithImpl<$Res, StoreDishModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String storeId,
      String dishId,
      String merchantId,
      double localPrice,
      bool isAvailableInStore,
      int dailyLimit,
      int currentSold,
      Map<String, dynamic> storeSpecificInfo,
      List<String> localTags,
      DishModel dish,
      DateTime? createdAt,
      DateTime? updatedAt});

  $DishModelCopyWith<$Res> get dish;
}

/// @nodoc
class _$StoreDishModelCopyWithImpl<$Res, $Val extends StoreDishModel>
    implements $StoreDishModelCopyWith<$Res> {
  _$StoreDishModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreDishModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? dishId = null,
    Object? merchantId = null,
    Object? localPrice = null,
    Object? isAvailableInStore = null,
    Object? dailyLimit = null,
    Object? currentSold = null,
    Object? storeSpecificInfo = null,
    Object? localTags = null,
    Object? dish = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      dishId: null == dishId
          ? _value.dishId
          : dishId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      localPrice: null == localPrice
          ? _value.localPrice
          : localPrice // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailableInStore: null == isAvailableInStore
          ? _value.isAvailableInStore
          : isAvailableInStore // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyLimit: null == dailyLimit
          ? _value.dailyLimit
          : dailyLimit // ignore: cast_nullable_to_non_nullable
              as int,
      currentSold: null == currentSold
          ? _value.currentSold
          : currentSold // ignore: cast_nullable_to_non_nullable
              as int,
      storeSpecificInfo: null == storeSpecificInfo
          ? _value.storeSpecificInfo
          : storeSpecificInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      localTags: null == localTags
          ? _value.localTags
          : localTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dish: null == dish
          ? _value.dish
          : dish // ignore: cast_nullable_to_non_nullable
              as DishModel,
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

  /// Create a copy of StoreDishModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DishModelCopyWith<$Res> get dish {
    return $DishModelCopyWith<$Res>(_value.dish, (value) {
      return _then(_value.copyWith(dish: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StoreDishModelImplCopyWith<$Res>
    implements $StoreDishModelCopyWith<$Res> {
  factory _$$StoreDishModelImplCopyWith(_$StoreDishModelImpl value,
          $Res Function(_$StoreDishModelImpl) then) =
      __$$StoreDishModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String storeId,
      String dishId,
      String merchantId,
      double localPrice,
      bool isAvailableInStore,
      int dailyLimit,
      int currentSold,
      Map<String, dynamic> storeSpecificInfo,
      List<String> localTags,
      DishModel dish,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $DishModelCopyWith<$Res> get dish;
}

/// @nodoc
class __$$StoreDishModelImplCopyWithImpl<$Res>
    extends _$StoreDishModelCopyWithImpl<$Res, _$StoreDishModelImpl>
    implements _$$StoreDishModelImplCopyWith<$Res> {
  __$$StoreDishModelImplCopyWithImpl(
      _$StoreDishModelImpl _value, $Res Function(_$StoreDishModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreDishModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? dishId = null,
    Object? merchantId = null,
    Object? localPrice = null,
    Object? isAvailableInStore = null,
    Object? dailyLimit = null,
    Object? currentSold = null,
    Object? storeSpecificInfo = null,
    Object? localTags = null,
    Object? dish = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$StoreDishModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      dishId: null == dishId
          ? _value.dishId
          : dishId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      localPrice: null == localPrice
          ? _value.localPrice
          : localPrice // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailableInStore: null == isAvailableInStore
          ? _value.isAvailableInStore
          : isAvailableInStore // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyLimit: null == dailyLimit
          ? _value.dailyLimit
          : dailyLimit // ignore: cast_nullable_to_non_nullable
              as int,
      currentSold: null == currentSold
          ? _value.currentSold
          : currentSold // ignore: cast_nullable_to_non_nullable
              as int,
      storeSpecificInfo: null == storeSpecificInfo
          ? _value._storeSpecificInfo
          : storeSpecificInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      localTags: null == localTags
          ? _value._localTags
          : localTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dish: null == dish
          ? _value.dish
          : dish // ignore: cast_nullable_to_non_nullable
              as DishModel,
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
class _$StoreDishModelImpl implements _StoreDishModel {
  const _$StoreDishModelImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.storeId,
      required this.dishId,
      required this.merchantId,
      required this.localPrice,
      this.isAvailableInStore = true,
      this.dailyLimit = 0,
      this.currentSold = 0,
      final Map<String, dynamic> storeSpecificInfo = const {},
      final List<String> localTags = const [],
      required this.dish,
      this.createdAt,
      this.updatedAt})
      : _storeSpecificInfo = storeSpecificInfo,
        _localTags = localTags;

  factory _$StoreDishModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreDishModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String storeId;
  @override
  final String dishId;
  @override
  final String merchantId;
  @override
  final double localPrice;
  @override
  @JsonKey()
  final bool isAvailableInStore;
  @override
  @JsonKey()
  final int dailyLimit;
  @override
  @JsonKey()
  final int currentSold;
  final Map<String, dynamic> _storeSpecificInfo;
  @override
  @JsonKey()
  Map<String, dynamic> get storeSpecificInfo {
    if (_storeSpecificInfo is EqualUnmodifiableMapView)
      return _storeSpecificInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_storeSpecificInfo);
  }

  final List<String> _localTags;
  @override
  @JsonKey()
  List<String> get localTags {
    if (_localTags is EqualUnmodifiableListView) return _localTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_localTags);
  }

  @override
  final DishModel dish;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'StoreDishModel(id: $id, storeId: $storeId, dishId: $dishId, merchantId: $merchantId, localPrice: $localPrice, isAvailableInStore: $isAvailableInStore, dailyLimit: $dailyLimit, currentSold: $currentSold, storeSpecificInfo: $storeSpecificInfo, localTags: $localTags, dish: $dish, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreDishModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.dishId, dishId) || other.dishId == dishId) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.localPrice, localPrice) ||
                other.localPrice == localPrice) &&
            (identical(other.isAvailableInStore, isAvailableInStore) ||
                other.isAvailableInStore == isAvailableInStore) &&
            (identical(other.dailyLimit, dailyLimit) ||
                other.dailyLimit == dailyLimit) &&
            (identical(other.currentSold, currentSold) ||
                other.currentSold == currentSold) &&
            const DeepCollectionEquality()
                .equals(other._storeSpecificInfo, _storeSpecificInfo) &&
            const DeepCollectionEquality()
                .equals(other._localTags, _localTags) &&
            (identical(other.dish, dish) || other.dish == dish) &&
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
      storeId,
      dishId,
      merchantId,
      localPrice,
      isAvailableInStore,
      dailyLimit,
      currentSold,
      const DeepCollectionEquality().hash(_storeSpecificInfo),
      const DeepCollectionEquality().hash(_localTags),
      dish,
      createdAt,
      updatedAt);

  /// Create a copy of StoreDishModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreDishModelImplCopyWith<_$StoreDishModelImpl> get copyWith =>
      __$$StoreDishModelImplCopyWithImpl<_$StoreDishModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StoreDishModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StoreDishModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StoreDishModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreDishModelImplToJson(
      this,
    );
  }
}

abstract class _StoreDishModel implements StoreDishModel {
  const factory _StoreDishModel(
      {@JsonKey(name: '_id') required final String id,
      required final String storeId,
      required final String dishId,
      required final String merchantId,
      required final double localPrice,
      final bool isAvailableInStore,
      final int dailyLimit,
      final int currentSold,
      final Map<String, dynamic> storeSpecificInfo,
      final List<String> localTags,
      required final DishModel dish,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$StoreDishModelImpl;

  factory _StoreDishModel.fromJson(Map<String, dynamic> json) =
      _$StoreDishModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get storeId;
  @override
  String get dishId;
  @override
  String get merchantId;
  @override
  double get localPrice;
  @override
  bool get isAvailableInStore;
  @override
  int get dailyLimit;
  @override
  int get currentSold;
  @override
  Map<String, dynamic> get storeSpecificInfo;
  @override
  List<String> get localTags;
  @override
  DishModel get dish;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of StoreDishModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreDishModelImplCopyWith<_$StoreDishModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IngredientUsage _$IngredientUsageFromJson(Map<String, dynamic> json) {
  return _IngredientUsage.fromJson(json);
}

/// @nodoc
mixin _$IngredientUsage {
  String get ingredientId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  bool get isOptional => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_IngredientUsage value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_IngredientUsage value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_IngredientUsage value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this IngredientUsage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IngredientUsage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IngredientUsageCopyWith<IngredientUsage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IngredientUsageCopyWith<$Res> {
  factory $IngredientUsageCopyWith(
          IngredientUsage value, $Res Function(IngredientUsage) then) =
      _$IngredientUsageCopyWithImpl<$Res, IngredientUsage>;
  @useResult
  $Res call(
      {String ingredientId,
      String name,
      double quantity,
      String unit,
      bool isOptional,
      String notes});
}

/// @nodoc
class _$IngredientUsageCopyWithImpl<$Res, $Val extends IngredientUsage>
    implements $IngredientUsageCopyWith<$Res> {
  _$IngredientUsageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IngredientUsage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ingredientId = null,
    Object? name = null,
    Object? quantity = null,
    Object? unit = null,
    Object? isOptional = null,
    Object? notes = null,
  }) {
    return _then(_value.copyWith(
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      isOptional: null == isOptional
          ? _value.isOptional
          : isOptional // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IngredientUsageImplCopyWith<$Res>
    implements $IngredientUsageCopyWith<$Res> {
  factory _$$IngredientUsageImplCopyWith(_$IngredientUsageImpl value,
          $Res Function(_$IngredientUsageImpl) then) =
      __$$IngredientUsageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String ingredientId,
      String name,
      double quantity,
      String unit,
      bool isOptional,
      String notes});
}

/// @nodoc
class __$$IngredientUsageImplCopyWithImpl<$Res>
    extends _$IngredientUsageCopyWithImpl<$Res, _$IngredientUsageImpl>
    implements _$$IngredientUsageImplCopyWith<$Res> {
  __$$IngredientUsageImplCopyWithImpl(
      _$IngredientUsageImpl _value, $Res Function(_$IngredientUsageImpl) _then)
      : super(_value, _then);

  /// Create a copy of IngredientUsage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ingredientId = null,
    Object? name = null,
    Object? quantity = null,
    Object? unit = null,
    Object? isOptional = null,
    Object? notes = null,
  }) {
    return _then(_$IngredientUsageImpl(
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      isOptional: null == isOptional
          ? _value.isOptional
          : isOptional // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IngredientUsageImpl implements _IngredientUsage {
  const _$IngredientUsageImpl(
      {required this.ingredientId,
      required this.name,
      required this.quantity,
      required this.unit,
      this.isOptional = false,
      this.notes = ''});

  factory _$IngredientUsageImpl.fromJson(Map<String, dynamic> json) =>
      _$$IngredientUsageImplFromJson(json);

  @override
  final String ingredientId;
  @override
  final String name;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  @JsonKey()
  final bool isOptional;
  @override
  @JsonKey()
  final String notes;

  @override
  String toString() {
    return 'IngredientUsage(ingredientId: $ingredientId, name: $name, quantity: $quantity, unit: $unit, isOptional: $isOptional, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IngredientUsageImpl &&
            (identical(other.ingredientId, ingredientId) ||
                other.ingredientId == ingredientId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.isOptional, isOptional) ||
                other.isOptional == isOptional) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, ingredientId, name, quantity, unit, isOptional, notes);

  /// Create a copy of IngredientUsage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IngredientUsageImplCopyWith<_$IngredientUsageImpl> get copyWith =>
      __$$IngredientUsageImplCopyWithImpl<_$IngredientUsageImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_IngredientUsage value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_IngredientUsage value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_IngredientUsage value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IngredientUsageImplToJson(
      this,
    );
  }
}

abstract class _IngredientUsage implements IngredientUsage {
  const factory _IngredientUsage(
      {required final String ingredientId,
      required final String name,
      required final double quantity,
      required final String unit,
      final bool isOptional,
      final String notes}) = _$IngredientUsageImpl;

  factory _IngredientUsage.fromJson(Map<String, dynamic> json) =
      _$IngredientUsageImpl.fromJson;

  @override
  String get ingredientId;
  @override
  String get name;
  @override
  double get quantity;
  @override
  String get unit;
  @override
  bool get isOptional;
  @override
  String get notes;

  /// Create a copy of IngredientUsage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IngredientUsageImplCopyWith<_$IngredientUsageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DishCreateRequest _$DishCreateRequestFromJson(Map<String, dynamic> json) {
  return _DishCreateRequest.fromJson(json);
}

/// @nodoc
mixin _$DishCreateRequest {
  String get merchantId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<String> get allergens => throw _privateConstructorUsedError;
  List<String> get dietaryRestrictions => throw _privateConstructorUsedError;
  SpicyLevel get spicyLevel => throw _privateConstructorUsedError;
  int get estimatedPrepTime => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  Map<String, dynamic> get nutritionFacts => throw _privateConstructorUsedError;
  List<IngredientUsage> get ingredients => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DishCreateRequest value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DishCreateRequest value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DishCreateRequest value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this DishCreateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DishCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DishCreateRequestCopyWith<DishCreateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DishCreateRequestCopyWith<$Res> {
  factory $DishCreateRequestCopyWith(
          DishCreateRequest value, $Res Function(DishCreateRequest) then) =
      _$DishCreateRequestCopyWithImpl<$Res, DishCreateRequest>;
  @useResult
  $Res call(
      {String merchantId,
      String name,
      String description,
      double price,
      String category,
      List<String> tags,
      List<String> allergens,
      List<String> dietaryRestrictions,
      SpicyLevel spicyLevel,
      int estimatedPrepTime,
      bool isAvailable,
      Map<String, dynamic> nutritionFacts,
      List<IngredientUsage> ingredients,
      bool isFeatured});
}

/// @nodoc
class _$DishCreateRequestCopyWithImpl<$Res, $Val extends DishCreateRequest>
    implements $DishCreateRequestCopyWith<$Res> {
  _$DishCreateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DishCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchantId = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? category = null,
    Object? tags = null,
    Object? allergens = null,
    Object? dietaryRestrictions = null,
    Object? spicyLevel = null,
    Object? estimatedPrepTime = null,
    Object? isAvailable = null,
    Object? nutritionFacts = null,
    Object? ingredients = null,
    Object? isFeatured = null,
  }) {
    return _then(_value.copyWith(
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergens: null == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dietaryRestrictions: null == dietaryRestrictions
          ? _value.dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      spicyLevel: null == spicyLevel
          ? _value.spicyLevel
          : spicyLevel // ignore: cast_nullable_to_non_nullable
              as SpicyLevel,
      estimatedPrepTime: null == estimatedPrepTime
          ? _value.estimatedPrepTime
          : estimatedPrepTime // ignore: cast_nullable_to_non_nullable
              as int,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      nutritionFacts: null == nutritionFacts
          ? _value.nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<IngredientUsage>,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DishCreateRequestImplCopyWith<$Res>
    implements $DishCreateRequestCopyWith<$Res> {
  factory _$$DishCreateRequestImplCopyWith(_$DishCreateRequestImpl value,
          $Res Function(_$DishCreateRequestImpl) then) =
      __$$DishCreateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String merchantId,
      String name,
      String description,
      double price,
      String category,
      List<String> tags,
      List<String> allergens,
      List<String> dietaryRestrictions,
      SpicyLevel spicyLevel,
      int estimatedPrepTime,
      bool isAvailable,
      Map<String, dynamic> nutritionFacts,
      List<IngredientUsage> ingredients,
      bool isFeatured});
}

/// @nodoc
class __$$DishCreateRequestImplCopyWithImpl<$Res>
    extends _$DishCreateRequestCopyWithImpl<$Res, _$DishCreateRequestImpl>
    implements _$$DishCreateRequestImplCopyWith<$Res> {
  __$$DishCreateRequestImplCopyWithImpl(_$DishCreateRequestImpl _value,
      $Res Function(_$DishCreateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of DishCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchantId = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? category = null,
    Object? tags = null,
    Object? allergens = null,
    Object? dietaryRestrictions = null,
    Object? spicyLevel = null,
    Object? estimatedPrepTime = null,
    Object? isAvailable = null,
    Object? nutritionFacts = null,
    Object? ingredients = null,
    Object? isFeatured = null,
  }) {
    return _then(_$DishCreateRequestImpl(
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergens: null == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dietaryRestrictions: null == dietaryRestrictions
          ? _value._dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      spicyLevel: null == spicyLevel
          ? _value.spicyLevel
          : spicyLevel // ignore: cast_nullable_to_non_nullable
              as SpicyLevel,
      estimatedPrepTime: null == estimatedPrepTime
          ? _value.estimatedPrepTime
          : estimatedPrepTime // ignore: cast_nullable_to_non_nullable
              as int,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      nutritionFacts: null == nutritionFacts
          ? _value._nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<IngredientUsage>,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DishCreateRequestImpl implements _DishCreateRequest {
  const _$DishCreateRequestImpl(
      {required this.merchantId,
      required this.name,
      required this.description,
      required this.price,
      this.category = '',
      final List<String> tags = const [],
      final List<String> allergens = const [],
      final List<String> dietaryRestrictions = const [],
      this.spicyLevel = SpicyLevel.none,
      this.estimatedPrepTime = 0,
      this.isAvailable = true,
      final Map<String, dynamic> nutritionFacts = const {},
      final List<IngredientUsage> ingredients = const [],
      this.isFeatured = false})
      : _tags = tags,
        _allergens = allergens,
        _dietaryRestrictions = dietaryRestrictions,
        _nutritionFacts = nutritionFacts,
        _ingredients = ingredients;

  factory _$DishCreateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$DishCreateRequestImplFromJson(json);

  @override
  final String merchantId;
  @override
  final String name;
  @override
  final String description;
  @override
  final double price;
  @override
  @JsonKey()
  final String category;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<String> _allergens;
  @override
  @JsonKey()
  List<String> get allergens {
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergens);
  }

  final List<String> _dietaryRestrictions;
  @override
  @JsonKey()
  List<String> get dietaryRestrictions {
    if (_dietaryRestrictions is EqualUnmodifiableListView)
      return _dietaryRestrictions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dietaryRestrictions);
  }

  @override
  @JsonKey()
  final SpicyLevel spicyLevel;
  @override
  @JsonKey()
  final int estimatedPrepTime;
  @override
  @JsonKey()
  final bool isAvailable;
  final Map<String, dynamic> _nutritionFacts;
  @override
  @JsonKey()
  Map<String, dynamic> get nutritionFacts {
    if (_nutritionFacts is EqualUnmodifiableMapView) return _nutritionFacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionFacts);
  }

  final List<IngredientUsage> _ingredients;
  @override
  @JsonKey()
  List<IngredientUsage> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  @override
  @JsonKey()
  final bool isFeatured;

  @override
  String toString() {
    return 'DishCreateRequest(merchantId: $merchantId, name: $name, description: $description, price: $price, category: $category, tags: $tags, allergens: $allergens, dietaryRestrictions: $dietaryRestrictions, spicyLevel: $spicyLevel, estimatedPrepTime: $estimatedPrepTime, isAvailable: $isAvailable, nutritionFacts: $nutritionFacts, ingredients: $ingredients, isFeatured: $isFeatured)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DishCreateRequestImpl &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens) &&
            const DeepCollectionEquality()
                .equals(other._dietaryRestrictions, _dietaryRestrictions) &&
            (identical(other.spicyLevel, spicyLevel) ||
                other.spicyLevel == spicyLevel) &&
            (identical(other.estimatedPrepTime, estimatedPrepTime) ||
                other.estimatedPrepTime == estimatedPrepTime) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            const DeepCollectionEquality()
                .equals(other._nutritionFacts, _nutritionFacts) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      merchantId,
      name,
      description,
      price,
      category,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_allergens),
      const DeepCollectionEquality().hash(_dietaryRestrictions),
      spicyLevel,
      estimatedPrepTime,
      isAvailable,
      const DeepCollectionEquality().hash(_nutritionFacts),
      const DeepCollectionEquality().hash(_ingredients),
      isFeatured);

  /// Create a copy of DishCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DishCreateRequestImplCopyWith<_$DishCreateRequestImpl> get copyWith =>
      __$$DishCreateRequestImplCopyWithImpl<_$DishCreateRequestImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DishCreateRequest value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DishCreateRequest value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DishCreateRequest value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DishCreateRequestImplToJson(
      this,
    );
  }
}

abstract class _DishCreateRequest implements DishCreateRequest {
  const factory _DishCreateRequest(
      {required final String merchantId,
      required final String name,
      required final String description,
      required final double price,
      final String category,
      final List<String> tags,
      final List<String> allergens,
      final List<String> dietaryRestrictions,
      final SpicyLevel spicyLevel,
      final int estimatedPrepTime,
      final bool isAvailable,
      final Map<String, dynamic> nutritionFacts,
      final List<IngredientUsage> ingredients,
      final bool isFeatured}) = _$DishCreateRequestImpl;

  factory _DishCreateRequest.fromJson(Map<String, dynamic> json) =
      _$DishCreateRequestImpl.fromJson;

  @override
  String get merchantId;
  @override
  String get name;
  @override
  String get description;
  @override
  double get price;
  @override
  String get category;
  @override
  List<String> get tags;
  @override
  List<String> get allergens;
  @override
  List<String> get dietaryRestrictions;
  @override
  SpicyLevel get spicyLevel;
  @override
  int get estimatedPrepTime;
  @override
  bool get isAvailable;
  @override
  Map<String, dynamic> get nutritionFacts;
  @override
  List<IngredientUsage> get ingredients;
  @override
  bool get isFeatured;

  /// Create a copy of DishCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DishCreateRequestImplCopyWith<_$DishCreateRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DishUpdateRequest _$DishUpdateRequestFromJson(Map<String, dynamic> json) {
  return _DishUpdateRequest.fromJson(json);
}

/// @nodoc
mixin _$DishUpdateRequest {
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  List<String>? get allergens => throw _privateConstructorUsedError;
  List<String>? get dietaryRestrictions => throw _privateConstructorUsedError;
  SpicyLevel? get spicyLevel => throw _privateConstructorUsedError;
  int? get estimatedPrepTime => throw _privateConstructorUsedError;
  bool? get isAvailable => throw _privateConstructorUsedError;
  Map<String, dynamic>? get nutritionFacts =>
      throw _privateConstructorUsedError;
  List<IngredientUsage>? get ingredients => throw _privateConstructorUsedError;
  bool? get isFeatured => throw _privateConstructorUsedError;
  int? get sortOrder => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DishUpdateRequest value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DishUpdateRequest value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DishUpdateRequest value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this DishUpdateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DishUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DishUpdateRequestCopyWith<DishUpdateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DishUpdateRequestCopyWith<$Res> {
  factory $DishUpdateRequestCopyWith(
          DishUpdateRequest value, $Res Function(DishUpdateRequest) then) =
      _$DishUpdateRequestCopyWithImpl<$Res, DishUpdateRequest>;
  @useResult
  $Res call(
      {String? name,
      String? description,
      double? price,
      String? category,
      List<String>? tags,
      List<String>? allergens,
      List<String>? dietaryRestrictions,
      SpicyLevel? spicyLevel,
      int? estimatedPrepTime,
      bool? isAvailable,
      Map<String, dynamic>? nutritionFacts,
      List<IngredientUsage>? ingredients,
      bool? isFeatured,
      int? sortOrder});
}

/// @nodoc
class _$DishUpdateRequestCopyWithImpl<$Res, $Val extends DishUpdateRequest>
    implements $DishUpdateRequestCopyWith<$Res> {
  _$DishUpdateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DishUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? category = freezed,
    Object? tags = freezed,
    Object? allergens = freezed,
    Object? dietaryRestrictions = freezed,
    Object? spicyLevel = freezed,
    Object? estimatedPrepTime = freezed,
    Object? isAvailable = freezed,
    Object? nutritionFacts = freezed,
    Object? ingredients = freezed,
    Object? isFeatured = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      allergens: freezed == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dietaryRestrictions: freezed == dietaryRestrictions
          ? _value.dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      spicyLevel: freezed == spicyLevel
          ? _value.spicyLevel
          : spicyLevel // ignore: cast_nullable_to_non_nullable
              as SpicyLevel?,
      estimatedPrepTime: freezed == estimatedPrepTime
          ? _value.estimatedPrepTime
          : estimatedPrepTime // ignore: cast_nullable_to_non_nullable
              as int?,
      isAvailable: freezed == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      nutritionFacts: freezed == nutritionFacts
          ? _value.nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      ingredients: freezed == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<IngredientUsage>?,
      isFeatured: freezed == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DishUpdateRequestImplCopyWith<$Res>
    implements $DishUpdateRequestCopyWith<$Res> {
  factory _$$DishUpdateRequestImplCopyWith(_$DishUpdateRequestImpl value,
          $Res Function(_$DishUpdateRequestImpl) then) =
      __$$DishUpdateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name,
      String? description,
      double? price,
      String? category,
      List<String>? tags,
      List<String>? allergens,
      List<String>? dietaryRestrictions,
      SpicyLevel? spicyLevel,
      int? estimatedPrepTime,
      bool? isAvailable,
      Map<String, dynamic>? nutritionFacts,
      List<IngredientUsage>? ingredients,
      bool? isFeatured,
      int? sortOrder});
}

/// @nodoc
class __$$DishUpdateRequestImplCopyWithImpl<$Res>
    extends _$DishUpdateRequestCopyWithImpl<$Res, _$DishUpdateRequestImpl>
    implements _$$DishUpdateRequestImplCopyWith<$Res> {
  __$$DishUpdateRequestImplCopyWithImpl(_$DishUpdateRequestImpl _value,
      $Res Function(_$DishUpdateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of DishUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? category = freezed,
    Object? tags = freezed,
    Object? allergens = freezed,
    Object? dietaryRestrictions = freezed,
    Object? spicyLevel = freezed,
    Object? estimatedPrepTime = freezed,
    Object? isAvailable = freezed,
    Object? nutritionFacts = freezed,
    Object? ingredients = freezed,
    Object? isFeatured = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_$DishUpdateRequestImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      allergens: freezed == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dietaryRestrictions: freezed == dietaryRestrictions
          ? _value._dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      spicyLevel: freezed == spicyLevel
          ? _value.spicyLevel
          : spicyLevel // ignore: cast_nullable_to_non_nullable
              as SpicyLevel?,
      estimatedPrepTime: freezed == estimatedPrepTime
          ? _value.estimatedPrepTime
          : estimatedPrepTime // ignore: cast_nullable_to_non_nullable
              as int?,
      isAvailable: freezed == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      nutritionFacts: freezed == nutritionFacts
          ? _value._nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      ingredients: freezed == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<IngredientUsage>?,
      isFeatured: freezed == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DishUpdateRequestImpl implements _DishUpdateRequest {
  const _$DishUpdateRequestImpl(
      {this.name,
      this.description,
      this.price,
      this.category,
      final List<String>? tags,
      final List<String>? allergens,
      final List<String>? dietaryRestrictions,
      this.spicyLevel,
      this.estimatedPrepTime,
      this.isAvailable,
      final Map<String, dynamic>? nutritionFacts,
      final List<IngredientUsage>? ingredients,
      this.isFeatured,
      this.sortOrder})
      : _tags = tags,
        _allergens = allergens,
        _dietaryRestrictions = dietaryRestrictions,
        _nutritionFacts = nutritionFacts,
        _ingredients = ingredients;

  factory _$DishUpdateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$DishUpdateRequestImplFromJson(json);

  @override
  final String? name;
  @override
  final String? description;
  @override
  final double? price;
  @override
  final String? category;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _allergens;
  @override
  List<String>? get allergens {
    final value = _allergens;
    if (value == null) return null;
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _dietaryRestrictions;
  @override
  List<String>? get dietaryRestrictions {
    final value = _dietaryRestrictions;
    if (value == null) return null;
    if (_dietaryRestrictions is EqualUnmodifiableListView)
      return _dietaryRestrictions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final SpicyLevel? spicyLevel;
  @override
  final int? estimatedPrepTime;
  @override
  final bool? isAvailable;
  final Map<String, dynamic>? _nutritionFacts;
  @override
  Map<String, dynamic>? get nutritionFacts {
    final value = _nutritionFacts;
    if (value == null) return null;
    if (_nutritionFacts is EqualUnmodifiableMapView) return _nutritionFacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<IngredientUsage>? _ingredients;
  @override
  List<IngredientUsage>? get ingredients {
    final value = _ingredients;
    if (value == null) return null;
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? isFeatured;
  @override
  final int? sortOrder;

  @override
  String toString() {
    return 'DishUpdateRequest(name: $name, description: $description, price: $price, category: $category, tags: $tags, allergens: $allergens, dietaryRestrictions: $dietaryRestrictions, spicyLevel: $spicyLevel, estimatedPrepTime: $estimatedPrepTime, isAvailable: $isAvailable, nutritionFacts: $nutritionFacts, ingredients: $ingredients, isFeatured: $isFeatured, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DishUpdateRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens) &&
            const DeepCollectionEquality()
                .equals(other._dietaryRestrictions, _dietaryRestrictions) &&
            (identical(other.spicyLevel, spicyLevel) ||
                other.spicyLevel == spicyLevel) &&
            (identical(other.estimatedPrepTime, estimatedPrepTime) ||
                other.estimatedPrepTime == estimatedPrepTime) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            const DeepCollectionEquality()
                .equals(other._nutritionFacts, _nutritionFacts) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      description,
      price,
      category,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_allergens),
      const DeepCollectionEquality().hash(_dietaryRestrictions),
      spicyLevel,
      estimatedPrepTime,
      isAvailable,
      const DeepCollectionEquality().hash(_nutritionFacts),
      const DeepCollectionEquality().hash(_ingredients),
      isFeatured,
      sortOrder);

  /// Create a copy of DishUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DishUpdateRequestImplCopyWith<_$DishUpdateRequestImpl> get copyWith =>
      __$$DishUpdateRequestImplCopyWithImpl<_$DishUpdateRequestImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DishUpdateRequest value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DishUpdateRequest value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DishUpdateRequest value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DishUpdateRequestImplToJson(
      this,
    );
  }
}

abstract class _DishUpdateRequest implements DishUpdateRequest {
  const factory _DishUpdateRequest(
      {final String? name,
      final String? description,
      final double? price,
      final String? category,
      final List<String>? tags,
      final List<String>? allergens,
      final List<String>? dietaryRestrictions,
      final SpicyLevel? spicyLevel,
      final int? estimatedPrepTime,
      final bool? isAvailable,
      final Map<String, dynamic>? nutritionFacts,
      final List<IngredientUsage>? ingredients,
      final bool? isFeatured,
      final int? sortOrder}) = _$DishUpdateRequestImpl;

  factory _DishUpdateRequest.fromJson(Map<String, dynamic> json) =
      _$DishUpdateRequestImpl.fromJson;

  @override
  String? get name;
  @override
  String? get description;
  @override
  double? get price;
  @override
  String? get category;
  @override
  List<String>? get tags;
  @override
  List<String>? get allergens;
  @override
  List<String>? get dietaryRestrictions;
  @override
  SpicyLevel? get spicyLevel;
  @override
  int? get estimatedPrepTime;
  @override
  bool? get isAvailable;
  @override
  Map<String, dynamic>? get nutritionFacts;
  @override
  List<IngredientUsage>? get ingredients;
  @override
  bool? get isFeatured;
  @override
  int? get sortOrder;

  /// Create a copy of DishUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DishUpdateRequestImplCopyWith<_$DishUpdateRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoreDishUpdateRequest _$StoreDishUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return _StoreDishUpdateRequest.fromJson(json);
}

/// @nodoc
mixin _$StoreDishUpdateRequest {
  double? get localPrice => throw _privateConstructorUsedError;
  bool? get isAvailableInStore => throw _privateConstructorUsedError;
  int? get dailyLimit => throw _privateConstructorUsedError;
  Map<String, dynamic>? get storeSpecificInfo =>
      throw _privateConstructorUsedError;
  List<String>? get localTags => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StoreDishUpdateRequest value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StoreDishUpdateRequest value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StoreDishUpdateRequest value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this StoreDishUpdateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreDishUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreDishUpdateRequestCopyWith<StoreDishUpdateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreDishUpdateRequestCopyWith<$Res> {
  factory $StoreDishUpdateRequestCopyWith(StoreDishUpdateRequest value,
          $Res Function(StoreDishUpdateRequest) then) =
      _$StoreDishUpdateRequestCopyWithImpl<$Res, StoreDishUpdateRequest>;
  @useResult
  $Res call(
      {double? localPrice,
      bool? isAvailableInStore,
      int? dailyLimit,
      Map<String, dynamic>? storeSpecificInfo,
      List<String>? localTags});
}

/// @nodoc
class _$StoreDishUpdateRequestCopyWithImpl<$Res,
        $Val extends StoreDishUpdateRequest>
    implements $StoreDishUpdateRequestCopyWith<$Res> {
  _$StoreDishUpdateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreDishUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localPrice = freezed,
    Object? isAvailableInStore = freezed,
    Object? dailyLimit = freezed,
    Object? storeSpecificInfo = freezed,
    Object? localTags = freezed,
  }) {
    return _then(_value.copyWith(
      localPrice: freezed == localPrice
          ? _value.localPrice
          : localPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      isAvailableInStore: freezed == isAvailableInStore
          ? _value.isAvailableInStore
          : isAvailableInStore // ignore: cast_nullable_to_non_nullable
              as bool?,
      dailyLimit: freezed == dailyLimit
          ? _value.dailyLimit
          : dailyLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      storeSpecificInfo: freezed == storeSpecificInfo
          ? _value.storeSpecificInfo
          : storeSpecificInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      localTags: freezed == localTags
          ? _value.localTags
          : localTags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreDishUpdateRequestImplCopyWith<$Res>
    implements $StoreDishUpdateRequestCopyWith<$Res> {
  factory _$$StoreDishUpdateRequestImplCopyWith(
          _$StoreDishUpdateRequestImpl value,
          $Res Function(_$StoreDishUpdateRequestImpl) then) =
      __$$StoreDishUpdateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? localPrice,
      bool? isAvailableInStore,
      int? dailyLimit,
      Map<String, dynamic>? storeSpecificInfo,
      List<String>? localTags});
}

/// @nodoc
class __$$StoreDishUpdateRequestImplCopyWithImpl<$Res>
    extends _$StoreDishUpdateRequestCopyWithImpl<$Res,
        _$StoreDishUpdateRequestImpl>
    implements _$$StoreDishUpdateRequestImplCopyWith<$Res> {
  __$$StoreDishUpdateRequestImplCopyWithImpl(
      _$StoreDishUpdateRequestImpl _value,
      $Res Function(_$StoreDishUpdateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreDishUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localPrice = freezed,
    Object? isAvailableInStore = freezed,
    Object? dailyLimit = freezed,
    Object? storeSpecificInfo = freezed,
    Object? localTags = freezed,
  }) {
    return _then(_$StoreDishUpdateRequestImpl(
      localPrice: freezed == localPrice
          ? _value.localPrice
          : localPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      isAvailableInStore: freezed == isAvailableInStore
          ? _value.isAvailableInStore
          : isAvailableInStore // ignore: cast_nullable_to_non_nullable
              as bool?,
      dailyLimit: freezed == dailyLimit
          ? _value.dailyLimit
          : dailyLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      storeSpecificInfo: freezed == storeSpecificInfo
          ? _value._storeSpecificInfo
          : storeSpecificInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      localTags: freezed == localTags
          ? _value._localTags
          : localTags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreDishUpdateRequestImpl implements _StoreDishUpdateRequest {
  const _$StoreDishUpdateRequestImpl(
      {this.localPrice,
      this.isAvailableInStore,
      this.dailyLimit,
      final Map<String, dynamic>? storeSpecificInfo,
      final List<String>? localTags})
      : _storeSpecificInfo = storeSpecificInfo,
        _localTags = localTags;

  factory _$StoreDishUpdateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreDishUpdateRequestImplFromJson(json);

  @override
  final double? localPrice;
  @override
  final bool? isAvailableInStore;
  @override
  final int? dailyLimit;
  final Map<String, dynamic>? _storeSpecificInfo;
  @override
  Map<String, dynamic>? get storeSpecificInfo {
    final value = _storeSpecificInfo;
    if (value == null) return null;
    if (_storeSpecificInfo is EqualUnmodifiableMapView)
      return _storeSpecificInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _localTags;
  @override
  List<String>? get localTags {
    final value = _localTags;
    if (value == null) return null;
    if (_localTags is EqualUnmodifiableListView) return _localTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'StoreDishUpdateRequest(localPrice: $localPrice, isAvailableInStore: $isAvailableInStore, dailyLimit: $dailyLimit, storeSpecificInfo: $storeSpecificInfo, localTags: $localTags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreDishUpdateRequestImpl &&
            (identical(other.localPrice, localPrice) ||
                other.localPrice == localPrice) &&
            (identical(other.isAvailableInStore, isAvailableInStore) ||
                other.isAvailableInStore == isAvailableInStore) &&
            (identical(other.dailyLimit, dailyLimit) ||
                other.dailyLimit == dailyLimit) &&
            const DeepCollectionEquality()
                .equals(other._storeSpecificInfo, _storeSpecificInfo) &&
            const DeepCollectionEquality()
                .equals(other._localTags, _localTags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      localPrice,
      isAvailableInStore,
      dailyLimit,
      const DeepCollectionEquality().hash(_storeSpecificInfo),
      const DeepCollectionEquality().hash(_localTags));

  /// Create a copy of StoreDishUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreDishUpdateRequestImplCopyWith<_$StoreDishUpdateRequestImpl>
      get copyWith => __$$StoreDishUpdateRequestImplCopyWithImpl<
          _$StoreDishUpdateRequestImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StoreDishUpdateRequest value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StoreDishUpdateRequest value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StoreDishUpdateRequest value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreDishUpdateRequestImplToJson(
      this,
    );
  }
}

abstract class _StoreDishUpdateRequest implements StoreDishUpdateRequest {
  const factory _StoreDishUpdateRequest(
      {final double? localPrice,
      final bool? isAvailableInStore,
      final int? dailyLimit,
      final Map<String, dynamic>? storeSpecificInfo,
      final List<String>? localTags}) = _$StoreDishUpdateRequestImpl;

  factory _StoreDishUpdateRequest.fromJson(Map<String, dynamic> json) =
      _$StoreDishUpdateRequestImpl.fromJson;

  @override
  double? get localPrice;
  @override
  bool? get isAvailableInStore;
  @override
  int? get dailyLimit;
  @override
  Map<String, dynamic>? get storeSpecificInfo;
  @override
  List<String>? get localTags;

  /// Create a copy of StoreDishUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreDishUpdateRequestImplCopyWith<_$StoreDishUpdateRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
