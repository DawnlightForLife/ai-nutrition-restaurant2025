// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredOrdersHash() => r'33552c760a8d40a1699c76781eb9ba6d21ee0640';

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

/// 订单状态过滤器
///
/// Copied from [filteredOrders].
@ProviderFor(filteredOrders)
const filteredOrdersProvider = FilteredOrdersFamily();

/// 订单状态过滤器
///
/// Copied from [filteredOrders].
class FilteredOrdersFamily extends Family<List<Uorder>> {
  /// 订单状态过滤器
  ///
  /// Copied from [filteredOrders].
  const FilteredOrdersFamily();

  /// 订单状态过滤器
  ///
  /// Copied from [filteredOrders].
  FilteredOrdersProvider call(
    String? status,
  ) {
    return FilteredOrdersProvider(
      status,
    );
  }

  @override
  FilteredOrdersProvider getProviderOverride(
    covariant FilteredOrdersProvider provider,
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
  String? get name => r'filteredOrdersProvider';
}

/// 订单状态过滤器
///
/// Copied from [filteredOrders].
class FilteredOrdersProvider extends AutoDisposeProvider<List<Uorder>> {
  /// 订单状态过滤器
  ///
  /// Copied from [filteredOrders].
  FilteredOrdersProvider(
    String? status,
  ) : this._internal(
          (ref) => filteredOrders(
            ref as FilteredOrdersRef,
            status,
          ),
          from: filteredOrdersProvider,
          name: r'filteredOrdersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredOrdersHash,
          dependencies: FilteredOrdersFamily._dependencies,
          allTransitiveDependencies:
              FilteredOrdersFamily._allTransitiveDependencies,
          status: status,
        );

  FilteredOrdersProvider._internal(
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
    List<Uorder> Function(FilteredOrdersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredOrdersProvider._internal(
        (ref) => create(ref as FilteredOrdersRef),
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
  AutoDisposeProviderElement<List<Uorder>> createElement() {
    return _FilteredOrdersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredOrdersProvider && other.status == status;
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
mixin FilteredOrdersRef on AutoDisposeProviderRef<List<Uorder>> {
  /// The parameter `status` of this provider.
  String? get status;
}

class _FilteredOrdersProviderElement
    extends AutoDisposeProviderElement<List<Uorder>> with FilteredOrdersRef {
  _FilteredOrdersProviderElement(super.provider);

  @override
  String? get status => (origin as FilteredOrdersProvider).status;
}

String _$orderStatsHash() => r'c22c369d4c83f264f8203a3dd7a6a7771fe71c39';

/// 订单统计
///
/// Copied from [orderStats].
@ProviderFor(orderStats)
final orderStatsProvider = AutoDisposeProvider<Map<String, int>>.internal(
  orderStats,
  name: r'orderStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$orderStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrderStatsRef = AutoDisposeProviderRef<Map<String, int>>;
String _$getOrdersUseCaseHash() => r'25be9cafdf396736fec694808a9d6106e6e2bde4';

/// UseCase Provider
///
/// Copied from [getOrdersUseCase].
@ProviderFor(getOrdersUseCase)
final getOrdersUseCaseProvider =
    AutoDisposeProvider<GetUordersUseCase>.internal(
  getOrdersUseCase,
  name: r'getOrdersUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getOrdersUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetOrdersUseCaseRef = AutoDisposeProviderRef<GetUordersUseCase>;
String _$orderRepositoryHash() => r'758af11f39e9869a38901838451add6f88d24a36';

/// Repository Provider
///
/// Copied from [orderRepository].
@ProviderFor(orderRepository)
final orderRepositoryProvider = AutoDisposeProvider<UorderRepository>.internal(
  orderRepository,
  name: r'orderRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orderRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrderRepositoryRef = AutoDisposeProviderRef<UorderRepository>;
String _$currentOrdersHash() => r'5bd24e4fb37d3dc7fc5318912bf58305a6cb908d';

/// 便捷访问器
///
/// Copied from [currentOrders].
@ProviderFor(currentOrders)
final currentOrdersProvider = AutoDisposeProvider<List<Uorder>>.internal(
  currentOrders,
  name: r'currentOrdersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentOrdersRef = AutoDisposeProviderRef<List<Uorder>>;
String _$hasOrdersHash() => r'bf12d26ec74873f37d1468343778647e68c348ed';

/// See also [hasOrders].
@ProviderFor(hasOrders)
final hasOrdersProvider = AutoDisposeProvider<bool>.internal(
  hasOrders,
  name: r'hasOrdersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$hasOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasOrdersRef = AutoDisposeProviderRef<bool>;
String _$orderCountHash() => r'f62f674e49e256018cf0f01b4e9b59ea8b4ed441';

/// See also [orderCount].
@ProviderFor(orderCount)
final orderCountProvider = AutoDisposeProvider<int>.internal(
  orderCount,
  name: r'orderCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$orderCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrderCountRef = AutoDisposeProviderRef<int>;
String _$orderControllerHash() => r'232e4f555533d9a70965274c396a3251ce65dc9a';

/// 订单控制器 - 使用新的 AsyncNotifier 模式
///
/// Copied from [OrderController].
@ProviderFor(OrderController)
final orderControllerProvider =
    AutoDisposeAsyncNotifierProvider<OrderController, List<Uorder>>.internal(
  OrderController.new,
  name: r'orderControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orderControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OrderController = AutoDisposeAsyncNotifier<List<Uorder>>;
String _$singleOrderControllerHash() =>
    r'd28d097324bb64b4d6c12b956314ac0b2d0bad98';

abstract class _$SingleOrderController
    extends BuildlessAutoDisposeAsyncNotifier<Uorder?> {
  late final String orderId;

  FutureOr<Uorder?> build(
    String orderId,
  );
}

/// 单个订单控制器
///
/// Copied from [SingleOrderController].
@ProviderFor(SingleOrderController)
const singleOrderControllerProvider = SingleOrderControllerFamily();

/// 单个订单控制器
///
/// Copied from [SingleOrderController].
class SingleOrderControllerFamily extends Family<AsyncValue<Uorder?>> {
  /// 单个订单控制器
  ///
  /// Copied from [SingleOrderController].
  const SingleOrderControllerFamily();

  /// 单个订单控制器
  ///
  /// Copied from [SingleOrderController].
  SingleOrderControllerProvider call(
    String orderId,
  ) {
    return SingleOrderControllerProvider(
      orderId,
    );
  }

  @override
  SingleOrderControllerProvider getProviderOverride(
    covariant SingleOrderControllerProvider provider,
  ) {
    return call(
      provider.orderId,
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
  String? get name => r'singleOrderControllerProvider';
}

/// 单个订单控制器
///
/// Copied from [SingleOrderController].
class SingleOrderControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<SingleOrderController,
        Uorder?> {
  /// 单个订单控制器
  ///
  /// Copied from [SingleOrderController].
  SingleOrderControllerProvider(
    String orderId,
  ) : this._internal(
          () => SingleOrderController()..orderId = orderId,
          from: singleOrderControllerProvider,
          name: r'singleOrderControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$singleOrderControllerHash,
          dependencies: SingleOrderControllerFamily._dependencies,
          allTransitiveDependencies:
              SingleOrderControllerFamily._allTransitiveDependencies,
          orderId: orderId,
        );

  SingleOrderControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderId,
  }) : super.internal();

  final String orderId;

  @override
  FutureOr<Uorder?> runNotifierBuild(
    covariant SingleOrderController notifier,
  ) {
    return notifier.build(
      orderId,
    );
  }

  @override
  Override overrideWith(SingleOrderController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SingleOrderControllerProvider._internal(
        () => create()..orderId = orderId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderId: orderId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SingleOrderController, Uorder?>
      createElement() {
    return _SingleOrderControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SingleOrderControllerProvider && other.orderId == orderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SingleOrderControllerRef on AutoDisposeAsyncNotifierProviderRef<Uorder?> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _SingleOrderControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SingleOrderController,
        Uorder?> with SingleOrderControllerRef {
  _SingleOrderControllerProviderElement(super.provider);

  @override
  String get orderId => (origin as SingleOrderControllerProvider).orderId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
