import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../config/theme/yuanqi_colors.dart';
import '../../providers/auth_state_provider.dart';
import '../../widgets/common/toast.dart';
import '../../../core/exceptions/app_exceptions.dart';
import 'profile_completion_page.dart';
import '../home/home_page.dart';

class VerificationCodePage extends ConsumerStatefulWidget {
  final String phone;
  final bool isFromLogin;
  
  const VerificationCodePage({
    Key? key,
    required this.phone,
    this.isFromLogin = true,
  }) : super(key: key);

  @override
  ConsumerState<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends ConsumerState<VerificationCodePage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  
  Timer? _timer;
  int _countdown = 60;
  bool _canResend = false;
  
  @override
  void initState() {
    super.initState();
    _startCountdown();
    // 自动聚焦第一个输入框
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
  
  void _startCountdown() {
    setState(() {
      _countdown = 60;
      _canResend = false;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
        if (_countdown == 0) {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: YuanqiColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO(dev): 帮助
            },
            child: const Text(
              '帮助',
              style: TextStyle(color: YuanqiColors.textSecondary),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              '输入验证码',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: YuanqiColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '验证码已发送至 ${widget.phone}',
              style: const TextStyle(
                fontSize: 14,
                color: YuanqiColors.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            // 验证码输入框
            _buildCodeInput(),
            const SizedBox(height: 32),
            // 重新获取按钮
            _buildResendButton(),
            const SizedBox(height: 16),
            // 其他选项
            _buildOtherOptions(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCodeInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 48,
          height: 56,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: YuanqiColors.textPrimary,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: YuanqiColors.background,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: YuanqiColors.primaryOrange,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                // 自动跳转到下一个输入框
                if (index < 5) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  // 最后一个输入框，稍等一下再自动提交，确保输入完成
                  _focusNodes[index].unfocus();
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (_controllers.map((c) => c.text).join().length == 6) {
                      _verifyCode();
                    }
                  });
                }
              }
            },
            onSubmitted: (_) {
              if (index < 5) {
                _focusNodes[index + 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
  }
  
  Widget _buildResendButton() {
    return Center(
      child: TextButton(
        onPressed: _canResend ? _resendCode : null,
        child: Text(
          _canResend ? '重新获取' : '重新获取(${_countdown}s)',
          style: TextStyle(
            color: _canResend ? YuanqiColors.primaryOrange : YuanqiColors.textHint,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
  
  Widget _buildOtherOptions() {
    return Center(
      child: TextButton(
        onPressed: () {
          // TODO(dev): 手机号已停用
        },
        child: const Text(
          '手机号已停用？',
          style: TextStyle(
            color: YuanqiColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
  
  void _verifyCode() async {
    String code = _controllers.map((c) => c.text).join();
    if (code.length == 6) {
      final authNotifier = ref.read(authStateProvider.notifier);
      
      // 显示加载指示器
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: YuanqiColors.primaryOrange,
          ),
        ),
      );
      
      try {
        print('开始验证码登录: 手机号=${widget.phone}, 验证码=$code');
        final success = await authNotifier.loginWithCode(widget.phone, code);
        
        // 关闭加载指示器
        if (mounted) {
          Navigator.pop(context);
        }
        
        print('验证码登录结果: $success');
        if (success) {
          print('验证码登录成功，准备跳转');
          _navigateAfterLogin();
        } else {
          print('验证码登录失败，但没有抛出异常');
          Toast.error(context, '验证码验证失败');
        }
      } catch (e) {
        print('验证码登录异常: $e');
        // 关闭加载指示器
        if (mounted) {
          Navigator.pop(context);
          
          String errorMessage = '验证码错误';
          if (e is AppException) {
            errorMessage = e.message;
          } else {
            // 将英文错误信息转换为中文
            String error = e.toString();
            if (error.contains('type \'Null\' is not a subtype')) {
              errorMessage = '数据格式错误，请重试';
            } else if (error.contains('Connection refused')) {
              errorMessage = '网络连接失败';
            } else if (error.contains('timeout')) {
              errorMessage = '网络超时，请重试';
            } else {
              errorMessage = '登录失败，请重试';
            }
          }
          print('显示错误消息: $errorMessage');
          Toast.error(context, errorMessage);
          
          // 清空验证码输入框
          for (var controller in _controllers) {
            controller.clear();
          }
          _focusNodes[0].requestFocus();
        }
      }
    }
  }
  
  void _navigateAfterLogin() {
    final user = ref.read(authStateProvider).user;
    if (user != null && mounted) {
      if (user.needCompleteProfile) {
        // 跳转到资料完善页面
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileCompletionPage(),
          ),
          (route) => false,
        );
      } else {
        // 跳转到主页
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false,
        );
      }
    }
  }
  
  void _resendCode() async {
    final authNotifier = ref.read(authStateProvider.notifier);
    
    try {
      final success = await authNotifier.sendVerificationCode(widget.phone);
      
      if (success) {
        _startCountdown();
        if (mounted) {
          Toast.success(context, '验证码已重新发送');
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = '发送验证码失败';
        if (e is AppException) {
          errorMessage = e.message;
        }
        Toast.error(context, errorMessage);
      }
    }
  }
}