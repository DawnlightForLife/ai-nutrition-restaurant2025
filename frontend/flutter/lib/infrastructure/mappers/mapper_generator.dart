import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// Annotation to mark a class for mapper generation
class GenerateMapper {
  final Type dtoType;
  final Type entityType;
  
  const GenerateMapper({
    required this.dtoType,
    required this.entityType,
  });
}

/// Builder configuration for mapper generation
Builder mapperBuilder(BuilderOptions options) => LibraryBuilder(
      MapperGenerator(),
      generatedExtension: '.mapper.dart',
    );

/// Generator for creating mapper classes
class MapperGenerator extends GeneratorForAnnotation<GenerateMapper> {
  @override
  generateForAnnotatedElement(element, annotation, buildStep) {
    // This would contain the actual generation logic
    // For now, it's a placeholder
    return '''
// Generated mapper code would go here
''';
  }
}