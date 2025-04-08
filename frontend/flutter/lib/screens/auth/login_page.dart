import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../providers/core/auth_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../services/core/auth_service.dart';
import '../../services/api_service.dart';

/**
 * 登录页面
 * 
 * 提供手机号+密码和手机号+验证码两种登录方式
 * 支持多国家/地区手机号码格式
 */
class LoginPage extends StatefulWidget {
  /// 路由名称，用于导航
  static const routeName = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/**
 * 登录页面状态类
 * 
 * 管理登录表单的状态和交互逻辑
 * 处理用户输入验证和登录请求
 */
class _LoginPageState extends State<LoginPage> {
  /// 表单全局键，用于表单验证
  final _formKey = GlobalKey<FormState>();
  
  /// 手机号输入控制器
  final _phoneController = TextEditingController();
  
  /// 密码输入控制器
  final _passwordController = TextEditingController();
  
  /// 验证码输入控制器
  final _codeController = TextEditingController();
  
  /// 加载状态标志，控制加载指示器的显示
  bool _isLoading = false;
  
  /// 国家/地区代码，默认中国 +86
  String _countryCode = '+86';
  
  /// 支持的国家/地区代码列表
  /// 每项包含code(电话区号)和name(国家/地区名称)
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

  /**
   * 组件销毁时释放资源
   * 
   * 释放所有文本控制器，避免内存泄漏
   */
  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  /**
   * 处理登录操作
   * 
   * 根据当前选择的登录方式（密码/验证码）执行对应的登录逻辑
   * 成功后更新认证状态并跳转到主页
   * 失败则显示错误消息
   */
  Future<void> _handleLogin() async {
    // 首先验证表单
    if (!_formKey.currentState!.validate()) return;

    // 显示加载状态
    setState(() => _isLoading = true);

    try {
      // 获取认证提供者和服务
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final authService = AuthService(ApiService(baseUrl: 'http://10.0.2.2:8080'));

      // 根据登录方式选择不同的登录方法（验证码登录或密码登录）
      final loginResponse = authProvider.isCodeLogin
          ? await authService.loginWithCode(_phoneController.text, _codeController.text, context: context)
          : await authService.loginWithPassword(_phoneController.text, _passwordController.text, context: context);

      // 如果组件已被销毁，则不继续执行
      if (!mounted) return;

      // 使用登录响应中的所有信息更新认证状态
      await authProvider.login(
        loginResponse['token'],
        userId: loginResponse['userId'],
        phone: loginResponse['phone'],
        username: loginResponse['username'],
        nickname: loginResponse['nickname'],
        avatar: loginResponse['avatar'],
      );

      if (!mounted) return;
      
      // 登录成功后跳转到主页
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      // 登录失败，恢复UI状态并显示错误消息
      setState(() => _isLoading = false);
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  /**
   * 构建登录页面UI
   * 
   * 包括页面标题、手机号输入、国家/地区选择、密码/验证码输入
   * 以及登录按钮和其他操作选项
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const LoadingIndicator(message: '登录中...') // 加载状态显示加载指示器
          : SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 页面标题
                        const Text(
                          '登录',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        
                        // 手机号输入区域（包含国家/地区代码选择器）
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 国家/地区代码选择器
                            Container(
                              height: 64,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _countryCode,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                      child: Text("${country['code']}"),
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
                                decoration: const InputDecoration(
                                  labelText: '手机号',
                                  hintText: '请输入手机号',
                                  prefixIcon: Icon(Icons.phone),
                                ),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly, // 限制只能输入数字
                                ],
                                validator: (value) {
                                  // 输入验证
                                  if (value == null || value.isEmpty) {
                                    return '请输入手机号';
                                  }
                                  // 根据不同国家/地区代码验证手机号格式
                                  if (_countryCode == '+86' && value.length != 11) {
                                    return '请输入有效的手机号';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
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
                        const SizedBox(height: 24),
                        
                        // 登录按钮
                        ElevatedButton(
                          onPressed: _handleLogin, // 点击时触发登录处理函数
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            '登录',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // 注册链接按钮
                        // 引导用户前往注册页面创建新账号
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register'); // 导航到注册页面
                          },
                          child: const Text('还没有账号？点击注册'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
} 