import 'package:flutter/material.dart';
import '../../domain/entities/nutritionist.dart';

/// 在线状态指示器组件
class OnlineStatusIndicator extends StatelessWidget {
  final Nutritionist nutritionist;
  final bool showText;
  final double size;
  final EdgeInsets? padding;

  const OnlineStatusIndicator({
    super.key,
    required this.nutritionist,
    this.showText = true,
    this.size = 12.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: _getStatusColor(context).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: _getStatusColor(context),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 状态指示点
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: _getStatusColor(context),
              shape: BoxShape.circle,
            ),
          ),
          if (showText) ...[
            const SizedBox(width: 6.0),
            Text(
              nutritionist.onlineStatusText,
              style: TextStyle(
                color: _getStatusColor(context),
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    switch (nutritionist.onlineStatusColor) {
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      case 'gray':
      default:
        return Colors.grey;
    }
  }
}

/// 详细在线状态卡片
class OnlineStatusCard extends StatelessWidget {
  final Nutritionist nutritionist;
  final bool showLastActive;
  final bool showResponseTime;

  const OnlineStatusCard({
    super.key,
    required this.nutritionist,
    this.showLastActive = true,
    this.showResponseTime = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 主要状态
            Row(
              children: [
                OnlineStatusIndicator(
                  nutritionist: nutritionist,
                  showText: true,
                ),
                const Spacer(),
                if (nutritionist.statusMessage != null) 
                  Expanded(
                    flex: 2,
                    child: Text(
                      nutritionist.statusMessage!,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 12.0),
            
            // 可用咨询类型
            if (nutritionist.availableConsultationTypes.isNotEmpty) ...[
              const Text(
                '可用咨询方式',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                children: nutritionist.availableConsultationTypes.map((type) {
                  return Chip(
                    label: Text(
                      '${type.icon} ${type.displayName}',
                      style: const TextStyle(fontSize: 12.0),
                    ),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12.0),
            ],
            
            // 额外信息
            if (showLastActive || showResponseTime) ...[
              Row(
                children: [
                  if (showLastActive) ...[
                    const Icon(Icons.access_time, size: 16.0, color: Colors.grey),
                    const SizedBox(width: 4.0),
                    Text(
                      nutritionist.lastActiveText,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                  if (showLastActive && showResponseTime) const Spacer(),
                  if (showResponseTime) ...[
                    const Icon(Icons.reply, size: 16.0, color: Colors.grey),
                    const SizedBox(width: 4.0),
                    Text(
                      nutritionist.responseTimeText,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 简洁的在线状态徽章
class OnlineStatusBadge extends StatelessWidget {
  final Nutritionist nutritionist;

  const OnlineStatusBadge({
    super.key,
    required this.nutritionist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: _getStatusColor(),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        nutritionist.onlineStatusText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (nutritionist.onlineStatusColor) {
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      case 'gray':
      default:
        return Colors.grey;
    }
  }
}

/// 动态在线状态指示器（带动画）
class AnimatedOnlineStatusIndicator extends StatefulWidget {
  final Nutritionist nutritionist;
  final bool showText;

  const AnimatedOnlineStatusIndicator({
    super.key,
    required this.nutritionist,
    this.showText = true,
  });

  @override
  State<AnimatedOnlineStatusIndicator> createState() => _AnimatedOnlineStatusIndicatorState();
}

class _AnimatedOnlineStatusIndicatorState extends State<AnimatedOnlineStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // 只有在线状态才显示脉冲动画
    if (widget.nutritionist.isOnline && widget.nutritionist.isAvailable) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedOnlineStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 状态变化时更新动画
    if (widget.nutritionist.isOnline && widget.nutritionist.isAvailable) {
      if (!_controller.isAnimating) {
        _controller.repeat(reverse: true);
      }
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.nutritionist.isOnline && widget.nutritionist.isAvailable 
              ? _pulseAnimation.value 
              : 1.0,
          child: OnlineStatusIndicator(
            nutritionist: widget.nutritionist,
            showText: widget.showText,
          ),
        );
      },
    );
  }
}