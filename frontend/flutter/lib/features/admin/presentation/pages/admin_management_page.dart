import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/admin_user_item.dart';
import '../providers/admin_management_provider.dart';

/// 管理员管理页面
/// 
/// 超级管理员可以对其他管理员进行增删改查
class AdminManagementPage extends ConsumerStatefulWidget {
  const AdminManagementPage({super.key});

  @override
  ConsumerState<AdminManagementPage> createState() => _AdminManagementPageState();
}

class _AdminManagementPageState extends ConsumerState<AdminManagementPage> {
  @override
  void initState() {
    super.initState();
    // 加载管理员列表
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminManagementProvider.notifier).loadAdminList();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminManagementProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('管理员管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddAdminDialog(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(adminManagementProvider.notifier).loadAdminList();
        },
        child: _buildBody(adminState),
      ),
    );
  }
  
  /// 构建主体内容
  Widget _buildBody(AdminManagementState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              state.error!,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(adminManagementProvider.notifier).loadAdminList();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }
    
    final admins = state.admins;
    
    if (admins.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.admin_panel_settings_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '暂无管理员',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showAddAdminDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('添加管理员'),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: admins.length,
      itemBuilder: (context, index) {
        final admin = admins[index];
        return AdminUserItem(
          admin: admin,
          onEdit: () => _showEditAdminDialog(context, admin),
          onDelete: () => _showDeleteConfirmDialog(context, admin),
        );
      },
    );
  }
  
  /// 显示添加管理员对话框
  void _showAddAdminDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _AddAdminDialog(
        onConfirm: (phone, nickname, role) async {
          await ref.read(adminManagementProvider.notifier).addAdmin(
            phone: phone,
            nickname: nickname,
            role: role,
          );
        },
      ),
    );
  }
  
  /// 显示编辑管理员对话框
  void _showEditAdminDialog(BuildContext context, Map<String, dynamic> admin) {
    showDialog(
      context: context,
      builder: (context) => _EditAdminDialog(
        admin: admin,
        onConfirm: (nickname, role) async {
          await ref.read(adminManagementProvider.notifier).updateAdmin(
            adminId: admin['_id'],
            nickname: nickname,
            role: role,
          );
        },
      ),
    );
  }
  
  /// 显示删除确认对话框
  void _showDeleteConfirmDialog(BuildContext context, Map<String, dynamic> admin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除管理员 "${admin['nickname'] ?? admin['phone']}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(adminManagementProvider.notifier).deleteAdmin(admin['_id']);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}

/// 添加管理员对话框
class _AddAdminDialog extends StatefulWidget {
  final Future<void> Function(String phone, String nickname, String role) onConfirm;
  
  const _AddAdminDialog({required this.onConfirm});
  
  @override
  State<_AddAdminDialog> createState() => _AddAdminDialogState();
}

class _AddAdminDialogState extends State<_AddAdminDialog> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nicknameController = TextEditingController();
  String _selectedRole = 'admin';
  bool _isLoading = false;
  
  @override
  void dispose() {
    _phoneController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加管理员'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: '手机号',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入手机号';
                }
                if (value.length != 11) {
                  return '请输入正确的手机号';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: '昵称',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入昵称';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: '角色',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'admin', child: Text('管理员')),
                DropdownMenuItem(value: 'super_admin', child: Text('超级管理员')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRole = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleConfirm,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('确定'),
        ),
      ],
    );
  }
  
  Future<void> _handleConfirm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await widget.onConfirm(
        _phoneController.text,
        _nicknameController.text,
        _selectedRole,
      );
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('添加失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

/// 编辑管理员对话框
class _EditAdminDialog extends StatefulWidget {
  final Map<String, dynamic> admin;
  final Future<void> Function(String nickname, String role) onConfirm;
  
  const _EditAdminDialog({
    required this.admin,
    required this.onConfirm,
  });
  
  @override
  State<_EditAdminDialog> createState() => _EditAdminDialogState();
}

class _EditAdminDialogState extends State<_EditAdminDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nicknameController;
  late String _selectedRole;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.admin['nickname'] ?? '');
    _selectedRole = widget.admin['role'] ?? 'admin';
  }
  
  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('编辑管理员'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 显示手机号（不可编辑）
            TextFormField(
              initialValue: widget.admin['phone'],
              decoration: const InputDecoration(
                labelText: '手机号',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: '昵称',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入昵称';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: '角色',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'admin', child: Text('管理员')),
                DropdownMenuItem(value: 'super_admin', child: Text('超级管理员')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRole = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleConfirm,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('保存'),
        ),
      ],
    );
  }
  
  Future<void> _handleConfirm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await widget.onConfirm(
        _nicknameController.text,
        _selectedRole,
      );
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}