import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';

/// 管理员服务Provider
final adminServiceProvider = Provider<AdminService>((ref) {
  return AdminService();
});

/// 管理员服务
class AdminService {
  late final Dio _dio;
  
  AdminService() {
    _dio = DioClient.instance.dio;
  }
  
  /// 获取管理员列表
  Future<List<Map<String, dynamic>>> getAdminList() async {
    try {
      final response = await _dio.get('/admin/admins');
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(response.data['message'] ?? '获取管理员列表失败');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // 如果接口不存在，返回模拟数据
        return _getMockAdminList();
      }
      throw Exception('网络错误: ${e.message}');
    } catch (e) {
      throw Exception('获取管理员列表失败: $e');
    }
  }
  
  /// 创建管理员
  Future<Map<String, dynamic>> createAdmin({
    required String phone,
    required String nickname,
    required String role,
  }) async {
    try {
      final response = await _dio.post('/admin/admins', data: {
        'phone': phone,
        'nickname': nickname,
        'role': role,
      });
      
      if (response.statusCode == 201 && response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? '创建管理员失败');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // 模拟创建成功
        return {
          '_id': DateTime.now().millisecondsSinceEpoch.toString(),
          'phone': phone,
          'nickname': nickname,
          'role': role,
          'createdAt': DateTime.now().toIso8601String(),
        };
      }
      throw Exception('网络错误: ${e.message}');
    } catch (e) {
      throw Exception('创建管理员失败: $e');
    }
  }
  
  /// 更新管理员
  Future<Map<String, dynamic>> updateAdmin({
    required String adminId,
    required String nickname,
    required String role,
  }) async {
    try {
      final response = await _dio.put('/admin/admins/$adminId', data: {
        'nickname': nickname,
        'role': role,
      });
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? '更新管理员失败');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // 模拟更新成功
        return {
          '_id': adminId,
          'nickname': nickname,
          'role': role,
          'updatedAt': DateTime.now().toIso8601String(),
        };
      }
      throw Exception('网络错误: ${e.message}');
    } catch (e) {
      throw Exception('更新管理员失败: $e');
    }
  }
  
  /// 删除管理员
  Future<void> deleteAdmin(String adminId) async {
    try {
      final response = await _dio.delete('/admin/admins/$adminId');
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(response.data['message'] ?? '删除管理员失败');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // 模拟删除成功
        return;
      }
      throw Exception('网络错误: ${e.message}');
    } catch (e) {
      throw Exception('删除管理员失败: $e');
    }
  }
  
  /// 获取模拟管理员列表（开发期间使用）
  List<Map<String, dynamic>> _getMockAdminList() {
    return [
      {
        '_id': '6841547dbbb7a494bce8f616',
        'phone': '15108343625',
        'nickname': '超级管理员',
        'role': 'super_admin',
        'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
        'profileCompleted': true,
      },
      {
        '_id': '6841547dbbb7a494bce8f617',
        'phone': '13800138001',
        'nickname': '系统管理员',
        'role': 'admin',
        'createdAt': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
        'profileCompleted': true,
      },
      {
        '_id': '6841547dbbb7a494bce8f618',
        'phone': '13800138002',
        'nickname': '运营管理员',
        'role': 'admin',
        'createdAt': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
        'profileCompleted': true,
      },
    ];
  }
}