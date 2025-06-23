import 'dart:async';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../network/api_client.dart';

enum NutritionistConnectionStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

class NutritionistStatusUpdate {
  final String nutritionistId;
  final bool isOnline;
  final bool isAvailable;
  final String? statusMessage;
  final List<String>? availableConsultationTypes;
  final DateTime lastActiveAt;

  const NutritionistStatusUpdate({
    required this.nutritionistId,
    required this.isOnline,
    required this.isAvailable,
    this.statusMessage,
    this.availableConsultationTypes,
    required this.lastActiveAt,
  });

  factory NutritionistStatusUpdate.fromJson(Map<String, dynamic> json) {
    return NutritionistStatusUpdate(
      nutritionistId: json['nutritionistId'] as String,
      isOnline: json['isOnline'] as bool,
      isAvailable: json['isAvailable'] as bool,
      statusMessage: json['statusMessage'] as String?,
      availableConsultationTypes: (json['availableConsultationTypes'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      lastActiveAt: DateTime.parse(json['lastActiveAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nutritionistId': nutritionistId,
      'isOnline': isOnline,
      'isAvailable': isAvailable,
      'statusMessage': statusMessage,
      'availableConsultationTypes': availableConsultationTypes,
      'lastActiveAt': lastActiveAt.toIso8601String(),
    };
  }
}

class NutritionistStatusWebSocketService {
  IO.Socket? _socket;
  final StreamController<NutritionistConnectionStatus> _connectionStatusController =
      StreamController<NutritionistConnectionStatus>.broadcast();
  final StreamController<NutritionistStatusUpdate> _statusUpdateController =
      StreamController<NutritionistStatusUpdate>.broadcast();
  final StreamController<Map<String, dynamic>> _errorController =
      StreamController<Map<String, dynamic>>.broadcast();

  NutritionistConnectionStatus _currentStatus = NutritionistConnectionStatus.disconnected;
  String? _currentToken;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _heartbeatInterval = Duration(minutes: 2);
  static const Duration _reconnectDelay = Duration(seconds: 3);

  // Getters for streams
  Stream<NutritionistConnectionStatus> get connectionStatus => _connectionStatusController.stream;
  Stream<NutritionistStatusUpdate> get statusUpdates => _statusUpdateController.stream;
  Stream<Map<String, dynamic>> get errors => _errorController.stream;
  
  NutritionistConnectionStatus get currentStatus => _currentStatus;
  bool get isConnected => _currentStatus == NutritionistConnectionStatus.connected;

  Future<void> connect(String token) async {
    if (_currentStatus == NutritionistConnectionStatus.connected ||
        _currentStatus == NutritionistConnectionStatus.connecting) {
      return;
    }

    _currentToken = token;
    _setConnectionStatus(NutritionistConnectionStatus.connecting);

    try {
      final baseUrl = ApiClient.getBaseUrl().replaceFirst('/api', '');
      
      _socket = IO.io(
        '$baseUrl/nutritionist-status',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(_maxReconnectAttempts)
            .setReconnectionDelay(_reconnectDelay.inMilliseconds)
            .setAuth({'token': token})
            .build(),
      );

      _setupEventListeners();
      _socket!.connect();
    } catch (e) {
      _setConnectionStatus(NutritionistConnectionStatus.error);
      _errorController.add({'type': 'connection_error', 'message': e.toString()});
    }
  }

  void _setupEventListeners() {
    if (_socket == null) return;

    // Connection events
    _socket!.onConnect((_) {
      print('营养师状态WebSocket已连接');
      _setConnectionStatus(NutritionistConnectionStatus.connected);
      _reconnectAttempts = 0;
      _startHeartbeat();
    });

    _socket!.onDisconnect((_) {
      print('营养师状态WebSocket连接断开');
      _setConnectionStatus(NutritionistConnectionStatus.disconnected);
      _stopHeartbeat();
      _scheduleReconnect();
    });

    _socket!.onConnectError((error) {
      print('营养师状态WebSocket连接错误: $error');
      _setConnectionStatus(NutritionistConnectionStatus.error);
      _errorController.add({'type': 'connect_error', 'message': error.toString()});
      _scheduleReconnect();
    });

    _socket!.onReconnect((_) {
      print('营养师状态WebSocket重新连接成功');
      _setConnectionStatus(NutritionistConnectionStatus.connected);
      _reconnectAttempts = 0;
    });

    _socket!.onReconnectError((error) {
      print('营养师状态WebSocket重连错误: $error');
      _reconnectAttempts++;
      if (_reconnectAttempts >= _maxReconnectAttempts) {
        _setConnectionStatus(NutritionistConnectionStatus.error);
        _errorController.add({
          'type': 'reconnect_failed',
          'message': '重连次数过多，连接失败'
        });
      }
    });

    // Status events
    _socket!.on('status-initialized', (data) {
      _handleStatusUpdate(data);
    });

    _socket!.on('status-changed', (data) {
      _handleStatusUpdate(data);
    });

    _socket!.on('nutritionist-status-changed', (data) {
      _handleStatusUpdate(data);
    });

    _socket!.on('online-success', (data) {
      print('营养师上线成功: $data');
    });

    _socket!.on('offline-success', (data) {
      print('营养师下线成功: $data');
    });

    _socket!.on('status-updated', (data) {
      print('营养师状态更新成功: $data');
    });

    _socket!.on('force-offline', (data) {
      print('营养师被强制下线: $data');
      _errorController.add({
        'type': 'force_offline',
        'message': data['reason'] ?? '被管理员强制下线'
      });
      disconnect();
    });

    // Heartbeat events
    _socket!.on('heartbeat-request', (_) {
      _sendHeartbeat();
    });

    _socket!.on('heartbeat-ack', (data) {
      print('心跳响应: $data');
    });

    // Error events
    _socket!.on('error', (error) {
      print('营养师状态WebSocket错误: $error');
      _errorController.add({
        'type': 'socket_error',
        'message': error['message'] ?? error.toString()
      });
    });

    // Subscription events
    _socket!.on('subscribed', (data) {
      print('已订阅营养师状态: $data');
    });

    _socket!.on('unsubscribed', (data) {
      print('已取消订阅营养师状态: $data');
    });
  }

  void _handleStatusUpdate(dynamic data) {
    try {
      final Map<String, dynamic> statusData;
      
      if (data is Map) {
        // 如果是直接的状态数据
        if (data.containsKey('nutritionistId')) {
          statusData = Map<String, dynamic>.from(data);
        } 
        // 如果是包含statusUpdate的数据
        else if (data.containsKey('statusUpdate')) {
          statusData = {
            'nutritionistId': data['nutritionistId'],
            ...Map<String, dynamic>.from(data['statusUpdate']),
          };
        } else {
          return;
        }
      } else {
        return;
      }

      final update = NutritionistStatusUpdate(
        nutritionistId: statusData['nutritionistId'] as String,
        isOnline: statusData['isOnline'] as bool? ?? false,
        isAvailable: statusData['isAvailable'] as bool? ?? false,
        statusMessage: statusData['statusMessage'] as String?,
        availableConsultationTypes: (statusData['availableConsultationTypes'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        lastActiveAt: statusData['lastActiveAt'] != null
            ? DateTime.parse(statusData['lastActiveAt'] as String)
            : DateTime.now(),
      );

      _statusUpdateController.add(update);
    } catch (e) {
      print('处理营养师状态更新错误: $e');
      _errorController.add({
        'type': 'status_parse_error',
        'message': '状态数据解析失败'
      });
    }
  }

  void _setConnectionStatus(NutritionistConnectionStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _connectionStatusController.add(status);
    }
  }

  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      _sendHeartbeat();
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void _sendHeartbeat() {
    if (_socket?.connected == true) {
      _socket!.emit('heartbeat');
    }
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts < _maxReconnectAttempts) {
      _setConnectionStatus(NutritionistConnectionStatus.reconnecting);
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(_reconnectDelay, () {
        if (_currentToken != null) {
          connect(_currentToken!);
        }
      });
    }
  }

  // 营养师功能方法
  Future<void> goOnline({
    String? statusMessage,
    List<String>? availableConsultationTypes,
  }) async {
    if (_socket?.connected != true) {
      throw Exception('WebSocket未连接');
    }

    _socket!.emit('go-online', {
      'statusMessage': statusMessage,
      'availableConsultationTypes': availableConsultationTypes ?? [],
    });
  }

  Future<void> goOffline() async {
    if (_socket?.connected != true) {
      throw Exception('WebSocket未连接');
    }

    _socket!.emit('go-offline');
  }

  Future<void> updateStatus({
    required bool isAvailable,
    String? statusMessage,
    List<String>? availableConsultationTypes,
  }) async {
    if (_socket?.connected != true) {
      throw Exception('WebSocket未连接');
    }

    _socket!.emit('update-status', {
      'isAvailable': isAvailable,
      'statusMessage': statusMessage,
      'availableConsultationTypes': availableConsultationTypes ?? [],
    });
  }

  // 订阅功能
  void subscribeToNutritionistStatus(List<String> nutritionistIds) {
    if (_socket?.connected == true && nutritionistIds.isNotEmpty) {
      _socket!.emit('subscribe-nutritionist-status', nutritionistIds);
    }
  }

  void unsubscribeFromNutritionistStatus(List<String> nutritionistIds) {
    if (_socket?.connected == true && nutritionistIds.isNotEmpty) {
      _socket!.emit('unsubscribe-nutritionist-status', nutritionistIds);
    }
  }

  void disconnect() {
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _setConnectionStatus(NutritionistConnectionStatus.disconnected);
  }

  void dispose() {
    disconnect();
    _connectionStatusController.close();
    _statusUpdateController.close();
    _errorController.close();
  }
}

// Provider instances
final nutritionistStatusWebSocketServiceProvider = Provider<NutritionistStatusWebSocketService>((ref) {
  final service = NutritionistStatusWebSocketService();
  
  // 自动连接当有token时
  ref.listen(authProvider, (previous, next) {
    if (next.token != null && next.user?.role == 'nutritionist') {
      service.connect(next.token!);
    } else {
      service.disconnect();
    }
  });

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

// Connection status provider
final nutritionistWebSocketConnectionProvider = StreamProvider<NutritionistConnectionStatus>((ref) {
  final service = ref.watch(nutritionistStatusWebSocketServiceProvider);
  return service.connectionStatus;
});

// Status updates provider
final nutritionistStatusUpdatesProvider = StreamProvider<NutritionistStatusUpdate>((ref) {
  final service = ref.watch(nutritionistStatusWebSocketServiceProvider);
  return service.statusUpdates;
});

// Error stream provider
final nutritionistWebSocketErrorProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final service = ref.watch(nutritionistStatusWebSocketServiceProvider);
  return service.errors;
});