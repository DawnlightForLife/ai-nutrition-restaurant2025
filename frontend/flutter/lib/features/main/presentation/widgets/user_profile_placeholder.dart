import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../merchant/presentation/pages/merchant_application_improved_page.dart';
import '../../../merchant/presentation/pages/merchant_application_status_page.dart';
import '../../../merchant/presentation/pages/merchant_application_edit_page.dart';
import '../../../merchant/presentation/providers/merchant_application_provider.dart';
import '../../../system/presentation/providers/system_config_provider.dart';
import '../../../system/domain/entities/system_config.dart';
import '../../../certification/presentation/pages/contact_certification_page.dart';
import '../../../workspace/presentation/providers/workspace_provider.dart';
import '../../../workspace/presentation/widgets/workspace_switcher.dart';
import '../../../workspace/domain/entities/workspace.dart';
import '../../../permission/presentation/providers/user_permission_provider.dart';
import '../../../../routes/app_navigator.dart';

/// 用户中心页面占位组件
/// TODO: 替换为完整的 UserProfilePage
class UserProfilePlaceholder extends ConsumerStatefulWidget {
  const UserProfilePlaceholder({super.key});

  @override
  ConsumerState<UserProfilePlaceholder> createState() => _UserProfilePlaceholderState();
}

class _UserProfilePlaceholderState extends ConsumerState<UserProfilePlaceholder> {
  bool _hasInitialized = false;
  int _refreshKey = 0; // 用于强制重建widget

  @override
  void initState() {
    super.initState();
    // 在下一帧加载商家申请状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMerchantApplications();
    });
  }

  void _loadMerchantApplications() {
    final authState = ref.read(authStateProvider);
    if (authState.user != null && !_hasInitialized) {
      _hasInitialized = true;
      ref.read(merchantApplicationProvider.notifier).loadUserApplications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final merchantAppState = ref.watch(merchantApplicationProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          // 用户信息卡片
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.primaryColor,
                  child: const Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authState.user?.nickname ?? '用户',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authState.user?.phone ?? '',
                        style: theme.textTheme.bodyMedium,
                      ),
                      // 临时调试：显示角色信息
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'DEBUG - Role: ${authState.user?.role ?? 'null'}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 工作台切换器
                Consumer(
                  builder: (context, ref, child) {
                    final hasMultipleWorkspaces = ref.watch(hasMultipleWorkspacesProvider);
                    if (!hasMultipleWorkspaces) {
                      return const SizedBox.shrink();
                    }
                    return const WorkspaceSwitcher();
                  },
                ),
              ],
            ),
          ),
          
          // 工作台指示器
          Consumer(
            builder: (context, ref, child) {
              final hasMultipleWorkspaces = ref.watch(hasMultipleWorkspacesProvider);
              if (!hasMultipleWorkspaces) {
                return const SizedBox.shrink();
              }
              
              return Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.dashboard, size: 16),
                    const SizedBox(width: 8),
                    const Text('当前工作台：'),
                    const SizedBox(width: 8),
                    const WorkspaceIndicator(),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          
          // 功能列表
          _buildMenuItem(
            context,
            icon: Icons.person_outline,
            title: '营养档案管理',
            onTap: () => AppNavigator.toNutritionProfiles(context),
          ),
          _buildMenuItem(
            context,
            icon: Icons.history,
            title: '推荐历史',
            onTap: () {
              // TODO: Navigate to recommendation history
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.location_on_outlined,
            title: '地址管理',
            onTap: () => AppNavigator.toAddresses(context),
          ),
          _buildMenuItem(
            context,
            icon: Icons.notifications_outlined,
            title: '消息中心',
            onTap: () => AppNavigator.toNotifications(context),
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings_outlined,
            title: '设置',
            onTap: () => AppNavigator.toSettings(context),
          ),
          const Divider(height: 32),
          
          // 角色入口 - 根据系统配置显示
          _buildCertificationMenuItems(context, merchantAppState),
          
          // 管理员入口 - 根据角色动态显示
          if (authState.user != null && 
              (authState.user!.role == 'admin' || authState.user!.role == 'super_admin'))
            ...[
              const Divider(height: 32),
              _buildMenuItem(
                context,
                icon: Icons.admin_panel_settings,
                title: '后台管理中心',
                subtitle: '进入管理后台',
                onTap: () => _handleAdminAccess(context),
              ),
            ],
          
          const Divider(height: 32),
          
          // 退出登录
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: '退出登录',
            textColor: Colors.red,
            onTap: () async {
              // TODO: Show confirmation dialog
              ref.read(authStateProvider.notifier).logout();
              ref.read(merchantApplicationProvider.notifier).reset();
              AppNavigator.toLogin(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
  
  /// 构建商家相关菜单项
  Widget _buildMerchantMenuItem(BuildContext context, MerchantApplicationState merchantAppState) {
    // 添加调试信息
    debugPrint('UI更新: 构建商家菜单项');
    debugPrint('UI更新: 错误状态: ${merchantAppState.error}');
    debugPrint('UI更新: 加载状态: ${merchantAppState.isLoading}');
    debugPrint('UI更新: 已加载: ${merchantAppState.hasLoadedApplications}');
    debugPrint('UI更新: 申请数量: ${merchantAppState.userApplications.length}');
    // 如果有错误，显示默认的商家入驻选项
    if (merchantAppState.error != null) {
      debugPrint('商家状态加载错误: ${merchantAppState.error}');
      return _buildMenuItem(
        context,
        icon: Icons.store_outlined,
        title: '商家入驻',
        subtitle: '申请加盟',
        onTap: () => _navigateToMerchantApplication(context),
      );
    }
    
    // 如果正在加载且还没有数据，显示加载状态
    if (merchantAppState.isLoading && !merchantAppState.hasLoadedApplications) {
      return ListTile(
        leading: const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        title: const Text('加载中...'),
        subtitle: const Text('正在获取商家状态'),
      );
    }
    
    // 检查用户是否有商家申请记录
    final hasApplication = merchantAppState.userApplications.isNotEmpty;
    
    if (!hasApplication) {
      // 没有申请记录，显示"商家入驻"
      return _buildMenuItem(
        context,
        icon: Icons.store_outlined,
        title: '商家入驻',
        subtitle: '申请加盟',
        onTap: () => _navigateToMerchantApplication(context),
      );
    } else {
      // 有申请记录，显示最新申请状态
      final latestApplication = merchantAppState.userApplications.first;
      // 从verification字段中获取状态，如果没有则默认为pending
      final status = (latestApplication['verification']?['verificationStatus'] ?? 'pending') as String;
      debugPrint('商家申请状态: $status');
      debugPrint('完整商家数据: $latestApplication');
      
      String title;
      String subtitle;
      IconData icon;
      Color? textColor;
      
      switch (status) {
        case 'pending':
          title = '申请审核中';
          subtitle = '查看申请状态';
          icon = Icons.hourglass_empty;
          textColor = Colors.orange[700];
          break;
        case 'approved':
        case 'verified': // 可能的已验证状态
          title = '我的店铺';
          subtitle = '已通过审核';
          icon = Icons.store;
          textColor = Colors.green[700];
          break;
        case 'rejected':
          title = '商家申请';
          subtitle = '申请已被拒绝，点击修改';
          icon = Icons.edit_note;
          textColor = Colors.red[700];
          break;
        default:
          // 对于未知状态，检查isVerified字段
          final isVerified = (latestApplication['verification']?['isVerified'] as bool?) ?? false;
          if (isVerified) {
            title = '商家管理';
            subtitle = '已通过审核';
            icon = Icons.store;
            textColor = Colors.green[700];
          } else {
            title = '查看申请';
            subtitle = '申请状态：$status';
            icon = Icons.store_outlined;
            textColor = null;
          }
      }
      
      return _buildMenuItem(
        context,
        icon: icon,
        title: title,
        subtitle: subtitle,
        textColor: textColor,
        onTap: () => _navigateToMerchantStatus(context, status),
      );
    }
  }

  /// 导航到商家申请页面
  void _navigateToMerchantApplication(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const MerchantApplicationImprovedPage(),
      ),
    );
  }

  /// 导航到商家状态页面
  void _navigateToMerchantStatus(BuildContext context, String status) {
    final merchantAppState = ref.read(merchantApplicationProvider);
    
    if (status == 'rejected') {
      // 如果被拒绝，导航到编辑页面
      final rejectedApplication = merchantAppState.userApplications.firstWhere(
        (app) => app['verification']?['verificationStatus'] == 'rejected',
        orElse: () => {},
      );
      
      if (rejectedApplication.isNotEmpty) {
        Navigator.of(context).push(
          MaterialPageRoute<bool>(
            builder: (context) => MerchantApplicationEditPage(
              rejectedApplication: rejectedApplication,
            ),
          ),
        ).then((result) {
          if (result == true) {
            // 如果编辑成功，刷新申请列表
            debugPrint('重新提交成功，开始刷新申请状态...');
            
            // 延迟刷新，确保后端已经处理完成
            Future.delayed(const Duration(milliseconds: 1000), () async {
              if (mounted) {
                debugPrint('开始延迟刷新申请状态...');
                await ref.read(merchantApplicationProvider.notifier).refreshUserApplications();
                debugPrint('申请状态刷新完成');
                
                // 强制重建UI以显示最新状态
                if (mounted) {
                  setState(() {
                    _refreshKey++; // 增加刷新key强制重建
                  });
                  debugPrint('UI强制重建完成，刷新key: $_refreshKey');
                }
              }
            });
          }
        });
      } else {
        // 如果找不到拒绝的申请，导航到新申请页面
        _navigateToMerchantApplication(context);
      }
    } else if (status == 'approved' || status == 'verified') {
      // 已验证的商家，可以进入商家管理
      // TODO: 导航到商家管理页面
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('商家管理功能即将上线')),
      );
    } else {
      // 其他状态，查看申请状态
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const MerchantApplicationStatusPage(),
        ),
      );
    }
  }

  /// 导航到营养师认证申请页面
  void _navigateToNutritionistCertification(BuildContext context) {
    AppNavigator.toNutritionistCertification(context);
  }

  /// 处理管理员访问
  void _handleAdminAccess(BuildContext context) {
    // 跳转到管理员验证页面
    Navigator.of(context).pushNamed('/admin/verify');
  }
  
  /// 构建认证相关菜单项（根据系统配置和当前工作台）
  Widget _buildCertificationMenuItems(BuildContext context, MerchantApplicationState merchantAppState) {
    final certConfig = ref.watch(certificationConfigProvider);
    final currentWorkspace = ref.watch(currentWorkspaceProvider);
    final userPermissions = ref.watch(currentUserHasMerchantPermissionProvider);
    final nutritionistPermissions = ref.watch(currentUserHasNutritionistPermissionProvider);
    final widgets = <Widget>[];
    
    // 如果配置还在加载中，显示加载状态
    if (certConfig.isLoading) {
      widgets.add(
        const ListTile(
          leading: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          title: Text('加载认证配置...'),
        ),
      );
      return Column(children: widgets);
    }
    
    // 根据当前工作台显示不同的功能
    switch (currentWorkspace) {
      case WorkspaceType.user:
        // 用户工作台：显示认证申请入口（如果还未获得权限）
        if (certConfig.nutritionistEnabled && !nutritionistPermissions) {
          widgets.add(
            _buildMenuItem(
              context,
              icon: Icons.medical_services_outlined,
              title: '营养师认证',
              subtitle: certConfig.nutritionistMode == CertificationMode.contact 
                  ? '联系客服申请' 
                  : '成为营养师',
              onTap: () => _handleNutritionistCertification(context, certConfig.nutritionistMode),
            ),
          );
        }
        
        if (certConfig.merchantEnabled && !userPermissions) {
          widgets.add(
            Container(
              key: ValueKey('merchant_menu_$_refreshKey'),
              child: _buildMerchantMenuItemWithConfig(context, merchantAppState, certConfig.merchantMode),
            ),
          );
        }
        break;
        
      case WorkspaceType.merchant:
        // 商家工作台：显示商家相关功能
        widgets.addAll([
          _buildMenuItem(
            context,
            icon: Icons.store,
            title: '我的店铺',
            subtitle: '店铺管理',
            onTap: () => _handleMerchantManagement(context),
          ),
          _buildMenuItem(
            context,
            icon: Icons.restaurant_menu,
            title: '菜品管理',
            subtitle: '添加和编辑菜品',
            onTap: () => _handleDishManagement(context),
          ),
          _buildMenuItem(
            context,
            icon: Icons.receipt_long,
            title: '订单管理',
            subtitle: '查看和处理订单',
            onTap: () => _handleOrderManagement(context),
          ),
        ]);
        break;
        
      case WorkspaceType.nutritionist:
        // 营养师工作台：显示营养师相关功能
        widgets.addAll([
          _buildMenuItem(
            context,
            icon: Icons.chat,
            title: '营养咨询',
            subtitle: '在线咨询服务',
            onTap: () => _handleNutritionConsultation(context),
          ),
          _buildMenuItem(
            context,
            icon: Icons.assignment,
            title: '营养方案',
            subtitle: '制定营养计划',
            onTap: () => _handleNutritionPlan(context),
          ),
          _buildMenuItem(
            context,
            icon: Icons.people,
            title: '客户管理',
            subtitle: '管理咨询客户',
            onTap: () => _handleClientManagement(context),
          ),
        ]);
        break;
    }
    
    return Column(children: widgets);
  }
  
  /// 构建商家菜单项（带配置）
  Widget _buildMerchantMenuItemWithConfig(
    BuildContext context, 
    MerchantApplicationState merchantAppState,
    CertificationMode mode,
  ) {
    // 如果是联系客服模式，直接显示联系客服选项
    if (mode == CertificationMode.contact) {
      return _buildMenuItem(
        context,
        icon: Icons.store_outlined,
        title: '商家入驻',
        subtitle: '联系客服申请',
        onTap: () => _handleMerchantCertification(context, mode),
      );
    }
    
    // 自动认证模式，显示原有的逻辑
    return _buildMerchantMenuItem(context, merchantAppState);
  }
  
  /// 处理营养师认证
  void _handleNutritionistCertification(BuildContext context, CertificationMode mode) {
    if (mode == CertificationMode.contact) {
      // 导航到联系客服页面
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => const ContactCertificationPage(
            certificationType: CertificationType.nutritionist,
          ),
        ),
      );
    } else {
      // 导航到自动认证流程
      _navigateToNutritionistCertification(context);
    }
  }
  
  /// 处理商家认证
  void _handleMerchantCertification(BuildContext context, CertificationMode mode) {
    if (mode == CertificationMode.contact) {
      // 导航到联系客服页面
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => const ContactCertificationPage(
            certificationType: CertificationType.merchant,
          ),
        ),
      );
    } else {
      // 导航到自动认证流程
      _navigateToMerchantApplication(context);
    }
  }
  
  // ========== 工作台功能处理方法 ==========
  
  /// 处理商家管理
  void _handleMerchantManagement(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('商家管理功能开发中...')),
    );
  }
  
  /// 处理菜品管理
  void _handleDishManagement(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('菜品管理功能开发中...')),
    );
  }
  
  /// 处理订单管理
  void _handleOrderManagement(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('订单管理功能开发中...')),
    );
  }
  
  /// 处理营养咨询
  void _handleNutritionConsultation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('营养咨询功能开发中...')),
    );
  }
  
  /// 处理营养方案
  void _handleNutritionPlan(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('营养方案功能开发中...')),
    );
  }
  
  /// 处理客户管理
  void _handleClientManagement(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('客户管理功能开发中...')),
    );
  }
}