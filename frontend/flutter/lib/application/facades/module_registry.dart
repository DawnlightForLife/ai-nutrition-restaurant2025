import 'package:ai_nutrition_restaurant/domain/common/facade/module_facade.dart';
import 'package:ai_nutrition_restaurant/application/facades/user_facade.dart';
import 'package:ai_nutrition_restaurant/application/facades/nutrition_facade.dart';

/// Registry for all module facades
/// Ensures module isolation and provides centralized access
class ModuleRegistry {
  static final ModuleRegistry _instance = ModuleRegistry._internal();
  
  factory ModuleRegistry() => _instance;
  
  ModuleRegistry._internal();
  
  final Map<String, ModuleFacade> _modules = {};
  
  /// Register a module facade
  void register(ModuleFacade module) {
    if (_modules.containsKey(module.moduleName)) {
      throw Exception('Module ${module.moduleName} is already registered');
    }
    _modules[module.moduleName] = module;
  }
  
  /// Get a registered module
  T getModule<T extends ModuleFacade>(String moduleName) {
    final module = _modules[moduleName];
    if (module == null) {
      throw Exception('Module $moduleName is not registered');
    }
    if (module is! T) {
      throw Exception('Module $moduleName is not of type $T');
    }
    return module;
  }
  
  /// Get user module facade
  UserFacade get user => getModule<UserFacade>('User');
  
  /// Get nutrition module facade
  NutritionFacade get nutrition => getModule<NutritionFacade>('Nutrition');
  
  /// Initialize all modules
  Future<void> initializeAll() async {
    for (final module in _modules.values) {
      await module.initialize();
    }
  }
  
  /// Dispose all modules
  Future<void> disposeAll() async {
    for (final module in _modules.values) {
      await module.dispose();
    }
  }
  
  /// Check if all modules are ready
  bool get allReady => _modules.values.every((module) => module.isReady);
  
  /// Get list of registered module names
  List<String> get registeredModules => _modules.keys.toList();
}