import 'package:flutter/material.dart';
import '../../domain/enums/certification_status.dart';
import '../../domain/entities/nutritionist_certification.dart';

/// 简化的认证状态卡片
class SimpleCertificationStatusCard extends StatelessWidget {
  final NutritionistCertification certification;

  const SimpleCertificationStatusCard({
    Key? key,
    required this.certification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // 简化的状态处理
    final status = CertificationStatus.draft; // 默认状态
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getStatusIcon(status),
                  color: _getStatusColor(status, colorScheme),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  '认证状态',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getStatusColor(status, colorScheme).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getStatusColor(status, colorScheme).withOpacity(0.3),
                ),
              ),
              child: Text(
                status.displayName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _getStatusColor(status, colorScheme),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '申请ID: ${certification.id}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(CertificationStatus status) {
    switch (status) {
      case CertificationStatus.draft:
        return Icons.edit_outlined;
      case CertificationStatus.pending:
        return Icons.pending_outlined;
      case CertificationStatus.underReview:
        return Icons.search_outlined;
      case CertificationStatus.approved:
        return Icons.check_circle_outline;
      case CertificationStatus.rejected:
        return Icons.cancel_outlined;
      case CertificationStatus.suspended:
        return Icons.pause_circle_outline;
      case CertificationStatus.expired:
        return Icons.schedule_outlined;
    }
  }

  Color _getStatusColor(CertificationStatus status, ColorScheme colorScheme) {
    switch (status) {
      case CertificationStatus.draft:
        return Colors.grey;
      case CertificationStatus.pending:
        return Colors.orange;
      case CertificationStatus.underReview:
        return Colors.blue;
      case CertificationStatus.approved:
        return Colors.green;
      case CertificationStatus.rejected:
        return Colors.red;
      case CertificationStatus.suspended:
        return Colors.purple;
      case CertificationStatus.expired:
        return Colors.brown;
    }
  }
}