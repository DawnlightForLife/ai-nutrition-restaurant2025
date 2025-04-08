import 'package:flutter/material.dart';

/**
 * 第三方登录行组件
 * 
 * 显示微信、支付宝等第三方登录入口
 * 包含分隔线、说明文字和圆形图标按钮
 * 用于登录页面底部，提供多种登录方式选择
 */
class SocialLoginRow extends StatelessWidget {
  /// 微信登录点击回调
  /// 调用微信SDK进行第三方登录
  final VoidCallback? onWeChatLogin;
  
  /// 支付宝登录点击回调
  /// 调用支付宝SDK进行第三方登录
  final VoidCallback? onAlipayLogin;

  /**
   * 构造函数
   * 
   * @param key 组件键
   * @param onWeChatLogin 微信登录回调，可为null表示不启用微信登录
   * @param onAlipayLogin 支付宝登录回调，可为null表示不启用支付宝登录
   */
  const SocialLoginRow({
    Key? key,
    this.onWeChatLogin,
    this.onAlipayLogin,
  }) : super(key: key);

  /**
   * 构建组件UI
   * 
   * 创建包含分隔线和社交登录按钮的垂直布局
   * 
   * @param context 构建上下文
   * @return 构建的组件
   */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 分隔线和文字
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.grey[300],
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '其他登录方式',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.grey[300],
                thickness: 1,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // 社交登录按钮行
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 微信登录按钮
            _buildSocialButton(
              context,
              label: '微信登录',
              icon: _buildIconWithFallback(
                'assets/icons/wechat.png',
                Icons.wechat,
                Colors.green,
              ),
              onTap: onWeChatLogin,
            ),
            
            const SizedBox(width: 40),
            
            // 支付宝登录按钮
            _buildSocialButton(
              context,
              label: '支付宝登录',
              icon: _buildIconWithFallback(
                'assets/icons/alipay.png',
                Icons.account_balance_wallet,
                Colors.blue,
              ),
              onTap: onAlipayLogin,
            ),
          ],
        ),
      ],
    );
  }

  /**
   * 构建社交登录按钮
   * 
   * 创建圆形图标按钮和底部文字标签
   * 
   * @param context 构建上下文
   * @param label 按钮下方显示的文字
   * @param icon 按钮中心显示的图标
   * @param onTap 点击回调函数
   * @return 构建的社交登录按钮组件
   */
  Widget _buildSocialButton(
    BuildContext context, {
    required String label,
    required Widget icon,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        // 圆形按钮
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Center(
              child: icon,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // 按钮下方文字
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
  
  /**
   * 构建带有备用图标的图标组件
   * 
   * 尝试加载本地资源图标，加载失败时显示备用图标
   * 确保即使资源文件缺失，UI仍能正常显示
   * 
   * @param assetPath 资源文件路径
   * @param fallbackIcon 备用图标数据
   * @param fallbackColor 备用图标颜色
   * @return 图标组件
   */
  Widget _buildIconWithFallback(
    String assetPath,
    IconData fallbackIcon,
    Color fallbackColor,
  ) {
    return Image.asset(
      assetPath,
      width: 32,
      height: 32,
      errorBuilder: (context, error, stackTrace) {
        // 图片加载失败时显示备用图标
        return Icon(
          fallbackIcon,
          size: 28,
          color: fallbackColor,
        );
      },
    );
  }
} 