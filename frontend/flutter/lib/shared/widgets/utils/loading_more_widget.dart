import 'package:flutter/material.dart';

/// 加载更多组件
class LoadingMoreWidget extends StatelessWidget {
  final LoadingMoreStatus status;
  final VoidCallback? onRetry;
  final String? noMoreText;
  final String? errorText;
  final String? loadingText;
  
  const LoadingMoreWidget({
    super.key,
    required this.status,
    this.onRetry,
    this.noMoreText,
    this.errorText,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: _buildContent(theme),
      ),
    );
  }
  
  Widget _buildContent(ThemeData theme) {
    switch (status) {
      case LoadingMoreStatus.idle:
        return const SizedBox.shrink();
        
      case LoadingMoreStatus.loading:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              loadingText ?? '加载中...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ),
          ],
        );
        
      case LoadingMoreStatus.noMore:
        return Text(
          noMoreText ?? '没有更多了',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.4),
          ),
        );
        
      case LoadingMoreStatus.error:
        return GestureDetector(
          onTap: onRetry,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 20,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                errorText ?? '加载失败，点击重试',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
        );
    }
  }
}

/// 加载更多状态
enum LoadingMoreStatus {
  /// 空闲状态
  idle,
  /// 加载中
  loading,
  /// 没有更多数据
  noMore,
  /// 加载错误
  error,
}

/// 自动加载更多的包装组件
class AutoLoadMoreWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onLoadMore;
  final LoadingMoreStatus status;
  final double triggerDistance;
  
  const AutoLoadMoreWrapper({
    super.key,
    required this.child,
    required this.onLoadMore,
    required this.status,
    this.triggerDistance = 100,
  });

  @override
  State<AutoLoadMoreWrapper> createState() => _AutoLoadMoreWrapperState();
}

class _AutoLoadMoreWrapperState extends State<AutoLoadMoreWrapper> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < widget.triggerDistance &&
            widget.status == LoadingMoreStatus.idle) {
          widget.onLoadMore();
        }
        return false;
      },
      child: widget.child,
    );
  }
}