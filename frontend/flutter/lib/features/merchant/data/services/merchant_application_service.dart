import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';

/// 商家申请服务
class MerchantApplicationService {
  final ApiClient _apiClient;

  MerchantApplicationService(this._apiClient);

  /// 提交商家申请
  Future<Map<String, dynamic>> submitApplication(Map<String, dynamic> applicationData) async {
    try {
      final response = await _apiClient.post('/merchants', data: applicationData);
      
      if (response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
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
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('查询失败：${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('网络错误：$e');
    }
  }

  /// 更新商家申请（用于被拒绝后重新提交）
  Future<Map<String, dynamic>> updateApplication(String applicationId, Map<String, dynamic> applicationData) async {
    try {
      final response = await _apiClient.put('/merchants/$applicationId', data: applicationData);
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('更新申请失败：${response.statusMessage}');
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

  /// 获取用户的商家申请记录
  Future<List<Map<String, dynamic>>> getUserApplications() async {
    debugPrint('开始获取用户商家申请记录...');
    try {
      final response = await _apiClient.get('/merchants/current');
      debugPrint('API响应状态: ${response.statusCode}');
      debugPrint('API响应数据: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        debugPrint('解析响应数据: success=${data['success']}, data类型=${data['data'].runtimeType}');
        
        if (data['success'] == true) {
          final responseData = data['data'];
          if (responseData is List) {
            final applications = responseData.map((item) => item as Map<String, dynamic>).toList();
            debugPrint('获取到 ${applications.length} 条商家申请记录');
            if (applications.isNotEmpty) {
              debugPrint('最新申请状态: ${applications.first['verification']?['verificationStatus']}');
            }
            return applications;
          } else {
            debugPrint('data不是List类型，实际类型: ${responseData.runtimeType}');
            debugPrint('data内容: $responseData');
            return [];
          }
        } else {
          debugPrint('API返回success=false: ${data['message']}');
          return [];
        }
      } else {
        throw Exception('查询失败：${response.statusMessage}');
      }
    } catch (e) {
      // 如果是网络错误，返回空列表而不是抛出异常
      debugPrint('获取用户商家申请记录失败: $e');
      return [];
    }
  }
}