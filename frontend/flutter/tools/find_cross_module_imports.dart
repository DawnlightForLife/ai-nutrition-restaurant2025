#!/usr/bin/env dart

/// 查找跨模块导入工具
/// 
/// 快速查找项目中所有的跨模块导入
/// 使用方法: dart run tools/find_cross_module_imports.dart
library;

import 'dart:io';

class CrossModuleImportFinder {
  final Map<String, List<String>> crossImports = {};
  int totalImports = 0;

  Future<void> run() async {
    print('🔍 查找跨模块导入...\n');

    final libDir = Directory('lib/features');
    if (!await libDir.exists()) {
      print('❌ 找不到 lib/features 目录');
      exit(1);
    }

    // 遍历所有模块
    await for (final moduleDir in libDir.list()) {
      if (moduleDir is Directory) {
        final moduleName = moduleDir.path.split('/').last;
        await _checkModule(moduleName, moduleDir);
      }
    }

    // 输出结果
    _printResults();
  }

  Future<void> _checkModule(String moduleName, Directory moduleDir) async {
    await for (final entity in moduleDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        await _checkFile(moduleName, entity);
      }
    }
  }

  Future<void> _checkFile(String currentModule, File file) async {
    // 跳过生成的文件
    if (file.path.contains('.g.dart') || 
        file.path.contains('.freezed.dart')) {
      return;
    }

    final lines = await file.readAsLines();
    final filePath = file.path.replaceAll('\\', '/');
    
    for (final line in lines) {
      if (line.trim().startsWith('import ')) {
        final importedModule = _getImportedModule(line);
        if (importedModule != null && 
            importedModule != currentModule &&
            importedModule != 'core' &&
            importedModule != 'shared') {
          
          final key = '$currentModule → $importedModule';
          crossImports.putIfAbsent(key, () => []).add(filePath);
          totalImports++;
        }
      }
    }
  }

  String? _getImportedModule(String importLine) {
    final regex = RegExp('import\\s+["\']package:ai_nutrition_restaurant/features/([^/]+)');
    final match = regex.firstMatch(importLine);
    return match?.group(1);
  }

  void _printResults() {
    if (crossImports.isEmpty) {
      print('✅ 未发现跨模块导入！');
      return;
    }

    print('📊 发现 $totalImports 个跨模块导入:\n');
    
    // 按模块分组显示
    crossImports.forEach((key, files) {
      print('$key (${files.length} 个文件)');
      for (final file in files.take(3)) {
        print('  - ${file.replaceFirst('lib/features/', '')}');
      }
      if (files.length > 3) {
        print('  ... 还有 ${files.length - 3} 个文件');
      }
      print('');
    });

    // 生成迁移建议
    print('\n💡 迁移建议:');
    print('1. 将共享的实体移至 lib/shared/domain/');
    print('2. 使用事件总线进行模块间通信');
    print('3. 通过 Facade 层聚合跨模块业务逻辑');
  }
}

void main() async {
  final finder = CrossModuleImportFinder();
  await finder.run();
}