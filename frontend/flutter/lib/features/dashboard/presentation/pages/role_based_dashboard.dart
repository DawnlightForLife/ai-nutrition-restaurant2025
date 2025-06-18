import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/permissions.dart';
import '../../../../core/widgets/permission_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'customer_dashboard.dart';
import 'merchant_dashboard.dart';
import 'nutritionist_dashboard.dart';
import 'admin_dashboard.dart';

/// 基于角色的仪表板页面
/// 根据用户角色显示不同的界面
class RoleBasedDashboard extends ConsumerWidget {
  const RoleBasedDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    if (!authState.isAuthenticated || authState.user == null) {
      return const Scaffold(
        body: Center(
          child: Text('请先登录'),
        ),
      );
    }

    final user = authState.user!;
    
    // 根据用户角色返回对应的仪表板
    switch (user.role) {
      case Roles.customer:
        return const CustomerDashboard();
      
      case Roles.storeManager:
      case Roles.storeStaff:
        return const MerchantDashboard();
      
      case Roles.nutritionist:
        return const NutritionistDashboard();
      
      case Roles.admin:
      case Roles.superAdmin:
      case Roles.areaManager:
        return const AdminDashboard();
      
      default:
        return Scaffold(
          appBar: AppBar(
            title: const Text('智能营养餐厅'),
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning,
                  size: 64,
                  color: Colors.orange,
                ),
                SizedBox(height: 16),
                Text(
                  '未知的用户角色',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  '请联系管理员检查账户设置',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
    }
  }
}

/// 快速操作卡片组件
class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.color,
    this.enabled = true,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 48,
                color: enabled ? (color ?? Theme.of(context).primaryColor) : Colors.grey,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: enabled ? null : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: enabled ? Colors.grey[600] : Colors.grey,
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

/// 统计数据卡片组件
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.trend,
    this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final String? trend;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color ?? Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color ?? Theme.of(context).primaryColor,
              ),
            ),
            if (trend != null) ...[
              const SizedBox(height: 4),
              Text(
                trend!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.green,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}