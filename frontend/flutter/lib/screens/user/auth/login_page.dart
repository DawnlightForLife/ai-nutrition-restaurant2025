import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../../components/form/login_tab_switch.dart';
import '../../../components/form/verify_code_input.dart';
import '../../../components/form/social_login_row.dart';
import '../../../providers/core/auth_provider.dart';
import '../../../services/core/auth_service.dart';
import '../../../services/core/api_service.dart';
import '../../../utils/global_error_handler.dart';
import '../../../common/utils/validators.dart';
import '../../../router/app_routes.dart';

/// 登录页面
///
/// 支持验证码登录和密码登录两种方式
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 控制器
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // 错误提示文本
  String? _phoneErrorText;
  String? _passwordErrorText;
  String? _codeErrorText;
  
  // 登录状态
  bool _isLoading = false;
  
  // 错误处理
  final _errorHandler = GlobalErrorHandler();
  
  // 国家/地区代码，默认中国 +86
  String _countryCode = '+86';
  
  // 支持的国家/地区代码列表
  final List<Map<String, String>> _countryCodes = [
    {'code': '+86', 'name': '中国大陆'},
    {'code': '+852', 'name': '中国香港'},
    {'code': '+853', 'name': '中国澳门'},
    {'code': '+886', 'name': '中国台湾'},
    {'code': '+1', 'name': '美国/加拿大'},
    {'code': '+44', 'name': '英国'},
    {'code': '+81', 'name': '日本'},
    {'code': '+82', 'name': '韩国'},
    {'code': '+65', 'name': '新加坡'},
    {'code': '+60', 'name': '马来西亚'},
    {'code': '+61', 'name': '澳大利亚'},
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 验证手机号
  bool _validatePhone() {
    final phone = _phoneController.text.trim();
    
    if (phone.isEmpty) {
      setState(() {
        _phoneErrorText = '请输入手机号';
      });
      return false;
    }
    
    // 根据不同国家/地区代码验证手机号格式
    if (_countryCode == '+86' && phone.length != 11) {
      setState(() {
        _phoneErrorText = '请输入正确的手机号';
      });
      return false;
    }
    
    setState(() {
      _phoneErrorText = null;
    });
    return true;
  }

  /// 验证验证码
  bool _validateCode() {
    final code = _codeController.text.trim();
    
    if (code.isEmpty) {
      setState(() {
        _codeErrorText = '请输入验证码';
      });
      return false;
    }
    
    if (code.length != 6) {
      setState(() {
        _codeErrorText = '验证码为6位数字';
      });
      return false;
    }
    
    setState(() {
      _codeErrorText = null;
    });
    return true;
  }

  /// 验证密码
  bool _validatePassword() {
    final password = _passwordController.text;
    
    if (password.isEmpty) {
      setState(() {
        _passwordErrorText = '请输入密码';
      });
      return false;
    }
    
    if (password.length < 6) {
      setState(() {
        _passwordErrorText = '密码至少6位';
      });
      return false;
    }
    
    setState(() {
      _passwordErrorText = null;
    });
    return true;
  }

  /// 处理发送验证码
  Future<bool> _handleSendCode(String phone) async {
    if (!_validatePhone()) {
      return false;
    }
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      return await authService.sendVerificationCode(phone, context: context);
    } catch (e) {
      _errorHandler.handleNetworkError(context, e);
      return false;
    }
  }

  /// 处理登录提交
  Future<void> _handleSubmit() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isCodeLogin = authProvider.isCodeLogin;
    
    // 登录前表单校验
    if (!_validatePhone()) {
      return;
    }
    
    if (isCodeLogin) {
      if (!_validateCode()) {
        return;
      }
    } else {
      if (!_validatePassword()) {
        return;
      }
    }
    
    if (_isLoading) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      
      Map<String, dynamic> loginResponse;
      final phone = _phoneController.text.trim();
      
      if (isCodeLogin) {
        // 验证码登录
        final code = _codeController.text.trim();
        loginResponse = await authService.loginWithCode(phone, code, context: context);
      } else {
        // 密码登录
        final password = _passwordController.text;
        loginResponse = await authService.loginWithPassword(phone, password, context: context);
      }
      
      debugPrint('登录响应数据: $loginResponse');  // 添加调试日志
      
      // 存储token并跳转
      if (mounted) {
        await authProvider.login(
          loginResponse['token'],
          userId: loginResponse['userId'],
          phone: loginResponse['phone'],
          username: loginResponse['username'],  // 用户名
          nickname: loginResponse['nickname'],  // 用户昵称
          avatar: loginResponse['avatar'],
        );
        
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      }
    } catch (e) {
      debugPrint('登录错误: $e');  // 添加调试日志
      if (mounted) {
        _errorHandler.handleAuthError(context, e);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isCodeLogin = authProvider.isCodeLogin;
    
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('登录'),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 登录方式切换
                LoginTabSwitch(
                  isCodeLogin: isCodeLogin,
                  onTabChanged: (value) {
                    authProvider.setLoginMethod(value);
                    // 清除错误信息
                    setState(() {
                      _codeErrorText = null;
                      _passwordErrorText = null;
                    });
                  },
                ),
                
                const SizedBox(height: 32),
                
                // 登录表单
                _buildLoginForm(isCodeLogin),
                
                const SizedBox(height: 32),
                
                // 登录按钮
                _buildLoginButton(),
                
                const SizedBox(height: 24),
                
                // 辅助功能行
                _buildHelperRow(),
                
                const SizedBox(height: 32),
                
                // 社交登录选项
                SocialLoginRow(
                  onWeChatLogin: () {
                    // 微信登录
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('微信登录功能暂未实现')),
                    );
                  },
                  onAlipayLogin: () {
                    // 支付宝登录
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('支付宝登录功能暂未实现')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// 构建登录表单
  Widget _buildLoginForm(bool isCodeLogin) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 手机号输入框
        _buildPhoneInput(),
        
        const SizedBox(height: 20),
        
        // 验证码或密码输入框
        isCodeLogin ? _buildCodeInput() : _buildPasswordInput(),
      ],
    );
  }
  
  /// 构建手机号输入框
  Widget _buildPhoneInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 国家/地区代码选择器
        Container(
          height: 60,
          width: 80, // 设置固定宽度
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _countryCode,
              icon: const Icon(Icons.arrow_drop_down, size: 18),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              isExpanded: true, // 确保下拉按钮填充容器宽度
              style: const TextStyle(fontSize: 14, color: Colors.black), // 确保文本颜色可见
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _countryCode = newValue;
                  });
                }
              },
              items: _countryCodes.map<DropdownMenuItem<String>>((Map<String, String> country) {
                return DropdownMenuItem<String>(
                  value: country['code'],
                  child: Text(
                    "${country['code']}",
                    style: const TextStyle(fontSize: 13), // 稍微减小字体大小
                    overflow: TextOverflow.ellipsis, // 防止文本溢出
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 手机号输入框
        Expanded(
          child: TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: '手机号',
              hintText: '请输入手机号',
              errorText: _phoneErrorText,
              prefixIcon: const Icon(Icons.phone_android),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (_) {
              // 清除错误提示
              if (_phoneErrorText != null) {
                setState(() {
                  _phoneErrorText = null;
                });
              }
            },
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }
  
  /// 构建验证码输入框（使用新组件）
  Widget _buildCodeInput() {
    return VerifyCodeInput(
      getPhone: () => _phoneController.text.trim(),
      onSendCode: _handleSendCode,
      controller: _codeController,
      errorText: _codeErrorText,
      hintText: '请输入6位验证码',
      codeLength: 6,
      cooldownSeconds: 60,
    );
  }
  
  /// 构建密码输入框
  Widget _buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: '密码',
        hintText: '请输入密码',
        errorText: _passwordErrorText,
        prefixIcon: const Icon(Icons.lock_outline),
      ),
      onChanged: (_) {
        // 清除错误提示
        if (_passwordErrorText != null) {
          setState(() {
            _passwordErrorText = null;
          });
        }
      },
      textInputAction: TextInputAction.done,
    );
  }
  
  /// 构建登录按钮
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          disabledBackgroundColor: Colors.grey.withOpacity(0.3),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                '登 录',
                style: TextStyle(fontSize: 18),
              ),
      ),
    );
  }

  /// 构建页面顶部LOGO和标题
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Image.asset(
            'assets/images/logo.png',
            width: 80,
            height: 80,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.restaurant,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 标题
        const Text(
          'AI营养餐厅',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  /// 构建辅助功能行（注册、忘记密码等）
  Widget _buildHelperRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 注册账号
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.register);
          },
          child: const Text('注册账号'),
        ),
        
        // 分隔符
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        
        // 忘记密码
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.forgotPassword);
          },
          child: const Text('忘记密码'),
        ),
        
        // 分隔符
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        
        // 客服
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/user/customer_service');
          },
          child: const Text('联系客服'),
        ),
      ],
    );
  }
}
