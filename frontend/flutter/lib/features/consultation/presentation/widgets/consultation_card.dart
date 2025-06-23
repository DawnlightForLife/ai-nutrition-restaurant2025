import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/consultation_entity.dart';

class ConsultationCard extends StatelessWidget {
  final ConsultationEntity consultation;
  final VoidCallback? onTap;
  final Function(ConsultationStatus)? onStatusUpdate;

  const ConsultationCard({
    Key? key,
    required this.consultation,
    this.onTap,
    this.onStatusUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题和状态
              Row(
                children: [
                  Expanded(
                    child: Text(
                      consultation.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(consultation.status),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // 描述
              Text(
                consultation.description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // 咨询信息
              Row(
                children: [
                  Icon(
                    _getTypeIcon(consultation.type),
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    consultation.type.displayName,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${consultation.duration}分钟',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.attach_money,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '¥${consultation.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 时间信息
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '预约时间',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('yyyy-MM-dd HH:mm').format(consultation.scheduledStartTime),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (consultation.rating != null) ...[
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '评分',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              consultation.rating!.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              
              // 标签
              if (consultation.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: consultation.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              
              // 操作按钮
              if (onStatusUpdate != null && _canUpdateStatus(consultation.status)) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: _buildActionButtons(consultation.status),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ConsultationStatus status) {
    Color backgroundColor;
    Color textColor = Colors.white;
    
    switch (status) {
      case ConsultationStatus.pending:
        backgroundColor = Colors.orange;
        break;
      case ConsultationStatus.scheduled:
        backgroundColor = Colors.blue;
        break;
      case ConsultationStatus.inProgress:
        backgroundColor = Colors.green;
        break;
      case ConsultationStatus.completed:
        backgroundColor = Colors.grey;
        break;
      case ConsultationStatus.cancelled:
        backgroundColor = Colors.red;
        break;
      case ConsultationStatus.missed:
        backgroundColor = Colors.red[300]!;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  IconData _getTypeIcon(ConsultationType type) {
    switch (type) {
      case ConsultationType.text:
        return Icons.chat_bubble_outline;
      case ConsultationType.voice:
        return Icons.phone;
      case ConsultationType.video:
        return Icons.videocam;
      case ConsultationType.offline:
        return Icons.location_on;
    }
  }

  bool _canUpdateStatus(ConsultationStatus status) {
    return status == ConsultationStatus.pending || 
           status == ConsultationStatus.scheduled;
  }

  List<Widget> _buildActionButtons(ConsultationStatus status) {
    List<Widget> buttons = [];
    
    if (status == ConsultationStatus.pending) {
      buttons.addAll([
        OutlinedButton(
          onPressed: () => onStatusUpdate?.call(ConsultationStatus.cancelled),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
          ),
          child: const Text('拒绝'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => onStatusUpdate?.call(ConsultationStatus.scheduled),
          child: const Text('确认'),
        ),
      ]);
    } else if (status == ConsultationStatus.scheduled) {
      buttons.add(
        ElevatedButton(
          onPressed: () => onStatusUpdate?.call(ConsultationStatus.inProgress),
          child: const Text('开始咨询'),
        ),
      );
    }
    
    return buttons;
  }
}