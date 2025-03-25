import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../providers/index.dart';
import '../../../constants/api.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  void _register() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      _showDialog("手机号和密码不能为空");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/api/users/register');
      
      print('正在请求URL: $url'); // 添加调试信息
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone, 'password': password}),
      ).timeout(const Duration(seconds: 10));
      
      print('收到响应状态码: ${response.statusCode}'); // 添加调试信息
      
      final responseData = json.decode(response.body);
      print('响应数据: $responseData'); // 添加调试信息

      if (response.statusCode == 200 && responseData['success'] == true) {
        // 保存用户信息到Provider
        if(responseData['user'] != null && responseData['token'] != null) {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(responseData['user']);
          userProvider.setToken(responseData['token']);
        }
        
        // 注册成功，显示简短提示，然后跳转到主页
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('注册成功！'), duration: Duration(seconds: 1)),
        );
        
        // 延迟一小段时间再跳转，让用户能看到提示
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacementNamed(context, '/home');
        });
      } else {
        _showDialog(responseData['message'] ?? "注册失败，请稍后重试");
      }
    } catch (e) {
      print('注册出错: $e'); // 添加调试信息
      _showDialog("注册失败：$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("确定"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("用户注册")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "手机号"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "密码"),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: const Text("立即注册"),
                  )
          ],
        ),
      ),
    );
  }
}
