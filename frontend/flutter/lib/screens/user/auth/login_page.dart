import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../../providers/index.dart';
import '../../../constants/api.dart';

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
      // 使用API常量中定义的基础URL
      final url = Uri.parse('${ApiConstants.baseUrl}/api/users/login');
      
      print('正在请求URL: $url'); // 添加调试信息
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phone, "password": password}),
      ).timeout(const Duration(seconds: 10)); // 添加超时处理
      
      print('收到响应状态码: ${response.statusCode}'); // 添加调试信息
      
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('响应数据: $responseData'); // 添加调试信息

      if (response.statusCode == 200 && responseData['success'] == true) {
        // 保存用户信息到Provider
        if(responseData['user'] != null && responseData['token'] != null) {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(responseData['user']);
          userProvider.setToken(responseData['token']);
        }
        
        // 登录成功，显示简短提示，然后跳转到主页
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('登录成功！'), duration: Duration(seconds: 1)),
        );
        
        // 延迟一小段时间再跳转，让用户能看到提示
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacementNamed(context, '/home');
        });
      } else {
        _showDialog(responseData['message'] ?? "登录失败");
      }
    } catch (e) {
      print('登录出错: $e'); // 添加调试信息
      _showDialog("网络错误：$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 模拟第三方登录
  Future<void> _thirdPartyLogin(String provider) async {
    setState(() {
      isLoading = true;
    });

    try {
      // 模拟网络请求延迟
      await Future.delayed(const Duration(seconds: 1));

      // 测试数据：模拟从第三方获取的用户信息
      final Map<String, dynamic> mockUserData = {
        "id": "mock_${provider}_user_123",
        "nickname": provider == "wechat" ? "微信用户" : "支付宝用户",
        "phone": "13800138000",
        "email": "$provider@example.com",
        "avatarUrl": "https://example.com/avatar.jpg",
      };

      // 模拟向后端发送第三方登录信息的请求
      print('模拟第三方登录: $provider');

      // 构造虚拟响应数据
      final Map<String, dynamic> mockResponseData = {
        "success": true,
        "message": "登录成功",
        "user": {
          "_id": "mock_user_id_${DateTime.now().millisecondsSinceEpoch}",
          "nickname": mockUserData["nickname"],
          "phone": mockUserData["phone"],
          "email": mockUserData["email"],
        },
        "token": "mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}",
      };

      // 保存用户信息到Provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(mockResponseData['user']);
      userProvider.setToken(mockResponseData['token']);
      
      // 显示登录成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$provider 登录成功！'), 
          duration: const Duration(seconds: 1)
        ),
      );
      
      // 跳转到主页
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacementNamed(context, '/home');
      });
    } catch (e) {
      print('第三方登录出错: $e');
      _showDialog("登录失败: $e");
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Logo
              const Center(
                child: Icon(
                  Icons.restaurant,
                  size: 80,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "智慧AI营养餐厅",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // 手机号输入框
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "手机号",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              // 密码输入框
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "密码",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              
              // 忘记密码
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _showDialog("密码重置功能正在开发中");
                  },
                  child: const Text("忘记密码？"),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 登录按钮
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        "登录",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
              
              const SizedBox(height: 16),
              
              // 注册链接
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("还没有账号？"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text("立即注册"),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // 分割线
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("其他登录方式", style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // 第三方登录按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 微信登录
                  InkWell(
                    onTap: () => _thirdPartyLogin("wechat"),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1AAD19),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.wechat,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 40),
                  
                  // 支付宝登录
                  InkWell(
                    onTap: () => _thirdPartyLogin("alipay"),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1677FF),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // 游客模式
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text(
                    "游客模式",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
