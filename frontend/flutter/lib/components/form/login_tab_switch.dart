import 'package:flutter/material.dart';

/// 登录方式切换组件
///
/// 提供验证码登录和密码登录两种方式的切换功能
class LoginTabSwitch extends StatelessWidget {
  final bool isCodeLogin;
  final ValueChanged<bool> onTabChanged;

  const LoginTabSwitch({
    Key? key,
    required this.isCodeLogin,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 获取主题色
    final primaryColor = Theme.of(context).primaryColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 验证码登录选项
          _buildTabItem(
            context: context,
            title: '验证码登录',
            isSelected: isCodeLogin,
            onTap: () => onTabChanged(true),
            primaryColor: primaryColor,
            textColor: textColor,
          ),
          // 分隔线
          Container(
            height: 16,
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.grey.withOpacity(0.3),
          ),
          // 密码登录选项
          _buildTabItem(
            context: context,
            title: '密码登录',
            isSelected: !isCodeLogin,
            onTap: () => onTabChanged(false),
            primaryColor: primaryColor,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  /// 构建单个标签项
  Widget _buildTabItem({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required Color primaryColor,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? primaryColor : textColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            // 选中的底部指示器
            Container(
              height: 3,
              width: 24,
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 