import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/repositories/user_repository_impl.dart';

part 'user_profile_provider.freezed.dart';

/// 用户档案状态
@freezed
class UserProfileState with _$UserProfileState {
  const factory UserProfileState.initial() = _Initial;
  const factory UserProfileState.loading() = _Loading;
  const factory UserProfileState.loaded(UserProfile profile) = _Loaded;
  const factory UserProfileState.error(String message) = _Error;
}

/// 用户档案Provider
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfileState>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  final getUserProfile = GetUserProfileUseCase(repository);
  final updateUserProfile = UpdateUserProfileUseCase(repository);
  
  return UserProfileNotifier(
    getUserProfile: getUserProfile,
    updateUserProfile: updateUserProfile,
  );
});

/// 用户档案Notifier
class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final GetUserProfileUseCase _getUserProfile;
  final UpdateUserProfileUseCase _updateUserProfile;

  UserProfileNotifier({
    required GetUserProfileUseCase getUserProfile,
    required UpdateUserProfileUseCase updateUserProfile,
  })  : _getUserProfile = getUserProfile,
        _updateUserProfile = updateUserProfile,
        super(const UserProfileState.initial());

  /// 加载用户档案
  Future<void> loadUserProfile(String userId) async {
    state = const UserProfileState.loading();
    
    final result = await _getUserProfile(GetUserProfileParams(userId: userId));
    
    state = result.fold(
      (failure) => UserProfileState.error(failure.message),
      (profile) => UserProfileState.loaded(profile),
    );
  }

  /// 更新用户档案
  Future<void> updateUserProfile(UserProfile profile) async {
    state = const UserProfileState.loading();
    
    final result = await _updateUserProfile(UpdateUserProfileParams(profile: profile));
    
    state = result.fold(
      (failure) => UserProfileState.error(failure.message),
      (profile) => UserProfileState.loaded(profile),
    );
  }

  /// 更新昵称
  Future<void> updateNickname(String nickname) async {
    state.whenOrNull(
      loaded: (profile) async {
        final updatedProfile = profile.copyWith(nickname: nickname);
        await updateUserProfile(updatedProfile);
      },
    );
  }

  /// 更新头像
  Future<void> updateAvatar(String avatarUrl) async {
    state.whenOrNull(
      loaded: (profile) async {
        final updatedProfile = profile.copyWith(avatar: avatarUrl);
        await updateUserProfile(updatedProfile);
      },
    );
  }
}

/// Repository Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  // 这里应该从DI容器中获取实际的repository实现
  throw UnimplementedError('请在应用启动时配置UserRepository');
});