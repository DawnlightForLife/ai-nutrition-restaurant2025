// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileForAIHash() => r'c3aa599d8313dffb412cbba75a9a9509754b4a9d';

/// 获取AI推荐数据的单独 Provider
///
/// Copied from [profileForAI].
@ProviderFor(profileForAI)
final profileForAIProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>?>.internal(
  profileForAI,
  name: r'profileForAIProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$profileForAIHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileForAIRef = AutoDisposeFutureProviderRef<Map<String, dynamic>?>;
String _$nutritionApiHash() => r'5d30c965a6ddb006ffe73ed38e97652fbb5a8c29';

/// Providers - 依赖注入
///
/// Copied from [nutritionApi].
@ProviderFor(nutritionApi)
final nutritionApiProvider = AutoDisposeProvider<NutritionApi>.internal(
  nutritionApi,
  name: r'nutritionApiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$nutritionApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NutritionApiRef = AutoDisposeProviderRef<NutritionApi>;
String _$authServiceHash() => r'f691c2d6e3b111b8510ebf15bd7f6a448c83e493';

/// See also [authService].
@ProviderFor(authService)
final authServiceProvider = AutoDisposeProvider<AuthLocalDataSource>.internal(
  authService,
  name: r'authServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthServiceRef = AutoDisposeProviderRef<AuthLocalDataSource>;
String _$currentProfileHash() => r'0ef4d5db130011211764303bff73719a687e178a';

/// 便捷访问器
///
/// Copied from [currentProfile].
@ProviderFor(currentProfile)
final currentProfileProvider = AutoDisposeProvider<NutritionProfile?>.internal(
  currentProfile,
  name: r'currentProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentProfileRef = AutoDisposeProviderRef<NutritionProfile?>;
String _$profileCompletionStatsHash() =>
    r'1a86056ff2071311d6f21d0bd1a6b7e0f2c7e33c';

/// See also [profileCompletionStats].
@ProviderFor(profileCompletionStats)
final profileCompletionStatsProvider =
    AutoDisposeProvider<CompletionStats?>.internal(
  profileCompletionStats,
  name: r'profileCompletionStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileCompletionStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileCompletionStatsRef = AutoDisposeProviderRef<CompletionStats?>;
String _$isProfileCompleteHash() => r'd0346854918c19334f8e756c899115171aee850d';

/// See also [isProfileComplete].
@ProviderFor(isProfileComplete)
final isProfileCompleteProvider = AutoDisposeProvider<bool>.internal(
  isProfileComplete,
  name: r'isProfileCompleteProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isProfileCompleteHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsProfileCompleteRef = AutoDisposeProviderRef<bool>;
String _$nutritionProfileControllerHash() =>
    r'3ea416e1c77b7f5734e13ff28f75820e08debedc';

/// 营养档案控制器 - 使用新的 AsyncNotifier 模式
///
/// Copied from [NutritionProfileController].
@ProviderFor(NutritionProfileController)
final nutritionProfileControllerProvider = AutoDisposeAsyncNotifierProvider<
    NutritionProfileController, NutritionProfileState>.internal(
  NutritionProfileController.new,
  name: r'nutritionProfileControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nutritionProfileControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NutritionProfileController
    = AutoDisposeAsyncNotifier<NutritionProfileState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
