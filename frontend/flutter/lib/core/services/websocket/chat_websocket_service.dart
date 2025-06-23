import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../features/consultation/domain/entities/chat_message_entity.dart';
import '../../../features/consultation/domain/entities/consultation_entity.dart';
import '../../config/app_constants.dart';
import '../auth/auth_service.dart';

class ChatWebSocketService {
  static final ChatWebSocketService _instance = ChatWebSocketService._internal();
  factory ChatWebSocketService() => _instance;
  ChatWebSocketService._internal();

  io.Socket? _socket;
  bool _isConnected = false;
  String? _currentConsultationId;
  
  // 事件流控制器
  final _messageController = StreamController<ChatMessageEntity>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();
  final _typingController = StreamController<TypingEvent>.broadcast();
  final _readStatusController = StreamController<ReadStatusEvent>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  final _consultationStatusController = StreamController<ConsultationStatusEvent>.broadcast();

  // Getters for streams
  Stream<ChatMessageEntity> get messageStream => _messageController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<TypingEvent> get typingStream => _typingController.stream;
  Stream<ReadStatusEvent> get readStatusStream => _readStatusController.stream;
  Stream<String> get errorStream => _errorController.stream;
  Stream<ConsultationStatusEvent> get consultationStatusStream => _consultationStatusController.stream;

  bool get isConnected => _isConnected;
  String? get currentConsultationId => _currentConsultationId;

  /// 初始化WebSocket连接
  Future<void> initialize() async {
    if (_socket != null) {
      await disconnect();
    }

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception('用户未登录');
      }

      _socket = io.io('${AppConstants.serverBaseUrl}/consultation-chat', {
        'transports': ['websocket'],
        'autoConnect': false,
        'auth': {'token': token},
        'timeout': 20000,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 1000,
      });

      _setupEventHandlers();
      _socket!.connect();

      debugPrint('WebSocket服务初始化完成');
    } catch (e) {
      debugPrint('WebSocket初始化失败: $e');
      _errorController.add('连接失败：$e');
    }
  }

  /// 设置事件处理器
  void _setupEventHandlers() {
    if (_socket == null) return;

    // 连接成功
    _socket!.on('connect', (data) {
      debugPrint('WebSocket连接成功');
      _isConnected = true;
      _connectionController.add(true);
    });

    // 连接断开
    _socket!.on('disconnect', (data) {
      debugPrint('WebSocket连接断开: $data');
      _isConnected = false;
      _connectionController.add(false);
    });

    // 连接错误
    _socket!.on('connect_error', (error) {
      debugPrint('WebSocket连接错误: $error');
      _isConnected = false;
      _connectionController.add(false);
      _errorController.add('连接错误：$error');
    });

    // 加入咨询成功
    _socket!.on('consultation-joined', (data) {
      debugPrint('成功加入咨询：${data['consultation']['id']}');
      _currentConsultationId = data['consultation']['id'];
      
      // 发送历史消息
      final List<dynamic> messages = data['messages'] ?? [];
      for (final messageData in messages) {
        try {
          final message = _parseMessage(messageData);
          _messageController.add(message);
        } catch (e) {
          debugPrint('解析历史消息失败: $e');
        }
      }
    });

    // 新消息
    _socket!.on('new-message', (data) {
      try {
        final message = _parseMessage(data);
        _messageController.add(message);
        debugPrint('收到新消息：${message.content}');
      } catch (e) {
        debugPrint('解析新消息失败: $e');
        _errorController.add('消息解析失败');
      }
    });

    // 用户正在输入
    _socket!.on('user-typing', (data) {
      final event = TypingEvent(
        consultationId: data['consultationId'],
        userId: data['userId'],
        isTyping: true,
        timestamp: DateTime.parse(data['timestamp']),
      );
      _typingController.add(event);
    });

    // 用户停止输入
    _socket!.on('user-stop-typing', (data) {
      final event = TypingEvent(
        consultationId: data['consultationId'],
        userId: data['userId'],
        isTyping: false,
        timestamp: DateTime.now(),
      );
      _typingController.add(event);
    });

    // 消息已读
    _socket!.on('messages-read', (data) {
      final event = ReadStatusEvent(
        consultationId: data['consultationId'],
        messageIds: List<String>.from(data['messageIds']),
        readBy: data['readBy'],
        timestamp: DateTime.parse(data['timestamp']),
      );
      _readStatusController.add(event);
    });

    // 咨询状态变更
    _socket!.on('consultation-status-changed', (data) {
      final event = ConsultationStatusEvent(
        consultationId: data['consultationId'],
        status: ConsultationStatus.values.firstWhere(
          (s) => s.name == data['status'],
          orElse: () => ConsultationStatus.pending,
        ),
        startTime: data['startTime'] != null 
          ? DateTime.parse(data['startTime'])
          : null,
      );
      _consultationStatusController.add(event);
    });

    // 用户加入/离开
    _socket!.on('user-joined', (data) {
      debugPrint('用户加入咨询：${data['userId']}');
    });

    _socket!.on('user-left', (data) {
      debugPrint('用户离开咨询：${data['userId']}');
    });

    // 咨询结束
    _socket!.on('consultation-ended', (data) {
      debugPrint('咨询已结束：${data['consultationId']}');
      _currentConsultationId = null;
    });

    // 系统消息
    _socket!.on('system-message', (data) {
      debugPrint('系统消息：${data['content']}');
    });

    // 错误处理
    _socket!.on('error', (error) {
      debugPrint('WebSocket错误: $error');
      final message = error is Map ? error['message'] : error.toString();
      _errorController.add(message);
    });
  }

  /// 加入咨询房间
  Future<void> joinConsultation(String consultationId) async {
    if (_socket == null || !_isConnected) {
      throw Exception('WebSocket未连接');
    }

    _socket!.emit('join-consultation', {
      'consultationId': consultationId,
    });

    debugPrint('请求加入咨询：$consultationId');
  }

  /// 离开咨询房间
  Future<void> leaveConsultation(String consultationId) async {
    if (_socket == null || !_isConnected) return;

    _socket!.emit('leave-consultation', {
      'consultationId': consultationId,
    });

    if (_currentConsultationId == consultationId) {
      _currentConsultationId = null;
    }

    debugPrint('离开咨询：$consultationId');
  }

  /// 发送消息
  Future<void> sendMessage({
    required String consultationId,
    required String content,
    required MessageType messageType,
    List<Map<String, dynamic>>? attachments,
  }) async {
    if (_socket == null || !_isConnected) {
      throw Exception('WebSocket未连接');
    }

    _socket!.emit('send-message', {
      'consultationId': consultationId,
      'content': content,
      'messageType': messageType.name,
      'attachments': attachments ?? [],
    });

    debugPrint('发送消息：$content');
  }

  /// 发送正在输入状态
  void sendTyping(String consultationId) {
    if (_socket == null || !_isConnected) return;

    _socket!.emit('typing', {
      'consultationId': consultationId,
    });
  }

  /// 发送停止输入状态
  void sendStopTyping(String consultationId) {
    if (_socket == null || !_isConnected) return;

    _socket!.emit('stop-typing', {
      'consultationId': consultationId,
    });
  }

  /// 标记消息已读
  Future<void> markMessagesAsRead({
    required String consultationId,
    required List<String> messageIds,
  }) async {
    if (_socket == null || !_isConnected) return;

    _socket!.emit('mark-read', {
      'consultationId': consultationId,
      'messageIds': messageIds,
    });
  }

  /// 断开连接
  Future<void> disconnect() async {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }

    _isConnected = false;
    _currentConsultationId = null;
    _connectionController.add(false);

    debugPrint('WebSocket连接已断开');
  }

  /// 解析消息数据
  ChatMessageEntity _parseMessage(dynamic data) {
    return ChatMessageEntity(
      id: data['id'].toString(),
      consultationId: data['consultationId'].toString(),
      senderId: data['senderId'].toString(),
      senderName: data['senderName']?.toString() ?? '',
      senderType: MessageSenderType.values.firstWhere(
        (type) => type.name == data['senderType'],
        orElse: () => MessageSenderType.user,
      ),
      messageType: MessageType.values.firstWhere(
        (type) => type.name == data['messageType'],
        orElse: () => MessageType.text,
      ),
      content: data['content']?.toString() ?? '',
      attachments: _parseAttachments(data['attachments']),
      isRead: data['isRead'] ?? false,
      isDeleted: data['deleted'] ?? false,
      createdAt: DateTime.parse(data['sentAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// 解析附件数据
  List<MessageAttachment> _parseAttachments(dynamic attachments) {
    if (attachments == null) return [];
    
    final List<dynamic> attachmentList = attachments is List 
      ? attachments 
      : [attachments];

    return attachmentList.map((attachment) {
      return MessageAttachment(
        id: attachment['id']?.toString() ?? '',
        url: attachment['url']?.toString() ?? '',
        type: AttachmentType.values.firstWhere(
          (type) => type.name == attachment['type'],
          orElse: () => AttachmentType.other,
        ),
        fileName: attachment['fileName']?.toString() ?? '',
        fileSize: attachment['fileSize'] ?? 0,
        mimeType: attachment['mimeType']?.toString() ?? '',
        metadata: Map<String, dynamic>.from(attachment['metadata'] ?? {}),
      );
    }).toList();
  }

  /// 释放资源
  void dispose() {
    disconnect();
    _messageController.close();
    _connectionController.close();
    _typingController.close();
    _readStatusController.close();
    _errorController.close();
    _consultationStatusController.close();
  }
}

// 事件数据类
class TypingEvent {
  final String consultationId;
  final String userId;
  final bool isTyping;
  final DateTime timestamp;

  TypingEvent({
    required this.consultationId,
    required this.userId,
    required this.isTyping,
    required this.timestamp,
  });
}

class ReadStatusEvent {
  final String consultationId;
  final List<String> messageIds;
  final String readBy;
  final DateTime timestamp;

  ReadStatusEvent({
    required this.consultationId,
    required this.messageIds,
    required this.readBy,
    required this.timestamp,
  });
}

class ConsultationStatusEvent {
  final String consultationId;
  final ConsultationStatus status;
  final DateTime? startTime;

  ConsultationStatusEvent({
    required this.consultationId,
    required this.status,
    this.startTime,
  });
}