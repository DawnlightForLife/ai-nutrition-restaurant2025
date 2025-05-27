import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../api/api_client.dart';
import '../dtos/user_dto.dart';

/// 认证数据源
/// 负责认证相关的API调用
@Injectable()
class AuthDatasource {
  final ApiClient _apiClient;

  AuthDatasource(this._apiClient);

  /// 手机号验证码登录
  Future<AuthResponseDto> signInWithPhoneAndCode({
    required String phone,
    required String code,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login-with-code',
      data: {
        'phone': phone,
        'code': code,
      },
    );

    if (response.data == null) {
      throw Exception('响应数据为空');
    }

    return AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// 手机号密码登录
  Future<AuthResponseDto> signInWithPhoneAndPassword({
    required String phone,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'phone': phone,
        'password': password,
      },
    );

    if (response.data == null) {
      throw Exception('响应数据为空');
    }

    return AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// 邮箱密码登录
  Future<AuthResponseDto> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.data == null) {
      throw Exception('响应数据为空');
    }

    return AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// 用户注册
  Future<AuthResponseDto> signUp({
    required String email,
    required String phone,
    required String password,
    required String nickname,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'email': email,
        'phone': phone,
        'password': password,
        'nickname': nickname,
      },
    );

    if (response.data == null) {
      throw Exception('响应数据为空');
    }

    return AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// 发送验证码
  Future<void> sendVerificationCode(String phone) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/auth/send-verification-code',
      data: {
        'phone': phone,
      },
    );
  }

  /// 重置密码
  Future<void> resetPassword({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/auth/reset-password',
      data: {
        'phone': phone,
        'code': code,
        'newPassword': newPassword,
      },
    );
  }

  /// 修改密码
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _apiClient.put(
      '/auth/change-password',
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );
  }

  /// 验证token
  Future<UserDto> verifyToken(String token) async {
    final response = await _apiClient.get(
      '/auth/verify-token',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.data == null) {
      throw Exception('响应数据为空');
    }

    final data = response.data as Map<String, dynamic>;
    return UserDto.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// 刷新token
  Future<AuthResponseDto> refreshToken(String refreshToken) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/refresh-token',
      data: {
        'refreshToken': refreshToken,
      },
    );

    if (response.data == null) {
      throw Exception('响应数据为空');
    }

    return AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
  }
} 