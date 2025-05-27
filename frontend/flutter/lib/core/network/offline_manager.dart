import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../infrastructure/dtos/offline_operation.dart';
import '../error/error_handler.dart';
import 'network_monitor.dart';

/// 离线数据管理器
@Injectable()
@singleton
class OfflineManager {
  static const String _operationsKey = 'offline_operations';
  static const String _cachePrefix = 'cache_';

  final NetworkMonitor _networkMonitor;
  final List<OfflineOperation> _pendingOperations = [];
  
  late final StreamController<List<OfflineOperation>> _operationsController;
  StreamSubscription<NetworkStatus>? _networkSubscription;
  
  bool _isProcessing = false;

  OfflineManager(this._networkMonitor) {
    _operationsController = StreamController<List<OfflineOperation>>.broadcast();
    _initialize();
  }

  /// 待处理操作流
  Stream<List<OfflineOperation>> get pendingOperationsStream => _operationsController.stream;
  
  /// 待处理操作数量
  int get pendingOperationsCount => _pendingOperations.length;
  
  /// 是否有待处理操作
  bool get hasPendingOperations => _pendingOperations.isNotEmpty;
  
  /// 获取所有待处理操作
  Future<List<OfflineOperation>> getPendingOperations() async {
    await _loadPendingOperations();
    return List.unmodifiable(_pendingOperations);
  }

  /// 初始化
  Future<void> _initialize() async {
    try {
      // 加载待处理操作
      await _loadPendingOperations();
      
      // 监听网络状态
      _networkSubscription = _networkMonitor.statusStream.listen(_onNetworkStatusChanged);
      
      GlobalErrorHandler.logInfo('Offline manager initialized');
    } catch (e) {
      GlobalErrorHandler.logError('Failed to initialize offline manager', error: e);
    }
  }

  /// 网络状态变化处理
  void _onNetworkStatusChanged(NetworkStatus status) {
    if (status.isConnected && hasPendingOperations) {
      _processPendingOperations();
    }
  }

  /// 加载待处理操作
  Future<void> _loadPendingOperations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(_operationsKey);
      
      if (jsonData != null) {
        final List<dynamic> jsonList = jsonDecode(jsonData) as List<dynamic>;
        
        _pendingOperations.clear();
        _pendingOperations.addAll(
          jsonList.map((json) => OfflineOperation.fromJson(json as Map<String, dynamic>)).toList(),
        );
        
        _operationsController.add(List.from(_pendingOperations));
        
        GlobalErrorHandler.logInfo(
          'Pending operations loaded',
          {'count': _pendingOperations.length},
        );
      }
    } catch (e) {
      GlobalErrorHandler.logError('Failed to load pending operations', error: e);
    }
  }
  
  /// 保存待处理操作
  Future<void> _savePendingOperations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = jsonEncode(
        _pendingOperations.map((op) => op.toJson()).toList(),
      );
      
      await prefs.setString(_operationsKey, jsonData);
      
      GlobalErrorHandler.logDebug(
        'Pending operations saved',
        {'count': _pendingOperations.length},
      );
    } catch (e) {
      GlobalErrorHandler.logError('Failed to save pending operations', error: e);
    }
  }

  /// 添加离线操作
  Future<void> addOperation(OfflineOperation operation) async {
    try {
      _pendingOperations.add(operation);
      await _savePendingOperations();
      _operationsController.add(List.from(_pendingOperations));
      
      GlobalErrorHandler.logInfo(
        'Added offline operation',
        {
          'id': operation.id,
          'endpoint': operation.endpoint,
          'method': operation.method,
        },
      );

      // 如果网络可用，立即尝试处理
      if (_networkMonitor.isConnected) {
        _processPendingOperations();
      }
    } catch (e) {
      GlobalErrorHandler.logError('Failed to add offline operation', error: e);
    }
  }

  /// 缓存数据
  Future<void> cacheData(String key, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cachePrefix$key';
      final jsonData = jsonEncode({
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      await prefs.setString(cacheKey, jsonData);
      
      GlobalErrorHandler.logDebug('Data cached', {'key': key});
    } catch (e) {
      GlobalErrorHandler.logError('Failed to cache data', error: e);
    }
  }

  /// 获取缓存数据
  Future<Map<String, dynamic>?> getCachedData(String key, {Duration? maxAge}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cachePrefix$key';
      final jsonData = prefs.getString(cacheKey);
      
      if (jsonData == null) return null;
      
      final cacheEntry = jsonDecode(jsonData) as Map<String, dynamic>;
      final timestamp = DateTime.parse(cacheEntry['timestamp'] as String);
      
      // 检查缓存是否过期
      if (maxAge != null && DateTime.now().difference(timestamp) > maxAge) {
        await prefs.remove(cacheKey);
        return null;
      }
      
      GlobalErrorHandler.logDebug('Data retrieved from cache', {'key': key});
      return cacheEntry['data'] as Map<String, dynamic>;
    } catch (e) {
      GlobalErrorHandler.logError('Failed to get cached data', error: e);
      return null;
    }
  }

  /// 清除缓存
  Future<void> clearCache([String? keyPattern]) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (final key in keys) {
        if (key.startsWith(_cachePrefix)) {
          if (keyPattern == null || key.contains(keyPattern)) {
            await prefs.remove(key);
          }
        }
      }
      
      GlobalErrorHandler.logInfo('Cache cleared', {'pattern': keyPattern});
    } catch (e) {
      GlobalErrorHandler.logError('Failed to clear cache', error: e);
    }
  }

  /// 处理待处理操作
  Future<void> _processPendingOperations() async {
    if (_isProcessing || !_networkMonitor.isConnected) return;
    
    _isProcessing = true;
    
    try {
      GlobalErrorHandler.logInfo('Processing pending operations', {'count': _pendingOperations.length});
      
      final operationsToProcess = List<OfflineOperation>.from(_pendingOperations);
      
      for (final operation in operationsToProcess) {
        try {
          await _processOperation(operation);
          _pendingOperations.remove(operation);
        } catch (e) {
          // 记录错误
          GlobalErrorHandler.logError(
            'Failed to process offline operation',
            error: e,
            context: {'operation_id': operation.id},
          );
        }
      }
      
      await _savePendingOperations();
      _operationsController.add(List.from(_pendingOperations));
      
      GlobalErrorHandler.logInfo('Pending operations processed');
    } catch (e) {
      GlobalErrorHandler.logError('Failed to process pending operations', error: e);
    } finally {
      _isProcessing = false;
    }
  }
  
  /// 处理单个操作
  Future<void> _processOperation(OfflineOperation operation) async {
    // TODO(dev): 实现实际的API调用逻辑
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// 清除所有待处理操作
  Future<void> clearPendingOperations() async {
    try {
      _pendingOperations.clear();
      await _savePendingOperations();
      _operationsController.add([]);
      
      GlobalErrorHandler.logInfo('Pending operations cleared');
    } catch (e) {
      GlobalErrorHandler.logError('Failed to clear pending operations', error: e);
    }
  }

  /// 删除特定操作
  Future<void> removeOperation(String id) async {
    try {
      _pendingOperations.removeWhere((op) => op.id == id);
      await _savePendingOperations();
      _operationsController.add(List.from(_pendingOperations));
      
      GlobalErrorHandler.logInfo('Operation removed', {'id': id});
    } catch (e) {
      GlobalErrorHandler.logError('Failed to remove operation', error: e);
    }
  }

  /// 释放资源
  void dispose() {
    _networkSubscription?.cancel();
    _operationsController.close();
    
    GlobalErrorHandler.logInfo('Offline manager disposed');
  }
}

/// Riverpod Providers
final offlineManagerProvider = Provider<OfflineManager>((ref) {
  final networkMonitor = ref.watch(networkMonitorProvider);
  final manager = OfflineManager(networkMonitor);
  ref.onDispose(() => manager.dispose());
  return manager;
});

final pendingOperationsProvider = StreamProvider<List<OfflineOperation>>((ref) {
  final manager = ref.watch(offlineManagerProvider);
  return manager.pendingOperationsStream;
});

final hasPendingOperationsProvider = Provider<bool>((ref) {
  final pendingOperations = ref.watch(pendingOperationsProvider);
  return pendingOperations.when(
    data: (operations) => operations.isNotEmpty,
    loading: () => false,
    error: (_, __) => false,
  );
});