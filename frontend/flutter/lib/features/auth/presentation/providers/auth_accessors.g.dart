// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_accessors.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isAuthenticatedHash() => r'e3c516ec0489163bc4ff2d0c0debb33df842b56a';

/// 认证便捷访问器
///
/// 提供简化的认证状态访问方式
/// 是否已认证
///
/// Copied from [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = AutoDisposeProvider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAuthenticatedRef = AutoDisposeProviderRef<bool>;
String _$authIsLoadingHash() => r'e2f4bb4da60d7bb16de932d94a776c045cd52850';

/// 是否正在加载
///
/// Copied from [authIsLoading].
@ProviderFor(authIsLoading)
final authIsLoadingProvider = AutoDisposeProvider<bool>.internal(
  authIsLoading,
  name: r'authIsLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authIsLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthIsLoadingRef = AutoDisposeProviderRef<bool>;
String _$currentUserHash() => r'c6d9c9dbf76dde5dc8d38267570e88bd86c2bf92';

/// 当前用户
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeProvider<UserModel?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeProviderRef<UserModel?>;
String _$authTokenHash() => r'1d026711f30a9e99ff14d0a5be6619d68bd7d525';

/// 认证Token
///
/// Copied from [authToken].
@ProviderFor(authToken)
final authTokenProvider = AutoDisposeProvider<String?>.internal(
  authToken,
  name: r'authTokenProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authTokenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthTokenRef = AutoDisposeProviderRef<String?>;
String _$authErrorHash() => r'daf281a193569a57ebb678ce9043f39575804eb8';

/// 错误信息
///
/// Copied from [authError].
@ProviderFor(authError)
final authErrorProvider = AutoDisposeProvider<String?>.internal(
  authError,
  name: r'authErrorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthErrorRef = AutoDisposeProviderRef<String?>;
String _$userRoleHash() => r'6a09ee78ea3d7b8357a928dc4ce569cc75453c8e';

/// 用户角色
///
/// Copied from [userRole].
@ProviderFor(userRole)
final userRoleProvider = AutoDisposeProvider<String?>.internal(
  userRole,
  name: r'userRoleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userRoleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRoleRef = AutoDisposeProviderRef<String?>;
String _$isAdminHash() => r'7cb997d1d43cf41d4b4abeef9c00159b9f47b857';

/// 是否是管理员
///
/// Copied from [isAdmin].
@ProviderFor(isAdmin)
final isAdminProvider = AutoDisposeProvider<bool>.internal(
  isAdmin,
  name: r'isAdminProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isAdminHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAdminRef = AutoDisposeProviderRef<bool>;
String _$isNutritionistHash() => r'c2f6e7916566bda4375f0adf77312f04f171bbc4';

/// 是否是营养师
///
/// Copied from [isNutritionist].
@ProviderFor(isNutritionist)
final isNutritionistProvider = AutoDisposeProvider<bool>.internal(
  isNutritionist,
  name: r'isNutritionistProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isNutritionistHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsNutritionistRef = AutoDisposeProviderRef<bool>;
String _$isMerchantHash() => r'a2d6efcfaec98007a06c2e0171059def98f443c6';

/// 是否是商家
///
/// Copied from [isMerchant].
@ProviderFor(isMerchant)
final isMerchantProvider = AutoDisposeProvider<bool>.internal(
  isMerchant,
  name: r'isMerchantProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isMerchantHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsMerchantRef = AutoDisposeProviderRef<bool>;
String _$hasPermissionHash() => r'128c9ca7bcdadc4b738e5ca77acaa616d9cfeacb';

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

/// 检查权限
///
/// Copied from [hasPermission].
@ProviderFor(hasPermission)
const hasPermissionProvider = HasPermissionFamily();

/// 检查权限
///
/// Copied from [hasPermission].
class HasPermissionFamily extends Family<bool> {
  /// 检查权限
  ///
  /// Copied from [hasPermission].
  const HasPermissionFamily();

  /// 检查权限
  ///
  /// Copied from [hasPermission].
  HasPermissionProvider call(
    String permission,
  ) {
    return HasPermissionProvider(
      permission,
    );
  }

  @override
  HasPermissionProvider getProviderOverride(
    covariant HasPermissionProvider provider,
  ) {
    return call(
      provider.permission,
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
  String? get name => r'hasPermissionProvider';
}

/// 检查权限
///
/// Copied from [hasPermission].
class HasPermissionProvider extends AutoDisposeProvider<bool> {
  /// 检查权限
  ///
  /// Copied from [hasPermission].
  HasPermissionProvider(
    String permission,
  ) : this._internal(
          (ref) => hasPermission(
            ref as HasPermissionRef,
            permission,
          ),
          from: hasPermissionProvider,
          name: r'hasPermissionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hasPermissionHash,
          dependencies: HasPermissionFamily._dependencies,
          allTransitiveDependencies:
              HasPermissionFamily._allTransitiveDependencies,
          permission: permission,
        );

  HasPermissionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.permission,
  }) : super.internal();

  final String permission;

  @override
  Override overrideWith(
    bool Function(HasPermissionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasPermissionProvider._internal(
        (ref) => create(ref as HasPermissionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        permission: permission,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _HasPermissionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasPermissionProvider && other.permission == permission;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, permission.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HasPermissionRef on AutoDisposeProviderRef<bool> {
  /// The parameter `permission` of this provider.
  String get permission;
}

class _HasPermissionProviderElement extends AutoDisposeProviderElement<bool>
    with HasPermissionRef {
  _HasPermissionProviderElement(super.provider);

  @override
  String get permission => (origin as HasPermissionProvider).permission;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
