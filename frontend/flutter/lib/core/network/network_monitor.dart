import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../error/error_handler.dart';

/// 网络连接状态
class NetworkStatus {
  /// 是否已连接到网络
  final bool isConnected;
  
  /// 连接类型描述
  final String connectionType;
  
  /// 是否有互联网连接
  final bool hasInternet;
  
  const NetworkStatus({
    required this.isConnected,
    required this.connectionType,
    required this.hasInternet,
  });
  
  @override
  String toString() => 'NetworkStatus(isConnected: $isConnected, connectionType: $connectionType, hasInternet: $hasInternet)';
}

/// 网络连接类型
enum ConnectionType {
  /// WiFi
  wifi,
  /// 移动网络
  mobile,
  /// 以太网
  ethernet,
  /// 蓝牙
  bluetooth,
  /// VPN
  vpn,
  /// 其他
  other,
  /// 无连接
  none,
}

/// 网络监控器
@Injectable()
@singleton
class NetworkMonitor {
  final Connectivity _connectivity = Connectivity();
  
  late final StreamController<NetworkStatus> _statusController;
  late final StreamController<ConnectionType> _typeController;
  
  NetworkStatus _currentStatus = NetworkStatus(
    isConnected: false,
    connectionType: 'unknown',
    hasInternet: false,
  );
  
  ConnectionType _currentType = ConnectionType.none;
  
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _periodicCheckTimer;

  NetworkMonitor() {
    _statusController = StreamController<NetworkStatus>.broadcast();
    _typeController = StreamController<ConnectionType>.broadcast();
    _initialize();
  }

  /// 当前网络状态
  NetworkStatus get currentStatus => _currentStatus;
  
  /// 当前连接类型
  ConnectionType get currentType => _currentType;
  
  /// 是否已连接
  bool get isConnected => _currentStatus.isConnected;
  
  /// 网络状态流
  Stream<NetworkStatus> get statusStream => _statusController.stream;
  
  /// 连接类型流
  Stream<ConnectionType> get typeStream => _typeController.stream;

  /// 初始化网络监控
  Future<void> _initialize() async {
    try {
      // 检查初始连接状态
      await _checkConnectivity();
      
      // 监听连接变化
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _onConnectivityChanged,
        onError: (error) {
          GlobalErrorHandler.logError('Network monitor error', error: error);
        },
      );
      
      // 启动定期检查（每30秒检查一次）
      _startPeriodicCheck();
      
      GlobalErrorHandler.logInfo('Network monitor initialized');
    } catch (e) {
      GlobalErrorHandler.logError('Failed to initialize network monitor', error: e);
    }
  }

  /// 连接状态变化处理
  void _onConnectivityChanged(List<ConnectivityResult> results) {
    _checkConnectivity();
  }

  /// 检查连接状态
  Future<void> _checkConnectivity() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      
      final newType = _mapConnectivityResult(connectivityResults.first);
      final typeString = newType.name;
      
      // 进行实际网络可达性测试
      final hasInternet = await _testInternetConnection();
      final isConnected = newType != ConnectionType.none;

      // 创建新的网络状态
      final newStatus = NetworkStatus(
        isConnected: isConnected,
        connectionType: typeString,
        hasInternet: hasInternet,
      );

      // 更新状态
      if (newStatus.isConnected != _currentStatus.isConnected || 
          newStatus.connectionType != _currentStatus.connectionType ||
          newStatus.hasInternet != _currentStatus.hasInternet) {
        _currentStatus = newStatus;
        _statusController.add(_currentStatus);
        
        GlobalErrorHandler.logInfo(
          'Network status changed: $newStatus',
        );
      }

      if (newType != _currentType) {
        _currentType = newType;
        _typeController.add(_currentType);
        
        GlobalErrorHandler.logInfo(
          'Connection type changed: ${_currentType.name}',
        );
      }
    } catch (e) {
      GlobalErrorHandler.logError('Failed to check connectivity', error: e);
      _updateStatus(
        NetworkStatus(
          isConnected: false,
          connectionType: 'unknown',
          hasInternet: false,
        ), 
        ConnectionType.none
      );
    }
  }

  /// 映射连接结果
  ConnectionType _mapConnectivityResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return ConnectionType.wifi;
      case ConnectivityResult.mobile:
        return ConnectionType.mobile;
      case ConnectivityResult.ethernet:
        return ConnectionType.ethernet;
      case ConnectivityResult.bluetooth:
        return ConnectionType.bluetooth;
      case ConnectivityResult.vpn:
        return ConnectionType.vpn;
      case ConnectivityResult.other:
        return ConnectionType.other;
      case ConnectivityResult.none:
        return ConnectionType.none;
    }
  }

  /// 测试实际网络连接
  Future<bool> _testInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      GlobalErrorHandler.logWarning('Internet connection test failed', {'error': e.toString()});
      return false;
    }
  }

  /// 启动定期检查
  void _startPeriodicCheck() {
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkConnectivity(),
    );
  }

  /// 停止定期检查
  void _stopPeriodicCheck() {
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = null;
  }

  /// 更新状态
  void _updateStatus(NetworkStatus status, ConnectionType type) {
    _currentStatus = status;
    _statusController.add(_currentStatus);
    
    if (_currentType != type) {
      _currentType = type;
      _typeController.add(_currentType);
    }
  }

  /// 手动刷新网络状态
  Future<void> refresh() async {
    await _checkConnectivity();
  }

  /// 等待网络连接
  Future<void> waitForConnection({Duration? timeout}) async {
    if (isConnected) return;

    final completer = Completer<void>();
    StreamSubscription<NetworkStatus>? subscription;

    subscription = statusStream.listen((status) {
      if (status.isConnected) {
        subscription?.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    if (timeout != null) {
      Timer(timeout, () {
        subscription?.cancel();
        if (!completer.isCompleted) {
          completer.completeError(
            TimeoutException('等待网络连接超时', timeout),
          );
        }
      });
    }

    return completer.future;
  }

  /// 释放资源
  void dispose() {
    _connectivitySubscription?.cancel();
    _stopPeriodicCheck();
    _statusController.close();
    _typeController.close();
    
    GlobalErrorHandler.logInfo('Network monitor disposed');
  }
}

/// Riverpod Provider
final networkMonitorProvider = Provider<NetworkMonitor>((ref) {
  final monitor = NetworkMonitor();
  ref.onDispose(() => monitor.dispose());
  return monitor;
});

/// 网络状态Provider
final networkStatusProvider = StreamProvider<NetworkStatus>((ref) {
  final monitor = ref.watch(networkMonitorProvider);
  return monitor.statusStream;
});

/// 连接类型Provider
final connectionTypeProvider = StreamProvider<ConnectionType>((ref) {
  final monitor = ref.watch(networkMonitorProvider);
  return monitor.typeStream;
});

/// 网络连接状态Provider
final isConnectedProvider = Provider<bool>((ref) {
  final networkStatus = ref.watch(networkStatusProvider);
  return networkStatus.when(
    data: (status) => status.isConnected,
    loading: () => false,
    error: (_, __) => false,
  );
});