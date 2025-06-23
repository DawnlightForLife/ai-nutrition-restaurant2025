import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

class ChatMessageBubble extends StatefulWidget {
  final ChatMessageEntity message;
  final bool isConsecutive;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ChatMessageBubble({
    Key? key,
    required this.message,
    this.isConsecutive = false,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  bool get _isFromCurrentUser {
    // TODO: 从用户服务获取当前用户ID进行比较
    // 目前临时使用发送者类型判断
    return widget.message.senderType == MessageSenderType.user;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Container(
        margin: EdgeInsets.only(
          top: widget.isConsecutive ? 2 : 8,
          bottom: 2,
          left: _isFromCurrentUser ? 64 : 16,
          right: _isFromCurrentUser ? 16 : 64,
        ),
        child: Column(
          crossAxisAlignment: _isFromCurrentUser 
              ? CrossAxisAlignment.end 
              : CrossAxisAlignment.start,
          children: [
            if (!widget.isConsecutive && !_isFromCurrentUser)
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4),
                child: Text(
                  widget.message.senderName,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: _isFromCurrentUser 
                  ? MainAxisAlignment.end 
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_isFromCurrentUser) ...[
                  _buildMessageStatus(),
                  const SizedBox(width: 8),
                  _buildMessageTime(),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: _buildMessageContent(),
                ),
                if (!_isFromCurrentUser) ...[
                  const SizedBox(width: 8),
                  _buildMessageTime(),
                  const SizedBox(width: 8),
                  _buildMessageStatus(),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    return Container(
      decoration: BoxDecoration(
        color: _isFromCurrentUser ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(16).copyWith(
          bottomRight: _isFromCurrentUser ? const Radius.circular(4) : null,
          bottomLeft: !_isFromCurrentUser ? const Radius.circular(4) : null,
        ),
        border: !_isFromCurrentUser ? Border.all(
          color: AppColors.border,
          width: 1,
        ) : null,
      ),
      child: _buildContentByType(),
    );
  }

  Widget _buildContentByType() {
    switch (widget.message.messageType) {
      case MessageType.text:
        return _buildTextContent();
      case MessageType.image:
        return _buildImageContent();
      case MessageType.voice:
        return _buildVoiceContent();
      case MessageType.systemNotice:
        return _buildSystemContent();
      default:
        return _buildTextContent();
    }
  }

  Widget _buildTextContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        widget.message.content,
        style: AppTextStyles.body.copyWith(
          color: _isFromCurrentUser ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    // 获取图片附件
    final imageAttachment = widget.message.attachments.firstWhere(
      (attachment) => attachment.type == AttachmentType.image,
      orElse: () => const MessageAttachment(
        id: '',
        url: '',
        type: AttachmentType.image,
        fileName: '',
        fileSize: 0,
      ),
    );
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(16).copyWith(
        bottomRight: _isFromCurrentUser ? const Radius.circular(4) : null,
        bottomLeft: !_isFromCurrentUser ? const Radius.circular(4) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageAttachment.url.isNotEmpty)
            GestureDetector(
              onTap: () => _showImagePreview(imageAttachment.url),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 200,
                  maxHeight: 200,
                ),
                child: CachedNetworkImage(
                  imageUrl: imageAttachment.url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 200,
                    height: 150,
                    color: AppColors.background,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 200,
                    height: 150,
                    color: AppColors.background,
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          if (widget.message.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                widget.message.content,
                style: AppTextStyles.body.copyWith(
                  color: _isFromCurrentUser ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVoiceContent() {
    // 获取语音附件
    final voiceAttachment = widget.message.attachments.firstWhere(
      (attachment) => attachment.type == AttachmentType.audio,
      orElse: () => const MessageAttachment(
        id: '',
        url: '',
        type: AttachmentType.audio,
        fileName: '',
        fileSize: 0,
      ),
    );
    
    // 从metadata中获取语音时长，默认为文件大小估算
    final duration = voiceAttachment.metadata['duration'] as int? ?? 
                    (voiceAttachment.fileSize / 1000).round(); // 简单估算
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _toggleVoicePlay(voiceAttachment.url),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _isFromCurrentUser 
                    ? Colors.white.withOpacity(0.2) 
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: _isFromCurrentUser ? Colors.white : AppColors.primary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (_isPlaying && _duration.inSeconds > 0)
            Expanded(
              child: LinearProgressIndicator(
                value: _position.inSeconds / _duration.inSeconds,
                backgroundColor: _isFromCurrentUser 
                    ? Colors.white.withOpacity(0.3) 
                    : AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _isFromCurrentUser ? Colors.white : AppColors.primary,
                ),
              ),
            )
          else
            Expanded(
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: _isFromCurrentUser 
                      ? Colors.white.withOpacity(0.3) 
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          const SizedBox(width: 12),
          Text(
            '${duration}s',
            style: AppTextStyles.caption.copyWith(
              color: _isFromCurrentUser 
                  ? Colors.white.withOpacity(0.8) 
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        widget.message.content,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMessageTime() {
    final timeFormat = DateFormat('HH:mm');
    return Text(
      timeFormat.format(widget.message.createdAt),
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textSecondary,
        fontSize: 10,
      ),
    );
  }

  Widget _buildMessageStatus() {
    if (!_isFromCurrentUser) return const SizedBox.shrink();

    // 简化消息状态显示，基于现有字段
    if (widget.message.isRead) {
      return Icon(
        Icons.done_all,
        size: 12,
        color: AppColors.primary,
      );
    } else {
      return Icon(
        Icons.check,
        size: 12,
        color: AppColors.textSecondary,
      );
    }
  }

  void _toggleVoicePlay(String voiceUrl) async {
    if (voiceUrl.isEmpty) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(UrlSource(voiceUrl));
      }
    } catch (e) {
      debugPrint('Error playing audio: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('语音播放失败')),
        );
      }
    }
  }

  void _showImagePreview(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error, color: Colors.white),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}