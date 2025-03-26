
/// 管理员权限枚举
class AdminPermission {
  static const String userManagement = 'user_management';
  static const String nutritionistVerification = 'nutritionist_verification';
  static const String merchantManagement = 'merchant_management';
  static const String merchantCodeManagement = 'merchant_code_management';
  static const String contentManagement = 'content_management';
  static const String systemSettings = 'system_settings';
  static const String adminManagement = 'admin_management';

  // 所有权限列表
  static List<String> get allPermissions => [
    userManagement,
    nutritionistVerification,
    merchantManagement,
    merchantCodeManagement,
    contentManagement,
    systemSettings,
    adminManagement,
  ];
  
  // 权限名称映射
  static Map<String, String> permissionNames = {
    userManagement: '用户管理',
    nutritionistVerification: '营养师认证管理',
    merchantManagement: '商家管理',
    merchantCodeManagement: '商家注册码管理',
    contentManagement: '内容管理',
    systemSettings: '系统设置',
    adminManagement: '管理员管理',
  };
  
  // 权限描述映射
  static Map<String, String> permissionDescriptions = {
    userManagement: '管理用户账号，查看和修改用户信息',
    nutritionistVerification: '审核营养师认证申请',
    merchantManagement: '管理商家账号，审核商家入驻申请',
    merchantCodeManagement: '生成和管理商家注册码',
    contentManagement: '管理平台内容，包括文章、评论等',
    systemSettings: '管理系统设置和配置',
    adminManagement: '管理其他管理员账号和权限',
  };
}

/// 管理员模型类
class Admin {
  final String id;
  final String username;
  final String nickname;
  final String email;
  final String phone;
  final List<String> permissions;
  final bool isSuper; // 超级管理员标识
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final String createdBy; // 创建者ID
  final bool isActive; // 是否活跃

  Admin({
    required this.id,
    required this.username,
    required this.nickname,
    required this.email,
    required this.phone,
    required this.permissions,
    required this.isSuper,
    required this.createdAt,
    this.lastLoginAt,
    required this.createdBy,
    required this.isActive,
  });

  // 检查是否有指定权限
  bool hasPermission(String permission) {
    if (isSuper) return true; // 超级管理员拥有所有权限
    return permissions.contains(permission);
  }
  
  // 从JSON创建Admin对象
  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['_id'] ?? json['id'],
      username: json['username'],
      nickname: json['nickname'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      permissions: (json['permissions'] as List?)?.map((e) => e as String).toList() ?? [],
      isSuper: json['isSuper'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt']) : null,
      createdBy: json['createdBy'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }
  
  // 将Admin对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'nickname': nickname,
      'email': email,
      'phone': phone,
      'permissions': permissions,
      'isSuper': isSuper,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'createdBy': createdBy,
      'isActive': isActive,
    };
  }
  
  // 创建带有更新属性的Admin副本
  Admin copyWith({
    String? nickname,
    String? email,
    String? phone,
    List<String>? permissions,
    bool? isActive,
  }) {
    return Admin(
      id: id,
      username: username,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      permissions: permissions ?? this.permissions,
      isSuper: isSuper,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
      createdBy: createdBy,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'Admin{id: $id, username: $username, nickname: $nickname, isSuper: $isSuper}';
  }
} 