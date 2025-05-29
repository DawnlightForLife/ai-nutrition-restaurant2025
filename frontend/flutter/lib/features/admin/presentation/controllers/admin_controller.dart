import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/admin.dart';
import '../../domain/usecases/get_admins_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'admin_controller.freezed.dart';
part 'admin_controller.g.dart';

/// Admin 状态类
@freezed
class AdminState with _$AdminState {
  const factory AdminState({
    @Default([]) List<Uadmin> admins,
    @Default(false) bool isLoading,
    String? error,
    Uadmin? selectedAdmin,
    @Default({}) Map<String, List<Uadmin>> adminsByRole,
    @Default({}) Map<String, dynamic> systemStats,
  }) = _AdminState;

  const AdminState._();

  /// 是否处于初始状态
  bool get isInitial => admins.isEmpty && !isLoading && error == null;

  /// 是否已加载数据
  bool get hasData => admins.isNotEmpty;

  /// 获取所有角色
  List<String> get roles => adminsByRole.keys.toList();

  /// 获取活跃管理员
  List<Uadmin> get activeAdmins =>
      admins.where((admin) => admin.isActive ?? true).toList();

  /// 获取超级管理员
  List<Uadmin> get superAdmins =>
      admins.where((admin) => admin.role == 'super_admin').toList();
}

/// Admin 控制器
@riverpod
class AdminController extends _$AdminController {
  late final GetUadminsUseCase _getAdminsUseCase;

  @override
  FutureOr<AdminState> build() {
    _getAdminsUseCase = ref.watch(getAdminsUseCaseProvider);
    return const AdminState();
  }

  /// 加载管理员列表
  Future<void> loadAdmins() async {
    state = const AsyncValue.loading();

    final result = await _getAdminsUseCase(NoParams());

    state = result.fold(
      (failure) => AsyncValue.data(
        AdminState(error: failure.message),
      ),
      (admins) {
        final adminsByRole = _groupByRole(admins);
        return AsyncValue.data(
          AdminState(
            admins: admins,
            adminsByRole: adminsByRole,
          ),
        );
      },
    );
  }

  /// 按角色分组管理员
  Map<String, List<Uadmin>> _groupByRole(List<Uadmin> admins) {
    final grouped = <String, List<Uadmin>>{};
    for (final admin in admins) {
      final role = admin.role ?? 'admin';
      grouped.putIfAbsent(role, () => []).add(admin);
    }
    return grouped;
  }

  /// 刷新管理员列表
  Future<void> refresh() async {
    await loadAdmins();
  }

  /// 根据ID获取管理员
  Uadmin? getAdminById(String id) {
    return state.valueOrNull?.admins.firstWhere(
      (admin) => admin.id == id,
      orElse: () => throw Exception('Admin not found'),
    );
  }

  /// 搜索管理员
  List<Uadmin> searchAdmins(String query) {
    final admins = state.valueOrNull?.admins ?? [];
    if (query.isEmpty) return admins;

    return admins.where((admin) {
      final nameMatch = admin.name.toLowerCase().contains(query.toLowerCase());
      final emailMatch = admin.email?.toLowerCase().contains(query.toLowerCase()) ?? false;
      final phoneMatch = admin.phone?.contains(query) ?? false;
      return nameMatch || emailMatch || phoneMatch;
    }).toList();
  }

  /// 按角色筛选管理员
  List<Uadmin> filterByRole(String role) {
    return state.valueOrNull?.adminsByRole[role] ?? [];
  }

  /// 按状态筛选管理员
  List<Uadmin> filterByStatus(bool isActive) {
    final admins = state.valueOrNull?.admins ?? [];
    return admins.where((admin) => (admin.isActive ?? true) == isActive).toList();
  }

  /// 按权限筛选管理员
  List<Uadmin> filterByPermission(String permission) {
    final admins = state.valueOrNull?.admins ?? [];
    return admins.where((admin) {
      return admin.permissions?.contains(permission) ?? false;
    }).toList();
  }

  /// 获取管理员统计信息
  Map<String, int> getAdminStats() {
    final admins = state.valueOrNull?.admins ?? [];
    return {
      'total': admins.length,
      'active': admins.where((a) => a.isActive ?? true).length,
      'inactive': admins.where((a) => !(a.isActive ?? true)).length,
      'super_admin': admins.where((a) => a.role == 'super_admin').length,
      'admin': admins.where((a) => a.role == 'admin').length,
      'moderator': admins.where((a) => a.role == 'moderator').length,
    };
  }

  /// 更新系统统计信息
  void updateSystemStats(Map<String, dynamic> stats) {
    state = state.whenData((data) => data.copyWith(systemStats: stats));
  }

  /// 选择管理员
  void selectAdmin(Uadmin? admin) {
    state = state.whenData((data) => data.copyWith(selectedAdmin: admin));
  }

  /// 清除选中的管理员
  void clearSelection() {
    selectAdmin(null);
  }

  /// 清除错误
  void clearError() {
    state = state.whenData((data) => data.copyWith(error: null));
  }

  /// 检查权限
  bool hasPermission(String adminId, String permission) {
    final admin = getAdminById(adminId);
    if (admin == null) return false;
    
    // 超级管理员拥有所有权限
    if (admin.role == 'super_admin') return true;
    
    return admin.permissions?.contains(permission) ?? false;
  }

  /// 是否可以编辑目标管理员
  bool canEdit(String currentAdminId, String targetAdminId) {
    final currentAdmin = getAdminById(currentAdminId);
    final targetAdmin = getAdminById(targetAdminId);
    
    if (currentAdmin == null || targetAdmin == null) return false;
    
    // 超级管理员可以编辑所有人
    if (currentAdmin.role == 'super_admin') return true;
    
    // 不能编辑超级管理员
    if (targetAdmin.role == 'super_admin') return false;
    
    // 检查是否有编辑权限
    return hasPermission(currentAdminId, 'admin.edit');
  }
}

/// UseCase Provider
@riverpod
GetUadminsUseCase getAdminsUseCase(GetAdminsUseCaseRef ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return GetUadminsUseCase(repository);
}

/// Repository Provider (需要在DI中配置)
final adminRepositoryProvider = Provider<UadminRepository>((ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
});

// ===== 便捷访问器 =====

/// 管理员列表
@riverpod
List<Uadmin> adminList(AdminListRef ref) {
  return ref.watch(adminControllerProvider).valueOrNull?.admins ?? [];
}

/// 是否正在加载
@riverpod
bool adminIsLoading(AdminIsLoadingRef ref) {
  return ref.watch(adminControllerProvider).isLoading;
}

/// 错误信息
@riverpod
String? adminError(AdminErrorRef ref) {
  return ref.watch(adminControllerProvider).valueOrNull?.error;
}

/// 选中的管理员
@riverpod
Uadmin? selectedAdmin(SelectedAdminRef ref) {
  return ref.watch(adminControllerProvider).valueOrNull?.selectedAdmin;
}

/// 活跃管理员列表
@riverpod
List<Uadmin> activeAdmins(ActiveAdminsRef ref) {
  return ref.watch(adminControllerProvider).valueOrNull?.activeAdmins ?? [];
}

/// 超级管理员列表
@riverpod
List<Uadmin> superAdmins(SuperAdminsRef ref) {
  return ref.watch(adminControllerProvider).valueOrNull?.superAdmins ?? [];
}

/// 管理员角色列表
@riverpod
List<String> adminRoles(AdminRolesRef ref) {
  return ref.watch(adminControllerProvider).valueOrNull?.roles ?? [];
}

/// 管理员统计信息
@riverpod
Map<String, int> adminStats(AdminStatsRef ref) {
  final controller = ref.watch(adminControllerProvider.notifier);
  return controller.getAdminStats();
}

/// 系统统计信息
@riverpod
Map<String, dynamic> systemStats(SystemStatsRef ref) {
  return ref.watch(adminControllerProvider).valueOrNull?.systemStats ?? {};
}

// ===== 兼容旧接口 =====

/// 旧的 Provider 兼容层
final adminProvider = Provider<AsyncValue<AdminState>>((ref) {
  return ref.watch(adminControllerProvider);
});