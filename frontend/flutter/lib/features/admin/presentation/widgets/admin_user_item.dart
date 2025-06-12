import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 管理员用户列表项
class AdminUserItem extends StatelessWidget {
  final Map<String, dynamic> admin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  
  const AdminUserItem({
    Key? key,
    required this.admin,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: _getRoleColor(admin['role']),
          child: Text(
            (admin['nickname'] ?? admin['phone'] ?? '?')[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              admin['nickname'] ?? '未设置昵称',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            _buildRoleChip(admin['role']),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.phone,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  admin['phone'] ?? '未知',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '创建时间: ${_formatDate(admin['createdAt'] ?? admin['created_at'])}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: _buildActions(context),
      ),
    );
  }
  
  /// 构建角色标签
  Widget _buildRoleChip(String? role) {
    String roleText;
    Color roleColor;
    
    switch (role) {
      case 'super_admin':
        roleText = '超级管理员';
        roleColor = Colors.red;
        break;
      case 'admin':
        roleText = '管理员';
        roleColor = Colors.orange;
        break;
      default:
        roleText = '未知角色';
        roleColor = Colors.grey;
    }
    
    return Chip(
      label: Text(
        roleText,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
      backgroundColor: roleColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
  
  /// 获取角色对应的颜色
  Color _getRoleColor(String? role) {
    switch (role) {
      case 'super_admin':
        return Colors.red;
      case 'admin':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  /// 格式化日期
  String _formatDate(dynamic date) {
    if (date == null) return '未知';
    
    try {
      DateTime dateTime;
      if (date is String) {
        dateTime = DateTime.parse(date);
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return '未知';
      }
      
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      return '未知';
    }
  }
  
  /// 构建操作按钮
  Widget _buildActions(BuildContext context) {
    // 超级管理员不能被编辑或删除
    if (admin['role'] == 'super_admin' && admin['phone'] == '15108343625') {
      return const SizedBox.shrink();
    }
    
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 20),
              SizedBox(width: 8),
              Text('编辑'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 20, color: Colors.red),
              SizedBox(width: 8),
              Text('删除', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}