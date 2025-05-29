/// 用户角色枚举
/// 
/// 定义系统中所有可能的用户角色类型
enum UserRole {
  /// 普通用户
  user('user', '普通用户'),
  
  /// 营养师
  nutritionist('nutritionist', '营养师'),
  
  /// 商家
  merchant('merchant', '商家'),
  
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

  /// 是否是普通用户
  bool get isUser => this == UserRole.user;

  /// 获取所有角色值列表
  static List<String> get allValues => UserRole.values.map((e) => e.value).toList();

  /// 获取所有角色标签列表
  static List<String> get allLabels => UserRole.values.map((e) => e.label).toList();
}