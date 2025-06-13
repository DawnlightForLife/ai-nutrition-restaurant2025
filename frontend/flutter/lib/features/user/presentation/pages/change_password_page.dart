import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_nutrition_restaurant/shared/utils/toast_util.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/password_provider.dart';

/// 修改密码页面
class ChangePasswordPage extends ConsumerStatefulWidget {
  /// 构造函数
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasPasswordAsync = ref.watch(hasPasswordProvider);
    final passwordManagerState = ref.watch(passwordManagerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录密码'),
        centerTitle: true,
      ),
      body: hasPasswordAsync.when(
        data: (hasPassword) {
          final isNewUser = !hasPassword;
          
          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 提示信息
                      if (isNewUser) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '您还未设置登录密码，设置密码后可使用手机号+密码登录',
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      
                      // 页面标题
                      Text(
                        isNewUser ? '设置登录密码' : '修改登录密码',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // 旧密码输入框（仅对已有密码的用户显示）
                      if (!isNewUser) ...[
                        _buildPasswordField(
                          controller: _oldPasswordController,
                          labelText: '当前密码',
                          isPasswordVisible: _isOldPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _isOldPasswordVisible = !_isOldPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // 新密码输入框
                      _buildPasswordField(
                        controller: _newPasswordController,
                        labelText: isNewUser ? '设置登录密码' : '新密码',
                        isPasswordVisible: _isNewPasswordVisible,
                        onToggleVisibility: () {
                          setState(() {
                            _isNewPasswordVisible = !_isNewPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      
                      // 密码强度提示
                      Text(
                        '密码长度6-20位，建议包含数字、字母、特殊字符',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // 确认密码输入框
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        labelText: '确认密码',
                        isPasswordVisible: _isConfirmPasswordVisible,
                        onToggleVisibility: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      
                      // 确认按钮
                      ElevatedButton(
                        onPressed: passwordManagerState.isLoading || _isLoading 
                            ? null 
                            : () => _handleChangePassword(isNewUser),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: passwordManagerState.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(isNewUser ? '设置密码' : '修改密码'),
                      ),
                    ],
                  ),
                ),
                // 加载状态
                if (_isLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('加载失败'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(hasPasswordProvider),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool isPasswordVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }

  void _handleChangePassword(bool isNewUser) async {
    // 表单验证
    if (_newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ToastUtil.showError(context, '请填写所有字段');
      return;
    }

    // 对于已有密码的用户，需要验证旧密码
    if (!isNewUser && _oldPasswordController.text.isEmpty) {
      ToastUtil.showError(context, '请输入当前密码');
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ToastUtil.showError(context, '两次输入的密码不一致');
      return;
    }

    // 密码强度验证
    if (_newPasswordController.text.length < 6) {
      ToastUtil.showError(context, '密码长度至少6位');
      return;
    }

    // 调用Provider方法
    final passwordManager = ref.read(passwordManagerProvider.notifier);
    bool success;
    
    if (isNewUser) {
      success = await passwordManager.setPassword(_newPasswordController.text);
    } else {
      success = await passwordManager.changePassword(
        _oldPasswordController.text,
        _newPasswordController.text,
      );
    }

    if (success && mounted) {
      // 显示成功提示
      ToastUtil.showSuccess(
        context, 
        isNewUser ? '密码设置成功！' : '密码修改成功！'
      );
      
      // 刷新密码状态
      ref.refresh(hasPasswordProvider);
      
      // 返回上一页
      Navigator.pop(context);
    } else if (mounted) {
      // 显示错误信息
      final error = ref.read(passwordManagerProvider).error;
      ToastUtil.showError(
        context,
        error?.toString() ?? '操作失败，请重试',
      );
    }
  }
} 