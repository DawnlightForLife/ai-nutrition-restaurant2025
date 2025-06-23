import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/websocket/chat_websocket_service.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/consultation_entity.dart';

// WebSocket服务提供者
final chatWebSocketServiceProvider = Provider<ChatWebSocketService>((ref) {
  final service = ChatWebSocketService();
  
  // 当Provider被销毁时清理资源
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

// WebSocket连接状态提供者
final chatConnectionStateProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(chatWebSocketServiceProvider);
  return service.connectionStream;
});

// 当前咨询房间提供者
final currentConsultationRoomProvider = StateProvider<String?>((ref) => null);

// 聊天消息流提供者
final chatMessageStreamProvider = StreamProvider.family<ChatMessageEntity, String>((ref, consultationId) {
  final service = ref.watch(chatWebSocketServiceProvider);
  return service.messageStream.where((message) => message.consultationId == consultationId);
});

// 聊天消息列表提供者
final chatMessagesProvider = StateNotifierProvider.family<ChatMessagesNotifier, List<ChatMessageEntity>, String>((ref, consultationId) {
  return ChatMessagesNotifier(consultationId, ref);
});

// 输入状态提供者
final typingStatusProvider = StreamProvider.family<List<TypingEvent>, String>((ref, consultationId) {
  final service = ref.watch(chatWebSocketServiceProvider);
  return service.typingStream
    .where((event) => event.consultationId == consultationId)
    .scan<List<TypingEvent>>((accumulated, event, index) {
      final now = DateTime.now();
      // 移除超过5秒的输入状态
      accumulated.removeWhere((e) => now.difference(e.timestamp).inSeconds > 5);
      
      if (event.isTyping) {
        // 添加或更新输入状态
        accumulated.removeWhere((e) => e.userId == event.userId);
        accumulated.add(event);
      } else {
        // 移除输入状态
        accumulated.removeWhere((e) => e.userId == event.userId);
      }
      
      return List.from(accumulated);
    }, <TypingEvent>[]);
});

// 消息已读状态提供者
final messageReadStatusProvider = StreamProvider.family<ReadStatusEvent, String>((ref, consultationId) {
  final service = ref.watch(chatWebSocketServiceProvider);
  return service.readStatusStream.where((event) => event.consultationId == consultationId);
});

// 咨询状态提供者
final consultationStatusStreamProvider = StreamProvider.family<ConsultationStatusEvent, String>((ref, consultationId) {
  final service = ref.watch(chatWebSocketServiceProvider);
  return service.consultationStatusStream.where((event) => event.consultationId == consultationId);
});

// WebSocket错误提供者
final chatWebSocketErrorProvider = StreamProvider<String>((ref) {
  final service = ref.watch(chatWebSocketServiceProvider);
  return service.errorStream;
});

// 聊天消息管理器
class ChatMessagesNotifier extends StateNotifier<List<ChatMessageEntity>> {
  final String consultationId;
  final Ref ref;

  ChatMessagesNotifier(this.consultationId, this.ref) : super([]) {
    _init();
  }

  void _init() {
    // 监听新消息
    ref.listen<AsyncValue<ChatMessageEntity>>(
      chatMessageStreamProvider(consultationId),
      (_, next) {
        next.whenData((message) {
          _addMessage(message);
        });
      },
    );

    // 监听已读状态更新
    ref.listen<AsyncValue<ReadStatusEvent>>(
      messageReadStatusProvider(consultationId),
      (_, next) {
        next.whenData((event) {
          _updateReadStatus(event);
        });
      },
    );
  }

  void _addMessage(ChatMessageEntity message) {
    // 检查消息是否已存在
    final existingIndex = state.indexWhere((m) => m.id == message.id);
    if (existingIndex >= 0) {
      // 更新现有消息
      final newState = List<ChatMessageEntity>.from(state);
      newState[existingIndex] = message;
      state = newState;
    } else {
      // 添加新消息，按时间排序
      final newState = List<ChatMessageEntity>.from(state);
      newState.add(message);
      newState.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      state = newState;
    }
  }

  void _updateReadStatus(ReadStatusEvent event) {
    final newState = state.map((message) {
      if (event.messageIds.contains(message.id)) {
        return message.copyWith(
          isRead: true,
          readAt: event.timestamp,
        );
      }
      return message;
    }).toList();
    
    state = newState;
  }

  void addLocalMessage(ChatMessageEntity message) {
    _addMessage(message);
  }

  void updateMessage(String messageId, ChatMessageEntity updatedMessage) {
    final newState = state.map((message) {
      return message.id == messageId ? updatedMessage : message;
    }).toList();
    
    state = newState;
  }

  void removeMessage(String messageId) {
    state = state.where((message) => message.id != messageId).toList();
  }

  void loadHistoryMessages(List<ChatMessageEntity> messages) {
    // 合并历史消息，避免重复
    final existingIds = state.map((m) => m.id).toSet();
    final newMessages = messages.where((m) => !existingIds.contains(m.id)).toList();
    
    final allMessages = [...state, ...newMessages];
    allMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    
    state = allMessages;
  }

  void clearMessages() {
    state = [];
  }
}

// 聊天输入状态管理器
class ChatInputNotifier extends StateNotifier<ChatInputState> {
  final String consultationId;
  final Ref ref;

  ChatInputNotifier(this.consultationId, this.ref) : super(const ChatInputState());

  void updateText(String text) {
    state = state.copyWith(text: text);
    
    // 发送输入状态
    if (text.isNotEmpty && !state.isTyping) {
      _sendTypingStatus(true);
    } else if (text.isEmpty && state.isTyping) {
      _sendTypingStatus(false);
    }
  }

  void _sendTypingStatus(bool isTyping) {
    state = state.copyWith(isTyping: isTyping);
    
    final service = ref.read(chatWebSocketServiceProvider);
    if (isTyping) {
      service.sendTyping(consultationId);
    } else {
      service.sendStopTyping(consultationId);
    }
  }

  void setRecording(bool isRecording) {
    state = state.copyWith(isRecording: isRecording);
  }

  void clear() {
    state = const ChatInputState();
    _sendTypingStatus(false);
  }
}

// 聊天输入状态
class ChatInputState {
  final String text;
  final bool isTyping;
  final bool isRecording;

  const ChatInputState({
    this.text = '',
    this.isTyping = false,
    this.isRecording = false,
  });

  ChatInputState copyWith({
    String? text,
    bool? isTyping,
    bool? isRecording,
  }) {
    return ChatInputState(
      text: text ?? this.text,
      isTyping: isTyping ?? this.isTyping,
      isRecording: isRecording ?? this.isRecording,
    );
  }
}

// 聊天输入提供者
final chatInputProvider = StateNotifierProvider.family<ChatInputNotifier, ChatInputState, String>((ref, consultationId) {
  return ChatInputNotifier(consultationId, ref);
});

// 扩展方法，用于简化操作
extension ChatWebSocketServiceX on ChatWebSocketService {
  Future<void> initializeAndJoin(String consultationId) async {
    if (!isConnected) {
      await initialize();
      
      // 等待连接成功
      await connectionStream.firstWhere((connected) => connected);
    }
    
    await joinConsultation(consultationId);
  }
}