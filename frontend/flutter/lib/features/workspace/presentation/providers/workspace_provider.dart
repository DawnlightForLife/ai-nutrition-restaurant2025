import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../permission/presentation/providers/user_permission_provider.dart';
import '../../domain/entities/workspace.dart';

const String _workspaceKey = 'current_workspace';

/// 工作台状态管理
class WorkspaceNotifier extends StateNotifier<WorkspaceState> {
  final Ref _ref;
  
  WorkspaceNotifier(this._ref) : super(
    const WorkspaceState(
      currentWorkspace: WorkspaceType.user,
      availableWorkspaces: [],
      isLoading: true,
    ),
  ) {
    _initializeWorkspaces();
  }

  /// 初始化工作台
  Future<void> _initializeWorkspaces() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // 获取用户权限
      final hasMerchant = await _ref.read(hasMerchantPermissionProvider.future);
      final hasNutritionist = await _ref.read(hasNutritionistPermissionProvider.future);
      
      // 构建可用工作台列表
      final availableWorkspaces = <Workspace>[
        // 用户工作台（始终可用）
        const Workspace(
          type: WorkspaceType.user,
          title: '用户工作台',
          description: '浏览菜品、营养咨询、健康管理',
          iconPath: 'person',
        ),
        
        // 商家工作台
        Workspace(
          type: WorkspaceType.merchant,
          title: '商家工作台',
          description: '店铺管理、菜品发布、订单处理',
          iconPath: 'store',
          isAvailable: hasMerchant,
          unavailableReason: hasMerchant ? null : '需要商家权限认证',
        ),
        
        // 营养师工作台
        Workspace(
          type: WorkspaceType.nutritionist,
          title: '营养师工作台',
          description: '营养咨询、方案制定、客户管理',
          iconPath: 'local_hospital',
          isAvailable: hasNutritionist,
          unavailableReason: hasNutritionist ? null : '需要营养师权限认证',
        ),
      ];
      
      // 获取保存的工作台设置
      final savedWorkspace = await _getSavedWorkspace();
      WorkspaceType currentWorkspace = WorkspaceType.user;
      
      // 验证保存的工作台是否可用
      if (savedWorkspace != null) {
        final workspace = availableWorkspaces.firstWhere(
          (w) => w.type == savedWorkspace,
          orElse: () => availableWorkspaces.first,
        );
        
        if (workspace.isAvailable) {
          currentWorkspace = savedWorkspace;
        }
      }
      
      state = state.copyWith(
        currentWorkspace: currentWorkspace,
        availableWorkspaces: availableWorkspaces,
        isLoading: false,
        error: null,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
    }
  }

  /// 切换工作台
  Future<void> switchWorkspace(WorkspaceType workspaceType) async {
    final workspace = state.availableWorkspaces.firstWhere(
      (w) => w.type == workspaceType,
      orElse: () => throw Exception('工作台不存在'),
    );
    
    if (!workspace.isAvailable) {
      throw Exception(workspace.unavailableReason ?? '工作台不可用');
    }
    
    state = state.copyWith(currentWorkspace: workspaceType);
    await _saveWorkspace(workspaceType);
  }

  /// 刷新工作台权限
  Future<void> refreshWorkspaces() async {
    await _initializeWorkspaces();
  }

  /// 获取保存的工作台设置
  Future<WorkspaceType?> _getSavedWorkspace() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final workspaceName = prefs.getString(_workspaceKey);
      
      if (workspaceName != null) {
        return WorkspaceType.values.firstWhere(
          (type) => type.name == workspaceName,
          orElse: () => WorkspaceType.user,
        );
      }
    } catch (e) {
      // 忽略错误，使用默认值
    }
    return null;
  }

  /// 保存工作台设置
  Future<void> _saveWorkspace(WorkspaceType workspaceType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_workspaceKey, workspaceType.name);
    } catch (e) {
      // 忽略保存错误
    }
  }
}

/// 工作台状态Provider
final workspaceProvider = StateNotifierProvider<WorkspaceNotifier, WorkspaceState>((ref) {
  return WorkspaceNotifier(ref);
});

/// 当前工作台类型
final currentWorkspaceProvider = Provider<WorkspaceType>((ref) {
  return ref.watch(workspaceProvider).currentWorkspace;
});

/// 是否有多个可用工作台
final hasMultipleWorkspacesProvider = Provider<bool>((ref) {
  return ref.watch(workspaceProvider).hasMultipleWorkspaces;
});

/// 可用工作台列表
final availableWorkspacesProvider = Provider<List<Workspace>>((ref) {
  return ref.watch(workspaceProvider).availableWorkspaces;
});

/// 当前工作台信息
final currentWorkspaceInfoProvider = Provider<Workspace?>((ref) {
  final state = ref.watch(workspaceProvider);
  return state.availableWorkspaces.firstWhere(
    (w) => w.type == state.currentWorkspace,
    orElse: () => const Workspace(
      type: WorkspaceType.user,
      title: '用户工作台',
      description: '浏览菜品、营养咨询、健康管理',
      iconPath: 'person',
    ),
  );
});

/// 是否在商家工作台
final isInMerchantWorkspaceProvider = Provider<bool>((ref) {
  return ref.watch(currentWorkspaceProvider) == WorkspaceType.merchant;
});

/// 是否在营养师工作台
final isInNutritionistWorkspaceProvider = Provider<bool>((ref) {
  return ref.watch(currentWorkspaceProvider) == WorkspaceType.nutritionist;
});

/// 工作台切换状态管理器
class WorkspaceSwitchNotifier extends StateNotifier<bool> {
  final Ref _ref;
  
  WorkspaceSwitchNotifier(this._ref) : super(false);
  
  /// 切换到指定工作台
  Future<void> switchTo(WorkspaceType workspaceType) async {
    if (state) return; // 防止重复切换
    
    state = true;
    try {
      await _ref.read(workspaceProvider.notifier).switchWorkspace(workspaceType);
    } finally {
      state = false;
    }
  }
}

/// 工作台切换状态Provider
final workspaceSwitchProvider = StateNotifierProvider<WorkspaceSwitchNotifier, bool>((ref) {
  return WorkspaceSwitchNotifier(ref);
});