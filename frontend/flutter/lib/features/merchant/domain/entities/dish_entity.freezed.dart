// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dish_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DishEntity _$DishEntityFromJson(Map<String, dynamic> json) {
  return _DishEntity.fromJson(json);
}

/// @nodoc
mixin _$DishEntity {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'imageUrl')
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError; // 多图片支持
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'discountedPrice')
  double? get discountedPrice => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get subCategory => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  Map<String, dynamic> get nutritionFacts => throw _privateConstructorUsedError;
  List<String> get nutritionAttributes => throw _privateConstructorUsedError;
  List<String> get ingredients => throw _privateConstructorUsedError;
  List<String> get allergens => throw _privateConstructorUsedError;
  int get spicyLevel => throw _privateConstructorUsedError;
  int get preparationTime => throw _privateConstructorUsedError;
  int get estimatedPrepTime => throw _privateConstructorUsedError; // 预计准备时间（分钟）
  List<String> get regions => throw _privateConstructorUsedError;
  List<String> get seasons => throw _privateConstructorUsedError;
  bool get isPackage => throw _privateConstructorUsedError;
  List<PackageDishItem> get packageDishes => throw _privateConstructorUsedError;
  List<String> get suitableMerchantTypes => throw _privateConstructorUsedError;
  List<HealthBenefit> get healthBenefits => throw _privateConstructorUsedError;
  List<String> get suitableDiets => throw _privateConstructorUsedError;
  List<String> get suitableActivityLevels => throw _privateConstructorUsedError;
  List<String> get suitableAgeGroups => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdBy')
  String get createdBy => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError; // 是否可用
  bool get isFeatured => throw _privateConstructorUsedError; // 是否特色推荐
  String get visibility => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DishEntity value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DishEntity value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DishEntity value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this DishEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DishEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DishEntityCopyWith<DishEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DishEntityCopyWith<$Res> {
  factory $DishEntityCopyWith(
          DishEntity value, $Res Function(DishEntity) then) =
      _$DishEntityCopyWithImpl<$Res, DishEntity>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String name,
      String description,
      @JsonKey(name: 'imageUrl') String? imageUrl,
      List<String> imageUrls,
      double price,
      @JsonKey(name: 'discountedPrice') double? discountedPrice,
      String category,
      String? subCategory,
      List<String> tags,
      Map<String, dynamic> nutritionFacts,
      List<String> nutritionAttributes,
      List<String> ingredients,
      List<String> allergens,
      int spicyLevel,
      int preparationTime,
      int estimatedPrepTime,
      List<String> regions,
      List<String> seasons,
      bool isPackage,
      List<PackageDishItem> packageDishes,
      List<String> suitableMerchantTypes,
      List<HealthBenefit> healthBenefits,
      List<String> suitableDiets,
      List<String> suitableActivityLevels,
      List<String> suitableAgeGroups,
      @JsonKey(name: 'createdBy') String createdBy,
      bool isActive,
      bool isAvailable,
      bool isFeatured,
      String visibility,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt});
}

/// @nodoc
class _$DishEntityCopyWithImpl<$Res, $Val extends DishEntity>
    implements $DishEntityCopyWith<$Res> {
  _$DishEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DishEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? imageUrls = null,
    Object? price = null,
    Object? discountedPrice = freezed,
    Object? category = null,
    Object? subCategory = freezed,
    Object? tags = null,
    Object? nutritionFacts = null,
    Object? nutritionAttributes = null,
    Object? ingredients = null,
    Object? allergens = null,
    Object? spicyLevel = null,
    Object? preparationTime = null,
    Object? estimatedPrepTime = null,
    Object? regions = null,
    Object? seasons = null,
    Object? isPackage = null,
    Object? packageDishes = null,
    Object? suitableMerchantTypes = null,
    Object? healthBenefits = null,
    Object? suitableDiets = null,
    Object? suitableActivityLevels = null,
    Object? suitableAgeGroups = null,
    Object? createdBy = null,
    Object? isActive = null,
    Object? isAvailable = null,
    Object? isFeatured = null,
    Object? visibility = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      discountedPrice: freezed == discountedPrice
          ? _value.discountedPrice
          : discountedPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      subCategory: freezed == subCategory
          ? _value.subCategory
          : subCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionFacts: null == nutritionFacts
          ? _value.nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      nutritionAttributes: null == nutritionAttributes
          ? _value.nutritionAttributes
          : nutritionAttributes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergens: null == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      spicyLevel: null == spicyLevel
          ? _value.spicyLevel
          : spicyLevel // ignore: cast_nullable_to_non_nullable
              as int,
      preparationTime: null == preparationTime
          ? _value.preparationTime
          : preparationTime // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedPrepTime: null == estimatedPrepTime
          ? _value.estimatedPrepTime
          : estimatedPrepTime // ignore: cast_nullable_to_non_nullable
              as int,
      regions: null == regions
          ? _value.regions
          : regions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      seasons: null == seasons
          ? _value.seasons
          : seasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPackage: null == isPackage
          ? _value.isPackage
          : isPackage // ignore: cast_nullable_to_non_nullable
              as bool,
      packageDishes: null == packageDishes
          ? _value.packageDishes
          : packageDishes // ignore: cast_nullable_to_non_nullable
              as List<PackageDishItem>,
      suitableMerchantTypes: null == suitableMerchantTypes
          ? _value.suitableMerchantTypes
          : suitableMerchantTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      healthBenefits: null == healthBenefits
          ? _value.healthBenefits
          : healthBenefits // ignore: cast_nullable_to_non_nullable
              as List<HealthBenefit>,
      suitableDiets: null == suitableDiets
          ? _value.suitableDiets
          : suitableDiets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      suitableActivityLevels: null == suitableActivityLevels
          ? _value.suitableActivityLevels
          : suitableActivityLevels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      suitableAgeGroups: null == suitableAgeGroups
          ? _value.suitableAgeGroups
          : suitableAgeGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DishEntityImplCopyWith<$Res>
    implements $DishEntityCopyWith<$Res> {
  factory _$$DishEntityImplCopyWith(
          _$DishEntityImpl value, $Res Function(_$DishEntityImpl) then) =
      __$$DishEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String name,
      String description,
      @JsonKey(name: 'imageUrl') String? imageUrl,
      List<String> imageUrls,
      double price,
      @JsonKey(name: 'discountedPrice') double? discountedPrice,
      String category,
      String? subCategory,
      List<String> tags,
      Map<String, dynamic> nutritionFacts,
      List<String> nutritionAttributes,
      List<String> ingredients,
      List<String> allergens,
      int spicyLevel,
      int preparationTime,
      int estimatedPrepTime,
      List<String> regions,
      List<String> seasons,
      bool isPackage,
      List<PackageDishItem> packageDishes,
      List<String> suitableMerchantTypes,
      List<HealthBenefit> healthBenefits,
      List<String> suitableDiets,
      List<String> suitableActivityLevels,
      List<String> suitableAgeGroups,
      @JsonKey(name: 'createdBy') String createdBy,
      bool isActive,
      bool isAvailable,
      bool isFeatured,
      String visibility,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt});
}

/// @nodoc
class __$$DishEntityImplCopyWithImpl<$Res>
    extends _$DishEntityCopyWithImpl<$Res, _$DishEntityImpl>
    implements _$$DishEntityImplCopyWith<$Res> {
  __$$DishEntityImplCopyWithImpl(
      _$DishEntityImpl _value, $Res Function(_$DishEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of DishEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? imageUrls = null,
    Object? price = null,
    Object? discountedPrice = freezed,
    Object? category = null,
    Object? subCategory = freezed,
    Object? tags = null,
    Object? nutritionFacts = null,
    Object? nutritionAttributes = null,
    Object? ingredients = null,
    Object? allergens = null,
    Object? spicyLevel = null,
    Object? preparationTime = null,
    Object? estimatedPrepTime = null,
    Object? regions = null,
    Object? seasons = null,
    Object? isPackage = null,
    Object? packageDishes = null,
    Object? suitableMerchantTypes = null,
    Object? healthBenefits = null,
    Object? suitableDiets = null,
    Object? suitableActivityLevels = null,
    Object? suitableAgeGroups = null,
    Object? createdBy = null,
    Object? isActive = null,
    Object? isAvailable = null,
    Object? isFeatured = null,
    Object? visibility = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$DishEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      discountedPrice: freezed == discountedPrice
          ? _value.discountedPrice
          : discountedPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      subCategory: freezed == subCategory
          ? _value.subCategory
          : subCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionFacts: null == nutritionFacts
          ? _value._nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      nutritionAttributes: null == nutritionAttributes
          ? _value._nutritionAttributes
          : nutritionAttributes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allergens: null == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      spicyLevel: null == spicyLevel
          ? _value.spicyLevel
          : spicyLevel // ignore: cast_nullable_to_non_nullable
              as int,
      preparationTime: null == preparationTime
          ? _value.preparationTime
          : preparationTime // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedPrepTime: null == estimatedPrepTime
          ? _value.estimatedPrepTime
          : estimatedPrepTime // ignore: cast_nullable_to_non_nullable
              as int,
      regions: null == regions
          ? _value._regions
          : regions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      seasons: null == seasons
          ? _value._seasons
          : seasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPackage: null == isPackage
          ? _value.isPackage
          : isPackage // ignore: cast_nullable_to_non_nullable
              as bool,
      packageDishes: null == packageDishes
          ? _value._packageDishes
          : packageDishes // ignore: cast_nullable_to_non_nullable
              as List<PackageDishItem>,
      suitableMerchantTypes: null == suitableMerchantTypes
          ? _value._suitableMerchantTypes
          : suitableMerchantTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      healthBenefits: null == healthBenefits
          ? _value._healthBenefits
          : healthBenefits // ignore: cast_nullable_to_non_nullable
              as List<HealthBenefit>,
      suitableDiets: null == suitableDiets
          ? _value._suitableDiets
          : suitableDiets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      suitableActivityLevels: null == suitableActivityLevels
          ? _value._suitableActivityLevels
          : suitableActivityLevels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      suitableAgeGroups: null == suitableAgeGroups
          ? _value._suitableAgeGroups
          : suitableAgeGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DishEntityImpl implements _DishEntity {
  const _$DishEntityImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.name,
      required this.description,
      @JsonKey(name: 'imageUrl') this.imageUrl,
      final List<String> imageUrls = const [],
      required this.price,
      @JsonKey(name: 'discountedPrice') this.discountedPrice,
      required this.category,
      this.subCategory,
      final List<String> tags = const [],
      final Map<String, dynamic> nutritionFacts = const {},
      final List<String> nutritionAttributes = const [],
      final List<String> ingredients = const [],
      final List<String> allergens = const [],
      this.spicyLevel = 0,
      this.preparationTime = 0,
      this.estimatedPrepTime = 0,
      final List<String> regions = const [],
      final List<String> seasons = const [],
      this.isPackage = false,
      final List<PackageDishItem> packageDishes = const [],
      final List<String> suitableMerchantTypes = const ['all'],
      final List<HealthBenefit> healthBenefits = const [],
      final List<String> suitableDiets = const [],
      final List<String> suitableActivityLevels = const ['all'],
      final List<String> suitableAgeGroups = const ['all'],
      @JsonKey(name: 'createdBy') required this.createdBy,
      this.isActive = true,
      this.isAvailable = true,
      this.isFeatured = false,
      this.visibility = 'public',
      @JsonKey(name: 'createdAt') required this.createdAt,
      @JsonKey(name: 'updatedAt') required this.updatedAt})
      : _imageUrls = imageUrls,
        _tags = tags,
        _nutritionFacts = nutritionFacts,
        _nutritionAttributes = nutritionAttributes,
        _ingredients = ingredients,
        _allergens = allergens,
        _regions = regions,
        _seasons = seasons,
        _packageDishes = packageDishes,
        _suitableMerchantTypes = suitableMerchantTypes,
        _healthBenefits = healthBenefits,
        _suitableDiets = suitableDiets,
        _suitableActivityLevels = suitableActivityLevels,
        _suitableAgeGroups = suitableAgeGroups;

  factory _$DishEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$DishEntityImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

// 多图片支持
  @override
  final double price;
  @override
  @JsonKey(name: 'discountedPrice')
  final double? discountedPrice;
  @override
  final String category;
  @override
  final String? subCategory;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final Map<String, dynamic> _nutritionFacts;
  @override
  @JsonKey()
  Map<String, dynamic> get nutritionFacts {
    if (_nutritionFacts is EqualUnmodifiableMapView) return _nutritionFacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionFacts);
  }

  final List<String> _nutritionAttributes;
  @override
  @JsonKey()
  List<String> get nutritionAttributes {
    if (_nutritionAttributes is EqualUnmodifiableListView)
      return _nutritionAttributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionAttributes);
  }

  final List<String> _ingredients;
  @override
  @JsonKey()
  List<String> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  final List<String> _allergens;
  @override
  @JsonKey()
  List<String> get allergens {
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergens);
  }

  @override
  @JsonKey()
  final int spicyLevel;
  @override
  @JsonKey()
  final int preparationTime;
  @override
  @JsonKey()
  final int estimatedPrepTime;
// 预计准备时间（分钟）
  final List<String> _regions;
// 预计准备时间（分钟）
  @override
  @JsonKey()
  List<String> get regions {
    if (_regions is EqualUnmodifiableListView) return _regions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_regions);
  }

  final List<String> _seasons;
  @override
  @JsonKey()
  List<String> get seasons {
    if (_seasons is EqualUnmodifiableListView) return _seasons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_seasons);
  }

  @override
  @JsonKey()
  final bool isPackage;
  final List<PackageDishItem> _packageDishes;
  @override
  @JsonKey()
  List<PackageDishItem> get packageDishes {
    if (_packageDishes is EqualUnmodifiableListView) return _packageDishes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_packageDishes);
  }

  final List<String> _suitableMerchantTypes;
  @override
  @JsonKey()
  List<String> get suitableMerchantTypes {
    if (_suitableMerchantTypes is EqualUnmodifiableListView)
      return _suitableMerchantTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suitableMerchantTypes);
  }

  final List<HealthBenefit> _healthBenefits;
  @override
  @JsonKey()
  List<HealthBenefit> get healthBenefits {
    if (_healthBenefits is EqualUnmodifiableListView) return _healthBenefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_healthBenefits);
  }

  final List<String> _suitableDiets;
  @override
  @JsonKey()
  List<String> get suitableDiets {
    if (_suitableDiets is EqualUnmodifiableListView) return _suitableDiets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suitableDiets);
  }

  final List<String> _suitableActivityLevels;
  @override
  @JsonKey()
  List<String> get suitableActivityLevels {
    if (_suitableActivityLevels is EqualUnmodifiableListView)
      return _suitableActivityLevels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suitableActivityLevels);
  }

  final List<String> _suitableAgeGroups;
  @override
  @JsonKey()
  List<String> get suitableAgeGroups {
    if (_suitableAgeGroups is EqualUnmodifiableListView)
      return _suitableAgeGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suitableAgeGroups);
  }

  @override
  @JsonKey(name: 'createdBy')
  final String createdBy;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isAvailable;
// 是否可用
  @override
  @JsonKey()
  final bool isFeatured;
// 是否特色推荐
  @override
  @JsonKey()
  final String visibility;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'DishEntity(id: $id, name: $name, description: $description, imageUrl: $imageUrl, imageUrls: $imageUrls, price: $price, discountedPrice: $discountedPrice, category: $category, subCategory: $subCategory, tags: $tags, nutritionFacts: $nutritionFacts, nutritionAttributes: $nutritionAttributes, ingredients: $ingredients, allergens: $allergens, spicyLevel: $spicyLevel, preparationTime: $preparationTime, estimatedPrepTime: $estimatedPrepTime, regions: $regions, seasons: $seasons, isPackage: $isPackage, packageDishes: $packageDishes, suitableMerchantTypes: $suitableMerchantTypes, healthBenefits: $healthBenefits, suitableDiets: $suitableDiets, suitableActivityLevels: $suitableActivityLevels, suitableAgeGroups: $suitableAgeGroups, createdBy: $createdBy, isActive: $isActive, isAvailable: $isAvailable, isFeatured: $isFeatured, visibility: $visibility, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DishEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.discountedPrice, discountedPrice) ||
                other.discountedPrice == discountedPrice) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subCategory, subCategory) ||
                other.subCategory == subCategory) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._nutritionFacts, _nutritionFacts) &&
            const DeepCollectionEquality()
                .equals(other._nutritionAttributes, _nutritionAttributes) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens) &&
            (identical(other.spicyLevel, spicyLevel) ||
                other.spicyLevel == spicyLevel) &&
            (identical(other.preparationTime, preparationTime) ||
                other.preparationTime == preparationTime) &&
            (identical(other.estimatedPrepTime, estimatedPrepTime) ||
                other.estimatedPrepTime == estimatedPrepTime) &&
            const DeepCollectionEquality().equals(other._regions, _regions) &&
            const DeepCollectionEquality().equals(other._seasons, _seasons) &&
            (identical(other.isPackage, isPackage) ||
                other.isPackage == isPackage) &&
            const DeepCollectionEquality()
                .equals(other._packageDishes, _packageDishes) &&
            const DeepCollectionEquality()
                .equals(other._suitableMerchantTypes, _suitableMerchantTypes) &&
            const DeepCollectionEquality()
                .equals(other._healthBenefits, _healthBenefits) &&
            const DeepCollectionEquality()
                .equals(other._suitableDiets, _suitableDiets) &&
            const DeepCollectionEquality().equals(
                other._suitableActivityLevels, _suitableActivityLevels) &&
            const DeepCollectionEquality()
                .equals(other._suitableAgeGroups, _suitableAgeGroups) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
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
        name,
        description,
        imageUrl,
        const DeepCollectionEquality().hash(_imageUrls),
        price,
        discountedPrice,
        category,
        subCategory,
        const DeepCollectionEquality().hash(_tags),
        const DeepCollectionEquality().hash(_nutritionFacts),
        const DeepCollectionEquality().hash(_nutritionAttributes),
        const DeepCollectionEquality().hash(_ingredients),
        const DeepCollectionEquality().hash(_allergens),
        spicyLevel,
        preparationTime,
        estimatedPrepTime,
        const DeepCollectionEquality().hash(_regions),
        const DeepCollectionEquality().hash(_seasons),
        isPackage,
        const DeepCollectionEquality().hash(_packageDishes),
        const DeepCollectionEquality().hash(_suitableMerchantTypes),
        const DeepCollectionEquality().hash(_healthBenefits),
        const DeepCollectionEquality().hash(_suitableDiets),
        const DeepCollectionEquality().hash(_suitableActivityLevels),
        const DeepCollectionEquality().hash(_suitableAgeGroups),
        createdBy,
        isActive,
        isAvailable,
        isFeatured,
        visibility,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of DishEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DishEntityImplCopyWith<_$DishEntityImpl> get copyWith =>
      __$$DishEntityImplCopyWithImpl<_$DishEntityImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DishEntity value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DishEntity value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DishEntity value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DishEntityImplToJson(
      this,
    );
  }
}

abstract class _DishEntity implements DishEntity {
  const factory _DishEntity(
          {@JsonKey(name: '_id') required final String id,
          required final String name,
          required final String description,
          @JsonKey(name: 'imageUrl') final String? imageUrl,
          final List<String> imageUrls,
          required final double price,
          @JsonKey(name: 'discountedPrice') final double? discountedPrice,
          required final String category,
          final String? subCategory,
          final List<String> tags,
          final Map<String, dynamic> nutritionFacts,
          final List<String> nutritionAttributes,
          final List<String> ingredients,
          final List<String> allergens,
          final int spicyLevel,
          final int preparationTime,
          final int estimatedPrepTime,
          final List<String> regions,
          final List<String> seasons,
          final bool isPackage,
          final List<PackageDishItem> packageDishes,
          final List<String> suitableMerchantTypes,
          final List<HealthBenefit> healthBenefits,
          final List<String> suitableDiets,
          final List<String> suitableActivityLevels,
          final List<String> suitableAgeGroups,
          @JsonKey(name: 'createdBy') required final String createdBy,
          final bool isActive,
          final bool isAvailable,
          final bool isFeatured,
          final String visibility,
          @JsonKey(name: 'createdAt') required final DateTime createdAt,
          @JsonKey(name: 'updatedAt') required final DateTime updatedAt}) =
      _$DishEntityImpl;

  factory _DishEntity.fromJson(Map<String, dynamic> json) =
      _$DishEntityImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  @JsonKey(name: 'imageUrl')
  String? get imageUrl;
  @override
  List<String> get imageUrls; // 多图片支持
  @override
  double get price;
  @override
  @JsonKey(name: 'discountedPrice')
  double? get discountedPrice;
  @override
  String get category;
  @override
  String? get subCategory;
  @override
  List<String> get tags;
  @override
  Map<String, dynamic> get nutritionFacts;
  @override
  List<String> get nutritionAttributes;
  @override
  List<String> get ingredients;
  @override
  List<String> get allergens;
  @override
  int get spicyLevel;
  @override
  int get preparationTime;
  @override
  int get estimatedPrepTime; // 预计准备时间（分钟）
  @override
  List<String> get regions;
  @override
  List<String> get seasons;
  @override
  bool get isPackage;
  @override
  List<PackageDishItem> get packageDishes;
  @override
  List<String> get suitableMerchantTypes;
  @override
  List<HealthBenefit> get healthBenefits;
  @override
  List<String> get suitableDiets;
  @override
  List<String> get suitableActivityLevels;
  @override
  List<String> get suitableAgeGroups;
  @override
  @JsonKey(name: 'createdBy')
  String get createdBy;
  @override
  bool get isActive;
  @override
  bool get isAvailable; // 是否可用
  @override
  bool get isFeatured; // 是否特色推荐
  @override
  String get visibility;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt;

  /// Create a copy of DishEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DishEntityImplCopyWith<_$DishEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PackageDishItem _$PackageDishItemFromJson(Map<String, dynamic> json) {
  return _PackageDishItem.fromJson(json);
}

/// @nodoc
mixin _$PackageDishItem {
  @JsonKey(name: 'dishId')
  String get dishId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PackageDishItem value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PackageDishItem value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PackageDishItem value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this PackageDishItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PackageDishItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PackageDishItemCopyWith<PackageDishItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageDishItemCopyWith<$Res> {
  factory $PackageDishItemCopyWith(
          PackageDishItem value, $Res Function(PackageDishItem) then) =
      _$PackageDishItemCopyWithImpl<$Res, PackageDishItem>;
  @useResult
  $Res call({@JsonKey(name: 'dishId') String dishId, int quantity});
}

/// @nodoc
class _$PackageDishItemCopyWithImpl<$Res, $Val extends PackageDishItem>
    implements $PackageDishItemCopyWith<$Res> {
  _$PackageDishItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PackageDishItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dishId = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      dishId: null == dishId
          ? _value.dishId
          : dishId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PackageDishItemImplCopyWith<$Res>
    implements $PackageDishItemCopyWith<$Res> {
  factory _$$PackageDishItemImplCopyWith(_$PackageDishItemImpl value,
          $Res Function(_$PackageDishItemImpl) then) =
      __$$PackageDishItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'dishId') String dishId, int quantity});
}

/// @nodoc
class __$$PackageDishItemImplCopyWithImpl<$Res>
    extends _$PackageDishItemCopyWithImpl<$Res, _$PackageDishItemImpl>
    implements _$$PackageDishItemImplCopyWith<$Res> {
  __$$PackageDishItemImplCopyWithImpl(
      _$PackageDishItemImpl _value, $Res Function(_$PackageDishItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of PackageDishItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dishId = null,
    Object? quantity = null,
  }) {
    return _then(_$PackageDishItemImpl(
      dishId: null == dishId
          ? _value.dishId
          : dishId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PackageDishItemImpl implements _PackageDishItem {
  const _$PackageDishItemImpl(
      {@JsonKey(name: 'dishId') required this.dishId, this.quantity = 1});

  factory _$PackageDishItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageDishItemImplFromJson(json);

  @override
  @JsonKey(name: 'dishId')
  final String dishId;
  @override
  @JsonKey()
  final int quantity;

  @override
  String toString() {
    return 'PackageDishItem(dishId: $dishId, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageDishItemImpl &&
            (identical(other.dishId, dishId) || other.dishId == dishId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dishId, quantity);

  /// Create a copy of PackageDishItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageDishItemImplCopyWith<_$PackageDishItemImpl> get copyWith =>
      __$$PackageDishItemImplCopyWithImpl<_$PackageDishItemImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PackageDishItem value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PackageDishItem value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PackageDishItem value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageDishItemImplToJson(
      this,
    );
  }
}

abstract class _PackageDishItem implements PackageDishItem {
  const factory _PackageDishItem(
      {@JsonKey(name: 'dishId') required final String dishId,
      final int quantity}) = _$PackageDishItemImpl;

  factory _PackageDishItem.fromJson(Map<String, dynamic> json) =
      _$PackageDishItemImpl.fromJson;

  @override
  @JsonKey(name: 'dishId')
  String get dishId;
  @override
  int get quantity;

  /// Create a copy of PackageDishItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackageDishItemImplCopyWith<_$PackageDishItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HealthBenefit _$HealthBenefitFromJson(Map<String, dynamic> json) {
  return _HealthBenefit.fromJson(json);
}

/// @nodoc
mixin _$HealthBenefit {
  String get targetCondition => throw _privateConstructorUsedError;
  String get benefitDescription => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HealthBenefit value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HealthBenefit value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HealthBenefit value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this HealthBenefit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthBenefit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthBenefitCopyWith<HealthBenefit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthBenefitCopyWith<$Res> {
  factory $HealthBenefitCopyWith(
          HealthBenefit value, $Res Function(HealthBenefit) then) =
      _$HealthBenefitCopyWithImpl<$Res, HealthBenefit>;
  @useResult
  $Res call({String targetCondition, String benefitDescription});
}

/// @nodoc
class _$HealthBenefitCopyWithImpl<$Res, $Val extends HealthBenefit>
    implements $HealthBenefitCopyWith<$Res> {
  _$HealthBenefitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthBenefit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetCondition = null,
    Object? benefitDescription = null,
  }) {
    return _then(_value.copyWith(
      targetCondition: null == targetCondition
          ? _value.targetCondition
          : targetCondition // ignore: cast_nullable_to_non_nullable
              as String,
      benefitDescription: null == benefitDescription
          ? _value.benefitDescription
          : benefitDescription // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthBenefitImplCopyWith<$Res>
    implements $HealthBenefitCopyWith<$Res> {
  factory _$$HealthBenefitImplCopyWith(
          _$HealthBenefitImpl value, $Res Function(_$HealthBenefitImpl) then) =
      __$$HealthBenefitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String targetCondition, String benefitDescription});
}

/// @nodoc
class __$$HealthBenefitImplCopyWithImpl<$Res>
    extends _$HealthBenefitCopyWithImpl<$Res, _$HealthBenefitImpl>
    implements _$$HealthBenefitImplCopyWith<$Res> {
  __$$HealthBenefitImplCopyWithImpl(
      _$HealthBenefitImpl _value, $Res Function(_$HealthBenefitImpl) _then)
      : super(_value, _then);

  /// Create a copy of HealthBenefit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetCondition = null,
    Object? benefitDescription = null,
  }) {
    return _then(_$HealthBenefitImpl(
      targetCondition: null == targetCondition
          ? _value.targetCondition
          : targetCondition // ignore: cast_nullable_to_non_nullable
              as String,
      benefitDescription: null == benefitDescription
          ? _value.benefitDescription
          : benefitDescription // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthBenefitImpl implements _HealthBenefit {
  const _$HealthBenefitImpl(
      {required this.targetCondition, required this.benefitDescription});

  factory _$HealthBenefitImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthBenefitImplFromJson(json);

  @override
  final String targetCondition;
  @override
  final String benefitDescription;

  @override
  String toString() {
    return 'HealthBenefit(targetCondition: $targetCondition, benefitDescription: $benefitDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthBenefitImpl &&
            (identical(other.targetCondition, targetCondition) ||
                other.targetCondition == targetCondition) &&
            (identical(other.benefitDescription, benefitDescription) ||
                other.benefitDescription == benefitDescription));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, targetCondition, benefitDescription);

  /// Create a copy of HealthBenefit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthBenefitImplCopyWith<_$HealthBenefitImpl> get copyWith =>
      __$$HealthBenefitImplCopyWithImpl<_$HealthBenefitImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HealthBenefit value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HealthBenefit value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HealthBenefit value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthBenefitImplToJson(
      this,
    );
  }
}

abstract class _HealthBenefit implements HealthBenefit {
  const factory _HealthBenefit(
      {required final String targetCondition,
      required final String benefitDescription}) = _$HealthBenefitImpl;

  factory _HealthBenefit.fromJson(Map<String, dynamic> json) =
      _$HealthBenefitImpl.fromJson;

  @override
  String get targetCondition;
  @override
  String get benefitDescription;

  /// Create a copy of HealthBenefit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthBenefitImplCopyWith<_$HealthBenefitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoreDishEntity _$StoreDishEntityFromJson(Map<String, dynamic> json) {
  return _StoreDishEntity.fromJson(json);
}

/// @nodoc
mixin _$StoreDishEntity {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'storeId')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'dishId')
  DishEntity get dishInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'priceOverride')
  double? get priceOverride => throw _privateConstructorUsedError;
  @JsonKey(name: 'discountPriceOverride')
  double? get discountPriceOverride => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  Map<String, dynamic> get inventory => throw _privateConstructorUsedError;
  String? get storeSpecificDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StoreDishEntity value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StoreDishEntity value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StoreDishEntity value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this StoreDishEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreDishEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreDishEntityCopyWith<StoreDishEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreDishEntityCopyWith<$Res> {
  factory $StoreDishEntityCopyWith(
          StoreDishEntity value, $Res Function(StoreDishEntity) then) =
      _$StoreDishEntityCopyWithImpl<$Res, StoreDishEntity>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      @JsonKey(name: 'storeId') String storeId,
      @JsonKey(name: 'dishId') DishEntity dishInfo,
      @JsonKey(name: 'priceOverride') double? priceOverride,
      @JsonKey(name: 'discountPriceOverride') double? discountPriceOverride,
      bool isAvailable,
      List<String> images,
      Map<String, dynamic> inventory,
      String? storeSpecificDescription,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt});

  $DishEntityCopyWith<$Res> get dishInfo;
}

/// @nodoc
class _$StoreDishEntityCopyWithImpl<$Res, $Val extends StoreDishEntity>
    implements $StoreDishEntityCopyWith<$Res> {
  _$StoreDishEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreDishEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? dishInfo = null,
    Object? priceOverride = freezed,
    Object? discountPriceOverride = freezed,
    Object? isAvailable = null,
    Object? images = null,
    Object? inventory = null,
    Object? storeSpecificDescription = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      dishInfo: null == dishInfo
          ? _value.dishInfo
          : dishInfo // ignore: cast_nullable_to_non_nullable
              as DishEntity,
      priceOverride: freezed == priceOverride
          ? _value.priceOverride
          : priceOverride // ignore: cast_nullable_to_non_nullable
              as double?,
      discountPriceOverride: freezed == discountPriceOverride
          ? _value.discountPriceOverride
          : discountPriceOverride // ignore: cast_nullable_to_non_nullable
              as double?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inventory: null == inventory
          ? _value.inventory
          : inventory // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      storeSpecificDescription: freezed == storeSpecificDescription
          ? _value.storeSpecificDescription
          : storeSpecificDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of StoreDishEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DishEntityCopyWith<$Res> get dishInfo {
    return $DishEntityCopyWith<$Res>(_value.dishInfo, (value) {
      return _then(_value.copyWith(dishInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StoreDishEntityImplCopyWith<$Res>
    implements $StoreDishEntityCopyWith<$Res> {
  factory _$$StoreDishEntityImplCopyWith(_$StoreDishEntityImpl value,
          $Res Function(_$StoreDishEntityImpl) then) =
      __$$StoreDishEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      @JsonKey(name: 'storeId') String storeId,
      @JsonKey(name: 'dishId') DishEntity dishInfo,
      @JsonKey(name: 'priceOverride') double? priceOverride,
      @JsonKey(name: 'discountPriceOverride') double? discountPriceOverride,
      bool isAvailable,
      List<String> images,
      Map<String, dynamic> inventory,
      String? storeSpecificDescription,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt});

  @override
  $DishEntityCopyWith<$Res> get dishInfo;
}

/// @nodoc
class __$$StoreDishEntityImplCopyWithImpl<$Res>
    extends _$StoreDishEntityCopyWithImpl<$Res, _$StoreDishEntityImpl>
    implements _$$StoreDishEntityImplCopyWith<$Res> {
  __$$StoreDishEntityImplCopyWithImpl(
      _$StoreDishEntityImpl _value, $Res Function(_$StoreDishEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreDishEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? dishInfo = null,
    Object? priceOverride = freezed,
    Object? discountPriceOverride = freezed,
    Object? isAvailable = null,
    Object? images = null,
    Object? inventory = null,
    Object? storeSpecificDescription = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$StoreDishEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      dishInfo: null == dishInfo
          ? _value.dishInfo
          : dishInfo // ignore: cast_nullable_to_non_nullable
              as DishEntity,
      priceOverride: freezed == priceOverride
          ? _value.priceOverride
          : priceOverride // ignore: cast_nullable_to_non_nullable
              as double?,
      discountPriceOverride: freezed == discountPriceOverride
          ? _value.discountPriceOverride
          : discountPriceOverride // ignore: cast_nullable_to_non_nullable
              as double?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inventory: null == inventory
          ? _value._inventory
          : inventory // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      storeSpecificDescription: freezed == storeSpecificDescription
          ? _value.storeSpecificDescription
          : storeSpecificDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreDishEntityImpl implements _StoreDishEntity {
  const _$StoreDishEntityImpl(
      {@JsonKey(name: '_id') required this.id,
      @JsonKey(name: 'storeId') required this.storeId,
      @JsonKey(name: 'dishId') required this.dishInfo,
      @JsonKey(name: 'priceOverride') this.priceOverride,
      @JsonKey(name: 'discountPriceOverride') this.discountPriceOverride,
      this.isAvailable = true,
      final List<String> images = const [],
      final Map<String, dynamic> inventory = const {},
      this.storeSpecificDescription,
      @JsonKey(name: 'createdAt') required this.createdAt,
      @JsonKey(name: 'updatedAt') required this.updatedAt})
      : _images = images,
        _inventory = inventory;

  factory _$StoreDishEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreDishEntityImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(name: 'storeId')
  final String storeId;
  @override
  @JsonKey(name: 'dishId')
  final DishEntity dishInfo;
  @override
  @JsonKey(name: 'priceOverride')
  final double? priceOverride;
  @override
  @JsonKey(name: 'discountPriceOverride')
  final double? discountPriceOverride;
  @override
  @JsonKey()
  final bool isAvailable;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final Map<String, dynamic> _inventory;
  @override
  @JsonKey()
  Map<String, dynamic> get inventory {
    if (_inventory is EqualUnmodifiableMapView) return _inventory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_inventory);
  }

  @override
  final String? storeSpecificDescription;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'StoreDishEntity(id: $id, storeId: $storeId, dishInfo: $dishInfo, priceOverride: $priceOverride, discountPriceOverride: $discountPriceOverride, isAvailable: $isAvailable, images: $images, inventory: $inventory, storeSpecificDescription: $storeSpecificDescription, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreDishEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.dishInfo, dishInfo) ||
                other.dishInfo == dishInfo) &&
            (identical(other.priceOverride, priceOverride) ||
                other.priceOverride == priceOverride) &&
            (identical(other.discountPriceOverride, discountPriceOverride) ||
                other.discountPriceOverride == discountPriceOverride) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality()
                .equals(other._inventory, _inventory) &&
            (identical(
                    other.storeSpecificDescription, storeSpecificDescription) ||
                other.storeSpecificDescription == storeSpecificDescription) &&
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
      dishInfo,
      priceOverride,
      discountPriceOverride,
      isAvailable,
      const DeepCollectionEquality().hash(_images),
      const DeepCollectionEquality().hash(_inventory),
      storeSpecificDescription,
      createdAt,
      updatedAt);

  /// Create a copy of StoreDishEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreDishEntityImplCopyWith<_$StoreDishEntityImpl> get copyWith =>
      __$$StoreDishEntityImplCopyWithImpl<_$StoreDishEntityImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StoreDishEntity value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StoreDishEntity value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StoreDishEntity value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreDishEntityImplToJson(
      this,
    );
  }
}

abstract class _StoreDishEntity implements StoreDishEntity {
  const factory _StoreDishEntity(
          {@JsonKey(name: '_id') required final String id,
          @JsonKey(name: 'storeId') required final String storeId,
          @JsonKey(name: 'dishId') required final DishEntity dishInfo,
          @JsonKey(name: 'priceOverride') final double? priceOverride,
          @JsonKey(name: 'discountPriceOverride')
          final double? discountPriceOverride,
          final bool isAvailable,
          final List<String> images,
          final Map<String, dynamic> inventory,
          final String? storeSpecificDescription,
          @JsonKey(name: 'createdAt') required final DateTime createdAt,
          @JsonKey(name: 'updatedAt') required final DateTime updatedAt}) =
      _$StoreDishEntityImpl;

  factory _StoreDishEntity.fromJson(Map<String, dynamic> json) =
      _$StoreDishEntityImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(name: 'storeId')
  String get storeId;
  @override
  @JsonKey(name: 'dishId')
  DishEntity get dishInfo;
  @override
  @JsonKey(name: 'priceOverride')
  double? get priceOverride;
  @override
  @JsonKey(name: 'discountPriceOverride')
  double? get discountPriceOverride;
  @override
  bool get isAvailable;
  @override
  List<String> get images;
  @override
  Map<String, dynamic> get inventory;
  @override
  String? get storeSpecificDescription;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt;

  /// Create a copy of StoreDishEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreDishEntityImplCopyWith<_$StoreDishEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
