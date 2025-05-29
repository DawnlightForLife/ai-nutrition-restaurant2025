import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;

void main() async {
  print('🏗️  架构守卫检查开始...\n');
  
  final violations = <String>[];
  
  // 加载配置
  final configFile = File('.architecture-guard.yaml');
  if (!configFile.existsSync()) {
    print('❌ 未找到架构守卫配置文件');
    exit(1);
  }
  
  final config = loadYaml(configFile.readAsStringSync());
  
  // 检查锁定目录
  print('📁 检查锁定目录...');
  checkLockedDirectories(config['locked_directories'], violations);
  
  // 检查文件命名
  print('📝 检查文件命名规范...');
  await checkNamingRules(config['naming_rules'], violations);
  
  // 检查导入规则
  print('🔗 检查导入规则...');
  await checkImportRules(config['forbidden_actions']['forbidden_imports'], violations);
  
  // 检查必需结构
  print('🏛️  检查代码结构...');
  await checkTemplateRequirements(config['template_requirements'], violations);
  
  // 输出结果
  print('\n' + '='*50);
  if (violations.isEmpty) {
    print('✅ 架构检查通过！');
    exit(0);
  } else {
    print('❌ 发现 ${violations.length} 个架构违规：\n');
    violations.forEach((v) => print('  • $v'));
    exit(1);
  }
}

void checkLockedDirectories(List<dynamic>? lockedDirs, List<String> violations) {
  if (lockedDirs == null) return;
  
  for (final dirPath in lockedDirs) {
    final dir = Directory(dirPath);
    if (dir.existsSync()) {
      // 检查是否有非预期的文件
      final files = dir.listSync(recursive: true)
          .whereType<File>()
          .where((f) => !f.path.endsWith('.dart'))
          .toList();
      
      if (files.isNotEmpty) {
        violations.add('锁定目录 $dirPath 中发现非Dart文件');
      }
    }
  }
}

Future<void> checkNamingRules(dynamic rules, List<String> violations) async {
  if (rules == null) return;
  
  // 检查文件命名
  final fileRules = rules['files'] as YamlList?;
  if (fileRules != null) {
    await for (final file in Directory('lib').list(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        final fileName = path.basename(file.path);
        var valid = false;
        
        for (final rule in fileRules) {
          final pattern = RegExp(rule['pattern']);
          if (pattern.hasMatch(fileName)) {
            valid = true;
            break;
          }
        }
        
        if (!valid && !fileName.endsWith('.g.dart') && 
            !fileName.endsWith('.freezed.dart') && 
            !fileName.endsWith('.gr.dart')) {
          violations.add('文件命名违规: ${file.path}');
        }
      }
    }
  }
  
  // 检查特定目录的命名规则
  final dirRules = rules['directories'] as YamlMap?;
  if (dirRules != null) {
    for (final entry in dirRules.entries) {
      final dirPattern = entry.key as String;
      final dirRulesList = entry.value as YamlList;
      
      await for (final file in Directory('lib').list(recursive: true)) {
        if (file is File && file.path.contains(dirPattern.replaceAll('*', ''))) {
          final fileName = path.basename(file.path);
          var valid = false;
          
          for (final rule in dirRulesList) {
            final pattern = RegExp(rule['pattern']);
            if (pattern.hasMatch(fileName)) {
              valid = true;
              break;
            }
          }
          
          if (!valid) {
            violations.add('目录命名规则违规: ${file.path} - ${dirRulesList[0]['message']}');
          }
        }
      }
    }
  }
}

Future<void> checkImportRules(List<dynamic>? rules, List<String> violations) async {
  if (rules == null) return;
  
  await for (final file in Directory('lib').list(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      try {
        final content = await file.readAsString();
        final lines = content.split('\n');
        
        for (final rule in rules) {
          final from = rule['from'] as String;
          final to = rule['to'] as String;
          final message = rule['message'] as String;
          
          if (file.path.contains(from.replaceAll('*', ''))) {
            for (final line in lines) {
              if (line.startsWith('import') && line.contains(to)) {
                violations.add('导入违规 [${file.path}]: $message');
                break;
              }
            }
          }
        }
      } catch (e) {
        // 跳过无法读取的文件（编码问题等）
        print('  ⚠️  跳过文件 ${file.path}: 编码错误');
      }
    }
  }
}

Future<void> checkTemplateRequirements(dynamic requirements, List<String> violations) async {
  if (requirements == null) return;
  
  final reqMap = requirements as YamlMap;
  for (final entry in reqMap.entries) {
    final pathPattern = entry.key as String;
    final reqs = entry.value as YamlMap;
    final mustContain = reqs['must_contain'] as YamlList?;
    
    if (mustContain == null) continue;
    
    await for (final file in Directory('lib').list(recursive: true)) {
      if (file is File && 
          file.path.endsWith('.dart') && 
          file.path.contains(pathPattern.replaceAll('*', ''))) {
        try {
          final content = await file.readAsString();
          
          for (final required in mustContain) {
            final pattern = RegExp(required as String);
            if (!pattern.hasMatch(content)) {
              violations.add('模板要求违规 [${file.path}]: 缺少必需的 "$required"');
            }
          }
        } catch (e) {
          // 跳过无法读取的文件
          print('  ⚠️  跳过文件 ${file.path}: 编码错误');
        }
      }
    }
  }
}