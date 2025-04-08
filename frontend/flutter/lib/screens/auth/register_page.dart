import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/core/auth_provider.dart';
import '../../widgets/common/loading_indicator.dart';

/**
 * 用户注册页面
 * 
 * 提供用户注册功能，包含姓名、手机号、密码等信息的输入和验证
 * 注册成功后自动登录并跳转到主页
 */
class RegisterPage extends StatefulWidget {
  /// 路由名称，用于导航
  static const routeName = '/register';

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

/**
 * 注册页面状态类
 * 
 * 管理注册表单的状态和交互逻辑
 * 处理用户输入验证和注册请求
 */
class _RegisterPageState extends State<RegisterPage> {
  /// 表单全局键，用于表单验证
  final _formKey = GlobalKey<FormState>();
  
  /// 姓名输入控制器
  final _nameController = TextEditingController();
  
  /// 手机号输入控制器
  final _phoneController = TextEditingController();
  
  /// 密码输入控制器
  final _passwordController = TextEditingController();
  
  /// 确认密码输入控制器
  final _confirmPasswordController = TextEditingController();
  
  /// 加载状态标志，控制加载指示器的显示
  bool _isLoading = false;

  /**
   * 组件销毁时释放资源
   * 
   * 释放所有文本控制器，避免内存泄漏
   */
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /**
   * 处理注册操作
   * 
   * 验证表单数据，调用认证服务进行注册并自动登录
   * 成功后跳转到主页，失败则显示错误消息
   */
  Future<void> _register() async {
    // 首先验证表单
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 显示加载状态
    setState(() {
      _isLoading = true;
    });

    try {
      // 获取认证提供者并调用注册登录方法
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.registerAndLogin(
        authService: Provider.of(context, listen: false),
        phone: _phoneController.text,
        password: _passwordController.text,
        code: '123456', // 这里应该使用真实的验证码
        nickname: _nameController.text,
        context: context,
      );

      // 如果组件已被销毁，则不继续执行
      if (!mounted) return;
      
      // 显示注册成功消息
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('注册成功！'),
          backgroundColor: Colors.green,
        ),
      );
      
      // 跳转到主页
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      // 注册失败，显示错误消息
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('注册失败: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // 恢复UI状态
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /**
   * 构建注册页面UI
   * 
   * 包括表单输入字段、验证逻辑和按钮
   * 实现姓名、手机号、密码和确认密码的输入和验证
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('注册'),
      ),
      body: _isLoading
          ? const LoadingIndicator(message: '注册中...') // 加载状态显示加载指示器
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 姓名输入框
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: '姓名',
                        hintText: '请输入姓名',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        // 姓名验证
                        if (value == null || value.isEmpty) {
                          return '请输入姓名';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // 手机号输入框
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: '手机号',
                        hintText: '请输入手机号',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone, // 设置键盘类型为电话号码
                      validator: (value) {
                        // 手机号验证
                        if (value == null || value.isEmpty) {
                          return '请输入手机号';
                        }
                        if (value.length != 11) {
                          return '请输入有效的手机号';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // 密码输入框
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: '密码',
                        hintText: '请输入密码',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true, // 密码隐藏显示
                      validator: (value) {
                        // 密码验证
                        if (value == null || value.isEmpty) {
                          return '请输入密码';
                        }
                        if (value.length < 6) {
                          return '密码长度不能少于6位';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // 确认密码输入框
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: '确认密码',
                        hintText: '请再次输入密码',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true, // 密码隐藏显示
                      validator: (value) {
                        // 确认密码验证：必须非空且与密码一致
                        if (value == null || value.isEmpty) {
                          return '请确认密码';
                        }
                        if (value != _passwordController.text) {
                          return '两次输入的密码不一致';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // 注册按钮
                    ElevatedButton(
                      onPressed: _register, // 点击时触发注册处理函数
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        '注册',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 登录链接按钮
                    // 引导已有账号的用户前往登录页面
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login'); // 导航到登录页面
                      },
                      child: const Text('已有账号？点击登录'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 