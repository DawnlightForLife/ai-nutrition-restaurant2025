import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/certification_migration_notice.dart';
import '../../../permission/presentation/pages/permission_application_page.dart';
import '../../../permission/data/models/user_permission_model.dart';

class LegacyCertificationDisabledPage extends ConsumerWidget {
  final PermissionType permissionType;

  const LegacyCertificationDisabledPage({
    super.key,
    required this.permissionType,
  });

  static const String routeName = '/legacy-certification-disabled';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isNutritionist = permissionType == PermissionType.nutritionist;

    return Scaffold(
      appBar: AppBar(
        title: Text('${isNutritionist ? '营养师' : '商家'}认证'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 主要信息卡片
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.upgrade,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '认证流程已升级',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '我们已为您提供全新的${isNutritionist ? '营养师' : '商家'}认证流程，更加简洁高效。',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToNewFlow(context),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('使用新版认证流程'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 升级优势
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '新版流程优势',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAdvantageItem(
                      context,
                      Icons.speed,
                      '更快速',
                      '简化申请步骤，减少等待时间',
                    ),
                    _buildAdvantageItem(
                      context,
                      Icons.visibility,
                      '更透明',
                      '实时查看审核状态和进度',
                    ),
                    _buildAdvantageItem(
                      context,
                      Icons.phone,
                      '多渠道',
                      '支持在线申请、客服联系等多种方式',
                    ),
                    _buildAdvantageItem(
                      context,
                      Icons.security,
                      '更安全',
                      '新版权限管理，保障数据安全',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 迁移通知组件
            CertificationMigrationNotice(
              onNavigateToNewFlow: () => _navigateToNewFlow(context),
            ),
            const SizedBox(height: 24),

            // 需要帮助
            Card(
              color: theme.colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 32,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '需要帮助？',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '如果您在使用新版认证流程时遇到问题，可以联系我们的客服团队。',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showContactInfo(context),
                            icon: const Icon(Icons.contact_support),
                            label: const Text('联系客服'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showFAQ(context),
                            icon: const Icon(Icons.quiz),
                            label: const Text('常见问题'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvantageItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToNewFlow(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PermissionApplicationPage(
          permissionType: permissionType,
        ),
      ),
    );
  }

  void _showContactInfo(BuildContext context) {
    // 动态获取联系信息
    final contactInfo = '客服电话：400-123-4567'; // TODO: 通过Provider或参数传入
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('联系客服'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('客服电话：${contactInfo['phone'] ?? '400-123-4567'}'),
            const SizedBox(height: 8),
            Text('客服邮箱：${contactInfo['email'] ?? 'cert@aihealth.com'}'),
            const SizedBox(height: 8),
            Text('客服微信：${contactInfo['wechat'] ?? 'AIHealth2025'}'),
            const SizedBox(height: 8),
            const Text('工作时间：周一至周五 9:00-18:00'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  void _showFAQ(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('常见问题'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFAQItem(
                'Q: 为什么要升级认证流程？',
                'A: 新版流程更加简洁高效，减少了用户的等待时间，提升了用户体验。',
              ),
              _buildFAQItem(
                'Q: 我之前提交的申请怎么办？',
                'A: 已提交的申请将继续处理，您可以继续关注审核状态。',
              ),
              _buildFAQItem(
                'Q: 新版流程有什么不同？',
                'A: 新版支持在线直接申请，实时查看状态，审核更快速。',
              ),
              _buildFAQItem(
                'Q: 如果遇到问题怎么办？',
                'A: 可以通过多种方式联系客服，我们会及时为您解决问题。',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(answer),
        ],
      ),
    );
  }
}