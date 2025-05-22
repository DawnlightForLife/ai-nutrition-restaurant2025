#!/bin/bash

# 确保在根目录运行
cd "$(dirname "$0")/.." || exit

# 创建砖块目录结构
mkdir -p brick/widget/__brick__/lib/components/{{category.snakeCase()}}

# 创建砖块配置
cat > brick/widget/brick.yaml << EOF
name: widget
description: 创建UI组件模板

vars:
  name:
    type: string
    description: 组件名称
    prompt: 请输入组件名称
  category:
    type: string
    description: 组件类别 (buttons, cards, inputs, indicators, navigation)
    prompt: 请输入组件类别
  description:
    type: string
    description: 组件描述
    prompt: 请输入组件描述
EOF

# 创建组件模板
cat > brick/widget/__brick__/lib/components/{{category.snakeCase()}}/{{name.snakeCase()}}.dart << EOF
import 'package:flutter/material.dart';

/// {{description}}
class {{name.pascalCase()}} extends StatelessWidget {
  /// 构造函数
  const {{name.pascalCase()}}({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('{{name.pascalCase()}}'),
      ),
    );
  }
}
EOF

# 创建组件测试模板
mkdir -p brick/widget/__brick__/test/components/{{category.snakeCase()}}

cat > brick/widget/__brick__/test/components/{{category.snakeCase()}}/{{name.snakeCase()}}_test.dart << EOF
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_nutrition_restaurant/components/{{category.snakeCase()}}/{{name.snakeCase()}}.dart';

void main() {
  testWidgets('{{name.pascalCase()}} - 基本渲染测试', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: {{name.pascalCase()}}(),
        ),
      ),
    );

    expect(find.text('{{name.pascalCase()}}'), findsOneWidget);
  });
}
EOF

# 创建组件Golden测试模板
mkdir -p brick/widget/__brick__/test/golden/components/{{category.snakeCase()}}

cat > brick/widget/__brick__/test/golden/components/{{category.snakeCase()}}/{{name.snakeCase()}}_golden_test.dart << EOF
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:ai_nutrition_restaurant/components/{{category.snakeCase()}}/{{name.snakeCase()}}.dart';

@Tags(['golden'])
void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('{{name.pascalCase()}} - 默认状态', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.phone,
      ])
      ..addScenario(
        widget: const Material(
          child: {{name.pascalCase()}}(),
        ),
        name: '{{name.pascalCase()}} 默认状态',
      );

    await tester.pumpDeviceBuilder(builder);
    await screenMatchesGolden(tester, '{{name.snakeCase()}}_default');
  });
}
EOF

# 创建Widgetbook测试模板
cat > brick/widget/__brick__/test/golden/components/{{category.snakeCase()}}/{{name.snakeCase()}}_widgetbook_test.dart << EOF
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook_test/widgetbook_test.dart';
import 'package:ai_nutrition_restaurant/components/{{category.snakeCase()}}/{{name.snakeCase()}}.dart';

@Tags(['golden'])
void main() {
  testGoldens('{{name.pascalCase()}} Golden Test', (tester) async {
    await testWidgetbookComponent(
      tester,
      name: '{{name.pascalCase()}}',
      useCase: '默认状态',
    );
  });
}
EOF

# 添加砖块到项目
echo "注册组件砖块到项目..."
mason add --source path brick/widget

echo "组件砖块已初始化。现在您可以使用以下命令创建新组件:"
echo "  mason make widget --name 组件名称 --category 组件类别 --description '组件描述'" 