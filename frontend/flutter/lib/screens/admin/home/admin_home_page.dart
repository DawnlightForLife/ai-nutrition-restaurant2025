import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/index.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    // 检查是否是管理员
    if (userProvider.user?.role != 'admin') {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                '访问被拒绝',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '您没有权限访问管理员页面',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text('返回主页'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('管理员控制台'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              userProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildAdminCard(
            context,
            '营养师认证管理',
            Icons.medical_services,
            Colors.blue,
            () => Navigator.pushNamed(context, '/admin/nutritionist-verification'),
          ),
          _buildAdminCard(
            context,
            '商家认证管理',
            Icons.store,
            Colors.orange,
            () => Navigator.pushNamed(context, '/admin/merchant-verification'),
          ),
          _buildAdminCard(
            context,
            '用户管理',
            Icons.people,
            Colors.green,
            () {
              // TODO: 实现用户管理功能
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('用户管理功能正在开发中')),
              );
            },
          ),
          _buildAdminCard(
            context,
            '系统设置',
            Icons.settings,
            Colors.purple,
            () {
              // TODO: 实现系统设置功能
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('系统设置功能正在开发中')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 