import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// 管理员二次验证页面
/// 
/// 用于管理员进入后台前的安全验证
class AdminVerificationPage extends ConsumerStatefulWidget {
  const AdminVerificationPage({super.key});

  @override
  ConsumerState<AdminVerificationPage> createState() => _AdminVerificationPageState();
}

class _AdminVerificationPageState extends ConsumerState<AdminVerificationPage> {
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  
  // 验证方式：password 或 otp
  String _verificationMethod = 'password';
  
  @override
  void dispose() {
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('管理员验证'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 说明文字
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.security,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '为确保账户安全，请完成身份验证',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // 用户信息
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: theme.colorScheme.primary,
                        child: const Icon(
                          Icons.admin_panel_settings,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        authState.user?.nickname ?? '管理员',
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        authState.user?.phone ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // 验证方式选择
                Row(
                  children: [
                    Expanded(
                      child: _buildVerificationMethodCard(
                        'password',
                        '密码验证',
                        Icons.lock,
                        theme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildVerificationMethodCard(
                        'otp',
                        '动态验证码',
                        Icons.message,
                        theme,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // 验证输入框
                if (_verificationMethod == 'password')
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: '管理员密码',
                      hintText: '请输入管理员密码',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入密码';
                      }
                      if (value.length < 6) {
                        return '密码长度不能少于6位';
                      }
                      return null;
                    },
                  )
                else
                  Column(
                    children: [
                      TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          labelText: '验证码',
                          hintText: '请输入6位验证码',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入验证码';
                          }
                          if (value.length != 6) {
                            return '请输入6位验证码';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _sendOtp,
                          child: const Text('发送验证码'),
                        ),
                      ),
                    ],
                  ),
                
                // 错误提示
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 14,
                      ),
                    ),
                  ),
                
                const Spacer(),
                
                // 验证按钮
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleVerification,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('验证身份'),
                  ),
                ),
                const SizedBox(height: 16),
                
                // 安全提示
                Text(
                  '提示：此操作将记录在安全日志中',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// 构建验证方式选择卡片
  Widget _buildVerificationMethodCard(
    String method,
    String label,
    IconData icon,
    ThemeData theme,
  ) {
    final isSelected = _verificationMethod == method;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _verificationMethod = method;
          _errorMessage = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w500 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 发送验证码
  Future<void> _sendOtp() async {
    // TODO: 实现发送验证码逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('验证码已发送')),
    );
  }
  
  /// 处理验证
  Future<void> _handleVerification() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final authState = ref.read(authStateProvider);
      
      // 检查是否是管理员
      if (authState.user?.role != 'admin' && authState.user?.role != 'super_admin') {
        setState(() {
          _errorMessage = '您没有管理员权限';
        });
        return;
      }
      
      // 模拟验证过程
      if (_verificationMethod == 'password') {
        // 这里应该调用后端API验证密码
        // 暂时使用硬编码密码进行演示
        if (_passwordController.text != 'admin123') {
          setState(() {
            _errorMessage = '密码错误';
          });
          return;
        }
      } else {
        // 验证码验证
        if (_otpController.text != '123456') {
          setState(() {
            _errorMessage = '验证码错误';
          });
          return;
        }
      }
      
      // 验证成功，跳转到管理后台
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/admin/dashboard');
      }
    } catch (e) {
      setState(() {
        _errorMessage = '验证失败，请重试';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}