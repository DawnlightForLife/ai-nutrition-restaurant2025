import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/enums/user_role.dart';

part 'user_profile.freezed.dart';

/// 用户档案实体
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String phone,
    String? email,
    String? nickname,
    String? avatar,
    @Default([UserRole.user]) List<UserRole> roles,
    DateTime? createdAt,
    DateTime? updatedAt,
    
    // 角色相关信息
    String? merchantId,      // 商家ID（如果是商家）
    String? storeId,         // 店铺ID（如果是店员）
    String? nutritionistId,  // 营养师ID（如果是营养师）
    
    // 认证状态
    @Default(false) bool isMerchantVerified,
    @Default(false) bool isNutritionistVerified,
  }) = _UserProfile;
  
  const UserProfile._();
  
  /// 检查是否有指定角色
  bool hasRole(UserRole role) => roles.contains(role);
  
  /// 是否是商家
  bool get isMerchant => hasRole(UserRole.merchant) && isMerchantVerified;
  
  /// 是否是店员
  bool get isEmployee => hasRole(UserRole.employee);
  
  /// 是否是营养师
  bool get isNutritionist => hasRole(UserRole.nutritionist) && isNutritionistVerified;
  
  /// 是否是管理员
  bool get isAdmin => hasRole(UserRole.admin);
  
  /// 获取主要角色（优先级最高的角色）
  UserRole get primaryRole {
    if (isAdmin) return UserRole.admin;
    if (isMerchant) return UserRole.merchant;
    if (isNutritionist) return UserRole.nutritionist;
    if (isEmployee) return UserRole.employee;
    return UserRole.user;
  }
  
  /// 获取可用的角色入口
  List<RoleEntry> get availableEntries {
    final entries = <RoleEntry>[];
    
    if (isMerchant) {
      entries.add(const RoleEntry(
        role: UserRole.merchant,
        title: '商家管理',
        icon: Icons.store,
        route: '/merchant/dashboard',
      ));
    }
    
    if (isEmployee) {
      entries.add(const RoleEntry(
        role: UserRole.employee,
        title: '员工工作台',
        icon: Icons.work,
        route: '/employee/workspace',
      ));
    }
    
    if (isNutritionist) {
      entries.add(const RoleEntry(
        role: UserRole.nutritionist,
        title: '营养师工作台',
        icon: Icons.medical_services,
        route: '/nutritionist/dashboard',
      ));
    }
    
    return entries;
  }
}

/// 角色入口
@freezed
class RoleEntry with _$RoleEntry {
  const factory RoleEntry({
    required UserRole role,
    required String title,
    required IconData icon,
    required String route,
  }) = _RoleEntry;
}