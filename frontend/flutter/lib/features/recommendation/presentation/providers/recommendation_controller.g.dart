// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredRecommendationsHash() =>
    r'7aa74d8655fe3417c7b6ac21cc74bd326ce3e617';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 推荐类型过滤器
///
/// Copied from [filteredRecommendations].
@ProviderFor(filteredRecommendations)
const filteredRecommendationsProvider = FilteredRecommendationsFamily();

/// 推荐类型过滤器
///
/// Copied from [filteredRecommendations].
class FilteredRecommendationsFamily extends Family<List<Urecommendation>> {
  /// 推荐类型过滤器
  ///
  /// Copied from [filteredRecommendations].
  const FilteredRecommendationsFamily();

  /// 推荐类型过滤器
  ///
  /// Copied from [filteredRecommendations].
  FilteredRecommendationsProvider call(
    String? type,
  ) {
    return FilteredRecommendationsProvider(
      type,
    );
  }

  @override
  FilteredRecommendationsProvider getProviderOverride(
    covariant FilteredRecommendationsProvider provider,
  ) {
    return call(
      provider.type,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredRecommendationsProvider';
}

/// 推荐类型过滤器
///
/// Copied from [filteredRecommendations].
class FilteredRecommendationsProvider
    extends AutoDisposeProvider<List<Urecommendation>> {
  /// 推荐类型过滤器
  ///
  /// Copied from [filteredRecommendations].
  FilteredRecommendationsProvider(
    String? type,
  ) : this._internal(
          (ref) => filteredRecommendations(
            ref as FilteredRecommendationsRef,
            type,
          ),
          from: filteredRecommendationsProvider,
          name: r'filteredRecommendationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredRecommendationsHash,
          dependencies: FilteredRecommendationsFamily._dependencies,
          allTransitiveDependencies:
              FilteredRecommendationsFamily._allTransitiveDependencies,
          type: type,
        );

  FilteredRecommendationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final String? type;

  @override
  Override overrideWith(
    List<Urecommendation> Function(FilteredRecommendationsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredRecommendationsProvider._internal(
        (ref) => create(ref as FilteredRecommendationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<Urecommendation>> createElement() {
    return _FilteredRecommendationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredRecommendationsProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredRecommendationsRef
    on AutoDisposeProviderRef<List<Urecommendation>> {
  /// The parameter `type` of this provider.
  String? get type;
}

class _FilteredRecommendationsProviderElement
    extends AutoDisposeProviderElement<List<Urecommendation>>
    with FilteredRecommendationsRef {
  _FilteredRecommendationsProviderElement(super.provider);

  @override
  String? get type => (origin as FilteredRecommendationsProvider).type;
}

String _$recommendationStatsHash() =>
    r'e33ed01cf432f83b9e6d8a9602c73aadc73cbdb1';

/// 推荐统计
///
/// Copied from [recommendationStats].
@ProviderFor(recommendationStats)
final recommendationStatsProvider =
    AutoDisposeProvider<Map<String, int>>.internal(
  recommendationStats,
  name: r'recommendationStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recommendationStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecommendationStatsRef = AutoDisposeProviderRef<Map<String, int>>;
String _$getRecommendationsUseCaseHash() =>
    r'7f0416b33522b8830c89e4e66d1fe61caca54616';

/// UseCase Provider
///
/// Copied from [getRecommendationsUseCase].
@ProviderFor(getRecommendationsUseCase)
final getRecommendationsUseCaseProvider =
    AutoDisposeProvider<GetUrecommendationsUseCase>.internal(
  getRecommendationsUseCase,
  name: r'getRecommendationsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getRecommendationsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetRecommendationsUseCaseRef
    = AutoDisposeProviderRef<GetUrecommendationsUseCase>;
String _$recommendationRepositoryHash() =>
    r'ea8249077a6e5dac0c8e30e5ccec9bdb35bc68ca';

/// Repository Provider
///
/// Copied from [recommendationRepository].
@ProviderFor(recommendationRepository)
final recommendationRepositoryProvider =
    AutoDisposeProvider<UrecommendationRepository>.internal(
  recommendationRepository,
  name: r'recommendationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recommendationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecommendationRepositoryRef
    = AutoDisposeProviderRef<UrecommendationRepository>;
String _$currentRecommendationsHash() =>
    r'e289c9369a1fc11a7c8f22657d355caf4df67359';

/// 便捷访问器
///
/// Copied from [currentRecommendations].
@ProviderFor(currentRecommendations)
final currentRecommendationsProvider =
    AutoDisposeProvider<List<Urecommendation>>.internal(
  currentRecommendations,
  name: r'currentRecommendationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentRecommendationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentRecommendationsRef
    = AutoDisposeProviderRef<List<Urecommendation>>;
String _$hasRecommendationsHash() =>
    r'97bbe206ff6b39abf00baf72c8debe4a52f29152';

/// See also [hasRecommendations].
@ProviderFor(hasRecommendations)
final hasRecommendationsProvider = AutoDisposeProvider<bool>.internal(
  hasRecommendations,
  name: r'hasRecommendationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasRecommendationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasRecommendationsRef = AutoDisposeProviderRef<bool>;
String _$recommendationCountHash() =>
    r'5e56fdefe27a90acbd2a861a388e7f95bed92e94';

/// See also [recommendationCount].
@ProviderFor(recommendationCount)
final recommendationCountProvider = AutoDisposeProvider<int>.internal(
  recommendationCount,
  name: r'recommendationCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recommendationCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecommendationCountRef = AutoDisposeProviderRef<int>;
String _$popularRecommendationsHash() =>
    r'6ef3724b8ddc2138726ec3225645872389a6eb08';

/// 热门推荐
///
/// Copied from [popularRecommendations].
@ProviderFor(popularRecommendations)
final popularRecommendationsProvider =
    AutoDisposeProvider<List<Urecommendation>>.internal(
  popularRecommendations,
  name: r'popularRecommendationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$popularRecommendationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PopularRecommendationsRef
    = AutoDisposeProviderRef<List<Urecommendation>>;
String _$recommendationControllerHash() =>
    r'48700c71e0355f31c8dd87a7cf1f2e6ad84a5af3';

/// 推荐控制器 - 使用新的 AsyncNotifier 模式
///
/// Copied from [RecommendationController].
@ProviderFor(RecommendationController)
final recommendationControllerProvider = AutoDisposeAsyncNotifierProvider<
    RecommendationController, List<Urecommendation>>.internal(
  RecommendationController.new,
  name: r'recommendationControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recommendationControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecommendationController
    = AutoDisposeAsyncNotifier<List<Urecommendation>>;
String _$singleRecommendationControllerHash() =>
    r'14c347113100ee8bfec6281e2be447845b2784f6';

abstract class _$SingleRecommendationController
    extends BuildlessAutoDisposeAsyncNotifier<Urecommendation?> {
  late final String recommendationId;

  FutureOr<Urecommendation?> build(
    String recommendationId,
  );
}

/// 单个推荐控制器
///
/// Copied from [SingleRecommendationController].
@ProviderFor(SingleRecommendationController)
const singleRecommendationControllerProvider =
    SingleRecommendationControllerFamily();

/// 单个推荐控制器
///
/// Copied from [SingleRecommendationController].
class SingleRecommendationControllerFamily
    extends Family<AsyncValue<Urecommendation?>> {
  /// 单个推荐控制器
  ///
  /// Copied from [SingleRecommendationController].
  const SingleRecommendationControllerFamily();

  /// 单个推荐控制器
  ///
  /// Copied from [SingleRecommendationController].
  SingleRecommendationControllerProvider call(
    String recommendationId,
  ) {
    return SingleRecommendationControllerProvider(
      recommendationId,
    );
  }

  @override
  SingleRecommendationControllerProvider getProviderOverride(
    covariant SingleRecommendationControllerProvider provider,
  ) {
    return call(
      provider.recommendationId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'singleRecommendationControllerProvider';
}

/// 单个推荐控制器
///
/// Copied from [SingleRecommendationController].
class SingleRecommendationControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<SingleRecommendationController,
        Urecommendation?> {
  /// 单个推荐控制器
  ///
  /// Copied from [SingleRecommendationController].
  SingleRecommendationControllerProvider(
    String recommendationId,
  ) : this._internal(
          () => SingleRecommendationController()
            ..recommendationId = recommendationId,
          from: singleRecommendationControllerProvider,
          name: r'singleRecommendationControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$singleRecommendationControllerHash,
          dependencies: SingleRecommendationControllerFamily._dependencies,
          allTransitiveDependencies:
              SingleRecommendationControllerFamily._allTransitiveDependencies,
          recommendationId: recommendationId,
        );

  SingleRecommendationControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.recommendationId,
  }) : super.internal();

  final String recommendationId;

  @override
  FutureOr<Urecommendation?> runNotifierBuild(
    covariant SingleRecommendationController notifier,
  ) {
    return notifier.build(
      recommendationId,
    );
  }

  @override
  Override overrideWith(SingleRecommendationController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SingleRecommendationControllerProvider._internal(
        () => create()..recommendationId = recommendationId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        recommendationId: recommendationId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SingleRecommendationController,
      Urecommendation?> createElement() {
    return _SingleRecommendationControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SingleRecommendationControllerProvider &&
        other.recommendationId == recommendationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, recommendationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SingleRecommendationControllerRef
    on AutoDisposeAsyncNotifierProviderRef<Urecommendation?> {
  /// The parameter `recommendationId` of this provider.
  String get recommendationId;
}

class _SingleRecommendationControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        SingleRecommendationController,
        Urecommendation?> with SingleRecommendationControllerRef {
  _SingleRecommendationControllerProviderElement(super.provider);

  @override
  String get recommendationId =>
      (origin as SingleRecommendationControllerProvider).recommendationId;
}

String _$personalizedRecommendationControllerHash() =>
    r'9853dd48e98ad1d0c2171d96a821b1714e7fc4db';

abstract class _$PersonalizedRecommendationController
    extends BuildlessAutoDisposeAsyncNotifier<List<Urecommendation>> {
  late final String userId;

  FutureOr<List<Urecommendation>> build(
    String userId,
  );
}

/// 个性化推荐控制器
///
/// Copied from [PersonalizedRecommendationController].
@ProviderFor(PersonalizedRecommendationController)
const personalizedRecommendationControllerProvider =
    PersonalizedRecommendationControllerFamily();

/// 个性化推荐控制器
///
/// Copied from [PersonalizedRecommendationController].
class PersonalizedRecommendationControllerFamily
    extends Family<AsyncValue<List<Urecommendation>>> {
  /// 个性化推荐控制器
  ///
  /// Copied from [PersonalizedRecommendationController].
  const PersonalizedRecommendationControllerFamily();

  /// 个性化推荐控制器
  ///
  /// Copied from [PersonalizedRecommendationController].
  PersonalizedRecommendationControllerProvider call(
    String userId,
  ) {
    return PersonalizedRecommendationControllerProvider(
      userId,
    );
  }

  @override
  PersonalizedRecommendationControllerProvider getProviderOverride(
    covariant PersonalizedRecommendationControllerProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'personalizedRecommendationControllerProvider';
}

/// 个性化推荐控制器
///
/// Copied from [PersonalizedRecommendationController].
class PersonalizedRecommendationControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<
        PersonalizedRecommendationController, List<Urecommendation>> {
  /// 个性化推荐控制器
  ///
  /// Copied from [PersonalizedRecommendationController].
  PersonalizedRecommendationControllerProvider(
    String userId,
  ) : this._internal(
          () => PersonalizedRecommendationController()..userId = userId,
          from: personalizedRecommendationControllerProvider,
          name: r'personalizedRecommendationControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$personalizedRecommendationControllerHash,
          dependencies:
              PersonalizedRecommendationControllerFamily._dependencies,
          allTransitiveDependencies: PersonalizedRecommendationControllerFamily
              ._allTransitiveDependencies,
          userId: userId,
        );

  PersonalizedRecommendationControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FutureOr<List<Urecommendation>> runNotifierBuild(
    covariant PersonalizedRecommendationController notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(
      PersonalizedRecommendationController Function() create) {
    return ProviderOverride(
      origin: this,
      override: PersonalizedRecommendationControllerProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PersonalizedRecommendationController,
      List<Urecommendation>> createElement() {
    return _PersonalizedRecommendationControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonalizedRecommendationControllerProvider &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PersonalizedRecommendationControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<Urecommendation>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _PersonalizedRecommendationControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        PersonalizedRecommendationController,
        List<Urecommendation>> with PersonalizedRecommendationControllerRef {
  _PersonalizedRecommendationControllerProviderElement(super.provider);

  @override
  String get userId =>
      (origin as PersonalizedRecommendationControllerProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
