import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../dtos/user_model.dart';

part 'auth_api.g.dart';

/// 认证相关API接口定义
/// 使用Retrofit自动生成网络请求代码
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  /// 发送验证码
  @POST('/auth/send-code')
  Future<HttpResponse<Map<String, dynamic>>> sendVerificationCode(
    @Body() Map<String, dynamic> body,
  );

  /// 验证码登录
  @POST('/auth/login-by-code')
  Future<HttpResponse<UserModel>> loginWithCode(
    @Body() Map<String, dynamic> body,
  );

  /// 刷新Token
  @POST('/auth/refresh-token')
  Future<HttpResponse<Map<String, dynamic>>> refreshToken(
    @Body() Map<String, dynamic> body,
  );

  /// 登出
  @POST('/auth/logout')
  Future<HttpResponse<void>> logout();

  /// 获取当前用户信息
  @GET('/user/profile')
  Future<HttpResponse<UserModel>> getCurrentUser();

  /// 更新用户信息
  @PUT('/user/profile')
  Future<HttpResponse<UserModel>> updateProfile(
    @Body() Map<String, dynamic> body,
  );
}