import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_nutrition_restaurant/presentation/screens/auth/login_page.dart';
import 'package:ai_nutrition_restaurant/config/theme/yuanqi_colors.dart';
import '../../golden_test_config.dart';

void main() {
  setUpAll(() async {
    await GoldenTestConfig.setupGoldenTests();
  });

  group('LoginPage Golden Tests', () {
    testGoldens('登录页面 - 默认状态', (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: GoldenTestConfig.devices)
        ..addScenario(
          widget: const ProviderScope(
            child: LoginPage(),
          ),
          name: 'default',
        );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'login_page_default');
    });

    testGoldens('登录页面 - 不同状态', (tester) async {
      final builder = GoldenBuilder.grid(
        columns: 2,
        widthToHeightRatio: 1,
      )
        ..addScenario(
          '短信登录模式',
          const ProviderScope(
            child: LoginPage(),
          ),
        )
        ..addScenario(
          '密码登录模式',
          ProviderScope(
            child: Builder(
              builder: (context) {
                return const LoginPage();
              },
            ),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => GoldenTestWrapper(
          theme: ThemeData(
            primaryColor: YuanqiColors.primaryOrange,
            colorScheme: ColorScheme.fromSeed(
              seedColor: YuanqiColors.primaryOrange,
            ),
          ),
          child: child,
        ),
        surfaceSize: const Size(800, 1200),
      );

      await screenMatchesGolden(tester, 'login_page_states');
    });

    testGoldens('登录页面 - 输入状态', (tester) async {
      await tester.pumpWidgetBuilder(
        const ProviderScope(
          child: LoginPage(),
        ),
        wrapper: (child) => GoldenTestWrapper(child: child),
        surfaceSize: const Size(390, 844),
      );

      // 输入手机号
      await tester.enterText(
        find.byType(TextField).first,
        '13800138000',
      );
      await tester.pump();

      await screenMatchesGolden(tester, 'login_page_with_phone');
    });

    testGoldens('登录页面 - 错误状态', (tester) async {
      await tester.pumpWidgetBuilder(
        ProviderScope(
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: Column(
                  children: [
                    const Expanded(child: LoginPage()),
                    Container(
                      color: Colors.red.shade100,
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        '错误: 手机号格式不正确',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        wrapper: (child) => GoldenTestWrapper(child: child),
        surfaceSize: const Size(390, 844),
      );

      await screenMatchesGolden(tester, 'login_page_error_state');
    });
  });
}