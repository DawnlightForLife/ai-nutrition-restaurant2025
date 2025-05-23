import '../../common/entities/entity.dart';
import '../value_objects/user_id.dart';
import '../value_objects/email.dart';
import '../value_objects/phone.dart';
import '../value_objects/user_name.dart';
import '../value_objects/user_role.dart';

/// 用户实体
/// 
/// 对应后端的User模型
class User extends Entity {
  final UserId id;
  final Email email;
  final Phone phone;
  final UserName nickname;
  final UserRole role;
  final String? avatar;
  final String? gender;
  final int? age;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const User({
    required this.id,
    required this.email,
    required this.phone,
    required this.nickname,
    required this.role,
    this.avatar,
    this.gender,
    this.age,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// 是否是管理员
  bool get isAdmin => role.value.fold(
    (_) => false,
    (role) => role == 'admin',
  );
  
  /// 是否是普通用户
  bool get isRegularUser => role.value.fold(
    (_) => false,
    (role) => role == 'user',
  );
  
  /// 是否是营养师
  bool get isNutritionist => role.value.fold(
    (_) => false,
    (role) => role == 'nutritionist',
  );
  
  /// 是否是商家
  bool get isMerchant => role.value.fold(
    (_) => false,
    (role) => role == 'merchant',
  );
  
  /// 是否完善了基本信息
  bool get hasCompleteProfile => 
    gender != null && 
    age != null && 
    avatar != null;
    
  /// 创建副本
  User copyWith({
    UserId? id,
    Email? email,
    Phone? phone,
    UserName? nickname,
    UserRole? role,
    String? avatar,
    String? gender,
    int? age,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      nickname: nickname ?? this.nickname,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}