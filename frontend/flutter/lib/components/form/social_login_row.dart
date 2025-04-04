import 'package:flutter/material.dart';

/// 第三方登录行组件
///
/// 显示微信和支付宝等第三方登录入口
class SocialLoginRow extends StatelessWidget {
  final VoidCallback? onWeChatLogin;
  final VoidCallback? onAlipayLogin;

  const SocialLoginRow({
    Key? key,
    this.onWeChatLogin,
    this.onAlipayLogin,
  }) : super(key: key);

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
        
        // 社交登录按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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

  /// 构建社交登录按钮
  Widget _buildSocialButton(
    BuildContext context, {
    required String label,
    required Widget icon,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
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
  
  /// 构建带有备用图标的图标组件
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
        return Icon(
          fallbackIcon,
          size: 28,
          color: fallbackColor,
        );
      },
    );
  }
} 