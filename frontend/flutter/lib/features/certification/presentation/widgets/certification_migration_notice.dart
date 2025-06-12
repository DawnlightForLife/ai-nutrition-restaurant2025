import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../system/presentation/providers/system_config_provider.dart';

/// 认证流程迁移通知组件
class CertificationMigrationNotice extends ConsumerWidget {
  final VoidCallback? onDismiss;
  final VoidCallback? onNavigateToNewFlow;

  const CertificationMigrationNotice({
    super.key,
    this.onDismiss,
    this.onNavigateToNewFlow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 简化：直接显示迁移通知，实际项目中应该从配置中读取
    return _buildNoticeCard(context);
  }

  Widget _buildNoticeCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.all(16),
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '认证流程升级通知',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (onDismiss != null)
                  IconButton(
                    onPressed: onDismiss,
                    icon: Icon(
                      Icons.close,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '我们已升级认证流程，新版本更加简洁高效：',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            _buildFeatureItem(
              context,
              '• 在线申请：直接在应用内提交申请',
              theme.colorScheme.onPrimaryContainer,
            ),
            _buildFeatureItem(
              context,
              '• 实时状态：随时查看审核进度',
              theme.colorScheme.onPrimaryContainer,
            ),
            _buildFeatureItem(
              context,
              '• 快速审核：1-3个工作日完成审核',
              theme.colorScheme.onPrimaryContainer,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (onNavigateToNewFlow != null)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onNavigateToNewFlow,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('体验新流程'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                if (onNavigateToNewFlow != null) const SizedBox(width: 12),
                TextButton(
                  onPressed: () => _showDetailDialog(context),
                  child: Text(
                    '了解更多',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('认证流程升级详情'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailSection(
                '新流程优势',
                [
                  '简化申请步骤，减少填写信息',
                  '支持多种联系方式提交',
                  '实时查看审核状态和结果',
                  '自动化权限管理，审核通过即可使用',
                ],
                theme,
              ),
              const SizedBox(height: 16),
              _buildDetailSection(
                '迁移时间',
                [
                  '新流程已正式上线',
                  '旧流程将在30天后停止服务',
                  '已提交的旧申请将继续处理',
                  '建议尽快迁移到新流程',
                ],
                theme,
              ),
              const SizedBox(height: 16),
              _buildDetailSection(
                '需要帮助？',
                [
                  '客服电话：400-123-4567',
                  '客服邮箱：cert@aihealth.com',
                  '客服微信：AIHealth2025',
                  '工作时间：周一至周五 9:00-18:00',
                ],
                theme,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
          if (onNavigateToNewFlow != null)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onNavigateToNewFlow!();
              },
              child: const Text('立即体验'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<String> items, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(
            '• $item',
            style: theme.textTheme.bodySmall,
          ),
        )),
      ],
    );
  }
}

/// 简化版迁移通知横幅
class CertificationMigrationBanner extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const CertificationMigrationBanner({
    super.key,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.upgrade,
          color: theme.colorScheme.secondary,
        ),
        title: const Text('认证流程已升级'),
        subtitle: const Text('新版更简洁高效，点击了解'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onDismiss != null)
              IconButton(
                onPressed: onDismiss,
                icon: const Icon(Icons.close, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}