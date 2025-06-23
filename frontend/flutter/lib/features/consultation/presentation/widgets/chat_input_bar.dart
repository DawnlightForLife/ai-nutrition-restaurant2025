import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

enum InputType { text, voice }

class ChatInputBar extends StatefulWidget {
  final Function(String message) onSendText;
  final Function(String imagePath, String? caption) onSendImage;
  final Function(String voicePath, int duration) onSendVoice;
  final bool isEnabled;
  final List<String>? quickReplies;

  const ChatInputBar({
    Key? key,
    required this.onSendText,
    required this.onSendImage,
    required this.onSendVoice,
    this.isEnabled = true,
    this.quickReplies,
  }) : super(key: key);

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  
  InputType _currentInputType = InputType.text;
  bool _isRecording = false;
  bool _showQuickReplies = false;
  String? _recordingPath;
  Duration _recordingDuration = Duration.zero;
  late AnimationController _recordingAnimationController;
  late AnimationController _quickReplyAnimationController;
  late Animation<double> _recordingScaleAnimation;
  late Animation<double> _quickReplySlideAnimation;

  @override
  void initState() {
    super.initState();
    _recordingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _quickReplyAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _recordingScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _recordingAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _quickReplySlideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _quickReplyAnimationController,
      curve: Curves.easeOut,
    ));

    _textController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _recordingAnimationController.dispose();
    _quickReplyAnimationController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && _showQuickReplies) {
      _hideQuickReplies();
    }
  }

  void _showQuickRepliesWidget() {
    setState(() {
      _showQuickReplies = true;
    });
    _quickReplyAnimationController.forward();
  }

  void _hideQuickReplies() {
    _quickReplyAnimationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showQuickReplies = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Column(
        children: [
          if (_showQuickReplies && widget.quickReplies != null && widget.quickReplies!.isNotEmpty)
            _buildQuickReplies(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildQuickReplies() {
    return AnimatedBuilder(
      animation: _quickReplySlideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _quickReplySlideAnimation.value) * 50),
          child: Opacity(
            opacity: _quickReplySlideAnimation.value,
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.quickReplies!.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final reply = widget.quickReplies![index];
                  return GestureDetector(
                    onTap: () => _sendQuickReply(reply),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Text(
                        reply,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildActionButton(),
          const SizedBox(width: 12),
          Expanded(child: _buildInputField()),
          const SizedBox(width: 12),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return GestureDetector(
      onTap: widget.isEnabled ? _showActionMenu : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: widget.isEnabled ? AppColors.primary.withOpacity(0.1) : AppColors.border,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.add,
          color: widget.isEnabled ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildInputField() {
    if (_currentInputType == InputType.voice) {
      return _buildVoiceInput();
    }
    return _buildTextInput();
  }

  Widget _buildTextInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _textController,
        focusNode: _focusNode,
        enabled: widget.isEnabled,
        maxLines: 4,
        minLines: 1,
        decoration: InputDecoration(
          hintText: '输入消息...',
          hintStyle: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: AppTextStyles.body,
      ),
    );
  }

  Widget _buildVoiceInput() {
    return AnimatedBuilder(
      animation: _recordingScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isRecording ? _recordingScaleAnimation.value : 1.0,
          child: GestureDetector(
            onLongPressStart: (_) => _startRecording(),
            onLongPressEnd: (_) => _stopRecording(),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: _isRecording ? AppColors.error.withOpacity(0.1) : AppColors.background,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: _isRecording ? AppColors.error : AppColors.border,
                  width: _isRecording ? 2 : 1,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isRecording ? Icons.mic : Icons.mic_none,
                      color: _isRecording ? AppColors.error : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isRecording ? '松开发送，正在录音...' : '长按录音',
                      style: AppTextStyles.body.copyWith(
                        color: _isRecording ? AppColors.error : AppColors.textSecondary,
                      ),
                    ),
                    if (_isRecording) ...[
                      const SizedBox(width: 8),
                      Text(
                        '${_recordingDuration.inSeconds}s',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSendButton() {
    final canSend = _textController.text.trim().isNotEmpty;
    
    return Row(
      children: [
        if (widget.quickReplies != null && widget.quickReplies!.isNotEmpty)
          GestureDetector(
            onTap: _showQuickReplies ? _hideQuickReplies : _showQuickRepliesWidget,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _showQuickReplies ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.flash_on,
                color: _showQuickReplies ? Colors.white : AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _currentInputType = _currentInputType == InputType.text 
                  ? InputType.voice 
                  : InputType.text;
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _currentInputType == InputType.voice ? AppColors.primary : AppColors.border,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              _currentInputType == InputType.voice ? Icons.keyboard : Icons.mic,
              color: _currentInputType == InputType.voice ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: (canSend && widget.isEnabled) ? _sendTextMessage : null,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (canSend && widget.isEnabled) ? AppColors.primary : AppColors.border,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.send,
              color: (canSend && widget.isEnabled) ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  void _showActionMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('从相册选择'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendTextMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendText(text);
      _textController.clear();
    }
  }

  void _sendQuickReply(String reply) {
    widget.onSendText(reply);
    _hideQuickReplies();
  }

  void _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (image != null) {
        widget.onSendImage(image.path, null);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('选择图片失败')),
      );
    }
  }

  void _startRecording() async {
    if (!widget.isEnabled) return;

    final permission = await Permission.microphone.request();
    if (permission != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('需要麦克风权限才能录音')),
      );
      return;
    }

    try {
      final path = '${Directory.systemTemp.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      setState(() {
        _isRecording = true;
        _recordingPath = path;
        _recordingDuration = Duration.zero;
      });

      _recordingAnimationController.repeat(reverse: true);
      _startRecordingTimer();
    } catch (e) {
      debugPrint('Error starting recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('录音失败')),
      );
    }
  }

  void _stopRecording() async {
    if (!_isRecording) return;

    try {
      await _audioRecorder.stop();
      _recordingAnimationController.stop();
      _recordingAnimationController.reset();

      setState(() {
        _isRecording = false;
      });

      if (_recordingPath != null && _recordingDuration.inSeconds >= 1) {
        widget.onSendVoice(_recordingPath!, _recordingDuration.inSeconds);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('录音时间太短')),
        );
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('录音保存失败')),
      );
    }

    _recordingPath = null;
    _recordingDuration = Duration.zero;
  }

  void _startRecordingTimer() {
    if (!_isRecording) return;
    
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording && mounted) {
        setState(() {
          _recordingDuration = Duration(seconds: _recordingDuration.inSeconds + 1);
        });
        _startRecordingTimer();
      }
    });
  }
}