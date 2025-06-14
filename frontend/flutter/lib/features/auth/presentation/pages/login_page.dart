import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../../../../shared/widgets/common/toast.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import 'verification_code_page.dart';
import 'profile_completion_page.dart';
import 'reset_password_page.dart';
import '../../../../routes/app_navigator.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isPasswordLogin = false;
  bool _isAgreed = false;
  bool _showPassword = false;
  
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
    // 添加监听器以在输入变化时更新按钮状态
    _phoneController.addListener(() {
      setState(() {});
    });
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Logo和标语
                _buildHeader(),
                const SizedBox(height: 60),
                // 登录表单
                _buildLoginForm(),
                const SizedBox(height: 24),
                // 登录按钮
                _buildLoginButton(),
                const SizedBox(height: 16),
                // 其他登录选项
                _buildOtherOptions(),
                const SizedBox(height: 40),
                // 第三方登录
                _buildThirdPartyLogin(),
                const SizedBox(height: 20),
                // 用户协议
                _buildAgreement(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryOrange.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: const Image(
              image: AssetImage('assets/images/logo.png'),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryOrange.withOpacity(0.1),
                AppColors.secondaryGreen.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            '🍎 健康营养每一天 🥗',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryOrange,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        // 手机号输入框
        Container(
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
                child: TextField(
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
                ),
              ),
            ],
          ),
        ),
        
        if (_isPasswordLogin) ...[
          const SizedBox(height: 16),
          // 密码输入框
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                hintText: '请输入密码',
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
            ),
          ),
          const SizedBox(height: 12),
          // 忘记密码按钮
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                AppNavigator.push(context, const ResetPasswordPage());
              },
              child: const Text(
                '忘记密码？',
                style: TextStyle(
                  color: AppColors.primaryOrange,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLoginButton() {
    final bool isPhoneValid = _phoneController.text.length == 11;
    final bool canLogin = _isPasswordLogin 
        ? (isPhoneValid && _passwordController.text.isNotEmpty && _isAgreed)
        : (isPhoneValid && _isAgreed);

    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: canLogin ? AppColors.buttonGradient : null,
        color: canLogin ? null : AppColors.divider,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ElevatedButton(
        onPressed: canLogin ? _handleLogin : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          _isPasswordLogin ? '登录' : '获取验证码',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: canLogin ? Colors.white : AppColors.textHint,
          ),
        ),
      ),
    );
  }

  Widget _buildOtherOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _isPasswordLogin = !_isPasswordLogin;
            });
          },
          child: Text(
            _isPasswordLogin ? '验证码登录' : '密码登录',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
        const Text(
          '|',
          style: TextStyle(color: AppColors.divider),
        ),
        TextButton(
          onPressed: () {
            // TODO(dev): 遇到问题
          },
          child: const Text(
            '遇到问题',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThirdPartyLogin() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Container(height: 1, color: AppColors.divider)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '其他登录方式',
                style: TextStyle(
                  color: AppColors.textHint,
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(child: Container(height: 1, color: AppColors.divider)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildThirdPartyIcon(
              icon: Icons.chat,
              color: AppColors.wechatGreen,
              onTap: () {
                // TODO(dev): 微信登录
              },
            ),
            _buildThirdPartyIcon(
              icon: Icons.account_balance_wallet,
              color: AppColors.alipayBlue,
              onTap: () {
                // TODO(dev): 支付宝登录
              },
            ),
            _buildThirdPartyIcon(
              icon: Icons.apartment,
              color: AppColors.dingdingBlue,
              onTap: () {
                // TODO(dev): 钉钉登录
              },
            ),
            _buildThirdPartyIcon(
              icon: Icons.business,
              color: AppColors.wecomBlue,
              onTap: () {
                // TODO(dev): 企业微信登录
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThirdPartyIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildAgreement() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _isAgreed,
            onChanged: (value) {
              setState(() {
                _isAgreed = value ?? false;
              });
            },
            activeColor: AppColors.primaryOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(text: '我已阅读并同意'),
                TextSpan(
                  text: '《用户服务协议》',
                  style: TextStyle(color: AppColors.primaryOrange),
                ),
                TextSpan(text: '和'),
                TextSpan(
                  text: '《隐私政策》',
                  style: TextStyle(color: AppColors.primaryOrange),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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

  void _handleLogin() async {
    final authNotifier = ref.read(authStateProvider.notifier);
    
    if (_isPasswordLogin) {
      // 密码登录
      try {
        final success = await authNotifier.loginWithPassword(
          _phoneController.text,
          _passwordController.text,
        );
        
        if (success) {
          _navigateAfterLogin();
        } else {
          // 登录失败，显示错误提示
          if (mounted) {
            final error = ref.read(authStateProvider).error;
            String errorMessage = '登录失败';
            
            // 根据错误信息显示更具体的提示
            if (error != null) {
              if (error.contains('密码错误') || error.contains('密码不正确')) {
                errorMessage = '密码错误，请重新输入';
              } else if (error.contains('用户不存在')) {
                errorMessage = '该手机号未注册';
              } else {
                errorMessage = error;
              }
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = '登录失败';
          
          // 解析错误信息
          String errorString = e.toString();
          if (errorString.contains('密码错误') || errorString.contains('密码不正确')) {
            errorMessage = '密码错误，请重新输入';
          } else if (errorString.contains('用户不存在')) {
            errorMessage = '该手机号未注册';
          } else if (errorString.contains('Exception: 登录失败:')) {
            // 提取具体的错误信息
            errorMessage = errorString.replaceAll('Exception: 登录失败:', '').trim();
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    } else {
      // 发送验证码
      try {
        print('开始发送验证码: ${_phoneController.text}');
        
        // 保存手机号和context，避免在异步操作后widget被dispose导致无法访问
        final phone = _phoneController.text;
        final navigator = Navigator.of(context);
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        
        final success = await authNotifier.sendVerificationCode(phone);
        
        print('发送验证码结果: $success');
        
        if (success) {
          print('验证码发送成功，准备跳转到验证码页面');
          
          // 先显示成功提示，然后跳转
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('验证码已发送'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2), // 短暂显示
            ),
          );
          
          // 延迟跳转到验证码页面，确保SnackBar显示完成
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              AppNavigator.push(
                context,
                VerificationCodePage.legacy(
                  phone: phone,
                ),
              );
              print('导航到验证码页面完成');
            }
          });
        } else {
          print('验证码发送失败');
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('验证码发送失败，请重试'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('发送验证码异常: $e');
        
        String errorMessage = '发送验证码失败';
        if (e is AppException) {
          errorMessage = e.message;
        }
        
        // 使用ScaffoldMessenger显示错误
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
  
  void _navigateAfterLogin() {
    final user = ref.read(authStateProvider).user;
    if (user != null) {
      if (user.needCompleteProfile) {
        // 跳转到资料完善页面
        AppNavigator.pushReplacement(
          context,
          const ProfileCompletionPage(),
        );
      } else {
        // 跳转到主页
        AppNavigator.toMain(context);
      }
    }
  }
}

