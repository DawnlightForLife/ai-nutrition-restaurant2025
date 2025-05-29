import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

/// 认证响应模型
@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    /// 访问Token
    @JsonKey(name: 'access_token') required String accessToken,
    
    /// 刷新Token
    @JsonKey(name: 'refresh_token') required String refreshToken,
    
    /// Token类型
    @JsonKey(name: 'token_type') @Default('Bearer') String tokenType,
    
    /// 过期时间（秒）
    @JsonKey(name: 'expires_in') required int expiresIn,
    
    /// 用户信息
    required UserModel user,
    
    /// 权限列表
    @Default([]) List<String> permissions,
    
    /// 角色列表
    @Default([]) List<String> roles,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

/// 登录响应扩展
extension AuthResponseExtension on AuthResponse {
  /// 是否是管理员
  bool get isAdmin => roles.contains('admin') || roles.contains('super_admin');
  
  /// 是否是营养师
  bool get isNutritionist => roles.contains('nutritionist');
  
  /// 是否是商家
  bool get isMerchant => roles.contains('merchant');
  
  /// 获取Token过期时间
  DateTime get tokenExpiryTime => 
      DateTime.now().add(Duration(seconds: expiresIn));
  
  /// 检查是否有指定权限
  bool hasPermission(String permission) => permissions.contains(permission);
  
  /// 检查是否有指定角色
  bool hasRole(String role) => roles.contains(role);
}