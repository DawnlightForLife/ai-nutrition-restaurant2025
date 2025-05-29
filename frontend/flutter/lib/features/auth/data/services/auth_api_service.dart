import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

part 'auth_api_service.g.dart';

/// 认证API服务
/// 
/// 处理用户认证相关的网络请求
@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio) = _AuthApiService;

  /// 登录
  @POST('/auth/login')
  Future<HttpResponse<AuthResponse>> login(@Body() LoginRequest request);

  /// 注册
  @POST('/auth/register')
  Future<HttpResponse<AuthResponse>> register(@Body() RegisterRequest request);

  /// 发送验证码
  @POST('/auth/send-code')
  Future<HttpResponse<void>> sendVerificationCode(
    @Body() SendCodeRequest request,
  );

  /// 验证码登录
  @POST('/auth/login-with-code')
  Future<HttpResponse<AuthResponse>> loginWithCode(
    @Body() CodeLoginRequest request,
  );

  /// 刷新Token
  @POST('/auth/refresh')
  Future<HttpResponse<String>> refreshToken(@Body() RefreshTokenRequest request);

  /// 登出
  @POST('/auth/logout')
  Future<HttpResponse<void>> logout();

  /// 获取当前用户信息
  @GET('/auth/me')
  Future<HttpResponse<UserModel>> getCurrentUser();

  /// 验证Token
  @POST('/auth/verify-token')
  Future<HttpResponse<bool>> verifyToken(@Body() VerifyTokenRequest request);

  /// 忘记密码
  @POST('/auth/forgot-password')
  Future<HttpResponse<void>> forgotPassword(@Body() ForgotPasswordRequest request);

  /// 重置密码
  @POST('/auth/reset-password')
  Future<HttpResponse<void>> resetPassword(@Body() ResetPasswordRequest request);

  /// 修改密码
  @PUT('/auth/change-password')
  Future<HttpResponse<void>> changePassword(@Body() ChangePasswordRequest request);

  /// 绑定第三方账号
  @POST('/auth/bind-oauth')
  Future<HttpResponse<void>> bindOAuthAccount(@Body() BindOAuthRequest request);

  /// 解绑第三方账号
  @DELETE('/auth/unbind-oauth/{provider}')
  Future<HttpResponse<void>> unbindOAuthAccount(@Path() String provider);
}