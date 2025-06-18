import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/permission_management_provider.dart';
import '../widgets/permission_stats_card.dart';
import '../widgets/user_search_dialog.dart';
import '../widgets/permission_history_dialog.dart';

/// 权限管理页面 - 管理员授权模式
class PermissionManagementPage extends ConsumerStatefulWidget {
  const PermissionManagementPage({super.key});

  static const String routeName = '/admin/permission-management';

  @override
  ConsumerState<PermissionManagementPage> createState() => _PermissionManagementPageState();
}

class _PermissionManagementPageState extends ConsumerState<PermissionManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _filterPermission = 'all'; // all, merchant, nutritionist

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // 初始化时加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(permissionManagementProvider.notifier).loadAuthorizedUsers();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(permissionManagementProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('权限管理'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '权限授权'),
            Tab(text: '已授权用户'),
            Tab(text: '历史记录'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAuthorizationTab(),
          _buildAuthorizedUsersTab(state),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  /// 构建权限授权标签页
  Widget _buildAuthorizationTab() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 统计卡片
          _buildStatsSection(),
          const SizedBox(height: 24),
          
          // 授权操作区
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '快速授权',
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '搜索用户并授予相应权限',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 授权按钮组
                  Row(
                    children: [
                      Expanded(
                        child: _buildAuthorizationButton(
                          context,
                          icon: Icons.store,
                          title: '授权加盟商',
                          subtitle: '授予商家管理权限',
                          color: Colors.orange,
                          onTap: () => _showUserSearchDialog('merchant'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAuthorizationButton(
                          context,
                          icon: Icons.medical_services,
                          title: '授权营养师',
                          subtitle: '授予营养师权限',
                          color: Colors.green,
                          onTap: () => _showUserSearchDialog('nutritionist'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // 使用提示
          Card(
            color: theme.colorScheme.primaryContainer.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '使用说明',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. 点击授权按钮，搜索要授权的用户\n'
                    '2. 确认用户信息后，点击授权\n'
                    '3. 用户将立即获得相应权限\n'
                    '4. 在"已授权用户"标签页管理权限',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建已授权用户标签页
  Widget _buildAuthorizedUsersTab(PermissionManagementState state) {
    final theme = Theme.of(context);
    
    if (state.isLoading && state.authorizedUsers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    final filteredUsers = state.authorizedUsers.where((user) {
      // 搜索过滤
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesSearch = user.nickname.toLowerCase().contains(query) ||
            user.phone.contains(query) ||
            (user.realName?.toLowerCase().contains(query) ?? false);
        if (!matchesSearch) return false;
      }
      
      // 权限类型过滤已在后端处理，这里不再重复过滤
      return true;
    }).toList();
    
    return Column(
      children: [
        // 搜索和过滤栏
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '搜索用户（姓名、手机号）',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _filterPermission,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('全部')),
                  DropdownMenuItem(value: 'merchant', child: Text('加盟商')),
                  DropdownMenuItem(value: 'nutritionist', child: Text('营养师')),
                ],
                onChanged: (value) {
                  setState(() {
                    _filterPermission = value!;
                  });
                  // 重新加载用户列表
                  ref.read(permissionManagementProvider.notifier).loadAuthorizedUsers(
                    permissionFilter: value == 'all' ? null : value,
                  );
                },
              ),
            ],
          ),
        ),
        
        // 用户列表
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(permissionManagementProvider.notifier).loadAuthorizedUsers();
            },
            child: filteredUsers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_off,
                          size: 64,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty ? '没有找到匹配的用户' : '暂无已授权用户',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return _buildUserCard(user);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  /// 构建历史记录标签页
  Widget _buildHistoryTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ref.read(permissionManagementProvider.notifier).getPermissionHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('加载历史记录失败'),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() {}), // 重新构建触发重新加载
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }
        
        final historyRecords = snapshot.data ?? [];
        
        if (historyRecords.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('暂无历史记录'),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: historyRecords.length,
          itemBuilder: (context, index) {
            final record = historyRecords[index];
            return _buildHistoryItem(record);
          },
        );
      },
    );
  }
  
  /// 构建历史记录项
  Widget _buildHistoryItem(Map<String, dynamic> record) {
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
                '时间: ${_formatDateTime(record['createdAt'])}',
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
  
  /// 格式化时间
  String _formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeStr;
    }
  }

  /// 构建统计卡片区域
  Widget _buildStatsSection() {
    final state = ref.watch(permissionManagementProvider);
    
    return Row(
      children: [
        Expanded(
          child: PermissionStatsCard(
            title: '加盟商总数',
            count: state.stats.merchantCount,
            icon: Icons.store,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PermissionStatsCard(
            title: '营养师总数',
            count: state.stats.nutritionistCount,
            icon: Icons.medical_services,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PermissionStatsCard(
            title: '本月新增',
            count: state.stats.monthlyNewCount,
            icon: Icons.trending_up,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  /// 构建授权按钮
  Widget _buildAuthorizationButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建用户卡片
  Widget _buildUserCard(AuthorizedUser user) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            user.nickname.isNotEmpty ? user.nickname[0].toUpperCase() : '?',
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(user.nickname),
            const SizedBox(width: 8),
            if (user.realName != null) ...[
              Text(
                '(${user.realName})',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('手机：${user.phone}'),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: user.permissions.map((permission) {
                final isMerchant = permission == 'merchant';
                return Chip(
                  label: Text(
                    isMerchant ? '加盟商' : '营养师',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: isMerchant
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.green.withOpacity(0.2),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          itemBuilder: (context) => [
            if (user.permissions.contains('merchant'))
              const PopupMenuItem(
                value: 'revoke_merchant',
                child: Text('撤销加盟商权限'),
              ),
            if (user.permissions.contains('nutritionist'))
              const PopupMenuItem(
                value: 'revoke_nutritionist',
                child: Text('撤销营养师权限'),
              ),
            if (!user.permissions.contains('merchant'))
              const PopupMenuItem(
                value: 'grant_merchant',
                child: Text('授予加盟商权限'),
              ),
            if (!user.permissions.contains('nutritionist'))
              const PopupMenuItem(
                value: 'grant_nutritionist',
                child: Text('授予营养师权限'),
              ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'history',
              child: Text('查看历史记录'),
            ),
          ],
          onSelected: (value) => _handleUserAction(value, user),
        ),
      ),
    );
  }

  /// 显示用户搜索对话框
  void _showUserSearchDialog(String permissionType) {
    showDialog(
      context: context,
      builder: (context) => UserSearchDialog(
        permissionType: permissionType,
        onUserSelected: (userId) async {
          // 先关闭对话框
          Navigator.of(context).pop();
          
          // 授权用户
          final success = await ref
              .read(permissionManagementProvider.notifier)
              .grantPermission(userId, permissionType);
          
          // 使用页面的 context 显示结果
          if (mounted && this.context.mounted) {
            _showPermissionFeedback(
              success: success,
              action: '授权',
              permissionType: permissionType,
              errorMessage: success ? null : ref.read(permissionManagementProvider).error,
            );
          }
        },
      ),
    );
  }

  /// 显示历史记录对话框
  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => const PermissionHistoryDialog(),
    );
  }

  /// 处理用户操作
  void _handleUserAction(String action, AuthorizedUser user) async {
    switch (action) {
      case 'revoke_merchant':
        _confirmRevoke(user, 'merchant');
        break;
      case 'revoke_nutritionist':
        _confirmRevoke(user, 'nutritionist');
        break;
      case 'grant_merchant':
        _confirmGrant(user, 'merchant');
        break;
      case 'grant_nutritionist':
        _confirmGrant(user, 'nutritionist');
        break;
      case 'history':
        _showUserHistory(user);
        break;
    }
  }

  /// 确认撤销权限
  void _confirmRevoke(AuthorizedUser user, String permissionType) {
    final permissionName = permissionType == 'merchant' ? '加盟商' : '营养师';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认撤销权限'),
        content: Text('确定要撤销 ${user.nickname} 的$permissionName权限吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final success = await ref
                  .read(permissionManagementProvider.notifier)
                  .revokePermission(user.id, permissionType);
              
              if (mounted) {
                _showPermissionFeedback(
                  success: success,
                  action: '撤销',
                  permissionType: permissionType,
                  errorMessage: success ? null : ref.read(permissionManagementProvider).error,
                );
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 确认授予权限
  void _confirmGrant(AuthorizedUser user, String permissionType) async {
    final success = await ref
        .read(permissionManagementProvider.notifier)
        .grantPermission(user.id, permissionType);
    
    if (mounted) {
      _showPermissionFeedback(
        success: success,
        action: '授权',
        permissionType: permissionType,
        errorMessage: success ? null : ref.read(permissionManagementProvider).error,
      );
    }
  }

  /// 显示用户历史记录
  void _showUserHistory(AuthorizedUser user) {
    showDialog(
      context: context,
      builder: (context) => PermissionHistoryDialog(userId: user.id),
    );
  }

  /// 显示权限操作反馈
  void _showPermissionFeedback({
    required bool success,
    required String action,
    required String permissionType,
    String? errorMessage,
  }) {
    final permissionName = permissionType == 'merchant' ? '商家' : '营养师';
    final theme = Theme.of(context);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.onInverseSurface,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text('${permissionName}权限${action}成功'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error,
                color: theme.colorScheme.onError,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  errorMessage ?? '${permissionName}权限${action}失败',
                ),
              ),
            ],
          ),
          backgroundColor: theme.colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}