import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/consultation_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../providers/chat_websocket_provider.dart';
import '../providers/consultation_provider.dart';
import '../widgets/chat_message_list.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/typing_indicator.dart';
import '../../../../shared/widgets/common/loading_overlay.dart';

class ConsultationChatPage extends ConsumerStatefulWidget {
  final String consultationId;

  const ConsultationChatPage({
    Key? key,
    required this.consultationId,
  }) : super(key: key);

  @override
  ConsumerState<ConsultationChatPage> createState() => _ConsultationChatPageState();
}

class _ConsultationChatPageState extends ConsumerState<ConsultationChatPage>
    with WidgetsBindingObserver {
  bool _isInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeChat();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _leaveChat();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // 应用进入后台时停止输入状态
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      final inputNotifier = ref.read(chatInputProvider(widget.consultationId).notifier);
      inputNotifier.clear();
    }
  }

  Future<void> _initializeChat() async {
    try {
      setState(() => _isLoading = true);

      // 获取咨询信息
      final consultationAsync = ref.read(consultationProvider(widget.consultationId));
      await consultationAsync.when(
        data: (consultation) async {
          if (consultation == null) {
            _showError('咨询不存在');
            return;
          }

          // 初始化WebSocket连接
          final webSocketService = ref.read(chatWebSocketServiceProvider);
          await webSocketService.initializeAndJoin(widget.consultationId);

          // 设置当前咨询房间
          ref.read(currentConsultationRoomProvider.notifier).state = widget.consultationId;

          setState(() {
            _isInitialized = true;
            _isLoading = false;
          });
        },
        loading: () => Future.value(),
        error: (error, stack) {
          _showError('加载咨询失败：$error');
        },
      );
    } catch (e) {
      _showError('初始化聊天失败：$e');
    }
  }

  Future<void> _leaveChat() async {
    if (_isInitialized) {
      try {
        final webSocketService = ref.read(chatWebSocketServiceProvider);
        await webSocketService.leaveConsultation(widget.consultationId);
        ref.read(currentConsultationRoomProvider.notifier).state = null;
      } catch (e) {
        debugPrint('离开聊天失败：$e');
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: '重试',
            textColor: Colors.white,
            onPressed: _initializeChat,
          ),
        ),
      );
    }
  }

  void _sendTextMessage(String message) {
    final webSocketService = ref.read(chatWebSocketServiceProvider);
    webSocketService.sendMessage(
      consultationId: widget.consultationId,
      content: message,
      messageType: MessageType.text,
    );
  }

  void _sendImageMessage(String imagePath, String? caption) {
    // TODO: 实现图片上传和发送
    // 1. 上传图片到服务器
    // 2. 获取图片URL
    // 3. 发送消息
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('图片发送功能开发中')),
    );
  }

  void _sendVoiceMessage(String voicePath, int duration) {
    // TODO: 实现语音上传和发送
    // 1. 上传语音文件到服务器
    // 2. 获取语音URL
    // 3. 发送消息
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('语音发送功能开发中')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 监听WebSocket错误
    ref.listen<AsyncValue<String>>(
      chatWebSocketErrorProvider,
      (_, error) {
        error.whenData((errorMessage) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      },
    );

    // 监听咨询状态变更
    // TODO: 实现咨询状态变更监听
    // ref.listen<AsyncValue<ConsultationStatusEvent>>(
    //   consultationStatusStreamProvider(widget.consultationId),
    //   (_, statusEvent) {
    //     statusEvent.whenData((event) {
    //       if (mounted) {
    //         final statusName = event.status.displayName;
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(
    //             content: Text('咨询状态已更新：$statusName'),
    //             backgroundColor: Colors.blue,
    //           ),
    //         );
    //       }
    //     });
    //   },
    // );

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('聊天')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                '聊天初始化失败',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initializeChat,
                child: const Text('重新连接'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: ChatAppBar(consultationId: widget.consultationId),
      body: Column(
        children: [
          // 消息列表
          Expanded(
            child: ChatMessageList(consultationId: widget.consultationId),
          ),

          // 输入状态指示器
          Consumer(
            builder: (context, ref, child) {
              final typingAsync = ref.watch(typingStatusProvider(widget.consultationId));
              return typingAsync.when(
                data: (typingEvents) {
                  if (typingEvents.isEmpty) return const SizedBox.shrink();
                  return TypingIndicator(typingEvents: typingEvents);
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),

          // 输入栏
          Consumer(
            builder: (context, ref, child) {
              final consultation = ref.watch(consultationProvider(widget.consultationId));
              return consultation.when(
                data: (consultationData) {
                  if (consultationData == null) return const SizedBox.shrink();
                  
                  // 根据用户角色确定快速回复选项
                  // TODO: 实现用户角色判断
                  final quickReplies = QuickReplyOptions.userReplies;
                  
                  return ChatInputBar(
                    onSendText: (message) => _sendTextMessage(message),
                    onSendImage: (imagePath, caption) => _sendImageMessage(imagePath, caption),
                    onSendVoice: (voicePath, duration) => _sendVoiceMessage(voicePath, duration),
                    isEnabled: consultationData.status != ConsultationStatus.completed,
                    quickReplies: quickReplies,
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }
}

// 快速回复选项
class QuickReplyOptions {
  static const List<String> nutritionistReplies = [
    '好的，我来帮您分析一下',
    '请提供更多详细信息',
    '建议您注意饮食平衡',
    '这个问题需要结合您的具体情况',
    '我为您制定一个详细方案',
  ];

  static const List<String> userReplies = [
    '好的，谢谢',
    '我明白了',
    '还有其他问题吗？',
    '什么时候开始执行？',
    '需要注意什么？',
  ];
}