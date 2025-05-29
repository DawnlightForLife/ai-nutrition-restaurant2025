import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 管理后台仪表盘
class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('管理后台'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: 刷新数据
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SystemOverviewSection(),
            SizedBox(height: 24),
            _ManagementModulesSection(),
            SizedBox(height: 24),
            _RecentActivitiesSection(),
            SizedBox(height: 24),
            _SystemStatusSection(),
          ],
        ),
      ),
    );
  }
}

class _SystemOverviewSection extends StatelessWidget {
  const _SystemOverviewSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '系统概况',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildOverviewCard(
              title: '总用户数',
              value: '12,856',
              icon: Icons.people,
              color: Colors.blue,
              growth: '+8.5%',
            ),
            _buildOverviewCard(
              title: '活跃营养师',
              value: '156',
              icon: Icons.psychology,
              color: Colors.green,
              growth: '+12.3%',
            ),
            _buildOverviewCard(
              title: '合作商家',
              value: '89',
              icon: Icons.store,
              color: Colors.orange,
              growth: '+5.7%',
            ),
            _buildOverviewCard(
              title: '今日订单',
              value: '1,234',
              icon: Icons.shopping_cart,
              color: Colors.purple,
              growth: '+15.2%',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String growth,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    growth,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManagementModulesSection extends StatelessWidget {
  const _ManagementModulesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '管理模块',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            _buildModuleCard(
              title: '用户管理',
              icon: Icons.people,
              color: Colors.blue,
              onTap: () {
                // TODO: 跳转到用户管理
              },
            ),
            _buildModuleCard(
              title: '营养师管理',
              icon: Icons.psychology,
              color: Colors.green,
              onTap: () {
                // TODO: 跳转到营养师管理
              },
            ),
            _buildModuleCard(
              title: '商家管理',
              icon: Icons.store,
              color: Colors.orange,
              onTap: () {
                // TODO: 跳转到商家管理
              },
            ),
            _buildModuleCard(
              title: '订单管理',
              icon: Icons.receipt,
              color: Colors.purple,
              onTap: () {
                // TODO: 跳转到订单管理
              },
            ),
            _buildModuleCard(
              title: '内容管理',
              icon: Icons.article,
              color: Colors.teal,
              onTap: () {
                // TODO: 跳转到内容管理
              },
            ),
            _buildModuleCard(
              title: '系统设置',
              icon: Icons.settings,
              color: Colors.grey,
              onTap: () {
                // TODO: 跳转到系统设置
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModuleCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentActivitiesSection extends StatelessWidget {
  const _RecentActivitiesSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '最近活动',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(5, (index) {
              return _buildActivityItem(
                title: '新用户注册',
                description: '用户 ${index + 1} 完成了注册',
                time: '${index + 1} 分钟前',
                icon: Icons.person_add,
                color: Colors.green,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String description,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemStatusSection extends StatelessWidget {
  const _SystemStatusSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '系统状态',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatusItem('API服务', '正常', Colors.green),
            _buildStatusItem('数据库', '正常', Colors.green),
            _buildStatusItem('AI服务', '正常', Colors.green),
            _buildStatusItem('存储服务', '正常', Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String service, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(service)),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}