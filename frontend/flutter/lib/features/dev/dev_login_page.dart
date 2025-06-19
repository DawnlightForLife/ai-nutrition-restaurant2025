import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../auth/presentation/providers/auth_provider.dart';
import '../auth/data/models/auth_state.dart';
import '../../config/app_constants.dart';

/// 开发环境快速登录页面
/// 仅在开发环境可用
class DevLoginPage extends ConsumerStatefulWidget {
  const DevLoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DevLoginPage> createState() => _DevLoginPageState();
}

class _DevLoginPageState extends ConsumerState<DevLoginPage> {
  String selectedRole = 'store_manager';
  bool isLoading = false;

  final List<Map<String, String>> roles = [
    {'value': 'user', 'label': '普通用户'},
    {'value': 'store_manager', 'label': '门店管理员'},
    {'value': 'merchant', 'label': '商家'},
    {'value': 'admin', 'label': '系统管理员'},
    {'value': 'nutritionist', 'label': '营养师'},
  ];

  Future<void> _quickLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      final dio = Dio();
      final response = await dio.post(
        '${AppConstants.apiBaseUrl}/dev/auth/quick-login',
        data: {'role': selectedRole},
      );

      if (response.data['success']) {
        final token = response.data['token'];
        final userData = response.data['user'];
        
        // 保存到认证状态
        final authNotifier = ref.read(authStateProvider.notifier);
        final secureStorage = ref.read(secureStorageProvider);
        
        await secureStorage.write(key: 'auth_token', value: token);
        
        // 更新认证状态
        authNotifier.state = authNotifier.state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          token: token,
          user: UserInfo.fromJson(userData),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('已切换到${_getRoleLabel(selectedRole)}角色'),
              backgroundColor: Colors.green,
            ),
          );
          
          // 跳转到首页
          Navigator.of(context).pushReplacementNamed('/');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('登录失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getRoleLabel(String role) {
    return roles.firstWhere(
      (r) => r['value'] == role,
      orElse: () => {'label': role},
    )['label']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('开发环境快速登录'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚠️ 开发环境专用',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '此功能仅在开发环境可用，可以快速切换到不同角色进行测试。',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '选择角色',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...roles.map((role) => Card(
              child: RadioListTile<String>(
                title: Text(role['label']!),
                subtitle: Text('角色: ${role['value']}'),
                value: role['value']!,
                groupValue: selectedRole,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
              ),
            )).toList(),
            const Spacer(),
            ElevatedButton(
              onPressed: isLoading ? null : _quickLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('登录为 ${_getRoleLabel(selectedRole)}'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: const Text('返回正常登录'),
            ),
          ],
        ),
      ),
    );
  }
}