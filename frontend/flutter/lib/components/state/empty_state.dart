import 'package:flutter/material.dart';

/// 空状态组件
///
/// 用于展示列表或搜索结果为空的状态
class EmptyState extends StatelessWidget {
  final String message;
  final String? subMessage;
  final IconData icon;
  final Widget? illustration;
  final Widget? actionButton;
  final double iconSize;
  final double spacing;

  const EmptyState({
    Key? key,
    this.message = '暂无数据',
    this.subMessage,
    this.icon = Icons.inbox_outlined,
    this.illustration,
    this.actionButton,
    this.iconSize = 64.0,
    this.spacing = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: 待填充组件逻辑
    return Container();
  }
} 