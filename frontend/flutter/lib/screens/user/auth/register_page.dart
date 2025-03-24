import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() async {
  final phone = _phoneController.text.trim();
  final password = _passwordController.text.trim();

  if (phone.isEmpty || password.isEmpty) {
    _showDialog("提示", "请填写手机号和密码");
    return;
  }

  try {
    final url = Uri.parse('http://10.0.2.2:3000/api/users/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phone': phone, 'password': password}),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 201 && responseData['success'] == true) {
      _showDialog("注册成功", "请返回登录页面登录");
    } else {
      _showDialog("注册失败", responseData['message'] ?? "请稍后重试");
    }
  } catch (e) {
    _showDialog("错误", "注册失败：$e");
  }
}


  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
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
            ElevatedButton(
              onPressed: _register,
              child: const Text("立即注册"),
            )
          ],
        ),
      ),
    );
  }
}
