import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/providers/dio_provider.dart';

/// 已授权用户模型
class AuthorizedUser {
  final String id;
  final String nickname;
  final String phone;
  final String? realName;
  final List<String> permissions;
  final DateTime? lastLoginAt;
  final DateTime createdAt;

  AuthorizedUser({
    required this.id,
    required this.nickname,
    required this.phone,
    this.realName,
    required this.permissions,
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
  return PermissionManagementNotifier(apiClient);
});

/// 权限管理状态管理器
class PermissionManagementNotifier extends StateNotifier<PermissionManagementState> {
  final ApiClient _apiClient;

  PermissionManagementNotifier(this._apiClient) : super(const PermissionManagementState());

  /// 加载已授权用户列表
  Future<void> loadAuthorizedUsers() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // 临时使用模拟数据，直到后端API准备好
      await Future.delayed(const Duration(milliseconds: 500)); // 模拟网络延迟
      
      final mockUsers = [
        AuthorizedUser(
          id: '1',
          nickname: '张三',
          phone: '13812345678',
          realName: '张三',
          permissions: ['merchant'],
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        AuthorizedUser(
          id: '2',
          nickname: '李营养师',
          phone: '13823456789',
          realName: '李四',
          permissions: ['nutritionist'],
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
        AuthorizedUser(
          id: '3',
          nickname: '王店长',
          phone: '13834567890',
          realName: '王五',
          permissions: ['merchant', 'nutritionist'],
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
      ];

      // 计算统计信息
      final stats = _calculateStats(mockUsers);

      state = state.copyWith(
        authorizedUsers: mockUsers,
        stats: stats,
        isLoading: false,
      );
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
      // 模拟网络延迟
      await Future.delayed(const Duration(milliseconds: 500));
      
      // 模拟成功授权
      final currentUsers = List<AuthorizedUser>.from(state.authorizedUsers);
      
      // 查找是否已存在该用户
      final existingUserIndex = currentUsers.indexWhere((user) => user.id == userId);
      
      if (existingUserIndex != -1) {
        // 用户已存在，添加权限
        final existingUser = currentUsers[existingUserIndex];
        if (!existingUser.permissions.contains(permissionType)) {
          final updatedPermissions = List<String>.from(existingUser.permissions)..add(permissionType);
          currentUsers[existingUserIndex] = AuthorizedUser(
            id: existingUser.id,
            nickname: existingUser.nickname,
            phone: existingUser.phone,
            realName: existingUser.realName,
            permissions: updatedPermissions,
            createdAt: existingUser.createdAt,
          );
        }
      } else {
        // 创建新用户（从搜索结果中获取信息）
        currentUsers.add(AuthorizedUser(
          id: userId,
          nickname: '新授权用户',
          phone: '138000000XX',
          permissions: [permissionType],
          createdAt: DateTime.now(),
        ));
      }
      
      // 重新计算统计信息
      final stats = _calculateStats(currentUsers);
      
      state = state.copyWith(
        authorizedUsers: currentUsers,
        stats: stats,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 撤销权限
  Future<bool> revokePermission(String userId, String permissionType) async {
    try {
      // 模拟网络延迟
      await Future.delayed(const Duration(milliseconds: 500));
      
      final currentUsers = List<AuthorizedUser>.from(state.authorizedUsers);
      final userIndex = currentUsers.indexWhere((user) => user.id == userId);
      
      if (userIndex != -1) {
        final user = currentUsers[userIndex];
        final updatedPermissions = List<String>.from(user.permissions)..remove(permissionType);
        
        if (updatedPermissions.isEmpty) {
          // 如果没有权限了，移除用户
          currentUsers.removeAt(userIndex);
        } else {
          // 更新用户权限
          currentUsers[userIndex] = AuthorizedUser(
            id: user.id,
            nickname: user.nickname,
            phone: user.phone,
            realName: user.realName,
            permissions: updatedPermissions,
            createdAt: user.createdAt,
          );
        }
        
        // 重新计算统计信息
        final stats = _calculateStats(currentUsers);
        
        state = state.copyWith(
          authorizedUsers: currentUsers,
          stats: stats,
        );
        
        return true;
      }
      
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 搜索用户
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      // 模拟网络延迟
      await Future.delayed(const Duration(milliseconds: 300));
      
      // 模拟用户数据
      final mockUsers = [
        {
          '_id': 'user1',
          'nickname': '普通用户1',
          'phone': '13800000001',
          'realName': '张一',
          'role': 'user',
          'permissions': [],
        },
        {
          '_id': 'user2',
          'nickname': '普通用户2',
          'phone': '13800000002',
          'realName': '李二',
          'role': 'user',
          'permissions': [],
        },
        {
          '_id': 'user3',
          'nickname': '测试商家',
          'phone': '13800000003',
          'realName': '王三',
          'role': 'user',
          'permissions': [],
        },
        {
          '_id': 'user4',
          'nickname': '测试营养师',
          'phone': '13800000004',
          'realName': '赵四',
          'role': 'user',
          'permissions': [],
        },
        {
          '_id': 'user5',
          'nickname': '新用户五',
          'phone': '13800000005',
          'realName': '钱五',
          'role': 'user',
          'permissions': [],
        },
      ];
      
      // 根据查询条件过滤用户
      final filteredUsers = mockUsers.where((user) {
        final nickname = (user['nickname'] as String).toLowerCase();
        final phone = user['phone'] as String;
        final realName = (user['realName'] as String? ?? '').toLowerCase();
        final searchQuery = query.toLowerCase();
        
        return nickname.contains(searchQuery) || 
               phone.contains(searchQuery) || 
               realName.contains(searchQuery);
      }).toList();
      
      return filteredUsers;
    } catch (e) {
      return [];
    }
  }

  /// 获取权限历史记录
  Future<List<Map<String, dynamic>>> getPermissionHistory({String? userId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (userId != null) queryParams['userId'] = userId;

      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/admin/permissions/history',
        queryParameters: queryParams,
      );

      if (response.data != null && response.data!['success'] == true) {
        final List<dynamic> historyData = response.data!['data'] ?? [];
        return historyData.cast<Map<String, dynamic>>();
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
      if (user.createdAt.isAfter(startOfMonth)) {
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