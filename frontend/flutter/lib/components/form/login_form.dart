import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 登录表单组件
///
/// 根据登录方式展示不同的登录表单，支持验证码登录和密码登录
class LoginForm extends StatefulWidget {
  final bool isCodeLogin;
  final TextEditingController phoneController;
  final TextEditingController codeController;
  final TextEditingController passwordController;
  final Function(String) onSendCode;
  final ValueChanged<bool> onSubmit;
  final String? phoneErrorText;
  final String? codeErrorText;
  final String? passwordErrorText;
  final int codeCooldown;

  const LoginForm({
    Key? key,
    required this.isCodeLogin,
    required this.phoneController,
    required this.codeController,
    required this.passwordController,
    required this.onSendCode,
    required this.onSubmit,
    this.phoneErrorText,
    this.codeErrorText,
    this.passwordErrorText,
    this.codeCooldown = 0,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  int _countdown = 0;
  Timer? _timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _countdown = widget.codeCooldown;
    if (_countdown > 0) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(LoginForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.codeCooldown != oldWidget.codeCooldown && widget.codeCooldown > 0) {
      _countdown = widget.codeCooldown;
      if (_countdown > 0 && _timer == null) {
        _startTimer();
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        _timer = null;
      }
    });
  }

  /// 处理发送验证码
  Future<void> _handleSendCode() async {
    // 手机号码校验
    final phone = widget.phoneController.text.trim();
    if (phone.isEmpty) {
      return;
    }

    if (_countdown > 0) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onSendCode(phone);
      setState(() {
        _countdown = 60;
      });
      _startTimer();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 手机号输入框
        _buildPhoneInput(),
        const SizedBox(height: 16),
        
        // 密码/验证码输入框
        widget.isCodeLogin ? _buildCodeInput() : _buildPasswordInput(),
        
        const SizedBox(height: 32),
        
        // 登录按钮
        _buildLoginButton(),
      ],
    );
  }

  /// 构建手机号输入框
  Widget _buildPhoneInput() {
    return TextFormField(
      controller: widget.phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: '手机号',
        hintText: '请输入手机号',
        prefixText: '+86  ',
        prefixStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        errorText: widget.phoneErrorText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(11),
        FilteringTextInputFormatter.digitsOnly,
      ],
      textInputAction: TextInputAction.next,
    );
  }

  /// 构建验证码输入框
  Widget _buildCodeInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 验证码输入框
        Expanded(
          child: TextFormField(
            controller: widget.codeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '验证码',
              hintText: '请输入验证码',
              errorText: widget.codeErrorText,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(6),
              FilteringTextInputFormatter.digitsOnly,
            ],
            textInputAction: TextInputAction.done,
          ),
        ),
        
        const SizedBox(width: 16),
        
        // 获取验证码按钮
        SizedBox(
          height: 56,
          width: 120,
          child: ElevatedButton(
            onPressed: _countdown > 0 || _isLoading
                ? null
                : () => _handleSendCode(),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              disabledForegroundColor: Colors.white60,
              disabledBackgroundColor: Colors.grey.withOpacity(0.3),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(_countdown > 0 ? '${_countdown}s后重发' : '获取验证码'),
          ),
        ),
      ],
    );
  }

  /// 构建密码输入框
  Widget _buildPasswordInput() {
    return TextFormField(
      controller: widget.passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: '密码',
        hintText: '请输入密码',
        errorText: widget.passwordErrorText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      textInputAction: TextInputAction.done,
    );
  }

  /// 构建登录按钮
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => widget.onSubmit(widget.isCodeLogin),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          '登 录',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
} 