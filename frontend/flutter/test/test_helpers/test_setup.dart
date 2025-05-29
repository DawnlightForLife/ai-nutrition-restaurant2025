/// 测试设置辅助工具
/// 
/// 提供统一的测试环境初始化和配置
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mockito/mockito.dart';

import '../../lib/core/router/app_router.dart';
import '../../lib/core/error/centralized_error_handler.dart';
import '../../lib/core/events/centralized_event_bus.dart';
import '../../lib/shared/themes/app_theme.dart';

/// 测试设置辅助类
class TestSetup {
  static late ProviderContainer _container;
  static late AppRouter _router;

  /// 初始化测试环境
  static void initialize() {
    // 初始化 Provider 容器
    _container = ProviderContainer();
    
    // 初始化路由
    _router = AppRouter();
    
    // 初始化错误处理器
    CentralizedErrorHandler.instance.initialize();
    
    // 初始化事件总线
    // CentralizedEventBus 是单例，无需初始化
  }

  /// 清理测试环境
  static void dispose() {
    _container.dispose();
    CentralizedErrorHandler.instance.dispose();
    CentralizedEventBus.instance.dispose();
  }

  /// 创建测试应用包装器
  static Widget createTestApp({
    required Widget child,
    List<Override>? overrides,
    bool includeRouter = false,
    ThemeData? theme,
  }) {
    Widget app = child;

    // 添加主题
    app = MaterialApp(
      theme: theme ?? AppTheme.lightTheme,
      home: app,
    );

    // 添加路由（如果需要）
    if (includeRouter) {
      app = MaterialApp.router(
        routerConfig: _router.config(),
        theme: theme ?? AppTheme.lightTheme,
      );
    }

    // 添加 Riverpod
    app = ProviderScope(
      overrides: overrides ?? [],
      child: app,
    );

    return app;
  }

  /// 创建带路由的测试应用
  static Widget createTestAppWithRouter({
    String initialRoute = '/',
    List<Override>? overrides,
    ThemeData? theme,
  }) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp.router(
        routerConfig: _router.config(
          // TODO: 设置初始路由
        ),
        theme: theme ?? AppTheme.lightTheme,
      ),
    );
  }

  /// 泵送组件并等待动画完成
  static Future<void> pumpAndSettle(
    WidgetTester tester,
    Widget widget, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle(timeout);
  }

  /// 查找组件
  static Finder findByKey(String key) => find.byKey(Key(key));
  static Finder findByText(String text) => find.text(text);
  static Finder findByType<T>() => find.byType(T);
  static Finder findByIcon(IconData icon) => find.byIcon(icon);

  /// 点击组件
  static Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// 输入文本
  static Future<void> enterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  /// 滚动到组件
  static Future<void> scrollUntilVisible(
    WidgetTester tester,
    Finder finder,
    Finder scrollable, {
    double delta = 100.0,
  }) async {
    await tester.scrollUntilVisible(finder, delta, scrollable: scrollable);
    await tester.pumpAndSettle();
  }

  /// 验证组件存在
  static void expectToFind(Finder finder, {int count = 1}) {
    expect(finder, findsNWidgets(count));
  }

  /// 验证组件不存在
  static void expectNotToFind(Finder finder) {
    expect(finder, findsNothing);
  }

  /// 验证文本存在
  static void expectText(String text, {int count = 1}) {
    expectToFind(find.text(text), count: count);
  }

  /// 验证组件类型存在
  static void expectWidget<T>({int count = 1}) {
    expectToFind(find.byType(T), count: count);
  }
}

/// 测试用的 Mock 类基类
class MockBase extends Mock {}

/// 常用的测试工具类
class TestUtils {
  /// 创建测试用的异步值
  static AsyncValue<T> createAsyncValue<T>(T data) {
    return AsyncValue.data(data);
  }

  /// 创建测试用的异步加载状态
  static AsyncValue<T> createAsyncLoading<T>() {
    return const AsyncValue.loading();
  }

  /// 创建测试用的异步错误状态
  static AsyncValue<T> createAsyncError<T>(Object error, [StackTrace? stack]) {
    return AsyncValue.error(error, stack ?? StackTrace.current);
  }

  /// 等待异步操作完成
  static Future<void> waitFor(Duration duration) {
    return Future.delayed(duration);
  }

  /// 模拟网络延迟
  static Future<T> simulateNetworkDelay<T>(T result, [Duration? delay]) async {
    await Future.delayed(delay ?? const Duration(milliseconds: 300));
    return result;
  }

  /// 模拟网络错误
  static Future<T> simulateNetworkError<T>([String? message]) async {
    await Future.delayed(const Duration(milliseconds: 100));
    throw Exception(message ?? 'Network error');
  }
}

/// 测试数据工厂
class TestDataFactory {
  /// 创建测试用户数据
  static Map<String, dynamic> createUserData({
    String? id,
    String? name,
    String? email,
  }) {
    return {
      'id': id ?? 'test_user_id',
      'name': name ?? 'Test User',
      'email': email ?? 'test@example.com',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// 创建测试订单数据
  static Map<String, dynamic> createOrderData({
    String? id,
    String? userId,
    double? amount,
  }) {
    return {
      'id': id ?? 'test_order_id',
      'userId': userId ?? 'test_user_id',
      'amount': amount ?? 99.99,
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// 创建测试营养档案数据
  static Map<String, dynamic> createNutritionProfileData({
    String? id,
    String? userId,
    int? age,
    double? height,
    double? weight,
  }) {
    return {
      'id': id ?? 'test_profile_id',
      'userId': userId ?? 'test_user_id',
      'age': age ?? 25,
      'height': height ?? 170.0,
      'weight': weight ?? 65.0,
      'activityLevel': 'moderate',
      'healthGoals': ['lose_weight'],
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}

/// 测试组
void testGroup(String description, void Function() body) {
  group(description, () {
    setUpAll(() {
      TestSetup.initialize();
    });

    tearDownAll(() {
      TestSetup.dispose();
    });

    body();
  });
}

/// 组件测试
void testWidget(
  String description,
  Future<void> Function(WidgetTester) body, {
  bool? skip,
  dynamic tags,
}) {
  testWidgets(description, (tester) async {
    TestSetup.initialize();
    
    try {
      await body(tester);
    } finally {
      TestSetup.dispose();
    }
  }, skip: skip, tags: tags);
}