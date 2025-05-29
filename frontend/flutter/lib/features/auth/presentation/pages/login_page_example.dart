import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/async_view.dart';
import '../providers/auth_controller.dart';

/// 登录页面示例 - 展示新 Provider 模式的使用方法
class LoginPageExample extends ConsumerStatefulWidget {
  const LoginPageExample({super.key});

  @override
  ConsumerState<LoginPageExample> createState() => _LoginPageExampleState();
}

class _LoginPageExampleState extends ConsumerState<LoginPageExample> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 使用新的 AsyncNotifier 模式监听状态
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('登录示例'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 使用 AsyncView 处理异步状态
              Expanded(
                child: AsyncView<AuthState>(
                  value: authState,
                  data: (state) => _buildLoginForm(state),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stackTrace) => _buildErrorView(error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(AuthState state) {
    if (state.isAuthenticated) {
      return _buildAuthenticatedView(state);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: '邮箱',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入邮箱';
            }
            if (!value.contains('@')) {
              return '请输入有效的邮箱地址';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: '密码',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入密码';
            }
            if (value.length < 6) {
              return '密码至少6位';
            }
            return null;
          },
        ),
        SizedBox(height: 24.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleLogin,
            child: const Text('登录'),
          ),
        ),
        SizedBox(height: 16.h),
        TextButton(
          onPressed: () {
            // 清除错误状态示例
            ref.read(authControllerProvider.notifier).clearError();
          },
          child: const Text('清除错误'),
        ),
      ],
    );
  }

  Widget _buildAuthenticatedView(AuthState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 64.w,
            color: Colors.green,
          ),
          SizedBox(height: 16.h),
          Text(
            '登录成功！',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          if (state.currentUser != null)
            Text(
              '欢迎回来，${state.currentUser!.nickname}',
              style: TextStyle(fontSize: 16.sp),
            ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
            child: const Text('登出'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.w,
            color: Colors.red,
          ),
          SizedBox(height: 16.h),
          Text(
            '登录失败',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            error.toString(),
            style: TextStyle(fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).clearError();
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }
}

/// 展示如何在其他组件中使用认证状态
class AuthStatusWidget extends ConsumerWidget {
  const AuthStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用便捷的访问器
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '认证状态',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  isAuthenticated ? Icons.check_circle : Icons.cancel,
                  color: isAuthenticated ? Colors.green : Colors.red,
                ),
                SizedBox(width: 8.w),
                Text(
                  isAuthenticated ? '已登录' : '未登录',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
            if (currentUser != null) ...[
              SizedBox(height: 8.h),
              Text(
                '用户：${currentUser.nickname}',
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
          ],
        ),
      ),
    );
  }
}