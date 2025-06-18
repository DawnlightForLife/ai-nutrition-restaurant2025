import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/permissions.dart';
import '../../../../core/widgets/permission_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'role_based_dashboard.dart';

/// 商家仪表板
class MerchantDashboard extends ConsumerWidget {
  const MerchantDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('商家管理中心'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: 导航到通知页面
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: 导航到设置页面
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
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        user.nickname?.substring(0, 1).toUpperCase() ?? 'M',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '欢迎回来，${user.nickname ?? '商家'}！',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '今日经营状况良好',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 今日统计
            Text(
              '今日概览',
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
              children: [
                const StatCard(
                  title: '今日订单',
                  value: '25',
                  icon: Icons.receipt_long,
                  trend: '+12% 比昨日',
                  color: Colors.blue,
                ),
                const StatCard(
                  title: '今日营收',
                  value: '¥1,286',
                  icon: Icons.monetization_on,
                  trend: '+8% 比昨日',
                  color: Colors.green,
                ),
                PermissionWidget(
                  requiredPermissions: const [Permissions.inventoryRead],
                  child: const StatCard(
                    title: '库存预警',
                    value: '3',
                    icon: Icons.warning,
                    color: Colors.orange,
                  ),
                ),
                const StatCard(
                  title: '客户评分',
                  value: '4.8',
                  icon: Icons.star,
                  color: Colors.amber,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 快速操作
            Text(
              '快速操作',
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
                  requiredPermissions: const [Permissions.dishRead],
                  child: QuickActionCard(
                    title: '菜品管理',
                    subtitle: '管理菜单和价格',
                    icon: Icons.restaurant_menu,
                    onTap: () {
                      Navigator.pushNamed(context, '/dishes');
                    },
                  ),
                ),
                PermissionWidget(
                  requiredPermissions: const [Permissions.orderRead],
                  child: QuickActionCard(
                    title: '订单管理',
                    subtitle: '查看和处理订单',
                    icon: Icons.list_alt,
                    onTap: () {
                      Navigator.pushNamed(context, '/orders');
                    },
                  ),
                ),
                PermissionWidget(
                  requiredPermissions: const [Permissions.inventoryRead],
                  child: QuickActionCard(
                    title: '库存管理',
                    subtitle: '管理食材库存',
                    icon: Icons.inventory,
                    onTap: () {
                      Navigator.pushNamed(context, '/inventory');
                    },
                  ),
                ),
                PermissionWidget(
                  requiredPermissions: const [Permissions.statsView],
                  child: QuickActionCard(
                    title: '销售统计',
                    subtitle: '查看销售报表',
                    icon: Icons.analytics,
                    onTap: () {
                      Navigator.pushNamed(context, '/stats');
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 最近订单（仅有权限用户可见）
            PermissionWidget(
              requiredPermissions: const [Permissions.orderRead],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '最近订单',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/orders');
                        },
                        child: const Text('查看全部'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // 订单列表
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3, // 显示最近3个订单
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getOrderStatusColor(index),
                            child: Text(
                              '#${1001 + index}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text('订单 #${1001 + index}'),
                          subtitle: Text(
                            '${_getOrderItems(index)} • ${_getOrderTime(index)}',
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '¥${_getOrderAmount(index)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _getOrderStatus(index),
                                style: TextStyle(
                                  color: _getOrderStatusColor(index),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            // TODO: 导航到订单详情
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
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
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: '菜品',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: '订单',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: '统计',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/dishes');
              break;
            case 2:
              Navigator.pushNamed(context, '/orders');
              break;
            case 3:
              Navigator.pushNamed(context, '/stats');
              break;
          }
        },
      ),
      
      // 浮动操作按钮
      floatingActionButton: PermissionWidget(
        requiredPermissions: const [Permissions.dishWrite],
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/dishes/create');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
  
  Color _getOrderStatusColor(int index) {
    switch (index % 3) {
      case 0:
        return Colors.green; // 已完成
      case 1:
        return Colors.orange; // 进行中
      default:
        return Colors.blue; // 待处理
    }
  }
  
  String _getOrderItems(int index) {
    const items = ['宫保鸡丁 x2', '麻婆豆腐 x1', '青椒肉丝 x1'];
    return items[index % items.length];
  }
  
  String _getOrderTime(int index) {
    const times = ['10分钟前', '25分钟前', '1小时前'];
    return times[index % times.length];
  }
  
  String _getOrderAmount(int index) {
    const amounts = ['68.00', '45.50', '52.80'];
    return amounts[index % amounts.length];
  }
  
  String _getOrderStatus(int index) {
    const statuses = ['已完成', '制作中', '待确认'];
    return statuses[index % statuses.length];
  }
}