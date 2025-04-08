import 'package:flutter/material.dart';

/**
 * 登录方式切换组件
 * 
 * 提供验证码登录和密码登录两种方式的切换功能
 * 以标签页的形式展示，支持选中状态高亮显示
 * 适用于登录页面中切换不同登录方式的场景
 */
class LoginTabSwitch extends StatelessWidget {
  /// 当前是否为验证码登录模式
  /// true表示验证码登录，false表示密码登录
  final bool isCodeLogin;
  
  /// 标签切换回调函数
  /// 当用户点击切换标签时触发，参数表示是否切换到验证码登录
  final ValueChanged<bool> onTabChanged;

  /**
   * 构造函数
   * 
   * @param key 组件键
   * @param isCodeLogin 是否为验证码登录模式
   * @param onTabChanged 标签切换回调函数
   */
  const LoginTabSwitch({
    Key? key,
    required this.isCodeLogin,
    required this.onTabChanged,
  }) : super(key: key);

  /**
   * 构建组件UI
   * 
   * 创建包含两个标签的切换组件，根据当前选择状态显示不同样式
   * 
   * @param context 构建上下文
   * @return 构建的组件
   */
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

  /**
   * 构建单个标签项
   * 
   * 创建可点击的标签项，包含标题文本和底部指示器
   * 根据选中状态显示不同的颜色和字体粗细
   * 
   * @param context 构建上下文
   * @param title 标签标题
   * @param isSelected 是否选中
   * @param onTap 点击回调
   * @param primaryColor 主题色，用于选中状态
   * @param textColor 文本颜色，用于非选中状态
   * @return 构建的标签项组件
   */
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
            // 标签文本
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? primaryColor : textColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            // 底部指示器，选中时显示主题色，未选中时透明
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