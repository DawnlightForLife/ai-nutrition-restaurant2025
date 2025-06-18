import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../../permission/presentation/providers/user_permission_provider.dart';

/// 权限详情模型
class PermissionDetail {
  final String type;
  final DateTime grantedAt;
  final String? grantedBy;

  PermissionDetail({
    required this.type,
    required this.grantedAt,
    this.grantedBy,
  });

  factory PermissionDetail.fromJson(Map<String, dynamic> json) {
    return PermissionDetail(
      type: json['type'] ?? '',
      grantedAt: DateTime.parse(json['grantedAt']),
      grantedBy: json['grantedBy'],
    );
  }
}

/// 已授权用户模型
class AuthorizedUser {
  final String id;
  final String nickname;
  final String phone;
  final String? realName;
  final List<String> permissions;
  final List<PermissionDetail> permissionDetails;
  final DateTime? lastLoginAt;
  final DateTime createdAt;

  AuthorizedUser({
    required this.id,
    required this.nickname,
    required this.phone,
    this.realName,
    required this.permissions,
    required this.permissionDetails,
    this.lastLoginAt,
    required this.createdAt,
  });

  factory AuthorizedUser.fromJson(Map<String, dynamic> json) {
    return AuthorizedUser(
      id: json['_id'] ?? json['id'] ?? '',
      nickname: json['nickname'] ?? '',
      phone: json['phone'] ?? '',
      realName: json['realName'],
      permissions: _extractPermissions(json),
      permissionDetails: _extractPermissionDetails(json),
      lastLoginAt: json['lastLogin'] != null 
          ? DateTime.tryParse(json['lastLogin']) 
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  static List<String> _extractPermissions(Map<String, dynamic> json) {
    final permissions = <String>[];
    
    // 检查role字段
    final role = json['role'] as String?;
    if (role == 'merchant' || role == 'merchant_admin') {
      permissions.add('merchant');
    }
    if (role == 'nutritionist') {
      permissions.add('nutritionist');
    }
    
    // 检查permissions字段
    if (json['permissions'] is List) {
      for (final permission in json['permissions']) {
        if (permission is String && !permissions.contains(permission)) {
          permissions.add(permission);
        }
      }
    }
    
    // 检查storePermissions字段（商家权限）
    if (json['storePermissions'] is List && 
        (json['storePermissions'] as List).isNotEmpty) {
      if (!permissions.contains('merchant')) {
        permissions.add('merchant');
      }
    }
    
    return permissions;
  }

  static List<PermissionDetail> _extractPermissionDetails(Map<String, dynamic> json) {
    final details = <PermissionDetail>[];
    
    if (json['permissionDetails'] is List) {
      for (final detail in json['permissionDetails']) {
        if (detail is Map<String, dynamic>) {
          try {
            details.add(PermissionDetail.fromJson(detail));
          } catch (e) {
            // 忽略解析错误的权限详情
          }
        }
      }
    }
    
    return details;
  }
}

/// 权限统计信息
class PermissionStats {
  final int merchantCount;
  final int nutritionistCount;
  final int monthlyNewCount;

  const PermissionStats({
    this.merchantCount = 0,
    this.nutritionistCount = 0,
    this.monthlyNewCount = 0,
  });
}

/// 权限管理状态
class PermissionManagementState {
  final List<AuthorizedUser> authorizedUsers;
  final PermissionStats stats;
  final bool isLoading;
  final String? error;

  const PermissionManagementState({
    this.authorizedUsers = const [],
    this.stats = const PermissionStats(),
    this.isLoading = false,
    this.error,
  });

  PermissionManagementState copyWith({
    List<AuthorizedUser>? authorizedUsers,
    PermissionStats? stats,
    bool? isLoading,
    String? error,
  }) {
    return PermissionManagementState(
      authorizedUsers: authorizedUsers ?? this.authorizedUsers,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 权限管理Provider
final permissionManagementProvider = StateNotifierProvider<PermissionManagementNotifier, PermissionManagementState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PermissionManagementNotifier(apiClient, ref);
});

/// 权限管理状态管理器
class PermissionManagementNotifier extends StateNotifier<PermissionManagementState> {
  final ApiClient _apiClient;
  final Ref _ref;

  PermissionManagementNotifier(this._apiClient, this._ref) : super(const PermissionManagementState());

  /// 加载已授权用户列表
  Future<void> loadAuthorizedUsers({String? permissionFilter}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // 构建查询参数
      final queryParameters = <String, dynamic>{};
      if (permissionFilter != null && permissionFilter.isNotEmpty) {
        queryParameters['permissions'] = permissionFilter;
      }

      // 调用真实的后端API
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/admin/user-permissions/authorized',
        queryParameters: queryParameters,
      );

      if (response.data != null && response.data!['success'] == true) {
        final Map<String, dynamic> data = response.data!['data'] ?? {};
        final List<dynamic> usersData = data['users'] ?? [];
        final users = usersData.map((userData) => 
          AuthorizedUser.fromJson(userData as Map<String, dynamic>)
        ).toList();

        // 计算统计信息
        final stats = _calculateStats(users);

        state = state.copyWith(
          authorizedUsers: users,
          stats: stats,
          isLoading: false,
        );
      } else {
        throw Exception(response.data?['message'] ?? '加载失败');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 授予权限
  Future<bool> grantPermission(String userId, String permissionType) async {
    try {
      // 调用真实的后端API授权
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/admin/user-permissions/$userId/permissions',
        data: {
          'permission': permissionType,
        },
      );

      if (response.data != null && response.data!['success'] == true) {
        // 重新加载授权用户列表以获取最新数据
        await loadAuthorizedUsers();
        // 刷新全局用户权限状态
        _ref.read(refreshUserPermissionsProvider)();
        return true;
      } else {
        state = state.copyWith(error: response.data?['message'] ?? '授权失败');
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 撤销权限
  Future<bool> revokePermission(String userId, String permissionType) async {
    try {
      // 调用真实的后端API撤销权限
      final response = await _apiClient.delete<Map<String, dynamic>>(
        '/admin/user-permissions/$userId/permissions/$permissionType',
      );

      if (response.data != null && response.data!['success'] == true) {
        // 重新加载授权用户列表以获取最新数据
        await loadAuthorizedUsers();
        // 刷新全局用户权限状态
        _ref.read(refreshUserPermissionsProvider)();
        return true;
      } else {
        state = state.copyWith(error: response.data?['message'] ?? '撤销权限失败');
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 搜索用户
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      // 调用真实的后端API搜索用户
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/admin/user-permissions/search',
        queryParameters: {
          'q': query,  // 修正参数名为后端期望的 'q'
          'limit': 20,
        },
      );

      if (response.data != null && response.data!['success'] == true) {
        // 后端直接返回数组，所以data就是用户数组
        final List<dynamic> usersData = response.data!['data'] ?? [];
        return usersData.cast<Map<String, dynamic>>();
      } else {
        return [];
      }
    } catch (e) {
      print('[PermissionManagementProvider] searchUsers error: $e');
      return [];
    }
  }

  /// 获取所有用户列表（用于初始显示）
  Future<List<Map<String, dynamic>>> getAllUsers({int page = 1, int limit = 50}) async {
    try {
      // 使用专门的用户列表API
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/admin/user-permissions/users',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.data != null && response.data!['success'] == true) {
        // 修正数据解析：后端返回的是 { data: { users: [...] } }
        final Map<String, dynamic> responseData = response.data!['data'] ?? {};
        final List<dynamic> usersData = responseData['users'] ?? [];
        return usersData.cast<Map<String, dynamic>>();
      } else {
        return [];
      }
    } catch (e) {
      print('[PermissionManagementProvider] getAllUsers error: $e');
      return [];
    }
  }

  /// 获取权限历史记录
  Future<List<Map<String, dynamic>>> getPermissionHistory({String? userId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (userId != null) queryParams['userId'] = userId;

      final response = await _apiClient.get<Map<String, dynamic>>(
        '/admin/user-permissions/history',
        queryParameters: queryParams,
      );

      if (response.data != null && response.data!['success'] == true) {
        final Map<String, dynamic> data = response.data!['data'] ?? {};
        final List<dynamic> historyData = data['history'] ?? [];
        
        // 处理历史记录数据，提取需要的字段
        return historyData.map((record) {
          final Map<String, dynamic> historyRecord = record as Map<String, dynamic>;
          return {
            'action': historyRecord['action'],
            'permission': historyRecord['permissionType'],
            'userName': historyRecord['userId']?['nickname'] ?? '未知用户',
            'operatorName': historyRecord['operatorId']?['nickname'] ?? '未知操作员',
            'reason': historyRecord['reason'] ?? '',
            'createdAt': historyRecord['createdAt'],
          };
        }).toList();
      } else {
        throw Exception(response.data?['message'] ?? '获取历史记录失败');
      }
    } catch (e) {
      return [];
    }
  }

  /// 计算统计信息
  PermissionStats _calculateStats(List<AuthorizedUser> users) {
    int merchantCount = 0;
    int nutritionistCount = 0;
    int monthlyNewCount = 0;

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    for (final user in users) {
      if (user.permissions.contains('merchant')) {
        merchantCount++;
      }
      if (user.permissions.contains('nutritionist')) {
        nutritionistCount++;
      }
      
      // 检查是否有本月新授权的权限
      bool hasNewPermissionThisMonth = false;
      
      for (final detail in user.permissionDetails) {
        if (detail.grantedAt.isAfter(startOfMonth)) {
          hasNewPermissionThisMonth = true;
          break;
        }
      }
      
      if (hasNewPermissionThisMonth) {
        monthlyNewCount++;
      }
    }

    return PermissionStats(
      merchantCount: merchantCount,
      nutritionistCount: nutritionistCount,
      monthlyNewCount: monthlyNewCount,
    );
  }
}