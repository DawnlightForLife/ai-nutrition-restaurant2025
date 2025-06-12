import 'package:flutter/material.dart';
import '../../domain/entities/nutritionist_certification.dart';
import '../../domain/entities/certification_audit_event.dart';
import '../../domain/enums/certification_status.dart';

/// 认证审核时间线组件
/// 显示认证申请的审核历史记录
class CertificationTimeline extends StatelessWidget {
  final CertificationStatus currentStatus;
  final List<CertificationAuditEvent> events;

  const CertificationTimeline({
    Key? key,
    required this.currentStatus,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timelineSteps = _buildTimelineSteps();

    return Column(
      children: List.generate(timelineSteps.length, (index) {
        final step = timelineSteps[index];
        final isLast = index == timelineSteps.length - 1;
        final isCompleted = step.isCompleted;
        final isActive = step.isActive;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? Colors.green
                        : isActive
                            ? Colors.blue
                            : Colors.grey[300],
                  ),
                  child: Center(
                    child: Icon(
                      step.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 60,
                    color: isCompleted ? Colors.green : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCompleted || isActive
                          ? Colors.black87
                          : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (step.timestamp != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(step.timestamp!),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  List<TimelineStep> _buildTimelineSteps() {
    final steps = <TimelineStep>[];

    // 提交申请步骤
    final submitEvent = events.firstWhere(
      (e) => e.eventType == 'submitted',
      orElse: () => CertificationAuditEvent(
        id: 'default-submit',
        eventType: 'submitted',
        description: '等待提交申请',
        createdAt: DateTime.now(),
      ),
    );

    steps.add(TimelineStep(
      title: '提交申请',
      description: submitEvent.description,
      icon: Icons.upload_file,
      timestamp: submitEvent.createdAt,
      isCompleted: currentStatus != CertificationStatus.draft,
      isActive: currentStatus == CertificationStatus.draft,
    ));

    // 开始审核步骤
    if (currentStatus != CertificationStatus.draft) {
      final reviewStartEvent = events.firstWhere(
        (e) => e.eventType == 'under_review',
        orElse: () => CertificationAuditEvent(
          id: 'default-review',
          eventType: 'under_review',
          description: '等待管理员开始审核',
          createdAt: DateTime.now(),
        ),
      );

      steps.add(TimelineStep(
        title: '开始审核',
        description: reviewStartEvent.description,
        icon: Icons.rate_review,
        timestamp: reviewStartEvent.createdAt,
        isCompleted: currentStatus == CertificationStatus.approved ||
            currentStatus == CertificationStatus.rejected ||
            currentStatus == CertificationStatus.underReview,
        isActive: currentStatus == CertificationStatus.pending,
      ));
    }

    // 审核结果步骤
    if (currentStatus == CertificationStatus.approved ||
        currentStatus == CertificationStatus.rejected ||
        currentStatus == CertificationStatus.suspended ||
        currentStatus == CertificationStatus.expired) {
      final resultEvent = events.firstWhere(
        (e) => e.eventType == 'approved' || e.eventType == 'rejected',
        orElse: () => CertificationAuditEvent(
          id: 'default-result',
          eventType: currentStatus == CertificationStatus.approved ? 'approved' : 'rejected',
          description: _getResultDescription(),
          createdAt: DateTime.now(),
        ),
      );

      steps.add(TimelineStep(
        title: _getResultTitle(),
        description: resultEvent.description,
        icon: _getResultIcon(),
        timestamp: resultEvent.createdAt,
        isCompleted: true,
        isActive: false,
      ));
    }

    return steps;
  }

  String _getResultTitle() {
    switch (currentStatus) {
      case CertificationStatus.approved:
        return '审核通过';
      case CertificationStatus.rejected:
        return '审核未通过';
      case CertificationStatus.suspended:
        return '认证暂停';
      case CertificationStatus.expired:
        return '认证过期';
      default:
        return '审核中';
    }
  }

  String _getResultDescription() {
    switch (currentStatus) {
      case CertificationStatus.approved:
        return '恭喜您！您的营养师认证申请已通过审核';
      case CertificationStatus.rejected:
        return '很遗憾，您的申请未通过审核，请查看拒绝原因';
      case CertificationStatus.suspended:
        return '您的认证已被暂停';
      case CertificationStatus.expired:
        return '您的认证已过期，请重新申请';
      default:
        return '审核进行中';
    }
  }

  IconData _getResultIcon() {
    switch (currentStatus) {
      case CertificationStatus.approved:
        return Icons.check_circle;
      case CertificationStatus.rejected:
        return Icons.cancel;
      case CertificationStatus.suspended:
        return Icons.pause_circle;
      case CertificationStatus.expired:
        return Icons.schedule;
      default:
        return Icons.hourglass_empty;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

/// 时间线步骤数据模型
class TimelineStep {
  final String title;
  final String description;
  final IconData icon;
  final DateTime? timestamp;
  final bool isCompleted;
  final bool isActive;

  TimelineStep({
    required this.title,
    required this.description,
    required this.icon,
    this.timestamp,
    required this.isCompleted,
    required this.isActive,
  });
}