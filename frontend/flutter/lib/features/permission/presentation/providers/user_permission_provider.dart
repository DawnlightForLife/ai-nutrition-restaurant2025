import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_permission_model.dart';
import '../../data/services/user_permission_service.dart';

// ========== 用户权限状态管理 ==========

/// 当前用户权限状态
final userPermissionsProvider = FutureProvider.autoDispose<List<UserPermissionModel>>((ref) async {
  final service = ref.read(userPermissionServiceProvider);
  return await service.getUserPermissions();
});

/// 刷新用户权限状态
final refreshUserPermissionsProvider = Provider<void Function()>((ref) {
  return () => ref.invalidate(userPermissionsProvider);
});

/// 商家权限检查
final hasMerchantPermissionProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(userPermissionServiceProvider);
  return await service.hasMerchantPermission();
});

/// 营养师权限检查
final hasNutritionistPermissionProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(userPermissionServiceProvider);
  return await service.hasNutritionistPermission();
});

/// 权限申请状态管理
class PermissionApplicationNotifier extends StateNotifier<AsyncValue<UserPermissionModel?>> {
  final UserPermissionService _service;
  final Ref _ref;
  
  PermissionApplicationNotifier(this._service, this._ref) : super(const AsyncValue.data(null));
  
  /// 申请权限
  Future<void> applyPermission({
    required String permissionType,
    required String reason,
    Map<String, String>? contactInfo,
    String? qualifications,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final result = await _service.applyPermission(
        permissionType: permissionType,
        reason: reason,
        contactInfo: contactInfo,
        qualifications: qualifications,
      );
      
      state = AsyncValue.data(result);
      
      // 刷新用户权限列表
      _ref.invalidate(userPermissionsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 清除状态
  void clearState() {
    state = const AsyncValue.data(null);
  }
}

final permissionApplicationProvider = StateNotifierProvider<PermissionApplicationNotifier, AsyncValue<UserPermissionModel?>>((ref) {
  final service = ref.read(userPermissionServiceProvider);
  return PermissionApplicationNotifier(service, ref);
});

// ========== 管理员权限管理 ==========

/// 待审核申请列表状态
class PendingApplicationsNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final UserPermissionService _service;
  final Ref _ref;
  
  PendingApplicationsNotifier(this._service, this._ref) : super(const AsyncValue.loading()) {
    loadPendingApplications();
  }
  
  /// 加载待审核申请
  Future<void> loadPendingApplications({
    String? permissionType,
    int page = 1,
    int limit = 20,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final result = await _service.getPendingApplications(
        permissionType: permissionType,
        page: page,
        limit: limit,
      );
      
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 审核申请
  Future<void> reviewApplication(
    String permissionId,
    ReviewAction action, {
    String? comment,
  }) async {
    try {
      await _service.reviewApplication(permissionId, action, comment: comment);
      
      // 重新加载列表
      await loadPendingApplications();
      
      // 刷新统计信息
      _ref.invalidate(permissionStatsProvider);
    } catch (error) {
      // 错误处理可以通过其他方式通知UI
      rethrow;
    }
  }
  
  /// 批量审核申请
  Future<void> batchReviewApplications(
    List<String> permissionIds,
    ReviewAction action, {
    String? comment,
  }) async {
    try {
      await _service.batchReviewApplications(permissionIds, action, comment: comment);
      
      // 重新加载列表
      await loadPendingApplications();
      
      // 刷新统计信息
      _ref.invalidate(permissionStatsProvider);
    } catch (error) {
      rethrow;
    }
  }
}

final pendingApplicationsProvider = StateNotifierProvider<PendingApplicationsNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  final service = ref.read(userPermissionServiceProvider);
  return PendingApplicationsNotifier(service, ref);
});

/// 权限统计信息
final permissionStatsProvider = FutureProvider<PermissionStatsModel>((ref) async {
  final service = ref.read(userPermissionServiceProvider);
  return await service.getPermissionStats();
});

/// 用户权限详情管理
class UserPermissionDetailsNotifier extends StateNotifier<AsyncValue<List<UserPermissionModel>>> {
  final UserPermissionService _service;
  final Ref _ref;
  
  UserPermissionDetailsNotifier(this._service, this._ref) : super(const AsyncValue.data([]));
  
  /// 加载用户权限详情
  Future<void> loadUserPermissionDetails(String userId) async {
    state = const AsyncValue.loading();
    
    try {
      final result = await _service.getUserPermissionDetails(userId);
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 撤销权限
  Future<void> revokePermission(
    String userId,
    String permissionType, {
    String? reason,
  }) async {
    try {
      await _service.revokePermission(userId, permissionType, reason: reason);
      
      // 重新加载用户权限详情
      await loadUserPermissionDetails(userId);
      
      // 刷新统计信息
      _ref.invalidate(permissionStatsProvider);
    } catch (error) {
      rethrow;
    }
  }
  
  /// 直接授予权限
  Future<void> grantPermission({
    required String userId,
    required String permissionType,
    String? comment,
  }) async {
    try {
      await _service.grantPermission(
        userId: userId,
        permissionType: permissionType,
        comment: comment,
      );
      
      // 重新加载用户权限详情
      await loadUserPermissionDetails(userId);
      
      // 刷新统计信息
      _ref.invalidate(permissionStatsProvider);
    } catch (error) {
      rethrow;
    }
  }
}

final userPermissionDetailsProvider = StateNotifierProvider<UserPermissionDetailsNotifier, AsyncValue<List<UserPermissionModel>>>((ref) {
  final service = ref.read(userPermissionServiceProvider);
  return UserPermissionDetailsNotifier(service, ref);
});

// ========== 便捷的权限检查Provider ==========

/// 检查当前用户是否有商家权限
final currentUserHasMerchantPermissionProvider = Provider<bool>((ref) {
  final permissionsAsync = ref.watch(userPermissionsProvider);
  
  return permissionsAsync.when(
    data: (permissions) => permissions.any(
      (p) => p.permissionType == 'merchant' && p.status == 'approved'
    ),
    loading: () => false,
    error: (_, __) => false,
  );
});

/// 检查当前用户是否有营养师权限
final currentUserHasNutritionistPermissionProvider = Provider<bool>((ref) {
  final permissionsAsync = ref.watch(userPermissionsProvider);
  
  return permissionsAsync.when(
    data: (permissions) => permissions.any(
      (p) => p.permissionType == 'nutritionist' && p.status == 'approved'
    ),
    loading: () => false,
    error: (_, __) => false,
  );
});

/// 检查当前用户是否有待审核的申请
final currentUserHasPendingApplicationProvider = Provider<Map<String, bool>>((ref) {
  final permissionsAsync = ref.watch(userPermissionsProvider);
  
  return permissionsAsync.when(
    data: (permissions) {
      final merchantPending = permissions.any(
        (p) => p.permissionType == 'merchant' && p.status == 'pending'
      );
      final nutritionistPending = permissions.any(
        (p) => p.permissionType == 'nutritionist' && p.status == 'pending'
      );
      
      return {
        'merchant': merchantPending,
        'nutritionist': nutritionistPending,
      };
    },
    loading: () => {'merchant': false, 'nutritionist': false},
    error: (_, __) => {'merchant': false, 'nutritionist': false},
  );
});