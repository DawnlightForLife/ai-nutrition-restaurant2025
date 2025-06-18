import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/permissions.dart';
import '../../../../core/widgets/permission_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'role_based_dashboard.dart';

/// 管理员仪表板
class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('管理员控制台'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/admin/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: 实现登出功能
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 欢迎消息
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '管理员 ${user.nickname ?? ''}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('系统运行正常，今日新增5家商户'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 系统统计
            Text(
              '系统概览',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              children: const [
                StatCard(
                  title: '总用户数',
                  value: '12,450',
                  icon: Icons.people,
                  trend: '+8% 本月',
                  color: Colors.blue,
                ),
                StatCard(
                  title: '商户数量',
                  value: '285',
                  icon: Icons.store,
                  trend: '+5 今日',
                  color: Colors.green,
                ),
                StatCard(
                  title: '今日订单',
                  value: '1,286',
                  icon: Icons.receipt_long,
                  trend: '+12% 比昨日',
                  color: Colors.orange,
                ),
                StatCard(
                  title: '平台收入',
                  value: '¥58,420',
                  icon: Icons.monetization_on,
                  trend: '+15% 本月',
                  color: Colors.purple,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 管理功能
            Text(
              '管理功能',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                PermissionWidget(
                  requiredPermissions: const [Permissions.userRead],
                  child: QuickActionCard(
                    title: '用户管理',
                    subtitle: '管理用户账户',
                    icon: Icons.people_alt,
                    onTap: () {
                      Navigator.pushNamed(context, '/admin/users');
                    },
                  ),
                ),
                PermissionWidget(
                  requiredPermissions: const [Permissions.merchantRead],
                  child: QuickActionCard(
                    title: '商户管理',
                    subtitle: '审核和管理商户',
                    icon: Icons.business,
                    onTap: () {
                      Navigator.pushNamed(context, '/admin/merchants');
                    },
                  ),
                ),
                PermissionWidget(
                  requiredPermissions: const [Permissions.orderRead],
                  child: QuickActionCard(
                    title: '订单监控',
                    subtitle: '监控订单状态',
                    icon: Icons.monitor,
                    onTap: () {
                      Navigator.pushNamed(context, '/admin/orders');
                    },
                  ),
                ),
                PermissionWidget(
                  requiredPermissions: const [Permissions.statsView],
                  child: QuickActionCard(
                    title: '数据分析',
                    subtitle: '查看平台数据',
                    icon: Icons.analytics,
                    onTap: () {
                      Navigator.pushNamed(context, '/admin/analytics');
                    },
                  ),
                ),
                PermissionWidget(
                  requiredPermissions: const [Permissions.systemConfig],
                  child: QuickActionCard(
                    title: '系统配置',
                    subtitle: '系统参数设置',
                    icon: Icons.settings,
                    onTap: () {
                      Navigator.pushNamed(context, '/admin/system-config');
                    },
                  ),
                ),
                PermissionWidget(
                  requiredPermissions: const [Permissions.permissionView],
                  child: QuickActionCard(
                    title: '权限管理',
                    subtitle: '角色权限配置',
                    icon: Icons.security,
                    onTap: () {
                      Navigator.pushNamed(context, '/admin/permissions');
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 系统监控
            PermissionWidget(
              requiredPermissions: const [Permissions.systemMonitor],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '系统监控',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/admin/monitoring');
                        },
                        child: const Text('详细监控'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.memory,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('CPU使用率'),
                                    const Spacer(),
                                    Text(
                                      '45%',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: 0.45,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.storage,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('内存使用'),
                                    const Spacer(),
                                    Text(
                                      '68%',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: 0.68,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 最近活动
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '最近活动',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getActivityColor(index),
                          child: Icon(
                            _getActivityIcon(index),
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(_getActivityTitle(index)),
                        subtitle: Text(_getActivityTime(index)),
                        trailing: const Icon(Icons.more_vert),
                        onTap: () {
                          // TODO: 查看活动详情
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      
      // 底部导航栏
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '总览',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '用户',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '商户',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: '数据',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/admin/users');
              break;
            case 2:
              Navigator.pushNamed(context, '/admin/merchants');
              break;
            case 3:
              Navigator.pushNamed(context, '/admin/analytics');
              break;
          }
        },
      ),
    );
  }
  
  Color _getActivityColor(int index) {
    const colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red];
    return colors[index % colors.length];
  }
  
  IconData _getActivityIcon(int index) {
    const icons = [Icons.person_add, Icons.store, Icons.receipt, Icons.settings, Icons.warning];
    return icons[index % icons.length];
  }
  
  String _getActivityTitle(int index) {
    const titles = [
      '新用户注册：张三',
      '商户审核通过：美味餐厅',
      '大额订单：¥1,250',
      '系统配置更新',
      '异常登录检测'
    ];
    return titles[index % titles.length];
  }
  
  String _getActivityTime(int index) {
    const times = ['5分钟前', '15分钟前', '30分钟前', '1小时前', '2小时前'];
    return times[index % times.length];
  }
}