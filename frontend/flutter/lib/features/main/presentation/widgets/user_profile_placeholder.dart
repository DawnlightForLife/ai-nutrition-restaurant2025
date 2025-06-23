import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../merchant/presentation/pages/merchant_application_improved_page.dart';
import '../../../merchant/presentation/pages/merchant_application_status_page.dart';
import '../../../merchant/presentation/pages/merchant_application_edit_page.dart';
import '../../../merchant/presentation/pages/dashboard_page.dart';
import '../../../merchant/presentation/pages/merchant_inventory_dashboard_page.dart';
import '../../../merchant/presentation/providers/merchant_application_provider.dart';
import '../../../order/presentation/pages/order_list_page.dart';
import '../../../system/presentation/providers/system_config_provider.dart';
import '../../../system/domain/entities/system_config.dart';
import '../../../certification/presentation/pages/contact_certification_page.dart';
import '../../../workspace/presentation/providers/workspace_provider.dart';
import '../../../workspace/presentation/widgets/workspace_switcher.dart';
import '../../../workspace/domain/entities/workspace.dart';
import '../../../permission/presentation/providers/user_permission_provider.dart';
import '../../../../routes/app_navigator.dart';
import '../../../../theme/app_colors.dart';
import '../../../../config/app_constants.dart';

/// 菜单项数据类
class _MenuItemData {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? textColor;

  const _MenuItemData({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.textColor,
  });
}

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
    // 暂时注释掉商家申请状态加载
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _loadMerchantApplications();
    // });
  }

  void _loadMerchantApplications() {
    // 暂时禁用商家申请功能
    return;
    // final authState = ref.read(authStateProvider);
    // if (authState.user != null && !_hasInitialized) {
    //   _hasInitialized = true;
    //   ref.read(merchantApplicationProvider.notifier).loadUserApplications();
    // }
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
          _buildUserProfileCard(context, authState, theme),
          
          
          // 核心功能分组
          _buildFunctionSection(context, '我的健康', [
            _MenuItemData(
              icon: Icons.person_outline,
              title: '营养档案管理',
              subtitle: '管理个人营养档案',
              onTap: () => AppNavigator.toNutritionProfiles(context),
            ),
            _MenuItemData(
              icon: Icons.history,
              title: '推荐历史',
              subtitle: '查看AI推荐记录',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('推荐历史功能开发中...')),
                );
              },
            ),
          ]),
          
          // 生活服务分组
          _buildFunctionSection(context, '生活服务', [
            _MenuItemData(
              icon: Icons.location_on_outlined,
              title: '地址管理',
              subtitle: '管理收货地址',
              onTap: () => AppNavigator.toAddresses(context),
            ),
            _MenuItemData(
              icon: Icons.notifications_outlined,
              title: '消息中心',
              subtitle: '查看通知消息',
              onTap: () => AppNavigator.toNotifications(context),
            ),
          ]),
          
          // 应用设置分组
          _buildFunctionSection(context, '应用设置', [
            _MenuItemData(
              icon: Icons.settings_outlined,
              title: '设置',
              subtitle: '应用偏好设置',
              onTap: () => AppNavigator.toSettings(context),
            ),
          ]),
          
          // 角色与权限相关功能
          _buildRoleBasedSections(context, merchantAppState, authState),
        ],
      ),
    );
  }

  /// 构建用户资料卡片
  Widget _buildUserProfileCard(BuildContext context, dynamic authState, ThemeData theme) {
    final user = authState.user;
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // 白色背景层
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          // 内容层
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => AppNavigator.toProfileEdit(context),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // 头像
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.9),
                                  Colors.white.withValues(alpha: 0.7),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.transparent,
                              backgroundImage: _getAvatarImage(user),
                              child: _getAvatarImage(user) == null
                                  ? Icon(
                                      Icons.person,
                                      size: 32,
                                      color: Colors.orange[700],
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      
                      // 用户信息
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 昵称
                            Text(
                              (user?.nickname as String?) ?? '点击设置昵称',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            
                            // 手机号
                            Text(
                              _maskPhoneNumber((user?.phone as String?) ?? ''),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // 提示文本
                            Row(
                              children: [
                                Icon(
                                  Icons.touch_app,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    '点击编辑个人信息',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // 身份切换按钮（紧凑型）
                      Consumer(
                        builder: (context, ref, child) {
                          final hasMultipleWorkspaces = ref.watch(hasMultipleWorkspacesProvider);
                          if (!hasMultipleWorkspaces) {
                            return const SizedBox.shrink();
                          }
                          return Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: const WorkspaceSwitcher(
                              showCompact: true,
                              showAsBottomSheet: true,
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // 箭头指示器
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[600],
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 掩码显示手机号
  String _maskPhoneNumber(String phone) {
    if (phone.length >= 11) {
      return '${phone.substring(0, 3)}****${phone.substring(7)}';
    }
    return phone;
  }

  /// 构建功能分组
  Widget _buildFunctionSection(BuildContext context, String title, List<_MenuItemData> items) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryOrange,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              
              return Column(
                children: [
                  _buildMenuItem(
                    context,
                    icon: item.icon,
                    title: item.title,
                    subtitle: item.subtitle,
                    textColor: item.textColor,
                    onTap: item.onTap,
                  ),
                  if (index < items.length - 1)
                    const Divider(height: 1, indent: 56),
                ],
              );
            }).toList(),
          ),
        ),
      ],
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

  /// 构建基于角色的功能分组
  Widget _buildRoleBasedSections(BuildContext context, MerchantApplicationState merchantAppState, dynamic authState) {
    final widgets = <Widget>[];
    
    // 专业服务分组（营养师/商家认证）
    final certificationItems = _buildCertificationItems(context, merchantAppState);
    if (certificationItems.isNotEmpty) {
      widgets.add(_buildFunctionSection(context, '专业服务', certificationItems));
    }
    
    // 工作台功能分组
    final workspaceItems = _buildWorkspaceItems(context);
    if (workspaceItems.isNotEmpty) {
      widgets.add(_buildFunctionSection(context, '工作台', workspaceItems));
    }
    
    // 管理功能分组（仅管理员可见）
    if (authState.user != null && 
        (authState.user!.role == 'admin' || authState.user!.role == 'super_admin')) {
      widgets.add(_buildFunctionSection(context, '系统管理', [
        _MenuItemData(
          icon: Icons.admin_panel_settings,
          title: '后台管理中心',
          subtitle: '进入管理后台',
          onTap: () => _handleAdminAccess(context),
        ),
      ]));
    }
    
    // 退出登录已移到账号与安全页面，这里不再重复显示
    
    return Column(children: widgets);
  }

  /// 构建认证相关菜单项
  List<_MenuItemData> _buildCertificationItems(BuildContext context, MerchantApplicationState merchantAppState) {
    final certConfig = ref.watch(certificationConfigProvider);
    final currentWorkspace = ref.watch(currentWorkspaceProvider);
    final userPermissions = ref.watch(currentUserHasMerchantPermissionProvider);
    final nutritionistPermissions = ref.watch(currentUserHasNutritionistPermissionProvider);
    final items = <_MenuItemData>[];
    
    // 权限状态检查完成
    
    // 如果配置还在加载中，返回空列表
    if (certConfig.isLoading) {
      return items;
    }
    
    // 工作台入口（有权限的用户永久显示）
    if (userPermissions) {
      items.add(_MenuItemData(
        icon: Icons.store,
        title: '商家管理系统',
        subtitle: '店铺管理、菜品管理、订单管理',
        onTap: () => _handleMerchantWorkspace(context),
      ));
    }
    
    if (nutritionistPermissions) {
      items.add(_MenuItemData(
        icon: Icons.medical_services,
        title: '营养师工作台',
        subtitle: '营养咨询、方案定制、客户管理',
        onTap: () => _handleNutritionistWorkspace(context),
      ));
    }
    
    // 认证入口（只在用户工作台且无权限时显示）
    if (currentWorkspace == WorkspaceType.user) {
      // 营养师认证（仅当没有权限且系统配置启用时显示）
      if (certConfig.nutritionistEnabled && !nutritionistPermissions) {
        items.add(_MenuItemData(
          icon: Icons.medical_services_outlined,
          title: '营养师认证',
          subtitle: certConfig.nutritionistMode == CertificationMode.contact 
              ? '联系客服申请' 
              : '成为营养师',
          onTap: () => _handleNutritionistCertification(context, certConfig.nutritionistMode),
        ));
      }
      
      // 商家认证（仅当没有权限且系统配置启用时显示）
      if (certConfig.merchantEnabled && !userPermissions) {
        final merchantStatus = _getMerchantStatusInfo(merchantAppState, certConfig.merchantMode);
        if (merchantStatus != null) {
          items.add(merchantStatus);
        }
      }
    }
    
    return items;
  }

  /// 构建工作台相关菜单项
  List<_MenuItemData> _buildWorkspaceItems(BuildContext context) {
    final currentWorkspace = ref.watch(currentWorkspaceProvider);
    final items = <_MenuItemData>[];
    
    switch (currentWorkspace) {
      case WorkspaceType.merchant:
        items.addAll([
          _MenuItemData(
            icon: Icons.store,
            title: '我的店铺',
            subtitle: '店铺管理',
            onTap: () => _handleMerchantManagement(context),
          ),
          _MenuItemData(
            icon: Icons.restaurant_menu,
            title: '菜品管理',
            subtitle: '添加和编辑菜品',
            onTap: () => _handleDishManagement(context),
          ),
          _MenuItemData(
            icon: Icons.receipt_long,
            title: '订单管理',
            subtitle: '查看和处理订单',
            onTap: () => _handleOrderManagement(context),
          ),
        ]);
        break;
        
      case WorkspaceType.nutritionist:
        items.addAll([
          _MenuItemData(
            icon: Icons.chat,
            title: '营养咨询',
            subtitle: '在线咨询服务',
            onTap: () => _handleNutritionConsultation(context),
          ),
          _MenuItemData(
            icon: Icons.assignment,
            title: '营养方案',
            subtitle: '制定营养计划',
            onTap: () => _handleNutritionPlan(context),
          ),
          _MenuItemData(
            icon: Icons.people,
            title: '客户管理',
            subtitle: '管理咨询客户',
            onTap: () => _handleClientManagement(context),
          ),
        ]);
        break;
        
      default:
        break;
    }
    
    return items;
  }

  /// 获取商家状态信息
  _MenuItemData? _getMerchantStatusInfo(MerchantApplicationState merchantAppState, CertificationMode mode) {
    // 如果是联系客服模式，直接显示联系客服选项
    if (mode == CertificationMode.contact) {
      return _MenuItemData(
        icon: Icons.store_outlined,
        title: '商家入驻',
        subtitle: '联系客服申请',
        onTap: () => _handleMerchantCertification(context, mode),
      );
    }
    
    // 如果有错误，显示默认的商家入驻选项
    if (merchantAppState.error != null) {
      return _MenuItemData(
        icon: Icons.store_outlined,
        title: '商家入驻',
        subtitle: '申请加盟',
        onTap: () => _navigateToMerchantApplication(context),
      );
    }
    
    // 如果正在加载且还没有数据，不显示
    if (merchantAppState.isLoading && !merchantAppState.hasLoadedApplications) {
      return null;
    }
    
    // 检查用户是否有商家申请记录
    final hasApplication = merchantAppState.userApplications.isNotEmpty;
    
    if (!hasApplication) {
      // 没有申请记录，显示"商家入驻"
      return _MenuItemData(
        icon: Icons.store_outlined,
        title: '商家入驻',
        subtitle: '申请加盟',
        onTap: () => _navigateToMerchantApplication(context),
      );
    } else {
      // 有申请记录，显示最新申请状态
      final latestApplication = merchantAppState.userApplications.first;
      final status = (latestApplication['verification']?['verificationStatus'] ?? 'pending') as String;
      
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
        case 'verified':
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
      
      return _MenuItemData(
        icon: icon,
        title: title,
        subtitle: subtitle,
        textColor: textColor,
        onTap: () => _navigateToMerchantStatus(context, status),
      );
    }
  }

  /// 显示退出登录确认对话框
  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authStateProvider.notifier).logout();
              ref.read(merchantApplicationProvider.notifier).reset();
              AppNavigator.toLogin(context);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MerchantDashboardPage(),
      ),
    );
  }
  
  /// 处理菜品管理
  void _handleDishManagement(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MerchantInventoryDashboardPage(merchantId: 'current_merchant'),
      ),
    );
  }
  
  /// 处理订单管理
  void _handleOrderManagement(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UorderListPage(),
      ),
    );
  }
  
  /// 处理营养咨询
  void _handleNutritionConsultation(BuildContext context) {
    Navigator.of(context).pushNamed('/consultations');
  }
  
  /// 处理营养方案
  void _handleNutritionPlan(BuildContext context) {
    Navigator.of(context).pushNamed('/nutrition-plans');
  }
  
  /// 处理客户管理
  void _handleClientManagement(BuildContext context) {
    Navigator.of(context).pushNamed('/clients');
  }
  
  /// 处理商家工作台切换
  void _handleMerchantWorkspace(BuildContext context) {
    // 切换到商家工作台
    ref.read(workspaceProvider.notifier).switchWorkspace(WorkspaceType.merchant);
    
    // 显示提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已切换到商家工作台'),
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  /// 处理营养师工作台切换
  void _handleNutritionistWorkspace(BuildContext context) {
    // 切换到营养师工作台
    ref.read(workspaceProvider.notifier).switchWorkspace(WorkspaceType.nutritionist);
    
    // 导航到营养师主页面
    Navigator.of(context).pushNamed('/nutritionist/main');
    
    // 显示提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已进入营养师工作台'),
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  /// 获取头像图片
  ImageProvider? _getAvatarImage(dynamic user) {
    if (user == null) return null;
    
    // 优先使用displayAvatarUrl获取头像URL
    String? avatarUrl;
    if (user.runtimeType.toString().contains('UserModel')) {
      // 如果是UserModel类型，使用displayAvatarUrl
      avatarUrl = (user as dynamic).displayAvatarUrl as String?;
    } else {
      // 其他情况，尝试获取avatarUrl或avatar
      final userData = user as dynamic;
      avatarUrl = (userData.avatarUrl as String?) ?? (userData.avatar as String?);
    }
    
    if (avatarUrl == null || avatarUrl.isEmpty) return null;
    
    // 如果是相对路径，添加服务器基础URL
    if (avatarUrl.startsWith('/')) {
      avatarUrl = '${AppConstants.serverBaseUrl}$avatarUrl';
    }
    
    return NetworkImage(avatarUrl);
  }
}