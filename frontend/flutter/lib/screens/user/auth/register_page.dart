import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/form/verify_code_input.dart';
import '../../../components/feedback/loading_indicator.dart';
import '../../../providers/core/auth_provider.dart';
import '../../../services/core/auth_service.dart';
import '../../../utils/global_error_handler.dart';
import '../../../common/utils/validators.dart';
import '../../../router/app_routes.dart';

/// 注册页面
///
/// 用户可以通过手机号验证码注册新账号
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // 控制器
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();
  
  // 表单Key
  final _formKey = GlobalKey<FormState>();
  
  // 错误处理
  final _errorHandler = GlobalErrorHandler();
  
  // 状态
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  /// 处理发送验证码
  Future<bool> _handleSendCode(String phone) async {
    // 验证手机号
    final phoneError = Validators.validatePhone(phone);
    if (phoneError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(phoneError)),
      );
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

  /// 处理注册
  Future<void> _handleRegister() async {
    // 验证表单
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    
    if (_isLoading) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      
      final phone = _phoneController.text.trim();
      final code = _codeController.text.trim();
      final password = _passwordController.text;
      final nickname = _nicknameController.text.trim();
      
      // 调用注册并自动登录
      await authProvider.registerAndLogin(
        authService: authService,
        phone: phone,
        password: password,
        code: code,
        nickname: nickname.isNotEmpty ? nickname : null,
        context: context,
      );
      
      if (mounted) {
        // 注册成功，跳转到主页
        Navigator.of(context).pushReplacementNamed(AppRoutes.main);
      }
    } catch (e) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('注册'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 页面标题
                      _buildHeader(),
                      
                      const SizedBox(height: 32),
                      
                      // 手机号输入
                      _buildPhoneInput(),
                      
                      const SizedBox(height: 20),
                      
                      // 验证码输入
                      _buildCodeInput(),
                      
                      const SizedBox(height: 20),
                      
                      // 密码输入
                      _buildPasswordInput(),
                      
                      const SizedBox(height: 20),
                      
                      // 确认密码
                      _buildConfirmPasswordInput(),
                      
                      const SizedBox(height: 20),
                      
                      // 昵称（可选）
                      _buildNicknameInput(),
                      
                      const SizedBox(height: 40),
                      
                      // 注册按钮
                      _buildRegisterButton(),
                      
                      const SizedBox(height: 20),
                      
                      // 已有账号
                      _buildLoginLink(),
                    ],
                  ),
                ),
              ),
            ),
            
            // 加载指示器
            if (_isLoading)
              const Positioned.fill(
                child: LoadingIndicator(
                  isLoading: true,
                  isFullScreen: true,
                  message: '正在注册...',
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  /// 构建页面标题
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '创建新账号',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '请填写以下信息完成注册',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
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
              value: '+86', // 暂时只支持中国区号
              icon: const Icon(Icons.arrow_drop_down, size: 18),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              isExpanded: true, // 确保下拉按钮填充容器宽度
              style: const TextStyle(fontSize: 14, color: Colors.black), // 确保文本颜色可见
              onChanged: (String? newValue) {
                // 暂时不做任何操作，因为目前只支持中国区号
              },
              items: [
                DropdownMenuItem<String>(
                  value: '+86',
                  child: const Text(
                    "+86",
                    style: TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 手机号输入框
        Expanded(
          child: TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: '手机号',
              hintText: '请输入手机号',
              prefixIcon: Icon(Icons.phone_android),
            ),
            validator: Validators.validatePhone,
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }
  
  /// 构建验证码输入框
  Widget _buildCodeInput() {
    return VerifyCodeInput(
      getPhone: () => _phoneController.text.trim(),
      onSendCode: _handleSendCode,
      controller: _codeController,
      hintText: '请输入6位验证码',
      codeLength: 6,
      cooldownSeconds: 60,
    );
  }
  
  /// 构建密码输入框
  Widget _buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: '密码',
        hintText: '请设置登录密码',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      validator: Validators.validatePassword,
      textInputAction: TextInputAction.next,
    );
  }
  
  /// 构建确认密码输入框
  Widget _buildConfirmPasswordInput() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: '确认密码',
        hintText: '请再次输入密码',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
      ),
      validator: (value) => Validators.validateConfirmPassword(
        value,
        _passwordController.text,
      ),
      textInputAction: TextInputAction.next,
    );
  }
  
  /// 构建昵称输入框
  Widget _buildNicknameInput() {
    return TextFormField(
      controller: _nicknameController,
      decoration: const InputDecoration(
        labelText: '昵称（可选）',
        hintText: '请输入昵称',
        prefixIcon: Icon(Icons.person_outline),
      ),
      validator: (value) => Validators.validateNickname(value),
      textInputAction: TextInputAction.done,
    );
  }
  
  /// 构建注册按钮
  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          disabledBackgroundColor: Colors.grey.withOpacity(0.3),
        ),
        child: const Text(
          '注 册',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
  
  /// 构建登录链接
  Widget _buildLoginLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('已有账号？'),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
            child: const Text('立即登录'),
          ),
        ],
      ),
    );
  }
}
