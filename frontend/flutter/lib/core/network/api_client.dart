import 'package:dio/dio.dart';
import '../error/error_handler.dart';
import 'package:retrofit/retrofit.dart';

/// API客户端
/// 负责与后端API的通信
class ApiClient {
  late final Dio _dio;
  
  static const String _baseUrl = 'http://10.0.2.2:8080/api';
  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // 添加拦截器
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => GlobalErrorHandler.logInfo(obj.toString()),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 可以在这里添加认证token
        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (error, handler) {
        GlobalErrorHandler.logError(
          'API Error',
          error: error,
          context: {
            'url': error.requestOptions.uri.toString(),
            'method': error.requestOptions.method,
            'statusCode': error.response?.statusCode,
          },
        );
        handler.next(error);
      },
    ));
  }

  /// 创建Retrofit API客户端
  T getClient<T>(Type type, {String? baseUrl}) {
    if (baseUrl != null) {
      _dio.options.baseUrl = baseUrl;
    }
    
    // 利用Retrofit的工厂构造函数创建API客户端实例
    if (type == NutritionApi) {
      return NutritionApi.create(this, baseUrl: baseUrl) as T;
    }
    
    throw ArgumentError('不支持的API类型: $type');
  }

  /// GET请求
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }

  /// POST请求
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }

  /// PUT请求
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }

  /// DELETE请求
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }

  /// 设置认证token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// 清除认证token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
  
  /// 获取Dio实例
  Dio getDio() {
    return _dio;
  }
} 