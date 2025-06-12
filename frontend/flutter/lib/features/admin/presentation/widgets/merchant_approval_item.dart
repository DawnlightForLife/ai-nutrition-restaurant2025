import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 商户审核列表项
class MerchantApprovalItem extends StatelessWidget {
  final Map<String, dynamic> merchant;
  final String status;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onViewDetail;
  
  const MerchantApprovalItem({
    super.key,
    required this.merchant,
    this.status = 'pending',
    this.onApprove,
    this.onReject,
    this.onViewDetail,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onViewDetail,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 商户基本信息
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 商户图标
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.store,
                      color: theme.colorScheme.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // 商户信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                (merchant['businessName'] as String?) ?? '未知商家',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildStatusBadge(context),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '联系人：${merchant['contact']?['email'] ?? ''} | ${merchant['contact']?['phone'] ?? ''}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '地址：${merchant['address']?['city'] ?? ''} ${merchant['address']?['state'] ?? ''}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 营业执照信息
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '业务类型：${_getBusinessTypeLabel((merchant['businessType'] as String?) ?? '未知')}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // 时间信息
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getTimeText(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              
              // 拒绝原因（如果有）
              if (status == 'rejected' && merchant['verification']?['rejectionReason'] != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.red[700],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '拒绝原因：${merchant['verification']?['rejectionReason']}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              // 操作按钮（仅待审核状态）
              if (status == 'pending') ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: OutlinedButton.icon(
                        onPressed: onReject,
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('拒绝'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: ElevatedButton.icon(
                        onPressed: onApprove,
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('通过'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
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
  
  /// 构建状态徽章
  Widget _buildStatusBadge(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;
    
    switch (status) {
      case 'approved':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green[700]!;
        text = '已通过';
        icon = Icons.check_circle;
        break;
      case 'rejected':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red[700]!;
        text = '已拒绝';
        icon = Icons.cancel;
        break;
      default:
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange[700]!;
        text = '待审核';
        icon = Icons.pending;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  /// 获取业务类型中文标签
  String _getBusinessTypeLabel(String type) {
    const typeMap = {
      'maternityCenter': '月子中心',
      'gym': '健身房',
      'school': '学校',
      'company': '公司',
      'restaurant': '餐厅',
      'schoolCompany': '学校/企业',
      'other': '其他',
    };
    return typeMap[type] ?? type;
  }

  /// 获取时间文本
  String _getTimeText() {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    
    if (status == 'pending') {
      final createdAt = merchant['createdAt'];
      if (createdAt != null) {
        DateTime date;
        if (createdAt is String) {
          date = DateTime.parse(createdAt);
        } else if (createdAt is DateTime) {
          date = createdAt;
        } else {
          return '提交时间：--';
        }
        return '提交时间：${dateFormat.format(date)}';
      }
      return '提交时间：--';
    } else if (status == 'approved') {
      // 首先尝试verifiedAt，如果没有则使用updatedAt
      final verifiedAt = merchant['verification']?['verifiedAt'] ?? merchant['updatedAt'];
      if (verifiedAt != null) {
        DateTime date;
        if (verifiedAt is String) {
          date = DateTime.parse(verifiedAt);
        } else if (verifiedAt is DateTime) {
          date = verifiedAt;
        } else {
          return '通过时间：--';
        }
        return '通过时间：${dateFormat.format(date)}';
      }
      // 如果都没有，尝试使用createdAt
      final createdAt = merchant['createdAt'];
      if (createdAt != null) {
        DateTime date;
        if (createdAt is String) {
          date = DateTime.parse(createdAt);
        } else if (createdAt is DateTime) {
          date = createdAt;
        } else {
          return '通过时间：--';
        }
        return '通过时间：${dateFormat.format(date)}';
      }
      return '通过时间：--';
    } else {
      // 对于拒绝状态，首先尝试verifiedAt，然后是updatedAt
      final verifiedAt = merchant['verification']?['verifiedAt'] ?? merchant['updatedAt'];
      if (verifiedAt != null) {
        DateTime date;
        if (verifiedAt is String) {
          date = DateTime.parse(verifiedAt);
        } else if (verifiedAt is DateTime) {
          date = verifiedAt;
        } else {
          return '拒绝时间：--';
        }
        return '拒绝时间：${dateFormat.format(date)}';
      }
      // 如果都没有，尝试使用createdAt
      final createdAt = merchant['createdAt'];
      if (createdAt != null) {
        DateTime date;
        if (createdAt is String) {
          date = DateTime.parse(createdAt);
        } else if (createdAt is DateTime) {
          date = createdAt;
        } else {
          return '拒绝时间：--';
        }
        return '拒绝时间：${dateFormat.format(date)}';
      }
      return '拒绝时间：--';
    }
  }
}