import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_nutrition_restaurant/presentation/screens/auth/login_page.dart';
import 'package:ai_nutrition_restaurant/config/app_config.dart';

void main() {
  setUp(() {
    AppConfig.setEnvironment(Environment.dev);
  });
  
  group('LoginPage Widget Tests', () {
    testWidgets('应该显示所有必要的UI元素', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );
      
      // 验证标题
    
      expect(find.text('健康营养每一天'), findsOneWidget);
      
      // 验证输入框
      expect(find.byType(TextField), findsWidgets);
      
      // 验证登录按钮
      expect(find.text('获取验证码'), findsOneWidget);
      
      // 验证其他元素
      expect(find.text('《用户协议》'), findsOneWidget);
      expect(find.text('《隐私政策》'), findsOneWidget);
    });
    
    testWidgets('应该能够切换登录方式', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );
      
      // 初始状态应该是短信登录
      expect(find.text('获取验证码'), findsOneWidget);
      
      // 点击切换到密码登录
      await tester.tap(find.text('密码登录'));
      await tester.pumpAndSettle();
      
      // 应该显示密码登录按钮
      expect(find.text('登录'), findsOneWidget);
    });
    
    testWidgets('应该验证手机号格式', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );
      
      // 输入无效的手机号
      await tester.enterText(find.byType(TextField).first, '123');
      await tester.pump();
      
      // 登录按钮应该被禁用
      final loginButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, '获取验证码'),
      );
      expect(loginButton.onPressed, isNull);
      
      // 输入有效的手机号
      await tester.enterText(find.byType(TextField).first, '13800138000');
      await tester.pump();
      
      // 同意协议
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      
      // 登录按钮应该启用
      final enabledButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, '获取验证码'),
      );
      expect(enabledButton.onPressed, isNotNull);
    });
    
    testWidgets('应该显示国家/地区选择器', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );
      
      // 默认应该显示 +86
      expect(find.text('+86'), findsOneWidget);
      
      // 点击国家/地区选择器
      await tester.tap(find.text('+86'));
      await tester.pumpAndSettle();
      
      // 应该显示选项
      expect(find.text('中国大陆'), findsOneWidget);
      expect(find.text('中国香港'), findsOneWidget);
    });
    
    testWidgets('密码输入框应该能够切换显示/隐藏', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );
      
      // 切换到密码登录
      await tester.tap(find.text('密码登录'));
      await tester.pumpAndSettle();
      
      // 查找密码输入框
      final passwordField = find.byType(TextField).last;
      
      // 输入密码
      await tester.enterText(passwordField, 'password123');
      
      // 默认应该是隐藏状态
      TextField textField = tester.widget(passwordField);
      expect(textField.obscureText, isTrue);
      
      // 点击显示/隐藏按钮
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();
      
      // 现在应该显示密码
      textField = tester.widget(passwordField);
      expect(textField.obscureText, isFalse);
    });
  });
}