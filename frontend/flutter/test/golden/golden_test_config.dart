import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

// Golden 测试配置
class GoldenTestConfig {
  // 设备配置
  static const devices = [
    Device(
      name: 'iPhone14',
      size: Size(390, 844),
      devicePixelRatio: 3.0,
    ),
    Device(
      name: 'iPhone14Pro',
      size: Size(393, 852),
      devicePixelRatio: 3.0,
    ),
    Device(
      name: 'iPadPro',
      size: Size(1024, 1366),
      devicePixelRatio: 2.0,
    ),
    Device(
      name: 'AndroidPhone',
      size: Size(412, 869),
      devicePixelRatio: 2.625,
    ),
    Device(
      name: 'AndroidTablet',
      size: Size(800, 1280),
      devicePixelRatio: 2.0,
    ),
  ];
  
  // 配置 Golden 测试
  static Future<void> setupGoldenTests() async {
    return GoldenToolkit.runWithConfiguration(
      () async {
        await loadAppFonts();
      },
      config: GoldenToolkitConfiguration(
        // 跳过实际的黄金测试，仅在 CI 中运行
        skipGoldenAssertion: () => !isRunningInCI,
        // 自定义文件名称模式
        fileNameFactory: (name) => 'goldens/$name.png',
        // 默认设备
        defaultDevices: devices,
        // 启用真实阴影
        enableRealShadows: true,
      ),
    );
  }
  
  // 检查是否在 CI 环境中运行
  static bool get isRunningInCI {
    return const bool.fromEnvironment('CI', defaultValue: false);
  }
}

// 包装器小部件，用于 Golden 测试
class GoldenTestWrapper extends StatelessWidget {
  final Widget child;
  final ThemeData? theme;
  final Size? size;
  
  const GoldenTestWrapper({
    Key? key,
    required this.child,
    this.theme,
    this.size,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    Widget content = MaterialApp(
      theme: theme ?? ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Material(
        child: child,
      ),
    );
    
    if (size != null) {
      content = SizedBox(
        width: size!.width,
        height: size!.height,
        child: content,
      );
    }
    
    return content;
  }
}

// 场景构建器
class GoldenScenarioBuilder {
  final String name;
  final Widget Function(BuildContext) builder;
  final String? description;
  
  const GoldenScenarioBuilder({
    required this.name,
    required this.builder,
    this.description,
  });
}