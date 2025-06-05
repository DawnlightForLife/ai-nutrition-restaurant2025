import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/enums/user_role.dart';
import '../../../../routes/app_navigator.dart';

/// 用户中心页面占位组件
/// TODO: 替换为完整的 UserProfilePage
class UserProfilePlaceholder extends ConsumerWidget {
  const UserProfilePlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
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
              ],
            ),
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
          
          // 角色入口
          _buildMenuItem(
            context,
            icon: Icons.medical_services_outlined,
            title: '营养师认证',
            subtitle: '成为营养师',
            onTap: () {
              // TODO: Navigate to nutritionist application
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.store_outlined,
            title: '商家入驻',
            subtitle: '申请加盟',
            onTap: () {
              // TODO: Navigate to merchant application
            },
          ),
          
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
                onTap: () => _handleAdminAccess(context, ref),
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
    final theme = Theme.of(context);
    
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
  
  /// 处理管理员访问
  void _handleAdminAccess(BuildContext context, WidgetRef ref) {
    // 跳转到管理员验证页面
    Navigator.of(context).pushNamed('/admin/verify');
  }
}