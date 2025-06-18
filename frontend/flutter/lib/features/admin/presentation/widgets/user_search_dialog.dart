import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/permission_management_provider.dart';

/// 用户搜索对话框
class UserSearchDialog extends ConsumerStatefulWidget {
  final String permissionType;
  final Function(String userId) onUserSelected;

  const UserSearchDialog({
    super.key,
    required this.permissionType,
    required this.onUserSelected,
  });

  @override
  ConsumerState<UserSearchDialog> createState() => _UserSearchDialogState();
}

class _UserSearchDialogState extends ConsumerState<UserSearchDialog> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  String? _selectedUserId;

  @override
  void initState() {
    super.initState();
    // 初始化时加载所有用户
    _loadAllUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllUsers() async {
    setState(() {
      _isSearching = true;
    });

    try {
      final results = await ref
          .read(permissionManagementProvider.notifier)
          .getAllUsers();
      
      // 过滤掉已有相应权限的用户
      final filteredResults = results.where((user) {
        final permissions = _extractPermissions(user);
        return !permissions.contains(widget.permissionType);
      }).toList();

      setState(() {
        _searchResults = filteredResults;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      // 如果搜索框为空，重新加载所有用户
      _loadAllUsers();
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await ref
          .read(permissionManagementProvider.notifier)
          .searchUsers(query);
      
      // 过滤掉已有相应权限的用户
      final filteredResults = results.where((user) {
        final permissions = _extractPermissions(user);
        return !permissions.contains(widget.permissionType);
      }).toList();

      setState(() {
        _searchResults = filteredResults;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('搜索失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<String> _extractPermissions(Map<String, dynamic> user) {
    final permissions = <String>[];
    
    // 检查role字段
    final role = user['role'] as String?;
    if (role == 'merchant' || role == 'merchant_admin') {
      permissions.add('merchant');
    }
    if (role == 'nutritionist') {
      permissions.add('nutritionist');
    }
    
    // 检查permissions字段
    if (user['permissions'] is List) {
      for (final permission in user['permissions']) {
        if (permission is String && !permissions.contains(permission)) {
          permissions.add(permission);
        }
      }
    }
    
    return permissions;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final permissionName = widget.permissionType == 'merchant' ? '加盟商' : '营养师';
    
    return AlertDialog(
      title: Text('授权$permissionName权限'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 搜索框
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '输入手机号或用户名搜索',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults = [];
                          });
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                // 输入内容变化时立即搜索，不再限制最小长度
                _performSearch(value);
              },
            ),
            const SizedBox(height: 16),
            
            // 搜索结果
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: _searchResults.isEmpty
                  ? Center(
                      child: Text(
                        _isSearching
                            ? '加载中...'
                            : '未找到符合条件的用户',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final user = _searchResults[index];
                        final userId = user['_id'] ?? user['id'] ?? '';
                        final isSelected = _selectedUserId == userId;
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: RadioListTile<String>(
                            value: userId,
                            groupValue: _selectedUserId,
                            onChanged: (value) {
                              setState(() {
                                _selectedUserId = value;
                              });
                            },
                            title: Text(user['nickname'] ?? '未知用户'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('手机: ${user['phone'] ?? '未知'}'),
                                if (user['realName'] != null)
                                  Text('姓名: ${user['realName']}'),
                              ],
                            ),
                            secondary: CircleAvatar(
                              backgroundColor: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.surfaceVariant,
                              child: Text(
                                (user['nickname'] ?? '?')[0].toUpperCase(),
                                style: TextStyle(
                                  color: isSelected
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: _selectedUserId == null
              ? null
              : () {
                  Navigator.pop(context);
                  widget.onUserSelected(_selectedUserId!);
                },
          child: const Text('确认授权'),
        ),
      ],
    );
  }
}