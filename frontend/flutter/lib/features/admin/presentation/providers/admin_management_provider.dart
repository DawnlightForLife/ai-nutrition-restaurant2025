import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/admin_service.dart';

/// 管理员管理状态
class AdminManagementState {
  final List<Map<String, dynamic>> admins;
  final bool isLoading;
  final String? error;
  
  const AdminManagementState({
    this.admins = const [],
    this.isLoading = false,
    this.error,
  });
  
  AdminManagementState copyWith({
    List<Map<String, dynamic>>? admins,
    bool? isLoading,
    String? error,
  }) {
    return AdminManagementState(
      admins: admins ?? this.admins,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 管理员管理Provider
final adminManagementProvider = StateNotifierProvider<AdminManagementNotifier, AdminManagementState>((ref) {
  return AdminManagementNotifier(ref);
});

class AdminManagementNotifier extends StateNotifier<AdminManagementState> {
  final Ref _ref;
  
  AdminManagementNotifier(this._ref) : super(const AdminManagementState());
  
  /// 加载管理员列表
  Future<void> loadAdminList() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final adminService = _ref.read(adminServiceProvider);
      final admins = await adminService.getAdminList();
      
      state = state.copyWith(
        admins: admins,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// 添加管理员
  Future<void> addAdmin({
    required String phone,
    required String nickname,
    required String role,
  }) async {
    try {
      final adminService = _ref.read(adminServiceProvider);
      await adminService.createAdmin(
        phone: phone,
        nickname: nickname,
        role: role,
      );
      
      // 重新加载列表
      await loadAdminList();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
  
  /// 更新管理员
  Future<void> updateAdmin({
    required String adminId,
    required String nickname,
    required String role,
  }) async {
    try {
      final adminService = _ref.read(adminServiceProvider);
      await adminService.updateAdmin(
        adminId: adminId,
        nickname: nickname,
        role: role,
      );
      
      // 重新加载列表
      await loadAdminList();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
  
  /// 删除管理员
  Future<void> deleteAdmin(String adminId) async {
    try {
      final adminService = _ref.read(adminServiceProvider);
      await adminService.deleteAdmin(adminId);
      
      // 重新加载列表
      await loadAdminList();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}