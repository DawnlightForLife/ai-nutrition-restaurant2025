// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getUserProfileUseCaseHash() =>
    r'a17db1b0f948fdd30ccaeff917569ce61e4d5d9b';

/// UseCase Providers
///
/// Copied from [getUserProfileUseCase].
@ProviderFor(getUserProfileUseCase)
final getUserProfileUseCaseProvider =
    AutoDisposeProvider<GetUserProfileUseCase>.internal(
  getUserProfileUseCase,
  name: r'getUserProfileUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getUserProfileUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetUserProfileUseCaseRef
    = AutoDisposeProviderRef<GetUserProfileUseCase>;
String _$updateUserProfileUseCaseHash() =>
    r'ebbbd0d789c0f307231573259049bf00c9afea46';

/// See also [updateUserProfileUseCase].
@ProviderFor(updateUserProfileUseCase)
final updateUserProfileUseCaseProvider =
    AutoDisposeProvider<UpdateUserProfileUseCase>.internal(
  updateUserProfileUseCase,
  name: r'updateUserProfileUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateUserProfileUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateUserProfileUseCaseRef
    = AutoDisposeProviderRef<UpdateUserProfileUseCase>;
String _$userRepositoryHash() => r'b209960031748fdb1b3acfbc4ed62d287ec27d9b';

/// Repository Provider
///
/// Copied from [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = AutoDisposeProvider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRepositoryRef = AutoDisposeProviderRef<UserRepository>;
String _$currentUserProfileHash() =>
    r'ddfa75324529c205c215bbaef857883d0fd20797';

/// 便捷访问器
///
/// Copied from [currentUserProfile].
@ProviderFor(currentUserProfile)
final currentUserProfileProvider = AutoDisposeProvider<UserProfile?>.internal(
  currentUserProfile,
  name: r'currentUserProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserProfileRef = AutoDisposeProviderRef<UserProfile?>;
String _$isProfileCompleteHash() => r'490eef3c71860a0ebcc79834260d45fecb80ce27';

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
String _$userDisplayNameHash() => r'9ae06b76dc110461a1980938d3badccaf6fb5dc3';

/// See also [userDisplayName].
@ProviderFor(userDisplayName)
final userDisplayNameProvider = AutoDisposeProvider<String>.internal(
  userDisplayName,
  name: r'userDisplayNameProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userDisplayNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserDisplayNameRef = AutoDisposeProviderRef<String>;
String _$userAvatarHash() => r'cf81fca2bba06a81cf3a5888cc54a4eba089a18d';

/// See also [userAvatar].
@ProviderFor(userAvatar)
final userAvatarProvider = AutoDisposeProvider<String?>.internal(
  userAvatar,
  name: r'userAvatarProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userAvatarHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserAvatarRef = AutoDisposeProviderRef<String?>;
String _$userProfileControllerHash() =>
    r'b9831cdb1a0a2d855c073e0973d3eae1ad67f92d';

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

abstract class _$UserProfileController
    extends BuildlessAutoDisposeAsyncNotifier<UserProfile?> {
  late final String userId;

  FutureOr<UserProfile?> build(
    String userId,
  );
}

/// 用户档案控制器 - 使用新的 AsyncNotifier 模式
///
/// Copied from [UserProfileController].
@ProviderFor(UserProfileController)
const userProfileControllerProvider = UserProfileControllerFamily();

/// 用户档案控制器 - 使用新的 AsyncNotifier 模式
///
/// Copied from [UserProfileController].
class UserProfileControllerFamily extends Family<AsyncValue<UserProfile?>> {
  /// 用户档案控制器 - 使用新的 AsyncNotifier 模式
  ///
  /// Copied from [UserProfileController].
  const UserProfileControllerFamily();

  /// 用户档案控制器 - 使用新的 AsyncNotifier 模式
  ///
  /// Copied from [UserProfileController].
  UserProfileControllerProvider call(
    String userId,
  ) {
    return UserProfileControllerProvider(
      userId,
    );
  }

  @override
  UserProfileControllerProvider getProviderOverride(
    covariant UserProfileControllerProvider provider,
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
  String? get name => r'userProfileControllerProvider';
}

/// 用户档案控制器 - 使用新的 AsyncNotifier 模式
///
/// Copied from [UserProfileController].
class UserProfileControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserProfileController,
        UserProfile?> {
  /// 用户档案控制器 - 使用新的 AsyncNotifier 模式
  ///
  /// Copied from [UserProfileController].
  UserProfileControllerProvider(
    String userId,
  ) : this._internal(
          () => UserProfileController()..userId = userId,
          from: userProfileControllerProvider,
          name: r'userProfileControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userProfileControllerHash,
          dependencies: UserProfileControllerFamily._dependencies,
          allTransitiveDependencies:
              UserProfileControllerFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserProfileControllerProvider._internal(
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
  FutureOr<UserProfile?> runNotifierBuild(
    covariant UserProfileController notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(UserProfileController Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserProfileControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<UserProfileController, UserProfile?>
      createElement() {
    return _UserProfileControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileControllerProvider && other.userId == userId;
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
mixin UserProfileControllerRef
    on AutoDisposeAsyncNotifierProviderRef<UserProfile?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserProfileControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserProfileController,
        UserProfile?> with UserProfileControllerRef {
  _UserProfileControllerProviderElement(super.provider);

  @override
  String get userId => (origin as UserProfileControllerProvider).userId;
}

String _$currentUserProfileControllerHash() =>
    r'28308dd49e1418009d300801a459af6db21a8743';

/// 当前用户档案控制器（不需要传入userId）
///
/// Copied from [CurrentUserProfileController].
@ProviderFor(CurrentUserProfileController)
final currentUserProfileControllerProvider = AutoDisposeAsyncNotifierProvider<
    CurrentUserProfileController, UserProfile?>.internal(
  CurrentUserProfileController.new,
  name: r'currentUserProfileControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserProfileControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentUserProfileController = AutoDisposeAsyncNotifier<UserProfile?>;
String _$userSettingsControllerHash() =>
    r'188d06649894c7a702a62ce9a1ce9054cc1d6cd0';

abstract class _$UserSettingsController
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, dynamic>> {
  late final String userId;

  FutureOr<Map<String, dynamic>> build(
    String userId,
  );
}

/// 用户设置控制器
///
/// Copied from [UserSettingsController].
@ProviderFor(UserSettingsController)
const userSettingsControllerProvider = UserSettingsControllerFamily();

/// 用户设置控制器
///
/// Copied from [UserSettingsController].
class UserSettingsControllerFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// 用户设置控制器
  ///
  /// Copied from [UserSettingsController].
  const UserSettingsControllerFamily();

  /// 用户设置控制器
  ///
  /// Copied from [UserSettingsController].
  UserSettingsControllerProvider call(
    String userId,
  ) {
    return UserSettingsControllerProvider(
      userId,
    );
  }

  @override
  UserSettingsControllerProvider getProviderOverride(
    covariant UserSettingsControllerProvider provider,
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
  String? get name => r'userSettingsControllerProvider';
}

/// 用户设置控制器
///
/// Copied from [UserSettingsController].
class UserSettingsControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserSettingsController,
        Map<String, dynamic>> {
  /// 用户设置控制器
  ///
  /// Copied from [UserSettingsController].
  UserSettingsControllerProvider(
    String userId,
  ) : this._internal(
          () => UserSettingsController()..userId = userId,
          from: userSettingsControllerProvider,
          name: r'userSettingsControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userSettingsControllerHash,
          dependencies: UserSettingsControllerFamily._dependencies,
          allTransitiveDependencies:
              UserSettingsControllerFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserSettingsControllerProvider._internal(
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
  FutureOr<Map<String, dynamic>> runNotifierBuild(
    covariant UserSettingsController notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(UserSettingsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserSettingsControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<UserSettingsController,
      Map<String, dynamic>> createElement() {
    return _UserSettingsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserSettingsControllerProvider && other.userId == userId;
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
mixin UserSettingsControllerRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserSettingsControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserSettingsController,
        Map<String, dynamic>> with UserSettingsControllerRef {
  _UserSettingsControllerProviderElement(super.provider);

  @override
  String get userId => (origin as UserSettingsControllerProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
