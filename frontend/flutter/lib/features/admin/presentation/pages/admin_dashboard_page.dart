import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/admin_quick_action.dart';
import '../widgets/admin_menu_item.dart';
import '../providers/merchant_approval_provider.dart';
import '../../providers/dashboard_stats_provider.dart';

/// 后台管理首页
/// 
/// 显示统计数据、快捷操作和功能菜单
class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    // 初始加载数据
    Future.microtask(() {
      ref.read(dashboardStatsProvider.notifier).loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(dashboardStatsProvider);
    
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
          await ref.read(dashboardStatsProvider.notifier).loadStats();
        },
        child: statsAsync.when(
          data: (stats) => SingleChildScrollView(
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
                  children: [
                    AdminStatCard(
                      title: '注册用户总数',
                      value: _formatNumber(stats['totalUsers'] ?? 0),
                      icon: Icons.people,
                      color: Colors.blue,
                      trend: '+${stats['newUsersThisMonth'] ?? 0}',
                    ),
                    AdminStatCard(
                      title: '活跃加盟商',
                      value: stats['activeMerchants']?.toString() ?? '0',
                      icon: Icons.store,
                      color: Colors.orange,
                      trend: '+${stats['newMerchantsThisMonth'] ?? 0}',
                    ),
                    AdminStatCard(
                      title: '认证营养师',
                      value: stats['certifiedNutritionists']?.toString() ?? '0',
                      icon: Icons.medical_services,
                      color: Colors.green,
                      trend: '+${stats['newNutritionistsThisMonth'] ?? 0}',
                    ),
                    AdminStatCard(
                      title: 'AI推荐次数',
                      value: _formatNumber(stats['aiRecommendations'] ?? 0),
                      icon: Icons.psychology,
                      color: Colors.purple,
                      trend: '+${stats['recommendationsThisMonth'] ?? 0}',
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
                        title: '权限管理',
                        icon: Icons.admin_panel_settings,
                        color: Colors.blue,
                        onTap: () => Navigator.of(context).pushNamed('/admin/permission-management'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AdminQuickAction(
                        title: '系统配置',
                        icon: Icons.settings,
                        color: Colors.purple,
                        onTap: () => Navigator.of(context).pushNamed('/admin/system-config'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AdminQuickAction(
                        title: '数据分析',
                        icon: Icons.analytics,
                        color: Colors.green,
                        onTap: () {
                          // TODO: 跳转到数据分析
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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('加载失败: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(dashboardStatsProvider.notifier).loadStats();
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// 构建功能菜单
  Widget _buildMenuSection(BuildContext context) {
    final theme = Theme.of(context);
    
    final menuCategories = [
      {
        'title': '权限管理',
        'items': [
          {
            'icon': Icons.admin_panel_settings,
            'title': '用户授权',
            'subtitle': '管理用户权限，授权加盟商和营养师',
            'color': Colors.blue,
            'onTap': () => Navigator.of(context).pushNamed('/admin/permission-management'),
          },
          {
            'icon': Icons.people,
            'title': '用户管理',
            'subtitle': '查看和管理所有注册用户',
            'color': Colors.indigo,
            'onTap': () {
              // TODO: 跳转到用户管理
            },
          },
        ],
      },
      {
        'title': '业务管理',
        'items': [
          {
            'icon': Icons.store,
            'title': '加盟商管理',
            'subtitle': '加盟商数据统计与业务分析',
            'color': Colors.orange,
            'onTap': () => Navigator.of(context).pushNamed('/admin/merchant-stats'),
          },
          {
            'icon': Icons.medical_services,
            'title': '营养师管理',
            'subtitle': '营养师数据统计与服务分析',
            'color': Colors.green,
            'onTap': () => Navigator.of(context).pushNamed('/admin/nutritionist-stats'),
          },
          {
            'icon': Icons.verified_user,
            'title': '认证审核',
            'subtitle': '营养师认证申请审核管理',
            'color': Colors.deepPurple,
            'onTap': () => Navigator.of(context).pushNamed('/admin/certification-review'),
          },
          {
            'icon': Icons.restaurant,
            'title': '菜品管理',
            'subtitle': '菜品信息管理与营养审核',
            'color': Colors.amber,
            'onTap': () {
              // TODO: 跳转到菜品管理
            },
          },
        ],
      },
      {
        'title': '运营管理',
        'items': [
          {
            'icon': Icons.receipt_long,
            'title': '订单管理',
            'subtitle': '订单查询、统计与异常处理',
            'color': Colors.teal,
            'onTap': () {
              // TODO: 跳转到订单管理
            },
          },
          {
            'icon': Icons.forum,
            'title': '内容管理',
            'subtitle': '论坛内容审核与社区管理',
            'color': Colors.red,
            'onTap': () {
              // TODO: 跳转到内容管理
            },
          },
          {
            'icon': Icons.analytics,
            'title': '数据分析',
            'subtitle': '平台运营数据深度分析',
            'color': Colors.purple,
            'onTap': () {
              // TODO: 跳转到数据分析
            },
          },
        ],
      },
      {
        'title': '系统管理',
        'items': [
          {
            'icon': Icons.admin_panel_settings,
            'title': '管理员管理',
            'subtitle': '管理员账号的增删改查',
            'color': Colors.cyan,
            'onTap': () => Navigator.of(context).pushNamed('/admin/admin-management'),
          },
          {
            'icon': Icons.settings,
            'title': '系统配置',
            'subtitle': '系统参数配置与功能开关',
            'color': Colors.grey,
            'onTap': () => Navigator.of(context).pushNamed('/admin/system-config'),
          },
        ],
      },
    ];
    
    return Column(
      children: menuCategories.map((category) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                category['title'] as String,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: (category['items'] as List).length,
              itemBuilder: (context, index) {
                final item = (category['items'] as List)[index] as Map<String, dynamic>;
                return _buildMenuCard(context, item);
              },
            ),
            const SizedBox(height: 24),
          ],
        );
      }).toList(),
    );
  }
  
  /// 构建菜单卡片
  Widget _buildMenuCard(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);
    final color = item['color'] as Color;
    
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: item['onTap'] as VoidCallback,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  size: 24,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item['title'] as String,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  item['subtitle'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 获取格式化日期
  String _getFormattedDate() {
    final now = DateTime.now();
    return '${now.year}年${now.month}月${now.day}日';
  }
  
  /// 格式化数字
  String _formatNumber(num value) {
    if (value >= 10000) {
      return '${(value / 10000).toStringAsFixed(1)}万';
    }
    return value.toString();
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