import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/admin_quick_action.dart';
import '../widgets/admin_menu_item.dart';

/// 后台管理首页
/// 
/// 显示统计数据、快捷操作和功能菜单
class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('管理中心'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: 跳转到管理通知页面
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: 刷新数据
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 欢迎信息
              Text(
                '欢迎回来，管理员',
                style: theme.textTheme.headlineSmall,
              ),
              Text(
                '今日是${_getFormattedDate()}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 24),
              
              // 统计数据卡片
              Text(
                '数据概览',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: const [
                  AdminStatCard(
                    title: '今日新增用户',
                    value: '128',
                    icon: Icons.person_add,
                    color: Colors.blue,
                    trend: '+12%',
                  ),
                  AdminStatCard(
                    title: '待审核商户',
                    value: '5',
                    icon: Icons.store,
                    color: Colors.orange,
                    isUrgent: true,
                  ),
                  AdminStatCard(
                    title: '今日订单',
                    value: '1,234',
                    icon: Icons.shopping_cart,
                    color: Colors.green,
                    trend: '+8%',
                  ),
                  AdminStatCard(
                    title: 'AI推荐次数',
                    value: '3,456',
                    icon: Icons.psychology,
                    color: Colors.purple,
                    trend: '+15%',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // 快捷操作
              Text(
                '快捷操作',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AdminQuickAction(
                      title: '商户审核',
                      icon: Icons.verified_user,
                      color: Colors.orange,
                      badge: '5',
                      onTap: () => Navigator.of(context).pushNamed('/admin/merchant-approval'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AdminQuickAction(
                      title: '内容审核',
                      icon: Icons.content_paste_search,
                      color: Colors.red,
                      badge: '3',
                      onTap: () {
                        // TODO: 跳转到内容审核
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AdminQuickAction(
                      title: '数据导出',
                      icon: Icons.download,
                      color: Colors.blue,
                      onTap: () {
                        // TODO: 跳转到数据导出
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // 功能菜单
              Text(
                '功能菜单',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildMenuSection(context),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 构建功能菜单
  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        AdminMenuItem(
          icon: Icons.people,
          title: '用户管理',
          subtitle: '查看和管理所有用户',
          onTap: () {
            // TODO: 跳转到用户管理
          },
        ),
        AdminMenuItem(
          icon: Icons.store,
          title: '商户管理',
          subtitle: '商户审核、信息管理',
          onTap: () => Navigator.of(context).pushNamed('/admin/merchant-approval'),
        ),
        AdminMenuItem(
          icon: Icons.medical_services,
          title: '营养师管理',
          subtitle: '营养师认证审核',
          onTap: () {
            // TODO: 跳转到营养师管理
          },
        ),
        AdminMenuItem(
          icon: Icons.restaurant,
          title: '菜品管理',
          subtitle: '菜品审核、营养信息',
          onTap: () {
            // TODO: 跳转到菜品管理
          },
        ),
        AdminMenuItem(
          icon: Icons.receipt_long,
          title: '订单管理',
          subtitle: '订单查询、异常处理',
          onTap: () {
            // TODO: 跳转到订单管理
          },
        ),
        AdminMenuItem(
          icon: Icons.forum,
          title: '内容管理',
          subtitle: '论坛内容审核',
          onTap: () {
            // TODO: 跳转到内容管理
          },
        ),
        AdminMenuItem(
          icon: Icons.analytics,
          title: '数据分析',
          subtitle: '运营数据统计分析',
          onTap: () {
            // TODO: 跳转到数据分析
          },
        ),
        AdminMenuItem(
          icon: Icons.admin_panel_settings,
          title: '管理员管理',
          subtitle: '管理员账号的增删改查',
          onTap: () => Navigator.of(context).pushNamed('/admin/admin-management'),
        ),
        AdminMenuItem(
          icon: Icons.settings,
          title: '系统设置',
          subtitle: '权限、日志、配置',
          onTap: () {
            // TODO: 跳转到系统设置
          },
        ),
      ],
    );
  }
  
  /// 获取格式化日期
  String _getFormattedDate() {
    final now = DateTime.now();
    return '${now.year}年${now.month}月${now.day}日';
  }
  
  /// 处理退出登录
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出管理后台'),
        content: const Text('确定要退出管理后台吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/main',
                (route) => false,
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}