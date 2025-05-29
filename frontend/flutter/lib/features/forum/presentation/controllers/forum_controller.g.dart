// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getForumsUseCaseHash() => r'4482dfb092455f4cf3ae41542ba8128ceee63792';

/// UseCase Provider
///
/// Copied from [getForumsUseCase].
@ProviderFor(getForumsUseCase)
final getForumsUseCaseProvider =
    AutoDisposeProvider<GetUforumsUseCase>.internal(
  getForumsUseCase,
  name: r'getForumsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getForumsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetForumsUseCaseRef = AutoDisposeProviderRef<GetUforumsUseCase>;
String _$forumListHash() => r'bdd58245fc56b12f6a3cef05f60a9718dd29e58d';

/// 论坛列表
///
/// Copied from [forumList].
@ProviderFor(forumList)
final forumListProvider = AutoDisposeProvider<List<Uforum>>.internal(
  forumList,
  name: r'forumListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$forumListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ForumListRef = AutoDisposeProviderRef<List<Uforum>>;
String _$forumIsLoadingHash() => r'db978f5ea14d24414469b5505316690f0773380d';

/// 是否正在加载
///
/// Copied from [forumIsLoading].
@ProviderFor(forumIsLoading)
final forumIsLoadingProvider = AutoDisposeProvider<bool>.internal(
  forumIsLoading,
  name: r'forumIsLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$forumIsLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ForumIsLoadingRef = AutoDisposeProviderRef<bool>;
String _$forumErrorHash() => r'9aa5d6d22916eeb5c4fa3771c7e5ad6f843c6c4d';

/// 错误信息
///
/// Copied from [forumError].
@ProviderFor(forumError)
final forumErrorProvider = AutoDisposeProvider<String?>.internal(
  forumError,
  name: r'forumErrorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$forumErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ForumErrorRef = AutoDisposeProviderRef<String?>;
String _$selectedForumHash() => r'5e1322fc2c878a88819da8b4db4b03c2644292f2';

/// 选中的论坛
///
/// Copied from [selectedForum].
@ProviderFor(selectedForum)
final selectedForumProvider = AutoDisposeProvider<Uforum?>.internal(
  selectedForum,
  name: r'selectedForumProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedForumHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedForumRef = AutoDisposeProviderRef<Uforum?>;
String _$forumControllerHash() => r'decaf2c68bd650e6756ec5e305f20a70d428f4fb';

/// Forum 控制器
///
/// Copied from [ForumController].
@ProviderFor(ForumController)
final forumControllerProvider =
    AutoDisposeAsyncNotifierProvider<ForumController, ForumState>.internal(
  ForumController.new,
  name: r'forumControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$forumControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ForumController = AutoDisposeAsyncNotifier<ForumState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
