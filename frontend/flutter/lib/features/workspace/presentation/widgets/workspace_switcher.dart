import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workspace_provider.dart';
import '../../domain/entities/workspace.dart';

/// 工作台切换器组件
class WorkspaceSwitcher extends ConsumerWidget {
  final bool showAsBottomSheet;
  final VoidCallback? onWorkspaceChanged;

  const WorkspaceSwitcher({
    super.key,
    this.showAsBottomSheet = true,
    this.onWorkspaceChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaceState = ref.watch(workspaceProvider);
    final isSwitching = ref.watch(workspaceSwitchProvider);

    if (workspaceState.isLoading) {
      return const CircularProgressIndicator();
    }

    if (!workspaceState.hasMultipleWorkspaces) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: isSwitching ? null : () => _showWorkspaceSwitcher(context, ref),
      icon: const Icon(Icons.swap_horiz),
      tooltip: '切换工作台',
    );
  }

  void _showWorkspaceSwitcher(BuildContext context, WidgetRef ref) {
    if (showAsBottomSheet) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => WorkspaceSwitcherSheet(
          onWorkspaceChanged: onWorkspaceChanged,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => WorkspaceSwitcherDialog(
          onWorkspaceChanged: onWorkspaceChanged,
        ),
      );
    }
  }
}

/// 工作台切换底部表单
class WorkspaceSwitcherSheet extends ConsumerWidget {
  final VoidCallback? onWorkspaceChanged;

  const WorkspaceSwitcherSheet({
    super.key,
    this.onWorkspaceChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final workspaceState = ref.watch(workspaceProvider);
    final isSwitching = ref.watch(workspaceSwitchProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部指示器
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // 标题
          Text(
            '选择工作台',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '切换到不同的工作台以访问相应功能',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // 工作台列表
          ...workspaceState.availableWorkspaces.map((workspace) =>
            _buildWorkspaceItem(
              context,
              ref,
              workspace,
              workspaceState.currentWorkspace == workspace.type,
              isSwitching,
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildWorkspaceItem(
    BuildContext context,
    WidgetRef ref,
    Workspace workspace,
    bool isCurrentWorkspace,
    bool isSwitching,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isCurrentWorkspace
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: isCurrentWorkspace ? 2 : 0,
        child: InkWell(
          onTap: workspace.isAvailable && !isSwitching && !isCurrentWorkspace
              ? () => _switchWorkspace(context, ref, workspace.type)
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 图标
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: workspace.isAvailable
                        ? (isCurrentWorkspace
                            ? theme.colorScheme.primary
                            : theme.colorScheme.primaryContainer)
                        : theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconData(workspace.iconPath),
                    color: workspace.isAvailable
                        ? (isCurrentWorkspace
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onPrimaryContainer)
                        : theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // 内容
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            workspace.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: workspace.isAvailable
                                  ? (isCurrentWorkspace
                                      ? theme.colorScheme.onPrimaryContainer
                                      : theme.colorScheme.onSurface)
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (isCurrentWorkspace) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '当前',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        workspace.isAvailable
                            ? workspace.description
                            : workspace.unavailableReason ?? '不可用',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: workspace.isAvailable
                              ? (isCurrentWorkspace
                                  ? theme.colorScheme.onPrimaryContainer
                                      .withOpacity(0.8)
                                  : theme.colorScheme.onSurfaceVariant)
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // 状态指示器
                if (isSwitching && !isCurrentWorkspace)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (workspace.isAvailable && !isCurrentWorkspace)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  )
                else if (!workspace.isAvailable)
                  Icon(
                    Icons.lock,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _switchWorkspace(
    BuildContext context,
    WidgetRef ref,
    WorkspaceType workspaceType,
  ) async {
    try {
      await ref.read(workspaceSwitchProvider.notifier).switchTo(workspaceType);
      
      if (context.mounted) {
        Navigator.of(context).pop();
        onWorkspaceChanged?.call();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已切换到${workspaceType.displayName}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('切换失败: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  IconData _getIconData(String iconPath) {
    switch (iconPath) {
      case 'person':
        return Icons.person;
      case 'store':
        return Icons.store;
      case 'local_hospital':
        return Icons.local_hospital;
      default:
        return Icons.dashboard;
    }
  }
}

/// 工作台切换对话框
class WorkspaceSwitcherDialog extends ConsumerWidget {
  final VoidCallback? onWorkspaceChanged;

  const WorkspaceSwitcherDialog({
    super.key,
    this.onWorkspaceChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('选择工作台'),
      content: SizedBox(
        width: double.maxFinite,
        child: WorkspaceSwitcherSheet(
          onWorkspaceChanged: () {
            Navigator.of(context).pop();
            onWorkspaceChanged?.call();
          },
        ),
      ),
    );
  }
}

/// 工作台指示器（显示当前工作台）
class WorkspaceIndicator extends ConsumerWidget {
  final bool showLabel;

  const WorkspaceIndicator({
    super.key,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWorkspaceInfo = ref.watch(currentWorkspaceInfoProvider);
    final theme = Theme.of(context);

    if (currentWorkspaceInfo == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIconData(currentWorkspaceInfo.iconPath),
            size: 16,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          if (showLabel) ...[
            const SizedBox(width: 6),
            Text(
              currentWorkspaceInfo.type.displayName,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getIconData(String iconPath) {
    switch (iconPath) {
      case 'person':
        return Icons.person;
      case 'store':
        return Icons.store;
      case 'local_hospital':
        return Icons.local_hospital;
      default:
        return Icons.dashboard;
    }
  }
}