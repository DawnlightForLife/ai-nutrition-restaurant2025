/// 插件管理器
/// 
/// 提供类似后端的插件系统，支持支付、分享、存储等插件扩展
library;

import 'dart:async';
import '../utils/logger.dart';

/// 插件接口
abstract class Plugin {
  /// 插件名称
  String get name;
  
  /// 插件版本
  String get version;
  
  /// 插件是否启用
  bool get isEnabled => _enabled;
  bool _enabled = false;
  
  /// 初始化插件
  Future<void> initialize();
  
  /// 启用插件
  Future<void> enable() async {
    if (_enabled) return;
    await onEnable();
    _enabled = true;
    AppLogger.info('插件已启用: $name v$version');
  }
  
  /// 禁用插件
  Future<void> disable() async {
    if (!_enabled) return;
    await onDisable();
    _enabled = false;
    AppLogger.info('插件已禁用: $name');
  }
  
  /// 清理资源
  Future<void> dispose();
  
  /// 启用时的钩子
  Future<void> onEnable() async {}
  
  /// 禁用时的钩子
  Future<void> onDisable() async {}
}

/// 插件管理器
class PluginManager {
  static PluginManager? _instance;
  static PluginManager get instance => _instance ??= PluginManager._();
  
  PluginManager._();
  
  final Map<Type, Plugin> _plugins = {};
  final List<PluginLifecycleListener> _listeners = [];
  
  /// 注册插件
  void register<T extends Plugin>(T plugin) {
    if (_plugins.containsKey(T)) {
      AppLogger.warning('插件已注册: ${plugin.name}');
      return;
    }
    
    _plugins[T] = plugin;
    AppLogger.info('插件已注册: ${plugin.name} v${plugin.version}');
    
    // 通知监听器
    for (final listener in _listeners) {
      listener.onPluginRegistered(plugin);
    }
  }
  
  /// 获取插件
  T? get<T extends Plugin>() {
    final plugin = _plugins[T] as T?;
    if (plugin == null) {
      AppLogger.warning('插件未找到: $T');
    }
    return plugin;
  }
  
  /// 获取插件（必须存在）
  T getRequired<T extends Plugin>() {
    final plugin = get<T>();
    if (plugin == null) {
      throw PluginNotFoundException('插件未找到: $T');
    }
    return plugin;
  }
  
  /// 初始化所有插件
  Future<void> initializeAll() async {
    AppLogger.info('开始初始化插件...');
    
    for (final plugin in _plugins.values) {
      try {
        await plugin.initialize();
        await plugin.enable();
      } catch (e, stack) {
        AppLogger.error(
          '插件初始化失败: ${plugin.name}',
          error: e,
          stackTrace: stack,
        );
      }
    }
    
    AppLogger.info('插件初始化完成，共 ${_plugins.length} 个插件');
  }
  
  /// 清理所有插件
  Future<void> disposeAll() async {
    for (final plugin in _plugins.values) {
      try {
        await plugin.disable();
        await plugin.dispose();
      } catch (e, stack) {
        AppLogger.error(
          '插件清理失败: ${plugin.name}',
          error: e,
          stackTrace: stack,
        );
      }
    }
    _plugins.clear();
    _listeners.clear();
  }
  
  /// 添加生命周期监听器
  void addLifecycleListener(PluginLifecycleListener listener) {
    _listeners.add(listener);
  }
  
  /// 移除生命周期监听器
  void removeLifecycleListener(PluginLifecycleListener listener) {
    _listeners.remove(listener);
  }
  
  /// 获取所有已注册的插件
  List<Plugin> get registeredPlugins => _plugins.values.toList();
  
  /// 获取所有已启用的插件
  List<Plugin> get enabledPlugins => 
      _plugins.values.where((p) => p.isEnabled).toList();
}

/// 插件生命周期监听器
abstract class PluginLifecycleListener {
  void onPluginRegistered(Plugin plugin);
  void onPluginEnabled(Plugin plugin);
  void onPluginDisabled(Plugin plugin);
}

/// 插件未找到异常
class PluginNotFoundException implements Exception {
  final String message;
  PluginNotFoundException(this.message);
  
  @override
  String toString() => 'PluginNotFoundException: $message';
}

/// 支付插件接口
abstract class PaymentPlugin extends Plugin {
  /// 发起支付
  Future<PaymentResult> pay(PaymentRequest request);
  
  /// 查询支付状态
  Future<PaymentStatus> queryStatus(String orderId);
  
  /// 退款
  Future<RefundResult> refund(RefundRequest request);
}

/// 存储插件接口
abstract class StoragePlugin extends Plugin {
  /// 上传文件
  Future<String> upload(String path, List<int> bytes);
  
  /// 下载文件
  Future<List<int>> download(String url);
  
  /// 删除文件
  Future<void> delete(String url);
}

/// 分享插件接口
abstract class SharePlugin extends Plugin {
  /// 分享文本
  Future<void> shareText(String text);
  
  /// 分享图片
  Future<void> shareImage(String imagePath);
  
  /// 分享链接
  Future<void> shareLink(String url, {String? title, String? description});
}

// 支付相关类型
class PaymentRequest {
  final String orderId;
  final double amount;
  final String currency;
  final Map<String, dynamic>? extra;
  
  const PaymentRequest({
    required this.orderId,
    required this.amount,
    this.currency = 'CNY',
    this.extra,
  });
}

class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? message;
  
  const PaymentResult({
    required this.success,
    this.transactionId,
    this.message,
  });
}

enum PaymentStatus {
  pending,
  processing,
  success,
  failed,
  cancelled,
}

class RefundRequest {
  final String orderId;
  final double amount;
  final String reason;
  
  const RefundRequest({
    required this.orderId,
    required this.amount,
    required this.reason,
  });
}

class RefundResult {
  final bool success;
  final String? refundId;
  final String? message;
  
  const RefundResult({
    required this.success,
    this.refundId,
    this.message,
  });
}