import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../domain/repositories/user_repository.dart';

part 'user_profile_controller.freezed.dart';
part 'user_profile_controller.g.dart';

/// 用户档案状态
@freezed
class UserProfileState with _$UserProfileState {
  const factory UserProfileState({
    UserProfile? profile,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _UserProfileState;
}

/// 用户档案控制器 - 使用新的 AsyncNotifier 模式
@riverpod
class UserProfileController extends _$UserProfileController {
  @override
  Future<UserProfile?> build(String userId) async {
    final getUserProfile = ref.read(getUserProfileUseCaseProvider);
    final result = await getUserProfile(GetUserProfileParams(userId: userId));
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (profile) => profile,
    );
  }

  /// 刷新用户档案
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  /// 更新用户档案
  Future<UserProfile?> updateProfile(UserProfile profile) async {
    state = const AsyncValue.loading();
    
    try {
      final updateUserProfile = ref.read(updateUserProfileUseCaseProvider);
      final result = await updateUserProfile(UpdateUserProfileParams(profile: profile));
      
      final updatedProfile = result.fold(
        (failure) => throw Exception(failure.message),
        (profile) => profile,
      );
      
      state = AsyncValue.data(updatedProfile);
      return updatedProfile;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return null;
    }
  }

  /// 更新昵称
  Future<UserProfile?> updateNickname(String nickname) async {
    final currentProfile = state.valueOrNull;
    if (currentProfile == null) return null;
    
    final updatedProfile = currentProfile.copyWith(nickname: nickname);
    return updateProfile(updatedProfile);
  }

  /// 更新头像
  Future<UserProfile?> updateAvatar(String avatarUrl) async {
    final currentProfile = state.valueOrNull;
    if (currentProfile == null) return null;
    
    final updatedProfile = currentProfile.copyWith(avatar: avatarUrl);
    return updateProfile(updatedProfile);
  }

  /// 更新邮箱
  Future<UserProfile?> updateEmail(String email) async {
    final currentProfile = state.valueOrNull;
    if (currentProfile == null) return null;
    
    final updatedProfile = currentProfile.copyWith(email: email);
    return updateProfile(updatedProfile);
  }

  /// 更新电话
  Future<UserProfile?> updatePhone(String phone) async {
    final currentProfile = state.valueOrNull;
    if (currentProfile == null) return null;
    
    final updatedProfile = currentProfile.copyWith(phone: phone);
    return updateProfile(updatedProfile);
  }
}

/// 当前用户档案控制器（不需要传入userId）
@riverpod
class CurrentUserProfileController extends _$CurrentUserProfileController {
  @override
  Future<UserProfile?> build() async {
    // 从认证服务获取当前用户ID
    final currentUserId = await _getCurrentUserId();
    if (currentUserId == null) return null;
    
    return ref.watch(userProfileControllerProvider(currentUserId).future);
  }

  /// 获取当前用户ID（需要实现）
  Future<String?> _getCurrentUserId() async {
    // 这里应该从认证服务获取当前用户ID
    // 可以从 SharedPreferences、Secure Storage 或其他地方获取
    return null; // 临时返回null
  }

  /// 刷新当前用户档案
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

/// 用户设置控制器
@riverpod
class UserSettingsController extends _$UserSettingsController {
  @override
  Future<Map<String, dynamic>> build(String userId) async {
    // 获取用户设置
    final profile = await ref.watch(userProfileControllerProvider(userId).future);
    return profile?.settings ?? {};
  }

  /// 更新设置
  Future<void> updateSetting(String key, dynamic value) async {
    final currentSettings = state.valueOrNull ?? {};
    final updatedSettings = {...currentSettings, key: value};
    
    // 更新用户档案中的设置
    final profile = await ref.read(userProfileControllerProvider(userId).future);
    if (profile != null) {
      final updatedProfile = profile.copyWith(settings: updatedSettings);
      await ref.read(userProfileControllerProvider(userId).notifier).updateProfile(updatedProfile);
    }
    
    state = AsyncValue.data(updatedSettings);
  }

  /// 获取设置值
  T? getSetting<T>(String key) {
    final settings = state.valueOrNull;
    return settings?[key] as T?;
  }
}

/// UseCase Providers
@riverpod
GetUserProfileUseCase getUserProfileUseCase(GetUserProfileUseCaseRef ref) {
  final repository = ref.read(userRepositoryProvider);
  return GetUserProfileUseCase(repository);
}

@riverpod
UpdateUserProfileUseCase updateUserProfileUseCase(UpdateUserProfileUseCaseRef ref) {
  final repository = ref.read(userRepositoryProvider);
  return UpdateUserProfileUseCase(repository);
}

/// Repository Provider
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
}

/// 便捷访问器
@riverpod
UserProfile? currentUserProfile(CurrentUserProfileRef ref) {
  return ref.watch(currentUserProfileControllerProvider).valueOrNull;
}

@riverpod
bool isProfileComplete(IsProfileCompleteRef ref) {
  final profile = ref.watch(currentUserProfileProvider);
  if (profile == null) return false;
  
  // 检查关键字段是否完整
  return profile.nickname.isNotEmpty &&
         profile.email.isNotEmpty &&
         profile.phone.isNotEmpty;
}

@riverpod
String userDisplayName(UserDisplayNameRef ref) {
  final profile = ref.watch(currentUserProfileProvider);
  return profile?.nickname ?? profile?.email ?? '未知用户';
}

@riverpod
String? userAvatar(UserAvatarRef ref) {
  final profile = ref.watch(currentUserProfileProvider);
  return profile?.avatar;
}