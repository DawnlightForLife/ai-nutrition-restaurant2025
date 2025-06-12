import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

/// 管理员商家服务
class AdminMerchantService {
  final ApiClient _apiClient;

  AdminMerchantService(this._apiClient);

  /// 获取商家列表
  Future<Map<String, dynamic>> getMerchants({
    String? verificationStatus,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.merchants,
        queryParameters: {
          if (verificationStatus != null) 'verificationStatus': verificationStatus,
          'skip': (page - 1) * limit,
          'limit': limit,
        },
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取商家详情
  Future<Map<String, dynamic>> getMerchantDetail(String merchantId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.merchants}/$merchantId',
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 审批商家
  Future<Map<String, dynamic>> verifyMerchant(
    String merchantId, {
    required String verificationStatus,
    String? rejectionReason,
  }) async {
    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.merchants}/$merchantId/verify',
        data: {
          'verificationStatus': verificationStatus,
          if (rejectionReason != null) 'rejectionReason': rejectionReason,
        },
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取商家统计数据
  Future<Map<String, dynamic>> getMerchantStats() async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.merchants}/stats',
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 处理错误
  Exception _handleError(DioException error) {
    if (error.response != null) {
      final message = error.response?.data?['message'] ?? '请求失败';
      return Exception(message);
    }
    return Exception('网络连接失败');
  }
}