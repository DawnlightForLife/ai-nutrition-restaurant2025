import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/utils/validators.dart';
import '../../../components/form/custom_password_input.dart';
import '../../../components/feedback/loading_indicator.dart';
import '../../../providers/core/auth_provider.dart';
import '../../../services/core/auth_service.dart';
import '../../../utils/global_error_handler.dart';
import '../../../router/app_routes.dart';

/// 重置密码页面
///
/// 用于密码重置流程中的设置新密码步骤
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  // 控制器
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // 表单Key
  final _formKey = GlobalKey<FormState>();
  
  // 错误处理
  final _errorHandler = GlobalErrorHandler();
  
  // 状态
  bool _isLoading = false;
  
  // 从上一页接收的数据
  String? _phone;
  String? _code;

  @override
  void initState() {
    super.initState();
    // 延迟获取路由参数，确保context已经初始化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _extractRouteArguments();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// 从路由参数中提取数据
  void _extractRouteArguments() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      setState(() {
        _phone = args['phone'];
        _code = args['code'];
      });
    }
    
    // 如果没有接收到必要参数，返回上一页
    if (_phone == null || _code == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('缺少必要信息，请重新开始找回密码流程')),
      );
      Navigator.pop(context);
    }
  }

  /// 处理提交重置密码
  Future<void> _handleSubmit() async {
    // 验证表单
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    
    if (_isLoading) {
      return;
    }
    
    // 确保有手机号和验证码
    if (_phone == null || _code == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('缺少必要信息，请重新开始找回密码流程')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      
      final newPassword = _passwordController.text;
      
      // 调用重置密码API
      final success = await authProvider.resetPassword(
        authService: authService,
        phone: _phone!,
        code: _code!,
        newPassword: newPassword,
        context: context,
      );
      
      if (success && mounted) {
        // 重置成功，显示提示并返回登录页
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('密码重置成功，请使用新密码登录')),
        );
        
        // 返回登录页
        Navigator.pushNamedAndRemoveUntil(
          context, 
          AppRoutes.login, 
          (route) => false,
        );
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
        title: const Text('重置密码'),
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
                      
                      // 新密码输入
                      _buildPasswordInput(),
                      
                      const SizedBox(height: 20),
                      
                      // 确认密码输入
                      _buildConfirmPasswordInput(),
                      
                      const SizedBox(height: 40),
                      
                      // 提交按钮
                      _buildSubmitButton(),
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
                  message: '正在重置密码...',
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
          '设置新密码',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '请输入您的新密码，并确认',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
  
  /// 构建密码输入框
  Widget _buildPasswordInput() {
    return CustomPasswordInput(
      controller: _passwordController,
      labelText: '新密码',
      hintText: '请设置新密码',
      validator: Validators.validatePassword,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
  
  /// 构建确认密码输入框
  Widget _buildConfirmPasswordInput() {
    return CustomPasswordInput(
      controller: _confirmPasswordController,
      labelText: '确认密码',
      hintText: '请再次输入新密码',
      validator: (value) => Validators.validateConfirmPassword(
        value,
        _passwordController.text,
      ),
      onEditingComplete: _handleSubmit,
    );
  }
  
  /// 构建提交按钮
  Widget _buildSubmitButton() {
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
        child: const Text(
          '重置密码',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
