/// Base interface for module facades
/// Each bounded context should implement this to provide a clean API
abstract class ModuleFacade {
  /// Module name for identification
  String get moduleName;
  
  /// Initialize the module
  Future<void> initialize();
  
  /// Dispose module resources
  Future<void> dispose();
  
  /// Check if module is ready
  bool get isReady;
}