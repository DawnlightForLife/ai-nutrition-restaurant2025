import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/screens/auth/login_page.dart';

final loginScreenComponent = WidgetbookComponent(
  name: '登录页面',
  useCases: [
    WidgetbookUseCase(
      name: '默认状态',
      builder: (context) {
        return const ProviderScope(
          child: LoginPage(),
        );
      },
    ),
    WidgetbookUseCase(
      name: '模拟状态',
      builder: (context) {
        final showError = context.knobs.boolean(
          label: '显示错误提示',
          initialValue: false,
        );
        
        final isLoading = context.knobs.boolean(
          label: '加载中',
          initialValue: false,
        );
        
        return ProviderScope(
          child: Stack(
            children: [
              const LoginPage(),
              if (showError)
                Positioned(
                  bottom: 100,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '登录失败：手机号或密码错误',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      },
    ),
  ],
);