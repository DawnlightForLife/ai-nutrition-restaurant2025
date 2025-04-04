import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/core/auth_provider.dart';
import '../../../widgets/common/loading_indicator.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;

  // 功能入口项配置
  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': '营养档案',
      'subtitle': '管理您的健康档案',
      'icon': Icons.health_and_safety,
      'route': '/health-profiles',
      'color': Colors.green,
    },
    {
      'title': '订单历史',
      'subtitle': '查看您的订单记录',
      'icon': Icons.receipt_long,
      'route': '/orders',
      'color': Colors.blue,
    },
    {
      'title': '收藏菜品',
      'subtitle': '您收藏的美食',
      'icon': Icons.favorite,
      'route': '/favorites',
      'color': Colors.red,
    },
    {
      'title': '我的评价',
      'subtitle': '查看您的评价记录',
      'icon': Icons.rate_review,
      'route': '/reviews',
      'color': Colors.orange,
    },
    {
      'title': '营养报告',
      'subtitle': '查看您的营养分析',
      'icon': Icons.analytics,
      'route': '/nutrition-reports',
      'color': Colors.purple,
    },
    {
      'title': '消息通知',
      'subtitle': '系统消息和活动提醒',
      'icon': Icons.notifications,
      'route': '/notifications',
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('个人中心')),
        body: const Center(child: Text('请先登录')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 顶部个人信息区域
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.green.shade400,
                      Colors.green.shade50,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // 头像
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          ((authProvider.nickname?.isEmpty ?? true) ? 'U' : authProvider.nickname!)[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 用户名
                      Text(
                        authProvider.nickname ?? '未设置昵称',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // 手机号
                      Text(
                        authProvider.phone ?? '未绑定手机',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 功能区域
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '我的服务',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      return _buildMenuItem(
                        context,
                        title: item['title'],
                        subtitle: item['subtitle'],
                        icon: item['icon'],
                        color: item['color'],
                        onTap: () => Navigator.pushNamed(context, item['route']),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 底部操作区域
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('设置'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, '/settings'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('帮助与反馈'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, '/help'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('关于我们'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, '/about'),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // 退出登录
                        authProvider.logout();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('退出登录'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shadowColor: color.withOpacity(0.3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: color,
                size: 28,
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
