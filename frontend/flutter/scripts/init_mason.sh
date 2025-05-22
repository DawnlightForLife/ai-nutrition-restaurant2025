#!/bin/bash

# 确保在根目录运行
cd "$(dirname "$0")/.." || exit

# 确保Mason已安装
command -v mason >/dev/null 2>&1 || {
  echo "安装 Mason CLI..."
  dart pub global activate mason_cli
}

# 初始化Mason
echo "初始化Mason..."
mason init

# 创建砖块目录结构
mkdir -p brick/feature_module/__brick__/lib/features/{{name.snakeCase()}}/{data/repositories,domain/{repositories,usecases},presentation/{providers,pages}}

# 创建砖块配置
cat > brick/feature_module/brick.yaml << EOF
name: feature_module
description: 创建新功能模块的标准架构

vars:
  name:
    type: string
    description: 模块名称
    prompt: 请输入模块名称
  description:
    type: string
    description: 模块描述
    prompt: 请输入模块描述
EOF

# 创建仓库实现模板
cat > brick/feature_module/__brick__/lib/features/{{name.snakeCase()}}/data/repositories/{{name.snakeCase()}}_repository_impl.dart << EOF
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/{{name.snakeCase()}}_repository.dart';

@Injectable(as: {{name.pascalCase()}}Repository)
class {{name.pascalCase()}}RepositoryImpl implements {{name.pascalCase()}}Repository {
  {{name.pascalCase()}}RepositoryImpl();
  
  // TODO: 实现具体方法
}
EOF

# 创建仓库接口模板
cat > brick/feature_module/__brick__/lib/features/{{name.snakeCase()}}/domain/repositories/{{name.snakeCase()}}_repository.dart << EOF
abstract class {{name.pascalCase()}}Repository {
  // TODO: 定义仓库接口
}
EOF

# 创建用例模板
cat > brick/feature_module/__brick__/lib/features/{{name.snakeCase()}}/domain/usecases/get_{{name.snakeCase()}}.dart << EOF
import 'package:injectable/injectable.dart';
import '../repositories/{{name.snakeCase()}}_repository.dart';

@injectable
class Get{{name.pascalCase()}} {
  final {{name.pascalCase()}}Repository repository;

  Get{{name.pascalCase()}}(this.repository);

  Future<void> call() async {
    // TODO: 实现用例逻辑
  }
}
EOF

# 创建Provider模板
cat > brick/feature_module/__brick__/lib/features/{{name.snakeCase()}}/presentation/providers/{{name.snakeCase()}}_provider.dart << EOF
import 'package:flutter/material.dart';

class {{name.pascalCase()}}Provider extends ChangeNotifier {
  // TODO: 实现状态管理逻辑
  
  void initialize() {
    // 初始化逻辑
  }
}
EOF

# 创建页面模板
cat > brick/feature_module/__brick__/lib/features/{{name.snakeCase()}}/presentation/pages/{{name.snakeCase()}}_page.dart << EOF
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/{{name.snakeCase()}}_provider.dart';

class {{name.pascalCase()}}Page extends StatelessWidget {
  const {{name.pascalCase()}}Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => {{name.pascalCase()}}Provider(),
      child: const _{{name.pascalCase()}}View(),
    );
  }
}

class _{{name.pascalCase()}}View extends StatelessWidget {
  const _{{name.pascalCase()}}View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<{{name.pascalCase()}}Provider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{name.titleCase()}}'),
      ),
      body: Center(
        child: Text('{{description}}'),
      ),
    );
  }
}
EOF

# 添加砖块到项目
echo "注册砖块到项目..."
mason add --source path brick/feature_module

echo "Mason 环境已初始化。现在您可以使用以下命令创建新模块:"
echo "  mason make feature_module --name 模块名称 --description '模块描述'"
echo "或使用便捷脚本:"
echo "  ./scripts/create_module.sh 模块名称 '模块描述'" 