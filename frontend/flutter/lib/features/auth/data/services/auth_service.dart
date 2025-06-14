import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/auth_state.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.read(dioClientProvider);
  return AuthService(dio);
});

class AuthService {
  final Dio _dio;
  
  AuthService(this._dio);
  
  /// 发送验证码
  Future<bool> sendVerificationCode(String phone) async {
    try {
      final response = await _dio.post('/auth/send-code', data: {
        'phone': phone,
      });
      
      return response.data['success'] == true;
    } catch (e) {
      print('发送验证码失败: $e');
      throw Exception('发送验证码失败: ${e.toString()}');
    }
  }
  
  /// 发送重置密码验证码
  Future<bool> sendPasswordResetCode(String phone) async {
    try {
      final response = await _dio.post('/auth/send-code', data: {
        'phone': phone,
        'type': 'reset',  // 指定为重置密码类型
      });
      
      return response.data['success'] == true;
    } catch (e) {
      print('发送重置密码验证码失败: $e');
      throw Exception('发送验证码失败: ${e.toString()}');
    }
  }
  
  /// 验证码登录（包含自动注册逻辑）
  Future<Map<String, dynamic>> loginWithCode(String phone, String code) async {
    try {
      final response = await _dio.post('/auth/login-with-code', data: {
        'phone': phone,
        'code': code,
      });
      
      if (response.data['success'] == true) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? '登录失败');
      }
    } catch (e) {
      print('验证码登录失败: $e');
      throw Exception('登录失败: ${e.toString()}');
    }
  }
  
  /// 密码登录
  Future<Map<String, dynamic>> loginWithPassword(String phone, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'phone': phone,
        'password': password,
      });
      
      if (response.data['success'] == true) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? '登录失败');
      }
    } catch (e) {
      print('密码登录失败: $e');
      throw Exception('登录失败: ${e.toString()}');
    }
  }
  
  /// 获取用户信息
  Future<UserInfo> getUserInfo(String token) async {
    try {
      final response = await _dio.get(
        '/auth/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      
      if (response.data['success'] == true) {
        return UserInfo.fromJson(response.data['user']);
      } else {
        throw Exception(response.data['message'] ?? '获取用户信息失败');
      }
    } catch (e) {
      print('获取用户信息失败: $e');
      throw Exception('获取用户信息失败: ${e.toString()}');
    }
  }
  
  /// 重置密码
  Future<bool> resetPassword(String phone, String code, String newPassword) async {
    try {
      final response = await _dio.post('/auth/reset-password', data: {
        'phone': phone,
        'code': code,
        'newPassword': newPassword,
      });
      
      return response.data['success'] == true;
    } catch (e) {
      print('重置密码失败: $e');
      throw Exception('重置密码失败: ${e.toString()}');
    }
  }
}