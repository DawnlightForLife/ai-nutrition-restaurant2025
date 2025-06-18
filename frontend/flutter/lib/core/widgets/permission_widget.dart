import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../constants/permissions.dart';

/// 权限控制小部件
/// 根据用户权限显示或隐藏子部件
class PermissionWidget extends ConsumerWidget {
  const PermissionWidget({
    super.key,
    required this.child,
    this.requiredPermissions,
    this.requiredRoles,
    this.mode = PermissionMode.all,
    this.fallback,
    this.showFallbackWhenNoAuth = false,
  });

  /// 子部件
  final Widget child;
  
  /// 需要的权限列表
  final List<String>? requiredPermissions;
  
  /// 需要的角色列表
  final List<String>? requiredRoles;
  
  /// 权限检查模式
  final PermissionMode mode;
  
  /// 无权限时显示的部件
  final Widget? fallback;
  
  /// 未登录时是否显示fallback
  final bool showFallbackWhenNoAuth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    // 如果未登录
    if (!authState.isAuthenticated) {
      return showFallbackWhenNoAuth ? (fallback ?? const SizedBox.shrink()) : child;
    }
    
    final user = authState.user;
    if (user == null) {
      return fallback ?? const SizedBox.shrink();
    }
    
    bool hasPermission = true;
    
    // 检查角色权限
    if (requiredRoles != null && requiredRoles!.isNotEmpty) {
      if (mode == PermissionMode.any) {
        hasPermission = PermissionChecker.hasAnyRole(user.role, requiredRoles!);
      } else {
        // 对于角色，all模式意味着用户必须具有列表中的某个角色
        hasPermission = PermissionChecker.hasAnyRole(user.role, requiredRoles!);
      }
    }
    
    // 检查具体权限
    if (hasPermission && requiredPermissions != null && requiredPermissions!.isNotEmpty) {
      final userPermissions = RolePermissions.getUserPermissions(
        user.role,
        user.permissions?.cast<String>(),
      );
      
      if (mode == PermissionMode.any) {
        hasPermission = PermissionChecker.hasAnyPermission(userPermissions, requiredPermissions!);
      } else {
        hasPermission = PermissionChecker.hasAllPermissions(userPermissions, requiredPermissions!);
      }
    }
    
    return hasPermission ? child : (fallback ?? const SizedBox.shrink());
  }
}

/// 权限检查模式
enum PermissionMode {
  /// 需要所有权限
  all,
  /// 需要任一权限
  any,
}

/// 角色控制小部件
/// 根据用户角色显示或隐藏子部件
class RoleWidget extends ConsumerWidget {
  const RoleWidget({
    super.key,
    required this.child,
    required this.allowedRoles,
    this.fallback,
  });

  final Widget child;
  final List<String> allowedRoles;
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PermissionWidget(
      requiredRoles: allowedRoles,
      mode: PermissionMode.any,
      fallback: fallback,
      child: child,
    );
  }
}

/// 商家专用小部件
class MerchantOnlyWidget extends ConsumerWidget {
  const MerchantOnlyWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RoleWidget(
      allowedRoles: const [Roles.storeManager, Roles.storeStaff],
      fallback: fallback,
      child: child,
    );
  }
}

/// 营养师专用小部件
class NutritionistOnlyWidget extends ConsumerWidget {
  const NutritionistOnlyWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RoleWidget(
      allowedRoles: const [Roles.nutritionist],
      fallback: fallback,
      child: child,
    );
  }
}

/// 管理员专用小部件
class AdminOnlyWidget extends ConsumerWidget {
  const AdminOnlyWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RoleWidget(
      allowedRoles: const [Roles.admin, Roles.superAdmin, Roles.areaManager],
      fallback: fallback,
      child: child,
    );
  }
}

/// 权限检查Mixin
/// 为StatefulWidget提供权限检查功能
mixin PermissionMixin<T extends StatefulWidget> on State<T> {
  /// 检查当前用户是否有指定权限
  bool hasPermission(WidgetRef ref, String permission) {
    final authState = ref.read(authStateProvider);
    if (!authState.isAuthenticated || authState.user == null) return false;
    
    final userPermissions = RolePermissions.getUserPermissions(
      authState.user!.role,
      authState.user!.permissions?.cast<String>(),
    );
    
    return PermissionChecker.hasPermission(userPermissions, permission);
  }
  
  /// 检查当前用户是否有任一权限
  bool hasAnyPermission(WidgetRef ref, List<String> permissions) {
    final authState = ref.read(authStateProvider);
    if (!authState.isAuthenticated || authState.user == null) return false;
    
    final userPermissions = RolePermissions.getUserPermissions(
      authState.user!.role,
      authState.user!.permissions?.cast<String>(),
    );
    
    return PermissionChecker.hasAnyPermission(userPermissions, permissions);
  }
  
  /// 检查当前用户是否有指定角色
  bool hasRole(WidgetRef ref, String role) {
    final authState = ref.read(authStateProvider);
    if (!authState.isAuthenticated || authState.user == null) return false;
    
    return PermissionChecker.hasRole(authState.user!.role, role);
  }
  
  /// 检查当前用户是否为商家
  bool isMerchant(WidgetRef ref) {
    final authState = ref.read(authStateProvider);
    if (!authState.isAuthenticated || authState.user == null) return false;
    
    return PermissionChecker.isMerchant(authState.user!.role);
  }
  
  /// 检查当前用户是否为营养师
  bool isNutritionist(WidgetRef ref) {
    final authState = ref.read(authStateProvider);
    if (!authState.isAuthenticated || authState.user == null) return false;
    
    return PermissionChecker.isNutritionist(authState.user!.role);
  }
  
  /// 检查当前用户是否为管理员
  bool isAdmin(WidgetRef ref) {
    final authState = ref.read(authStateProvider);
    if (!authState.isAuthenticated || authState.user == null) return false;
    
    return PermissionChecker.isAdmin(authState.user!.role);
  }
}