import 'package:flutter/material.dart';
import '../providers/certification_review_provider.dart';

/// 认证审核卡片组件
class CertificationReviewCard extends StatelessWidget {
  final CertificationApplication application;
  final VoidCallback onTap;
  final Function(String action) onQuickAction;

  const CertificationReviewCard({
    super.key,
    required this.application,
    required this.onTap,
    required this.onQuickAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头部信息
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: application.nutritionistAvatar != null
                        ? ClipOval(
                            child: Image.network(
                              application.nutritionistAvatar!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Text(
                                application.nutritionistName.substring(0, 1),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          )
                        : Text(
                            application.nutritionistName.substring(0, 1),
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              application.nutritionistName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildPriorityBadge(application.priority),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '申请等级: ${_getCertificationLevelLabel(application.certificationLevel)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(application.status),
                ],
              ),
              const SizedBox(height: 12),

              // 专业领域
              if (application.specializations.isNotEmpty) ...[
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: application.specializations.map((spec) {
                    return Chip(
                      label: Text(
                        spec,
                        style: const TextStyle(fontSize: 11),
                      ),
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      labelStyle: const TextStyle(color: Colors.blue),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],

              // 时间信息
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '提交时间: ${_formatDateTime(application.submittedAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              if (application.reviewedAt != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.done_all,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '审核时间: ${_formatDateTime(application.reviewedAt!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],

              // 快速操作按钮（仅待审核状态）
              if (application.status == 'pending') ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => onQuickAction('reject'),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('拒绝'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => onQuickAction('needsRevision'),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('要求修改'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => onQuickAction('approve'),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('通过'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = '待审核';
        icon = Icons.pending;
        break;
      case 'approved':
        color = Colors.green;
        label = '已通过';
        icon = Icons.check_circle;
        break;
      case 'rejected':
        color = Colors.red;
        label = '已拒绝';
        icon = Icons.cancel;
        break;
      case 'needsRevision':
        color = Colors.blue;
        label = '需修改';
        icon = Icons.edit;
        break;
      default:
        color = Colors.grey;
        label = status;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color color;
    IconData icon;

    switch (priority) {
      case 'urgent':
        color = Colors.red;
        icon = Icons.priority_high;
        break;
      case 'high':
        color = Colors.orange;
        icon = Icons.arrow_upward;
        break;
      case 'low':
        color = Colors.grey;
        icon = Icons.arrow_downward;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 12,
        color: color,
      ),
    );
  }

  String _getCertificationLevelLabel(String level) {
    switch (level) {
      case 'junior':
        return '初级营养师';
      case 'intermediate':
        return '中级营养师';
      case 'senior':
        return '高级营养师';
      case 'expert':
        return '专家营养师';
      default:
        return level;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}