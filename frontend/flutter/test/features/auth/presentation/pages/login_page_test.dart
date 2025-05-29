/// 登录页面组件测试
/// 
/// 示例组件测试文件，展示如何测试页面组件
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../test_helpers/test_setup.dart';
import '../../../../../lib/features/auth/presentation/pages/login_page.dart';
import '../../../../../lib/features/auth/presentation/providers/auth_controller.dart';

void main() {
  testGroup('LoginPage Widget Tests', () {
    
    testWidget('应该显示登录表单元素', (tester) async {
      // 安排
      const widget = LoginPage();
      
      final testApp = TestSetup.createTestApp(
        child: widget,
        overrides: [
          // TODO: 添加测试用的 Provider 覆盖
        ],
      );

      // 执行
      await TestSetup.pumpAndSettle(tester, testApp);

      // 验证
      // 检查页面标题
      TestSetup.expectText('登录');
      
      // 检查表单字段
      TestSetup.expectToFind(find.byType(TextFormField), count: 2);
      
      // 检查登录按钮
      TestSetup.expectText('登录');
      
      // 检查注册链接
      TestSetup.expectText('还没有账户？注册');
      
      // 检查忘记密码链接
      TestSetup.expectText('忘记密码？');
    });

    testWidget('输入有效凭据并点击登录按钮应该触发登录', (tester) async {
      // 安排
      bool loginCalled = false;
      
      const widget = LoginPage();
      
      final testApp = TestSetup.createTestApp(
        child: widget,
        overrides: [
          // TODO: Mock auth controller
          // authControllerProvider.overrideWith((ref) => MockAuthController()),
        ],
      );

      // 执行
      await TestSetup.pumpAndSettle(tester, testApp);

      // 输入邮箱
      await TestSetup.enterText(
        tester,
        find.byKey(const Key('email_field')),
        'test@example.com',
      );

      // 输入密码
      await TestSetup.enterText(
        tester,
        find.byKey(const Key('password_field')),
        'password123',
      );

      // 点击登录按钮
      await TestSetup.tap(
        tester,
        find.byKey(const Key('login_button')),
      );

      // 验证
      // TODO: 验证登录方法被调用
      // expect(loginCalled, true);
    });

    testWidget('输入无效邮箱应该显示验证错误', (tester) async {
      // 安排
      const widget = LoginPage();
      
      final testApp = TestSetup.createTestApp(
        child: widget,
      );

      // 执行
      await TestSetup.pumpAndSettle(tester, testApp);

      // 输入无效邮箱
      await TestSetup.enterText(
        tester,
        find.byKey(const Key('email_field')),
        'invalid-email',
      );

      // 输入密码
      await TestSetup.enterText(
        tester,
        find.byKey(const Key('password_field')),
        'password123',
      );

      // 点击登录按钮
      await TestSetup.tap(
        tester,
        find.byKey(const Key('login_button')),
      );

      // 验证错误消息
      TestSetup.expectText('请输入有效的邮箱地址');
    });

    testWidget('空密码应该显示验证错误', (tester) async {
      // 安排
      const widget = LoginPage();
      
      final testApp = TestSetup.createTestApp(
        child: widget,
      );

      // 执行
      await TestSetup.pumpAndSettle(tester, testApp);

      // 输入邮箱
      await TestSetup.enterText(
        tester,
        find.byKey(const Key('email_field')),
        'test@example.com',
      );

      // 不输入密码，直接点击登录
      await TestSetup.tap(
        tester,
        find.byKey(const Key('login_button')),
      );

      // 验证错误消息
      TestSetup.expectText('请输入密码');
    });

    testWidget('登录加载状态应该显示加载指示器', (tester) async {
      // 安排
      const widget = LoginPage();
      
      final testApp = TestSetup.createTestApp(
        child: widget,
        overrides: [
          // TODO: Mock loading state
          // authControllerProvider.overrideWith((ref) => AsyncValue.loading()),
        ],
      );

      // 执行
      await TestSetup.pumpAndSettle(tester, testApp);

      // 验证加载指示器
      TestSetup.expectWidget<CircularProgressIndicator>();
    });

    testWidget('登录错误应该显示错误消息', (tester) async {
      // 安排
      const widget = LoginPage();
      
      final testApp = TestSetup.createTestApp(
        child: widget,
        overrides: [
          // TODO: Mock error state
          // authControllerProvider.overrideWith((ref) => 
          //   AsyncValue.error('登录失败', StackTrace.current)),
        ],
      );

      // 执行
      await TestSetup.pumpAndSettle(tester, testApp);

      // 验证错误消息
      TestSetup.expectText('登录失败');
    });

    testWidget('点击注册链接应该导航到注册页面', (tester) async {
      // 安排
      const widget = LoginPage();
      
      final testApp = TestSetup.createTestAppWithRouter(
        initialRoute: '/login',
      );

      // 执行
      await TestSetup.pumpAndSettle(tester, testApp);

      // 点击注册链接
      await TestSetup.tap(
        tester,
        find.byKey(const Key('register_link')),
      );

      // 验证导航
      // TODO: 验证路由变化
      // expect(GoRouter.of(tester.element(find.byType(LoginPage))).location, '/register');
    });

    testWidget('点击忘记密码链接应该导航到重置密码页面', (tester) async {
      // 安排
      const widget = LoginPage();
      
      final testApp = TestSetup.createTestAppWithRouter(
        initialRoute: '/login',
      );

      // 执行
      await TestSetup.pumpAndSettle(tester, testApp);

      // 点击忘记密码链接
      await TestSetup.tap(
        tester,
        find.byKey(const Key('forgot_password_link')),
      );

      // 验证导航
      // TODO: 验证路由变化
      // expect(GoRouter.of(tester.element(find.byType(LoginPage))).location, '/reset-password');
    });
  });
}