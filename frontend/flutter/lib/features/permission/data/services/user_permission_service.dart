import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../datasources/user_permission_remote_datasource.dart';
import '../models/user_permission_model.dart';

// DI Provider
final userPermissionRemoteDatasourceProvider = Provider<UserPermissionRemoteDatasource>((ref) {
  final dio = ref.watch(dioProvider);
  return UserPermissionRemoteDatasource(dio);
});

final userPermissionServiceProvider = Provider<UserPermissionService>((ref) {
  final datasource = ref.read(userPermissionRemoteDatasourceProvider);
  return UserPermissionService(datasource);
});

class UserPermissionService {
  final UserPermissionRemoteDatasource _datasource;
  
  UserPermissionService(this._datasource);
  
  /// 申请权限
  Future<UserPermissionModel> applyPermission({
    required String permissionType,
    required String reason,
    Map<String, String>? contactInfo,
    String? qualifications,
  }) async {
    final request = PermissionApplicationRequest(
      permissionType: permissionType,
      reason: reason,
      contactInfo: contactInfo != null 
          ? ContactInfoModel(
              phone: contactInfo['phone'],
              email: contactInfo['email'],
              wechat: contactInfo['wechat'],
            )
          : null,
      qualifications: qualifications,
    );
    
    return await _datasource.applyPermission(request);
  }
  
  /// 获取当前用户的权限状态
  Future<List<UserPermissionModel>> getUserPermissions() async {
    return await _datasource.getUserPermissions();
  }
  
  /// 检查用户是否有特定权限
  Future<bool> checkPermission(String permissionType) async {
    return await _datasource.checkPermission(permissionType);
  }
  
  /// 检查商家权限
  Future<bool> hasMerchantPermission() async {
    return await checkPermission('merchant');
  }
  
  /// 检查营养师权限
  Future<bool> hasNutritionistPermission() async {
    return await checkPermission('nutritionist');
  }
  
  // ========== 管理员功能 ==========
  
  /// 获取待审核的权限申请列表
  Future<Map<String, dynamic>> getPendingApplications({
    String? permissionType,
    int page = 1,
    int limit = 20,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    return await _datasource.getPendingApplications(
      permissionType: permissionType,
      page: page,
      limit: limit,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }
  
  /// 审核权限申请
  Future<UserPermissionModel> reviewApplication(
    String permissionId,
    ReviewAction action, {
    String? comment,
  }) async {
    final request = PermissionReviewRequest(
      action: action.name,
      comment: comment,
    );
    
    return await _datasource.reviewApplication(permissionId, request);
  }
  
  /// 批量审核权限申请
  Future<Map<String, dynamic>> batchReviewApplications(
    List<String> permissionIds,
    ReviewAction action, {
    String? comment,
  }) async {
    final request = BatchReviewRequest(
      permissionIds: permissionIds,
      action: action.name,
      comment: comment,
    );
    
    return await _datasource.batchReviewApplications(request);
  }
  
  /// 撤销用户权限
  Future<UserPermissionModel> revokePermission(
    String userId,
    String permissionType, {
    String? reason,
  }) async {
    return await _datasource.revokePermission(
      userId,
      permissionType,
      reason: reason,
    );
  }
  
  /// 直接授予权限
  Future<UserPermissionModel> grantPermission({
    required String userId,
    required String permissionType,
    String? comment,
  }) async {
    return await _datasource.grantPermission(
      userId: userId,
      permissionType: permissionType,
      comment: comment,
    );
  }
  
  /// 获取权限统计信息
  Future<PermissionStatsModel> getPermissionStats() async {
    return await _datasource.getPermissionStats();
  }
  
  /// 获取指定用户的权限详情
  Future<List<UserPermissionModel>> getUserPermissionDetails(String userId) async {
    return await _datasource.getUserPermissionDetails(userId);
  }
}