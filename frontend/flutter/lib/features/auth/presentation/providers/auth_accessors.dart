import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/user_model.dart';
import 'auth_controller.dart';

part 'auth_accessors.g.dart';

/// 认证便捷访问器
/// 
/// 提供简化的认证状态访问方式

/// 是否已认证
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.isAuthenticated ?? false;
}

/// 是否正在加载
@riverpod
bool authIsLoading(AuthIsLoadingRef ref) {
  return ref.watch(authControllerProvider).isLoading ||
      (ref.watch(authControllerProvider).valueOrNull?.isLoading ?? false);
}

/// 当前用户
@riverpod
UserModel? currentUser(CurrentUserRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.user;
}

/// 认证Token
@riverpod
String? authToken(AuthTokenRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.token;
}

/// 错误信息
@riverpod
String? authError(AuthErrorRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.error;
}

/// 用户角色
@riverpod
String? userRole(UserRoleRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.userRole;
}

/// 是否是管理员
@riverpod
bool isAdmin(IsAdminRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.isAdmin ?? false;
}

/// 是否是营养师
@riverpod
bool isNutritionist(IsNutritionistRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.isNutritionist ?? false;
}

/// 是否是商家
@riverpod
bool isMerchant(IsMerchantRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.isMerchant ?? false;
}

/// 检查权限
@riverpod
bool hasPermission(HasPermissionRef ref, String permission) {
  return ref.watch(authControllerProvider).valueOrNull?.hasPermission(permission) ?? false;
}