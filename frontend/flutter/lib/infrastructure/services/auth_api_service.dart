import 'package:dio/dio.dart';
import '../dtos/login_response_dto.dart';
import '../dtos/user_model.dart';
import '../../core/network/dio_client.dart';

class AuthApiService {
  final Dio _dio = DioClient.instance.dio;
  
  // 发送验证码
  Future<bool> sendVerificationCode(String phone) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/send-code',
      data: {
        'phone': phone,
      },
    );
    
    print('发送验证码API响应: ${response.data}');
    final success = response.data?['success'] == true;
    print('发送验证码API成功状态: $success');
    return success;
  }
  
  // 验证码登录
  Future<LoginResponse> loginWithCode(String phone, String code) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login-with-code',
      data: {
        'phone': phone,
        'code': code,
      },
    );
    
    print('Login response success: ${response.data?['success']}');
    print('Login response message: ${response.data?['message']}');
    
    try {
      final loginResponse = LoginResponse.fromJson(response.data as Map<String, dynamic>);
      print('登录响应解析成功');
      return loginResponse;
    } catch (e) {
      print('登录响应解析失败: $e');
      // 尝试手动构建响应
      final userData = response.data?['user'] as Map<String, dynamic>?;
      if (userData != null) {
        try {
          final user = UserModel.fromJson(userData);
          return LoginResponse(
            success: response.data?['success'] ?? true,
            message: response.data?['message'],
            token: response.data?['token'] as String,
            user: user,
          );
        } catch (userError) {
          print('用户数据解析失败: $userError');
          rethrow;
        }
      }
      rethrow;
    }
  }
  
  // 密码登录
  Future<LoginResponse> loginWithPassword(String phone, String password) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'phone': phone,
        'password': password,
      },
    );
    
    return LoginResponse.fromJson(response.data as Map<String, dynamic>);
  }
  
  // 验证Token
  Future<bool> verifyToken(String token) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/auth/verify-token',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      
      return response.data?['success'] == true;
    } catch (e) {
      return false;
    }
  }
  
  // 获取当前用户信息
  Future<UserModel> getCurrentUser(String token) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/auth/me',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    
    return UserModel.fromJson(response.data?['user'] as Map<String, dynamic>);
  }
}