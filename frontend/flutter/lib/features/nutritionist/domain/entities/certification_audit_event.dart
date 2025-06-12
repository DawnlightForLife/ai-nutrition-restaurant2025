import 'package:flutter/material.dart';

/// 认证审核事件实体
class CertificationAuditEvent {
  /// 事件ID
  final String id;
  
  /// 事件类型
  final String eventType;
  
  /// 事件描述
  final String description;
  
  /// 操作人
  final String? operator;
  
  /// 操作人角色
  final String? operatorRole;
  
  /// 备注
  final String? remark;
  
  /// 创建时间
  final DateTime createdAt;

  const CertificationAuditEvent({
    required this.id,
    required this.eventType,
    required this.description,
    this.operator,
    this.operatorRole,
    this.remark,
    required this.createdAt,
  });

  /// 获取事件图标
  IconData get icon {
    switch (eventType) {
      case 'created':
        return Icons.create_outlined;
      case 'submitted':
        return Icons.send_outlined;
      case 'under_review':
        return Icons.rate_review_outlined;
      case 'approved':
        return Icons.check_circle_outline;
      case 'rejected':
        return Icons.cancel_outlined;
      case 'resubmitted':
        return Icons.refresh_outlined;
      default:
        return Icons.info_outline;
    }
  }

  /// 获取事件颜色
  Color get color {
    switch (eventType) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'under_review':
        return Colors.blue;
      case 'submitted':
      case 'resubmitted':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}