#!/usr/bin/env dart

/// Feature 模块脚手架工具
/// 
/// 快速创建符合标准结构的 Feature 模块
/// 使用方法: dart run tools/create_feature_module.dart [module_name]
library;

import 'dart:io';

class FeatureModuleGenerator {
  final String moduleName;
  final String moduleNamePascal;
  final String baseDir;

  FeatureModuleGenerator(this.moduleName)
      : moduleNamePascal = _toPascalCase(moduleName),
        baseDir = 'lib/features/$moduleName';

  static String _toPascalCase(String input) {
    return input.split('_').map((word) => 
      word[0].toUpperCase() + word.substring(1).toLowerCase()
    ).join();
  }

  Future<void> generate() async {
    print('🚀 创建 Feature 模块: $moduleName');
    
    // 创建目录结构
    await _createDirectories();
    
    // 创建文件
    await _createModuleFile();
    await _createApplicationFiles();
    await _createDomainFiles();
    await _createDataFiles();
    await _createPresentationFiles();
    
    print('\n✅ 模块创建成功！');
    print('📁 位置: $baseDir');
    print('\n下一步：');
    print('1. 在 ModuleInitializer 中注册模块');
    print('2. 在 AppInjection 中注册依赖');
    print('3. 在 RoutesCollector 中添加路由');
  }

  Future<void> _createDirectories() async {
    final dirs = [
      '$baseDir/application/facades',
      '$baseDir/domain/entities',
      '$baseDir/domain/repositories',
      '$baseDir/domain/usecases',
      '$baseDir/domain/value_objects',
      '$baseDir/data/datasources',
      '$baseDir/data/models',
      '$baseDir/data/repositories',
      '$baseDir/presentation/pages',
      '$baseDir/presentation/widgets',
      '$baseDir/presentation/controllers',
      '$baseDir/presentation/providers',
      '$baseDir/presentation/router',
    ];

    for (final dir in dirs) {
      await Directory(dir).create(recursive: true);
    }
  }

  Future<void> _createModuleFile() async {
    final content = '''
/// $moduleNamePascal 模块初始化
library;

import '../../core/utils/logger.dart';

/// $moduleNamePascal 模块
class ${moduleNamePascal}Module {
  ${moduleNamePascal}Module._();

  /// 初始化模块
  static Future<void> initialize() async {
    AppLogger.debug('初始化 $moduleNamePascal 模块...');
    
    try {
      // TODO: 添加模块初始化逻辑
      
      AppLogger.debug('$moduleNamePascal 模块初始化完成');
    } catch (e, stack) {
      AppLogger.error('$moduleNamePascal 模块初始化失败', error: e, stackTrace: stack);
      rethrow;
    }
  }
}
''';
    await File('$baseDir/${moduleName}_module.dart').writeAsString(content);
  }

  Future<void> _createApplicationFiles() async {
    // Facade
    final facadeContent = '''
/// $moduleNamePascal 模块业务门面
library;

import 'package:dartz/dartz.dart';

/// $moduleNamePascal 业务门面
class ${moduleNamePascal}Facade {
  const ${moduleNamePascal}Facade();

  // TODO: 添加业务方法
}

/// $moduleNamePascal 业务失败类型
abstract class ${moduleNamePascal}Failure {}
''';
    await File('$baseDir/application/facades/${moduleName}_facade.dart').writeAsString(facadeContent);
  }

  Future<void> _createDomainFiles() async {
    // Entity
    final entityContent = '''
/// $moduleNamePascal 实体
library;

/// $moduleNamePascal 实体类
class $moduleNamePascal {
  const $moduleNamePascal({
    required this.id,
  });

  final String id;
}
''';
    await File('$baseDir/domain/entities/$moduleName.dart').writeAsString(entityContent);

    // Repository
    final repositoryContent = '''
/// $moduleNamePascal 仓库接口
library;

import 'package:dartz/dartz.dart';
import '../entities/$moduleName.dart';

/// $moduleNamePascal 仓库接口
abstract class ${moduleNamePascal}Repository {
  Future<Either<${moduleNamePascal}Failure, List<$moduleNamePascal>>> get${moduleNamePascal}s();
}

/// $moduleNamePascal 仓库失败类型
abstract class ${moduleNamePascal}Failure {}
''';
    await File('$baseDir/domain/repositories/${moduleName}_repository.dart').writeAsString(repositoryContent);

    // UseCase
    final useCaseContent = '''
/// 获取 $moduleNamePascal 列表用例
library;

import '../../../core/base/use_case.dart';
import '../entities/$moduleName.dart';
import '../repositories/${moduleName}_repository.dart';

/// 获取 $moduleNamePascal 列表用例
class Get${moduleNamePascal}sUseCase {
  const Get${moduleNamePascal}sUseCase({
    required this.repository,
  });

  final ${moduleNamePascal}Repository repository;
}
''';
    await File('$baseDir/domain/usecases/get_${moduleName}s_usecase.dart').writeAsString(useCaseContent);
  }

  Future<void> _createDataFiles() async {
    // Model
    final modelContent = '''
/// $moduleNamePascal 数据模型
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part '${moduleName}_model.freezed.dart';
part '${moduleName}_model.g.dart';

/// $moduleNamePascal 数据模型
@freezed
class ${moduleNamePascal}Model with _\$${moduleNamePascal}Model {
  const factory ${moduleNamePascal}Model({
    required String id,
  }) = _${moduleNamePascal}Model;

  factory ${moduleNamePascal}Model.fromJson(Map<String, dynamic> json) =>
      _\$${moduleNamePascal}ModelFromJson(json);
}
''';
    await File('$baseDir/data/models/${moduleName}_model.dart').writeAsString(modelContent);

    // DataSource
    final dataSourceContent = '''
/// $moduleNamePascal 远程数据源
library;

/// $moduleNamePascal 远程数据源接口
abstract class ${moduleNamePascal}RemoteDataSource {
  Future<List<Map<String, dynamic>>> get${moduleNamePascal}s();
}

/// $moduleNamePascal 远程数据源实现
class ${moduleNamePascal}RemoteDataSourceImpl implements ${moduleNamePascal}RemoteDataSource {
  @override
  Future<List<Map<String, dynamic>>> get${moduleNamePascal}s() async {
    // TODO: 实现远程数据获取
    throw UnimplementedError();
  }
}
''';
    await File('$baseDir/data/datasources/${moduleName}_remote_datasource.dart').writeAsString(dataSourceContent);

    // Repository Implementation
    final repoImplContent = '''
/// $moduleNamePascal 仓库实现
library;

import 'package:dartz/dartz.dart';
import '../../domain/entities/$moduleName.dart';
import '../../domain/repositories/${moduleName}_repository.dart';
import '../datasources/${moduleName}_remote_datasource.dart';

/// $moduleNamePascal 仓库实现
class ${moduleNamePascal}RepositoryImpl implements ${moduleNamePascal}Repository {
  const ${moduleNamePascal}RepositoryImpl({
    required this.remoteDataSource,
  });

  final ${moduleNamePascal}RemoteDataSource remoteDataSource;

  @override
  Future<Either<${moduleNamePascal}Failure, List<$moduleNamePascal>>> get${moduleNamePascal}s() async {
    // TODO: 实现仓库方法
    throw UnimplementedError();
  }
}
''';
    await File('$baseDir/data/repositories/${moduleName}_repository_impl.dart').writeAsString(repoImplContent);

    // Injection
    final injectionContent = '''
/// $moduleNamePascal 模块内部依赖注入
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/di/app_injection.dart';
import 'datasources/${moduleName}_remote_datasource.dart';
import '../domain/repositories/${moduleName}_repository.dart';
import '../domain/usecases/get_${moduleName}s_usecase.dart';
import '../application/facades/${moduleName}_facade.dart';
import 'repositories/${moduleName}_repository_impl.dart';

/// $moduleNamePascal 模块依赖注入
class ${moduleNamePascal}ModuleInjection implements ModuleInjection {
  static void register() {
    // TODO: 注册依赖
  }
}
''';
    await File('$baseDir/data/injection.dart').writeAsString(injectionContent);
  }

  Future<void> _createPresentationFiles() async {
    // Page
    final pageContent = '''
/// $moduleNamePascal 列表页面
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// $moduleNamePascal 列表页面
class ${moduleNamePascal}ListPage extends ConsumerWidget {
  const ${moduleNamePascal}ListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$moduleNamePascal'),
      ),
      body: const Center(
        child: Text('$moduleNamePascal List Page'),
      ),
    );
  }
}
''';
    await File('$baseDir/presentation/pages/${moduleName}_list_page.dart').writeAsString(pageContent);

    // Controller
    final controllerContent = '''
/// $moduleNamePascal 控制器
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '${moduleName}_controller.freezed.dart';
part '${moduleName}_controller.g.dart';

/// $moduleNamePascal 控制器状态
@freezed
class ${moduleNamePascal}State with _\$${moduleNamePascal}State {
  const factory ${moduleNamePascal}State({
    @Default(false) bool isLoading,
  }) = _${moduleNamePascal}State;
}

/// $moduleNamePascal 控制器
@riverpod
class ${moduleNamePascal}Controller extends _\$${moduleNamePascal}Controller {
  @override
  Future<${moduleNamePascal}State> build() async {
    return const ${moduleNamePascal}State();
  }
}
''';
    await File('$baseDir/presentation/controllers/${moduleName}_controller.dart').writeAsString(controllerContent);

    // Providers
    final providersContent = '''
/// $moduleNamePascal 模块 Provider 统一导出
library;

export '${moduleName}_controller.dart';

/// $moduleNamePascal 模块 Provider 访问器
class ${moduleNamePascal}Providers {
  const ${moduleNamePascal}Providers._();
}
''';
    await File('$baseDir/presentation/providers/${moduleName}_providers.dart').writeAsString(providersContent);

    // Router
    final routerContent = '''
/// $moduleNamePascal 模块路由配置
library;

import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';

/// $moduleNamePascal 路由配置
class ${moduleNamePascal}Router {
  static List<AutoRoute> get routes => [
    // TODO: 添加路由配置
    // AutoRoute(
    //   page: ${moduleNamePascal}ListRoute.page,
    //   path: '/${moduleName}s',
    // ),
  ];
}
''';
    await File('$baseDir/presentation/router/${moduleName}_router.dart').writeAsString(routerContent);
  }
}

void main(List<String> args) async {
  if (args.isEmpty) {
    print('❌ 请提供模块名称');
    print('使用方法: dart run tools/create_feature_module.dart [module_name]');
    exit(1);
  }

  final moduleName = args[0].toLowerCase();
  if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(moduleName)) {
    print('❌ 模块名称无效');
    print('模块名称应该使用小写字母和下划线，如: payment, user_profile');
    exit(1);
  }

  final generator = FeatureModuleGenerator(moduleName);
  await generator.generate();
}