#!/usr/bin/env dart

/// 模块边界检查工具
/// 
/// 检查项目中是否存在违反模块边界的导入
/// 使用方法: dart run tools/check_boundaries.dart
library;

import 'dart:io';

/// 违规类型
enum ViolationType {
  crossModuleImport('跨模块导入'),
  wrongLayerImport('错误的层级导入'),
  circularDependency('循环依赖'),
  ;

  const ViolationType(this.description);
  final String description;
}

/// 违规记录
class Violation {
  const Violation({
    required this.file,
    required this.line,
    required this.importStatement,
    required this.type,
    required this.message,
  });

  final String file;
  final int line;
  final String importStatement;
  final ViolationType type;
  final String message;

  @override
  String toString() {
    return '$file:$line - ${type.description}: $message\n  导入语句: $importStatement';
  }
}

class BoundaryChecker {
  final List<Violation> violations = [];
  int filesChecked = 0;

  /// 运行边界检查
  Future<void> run() async {
    print('🔍 开始检查模块边界...\n');

    final libDir = Directory('lib');
    if (!await libDir.exists()) {
      print('❌ 找不到 lib 目录');
      exit(1);
    }

    await _checkDirectory(libDir);

    print('\n📊 检查结果:');
    print('  检查文件数: $filesChecked');
    print('  违规数量: ${violations.length}');

    if (violations.isEmpty) {
      print('\n✅ 未发现模块边界违规！');
      exit(0);
    } else {
      print('\n❌ 发现以下违规:\n');
      for (final violation in violations) {
        print(violation);
        print('');
      }
      exit(1);
    }
  }

  /// 检查目录
  Future<void> _checkDirectory(Directory dir) async {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        await _checkFile(entity);
      }
    }
  }

  /// 检查文件
  Future<void> _checkFile(File file) async {
    // 跳过生成的文件
    if (file.path.contains('.g.dart') || 
        file.path.contains('.freezed.dart') ||
        file.path.contains('.gr.dart')) {
      return;
    }

    filesChecked++;
    
    final lines = await file.readAsLines();
    final filePath = file.path.replaceAll('\\', '/');
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trim().startsWith('import ')) {
        _checkImport(filePath, i + 1, line);
      }
    }
  }

  /// 检查导入语句
  void _checkImport(String filePath, int lineNumber, String importLine) {
    // 提取导入路径
    final regex = RegExp('import\\s+["\']([^"\']+)["\']');
    final match = regex.firstMatch(importLine);
    if (match == null) return;
    
    final importPath = match.group(1)!;
    
    // 跳过 Dart 和 Flutter 包
    if (importPath.startsWith('dart:') || 
        importPath.startsWith('flutter/') ||
        !importPath.startsWith('package:ai_nutrition_restaurant/')) {
      return;
    }

    // 转换为相对路径
    final relativeImport = importPath.replaceFirst('package:ai_nutrition_restaurant/', '');
    
    // 检查跨模块导入
    _checkCrossModuleImport(filePath, lineNumber, importLine, relativeImport);
    
    // 检查层级导入
    _checkLayerImport(filePath, lineNumber, importLine, relativeImport);
  }

  /// 检查跨模块导入
  void _checkCrossModuleImport(String filePath, int lineNumber, String importLine, String importPath) {
    // 获取当前文件的模块
    final currentModule = _getModule(filePath);
    if (currentModule == null) return;
    
    // 获取导入的模块
    final importedModule = _getModule('lib/$importPath');
    if (importedModule == null) return;
    
    // 检查是否跨模块导入（presentation 层除外）
    if (currentModule != importedModule && 
        importedModule != 'core' && 
        importedModule != 'shared' &&
        importedModule != 'config') {
      
      // 检查导入的是否是 presentation 层以外的内容
      if (importPath.contains('/domain/') || 
          importPath.contains('/data/') ||
          importPath.contains('/application/')) {
        violations.add(Violation(
          file: filePath,
          line: lineNumber,
          importStatement: importLine,
          type: ViolationType.crossModuleImport,
          message: '模块 $currentModule 不应该导入模块 $importedModule 的内部实现',
        ));
      }
    }
  }

  /// 检查层级导入
  void _checkLayerImport(String filePath, int lineNumber, String importLine, String importPath) {
    final currentLayer = _getLayer(filePath);
    final importedLayer = _getLayer('lib/$importPath');
    
    if (currentLayer == null || importedLayer == null) return;
    
    // 检查层级依赖规则
    final isViolation = switch ((currentLayer, importedLayer)) {
      ('presentation', 'data') => true,
      ('application', 'data') => true,
      ('application', 'presentation') => true,
      ('domain', 'data') => true,
      ('domain', 'presentation') => true,
      ('domain', 'application') => true,
      _ => false,
    };
    
    if (isViolation) {
      violations.add(Violation(
        file: filePath,
        line: lineNumber,
        importStatement: importLine,
        type: ViolationType.wrongLayerImport,
        message: '$currentLayer 层不应该依赖 $importedLayer 层',
      ));
    }
  }

  /// 获取文件所属的模块
  String? _getModule(String path) {
    final match = RegExp(r'lib/features/([^/]+)').firstMatch(path);
    if (match != null) {
      return match.group(1);
    }
    
    if (path.contains('lib/core/')) return 'core';
    if (path.contains('lib/shared/')) return 'shared';
    if (path.contains('lib/config/')) return 'config';
    
    return null;
  }

  /// 获取文件所属的层
  String? _getLayer(String path) {
    if (path.contains('/presentation/')) return 'presentation';
    if (path.contains('/application/')) return 'application';
    if (path.contains('/domain/')) return 'domain';
    if (path.contains('/data/')) return 'data';
    return null;
  }
}

void main() async {
  final checker = BoundaryChecker();
  await checker.run();
}