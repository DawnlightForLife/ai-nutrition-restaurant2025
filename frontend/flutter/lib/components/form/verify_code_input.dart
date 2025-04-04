import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 验证码输入框组件
///
/// 集成了验证码输入框、发送按钮、倒计时功能
class VerifyCodeInput extends StatefulWidget {
  /// 手机号获取函数，用于在发送验证码时获取当前手机号
  final String Function() getPhone;
  
  /// 发送验证码的回调函数
  final Future<bool> Function(String phone) onSendCode;
  
  /// 验证码输入控制器
  final TextEditingController controller;
  
  /// 验证码输入框错误提示文本
  final String? errorText;
  
  /// 验证码输入框提示文本
  final String hintText;
  
  /// 验证码长度
  final int codeLength;
  
  /// 冷却时间（秒）
  final int cooldownSeconds;
  
  /// 已存在的倒计时时间（用于页面重建时保持倒计时）
  final int? existingCooldown;

  const VerifyCodeInput({
    Key? key,
    required this.getPhone,
    required this.onSendCode,
    required this.controller,
    this.errorText,
    this.hintText = '请输入验证码',
    this.codeLength = 6,
    this.cooldownSeconds = 60,
    this.existingCooldown,
  }) : super(key: key);

  @override
  State<VerifyCodeInput> createState() => _VerifyCodeInputState();
}

class _VerifyCodeInputState extends State<VerifyCodeInput> {
  /// 倒计时剩余秒数
  int _countdown = 0;
  
  /// 倒计时定时器
  Timer? _timer;
  
  /// 是否正在发送验证码
  bool _isSending = false;
  
  /// 是否已发送验证码
  bool _hasSent = false;

  @override
  void initState() {
    super.initState();
    // 如果有已存在的倒计时，则初始化倒计时
    if (widget.existingCooldown != null && widget.existingCooldown! > 0) {
      _countdown = widget.existingCooldown!;
      _hasSent = true;
      _startTimer();
    }
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  /// 开始倒计时
  void _startTimer() {
    _cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _cancelTimer();
        }
      });
    });
  }

  /// 取消倒计时
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// 处理发送验证码
  Future<void> _handleSendCode() async {
    // 如果正在发送或倒计时中，则不处理
    if (_isSending || _countdown > 0) {
      return;
    }

    // 获取手机号
    final phone = widget.getPhone();
    if (phone.isEmpty) {
      // 手机号为空，可以在界面上提示用户
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先输入手机号')),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // 调用发送验证码接口
      final success = await widget.onSendCode(phone);
      
      if (success && mounted) {
        setState(() {
          _hasSent = true;
          _countdown = widget.cooldownSeconds;
          _startTimer();
        });
      }
    } catch (e) {
      // 发送失败，可以在界面上提示用户
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('发送验证码失败: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 验证码输入框
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '验证码',
              hintText: widget.hintText,
              errorText: widget.errorText,
              prefixIcon: const Icon(Icons.lock_outline),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.codeLength),
              FilteringTextInputFormatter.digitsOnly,
            ],
            maxLength: widget.codeLength,
            buildCounter: (
              BuildContext context, {
              required int currentLength,
              required bool isFocused,
              required int? maxLength,
            }) => null, // 不显示字符计数器
            textInputAction: TextInputAction.done,
          ),
        ),

        const SizedBox(width: 16),
        
        // 发送验证码按钮
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _isSending || _countdown > 0 ? null : _handleSendCode,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              disabledForegroundColor: Colors.white60,
              disabledBackgroundColor: Colors.grey.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: _buildButtonChild(),
          ),
        ),
      ],
    );
  }

  /// 构建按钮内容
  Widget _buildButtonChild() {
    if (_isSending) {
      // 发送中显示加载动画
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      );
    } else if (_countdown > 0) {
      // 倒计时状态
      return Text('${_countdown}s后重发');
    } else if (_hasSent) {
      // 已发送状态
      return const Text('重新发送');
    } else {
      // 初始状态
      return const Text('获取验证码');
    }
  }
} 