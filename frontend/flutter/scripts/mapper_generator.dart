import 'dart:io';
import 'package:path/path.dart' as path;

void main() {
  print('🔄 Generating mappers...');
  
  final mappersDir = Directory('lib/infrastructure/mappers/generated');
  if (!mappersDir.existsSync()) {
    mappersDir.createSync(recursive: true);
  }
  
  // Define mapper configurations
  final mapperConfigs = [
    MapperConfig('User', 'user'),
    MapperConfig('Restaurant', 'restaurant'),
    MapperConfig('Order', 'order'),
    MapperConfig('NutritionProfile', 'nutrition'),
    MapperConfig('Dish', 'merchant'),
    MapperConfig('Consultation', 'consult'),
    MapperConfig('Payment', 'order'),
    MapperConfig('Notification', 'notification'),
  ];
  
  // Generate mapper for each configuration
  for (final config in mapperConfigs) {
    generateMapper(config);
  }
  
  // Generate mapper registry
  generateMapperRegistry(mapperConfigs);
  
  print('✅ Mapper generation completed!');
}

class MapperConfig {
  final String entityName;
  final String module;
  
  MapperConfig(this.entityName, this.module);
  
  String get dtoName => '${entityName}Dto';
  String get mapperName => '${entityName}Mapper';
  String get fileName => '${_toSnakeCase(entityName)}_mapper.dart';
}

void generateMapper(MapperConfig config) {
  final content = '''
import 'package:smart_nutrition_frontend/domain/${ config.module}/entities/${_toSnakeCase(config.entityName)}.dart';
import 'package:smart_nutrition_frontend/infrastructure/dtos/generated/${_toSnakeCase(config.entityName)}_dto.dart';
import 'package:smart_nutrition_frontend/infrastructure/mappers/base_mapper.dart';

/// Auto-generated mapper for ${config.entityName}
/// Generated on: ${DateTime.now().toIso8601String()}
class ${config.mapperName} extends BaseMapper<${config.dtoName}, ${config.entityName}> {
  @override
  ${config.entityName} toEntity(${config.dtoName} dto) {
    // TODO: Implement mapping logic
    // This is a template - actual implementation depends on the entity structure
    throw UnimplementedError('${config.mapperName}.toEntity() not implemented');
  }
  
  @override
  ${config.dtoName} toDto(${config.entityName} entity) {
    // TODO: Implement mapping logic
    // This is a template - actual implementation depends on the entity structure
    throw UnimplementedError('${config.mapperName}.toDto() not implemented');
  }
}
''';
  
  final file = File('lib/infrastructure/mappers/generated/${config.fileName}');
  file.writeAsStringSync(content);
  print('  ✓ Generated ${config.fileName}');
}

void generateMapperRegistry(List<MapperConfig> configs) {
  final imports = configs.map((c) => 
    "import '${c.fileName}';").join('\n');
  
  final registrations = configs.map((c) =>
    "  ${c.mapperName} get ${_toCamelCase(c.entityName)}Mapper => ${c.mapperName}();").join('\n');
  
  final content = '''
// Auto-generated mapper registry
// Generated on: ${DateTime.now().toIso8601String()}

$imports

/// Registry for all mappers
class MapperRegistry {
  static final MapperRegistry _instance = MapperRegistry._internal();
  
  factory MapperRegistry() => _instance;
  
  MapperRegistry._internal();
  
  // Mapper instances
$registrations
}
''';
  
  final file = File('lib/infrastructure/mappers/generated/mapper_registry.dart');
  file.writeAsStringSync(content);
  print('  ✓ Generated mapper_registry.dart');
}

String _toSnakeCase(String input) {
  return input.replaceAllMapped(
    RegExp('([A-Z])'),
    (match) => '_${match.group(1)!.toLowerCase()}'
  ).substring(1);
}

String _toCamelCase(String input) {
  return input[0].toLowerCase() + input.substring(1);
}