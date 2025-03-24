import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    final String phone = _phoneController.text.trim();
    final String password = _passwordController.text;

    if (phone.isEmpty || password.isEmpty) {
      _showDialog("请输入手机号和密码");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // 安卓模拟器下使用 10.0.2.2 访问宿主机服务
      final url = Uri.parse('http://10.0.2.2:3000/api/users/login');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phone, "password": password}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // 登录成功，显示弹窗，点击确定后跳转到健康信息填写页面
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("登录成功"),
            content: const Text("欢迎回来！"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx); // 关闭弹窗
                  Navigator.pushReplacementNamed(context, '/health'); // 跳转到健康信息填写页面
                },
                child: const Text("确定"),
              ),
            ],
          ),
        );
      } else {
        _showDialog(responseData['message'] ?? "登录失败");
      }
    } catch (e) {
      _showDialog("网络错误：$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 简单错误提示弹窗
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("确定"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("登录")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "手机号"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "密码"),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text("登录"),
                  ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("还没有账号？去注册"),
            ),
          ],
        ),
      ),
    );
  }
}
