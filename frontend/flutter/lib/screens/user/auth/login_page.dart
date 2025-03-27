import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:provider/provider.dart';
import '../../../providers/index.dart';
import '../../../models/index.dart';
import '../../../constants/api.dart';
import '../../../utils/api_helper.dart';
import '../../../utils/logger.dart';

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
      ApiHelper.showErrorDialog(context, "请输入手机号和密码");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // 使用API常量中定义的基础URL和路径
      final url = '${ApiConstants.baseUrl}${ApiConstants.userLoginPath}';
      
      // 使用统一的API调用和日志记录
      final responseData = await ApiHelper.post(
        url,
        data: {"phone": phone, "password": password},
        logPrefix: Logger.AUTH,
        timeout: ApiConstants.connectionTimeout,
      );

      if (responseData['success'] == true) {
        // 保存用户信息到Provider
        if(responseData['user'] != null && responseData['token'] != null) {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          
          final userId = responseData['user']['id'] ?? responseData['user']['_id'];
          Logger.i(Logger.AUTH, '登录成功，令牌长度: ${responseData['token'].length}');
          Logger.i(Logger.AUTH, '用户ID: $userId, 昵称: ${responseData['user']['nickname']}');
          
          try {
            final user = User.fromJson(responseData['user']);
            Logger.i(Logger.AUTH, '用户对象创建成功: $user');
            userProvider.login(user, responseData['token']);
            
            // 检查用户角色，如果是管理员，导航到管理员页面
            if (responseData['user']['role'] == 'admin') {
              ApiHelper.showSuccessSnackBar(context, '管理员登录成功！');
              
              // 延迟一小段时间再跳转，让用户能看到提示
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.pushReplacementNamed(context, '/admin/home');
              });
            } else {
              // 非管理员用户，显示普通登录成功提示，跳转到主页
              ApiHelper.showSuccessSnackBar(context, '登录成功！');
              
              // 延迟一小段时间再跳转，让用户能看到提示
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.pushReplacementNamed(context, '/home');
              });
            }
          } catch (e) {
            Logger.e(Logger.AUTH, '创建用户对象失败', e);
            Logger.d(Logger.AUTH, '用户数据: ${responseData['user']}');
            ApiHelper.showErrorDialog(context, "登录处理错误: $e");
          }
        } else {
          Logger.w(Logger.AUTH, '响应缺少用户数据或令牌');
          ApiHelper.showErrorDialog(context, responseData['message'] ?? "登录返回数据不完整");
        }
      } else {
        Logger.w(Logger.AUTH, '登录失败: ${responseData['message']}');
        ApiHelper.showErrorDialog(context, responseData['message'] ?? "登录失败");
      }
    } catch (e) {
      Logger.e(Logger.AUTH, '登录出错', e);
      ApiHelper.showErrorDialog(context, "网络错误: $e");
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
          "role": "user", // 默认为普通用户
        },
        "token": "mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}",
      };

      // 保存用户信息到Provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(mockResponseData['user']);
      userProvider.setToken(mockResponseData['token']);
      
      // 检查角色，但第三方登录默认不会有管理员角色
      // 这里为了完整性保留逻辑
      if (mockResponseData['user']['role'] == 'admin') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('管理员登录成功！'), 
            duration: Duration(seconds: 1)
          ),
        );
        
        // 跳转到管理员主页
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacementNamed(context, '/admin/home');
        });
      } else {
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
      }
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
              const Row(
                children: [
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
