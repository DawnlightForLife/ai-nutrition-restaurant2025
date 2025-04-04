import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../providers/core/auth_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../services/core/auth_service.dart';
import '../../services/api_service.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isLoading = false;
  
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
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  // 登录
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final authService = AuthService(ApiService(baseUrl: 'http://10.0.2.2:8080'));

      // 根据登录方式选择不同的登录方法
      final loginResponse = authProvider.isCodeLogin
          ? await authService.loginWithCode(_phoneController.text, _codeController.text, context: context)
          : await authService.loginWithPassword(_phoneController.text, _passwordController.text, context: context);

      if (!mounted) return;

      // 使用登录响应中的所有信息
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
      setState(() => _isLoading = false);
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const LoadingIndicator(message: '登录中...')
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
                        // 标题
                        const Text(
                          '登录',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        
                        // 手机号输入框
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
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
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
                        
                        // 密码
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: '密码',
                            hintText: '请输入密码',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
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
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            '登录',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // 注册链接
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
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