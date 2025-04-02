# Flutter 错误处理指南

本文档提供智慧AI营养餐厅Flutter项目的错误处理规范和最佳实践，确保应用程序能够优雅地处理各种错误情况，提供良好的用户体验，并便于开发团队诊断和修复问题。

## 错误类型分类

在应用中，我们将错误分为以下几类：

### 1. 网络错误

- 连接超时
- 服务器错误（500系列）
- API响应格式错误
- 无网络连接
- DNS解析失败

### 2. 业务逻辑错误

- 权限不足
- 业务规则验证失败
- 重复操作
- 资源不存在
- 资源状态异常

### 3. 数据错误

- 数据解析错误
- 类型不匹配
- 必要数据缺失
- 数据验证失败

### 4. UI交互错误

- 无效输入
- 表单验证错误
- 操作冲突
- 用户操作中断

### 5. 系统错误

- 存储空间不足
- 权限被拒绝（摄像头、位置等）
- 应用崩溃
- 硬件访问异常

## 错误处理层级

错误应该在合适的层级被处理：

### 1. Repository层

主要处理网络和数据错误：

```dart
class UserRepository {
  Future<User> getUserProfile() async {
    try {
      final response = await _apiClient.get('/user/profile');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException('网络连接超时，请检查网络设置或稍后重试');
      } else if (e.response?.statusCode == 401) {
        throw AuthException('登录已过期，请重新登录');
      } else if (e.response?.statusCode == 403) {
        throw PermissionException('您没有权限执行此操作');
      } else if (e.response?.statusCode == 404) {
        throw ResourceNotFoundException('请求的资源不存在');
      } else if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
        throw ServerException('服务器暂时不可用，请稍后重试');
      } else {
        throw NetworkException('网络请求失败: ${e.message}');
      }
    } on FormatException catch (_) {
      throw DataParsingException('数据格式错误，无法解析服务器响应');
    } catch (e) {
      throw UnknownException('获取用户资料时发生未知错误: $e');
    }
  }
}
```

### 2. Service层

主要处理业务逻辑错误：

```dart
class OrderService {
  Future<Order> placeOrder(Cart cart, Address address) async {
    // 业务逻辑验证
    if (cart.items.isEmpty) {
      throw BusinessException('购物车为空，无法下单');
    }
    
    if (!address.isValid) {
      throw ValidationException('配送地址无效，请检查地址信息');
    }
    
    try {
      final order = await _orderRepository.createOrder(cart, address);
      return order;
    } on NetworkException catch (e) {
      // 可以在这里对特定错误进行转换或添加上下文
      throw e;
    } on ServerException catch (e) {
      throw BusinessException('服务器处理订单请求失败: ${e.message}');
    } catch (e) {
      throw BusinessException('创建订单时发生错误: $e');
    }
  }
}
```

### 3. Provider/ViewModel层

处理UI相关错误和用户反馈：

```dart
class OrderProvider extends ChangeNotifier {
  Order? _order;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  Order? get order => _order;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  Future<bool> placeOrder(Cart cart, Address address) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _order = await _orderService.placeOrder(cart, address);
      _isLoading = false;
      notifyListeners();
      return true;
    } on BusinessException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } on ValidationException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = '下单失败: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
```

### 4. UI层

展示错误信息并提供恢复选项：

```dart
class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        return Scaffold(
          appBar: AppBar(title: Text('结算')),
          body: orderProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : orderProvider.errorMessage != null
              ? ErrorView(
                  message: orderProvider.errorMessage!,
                  onRetry: () => _submitOrder(context),
                )
              : CheckoutForm(onSubmit: () => _submitOrder(context)),
        );
      },
    );
  }
  
  Future<void> _submitOrder(BuildContext context) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userProvider = Provider.of<UserProfileProvider>(context, listen: false);
    
    final success = await orderProvider.placeOrder(
      cartProvider.cart, 
      userProvider.selectedAddress,
    );
    
    if (success) {
      cartProvider.clearCart();
      Navigator.pushReplacementNamed(context, '/order-success');
    }
  }
}
```

## 标准异常类型

为确保错误处理一致性，我们定义以下标准异常类：

```dart
/// 应用异常基类
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() => message;
}

/// 网络相关异常
class NetworkException extends AppException {
  NetworkException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// 服务器异常
class ServerException extends AppException {
  ServerException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// 认证异常
class AuthException extends AppException {
  AuthException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// 权限异常
class PermissionException extends AppException {
  PermissionException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// 资源不存在异常
class ResourceNotFoundException extends AppException {
  ResourceNotFoundException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// 数据解析异常
class DataParsingException extends AppException {
  DataParsingException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// 业务规则异常
class BusinessException extends AppException {
  BusinessException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// 数据验证异常
class ValidationException extends AppException {
  ValidationException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// 未知异常
class UnknownException extends AppException {
  UnknownException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}
```

## 错误信息展示

### 1. 错误提示组件

创建一套统一的错误UI组件：

```dart
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? actionText;
  final IconData icon;

  const ErrorView({
    Key? key,
    required this.message,
    this.onRetry,
    this.actionText,
    this.icon = Icons.error_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.error),
            SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh),
                label: Text(actionText ?? '重试'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### 2. Snackbar提示

对于非致命性错误，使用Snackbar展示简短提示：

```dart
void showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: '关闭',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}
```

### 3. 对话框提示

对于需要用户明确知晓或做出决策的错误：

```dart
Future<void> showErrorDialog(
  BuildContext context, 
  String title, 
  String message, {
  String? actionText,
  VoidCallback? onAction,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('关闭'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          if (onAction != null)
            TextButton(
              child: Text(actionText ?? '确定'),
              onPressed: () {
                Navigator.of(context).pop();
                onAction();
              },
            ),
        ],
      );
    },
  );
}
```

## 错误上报机制

为了监控应用质量和快速响应用户问题，我们实现错误上报机制：

### 1. 错误上报服务

```dart
class ErrorReportingService {
  final String _apiEndpoint = 'https://api.nutritionapp.com/error-reports';
  final ApiClient _apiClient;
  final DeviceInfoService _deviceInfo;
  
  ErrorReportingService(this._apiClient, this._deviceInfo);
  
  Future<void> reportError(
    dynamic error, 
    StackTrace stackTrace, {
    String? context,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final deviceInfo = await _deviceInfo.getDeviceInfo();
      final appInfo = await _deviceInfo.getAppInfo();
      
      final errorReport = {
        'timestamp': DateTime.now().toIso8601String(),
        'appVersion': appInfo.version,
        'buildNumber': appInfo.buildNumber,
        'platform': deviceInfo.platform,
        'deviceModel': deviceInfo.model,
        'osVersion': deviceInfo.osVersion,
        'errorType': error.runtimeType.toString(),
        'errorMessage': error.toString(),
        'stackTrace': stackTrace.toString(),
        'context': context,
        'additionalData': additionalData,
      };
      
      await _apiClient.post(_apiEndpoint, data: errorReport);
    } catch (e) {
      // 错误上报失败时，记录到本地日志
      print('Error reporting failed: $e');
    }
  }
}
```

### 2. 全局错误处理

在应用入口设置全局错误捕获：

```dart
void main() {
  // 捕获Flutter框架错误
  FlutterError.onError = (FlutterErrorDetails details) {
    // 本地记录错误
    print('Flutter Error: ${details.exception}');
    print('Stack trace: ${details.stack}');
    
    // 上报错误
    final errorReporter = GetIt.instance<ErrorReportingService>();
    errorReporter.reportError(
      details.exception, 
      details.stack ?? StackTrace.empty,
      context: 'Flutter框架错误',
    );
    
    // 在开发环境继续抛出以便查看红屏错误
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  };
  
  // 捕获异步错误
  PlatformDispatcher.instance.onError = (error, stack) {
    // 本地记录错误
    print('Async Error: $error');
    print('Stack trace: $stack');
    
    // 上报错误
    final errorReporter = GetIt.instance<ErrorReportingService>();
    errorReporter.reportError(
      error, 
      stack,
      context: '异步错误',
    );
    
    // 返回true表示错误已处理
    return true;
  };
  
  runApp(const MyApp());
}
```

### 3. 错误上报中间件

为网络请求添加错误上报中间件：

```dart
class ErrorReportingInterceptor extends Interceptor {
  final ErrorReportingService _errorReporter;
  
  ErrorReportingInterceptor(this._errorReporter);
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 上报网络错误
    _errorReporter.reportError(
      err,
      StackTrace.current,
      context: '网络请求失败',
      additionalData: {
        'url': err.requestOptions.uri.toString(),
        'method': err.requestOptions.method,
        'statusCode': err.response?.statusCode,
        'responseData': err.response?.data,
      },
    );
    
    // 继续错误处理流程
    handler.next(err);
  }
}
```

## 错误恢复策略

在错误发生后，提供恢复路径帮助用户继续使用应用：

### 1. 自动重试

对于网络错误，可以实现自动重试机制：

```dart
Future<T> retryRequest<T>(Future<T> Function() request, {
  int maxRetries = 3,
  Duration delay = const Duration(seconds: 1),
}) async {
  int attempts = 0;
  while (true) {
    try {
      attempts++;
      return await request();
    } on NetworkException catch (e) {
      if (attempts >= maxRetries) {
        rethrow;
      }
      
      // 指数退避策略
      final backoffDelay = delay * attempts;
      await Future.delayed(backoffDelay);
      
      // 继续重试
      continue;
    }
  }
}
```

### 2. 离线缓存

提供离线模式维持基本功能：

```dart
class CachedRepository<T> {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;
  final String _cacheKey;
  final T Function(Map<String, dynamic>) _fromJson;
  final Map<String, dynamic> Function(T) _toJson;
  
  CachedRepository(
    this._apiClient,
    this._localStorage,
    this._cacheKey,
    this._fromJson,
    this._toJson,
  );
  
  Future<T> getData(String endpoint) async {
    try {
      // 尝试从API获取最新数据
      final response = await _apiClient.get(endpoint);
      final data = _fromJson(response.data);
      
      // 更新缓存
      await _localStorage.saveData(_cacheKey, _toJson(data));
      
      return data;
    } on NetworkException catch (_) {
      // 网络错误时，尝试读取缓存
      final cachedData = await _localStorage.getData(_cacheKey);
      if (cachedData != null) {
        return _fromJson(cachedData);
      }
      
      // 没有缓存时，重新抛出异常
      rethrow;
    }
  }
}
```

### 3. 用户引导恢复

为用户提供明确的恢复路径：

```dart
class NetworkErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  
  const NetworkErrorView({
    Key? key, 
    required this.message, 
    required this.onRetry,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.signal_wifi_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh),
            label: Text('重试'),
          ),
          TextButton(
            onPressed: () {
              AppSettings.openWifiSettings();
            },
            child: Text('打开网络设置'),
          ),
        ],
      ),
    );
  }
}
```

## 测试错误场景

编写专门的测试来验证错误处理行为：

### 1. 单元测试错误处理

```dart
void main() {
  group('OrderService Tests', () {
    late OrderService orderService;
    late MockOrderRepository mockOrderRepository;
    
    setUp(() {
      mockOrderRepository = MockOrderRepository();
      orderService = OrderService(mockOrderRepository);
    });
    
    test('placeOrder throws BusinessException when cart is empty', () async {
      // Arrange
      final emptyCart = Cart(items: []);
      final address = Address(/* Valid address details */);
      
      // Act & Assert
      expect(
        () => orderService.placeOrder(emptyCart, address),
        throwsA(isA<BusinessException>().having(
          (e) => e.message, 
          'message', 
          contains('购物车为空'),
        )),
      );
    });
    
    test('placeOrder handles network exceptions properly', () async {
      // Arrange
      final cart = Cart(items: [CartItem(/* Valid cart item */)]);
      final address = Address(/* Valid address details */);
      
      when(() => mockOrderRepository.createOrder(any(), any()))
          .thenThrow(NetworkException('网络连接超时'));
      
      // Act & Assert
      expect(
        () => orderService.placeOrder(cart, address),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
```

### 2. Widget测试错误UI

```dart
void main() {
  testWidgets('ErrorView displays message and retry button', (WidgetTester tester) async {
    bool retryPressed = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorView(
            message: '加载失败，请重试',
            onRetry: () {
              retryPressed = true;
            },
          ),
        ),
      ),
    );
    
    // 验证错误消息显示
    expect(find.text('加载失败，请重试'), findsOneWidget);
    
    // 验证重试按钮存在
    expect(find.byIcon(Icons.refresh), findsOneWidget);
    
    // 点击重试按钮
    await tester.tap(find.byType(ElevatedButton));
    
    // 验证回调函数被调用
    expect(retryPressed, true);
  });
}
```

### 3. 集成测试错误流程

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('User can recover from network error during checkout', (WidgetTester tester) async {
    // 启动应用
    app.main();
    await tester.pumpAndSettle();
    
    // 模拟登录流程
    // ...
    
    // 添加商品到购物车
    // ...
    
    // 进入结算页面
    await tester.tap(find.text('结算'));
    await tester.pumpAndSettle();
    
    // 模拟断网
    await NetworkOverride.disconnect();
    
    // 尝试提交订单
    await tester.tap(find.text('提交订单'));
    await tester.pumpAndSettle();
    
    // 验证错误视图显示
    expect(find.byType(NetworkErrorView), findsOneWidget);
    expect(find.text('网络连接失败，请检查网络设置'), findsOneWidget);
    
    // 模拟恢复网络
    await NetworkOverride.reconnect();
    
    // 点击重试
    await tester.tap(find.text('重试'));
    await tester.pumpAndSettle();
    
    // 验证订单成功提交
    expect(find.text('订单已提交'), findsOneWidget);
  });
}
```

## 最佳实践总结

1. **使用自定义异常类**：创建应用专用的异常类层次结构，提供清晰的错误类型
2. **适当位置处理异常**：在正确的架构层处理相应的异常类型
3. **用户友好的错误消息**：转换技术错误为用户可理解的信息
4. **提供恢复路径**：为每种错误提供明确的恢复选项
5. **分层错误处理**：Repository层处理数据和网络错误，Service层处理业务逻辑错误，UI层展示错误
6. **错误上报**：收集错误信息以便改进应用质量
7. **离线支持**：实现缓存策略以支持离线或网络不稳定情况
8. **全面测试**：测试正常流程和错误流程
9. **保持一致性**：使用统一的错误UI组件和交互模式

## 错误处理检查清单

开发新功能时，确保考虑以下错误处理方面：

- [ ] 是否处理了所有可能的错误情况？
- [ ] 错误信息是否用户友好？
- [ ] 是否提供了恢复路径？
- [ ] 是否在正确的层级处理错误？
- [ ] 是否需要上报错误？
- [ ] 错误是否会泄露敏感信息？
- [ ] 是否考虑了离线场景？
- [ ] 是否写了测试验证错误处理？ 