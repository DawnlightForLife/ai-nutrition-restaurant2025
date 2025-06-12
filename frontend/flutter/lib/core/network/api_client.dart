import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../error/error_handler.dart';
import '../../features/nutrition/data/datasources/nutrition_api.dart';
import '../../config/app_constants.dart';

/// API客户端
/// 负责与后端API的通信
class ApiClient {
  late final Dio _dio;
  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);

  ApiClient() {
    final baseUrl = AppConstants.apiBaseUrl;
    
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
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
      logPrint: (obj) {
        // 使用调试模式下的print输出，避免通过错误处理器记录正常日志
        if (kDebugMode) {
          print('[API] $obj');
        }
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 添加认证token
        await _addAuthToken(options);
        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (error, handler) {
        // 只记录真正的错误（4xx、5xx状态码）
        final statusCode = error.response?.statusCode;
        if (statusCode != null && statusCode >= 400) {
          GlobalErrorHandler.logError(
            'API Error: ${error.requestOptions.uri} [${error.requestOptions.method}] $statusCode',
            error: error,
          );
        }
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
  
  /// 添加认证token
  Future<void> _addAuthToken(RequestOptions options) async {
    // 不需要 token 的接口
    final noAuthPaths = [
      '/auth/send-code',
      '/auth/login',
      '/auth/login-with-code',
      '/auth/login/code',
      '/auth/register',
    ];

    final needAuth = !noAuthPaths.any((path) => options.path.contains(path));

    if (needAuth) {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');
      
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
  }

  /// 获取Dio实例
  Dio getDio() {
    return _dio;
  }
} 