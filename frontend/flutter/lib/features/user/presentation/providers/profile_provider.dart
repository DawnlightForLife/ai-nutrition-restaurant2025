import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/user_remote_datasource.dart';
import 'password_provider.dart';

/// 个人资料更新数据类
class ProfileUpdate {
  final String? nickname;
  final String? bio;
  final File? avatarFile;

  ProfileUpdate({
    this.nickname,
    this.bio,
    this.avatarFile,
  });
}

/// 个人资料管理Provider
final profileManagerProvider = StateNotifierProvider<ProfileManagerNotifier, AsyncValue<void>>((ref) {
  final dataSource = ref.watch(userRemoteDataSourceProvider);
  return ProfileManagerNotifier(dataSource);
});

/// 个人资料管理状态管理器
class ProfileManagerNotifier extends StateNotifier<AsyncValue<void>> {
  final UserRemoteDataSource _dataSource;

  ProfileManagerNotifier(this._dataSource) : super(const AsyncValue.data(null));

  /// 更新个人资料
  Future<bool> updateProfile(ProfileUpdate update) async {
    state = const AsyncValue.loading();
    try {
      await _dataSource.updateProfile(update);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }
}