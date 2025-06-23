import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../providers/chat_websocket_provider.dart';
import 'chat_message_bubble.dart';
import 'typing_indicator.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';

class ChatMessageList extends ConsumerStatefulWidget {
  final String consultationId;

  const ChatMessageList({
    Key? key,
    required this.consultationId,
  }) : super(key: key);

  @override
  ConsumerState<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends ConsumerState<ChatMessageList> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = true;
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isAtBottom = _scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 100;
    
    if (_isAtBottom != isAtBottom) {
      setState(() {
        _isAtBottom = isAtBottom;
        _showScrollToBottom = !isAtBottom;
      });
    }
  }

  void _scrollToBottom({bool animate = true}) {
    if (_scrollController.hasClients) {
      if (animate) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.consultationId));
    
    // 监听新消息，自动滚动到底部
    ref.listen<List<ChatMessageEntity>>(
      chatMessagesProvider(widget.consultationId),
      (previous, next) {
        if (previous != null && next.length > previous.length && _isAtBottom) {
          // 新消息到达且用户在底部时，自动滚动
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
      },
    );

    return Stack(
      children: [
        // 消息列表
        _buildMessageList(messagesAsync),
        
        // 滚动到底部按钮
        if (_showScrollToBottom)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.small(
              onPressed: () => _scrollToBottom(),
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildMessageList(List<ChatMessageEntity> messages) {
    if (messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final previousMessage = index > 0 ? messages[index - 1] : null;
        final nextMessage = index < messages.length - 1 ? messages[index + 1] : null;

        // 判断是否显示时间分隔符
        final showTimeDivider = _shouldShowTimeDivider(message, previousMessage);
        
        // 判断是否是连续消息（用于优化气泡显示）
        final isConsecutive = _isConsecutiveMessage(message, previousMessage, nextMessage);

        return Column(
          children: [
            // 时间分隔符
            if (showTimeDivider) _buildTimeDivider(message.createdAt),
            
            // 消息气泡
            ChatMessageBubble(
              message: message,
              isConsecutive: isConsecutive,
              onTap: () => _onMessageTap(message),
              onLongPress: () => _onMessageLongPress(message),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '还没有消息',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '开始你们的对话吧！',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDivider(DateTime time) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _formatTime(time),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldShowTimeDivider(ChatMessageEntity message, ChatMessageEntity? previousMessage) {
    if (previousMessage == null) return true;
    
    final timeDifference = message.createdAt.difference(previousMessage.createdAt);
    return timeDifference.inMinutes > 5; // 超过5分钟显示时间分隔符
  }

  bool _isConsecutiveMessage(
    ChatMessageEntity message,
    ChatMessageEntity? previousMessage,
    ChatMessageEntity? nextMessage,
  ) {
    if (previousMessage == null) return false;
    
    // 同一发送者且时间间隔较短
    return message.senderType == previousMessage.senderType &&
           message.senderId == previousMessage.senderId &&
           message.createdAt.difference(previousMessage.createdAt).inMinutes < 2;
  }

  void _onMessageTap(ChatMessageEntity message) {
    // 处理消息点击，例如查看大图、播放语音等
    if (message.messageType == MessageType.image) {
      _showImagePreview(message);
    } else if (message.messageType == MessageType.voice) {
      _playAudioMessage(message);
    }
  }

  void _onMessageLongPress(ChatMessageEntity message) {
    _showMessageOptions(message);
  }

  void _showImagePreview(ChatMessageEntity message) {
    // TODO: 实现图片预览
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('图片预览功能开发中'),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('关闭'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _playAudioMessage(ChatMessageEntity message) {
    // TODO: 实现语音播放
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('语音播放功能开发中')),
    );
  }

  void _showMessageOptions(ChatMessageEntity message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('复制'),
              onTap: () {
                Navigator.of(context).pop();
                _copyMessage(message);
              },
            ),
            if (message.messageType == MessageType.voice)
              ListTile(
                leading: const Icon(Icons.play_arrow),
                title: const Text('播放'),
                onTap: () {
                  Navigator.of(context).pop();
                  _playAudioMessage(message);
                },
              ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('消息详情'),
              onTap: () {
                Navigator.of(context).pop();
                _showMessageDetails(message);
              },
            ),
            // 只有自己的消息才能删除
            if (_isMyMessage(message))
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('删除', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.of(context).pop();
                  _deleteMessage(message);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _copyMessage(ChatMessageEntity message) {
    // TODO: 实现复制功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已复制到剪贴板')),
    );
  }

  void _showMessageDetails(ChatMessageEntity message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('消息详情'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('发送者：${message.senderName}'),
            Text('类型：${message.messageType.displayName}'),
            Text('时间：${_formatDateTime(message.createdAt)}'),
            Text('状态：${message.isRead ? "已读" : "未读"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _deleteMessage(ChatMessageEntity message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除消息'),
        content: const Text('确定要删除这条消息吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 实现删除消息功能
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('删除功能开发中')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  bool _isMyMessage(ChatMessageEntity message) {
    // TODO: 实现判断是否是当前用户的消息
    return true; // 临时返回true
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(time.year, time.month, time.day);
    
    if (messageDay == today) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (messageDay == today.subtract(const Duration(days: 1))) {
      return '昨天 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.month}月${time.day}日 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatDateTime(DateTime time) {
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} '
           '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}