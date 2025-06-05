import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 管理员用户列表项
class AdminUserItem extends StatelessWidget {
  final Map<String, dynamic> admin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  
  const AdminUserItem({
    super.key,
    required this.admin,
    this.onEdit,
    this.onDelete,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 用户基本信息
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 用户头像
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getRoleColor(admin['role']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    _getRoleIcon(admin['role']),
                    color: _getRoleColor(admin['role']),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                
                // 用户信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              admin['nickname'] ?? admin['phone'],
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildRoleBadge(context),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        admin['phone'] ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getCreatedAtText(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 操作按钮
                if (_canEdit())
                  PopupMenuButton<String>(
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
                      if (_canDelete())
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
                  ),
              ],
            ),
            
            // 权限说明
            if (admin['role'] == 'super_admin') ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security,
                      size: 16,
                      color: Colors.purple[700],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '拥有最高权限，可以管理所有管理员和系统设置',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.purple[700],
                        ),
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
  
  /// 构建角色徽章
  Widget _buildRoleBadge(BuildContext context) {
    final role = admin['role'] ?? 'user';
    final color = _getRoleColor(role);
    final text = _getRoleText(role);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  /// 获取角色颜色
  Color _getRoleColor(String? role) {
    switch (role) {
      case 'super_admin':
        return Colors.purple;
      case 'admin':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
  
  /// 获取角色图标
  IconData _getRoleIcon(String? role) {
    switch (role) {
      case 'super_admin':
        return Icons.admin_panel_settings;
      case 'admin':
        return Icons.manage_accounts;
      default:
        return Icons.person;
    }
  }
  
  /// 获取角色文本
  String _getRoleText(String? role) {
    switch (role) {
      case 'super_admin':
        return '超级管理员';
      case 'admin':
        return '管理员';
      default:
        return '用户';
    }
  }
  
  /// 获取创建时间文本
  String _getCreatedAtText() {
    final createdAt = admin['createdAt'];
    if (createdAt == null) return '';
    
    try {
      final date = DateTime.parse(createdAt);
      final formatter = DateFormat('yyyy-MM-dd HH:mm');
      return '创建时间：${formatter.format(date)}';
    } catch (e) {
      return '';
    }
  }
  
  /// 是否可以编辑
  bool _canEdit() {
    // TODO: 根据当前用户权限判断
    return true;
  }
  
  /// 是否可以删除
  bool _canDelete() {
    // 超级管理员不能删除自己
    // TODO: 根据当前用户ID判断
    return admin['role'] != 'super_admin';
  }
}