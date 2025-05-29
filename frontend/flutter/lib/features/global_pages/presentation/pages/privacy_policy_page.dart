import 'package:flutter/material.dart';

/// 隐私政策页面
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('隐私政策'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '隐私政策',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '更新日期：2024年1月15日',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            _PolicySection(
              title: '1. 信息收集',
              content: '我们收集您主动提供的信息，包括但不限于：\n'
                  '• 注册信息（手机号、昵称等）\n'
                  '• 营养档案信息（身高、体重、饮食偏好等）\n'
                  '• 使用记录和偏好设置',
            ),
            SizedBox(height: 20),
            _PolicySection(
              title: '2. 信息使用',
              content: '我们使用收集的信息用于：\n'
                  '• 提供个性化营养推荐服务\n'
                  '• 改善产品功能和用户体验\n'
                  '• 与营养师匹配咨询服务\n'
                  '• 发送服务相关通知',
            ),
            SizedBox(height: 20),
            _PolicySection(
              title: '3. 信息保护',
              content: '我们采取以下措施保护您的个人信息：\n'
                  '• 数据加密存储\n'
                  '• 严格的访问控制\n'
                  '• 定期安全审计\n'
                  '• 员工保密协议',
            ),
            SizedBox(height: 20),
            _PolicySection(
              title: '4. 信息共享',
              content: '除以下情况外，我们不会与第三方共享您的个人信息：\n'
                  '• 获得您的明确同意\n'
                  '• 法律法规要求\n'
                  '• 保护公司合法权益\n'
                  '• 与合作营养师共享必要信息以提供咨询服务',
            ),
            SizedBox(height: 20),
            _PolicySection(
              title: '5. 您的权利',
              content: '您有权：\n'
                  '• 查看和更新个人信息\n'
                  '• 删除个人账户\n'
                  '• 撤回同意授权\n'
                  '• 投诉和举报',
            ),
            SizedBox(height: 20),
            _PolicySection(
              title: '6. 联系我们',
              content: '如有隐私相关问题，请联系我们：\n'
                  '• 邮箱：privacy@nutrition-app.com\n'
                  '• 电话：400-123-4567\n'
                  '• 地址：北京市朝阳区xxx街道xxx号',
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String content;

  const _PolicySection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}