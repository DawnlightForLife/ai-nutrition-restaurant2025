import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:ai_nutrition_restaurant/config/theme/yuanqi_colors.dart';
import '../golden_test_config.dart';

void main() {
  setUpAll(() async {
    await GoldenTestConfig.setupGoldenTests();
  });

  group('Button Golden Tests', () {
    testGoldens('元气立方按钮组件', (tester) async {
      final builder = GoldenBuilder.grid(
        columns: 2,
        widthToHeightRatio: 1,
      )
        ..addScenario(
          '主要按钮 - 启用',
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: YuanqiColors.primaryOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('登录'),
          ),
        )
        ..addScenario(
          '主要按钮 - 禁用',
          ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('登录'),
          ),
        )
        ..addScenario(
          '次要按钮',
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: YuanqiColors.primaryOrange,
              side: const BorderSide(color: YuanqiColors.primaryOrange),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('注册'),
          ),
        )
        ..addScenario(
          '文字按钮',
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: YuanqiColors.primaryOrange,
            ),
            child: const Text('忘记密码？'),
          ),
        )
        ..addScenario(
          '渐变按钮',
          Container(
            decoration: BoxDecoration(
              gradient: YuanqiColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                '立即体验',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
        ..addScenario(
          '图标按钮',
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite),
            color: YuanqiColors.primaryOrange,
            iconSize: 32,
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
        surfaceSize: const Size(600, 400),
      );

      await screenMatchesGolden(tester, 'yuanqi_buttons');
    });

    testGoldens('按钮状态变化', (tester) async {
      final buttonKey = GlobalKey();
      
      await tester.pumpWidgetBuilder(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  key: buttonKey,
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: YuanqiColors.primaryOrange,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                  ),
                  child: const Text(
                    '点击我',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            );
          },
        ),
        wrapper: (child) => GoldenTestWrapper(child: child),
        surfaceSize: const Size(300, 200),
      );

      // 正常状态
      await screenMatchesGolden(tester, 'button_normal');

      // 注意：在测试中模拟悬停状态比较复杂，这里只测试正常状态
    });
  });
}