/// 用户角色枚举
/// 
/// 定义系统中所有可能的用户角色类型
enum UserRole {
  /// 普通用户
  user('user', '普通用户'),
  
  /// 商家
  merchant('merchant', '商家'),
  
  /// 店员
  employee('employee', '店员'),
  
  /// 营养师
  nutritionist('nutritionist', '营养师'),
  
  /// 管理员
  admin('admin', '管理员'),
  
  /// 超级管理员
  superAdmin('super_admin', '超级管理员');

  const UserRole(this.value, this.label);

  /// 角色值
  final String value;
  
  /// 角色显示名称
  final String label;

  /// 从字符串转换为枚举
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.user,
    );
  }

  /// 是否是管理员角色
  bool get isAdmin => this == UserRole.admin || this == UserRole.superAdmin;

  /// 是否是营养师
  bool get isNutritionist => this == UserRole.nutritionist;

  /// 是否是商家
  bool get isMerchant => this == UserRole.merchant;

  /// 是否是员工
  bool get isEmployee => this == UserRole.employee;

  /// 是否是普通用户
  bool get isUser => this == UserRole.user;

  /// 获取所有角色值列表
  static List<String> get allValues => UserRole.values.map((e) => e.value).toList();

  /// 获取所有角色标签列表
  static List<String> get allLabels => UserRole.values.map((e) => e.label).toList();
}

/// 用户角色扩展方法
extension UserRoleExtension on UserRole {
  /// 获取角色显示名称
  String get displayName => label;
  
  /// 获取角色图标
  String get icon {
    switch (this) {
      case UserRole.user:
        return '👤';
      case UserRole.merchant:
        return '🏪';
      case UserRole.employee:
        return '👷';
      case UserRole.nutritionist:
        return '👨‍⚕️';
      case UserRole.admin:
        return '👨‍💼';
      case UserRole.superAdmin:
        return '👑';
    }
  }
  
  /// 获取角色入口路由
  String? get entryRoute {
    switch (this) {
      case UserRole.user:
        return null; // 普通用户没有特殊入口
      case UserRole.merchant:
        return '/merchant/dashboard';
      case UserRole.employee:
        return '/employee/workspace';
      case UserRole.nutritionist:
        return '/nutritionist/dashboard';
      case UserRole.admin:
        return '/admin/dashboard';
      case UserRole.superAdmin:
        return '/admin/dashboard';
    }
  }
}