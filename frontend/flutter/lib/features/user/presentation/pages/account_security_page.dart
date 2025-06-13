import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_nutrition_restaurant/routes/app_navigator.dart';
import 'package:ai_nutrition_restaurant/shared/presentation/widgets/list_tile/setting_list_tile.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// 账号安全页面
class AccountSecurityPage extends ConsumerWidget {
  /// 构造函数
  const AccountSecurityPage({super.key});

  /// 路由名称
  static const String routeName = '/account-security';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('账号与安全'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // 账号安全选项列表
              _buildSecurityOptions(context, ref, authState),
              const SizedBox(height: 16),
              // 退出登录（从用户中心移过来）
              _buildLogoutSection(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityOptions(BuildContext context, WidgetRef ref, dynamic authState) {
    final user = authState.user;
    final needCompleteProfile = user?.needCompleteProfile ?? true;
    final hasPassword = needCompleteProfile == false; // 通过完善资料需求反推是否有密码
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SettingListTile(
            leadingIcon: Icons.phone,
            title: '修改手机号码',
            subtitle: _maskPhoneNumber((user?.phone as String?) ?? ''),
            onTap: () => _showComingSoon(context, '修改手机号码'),
          ),
          const Divider(height: 1, indent: 56),
          SettingListTile(
            leadingIcon: Icons.lock_outline,
            title: hasPassword ? '修改登录密码' : '设置登录密码',
            subtitle: hasPassword ? '等级：中' : '提高账号安全性',
            onTap: () => AppNavigator.toChangePassword(context),
          ),
          const Divider(height: 1, indent: 56),
          SettingListTile(
            leadingIcon: Icons.devices,
            title: '登录设备管理',
            subtitle: '查看和管理登录设备',
            onTap: () => _showComingSoon(context, '登录设备管理'),
          ),
          const Divider(height: 1, indent: 56),
          SettingListTile(
            leadingIcon: Icons.delete_forever_outlined,
            title: '注销账号',
            subtitle: '注销后无法恢复，请谨慎操作',
            textColor: Colors.red[600],
            onTap: () => _showAccountDeletionDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: SettingListTile(
        leadingIcon: Icons.logout,
        title: '退出登录',
        subtitle: '安全退出当前账号',
        textColor: Colors.red,
        iconColor: Colors.red,
        onTap: () => _showLogoutConfirmDialog(context, ref),
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

  /// 显示即将推出提示
  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature功能即将推出'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// 显示注销账号确认对话框
  void _showAccountDeletionDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('注销账号'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('账号注销后将无法恢复，以下数据将被永久删除：'),
            SizedBox(height: 8),
            Text('• 个人资料和营养档案'),
            Text('• 订单记录和消费记录'),
            Text('• 收藏和推荐历史'),
            Text('• 积分和优惠券'),
            SizedBox(height: 12),
            Text('确定要注销账号吗？', style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon(context, '账号注销');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('确定注销'),
          ),
        ],
      ),
    );
  }

  /// 显示退出登录确认对话框
  void _showLogoutConfirmDialog(BuildContext context, WidgetRef ref) {
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
              AppNavigator.toLogin(context);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
} 