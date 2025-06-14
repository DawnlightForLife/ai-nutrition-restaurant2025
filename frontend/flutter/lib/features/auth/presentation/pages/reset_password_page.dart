import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../../theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../../../../shared/widgets/common/toast.dart';
import '../../../../routes/app_navigator.dart';

/// 找回密码页面
class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isCodeSent = false;
  int _countdown = 0;
  Timer? _countdownTimer;
  
  // 国家/地区代码
  String _countryCode = '+86';
  final List<Map<String, String>> _countryCodes = [
    {'code': '+86', 'name': '中国大陆'},
    {'code': '+852', 'name': '中国香港'},
    {'code': '+853', 'name': '中国澳门'},
    {'code': '+886', 'name': '中国台湾'},
  ];

  @override
  void initState() {
    super.initState();
    // 添加监听器
    _phoneController.addListener(() => setState(() {}));
    _codeController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '找回密码',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  // 说明文字
                  Text(
                    '请输入您的手机号，我们将发送验证码到您的手机',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // 手机号输入框
                  _buildPhoneField(),
                  const SizedBox(height: 16),
                  
                  // 验证码输入框
                  _buildCodeField(),
                  const SizedBox(height: 16),
                  
                  // 新密码输入框
                  _buildPasswordField(),
                  const SizedBox(height: 16),
                  
                  // 确认密码输入框
                  _buildConfirmPasswordField(),
                  const SizedBox(height: 32),
                  
                  // 重置密码按钮
                  _buildResetButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 国家/地区选择
          InkWell(
            onTap: _showCountryCodePicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    _countryCode,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 1,
            height: 24,
            color: AppColors.divider,
          ),
          // 手机号输入
          Expanded(
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              decoration: const InputDecoration(
                hintText: '请输入手机号',
                hintStyle: TextStyle(color: AppColors.textHint),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
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
          ),
        ],
      ),
    );
  }
  
  Widget _buildCodeField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: const InputDecoration(
                hintText: '请输入验证码',
                hintStyle: TextStyle(color: AppColors.textHint),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入验证码';
                }
                if (value.length != 6) {
                  return '验证码为6位数字';
                }
                return null;
              },
            ),
          ),
          // 发送验证码按钮
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _canSendCode() ? _sendCode : null,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                _countdown > 0 ? '$_countdown秒后重试' : '发送验证码',
                style: TextStyle(
                  color: _canSendCode() ? AppColors.primaryOrange : AppColors.textHint,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_showPassword,
        decoration: InputDecoration(
          hintText: '请输入新密码',
          hintStyle: const TextStyle(color: AppColors.textHint),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility : Icons.visibility_off,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '请输入新密码';
          }
          if (value.length < 6) {
            return '密码至少6位';
          }
          return null;
        },
      ),
    );
  }
  
  Widget _buildConfirmPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: _confirmPasswordController,
        obscureText: !_showConfirmPassword,
        decoration: InputDecoration(
          hintText: '请确认新密码',
          hintStyle: const TextStyle(color: AppColors.textHint),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: IconButton(
            icon: Icon(
              _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _showConfirmPassword = !_showConfirmPassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '请确认新密码';
          }
          if (value != _passwordController.text) {
            return '两次输入的密码不一致';
          }
          return null;
        },
      ),
    );
  }
  
  Widget _buildResetButton() {
    final bool isFormValid = _phoneController.text.length == 11 &&
        _codeController.text.length == 6 &&
        _passwordController.text.length >= 6 &&
        _confirmPasswordController.text == _passwordController.text;
        
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: isFormValid ? AppColors.buttonGradient : null,
        color: isFormValid ? null : AppColors.divider,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ElevatedButton(
        onPressed: isFormValid ? _handleReset : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          '重置密码',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isFormValid ? Colors.white : AppColors.textHint,
          ),
        ),
      ),
    );
  }
  
  bool _canSendCode() {
    return _phoneController.text.length == 11 && _countdown == 0;
  }
  
  void _startCountdown() {
    setState(() {
      _countdown = 60;
    });
    
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }
  
  void _showCountryCodePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                '选择国家/地区',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Divider(height: 1),
            ...List.generate(_countryCodes.length, (index) {
              final country = _countryCodes[index];
              return ListTile(
                title: Text(country['name']!),
                trailing: Text(
                  country['code']!,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                onTap: () {
                  setState(() {
                    _countryCode = country['code']!;
                  });
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
  
  void _sendCode() async {
    if (!_canSendCode()) return;
    
    try {
      final authNotifier = ref.read(authStateProvider.notifier);
      // 发送重置密码验证码
      final success = await authNotifier.sendPasswordResetCode(_phoneController.text);
      
      if (success && mounted) {
        Toast.success(context, '验证码已发送');
        _startCountdown();
        setState(() {
          _isCodeSent = true;
        });
      }
    } catch (e) {
      if (mounted) {
        Toast.error(context, '发送验证码失败：${e.toString()}');
      }
    }
  }
  
  void _handleReset() async {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      final authNotifier = ref.read(authStateProvider.notifier);
      final success = await authNotifier.resetPassword(
        _phoneController.text,
        _codeController.text,
        _passwordController.text,
      );
      
      if (success && mounted) {
        Toast.success(context, '密码重置成功，请重新登录');
        AppNavigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        Toast.error(context, '重置密码失败：${e.toString()}');
      }
    }
  }
}