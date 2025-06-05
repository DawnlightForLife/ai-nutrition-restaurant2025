import 'dart:async';
import 'package:flutter/material.dart';

/// 倒计时组件
class CountdownTimerWidget extends StatefulWidget {
  final DateTime endTime;
  final TextStyle? textStyle;
  final String? prefix;
  final String? suffix;
  final VoidCallback? onEnd;
  final bool showIcon;
  
  const CountdownTimerWidget({
    super.key,
    required this.endTime,
    this.textStyle,
    this.prefix,
    this.suffix,
    this.onEnd,
    this.showIcon = false,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Timer _timer;
  Duration _remaining = Duration.zero;
  
  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }
  
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  
  void _updateRemaining() {
    final now = DateTime.now();
    final remaining = widget.endTime.difference(now);
    
    setState(() {
      _remaining = remaining.isNegative ? Duration.zero : remaining;
    });
    
    if (_remaining == Duration.zero && widget.onEnd != null) {
      widget.onEnd!();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = widget.textStyle ?? theme.textTheme.titleMedium;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showIcon) ...[
          Icon(
            Icons.access_time,
            size: textStyle?.fontSize,
            color: textStyle?.color ?? theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
        ],
        if (widget.prefix != null)
          Text(widget.prefix!, style: textStyle),
        Text(
          _formatDuration(_remaining),
          style: textStyle?.copyWith(
            fontWeight: FontWeight.bold,
            color: _remaining.inMinutes < 5 
                ? theme.colorScheme.error 
                : textStyle.color,
          ),
        ),
        if (widget.suffix != null)
          Text(widget.suffix!, style: textStyle),
      ],
    );
  }
  
  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) {
      return '已结束';
    }
    
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    if (days > 0) {
      return '$days天 ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}

/// 简单倒计时组件（秒数）
class SimpleCountdownWidget extends StatefulWidget {
  final int seconds;
  final VoidCallback? onEnd;
  final Widget Function(int remaining)? builder;
  
  const SimpleCountdownWidget({
    super.key,
    required this.seconds,
    this.onEnd,
    this.builder,
  });

  @override
  State<SimpleCountdownWidget> createState() => _SimpleCountdownWidgetState();
}

class _SimpleCountdownWidgetState extends State<SimpleCountdownWidget> {
  late Timer _timer;
  late int _remaining;
  
  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _startTimer();
  }
  
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remaining--;
      });
      
      if (_remaining <= 0) {
        timer.cancel();
        widget.onEnd?.call();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(_remaining);
    }
    
    return Text(
      '$_remaining秒',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}