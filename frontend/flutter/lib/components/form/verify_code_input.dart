import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/**
 * 验证码输入框组件
 * 
 * 集成了验证码输入框、发送按钮和倒计时功能
 * 支持自定义验证码长度、冷却时间和错误提示
 * 适用于登录、注册、找回密码等需要短信验证码的场景
 */
class VerifyCodeInput extends StatefulWidget {
  /// 手机号获取函数，用于在发送验证码时获取当前手机号
  /// 返回当前输入框中的手机号码字符串
  final String Function() getPhone;
  
  /// 发送验证码的回调函数
  /// 参数为手机号，返回发送是否成功
  /// 成功返回true，失败返回false
  final Future<bool> Function(String phone) onSendCode;
  
  /// 验证码输入控制器
  /// 用于获取和设置输入的验证码
  final TextEditingController controller;
  
  /// 验证码输入框错误提示文本
  /// 显示在输入框下方，用于提示验证码输入错误
  final String? errorText;
  
  /// 验证码输入框提示文本
  /// 当输入框为空时显示的灰色提示文字
  final String hintText;
  
  /// 验证码长度
  /// 影响输入框最大输入长度和键盘限制
  final int codeLength;
  
  /// 冷却时间（秒）
  /// 发送验证码后的等待时间，期间不能再次发送
  final int cooldownSeconds;
  
  /// 已存在的倒计时时间（秒）
  /// 用于页面重建时保持倒计时状态
  /// 例如从其他页面返回时，继续显示剩余倒计时
  final int? existingCooldown;

  /**
   * 构造函数
   * 
   * @param key 组件键
   * @param getPhone 获取手机号的函数
   * @param onSendCode 发送验证码的回调函数
   * @param controller 验证码输入控制器
   * @param errorText 错误提示文本
   * @param hintText 提示文本，默认为"请输入验证码"
   * @param codeLength 验证码长度，默认为6位
   * @param cooldownSeconds 冷却时间，默认为60秒
   * @param existingCooldown 已存在的倒计时时间
   */
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

/**
 * 验证码输入框组件状态类
 * 
 * 管理验证码发送状态、倒计时逻辑和UI渲染
 */
class _VerifyCodeInputState extends State<VerifyCodeInput> {
  /// 倒计时剩余秒数
  /// 大于0时显示倒计时，等于0时显示"获取验证码"
  int _countdown = 0;
  
  /// 倒计时定时器
  /// 用于每秒更新倒计时显示
  Timer? _timer;
  
  /// 是否正在发送验证码
  /// 发送过程中显示加载状态
  bool _isSending = false;
  
  /// 是否已发送验证码
  /// 用于区分首次发送和重新发送的按钮文本
  bool _hasSent = false;

  /**
   * 组件初始化
   * 
   * 处理已存在的倒计时，恢复发送状态
   */
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

  /**
   * 组件销毁
   * 
   * 清理定时器资源，避免内存泄漏
   */
  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  /**
   * 开始倒计时
   * 
   * 创建定时器，每秒减少倒计时数值
   * 当倒计时归零时自动取消定时器
   */
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

  /**
   * 取消倒计时
   * 
   * 清理定时器资源
   */
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /**
   * 处理发送验证码
   * 
   * 获取手机号、调用发送接口、管理倒计时状态
   * 处理发送成功和失败的不同情况
   */
  Future<void> _handleSendCode() async {
    // 如果正在发送或倒计时中，则不处理
    if (_isSending || _countdown > 0) {
      return;
    }

    // 获取手机号
    final phone = widget.getPhone();
    if (phone.isEmpty) {
      // 手机号为空，提示用户先输入手机号
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先输入手机号')),
      );
      return;
    }

    // 设置发送中状态
    setState(() {
      _isSending = true;
    });

    try {
      // 调用发送验证码接口
      final success = await widget.onSendCode(phone);
      
      // 发送成功，开始倒计时
      if (success && mounted) {
        setState(() {
          _hasSent = true;
          _countdown = widget.cooldownSeconds;
          _startTimer();
        });
      }
    } catch (e) {
      // 发送失败，显示错误提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('发送验证码失败: ${e.toString()}')),
        );
      }
    } finally {
      // 无论成功失败，都结束发送中状态
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  /**
   * 构建组件UI
   * 
   * 包含验证码输入框和发送按钮两部分
   * 根据发送状态展示不同的按钮文本和样式
   * 
   * @param context 构建上下文
   * @return 构建的组件
   */
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 验证码输入框
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.number, // 使用数字键盘
            decoration: InputDecoration(
              labelText: '验证码',
              hintText: widget.hintText,
              errorText: widget.errorText,
              prefixIcon: const Icon(Icons.lock_outline),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.codeLength), // 限制最大长度
              FilteringTextInputFormatter.digitsOnly, // 限制只能输入数字
            ],
            maxLength: widget.codeLength,
            buildCounter: (
              BuildContext context, {
              required int currentLength,
              required bool isFocused,
              required int? maxLength,
            }) => null, // 不显示字符计数器
            textInputAction: TextInputAction.done, // 键盘完成按钮
          ),
        ),

        const SizedBox(width: 16),
        
        // 发送验证码按钮
        SizedBox(
          height: 56,
          child: ElevatedButton(
            // 根据状态决定按钮是否可点击
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

  /**
   * 构建按钮内容
   * 
   * 根据发送状态显示不同的按钮文本
   * - 发送中：显示加载指示器
   * - 倒计时中：显示剩余秒数
   * - 可发送：显示"获取验证码"或"重新发送"
   * 
   * @return 按钮内容组件
   */
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