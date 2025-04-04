import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/utils/validators.dart';
import '../../../components/form/verify_code_input.dart';
import '../../../components/feedback/loading_indicator.dart';
import '../../../providers/core/auth_provider.dart';
import '../../../services/core/auth_service.dart';
import '../../../utils/global_error_handler.dart';
import '../../../router/app_routes.dart';

/// 验证码页面
///
/// 用于密码重置流程中的验证手机号和验证码步骤
class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({Key? key}) : super(key: key);

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  // 控制器
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  
  // 表单Key
  final _formKey = GlobalKey<FormState>();
  
  // 错误处理
  final _errorHandler = GlobalErrorHandler();
  
  // 状态
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
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
      // 重置密码验证码发送逻辑
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      
      return await authProvider.sendResetCode(
        authService: authService,
        phone: phone,
        context: context,
      );
    } catch (e) {
      _errorHandler.handleNetworkError(context, e);
      return false;
    }
  }

  /// 处理下一步
  void _handleNextStep() {
    // 验证表单
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    
    if (_isLoading) {
      return;
    }
    
    final phone = _phoneController.text.trim();
    final code = _codeController.text.trim();
    
    // 导航到重置密码页面 (使用 resetPassword route)
    Navigator.pushNamed(
      context, 
      AppRoutes.resetPassword,
      arguments: {
        'phone': phone,
        'code': code,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('找回密码'),
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
                      
                      const SizedBox(height: 40),
                      
                      // 下一步按钮
                      _buildNextButton(),
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
                  message: '处理中...',
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
          '找回密码',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '请输入您的手机号和接收到的验证码',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
  
  /// 构建手机号输入框
  Widget _buildPhoneInput() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: '手机号',
        hintText: '请输入手机号',
        prefixIcon: Icon(Icons.phone_android),
        prefixText: '+86 ',
      ),
      validator: Validators.validatePhone,
      textInputAction: TextInputAction.next,
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
  
  /// 构建下一步按钮
  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleNextStep,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          disabledBackgroundColor: Colors.grey.withOpacity(0.3),
        ),
        child: const Text(
          '下一步',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
