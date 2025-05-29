// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMerchantsUseCaseHash() =>
    r'e27bafbf48d639b5f4982b0fa85f16cc0c2d436b';

/// UseCase Provider
///
/// Copied from [getMerchantsUseCase].
@ProviderFor(getMerchantsUseCase)
final getMerchantsUseCaseProvider =
    AutoDisposeProvider<GetUmerchantsUseCase>.internal(
  getMerchantsUseCase,
  name: r'getMerchantsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getMerchantsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetMerchantsUseCaseRef = AutoDisposeProviderRef<GetUmerchantsUseCase>;
String _$merchantListHash() => r'7d420aab8ff9a254468c66d7831fb27f8966a2aa';

/// 商家列表
///
/// Copied from [merchantList].
@ProviderFor(merchantList)
final merchantListProvider = AutoDisposeProvider<List<Umerchant>>.internal(
  merchantList,
  name: r'merchantListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$merchantListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MerchantListRef = AutoDisposeProviderRef<List<Umerchant>>;
String _$merchantIsLoadingHash() => r'533efe042611ec6b2ea8da7d09fc0ef83c166d63';

/// 是否正在加载
///
/// Copied from [merchantIsLoading].
@ProviderFor(merchantIsLoading)
final merchantIsLoadingProvider = AutoDisposeProvider<bool>.internal(
  merchantIsLoading,
  name: r'merchantIsLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$merchantIsLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MerchantIsLoadingRef = AutoDisposeProviderRef<bool>;
String _$merchantErrorHash() => r'79bb718beeccb3f2f307cb242ab2a5143f8da3b6';

/// 错误信息
///
/// Copied from [merchantError].
@ProviderFor(merchantError)
final merchantErrorProvider = AutoDisposeProvider<String?>.internal(
  merchantError,
  name: r'merchantErrorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$merchantErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MerchantErrorRef = AutoDisposeProviderRef<String?>;
String _$selectedMerchantHash() => r'c5859637ed4e213f8c4b4866db5019e8cee98415';

/// 选中的商家
///
/// Copied from [selectedMerchant].
@ProviderFor(selectedMerchant)
final selectedMerchantProvider = AutoDisposeProvider<Umerchant?>.internal(
  selectedMerchant,
  name: r'selectedMerchantProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedMerchantHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedMerchantRef = AutoDisposeProviderRef<Umerchant?>;
String _$merchantCategoriesHash() =>
    r'7c6ac7ac2546644c9ea383e9c96dad41ce721021';

/// 商家分类列表
///
/// Copied from [merchantCategories].
@ProviderFor(merchantCategories)
final merchantCategoriesProvider = AutoDisposeProvider<List<String>>.internal(
  merchantCategories,
  name: r'merchantCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$merchantCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MerchantCategoriesRef = AutoDisposeProviderRef<List<String>>;
String _$merchantsByCategoryHash() =>
    r'b80470dcd18943ac8d0084c45cf40791f9c1838e';

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

/// 按分类获取商家
///
/// Copied from [merchantsByCategory].
@ProviderFor(merchantsByCategory)
const merchantsByCategoryProvider = MerchantsByCategoryFamily();

/// 按分类获取商家
///
/// Copied from [merchantsByCategory].
class MerchantsByCategoryFamily extends Family<List<Umerchant>> {
  /// 按分类获取商家
  ///
  /// Copied from [merchantsByCategory].
  const MerchantsByCategoryFamily();

  /// 按分类获取商家
  ///
  /// Copied from [merchantsByCategory].
  MerchantsByCategoryProvider call(
    String category,
  ) {
    return MerchantsByCategoryProvider(
      category,
    );
  }

  @override
  MerchantsByCategoryProvider getProviderOverride(
    covariant MerchantsByCategoryProvider provider,
  ) {
    return call(
      provider.category,
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
  String? get name => r'merchantsByCategoryProvider';
}

/// 按分类获取商家
///
/// Copied from [merchantsByCategory].
class MerchantsByCategoryProvider extends AutoDisposeProvider<List<Umerchant>> {
  /// 按分类获取商家
  ///
  /// Copied from [merchantsByCategory].
  MerchantsByCategoryProvider(
    String category,
  ) : this._internal(
          (ref) => merchantsByCategory(
            ref as MerchantsByCategoryRef,
            category,
          ),
          from: merchantsByCategoryProvider,
          name: r'merchantsByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$merchantsByCategoryHash,
          dependencies: MerchantsByCategoryFamily._dependencies,
          allTransitiveDependencies:
              MerchantsByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  MerchantsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  Override overrideWith(
    List<Umerchant> Function(MerchantsByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MerchantsByCategoryProvider._internal(
        (ref) => create(ref as MerchantsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<Umerchant>> createElement() {
    return _MerchantsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MerchantsByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MerchantsByCategoryRef on AutoDisposeProviderRef<List<Umerchant>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _MerchantsByCategoryProviderElement
    extends AutoDisposeProviderElement<List<Umerchant>>
    with MerchantsByCategoryRef {
  _MerchantsByCategoryProviderElement(super.provider);

  @override
  String get category => (origin as MerchantsByCategoryProvider).category;
}

String _$merchantControllerHash() =>
    r'1a292191660c0b5c58146f9cf2f6591aa6f80654';

/// Merchant 控制器
///
/// Copied from [MerchantController].
@ProviderFor(MerchantController)
final merchantControllerProvider = AutoDisposeAsyncNotifierProvider<
    MerchantController, MerchantState>.internal(
  MerchantController.new,
  name: r'merchantControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$merchantControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MerchantController = AutoDisposeAsyncNotifier<MerchantState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
