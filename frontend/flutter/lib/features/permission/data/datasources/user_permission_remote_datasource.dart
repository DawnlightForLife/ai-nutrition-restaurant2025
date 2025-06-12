import 'package:dio/dio.dart';
import '../models/user_permission_model.dart';

class UserPermissionRemoteDatasource {
  final Dio _dio;
  
  UserPermissionRemoteDatasource(this._dio);
  
  // ========== 用户权限相关 ==========
  
  /// 申请权限
  Future<UserPermissionModel> applyPermission(
    PermissionApplicationRequest request
  ) async {
    try {
      final response = await _dio.post(
        '/user-permissions/apply',
        data: request.toJson(),
      );
      
      return UserPermissionModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// 获取当前用户的权限状态
  Future<List<UserPermissionModel>> getUserPermissions() async {
    try {
      final response = await _dio.get('/user-permissions/my');
      
      final List<dynamic> data = response.data['data'];
      return data.map((json) => UserPermissionModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// 检查用户是否有特定权限
  Future<bool> checkPermission(String permissionType) async {
    try {
      final response = await _dio.get('/user-permissions/check/$permissionType');
      
      return response.data['data']['hasPermission'] as bool;
    } catch (e) {
      throw _handleError(e);
    }
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
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      };
      
      if (permissionType != null) {
        queryParams['permissionType'] = permissionType;
      }
      
      final response = await _dio.get(
        '/user-permissions/admin/pending',
        queryParameters: queryParams,
      );
      
      final data = response.data['data'];
      return {
        'applications': (data['applications'] as List)
            .map((json) => UserPermissionModel.fromJson(json))
            .toList(),
        'pagination': data['pagination'],
      };
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// 审核权限申请
  Future<UserPermissionModel> reviewApplication(
    String permissionId,
    PermissionReviewRequest request,
  ) async {
    try {
      final response = await _dio.put(
        '/user-permissions/admin/review/$permissionId',
        data: request.toJson(),
      );
      
      return UserPermissionModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// 批量审核权限申请
  Future<Map<String, dynamic>> batchReviewApplications(
    BatchReviewRequest request,
  ) async {
    try {
      final response = await _dio.put(
        '/user-permissions/admin/batch-review',
        data: request.toJson(),
      );
      
      return response.data['data'];
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// 撤销用户权限
  Future<UserPermissionModel> revokePermission(
    String userId,
    String permissionType, {
    String? reason,
  }) async {
    try {
      final response = await _dio.put(
        '/user-permissions/admin/revoke/$userId/$permissionType',
        data: reason != null ? {'reason': reason} : null,
      );
      
      return UserPermissionModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// 直接授予权限
  Future<UserPermissionModel> grantPermission({
    required String userId,
    required String permissionType,
    String? comment,
  }) async {
    try {
      final response = await _dio.post(
        '/user-permissions/admin/grant',
        data: {
          'userId': userId,
          'permissionType': permissionType,
          if (comment != null) 'comment': comment,
        },
      );
      
      return UserPermissionModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// 获取权限统计信息
  Future<PermissionStatsModel> getPermissionStats() async {
    try {
      final response = await _dio.get('/user-permissions/admin/stats');
      
      return PermissionStatsModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// 获取指定用户的权限详情
  Future<List<UserPermissionModel>> getUserPermissionDetails(String userId) async {
    try {
      final response = await _dio.get('/user-permissions/admin/user/$userId');
      
      final List<dynamic> data = response.data['data'];
      return data.map((json) => UserPermissionModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // 错误处理
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response?.data != null) {
        final message = error.response!.data['message'] ?? '请求失败';
        return Exception(message);
      }
      return Exception('网络请求失败');
    }
    return Exception('未知错误: $error');
  }
}