import 'user_model.dart';

/// 登录响应DTO
class LoginResponse {
  final bool success;
  final String? message;
  final String token;
  final UserModel user;
  
  LoginResponse({
    required this.success,
    this.message,
    required this.token,
    required this.user,
  });
  
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? true,
      message: json['message'],
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'token': token,
      'user': user.toJson(),
    };
  }
}