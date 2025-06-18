import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workspace_provider.dart';
import '../../domain/entities/workspace.dart';

/// 工作台手势检测器
/// 提供右划切换工作台的手势交互
class WorkspaceGestureDetector extends ConsumerStatefulWidget {
  final Widget child;
  final bool enableGestures;
  
  const WorkspaceGestureDetector({
    super.key,
    required this.child,
    this.enableGestures = true,
  });

  @override
  ConsumerState<WorkspaceGestureDetector> createState() => _WorkspaceGestureDetectorState();
}

class _WorkspaceGestureDetectorState extends ConsumerState<WorkspaceGestureDetector>
    with TickerProviderStateMixin {
  
  late AnimationController _slideController;
  late AnimationController _overlayController;
  late Animation<double> _slideAnimation;
  late Animation<double> _overlayAnimation;
  
  bool _isGestureActive = false;
  bool _showWorkspaceSelector = false;
  
  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));
    
    _overlayAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableGestures) {
      return widget.child;
    }

    final workspaceState = ref.watch(workspaceProvider);
    final availableWorkspaces = workspaceState.availableWorkspaces
        .where((w) => w.isAvailable)
        .toList();
    
    // 如果只有用户工作台，不启用手势
    if (availableWorkspaces.length <= 1) {
      return widget.child;
    }

    return Stack(
      children: [
        // 主内容区域
        GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  _slideAnimation.value * 80, // 最大偏移80像素
                  0,
                ),
                child: widget.child,
              );
            },
          ),
        ),
        
        // 工作台指示器（在右侧边缘）
        if (availableWorkspaces.length > 1)
          _buildWorkspaceIndicator(context, availableWorkspaces),
        
        // 工作台选择器覆盖层
        if (_showWorkspaceSelector)
          _buildWorkspaceSelector(context, availableWorkspaces),
      ],
    );
  }

  void _onPanStart(DragStartDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final startX = details.globalPosition.dx;
    
    // 只在屏幕右侧30%区域内开始的手势才有效
    if (startX > screenWidth * 0.7) {
      _isGestureActive = true;
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isGestureActive) return;
    
    final screenWidth = MediaQuery.of(context).size.width;
    final deltaX = details.delta.dx;
    
    // 右划手势
    if (deltaX > 0) {
      final progress = (details.globalPosition.dx / screenWidth).clamp(0.0, 1.0);
      _slideController.value = progress;
      
      // 当滑动超过一定距离时，显示工作台选择器
      if (progress > 0.3 && !_showWorkspaceSelector) {
        setState(() {
          _showWorkspaceSelector = true;
        });
        _overlayController.forward();
      }
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isGestureActive) return;
    
    _isGestureActive = false;
    
    final velocity = details.velocity.pixelsPerSecond.dx;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // 根据速度和位置决定是否触发切换
    if (_slideController.value > 0.5 || velocity > 500) {
      _triggerWorkspaceSwitch();
    } else {
      _resetGesture();
    }
  }

  void _triggerWorkspaceSwitch() {
    final workspaceState = ref.read(workspaceProvider);
    final availableWorkspaces = workspaceState.availableWorkspaces
        .where((w) => w.isAvailable)
        .toList();
    
    if (availableWorkspaces.length == 2) {
      // 只有两个工作台，直接切换到另一个
      final currentWorkspace = workspaceState.currentWorkspace;
      final nextWorkspace = availableWorkspaces
          .firstWhere((w) => w.type != currentWorkspace);
      
      _switchToWorkspace(nextWorkspace.type);
    } else if (availableWorkspaces.length > 2) {
      // 多个工作台，保持选择器显示
      _slideController.forward();
    }
  }

  void _resetGesture() {
    _slideController.reverse();
    if (_showWorkspaceSelector) {
      _overlayController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showWorkspaceSelector = false;
          });
        }
      });
    }
  }

  Future<void> _switchToWorkspace(WorkspaceType workspaceType) async {
    try {
      await ref.read(workspaceSwitchProvider.notifier).switchTo(workspaceType);
      
      // 显示成功提示
      if (mounted) {
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
      
      _resetGesture();
    } catch (error) {
      if (mounted) {
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
      _resetGesture();
    }
  }

  Widget _buildWorkspaceIndicator(BuildContext context, List<Workspace> workspaces) {
    final theme = Theme.of(context);
    
    return Positioned(
      right: 0,
      top: MediaQuery.of(context).size.height * 0.3,
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              (1 - _slideAnimation.value) * 30, // 从右侧滑入
              0,
            ),
            child: Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkspaceSelector(BuildContext context, List<Workspace> workspaces) {
    final theme = Theme.of(context);
    final workspaceState = ref.watch(workspaceProvider);
    
    return AnimatedBuilder(
      animation: _overlayAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5 * _overlayAnimation.value),
            child: Align(
              alignment: Alignment.centerRight,
              child: Transform.translate(
                offset: Offset(
                  (1 - _overlayAnimation.value) * 300,
                  0,
                ),
                child: Container(
                  width: 280,
                  margin: const EdgeInsets.symmetric(vertical: 100),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(-5, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 标题
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          '选择工作台',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      
                      // 工作台列表
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: workspaces.map((workspace) =>
                            _buildWorkspaceOption(
                              context,
                              workspace,
                              workspaceState.currentWorkspace == workspace.type,
                            ),
                          ).toList(),
                        ),
                      ),
                      
                      // 关闭按钮
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextButton(
                          onPressed: _resetGesture,
                          child: const Text('取消'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWorkspaceOption(
    BuildContext context,
    Workspace workspace,
    bool isCurrentWorkspace,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isCurrentWorkspace
            ? theme.colorScheme.primaryContainer
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: isCurrentWorkspace 
              ? _resetGesture 
              : () => _switchToWorkspace(workspace.type),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 图标
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCurrentWorkspace
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getIconData(workspace.iconPath),
                    color: isCurrentWorkspace
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onPrimaryContainer,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // 标题和描述
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workspace.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isCurrentWorkspace
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        workspace.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isCurrentWorkspace
                              ? theme.colorScheme.onPrimaryContainer.withOpacity(0.8)
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 当前工作台指示器
                if (isCurrentWorkspace)
                  Icon(
                    Icons.check_circle,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
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