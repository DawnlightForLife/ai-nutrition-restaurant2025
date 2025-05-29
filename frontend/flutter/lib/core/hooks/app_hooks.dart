/// 应用生命周期钩子系统
/// 
/// 提供类似后端的 Hooks 机制，在关键生命周期节点执行自定义逻辑
library;

import 'dart:async';
import '../utils/logger.dart';
import '../events/centralized_event_bus.dart';

/// Hook 类型枚举
enum HookType {
  // 应用生命周期
  beforeAppStart,
  afterAppStart,
  beforeAppStop,
  afterAppStop,
  
  // 用户生命周期
  beforeUserLogin,
  afterUserLogin,
  beforeUserLogout,
  afterUserLogout,
  
  // 数据生命周期
  beforeDataCreate,
  afterDataCreate,
  beforeDataUpdate,
  afterDataUpdate,
  beforeDataDelete,
  afterDataDelete,
  
  // 网络请求生命周期
  beforeRequest,
  afterRequest,
  onRequestError,
  
  // 页面生命周期
  beforePageEnter,
  afterPageEnter,
  beforePageLeave,
  afterPageLeave,
}

/// Hook 上下文
class HookContext {
  final HookType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  bool _cancelled = false;
  
  HookContext({
    required this.type,
    Map<String, dynamic>? data,
    DateTime? timestamp,
  }) : data = data ?? {},
        timestamp = timestamp ?? DateTime.now();
  
  /// 是否已取消
  bool get isCancelled => _cancelled;
  
  /// 取消后续执行
  void cancel() {
    _cancelled = true;
  }
  
  /// 获取数据
  T? get<T>(String key) => data[key] as T?;
  
  /// 设置数据
  void set(String key, dynamic value) {
    data[key] = value;
  }
}

/// Hook 处理器
typedef HookHandler = FutureOr<void> Function(HookContext context);

/// Hook 管理器
class HookManager {
  static HookManager? _instance;
  static HookManager get instance => _instance ??= HookManager._();
  
  HookManager._();
  
  final Map<HookType, List<_HookEntry>> _hooks = {};
  
  /// 注册 Hook
  void register(
    HookType type,
    HookHandler handler, {
    int priority = 0,
    String? name,
  }) {
    final entry = _HookEntry(
      handler: handler,
      priority: priority,
      name: name ?? handler.toString(),
    );
    
    _hooks.putIfAbsent(type, () => []).add(entry);
    
    // 按优先级排序（高优先级先执行）
    _hooks[type]!.sort((a, b) => b.priority.compareTo(a.priority));
    
    AppLogger.debug('Hook 已注册: ${type.name} - ${entry.name}');
  }
  
  /// 注销 Hook
  void unregister(HookType type, HookHandler handler) {
    final entries = _hooks[type];
    if (entries != null) {
      entries.removeWhere((e) => e.handler == handler);
      AppLogger.debug('Hook 已注销: ${type.name}');
    }
  }
  
  /// 触发 Hook
  Future<HookContext> trigger(
    HookType type, {
    Map<String, dynamic>? data,
  }) async {
    final context = HookContext(type: type, data: data);
    final entries = _hooks[type] ?? [];
    
    AppLogger.debug('触发 Hook: ${type.name}, 处理器数量: ${entries.length}');
    
    for (final entry in entries) {
      if (context.isCancelled) {
        AppLogger.debug('Hook 执行已取消: ${type.name}');
        break;
      }
      
      try {
        await entry.handler(context);
      } catch (e, stack) {
        AppLogger.error(
          'Hook 处理器执行失败: ${type.name} - ${entry.name}',
          error: e,
          stackTrace: stack,
        );
        // 继续执行其他处理器
      }
    }
    
    // 发布 Hook 事件到事件总线
    CentralizedEventBus.instance.publish(
      HookTriggeredEvent(
        hookType: type,
        context: context,
      ),
    );
    
    return context;
  }
  
  /// 清除所有 Hook
  void clear() {
    _hooks.clear();
    AppLogger.info('所有 Hook 已清除');
  }
  
  /// 清除特定类型的 Hook
  void clearType(HookType type) {
    _hooks.remove(type);
    AppLogger.debug('Hook 类型已清除: ${type.name}');
  }
  
  /// 获取已注册的 Hook 信息
  Map<HookType, List<String>> getRegisteredHooks() {
    return _hooks.map((type, entries) => 
      MapEntry(type, entries.map((e) => e.name).toList())
    );
  }
}

/// Hook 条目
class _HookEntry {
  final HookHandler handler;
  final int priority;
  final String name;
  
  const _HookEntry({
    required this.handler,
    required this.priority,
    required this.name,
  });
}

/// Hook 触发事件
class HookTriggeredEvent extends AppEvent {
  final HookType hookType;
  final HookContext context;
  
  HookTriggeredEvent({
    required this.hookType,
    required this.context,
  }) : super(
    timestamp: DateTime.now(),
    source: 'HookManager',
    metadata: {
      'hookType': hookType.name,
      'contextData': context.data,
    },
  );
}

/// 常用 Hook 扩展
extension CommonHooks on HookManager {
  /// 用户登录前
  Future<void> beforeUserLogin(String userId) async {
    await trigger(HookType.beforeUserLogin, data: {'userId': userId});
  }
  
  /// 用户登录后
  Future<void> afterUserLogin(String userId, String token) async {
    await trigger(HookType.afterUserLogin, data: {
      'userId': userId,
      'token': token,
    });
  }
  
  /// 用户登出前
  Future<void> beforeUserLogout(String userId) async {
    await trigger(HookType.beforeUserLogout, data: {'userId': userId});
  }
  
  /// 用户登出后
  Future<void> afterUserLogout(String userId) async {
    await trigger(HookType.afterUserLogout, data: {'userId': userId});
  }
  
  /// 数据创建前
  Future<HookContext> beforeDataCreate(String entity, Map<String, dynamic> data) async {
    return trigger(HookType.beforeDataCreate, data: {
      'entity': entity,
      'data': data,
    });
  }
  
  /// 数据创建后
  Future<void> afterDataCreate(String entity, String id, Map<String, dynamic> data) async {
    await trigger(HookType.afterDataCreate, data: {
      'entity': entity,
      'id': id,
      'data': data,
    });
  }
}