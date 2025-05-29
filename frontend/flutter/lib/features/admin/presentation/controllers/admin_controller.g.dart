// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAdminsUseCaseHash() => r'c4957686a079ff38cc27013476b26e7561a20e65';

/// UseCase Provider
///
/// Copied from [getAdminsUseCase].
@ProviderFor(getAdminsUseCase)
final getAdminsUseCaseProvider =
    AutoDisposeProvider<GetUadminsUseCase>.internal(
  getAdminsUseCase,
  name: r'getAdminsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAdminsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAdminsUseCaseRef = AutoDisposeProviderRef<GetUadminsUseCase>;
String _$adminListHash() => r'dcef29910652a128780ea9325b01e652d3f4dcb4';

/// 管理员列表
///
/// Copied from [adminList].
@ProviderFor(adminList)
final adminListProvider = AutoDisposeProvider<List<Uadmin>>.internal(
  adminList,
  name: r'adminListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$adminListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminListRef = AutoDisposeProviderRef<List<Uadmin>>;
String _$adminIsLoadingHash() => r'd3cbdf7dd408b29f49f0736a922118470eaf791b';

/// 是否正在加载
///
/// Copied from [adminIsLoading].
@ProviderFor(adminIsLoading)
final adminIsLoadingProvider = AutoDisposeProvider<bool>.internal(
  adminIsLoading,
  name: r'adminIsLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminIsLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminIsLoadingRef = AutoDisposeProviderRef<bool>;
String _$adminErrorHash() => r'f08766b78edbae22445f1d42562d908a1ab28346';

/// 错误信息
///
/// Copied from [adminError].
@ProviderFor(adminError)
final adminErrorProvider = AutoDisposeProvider<String?>.internal(
  adminError,
  name: r'adminErrorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$adminErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminErrorRef = AutoDisposeProviderRef<String?>;
String _$selectedAdminHash() => r'7624487787224c15a088ddfa572bbe41b108fbe1';

/// 选中的管理员
///
/// Copied from [selectedAdmin].
@ProviderFor(selectedAdmin)
final selectedAdminProvider = AutoDisposeProvider<Uadmin?>.internal(
  selectedAdmin,
  name: r'selectedAdminProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedAdminHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedAdminRef = AutoDisposeProviderRef<Uadmin?>;
String _$activeAdminsHash() => r'82050cbc27cc137cf5d456fbe4c3fd69421fa046';

/// 活跃管理员列表
///
/// Copied from [activeAdmins].
@ProviderFor(activeAdmins)
final activeAdminsProvider = AutoDisposeProvider<List<Uadmin>>.internal(
  activeAdmins,
  name: r'activeAdminsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeAdminsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveAdminsRef = AutoDisposeProviderRef<List<Uadmin>>;
String _$superAdminsHash() => r'5d989cbeb0155a69d8de33c1e0e7e268e9563314';

/// 超级管理员列表
///
/// Copied from [superAdmins].
@ProviderFor(superAdmins)
final superAdminsProvider = AutoDisposeProvider<List<Uadmin>>.internal(
  superAdmins,
  name: r'superAdminsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$superAdminsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SuperAdminsRef = AutoDisposeProviderRef<List<Uadmin>>;
String _$adminRolesHash() => r'ceb7a31a69b9a121bf135d42e30a7303109cd91d';

/// 管理员角色列表
///
/// Copied from [adminRoles].
@ProviderFor(adminRoles)
final adminRolesProvider = AutoDisposeProvider<List<String>>.internal(
  adminRoles,
  name: r'adminRolesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$adminRolesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminRolesRef = AutoDisposeProviderRef<List<String>>;
String _$adminStatsHash() => r'9ea3899c3f4c57f163a59a66bf25b0a7c9ae9077';

/// 管理员统计信息
///
/// Copied from [adminStats].
@ProviderFor(adminStats)
final adminStatsProvider = AutoDisposeProvider<Map<String, int>>.internal(
  adminStats,
  name: r'adminStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$adminStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminStatsRef = AutoDisposeProviderRef<Map<String, int>>;
String _$systemStatsHash() => r'cbb071ebf0daa68ea8af5b64938894fb81538f92';

/// 系统统计信息
///
/// Copied from [systemStats].
@ProviderFor(systemStats)
final systemStatsProvider = AutoDisposeProvider<Map<String, dynamic>>.internal(
  systemStats,
  name: r'systemStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$systemStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SystemStatsRef = AutoDisposeProviderRef<Map<String, dynamic>>;
String _$adminControllerHash() => r'2afdd79d0aa5c490bf104f40b730725346339004';

/// Admin 控制器
///
/// Copied from [AdminController].
@ProviderFor(AdminController)
final adminControllerProvider =
    AutoDisposeAsyncNotifierProvider<AdminController, AdminState>.internal(
  AdminController.new,
  name: r'adminControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AdminController = AutoDisposeAsyncNotifier<AdminState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
