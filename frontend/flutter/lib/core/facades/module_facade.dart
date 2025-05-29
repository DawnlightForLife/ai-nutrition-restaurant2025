import 'dart:async';

/// 模块Facade基础接口
/// 所有功能模块的Facade都应该实现此接口
abstract class ModuleFacade {
  /// 模块名称
  String get moduleName;
  
  /// 模块版本
  String get moduleVersion => '1.0.0';
  
  /// 模块是否已初始化
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  
  /// 初始化模块
  Future<void> initialize() async {
    if (_isInitialized) {
      throw StateError('Module $moduleName is already initialized');
    }
    
    await onInitialize();
    _isInitialized = true;
  }
  
  /// 销毁模块
  Future<void> dispose() async {
    if (!_isInitialized) {
      return;
    }
    
    await onDispose();
    _isInitialized = false;
  }
  
  /// 子类实现初始化逻辑
  Future<void> onInitialize();
  
  /// 子类实现销毁逻辑
  Future<void> onDispose();
  
  /// 检查模块依赖
  List<Type> get dependencies => [];
  
  /// 获取模块状态
  Map<String, dynamic> getStatus() {
    return {
      'name': moduleName,
      'version': moduleVersion,
      'initialized': isInitialized,
      'dependencies': dependencies.map((d) => d.toString()).toList(),
    };
  }
}

/// 模块注册器
class ModuleRegistry {
  // 单例模式
  static final ModuleRegistry _instance = ModuleRegistry._internal();
  factory ModuleRegistry() => _instance;
  ModuleRegistry._internal();
  
  // 已注册的模块
  final Map<Type, ModuleFacade> _modules = {};
  
  /// 注册模块
  void register<T extends ModuleFacade>(T module) {
    if (_modules.containsKey(T)) {
      throw StateError('Module ${T.toString()} is already registered');
    }
    
    // 检查依赖
    for (final dep in module.dependencies) {
      if (!_modules.containsKey(dep)) {
        throw StateError('Module ${T.toString()} depends on ${dep.toString()}, but it is not registered');
      }
    }
    
    _modules[T] = module;
  }
  
  /// 获取模块
  T get<T extends ModuleFacade>() {
    final module = _modules[T];
    if (module == null) {
      throw StateError('Module ${T.toString()} is not registered');
    }
    return module as T;
  }
  
  /// 初始化所有模块
  Future<void> initializeAll() async {
    for (final module in _modules.values) {
      if (!module.isInitialized) {
        await module.initialize();
      }
    }
  }
  
  /// 销毁所有模块
  Future<void> disposeAll() async {
    // 反向顺序销毁（后注册的先销毁）
    final modules = _modules.values.toList().reversed;
    for (final module in modules) {
      if (module.isInitialized) {
        await module.dispose();
      }
    }
  }
  
  /// 获取所有模块状态
  Map<String, dynamic> getAllStatus() {
    final status = <String, dynamic>{};
    for (final entry in _modules.entries) {
      status[entry.key.toString()] = entry.value.getStatus();
    }
    return status;
  }
  
  /// 检查模块是否已注册
  bool isRegistered<T extends ModuleFacade>() {
    return _modules.containsKey(T);
  }
  
  /// 注销模块
  Future<void> unregister<T extends ModuleFacade>() async {
    final module = _modules[T];
    if (module != null) {
      if (module.isInitialized) {
        await module.dispose();
      }
      _modules.remove(T);
    }
  }
}