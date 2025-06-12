import '../../../../core/network/api_client.dart';
import 'package:dio/dio.dart';

/// 商家申请服务（修复版）
class MerchantApplicationServiceFixed {
  final ApiClient _apiClient;

  MerchantApplicationServiceFixed(this._apiClient);

  /// 提交商家申请
  Future<Map<String, dynamic>> submitApplication(Map<String, dynamic> applicationData) async {
    try {
      final response = await _apiClient.post('/merchants', data: applicationData);
      
      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('申请提交失败：${response.statusMessage}');
      }
    } on DioException catch (e) {
      // 处理HTTP错误响应
      if (e.response != null && e.response!.data != null) {
        final errorData = e.response!.data;
        if (errorData is Map && errorData['message'] != null) {
          throw Exception(errorData['message']);
        }
      }
      throw Exception('网络错误：${e.message}');
    } catch (e) {
      throw Exception('网络错误：$e');
    }
  }

  /// 查询申请状态
  Future<Map<String, dynamic>> getApplicationStatus(String applicationId) async {
    try {
      final response = await _apiClient.get('/merchants/$applicationId');
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('查询失败：${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('网络错误：$e');
    }
  }

  /// 获取当前用户的商家申请记录（修复版）
  Future<List<Map<String, dynamic>>> getUserApplications() async {
    try {
      // 使用新的 /merchants/current 接口
      final response = await _apiClient.get('/merchants/current');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        return [];
      } else {
        throw Exception('查询失败：${response.statusMessage}');
      }
    } on DioException catch (e) {
      // 处理404或其他错误，返回空列表而不是抛出异常
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('网络错误：${e.message}');
    } catch (e) {
      // 对于其他错误，也考虑返回空列表
      print('获取用户商家申请失败：$e');
      return [];
    }
  }
}