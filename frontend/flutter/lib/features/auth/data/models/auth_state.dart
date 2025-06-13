/// 认证状态
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final UserInfo? user;
  final String? token;
  final String? error;
  
  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.token,
    this.error,
  });
  
  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    UserInfo? user,
    String? token,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      token: token ?? this.token,
      error: error ?? this.error,
    );
  }
}

/// 用户信息
class UserInfo {
  final String id;
  final String phone;
  final String? nickname;
  final String? avatar; // 旧字段，保留兼容性
  final String? avatarUrl; // 新字段，优先使用
  final String? role;
  final bool needCompleteProfile;
  final DateTime createdAt;
  
  const UserInfo({
    required this.id,
    required this.phone,
    this.nickname,
    this.avatar,
    this.avatarUrl,
    this.role,
    this.needCompleteProfile = false,
    required this.createdAt,
  });
  
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? json['_id'] ?? '',
      phone: json['phone'] ?? '',
      nickname: json['nickname'],
      avatar: json['avatar'],
      avatarUrl: json['avatarUrl'],
      role: json['role'],
      needCompleteProfile: json['isProfileCompleted'] == false,
      createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt']) 
        : DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'nickname': nickname,
      'avatar': avatar,
      'avatarUrl': avatarUrl,
      'role': role,
      'isProfileCompleted': !needCompleteProfile,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  // 获取头像URL（优先使用avatarUrl，兼容avatar字段）
  String? get displayAvatarUrl => avatarUrl ?? avatar;
}