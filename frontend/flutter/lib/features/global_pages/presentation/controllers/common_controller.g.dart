// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getCommonsUseCaseHash() => r'55e0e27f63f4665d9599d8689061fc81b0efb596';

/// UseCase Provider
///
/// Copied from [getCommonsUseCase].
@ProviderFor(getCommonsUseCase)
final getCommonsUseCaseProvider =
    AutoDisposeProvider<GetUcommonsUseCase>.internal(
  getCommonsUseCase,
  name: r'getCommonsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCommonsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCommonsUseCaseRef = AutoDisposeProviderRef<GetUcommonsUseCase>;
String _$commonListHash() => r'924decef47fe0148352b992b3b1aa7db4ed3dea6';

/// 通用数据列表
///
/// Copied from [commonList].
@ProviderFor(commonList)
final commonListProvider = AutoDisposeProvider<List<Ucommon>>.internal(
  commonList,
  name: r'commonListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$commonListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CommonListRef = AutoDisposeProviderRef<List<Ucommon>>;
String _$commonIsLoadingHash() => r'828fabbb26efcc4552ccf613885cd97d29c1b7f8';

/// 是否正在加载
///
/// Copied from [commonIsLoading].
@ProviderFor(commonIsLoading)
final commonIsLoadingProvider = AutoDisposeProvider<bool>.internal(
  commonIsLoading,
  name: r'commonIsLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$commonIsLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CommonIsLoadingRef = AutoDisposeProviderRef<bool>;
String _$commonErrorHash() => r'28f839418f08871f6575e75d033e5821e1424c53';

/// 错误信息
///
/// Copied from [commonError].
@ProviderFor(commonError)
final commonErrorProvider = AutoDisposeProvider<String?>.internal(
  commonError,
  name: r'commonErrorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$commonErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CommonErrorRef = AutoDisposeProviderRef<String?>;
String _$appConfigHash() => r'43c17ad24d6da4b47c976d751dc5a8dadb396215';

/// 应用配置
///
/// Copied from [appConfig].
@ProviderFor(appConfig)
final appConfigProvider = AutoDisposeProvider<Map<String, dynamic>>.internal(
  appConfig,
  name: r'appConfigProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppConfigRef = AutoDisposeProviderRef<Map<String, dynamic>>;
String _$currentLocaleHash() => r'52d22f4737b1cabccdff8adaa7b0cb405ec74e4e';

/// 当前语言
///
/// Copied from [currentLocale].
@ProviderFor(currentLocale)
final currentLocaleProvider = AutoDisposeProvider<String>.internal(
  currentLocale,
  name: r'currentLocaleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentLocaleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentLocaleRef = AutoDisposeProviderRef<String>;
String _$isDarkModeHash() => r'95110a36ac006e43e0a1f820da031617257de31c';

/// 是否深色模式
///
/// Copied from [isDarkMode].
@ProviderFor(isDarkMode)
final isDarkModeProvider = AutoDisposeProvider<bool>.internal(
  isDarkMode,
  name: r'isDarkModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isDarkModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsDarkModeRef = AutoDisposeProviderRef<bool>;
String _$translateHash() => r'6000f8cfbf1266fabc7acea29fa1bee3862e7b34';

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

/// 翻译文本
///
/// Copied from [translate].
@ProviderFor(translate)
const translateProvider = TranslateFamily();

/// 翻译文本
///
/// Copied from [translate].
class TranslateFamily extends Family<String> {
  /// 翻译文本
  ///
  /// Copied from [translate].
  const TranslateFamily();

  /// 翻译文本
  ///
  /// Copied from [translate].
  TranslateProvider call(
    String key,
  ) {
    return TranslateProvider(
      key,
    );
  }

  @override
  TranslateProvider getProviderOverride(
    covariant TranslateProvider provider,
  ) {
    return call(
      provider.key,
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
  String? get name => r'translateProvider';
}

/// 翻译文本
///
/// Copied from [translate].
class TranslateProvider extends AutoDisposeProvider<String> {
  /// 翻译文本
  ///
  /// Copied from [translate].
  TranslateProvider(
    String key,
  ) : this._internal(
          (ref) => translate(
            ref as TranslateRef,
            key,
          ),
          from: translateProvider,
          name: r'translateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$translateHash,
          dependencies: TranslateFamily._dependencies,
          allTransitiveDependencies: TranslateFamily._allTransitiveDependencies,
          key: key,
        );

  TranslateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final String key;

  @override
  Override overrideWith(
    String Function(TranslateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TranslateProvider._internal(
        (ref) => create(ref as TranslateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _TranslateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TranslateProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TranslateRef on AutoDisposeProviderRef<String> {
  /// The parameter `key` of this provider.
  String get key;
}

class _TranslateProviderElement extends AutoDisposeProviderElement<String>
    with TranslateRef {
  _TranslateProviderElement(super.provider);

  @override
  String get key => (origin as TranslateProvider).key;
}

String _$userPreferenceHash() => r'98a3c26b889978f0f0f12c7a176c77a87926685f';

/// 用户偏好设置
///
/// Copied from [userPreference].
@ProviderFor(userPreference)
const userPreferenceProvider = UserPreferenceFamily();

/// 用户偏好设置
///
/// Copied from [userPreference].
class UserPreferenceFamily extends Family<T?> {
  /// 用户偏好设置
  ///
  /// Copied from [userPreference].
  const UserPreferenceFamily();

  /// 用户偏好设置
  ///
  /// Copied from [userPreference].
  UserPreferenceProvider call(
    String key,
  ) {
    return UserPreferenceProvider(
      key,
    );
  }

  @override
  UserPreferenceProvider getProviderOverride(
    covariant UserPreferenceProvider provider,
  ) {
    return call(
      provider.key,
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
  String? get name => r'userPreferenceProvider';
}

/// 用户偏好设置
///
/// Copied from [userPreference].
class UserPreferenceProvider extends AutoDisposeProvider<T?> {
  /// 用户偏好设置
  ///
  /// Copied from [userPreference].
  UserPreferenceProvider(
    String key,
  ) : this._internal(
          (ref) => userPreference(
            ref as UserPreferenceRef,
            key,
          ),
          from: userPreferenceProvider,
          name: r'userPreferenceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userPreferenceHash,
          dependencies: UserPreferenceFamily._dependencies,
          allTransitiveDependencies:
              UserPreferenceFamily._allTransitiveDependencies,
          key: key,
        );

  UserPreferenceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final String key;

  @override
  Override overrideWith(
    T? Function(UserPreferenceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserPreferenceProvider._internal(
        (ref) => create(ref as UserPreferenceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<T?> createElement() {
    return _UserPreferenceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserPreferenceProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserPreferenceRef on AutoDisposeProviderRef<T?> {
  /// The parameter `key` of this provider.
  String get key;
}

class _UserPreferenceProviderElement extends AutoDisposeProviderElement<T?>
    with UserPreferenceRef {
  _UserPreferenceProviderElement(super.provider);

  @override
  String get key => (origin as UserPreferenceProvider).key;
}

String _$featureEnabledHash() => r'21916bb7e1b652c88a710546d10190c933e7358d';

/// 功能开关
///
/// Copied from [featureEnabled].
@ProviderFor(featureEnabled)
const featureEnabledProvider = FeatureEnabledFamily();

/// 功能开关
///
/// Copied from [featureEnabled].
class FeatureEnabledFamily extends Family<bool> {
  /// 功能开关
  ///
  /// Copied from [featureEnabled].
  const FeatureEnabledFamily();

  /// 功能开关
  ///
  /// Copied from [featureEnabled].
  FeatureEnabledProvider call(
    String feature,
  ) {
    return FeatureEnabledProvider(
      feature,
    );
  }

  @override
  FeatureEnabledProvider getProviderOverride(
    covariant FeatureEnabledProvider provider,
  ) {
    return call(
      provider.feature,
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
  String? get name => r'featureEnabledProvider';
}

/// 功能开关
///
/// Copied from [featureEnabled].
class FeatureEnabledProvider extends AutoDisposeProvider<bool> {
  /// 功能开关
  ///
  /// Copied from [featureEnabled].
  FeatureEnabledProvider(
    String feature,
  ) : this._internal(
          (ref) => featureEnabled(
            ref as FeatureEnabledRef,
            feature,
          ),
          from: featureEnabledProvider,
          name: r'featureEnabledProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$featureEnabledHash,
          dependencies: FeatureEnabledFamily._dependencies,
          allTransitiveDependencies:
              FeatureEnabledFamily._allTransitiveDependencies,
          feature: feature,
        );

  FeatureEnabledProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.feature,
  }) : super.internal();

  final String feature;

  @override
  Override overrideWith(
    bool Function(FeatureEnabledRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FeatureEnabledProvider._internal(
        (ref) => create(ref as FeatureEnabledRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        feature: feature,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _FeatureEnabledProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeatureEnabledProvider && other.feature == feature;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, feature.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FeatureEnabledRef on AutoDisposeProviderRef<bool> {
  /// The parameter `feature` of this provider.
  String get feature;
}

class _FeatureEnabledProviderElement extends AutoDisposeProviderElement<bool>
    with FeatureEnabledRef {
  _FeatureEnabledProviderElement(super.provider);

  @override
  String get feature => (origin as FeatureEnabledProvider).feature;
}

String _$commonControllerHash() => r'bee9d71c6f94a56a5caf14d4f1be73aa58b82845';

/// Common 控制器
///
/// Copied from [CommonController].
@ProviderFor(CommonController)
final commonControllerProvider =
    AutoDisposeAsyncNotifierProvider<CommonController, CommonState>.internal(
  CommonController.new,
  name: r'commonControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$commonControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CommonController = AutoDisposeAsyncNotifier<CommonState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
