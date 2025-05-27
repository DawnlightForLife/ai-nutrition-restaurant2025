import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/environment/environment.dart';
import '../exceptions/app_exceptions.dart';

/// 单例 Dio 客户端
class DioClient {
  static DioClient? _instance;
  late final Dio _dio;
  
  DioClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Environment.apiBaseUrl,
        connectTimeout: const Duration(milliseconds: Environment.apiTimeout),
        receiveTimeout: const Duration(milliseconds: Environment.apiTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 添加拦截器
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(ErrorInterceptor());
    
    if (Environment.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
        error: true,
      ));
    }
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  Dio get dio => _dio;
}

/// 认证拦截器
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 不需要 token 的接口
    final noAuthPaths = [
      '/auth/send-code',
      '/auth/login',
      '/auth/login-with-code',
      '/auth/register',
    ];

    final needAuth = !noAuthPaths.any((path) => options.path.contains(path));

    if (needAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    super.onRequest(options, handler);
  }
}

/// 错误拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    
    if (response != null) {
      final statusCode = response.statusCode;
      final data = response.data;
      String message = '请求失败';
      
      if (data is Map && data.containsKey('message')) {
        message = data['message'] as String;
      }

      switch (statusCode) {
        case 400:
          throw BadRequestException(message);
        case 401:
          throw UnauthorizedException(message);
        case 403:
          throw ForbiddenException(message);
        case 404:
          throw NotFoundException(message);
        case 422:
          throw ValidationException(message, data is Map ? (data['errors'] as Map<String, dynamic>? ?? {}) : {});
        case 500:
          throw ServerException(message);
        default:
          throw ApiException(message, statusCode);
      }
    }

    // 网络错误
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException('网络连接超时，请检查网络设置');
      case DioExceptionType.connectionError:
        throw NetworkException('网络连接失败，请检查网络设置');
      case DioExceptionType.cancel:
        throw NetworkException('请求已取消');
      default:
        throw NetworkException('网络错误，请稍后重试');
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 处理业务错误
    final data = response.data;
    if (data is Map && data.containsKey('success') && data['success'] == false) {
      final message = (data['message'] as String?) ?? '操作失败';
      throw ApiException(message, response.statusCode ?? 0);
    }
    
    super.onResponse(response, handler);
  }
}