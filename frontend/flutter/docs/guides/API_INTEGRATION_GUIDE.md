# API 集成指南

## 📋 目录

- [概述](#概述)
- [环境配置](#环境配置)
- [认证机制](#认证机制)
- [API 客户端](#api-客户端)
- [请求拦截器](#请求拦截器)
- [错误处理](#错误处理)
- [数据模型](#数据模型)
- [最佳实践](#最佳实践)

## 🎯 概述

本项目使用 **Retrofit** + **Dio** 进行 API 集成，支持自动代码生成、请求拦截、错误处理和缓存管理。

### 技术栈
- **Dio**: HTTP 客户端
- **Retrofit**: API 接口声明式定义
- **Json Annotation**: 序列化/反序列化
- **Build Runner**: 代码生成

## ⚙️ 环境配置

### API 基础配置
```dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'https://api.nutrition-ai.com';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // 环境配置
  static String get currentBaseUrl {
    switch (Environment.current) {
      case Environment.dev:
        return 'https://dev-api.nutrition-ai.com';
      case Environment.staging:
        return 'https://staging-api.nutrition-ai.com';
      case Environment.prod:
        return 'https://api.nutrition-ai.com';
    }
  }
}
```

### Dio 客户端配置
```dart
// lib/core/network/api_client.dart
class ApiClient {
  static Dio? _dio;
  
  static Dio get instance {
    if (_dio == null) {
      _dio = Dio(BaseOptions(
        baseUrl: ApiConfig.currentBaseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));
      
      _setupInterceptors(_dio!);
    }
    return _dio!;
  }
  
  static void _setupInterceptors(Dio dio) {
    dio.interceptors.addAll([
      AuthInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => debugPrint(object.toString()),
      ),
      ErrorInterceptor(),
      CacheInterceptor(),
    ]);
  }
  
  T getClient<T>() {
    switch (T) {
      case AuthApi:
        return AuthApi(instance) as T;
      case NutritionApi:
        return NutritionApi(instance) as T;
      case OrderApi:
        return OrderApi(instance) as T;
      default:
        throw Exception('Unknown API client type: $T');
    }
  }
}
```

## 🔐 认证机制

### JWT Token 管理
```dart
// lib/core/auth/token_manager.dart
class TokenManager {
  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }
  
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }
  
  static Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }
  
  static Future<bool> isTokenValid() async {
    final token = await getAccessToken();
    if (token == null) return false;
    
    try {
      final jwt = JWT.decode(token);
      final exp = jwt.payload['exp'] as int;
      final expDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return expDate.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }
}
```

### 认证拦截器
```dart
// lib/core/network/interceptors/auth_interceptor.dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 跳过认证的端点
    final skipAuth = options.extra['skipAuth'] == true;
    if (skipAuth) {
      return handler.next(options);
    }
    
    final token = await TokenManager.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token 过期，尝试刷新
      final refreshed = await _refreshToken();
      if (refreshed) {
        // 重试原请求
        final response = await _retryRequest(err.requestOptions);
        return handler.resolve(response);
      } else {
        // 刷新失败，清除 Token 并跳转到登录页
        await TokenManager.clearTokens();
        NavigationService.pushNamedAndClearStack('/login');
      }
    }
    
    handler.next(err);
  }
  
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await TokenManager.getRefreshToken();
      if (refreshToken == null) return false;
      
      final dio = Dio(); // 创建新的 Dio 实例避免循环
      final response = await dio.post(
        '${ApiConfig.currentBaseUrl}/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      
      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];
        
        await TokenManager.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
        
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }
  
  Future<Response> _retryRequest(RequestOptions options) async {
    final token = await TokenManager.getAccessToken();
    options.headers['Authorization'] = 'Bearer $token';
    
    final dio = Dio();
    return dio.fetch(options);
  }
}
```

## 📡 API 客户端

### Retrofit API 定义
```dart
// lib/features/auth/data/datasources/auth_api.dart
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;
  
  @POST('/auth/login')
  Future<HttpResponse<AuthResponse>> login(
    @Body() LoginRequest request,
  );
  
  @POST('/auth/register')
  Future<HttpResponse<AuthResponse>> register(
    @Body() RegisterRequest request,
  );
  
  @POST('/auth/logout')
  Future<HttpResponse<void>> logout();
  
  @POST('/auth/refresh')
  Future<HttpResponse<AuthResponse>> refreshToken(
    @Body() RefreshTokenRequest request,
  );
  
  @GET('/auth/me')
  Future<HttpResponse<UserResponse>> getCurrentUser();
  
  @POST('/auth/forgot-password')
  Future<HttpResponse<void>> forgotPassword(
    @Body() ForgotPasswordRequest request,
  );
  
  @POST('/auth/reset-password')
  Future<HttpResponse<void>> resetPassword(
    @Body() ResetPasswordRequest request,
  );
  
  @POST('/auth/verify-email')
  Future<HttpResponse<void>> verifyEmail(
    @Body() VerifyEmailRequest request,
  );
}
```

### 营养 API 定义
```dart
// lib/features/nutrition/data/datasources/nutrition_api.dart
@RestApi()
abstract class NutritionApi {
  factory NutritionApi(Dio dio) = _NutritionApi;
  
  @GET('/nutrition/profile/{userId}')
  Future<HttpResponse<NutritionProfileResponse>> getNutritionProfile(
    @Path('userId') String userId,
  );
  
  @PUT('/nutrition/profile/{userId}')
  Future<HttpResponse<NutritionProfileResponse>> updateNutritionProfile(
    @Path('userId') String userId,
    @Body() NutritionProfileRequest request,
  );
  
  @POST('/nutrition/recommendations')
  Future<HttpResponse<List<RecommendationResponse>>> getRecommendations(
    @Body() RecommendationRequest request,
  );
  
  @GET('/nutrition/foods/search')
  Future<HttpResponse<List<FoodItemResponse>>> searchFoods(
    @Query('q') String query,
    @Query('limit') int limit,
    @Query('offset') int offset,
  );
  
  @POST('/nutrition/intake')
  Future<HttpResponse<IntakeResponse>> recordIntake(
    @Body() IntakeRequest request,
  );
  
  @GET('/nutrition/intake/{userId}')
  Future<HttpResponse<List<IntakeResponse>>> getIntakeHistory(
    @Path('userId') String userId,
    @Query('start_date') String startDate,
    @Query('end_date') String endDate,
  );
  
  @POST('/nutrition/analyze')
  Future<HttpResponse<NutritionAnalysisResponse>> analyzeNutrition(
    @Body() NutritionAnalysisRequest request,
  );
}
```

## 🔧 请求拦截器

### 错误拦截器
```dart
// lib/core/network/interceptors/error_interceptor.dart
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final customError = _handleError(err);
    handler.next(DioException(
      requestOptions: err.requestOptions,
      error: customError,
      type: err.type,
      response: err.response,
    ));
  }
  
  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('连接超时，请检查网络连接');
        
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response!);
        
      case DioExceptionType.cancel:
        return NetworkException('请求已取消');
        
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NetworkException('网络连接失败，请检查网络设置');
        }
        return ServerException('未知错误：${error.message}');
        
      default:
        return ServerException('网络请求失败');
    }
  }
  
  AppException _handleResponseError(Response response) {
    final statusCode = response.statusCode;
    final data = response.data;
    
    String message = '请求失败';
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      message = data['message'];
    }
    
    switch (statusCode) {
      case 400:
        return ValidationException(message);
      case 401:
        return AuthException('认证失败，请重新登录');
      case 403:
        return AuthException('权限不足');
      case 404:
        return NetworkException('请求的资源不存在');
      case 422:
        return ValidationException(message);
      case 429:
        return NetworkException('请求过于频繁，请稍后再试');
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException('服务器错误，请稍后再试');
      default:
        return ServerException('HTTP $statusCode: $message');
    }
  }
}
```

### 缓存拦截器
```dart
// lib/core/network/interceptors/cache_interceptor.dart
class CacheInterceptor extends Interceptor {
  final CacheManager _cacheManager = CacheManager.instance;
  
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // 只缓存 GET 请求
    if (options.method != 'GET') {
      return handler.next(options);
    }
    
    final cacheKey = _generateCacheKey(options);
    final cachedResponse = _cacheManager.get(cacheKey);
    
    if (cachedResponse != null && !_isCacheExpired(cachedResponse)) {
      // 返回缓存的响应
      final response = Response(
        requestOptions: options,
        data: cachedResponse.data,
        statusCode: 200,
        headers: Headers.fromMap(cachedResponse.headers),
      );
      return handler.resolve(response);
    }
    
    handler.next(options);
  }
  
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // 缓存成功的 GET 响应
    if (response.requestOptions.method == 'GET' && 
        response.statusCode == 200) {
      final cacheKey = _generateCacheKey(response.requestOptions);
      _cacheManager.put(
        cacheKey,
        CachedResponse(
          data: response.data,
          headers: response.headers.map,
          timestamp: DateTime.now(),
        ),
      );
    }
    
    handler.next(response);
  }
  
  String _generateCacheKey(RequestOptions options) {
    final uri = options.uri.toString();
    final queryParams = options.queryParameters.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    return '$uri?$queryParams';
  }
  
  bool _isCacheExpired(CachedResponse cached) {
    const cacheTimeout = Duration(minutes: 5);
    return DateTime.now().difference(cached.timestamp) > cacheTimeout;
  }
}
```

## 📊 数据模型

### 请求模型
```dart
// lib/features/auth/data/models/login_request.dart
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  final String? deviceId;
  final String? deviceName;
  
  const LoginRequest({
    required this.email,
    required this.password,
    this.deviceId,
    this.deviceName,
  });
  
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
      
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
```

### 响应模型
```dart
// lib/features/auth/data/models/auth_response.dart
@JsonSerializable()
class AuthResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;
  
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  
  final UserResponse user;
  
  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });
  
  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
      
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
```

### 统一响应格式
```dart
// lib/core/network/models/api_response.dart
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? meta;
  final List<ValidationError>? errors;
  
  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.meta,
    this.errors,
  });
  
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
  
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}
```

## 🏗️ Repository 实现

### 基础 Repository
```dart
// lib/core/network/base_repository.dart
abstract class BaseRepository {
  Future<Either<Failure, T>> safeApiCall<T>(
    Future<HttpResponse<T>> Function() apiCall,
  ) async {
    try {
      final response = await apiCall();
      
      if (response.response.statusCode == 200 ||
          response.response.statusCode == 201) {
        return Right(response.data);
      } else {
        return Left(ServerFailure('请求失败'));
      }
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(ServerFailure('未知错误: $e'));
    }
  }
  
  Failure _handleDioException(DioException e) {
    if (e.error is AppException) {
      final appException = e.error as AppException;
      return ServerFailure(appException.message);
    }
    
    return ServerFailure('网络请求失败');
  }
}
```

### 具体 Repository 实现
```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthApi _authApi;
  
  AuthRepositoryImpl(this._authApi);
  
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    return safeApiCall(() async {
      final request = LoginRequest(
        email: email,
        password: password,
        deviceId: await DeviceInfo.getDeviceId(),
        deviceName: await DeviceInfo.getDeviceName(),
      );
      
      final response = await _authApi.login(request);
      
      // 保存 Token
      await TokenManager.saveTokens(
        accessToken: response.data.accessToken,
        refreshToken: response.data.refreshToken,
      );
      
      // 转换为领域模型
      return HttpResponse(
        response.data.user.toDomain(),
        response.response,
      );
    });
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    return safeApiCall(() async {
      final response = await _authApi.logout();
      
      // 清除本地 Token
      await TokenManager.clearTokens();
      
      return response;
    });
  }
}
```

## 💡 最佳实践

### 1. API 接口设计
```dart
// ✅ 好的 API 设计
@RestApi()
abstract class UserApi {
  // 明确的路径参数
  @GET('/users/{id}')
  Future<HttpResponse<UserResponse>> getUser(@Path() String id);
  
  // 使用查询参数进行过滤
  @GET('/users')
  Future<HttpResponse<List<UserResponse>>> getUsers(
    @Query('page') int page,
    @Query('limit') int limit,
    @Query('search') String? search,
  );
  
  // 使用请求体传递复杂数据
  @POST('/users')
  Future<HttpResponse<UserResponse>> createUser(
    @Body() CreateUserRequest request,
  );
}
```

### 2. 错误处理策略
```dart
// ✅ 统一的错误处理
Future<Either<Failure, T>> performApiCall<T>(
  Future<HttpResponse<T>> Function() apiCall,
) async {
  try {
    final response = await apiCall();
    return Right(response.data);
  } on DioException catch (e) {
    if (e.error is AppException) {
      return Left(ServerFailure(e.error.message));
    }
    return Left(NetworkFailure('网络请求失败'));
  } catch (e) {
    return Left(UnknownFailure('未知错误'));
  }
}
```

### 3. 缓存策略
```dart
// 不同类型的数据使用不同的缓存策略
class CacheConfig {
  // 用户信息 - 长时间缓存
  static const Duration userProfileCache = Duration(hours: 1);
  
  // 推荐数据 - 中等时间缓存
  static const Duration recommendationsCache = Duration(minutes: 30);
  
  // 搜索结果 - 短时间缓存
  static const Duration searchResultsCache = Duration(minutes: 5);
  
  // 实时数据 - 不缓存
  static const Duration realtimeDataCache = Duration.zero;
}
```

### 4. 请求重试机制
```dart
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  
  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = err.requestOptions.extra['retry_count'] ?? 0;
    
    if (retryCount < maxRetries && _shouldRetry(err)) {
      await Future.delayed(retryDelay * (retryCount + 1));
      
      err.requestOptions.extra['retry_count'] = retryCount + 1;
      
      try {
        final response = await Dio().fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }
    
    handler.next(err);
  }
  
  bool _shouldRetry(DioException err) {
    // 只重试网络错误或服务器错误
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           (err.response?.statusCode ?? 0) >= 500;
  }
}
```

### 5. 环境配置管理
```dart
enum Environment {
  dev,
  staging,
  prod,
}

class EnvironmentConfig {
  static Environment _current = Environment.dev;
  
  static Environment get current => _current;
  
  static void setEnvironment(Environment env) {
    _current = env;
  }
  
  static String get apiBaseUrl {
    switch (_current) {
      case Environment.dev:
        return 'https://dev-api.example.com';
      case Environment.staging:
        return 'https://staging-api.example.com';
      case Environment.prod:
        return 'https://api.example.com';
    }
  }
  
  static bool get enableLogging => _current != Environment.prod;
  static bool get enableCaching => true;
  static Duration get cacheTimeout => 
      _current == Environment.dev ? Duration(minutes: 1) : Duration(minutes: 5);
}
```

## 🔍 调试技巧

### 1. 网络请求日志
```dart
// 详细的请求日志
LogInterceptor(
  request: true,
  requestHeader: true,
  requestBody: true,
  responseHeader: false,
  responseBody: true,
  error: true,
  logPrint: (object) {
    // 自定义日志格式
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[$timestamp] $object');
  },
)
```

### 2. Mock 数据调试
```dart
class MockInterceptor extends Interceptor {
  final bool enableMock;
  
  MockInterceptor({required this.enableMock});
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enableMock && _shouldMock(options)) {
      final mockResponse = _getMockResponse(options);
      return handler.resolve(mockResponse);
    }
    
    handler.next(options);
  }
  
  bool _shouldMock(RequestOptions options) {
    // 根据 URL 或其他条件决定是否使用 Mock
    return options.path.contains('/users/');
  }
  
  Response _getMockResponse(RequestOptions options) {
    // 返回 Mock 数据
    return Response(
      requestOptions: options,
      data: {'id': '1', 'name': 'Mock User'},
      statusCode: 200,
    );
  }
}
```

### 3. 性能监控
```dart
class PerformanceInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['start_time'] = DateTime.now();
    handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['start_time'] as DateTime;
    final duration = DateTime.now().difference(startTime);
    
    debugPrint('API ${response.requestOptions.path} took ${duration.inMilliseconds}ms');
    
    // 如果请求时间过长，记录警告
    if (duration.inSeconds > 5) {
      debugPrint('⚠️ Slow API request detected: ${response.requestOptions.path}');
    }
    
    handler.next(response);
  }
}
```

---

**📚 相关文档**
- [Dio 官方文档](https://pub.dev/packages/dio)
- [Retrofit 使用指南](https://pub.dev/packages/retrofit)
- [JSON 序列化指南](https://flutter.dev/docs/development/data-and-backend/json)