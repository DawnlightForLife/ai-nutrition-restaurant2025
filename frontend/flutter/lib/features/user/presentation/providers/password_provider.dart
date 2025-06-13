import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../shared/utils/toast_util.dart';
import '../../data/datasources/user_remote_datasource.dart';

/// 用户远程数据源Provider
final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return UserRemoteDataSource(dio);
});

/// 密码状态Provider
final hasPasswordProvider = FutureProvider<bool>((ref) async {
  final dataSource = ref.watch(userRemoteDataSourceProvider);
  return await dataSource.checkHasPassword();
});

/// 密码管理Provider
final passwordManagerProvider = StateNotifierProvider<PasswordManagerNotifier, AsyncValue<void>>((ref) {
  final dataSource = ref.watch(userRemoteDataSourceProvider);
  return PasswordManagerNotifier(dataSource);
});

/// 密码管理状态管理器
class PasswordManagerNotifier extends StateNotifier<AsyncValue<void>> {
  final UserRemoteDataSource _dataSource;

  PasswordManagerNotifier(this._dataSource) : super(const AsyncValue.data(null));

  /// 设置密码（新用户）
  Future<bool> setPassword(String newPassword) async {
    state = const AsyncValue.loading();
    try {
      await _dataSource.setPassword(newPassword);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  /// 修改密码（已有密码的用户）
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    state = const AsyncValue.loading();
    try {
      await _dataSource.changePassword(oldPassword, newPassword);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }
}