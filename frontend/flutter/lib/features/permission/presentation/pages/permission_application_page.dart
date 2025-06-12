import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_permission_provider.dart';
import '../../data/models/user_permission_model.dart';

class PermissionApplicationPage extends ConsumerStatefulWidget {
  final PermissionType permissionType;

  const PermissionApplicationPage({
    super.key,
    required this.permissionType,
  });

  static const String routeName = '/permission-application';

  @override
  ConsumerState<PermissionApplicationPage> createState() => _PermissionApplicationPageState();
}

class _PermissionApplicationPageState extends ConsumerState<PermissionApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _qualificationsController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _wechatController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _qualificationsController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _wechatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final applicationState = ref.watch(permissionApplicationProvider);
    final isNutritionist = widget.permissionType == PermissionType.nutritionist;

    // 监听申请状态
    ref.listen<AsyncValue<UserPermissionModel?>>(
      permissionApplicationProvider,
      (previous, next) {
        next.whenOrNull(
          data: (permission) {
            if (permission != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('权限申请已提交，请等待审核'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
            }
          },
          error: (error, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('申请失败: $error'),
                backgroundColor: Colors.red,
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('申请${widget.permissionType.displayName}'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 说明卡片
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '申请说明',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isNutritionist
                            ? '申请营养师权限需要提供相关资质证明，审核通过后您将能够为用户提供专业的营养咨询服务。'
                            : '申请商家权限需要提供营业资质证明，审核通过后您将能够发布菜品、管理店铺等。',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 申请原因
              Text(
                '申请原因 *',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: isNutritionist
                      ? '请说明您申请营养师权限的原因，如工作背景、专业经验等'
                      : '请说明您申请商家权限的原因，如经营计划、店铺类型等',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请填写申请原因';
                  }
                  if (value.trim().length < 10) {
                    return '申请原因至少需要10个字符';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 资质描述
              Text(
                '资质描述',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _qualificationsController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: isNutritionist
                      ? '请描述您的教育背景、执业资格、工作经验等（可选）'
                      : '请描述您的营业执照、经营许可等资质情况（可选）',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 联系方式
              Text(
                '联系方式',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: '手机号码',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '邮箱地址',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _wechatController,
                decoration: const InputDecoration(
                  labelText: '微信号',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.chat),
                ),
              ),
              const SizedBox(height: 24),

              // 提示信息
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.primaryContainer,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '提交申请后，我们将在1-3个工作日内完成审核，请保持联系方式畅通。',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 提交按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: applicationState.isLoading ? null : _submitApplication,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: applicationState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('提交申请'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitApplication() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final contactInfo = <String, String>{};
    if (_phoneController.text.trim().isNotEmpty) {
      contactInfo['phone'] = _phoneController.text.trim();
    }
    if (_emailController.text.trim().isNotEmpty) {
      contactInfo['email'] = _emailController.text.trim();
    }
    if (_wechatController.text.trim().isNotEmpty) {
      contactInfo['wechat'] = _wechatController.text.trim();
    }

    ref.read(permissionApplicationProvider.notifier).applyPermission(
          permissionType: widget.permissionType.name,
          reason: _reasonController.text.trim(),
          contactInfo: contactInfo.isNotEmpty ? contactInfo : null,
          qualifications: _qualificationsController.text.trim().isNotEmpty
              ? _qualificationsController.text.trim()
              : null,
        );
  }
}