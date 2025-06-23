import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/services/websocket/chat_websocket_service.dart';

class TypingIndicator extends StatelessWidget {
  final List<TypingEvent> typingEvents;

  const TypingIndicator({
    Key? key,
    required this.typingEvents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (typingEvents.isEmpty) return const SizedBox.shrink();

    final typingUsers = typingEvents
        .where((event) => event.isTyping)
        .map((event) => event.userId)
        .toList();

    if (typingUsers.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // 输入动画
          _buildTypingAnimation(),
          const SizedBox(width: 8),
          
          // 输入文本
          Expanded(
            child: Text(
              _buildTypingText(typingUsers.length),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingAnimation() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          width: 6,
          height: 6,
          margin: EdgeInsets.only(right: index < 2 ? 2 : 0),
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.2, 1.2),
              duration: 600.ms,
              delay: (index * 200).ms,
            )
            .then()
            .scale(
              begin: const Offset(1.2, 1.2),
              end: const Offset(0.8, 0.8),
              duration: 600.ms,
            );
      }),
    );
  }

  String _buildTypingText(int userCount) {
    if (userCount == 1) {
      return '对方正在输入...';
    } else {
      return '$userCount 人正在输入...';
    }
  }
}

// 简化的输入指示器，用于消息气泡内
class SimpleTypingIndicator extends StatelessWidget {
  final bool show;

  const SimpleTypingIndicator({
    Key? key,
    this.show = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return Container(
            width: 4,
            height: 4,
            margin: EdgeInsets.only(right: index < 2 ? 3 : 0),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .fadeIn(duration: 200.ms, delay: (index * 100).ms)
              .then()
              .fadeOut(duration: 200.ms)
              .then()
              .fadeIn(duration: 200.ms);
        }),
      ),
    );
  }
}