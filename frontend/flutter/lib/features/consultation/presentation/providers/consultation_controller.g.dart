// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredConsultationsHash() =>
    r'0fd5d9a48408a58a3908ec879935d92e95d7c922';

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

/// 咨询状态过滤器
///
/// Copied from [filteredConsultations].
@ProviderFor(filteredConsultations)
const filteredConsultationsProvider = FilteredConsultationsFamily();

/// 咨询状态过滤器
///
/// Copied from [filteredConsultations].
class FilteredConsultationsFamily extends Family<List<Uconsultation>> {
  /// 咨询状态过滤器
  ///
  /// Copied from [filteredConsultations].
  const FilteredConsultationsFamily();

  /// 咨询状态过滤器
  ///
  /// Copied from [filteredConsultations].
  FilteredConsultationsProvider call(
    String? status,
  ) {
    return FilteredConsultationsProvider(
      status,
    );
  }

  @override
  FilteredConsultationsProvider getProviderOverride(
    covariant FilteredConsultationsProvider provider,
  ) {
    return call(
      provider.status,
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
  String? get name => r'filteredConsultationsProvider';
}

/// 咨询状态过滤器
///
/// Copied from [filteredConsultations].
class FilteredConsultationsProvider
    extends AutoDisposeProvider<List<Uconsultation>> {
  /// 咨询状态过滤器
  ///
  /// Copied from [filteredConsultations].
  FilteredConsultationsProvider(
    String? status,
  ) : this._internal(
          (ref) => filteredConsultations(
            ref as FilteredConsultationsRef,
            status,
          ),
          from: filteredConsultationsProvider,
          name: r'filteredConsultationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredConsultationsHash,
          dependencies: FilteredConsultationsFamily._dependencies,
          allTransitiveDependencies:
              FilteredConsultationsFamily._allTransitiveDependencies,
          status: status,
        );

  FilteredConsultationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final String? status;

  @override
  Override overrideWith(
    List<Uconsultation> Function(FilteredConsultationsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredConsultationsProvider._internal(
        (ref) => create(ref as FilteredConsultationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<Uconsultation>> createElement() {
    return _FilteredConsultationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredConsultationsProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredConsultationsRef on AutoDisposeProviderRef<List<Uconsultation>> {
  /// The parameter `status` of this provider.
  String? get status;
}

class _FilteredConsultationsProviderElement
    extends AutoDisposeProviderElement<List<Uconsultation>>
    with FilteredConsultationsRef {
  _FilteredConsultationsProviderElement(super.provider);

  @override
  String? get status => (origin as FilteredConsultationsProvider).status;
}

String _$consultationStatsHash() => r'e484cdac0a17945f8520c7a2e0c219f075c3ac0b';

/// 咨询统计
///
/// Copied from [consultationStats].
@ProviderFor(consultationStats)
final consultationStatsProvider =
    AutoDisposeProvider<Map<String, int>>.internal(
  consultationStats,
  name: r'consultationStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$consultationStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConsultationStatsRef = AutoDisposeProviderRef<Map<String, int>>;
String _$todayConsultationsHash() =>
    r'311851abc3c741f67adc56ad35dad0812770953e';

/// 今日咨询
///
/// Copied from [todayConsultations].
@ProviderFor(todayConsultations)
final todayConsultationsProvider =
    AutoDisposeProvider<List<Uconsultation>>.internal(
  todayConsultations,
  name: r'todayConsultationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayConsultationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayConsultationsRef = AutoDisposeProviderRef<List<Uconsultation>>;
String _$getConsultationsUseCaseHash() =>
    r'80bc7f1cc51a6b8cb3a9afa97d792ef6f9d3d0ca';

/// UseCase Provider
///
/// Copied from [getConsultationsUseCase].
@ProviderFor(getConsultationsUseCase)
final getConsultationsUseCaseProvider =
    AutoDisposeProvider<GetUconsultationsUseCase>.internal(
  getConsultationsUseCase,
  name: r'getConsultationsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getConsultationsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetConsultationsUseCaseRef
    = AutoDisposeProviderRef<GetUconsultationsUseCase>;
String _$consultationRepositoryHash() =>
    r'1152021444a06ac15e40eb672b801ad701414188';

/// Repository Provider
///
/// Copied from [consultationRepository].
@ProviderFor(consultationRepository)
final consultationRepositoryProvider =
    AutoDisposeProvider<UconsultationRepository>.internal(
  consultationRepository,
  name: r'consultationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$consultationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConsultationRepositoryRef
    = AutoDisposeProviderRef<UconsultationRepository>;
String _$currentConsultationsHash() =>
    r'265022117d40531450bf63bfffd1c3db2b491f65';

/// 便捷访问器
///
/// Copied from [currentConsultations].
@ProviderFor(currentConsultations)
final currentConsultationsProvider =
    AutoDisposeProvider<List<Uconsultation>>.internal(
  currentConsultations,
  name: r'currentConsultationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentConsultationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentConsultationsRef = AutoDisposeProviderRef<List<Uconsultation>>;
String _$hasConsultationsHash() => r'9888e1652ebb9cfa00e181ce9ed8be89fb80e388';

/// See also [hasConsultations].
@ProviderFor(hasConsultations)
final hasConsultationsProvider = AutoDisposeProvider<bool>.internal(
  hasConsultations,
  name: r'hasConsultationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasConsultationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasConsultationsRef = AutoDisposeProviderRef<bool>;
String _$consultationCountHash() => r'08a55111fe724d96bb0ea91f55e3ca6a5cc67f63';

/// See also [consultationCount].
@ProviderFor(consultationCount)
final consultationCountProvider = AutoDisposeProvider<int>.internal(
  consultationCount,
  name: r'consultationCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$consultationCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConsultationCountRef = AutoDisposeProviderRef<int>;
String _$pendingConsultationsHash() =>
    r'6360587f43d539e92d39990aba75bbc7c001e153';

/// 待处理咨询
///
/// Copied from [pendingConsultations].
@ProviderFor(pendingConsultations)
final pendingConsultationsProvider =
    AutoDisposeProvider<List<Uconsultation>>.internal(
  pendingConsultations,
  name: r'pendingConsultationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingConsultationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingConsultationsRef = AutoDisposeProviderRef<List<Uconsultation>>;
String _$activeConsultationsHash() =>
    r'49bd7ae2ef7da113b6aa86b6e3183a5cc97e2f6c';

/// 进行中的咨询
///
/// Copied from [activeConsultations].
@ProviderFor(activeConsultations)
final activeConsultationsProvider =
    AutoDisposeProvider<List<Uconsultation>>.internal(
  activeConsultations,
  name: r'activeConsultationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeConsultationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveConsultationsRef = AutoDisposeProviderRef<List<Uconsultation>>;
String _$consultationControllerHash() =>
    r'acbc9691e05c20d408bf65e5cb488cfb4edfd56c';

/// 咨询控制器 - 使用新的 AsyncNotifier 模式
///
/// Copied from [ConsultationController].
@ProviderFor(ConsultationController)
final consultationControllerProvider = AutoDisposeAsyncNotifierProvider<
    ConsultationController, List<Uconsultation>>.internal(
  ConsultationController.new,
  name: r'consultationControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$consultationControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConsultationController
    = AutoDisposeAsyncNotifier<List<Uconsultation>>;
String _$singleConsultationControllerHash() =>
    r'92031a60a61a93bc741a0475a33c94cce020abf3';

abstract class _$SingleConsultationController
    extends BuildlessAutoDisposeAsyncNotifier<Uconsultation?> {
  late final String consultationId;

  FutureOr<Uconsultation?> build(
    String consultationId,
  );
}

/// 单个咨询控制器
///
/// Copied from [SingleConsultationController].
@ProviderFor(SingleConsultationController)
const singleConsultationControllerProvider =
    SingleConsultationControllerFamily();

/// 单个咨询控制器
///
/// Copied from [SingleConsultationController].
class SingleConsultationControllerFamily
    extends Family<AsyncValue<Uconsultation?>> {
  /// 单个咨询控制器
  ///
  /// Copied from [SingleConsultationController].
  const SingleConsultationControllerFamily();

  /// 单个咨询控制器
  ///
  /// Copied from [SingleConsultationController].
  SingleConsultationControllerProvider call(
    String consultationId,
  ) {
    return SingleConsultationControllerProvider(
      consultationId,
    );
  }

  @override
  SingleConsultationControllerProvider getProviderOverride(
    covariant SingleConsultationControllerProvider provider,
  ) {
    return call(
      provider.consultationId,
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
  String? get name => r'singleConsultationControllerProvider';
}

/// 单个咨询控制器
///
/// Copied from [SingleConsultationController].
class SingleConsultationControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<SingleConsultationController,
        Uconsultation?> {
  /// 单个咨询控制器
  ///
  /// Copied from [SingleConsultationController].
  SingleConsultationControllerProvider(
    String consultationId,
  ) : this._internal(
          () => SingleConsultationController()..consultationId = consultationId,
          from: singleConsultationControllerProvider,
          name: r'singleConsultationControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$singleConsultationControllerHash,
          dependencies: SingleConsultationControllerFamily._dependencies,
          allTransitiveDependencies:
              SingleConsultationControllerFamily._allTransitiveDependencies,
          consultationId: consultationId,
        );

  SingleConsultationControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.consultationId,
  }) : super.internal();

  final String consultationId;

  @override
  FutureOr<Uconsultation?> runNotifierBuild(
    covariant SingleConsultationController notifier,
  ) {
    return notifier.build(
      consultationId,
    );
  }

  @override
  Override overrideWith(SingleConsultationController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SingleConsultationControllerProvider._internal(
        () => create()..consultationId = consultationId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        consultationId: consultationId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SingleConsultationController,
      Uconsultation?> createElement() {
    return _SingleConsultationControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SingleConsultationControllerProvider &&
        other.consultationId == consultationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, consultationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SingleConsultationControllerRef
    on AutoDisposeAsyncNotifierProviderRef<Uconsultation?> {
  /// The parameter `consultationId` of this provider.
  String get consultationId;
}

class _SingleConsultationControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        SingleConsultationController,
        Uconsultation?> with SingleConsultationControllerRef {
  _SingleConsultationControllerProviderElement(super.provider);

  @override
  String get consultationId =>
      (origin as SingleConsultationControllerProvider).consultationId;
}

String _$userConsultationControllerHash() =>
    r'bb75953fadb4811c8df6ceb8de46638f1a52700b';

abstract class _$UserConsultationController
    extends BuildlessAutoDisposeAsyncNotifier<List<Uconsultation>> {
  late final String userId;

  FutureOr<List<Uconsultation>> build(
    String userId,
  );
}

/// 用户咨询控制器
///
/// Copied from [UserConsultationController].
@ProviderFor(UserConsultationController)
const userConsultationControllerProvider = UserConsultationControllerFamily();

/// 用户咨询控制器
///
/// Copied from [UserConsultationController].
class UserConsultationControllerFamily
    extends Family<AsyncValue<List<Uconsultation>>> {
  /// 用户咨询控制器
  ///
  /// Copied from [UserConsultationController].
  const UserConsultationControllerFamily();

  /// 用户咨询控制器
  ///
  /// Copied from [UserConsultationController].
  UserConsultationControllerProvider call(
    String userId,
  ) {
    return UserConsultationControllerProvider(
      userId,
    );
  }

  @override
  UserConsultationControllerProvider getProviderOverride(
    covariant UserConsultationControllerProvider provider,
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
  String? get name => r'userConsultationControllerProvider';
}

/// 用户咨询控制器
///
/// Copied from [UserConsultationController].
class UserConsultationControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserConsultationController,
        List<Uconsultation>> {
  /// 用户咨询控制器
  ///
  /// Copied from [UserConsultationController].
  UserConsultationControllerProvider(
    String userId,
  ) : this._internal(
          () => UserConsultationController()..userId = userId,
          from: userConsultationControllerProvider,
          name: r'userConsultationControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userConsultationControllerHash,
          dependencies: UserConsultationControllerFamily._dependencies,
          allTransitiveDependencies:
              UserConsultationControllerFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserConsultationControllerProvider._internal(
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
  FutureOr<List<Uconsultation>> runNotifierBuild(
    covariant UserConsultationController notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(UserConsultationController Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserConsultationControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<UserConsultationController,
      List<Uconsultation>> createElement() {
    return _UserConsultationControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserConsultationControllerProvider &&
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
mixin UserConsultationControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<Uconsultation>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserConsultationControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserConsultationController,
        List<Uconsultation>> with UserConsultationControllerRef {
  _UserConsultationControllerProviderElement(super.provider);

  @override
  String get userId => (origin as UserConsultationControllerProvider).userId;
}

String _$nutritionistConsultationControllerHash() =>
    r'f75884d87151d8c697c504229302c490170423e2';

abstract class _$NutritionistConsultationController
    extends BuildlessAutoDisposeAsyncNotifier<List<Uconsultation>> {
  late final String nutritionistId;

  FutureOr<List<Uconsultation>> build(
    String nutritionistId,
  );
}

/// 营养师咨询控制器
///
/// Copied from [NutritionistConsultationController].
@ProviderFor(NutritionistConsultationController)
const nutritionistConsultationControllerProvider =
    NutritionistConsultationControllerFamily();

/// 营养师咨询控制器
///
/// Copied from [NutritionistConsultationController].
class NutritionistConsultationControllerFamily
    extends Family<AsyncValue<List<Uconsultation>>> {
  /// 营养师咨询控制器
  ///
  /// Copied from [NutritionistConsultationController].
  const NutritionistConsultationControllerFamily();

  /// 营养师咨询控制器
  ///
  /// Copied from [NutritionistConsultationController].
  NutritionistConsultationControllerProvider call(
    String nutritionistId,
  ) {
    return NutritionistConsultationControllerProvider(
      nutritionistId,
    );
  }

  @override
  NutritionistConsultationControllerProvider getProviderOverride(
    covariant NutritionistConsultationControllerProvider provider,
  ) {
    return call(
      provider.nutritionistId,
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
  String? get name => r'nutritionistConsultationControllerProvider';
}

/// 营养师咨询控制器
///
/// Copied from [NutritionistConsultationController].
class NutritionistConsultationControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<
        NutritionistConsultationController, List<Uconsultation>> {
  /// 营养师咨询控制器
  ///
  /// Copied from [NutritionistConsultationController].
  NutritionistConsultationControllerProvider(
    String nutritionistId,
  ) : this._internal(
          () => NutritionistConsultationController()
            ..nutritionistId = nutritionistId,
          from: nutritionistConsultationControllerProvider,
          name: r'nutritionistConsultationControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$nutritionistConsultationControllerHash,
          dependencies: NutritionistConsultationControllerFamily._dependencies,
          allTransitiveDependencies: NutritionistConsultationControllerFamily
              ._allTransitiveDependencies,
          nutritionistId: nutritionistId,
        );

  NutritionistConsultationControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.nutritionistId,
  }) : super.internal();

  final String nutritionistId;

  @override
  FutureOr<List<Uconsultation>> runNotifierBuild(
    covariant NutritionistConsultationController notifier,
  ) {
    return notifier.build(
      nutritionistId,
    );
  }

  @override
  Override overrideWith(NutritionistConsultationController Function() create) {
    return ProviderOverride(
      origin: this,
      override: NutritionistConsultationControllerProvider._internal(
        () => create()..nutritionistId = nutritionistId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        nutritionistId: nutritionistId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<NutritionistConsultationController,
      List<Uconsultation>> createElement() {
    return _NutritionistConsultationControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NutritionistConsultationControllerProvider &&
        other.nutritionistId == nutritionistId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, nutritionistId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NutritionistConsultationControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<Uconsultation>> {
  /// The parameter `nutritionistId` of this provider.
  String get nutritionistId;
}

class _NutritionistConsultationControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        NutritionistConsultationController,
        List<Uconsultation>> with NutritionistConsultationControllerRef {
  _NutritionistConsultationControllerProviderElement(super.provider);

  @override
  String get nutritionistId =>
      (origin as NutritionistConsultationControllerProvider).nutritionistId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
