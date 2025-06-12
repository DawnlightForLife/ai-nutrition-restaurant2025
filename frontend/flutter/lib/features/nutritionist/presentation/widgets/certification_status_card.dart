import 'package:flutter/material.dart';
import '../../domain/entities/nutritionist_certification.dart';
import '../../domain/enums/certification_status.dart';

/// 认证状态卡片组件
/// 显示当前认证申请的状态信息
class CertificationStatusCard extends StatelessWidget {
  final CertificationStatus status;
  final String applicationNumber;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final String? rejectionReason;

  const CertificationStatusCard({
    Key? key,
    required this.status,
    required this.applicationNumber,
    this.submittedAt,
    this.reviewedAt,
    this.rejectionReason,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getGradientColors(),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getStatusIcon(),
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusTitle(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '申请编号：$applicationNumber',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (submittedAt != null)
              _buildDateInfo(
                '提交时间',
                _formatDate(submittedAt!),
              ),
            if (reviewedAt != null)
              _buildDateInfo(
                '审核时间',
                _formatDate(reviewedAt!),
              ),
            if (rejectionReason != null && rejectionReason!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '拒绝原因：',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rejectionReason!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label：',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientColors() {
    switch (status) {
      case CertificationStatus.draft:
        return [Colors.grey[600]!, Colors.grey[700]!];
      case CertificationStatus.pending:
        return [Colors.orange[600]!, Colors.orange[700]!];
      case CertificationStatus.underReview:
        return [Colors.blue[600]!, Colors.blue[700]!];
      case CertificationStatus.approved:
        return [Colors.green[600]!, Colors.green[700]!];
      case CertificationStatus.rejected:
        return [Colors.red[600]!, Colors.red[700]!];
      case CertificationStatus.suspended:
        return [Colors.orange[600]!, Colors.orange[700]!];
      case CertificationStatus.expired:
        return [Colors.grey[600]!, Colors.grey[700]!];
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case CertificationStatus.draft:
        return Icons.edit_note;
      case CertificationStatus.pending:
        return Icons.hourglass_empty;
      case CertificationStatus.underReview:
        return Icons.rate_review;
      case CertificationStatus.approved:
        return Icons.check_circle;
      case CertificationStatus.rejected:
        return Icons.cancel;
      case CertificationStatus.suspended:
        return Icons.pause_circle;
      case CertificationStatus.expired:
        return Icons.schedule;
    }
  }

  String _getStatusTitle() {
    switch (status) {
      case CertificationStatus.draft:
        return '草稿';
      case CertificationStatus.pending:
        return '待审核';
      case CertificationStatus.underReview:
        return '审核中';
      case CertificationStatus.approved:
        return '已通过';
      case CertificationStatus.rejected:
        return '已拒绝';
      case CertificationStatus.suspended:
        return '暂停认证';
      case CertificationStatus.expired:
        return '认证过期';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}