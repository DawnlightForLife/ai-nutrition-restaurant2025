#!/usr/bin/env dart

/// Provider 索引自动生成工具
/// 
/// 扫描所有 Provider 并生成统一的索引文件
/// 使用方法: dart run tools/generate_provider_index.dart
library;

import 'dart:io';

class ProviderIndexGenerator {
  final List<ProviderInfo> providers = [];
  final Set<String> imports = {};

  Future<void> run() async {
    print('🔍 扫描 Provider 文件...\n');

    final libDir = Directory('lib');
    await _scanDirectory(libDir);

    if (providers.isEmpty) {
      print('❌ 未找到任何 Provider');
      return;
    }

    print('📝 生成 Provider 索引...');
    await _generateIndex();
    
    print('\n✅ Provider 索引生成完成！');
    print('   文件位置: lib/core/di/generated_provider_index.dart');
    print('   Provider 数量: ${providers.length}');
  }

  Future<void> _scanDirectory(Directory dir) async {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && 
          entity.path.endsWith('.dart') &&
          !entity.path.contains('.g.dart') &&
          !entity.path.contains('.freezed.dart')) {
        await _scanFile(entity);
      }
    }
  }

  Future<void> _scanFile(File file) async {
    final content = await file.readAsString();
    final filePath = file.path.replaceAll('\\', '/');
    
    // 查找 Provider 定义
    final providerRegex = RegExp(
      r'final\s+(\w+Provider)\s*=\s*(?:Provider|StateProvider|FutureProvider|StreamProvider|StateNotifierProvider|AsyncNotifierProvider)',
      multiLine: true,
    );

    for (final match in providerRegex.allMatches(content)) {
      final providerName = match.group(1)!;
      final relativePath = filePath.replaceFirst('lib/', '');
      
      providers.add(ProviderInfo(
        name: providerName,
        file: relativePath,
        module: _getModule(filePath) ?? 'core',
      ));

      imports.add(relativePath);
    }
  }

  String? _getModule(String path) {
    final match = RegExp(r'lib/features/([^/]+)').firstMatch(path);
    return match?.group(1) ?? 'core';
  }

  Future<void> _generateIndex() async {
    final buffer = StringBuffer();
    
    // 文件头
    buffer.writeln('/// 自动生成的 Provider 索引');
    buffer.writeln('/// ');
    buffer.writeln('/// 生成时间: ${DateTime.now()}');
    buffer.writeln('/// Provider 数量: ${providers.length}');
    buffer.writeln('/// ');
    buffer.writeln('/// ⚠️ 不要手动编辑此文件，运行以下命令重新生成：');
    buffer.writeln('/// dart run tools/generate_provider_index.dart');
    buffer.writeln('library;\n');

    // 导入语句
    final sortedImports = imports.toList()..sort();
    for (final import in sortedImports) {
      buffer.writeln("import '../../$import';");
    }
    buffer.writeln();

    // Provider 索引类
    buffer.writeln('/// Provider 索引');
    buffer.writeln('abstract class ProviderIndex {');
    
    // 按模块分组
    final groupedProviders = <String, List<ProviderInfo>>{};
    for (final provider in providers) {
      groupedProviders.putIfAbsent(provider.module, () => []).add(provider);
    }

    // 生成每个模块的 Provider
    groupedProviders.forEach((module, moduleProviders) {
      buffer.writeln('\n  // ========== $module ==========');
      for (final provider in moduleProviders..sort((a, b) => a.name.compareTo(b.name))) {
        buffer.writeln('  static const ${provider.name} = ${provider.name};');
      }
    });

    buffer.writeln('}\n');

    // 生成 Provider 统计
    buffer.writeln('/// Provider 统计信息');
    buffer.writeln('class ProviderStats {');
    buffer.writeln('  static const totalCount = ${providers.length};');
    buffer.writeln('  static const moduleCount = {');
    groupedProviders.forEach((module, moduleProviders) {
      buffer.writeln("    '$module': ${moduleProviders.length},");
    });
    buffer.writeln('  };');
    buffer.writeln('}');

    // 写入文件
    final outputFile = File('lib/core/di/generated_provider_index.dart');
    await outputFile.writeAsString(buffer.toString());
  }
}

class ProviderInfo {
  const ProviderInfo({
    required this.name,
    required this.file,
    required this.module,
  });

  final String name;
  final String file;
  final String module;
}

void main() async {
  final generator = ProviderIndexGenerator();
  await generator.run();
}