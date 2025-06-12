import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/permission_management_provider.dart';

/// 权限历史记录对话框
class PermissionHistoryDialog extends ConsumerStatefulWidget {
  final String? userId;

  const PermissionHistoryDialog({
    super.key,
    this.userId,
  });

  @override
  ConsumerState<PermissionHistoryDialog> createState() => _PermissionHistoryDialogState();
}

class _PermissionHistoryDialogState extends ConsumerState<PermissionHistoryDialog> {
  List<Map<String, dynamic>> _historyRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final records = await ref
          .read(permissionManagementProvider.notifier)
          .getPermissionHistory(userId: widget.userId);
      
      setState(() {
        _historyRecords = records;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.history),
          const SizedBox(width: 8),
          Text(widget.userId != null ? '用户权限历史' : '权限变更历史'),
        ],
      ),
      content: SizedBox(
        width: 600,
        height: 400,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _historyRecords.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '暂无历史记录',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _historyRecords.length,
                    itemBuilder: (context, index) {
                      final record = _historyRecords[index];
                      return _buildHistoryItem(record, dateFormat);
                    },
                  ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('关闭'),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> record, DateFormat dateFormat) {
    final theme = Theme.of(context);
    final action = record['action'] as String?;
    final permission = record['permission'] as String?;
    final isGrant = action == 'grant';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isGrant
                ? Colors.green.withOpacity(0.1)
                : Colors.orange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isGrant ? Icons.add_circle : Icons.remove_circle,
            color: isGrant ? Colors.green : Colors.orange,
          ),
        ),
        title: Row(
          children: [
            Text(
              isGrant ? '授予' : '撤销',
              style: TextStyle(
                color: isGrant ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(permission == 'merchant' ? '加盟商权限' : '营养师权限'),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (record['userName'] != null)
              Text('用户: ${record['userName']}'),
            if (record['operatorName'] != null)
              Text('操作人: ${record['operatorName']}'),
            if (record['reason'] != null)
              Text('原因: ${record['reason']}'),
            if (record['createdAt'] != null)
              Text(
                '时间: ${dateFormat.format(DateTime.parse(record['createdAt']))}',
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}