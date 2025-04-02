import 'package:flutter/material.dart';

/// 成功消息组件
///
/// 用于展示操作成功后的反馈信息
class SuccessMessage extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Duration duration;
  final VoidCallback? onDismiss;

  const SuccessMessage({
    Key? key,
    required this.message,
    this.icon = Icons.check_circle,
    this.duration = const Duration(seconds: 3),
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: 待填充组件逻辑
    return Container();
  }
}
