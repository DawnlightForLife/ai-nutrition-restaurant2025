import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workspace_provider.dart';
import '../../domain/entities/workspace.dart';

/// 工作台切换器组件
class WorkspaceSwitcher extends ConsumerWidget {
  final bool showAsBottomSheet;
  final VoidCallback? onWorkspaceChanged;
  final bool showCompact; // 新增：紧凑模式
  final bool showDropdownStyle; // 新增：下拉菜单样式

  const WorkspaceSwitcher({
    super.key,
    this.showAsBottomSheet = true,
    this.onWorkspaceChanged,
    this.showCompact = false,
    this.showDropdownStyle = false,
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

    if (showDropdownStyle) {
      return _buildDropdownButton(context, ref, workspaceState, isSwitching);
    }
    
    if (showCompact) {
      return _buildCompactButton(context, ref, workspaceState, isSwitching);
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
  
  /// 构建下拉按钮样式
  Widget _buildDropdownButton(BuildContext context, WidgetRef ref, WorkspaceState workspaceState, bool isSwitching) {
    final currentWorkspace = workspaceState.availableWorkspaces.firstWhere(
      (w) => w.type == workspaceState.currentWorkspace,
      orElse: () => const Workspace(
        type: WorkspaceType.user,
        title: '用户工作台',
        description: '浏览菜品、营养咨询、健康管理',
        iconPath: 'person',
      ),
    );
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
      ),
      child: DropdownButton<WorkspaceType>(
        value: workspaceState.currentWorkspace,
        underline: const SizedBox.shrink(),
        borderRadius: BorderRadius.circular(8),
        icon: isSwitching 
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.keyboard_arrow_down),
        selectedItemBuilder: (context) => workspaceState.availableWorkspaces.map((workspace) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIconData(workspace.iconPath),
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  workspace.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        items: workspaceState.availableWorkspaces
            .where((w) => w.isAvailable)
            .map((workspace) => DropdownMenuItem<WorkspaceType>(
                  value: workspace.type,
                  child: Row(
                    children: [
                      Icon(
                        _getIconData(workspace.iconPath),
                        size: 20,
                        color: workspace.type == workspaceState.currentWorkspace
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              workspace.title,
                              style: TextStyle(
                                fontWeight: workspace.type == workspaceState.currentWorkspace
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: workspace.type == workspaceState.currentWorkspace
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                            ),
                            Text(
                              workspace.description,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (workspace.type == workspaceState.currentWorkspace)
                        Icon(
                          Icons.check,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    ],
                  ),
                ))
            .toList(),
        onChanged: isSwitching ? null : (WorkspaceType? newWorkspace) {
          if (newWorkspace != null && newWorkspace != workspaceState.currentWorkspace) {
            _switchWorkspace(context, ref, newWorkspace);
          }
        },
      ),
    );
  }
  
  /// 构建紧凑按钮样式（身份切换）
  Widget _buildCompactButton(BuildContext context, WidgetRef ref, WorkspaceState workspaceState, bool isSwitching) {
    final currentWorkspace = workspaceState.availableWorkspaces.firstWhere(
      (w) => w.type == workspaceState.currentWorkspace,
      orElse: () => const Workspace(
        type: WorkspaceType.user,
        title: '用户',
        description: '浏览菜品、营养咨询、健康管理',
        iconPath: 'person',
      ),
    );
    
    // 简化标题显示
    String displayName;
    switch (currentWorkspace.type) {
      case WorkspaceType.merchant:
        displayName = '商家';
        break;
      case WorkspaceType.nutritionist:
        displayName = '营养师';
        break;
      default:
        displayName = '用户';
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isSwitching ? null : () => _showWorkspaceSwitcher(context, ref),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIconData(currentWorkspace.iconPath),
                  size: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                if (isSwitching)
                  const SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(strokeWidth: 1),
                  )
                else
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 12,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// 切换工作台（用于下拉菜单）
  Future<void> _switchWorkspace(
    BuildContext context,
    WidgetRef ref,
    WorkspaceType workspaceType,
  ) async {
    try {
      await ref.read(workspaceSwitchProvider.notifier).switchTo(workspaceType);
      
      if (context.mounted) {
        onWorkspaceChanged?.call();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text('已切换到${workspaceType.displayName}'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Theme.of(context).colorScheme.onError,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text('切换失败: $error')),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
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
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text('已切换到${workspaceType.displayName}'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Theme.of(context).colorScheme.onError,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text('切换失败: $error')),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
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