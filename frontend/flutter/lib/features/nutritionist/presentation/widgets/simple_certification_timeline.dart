import 'package:flutter/material.dart';
import '../../domain/enums/certification_status.dart';

/// 简化的认证时间线
class SimpleCertificationTimeline extends StatelessWidget {
  final CertificationStatus currentStatus;

  const SimpleCertificationTimeline({
    Key? key,
    required this.currentStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final steps = [
      {'title': '提交申请', 'status': CertificationStatus.pending},
      {'title': '审核中', 'status': CertificationStatus.underReview},
      {'title': '审核完成', 'status': CertificationStatus.approved},
    ];

    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '认证进度',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isCompleted = _isStepCompleted(step['status'] as CertificationStatus?);
              final isActive = _isStepActive(step['status'] as CertificationStatus?);
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted || isActive
                            ? colorScheme.primary
                            : colorScheme.outline.withOpacity(0.3),
                      ),
                      child: Center(
                        child: isCompleted
                            ? Icon(
                                Icons.check,
                                color: colorScheme.onPrimary,
                                size: 16,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isActive
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface.withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      step['title'] as String? ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isCompleted || isActive
                            ? colorScheme.onSurface
                            : colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  bool _isStepCompleted(CertificationStatus? stepStatus) {
    if (stepStatus == null) return false;
    
    switch (currentStatus) {
      case CertificationStatus.approved:
        return true;
      case CertificationStatus.underReview:
        return stepStatus == CertificationStatus.pending;
      default:
        return false;
    }
  }

  bool _isStepActive(CertificationStatus? stepStatus) {
    if (stepStatus == null) return false;
    return stepStatus == currentStatus;
  }
}