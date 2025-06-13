import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:ai_nutrition_restaurant/core/extensions/context_extension.dart';
import 'package:ai_nutrition_restaurant/routes/app_navigator.dart';
import 'package:ai_nutrition_restaurant/routes/route_names.dart';
import 'package:ai_nutrition_restaurant/shared/presentation/widgets/list_tile/setting_list_tile.dart';

/// 设置页面
class SettingsPage extends ConsumerStatefulWidget {
  /// 构造函数
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String _appVersion = '加载中...';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _appVersion = 'v${packageInfo.version}+${packageInfo.buildNumber}';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _appVersion = 'v1.0.0';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // 分类显示设置选项
              _buildAccountSection(context),
              _buildPrivacySection(context),
              _buildNotificationSection(context),
              _buildGeneralSection(context),
              _buildAboutSection(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建分类标题
  Widget _buildSectionHeader(String title, String subtitle) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 账号与安全分类
  Widget _buildAccountSection(BuildContext context) {
    final l10n = context.l10n;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('账号与安全', '管理您的账号安全设置'),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SettingListTile(
                leadingIcon: Icons.security,
                title: '账号与安全',
                subtitle: '密码、手机号等安全设置',
                onTap: () => AppNavigator.toAccountSecurity(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 隐私设置分类
  Widget _buildPrivacySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('隐私设置', '控制您的信息如何被使用'),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SettingListTile(
                leadingIcon: Icons.visibility,
                title: '个人资料可见性',
                subtitle: '设置谁可以看到您的资料',
                onTap: () => _showComingSoon(context, '个人资料可见性设置'),
              ),
              const Divider(height: 1, indent: 56),
              SettingListTile(
                leadingIcon: Icons.location_on,
                title: '位置服务',
                subtitle: '控制位置信息的使用',
                onTap: () => _showComingSoon(context, '位置服务设置'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 通知管理分类
  Widget _buildNotificationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('通知管理', '设置您的通知偏好'),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SettingListTile(
                leadingIcon: Icons.notifications_active,
                title: '推送通知',
                subtitle: '接收应用推送消息',
                onTap: () => AppNavigator.toNotifications(context),
              ),
              const Divider(height: 1, indent: 56),
              SettingListTile(
                leadingIcon: Icons.receipt,
                title: '订单通知',
                subtitle: '订单状态变更提醒',
                onTap: () => _showComingSoon(context, '订单通知设置'),
              ),
              const Divider(height: 1, indent: 56),
              SettingListTile(
                leadingIcon: Icons.chat,
                title: '咨询消息',
                subtitle: '营养师咨询回复提醒',
                onTap: () => _showComingSoon(context, '咨询消息设置'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 通用设置分类
  Widget _buildGeneralSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('通用设置', '个性化您的使用体验'),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SettingListTile(
                leadingIcon: Icons.language,
                title: '语言',
                subtitle: '简体中文',
                onTap: () => _showComingSoon(context, '语言设置'),
              ),
              const Divider(height: 1, indent: 56),
              SettingListTile(
                leadingIcon: Icons.palette,
                title: '主题',
                subtitle: '跟随系统',
                onTap: () => _showComingSoon(context, '主题设置'),
              ),
              const Divider(height: 1, indent: 56),
              SettingListTile(
                leadingIcon: Icons.text_fields,
                title: '字体大小',
                subtitle: '标准',
                onTap: () => _showComingSoon(context, '字体大小设置'),
              ),
              const Divider(height: 1, indent: 56),
              SettingListTile(
                leadingIcon: Icons.cleaning_services,
                title: '清除缓存',
                subtitle: '释放存储空间',
                onTap: () => _handleClearCache(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 关于分类
  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('关于', '了解更多信息'),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SettingListTile(
                leadingIcon: Icons.info_outline,
                title: '版本信息',
                subtitle: _appVersion,
                onTap: () => _showVersionInfo(context),
              ),
              const Divider(height: 1, indent: 56),
              SettingListTile(
                leadingIcon: Icons.description,
                title: '用户协议',
                onTap: () => _showComingSoon(context, '用户协议'),
              ),
              const Divider(height: 1, indent: 56),
              SettingListTile(
                leadingIcon: Icons.privacy_tip,
                title: '隐私政策',
                onTap: () => _showComingSoon(context, '隐私政策'),
              ),
              const Divider(height: 1, indent: 56),
              SettingListTile(
                leadingIcon: Icons.help_outline,
                title: '帮助与反馈',
                subtitle: '常见问题、意见反馈',
                onTap: () => _showComingSoon(context, '帮助与反馈'),
              ),
              const Divider(height: 1, indent: 56),
              SettingListTile(
                leadingIcon: Icons.update,
                title: '检查更新',
                subtitle: '当前已是最新版本',
                onTap: () => _handleCheckUpdate(context),
              ),
            ],
          ),
        ),
      ],
    );
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

  /// 处理清除缓存
  void _handleClearCache(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除缓存'),
        content: const Text('确定要清除应用缓存吗？这将释放存储空间，但下次使用时可能需要重新加载数据。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('缓存清除成功'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
  }

  /// 处理检查更新
  void _handleCheckUpdate(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('当前已是最新版本'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// 显示版本信息
  void _showVersionInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('版本信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('应用版本：$_appVersion'),
            const SizedBox(height: 8),
            const Text('智慧AI营养餐厅'),
            const SizedBox(height: 4),
            const Text('为您提供个性化营养推荐服务'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
  }
  
  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.logout),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              // TODO: 实现退出登录逻辑
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, RouteNames.login);
            },
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
  }
} 