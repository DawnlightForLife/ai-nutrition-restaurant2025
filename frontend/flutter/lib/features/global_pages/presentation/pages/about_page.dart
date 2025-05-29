import 'package:flutter/material.dart';

/// 关于我们页面
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于我们'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            
            // Logo和应用名称
            _AppLogoSection(),
            SizedBox(height: 40),
            
            // 应用介绍
            _AppDescriptionSection(),
            SizedBox(height: 40),
            
            // 功能特色
            _FeaturesSection(),
            SizedBox(height: 40),
            
            // 团队介绍
            _TeamSection(),
            SizedBox(height: 40),
            
            // 联系方式
            _ContactSection(),
            SizedBox(height: 40),
            
            // 版本信息
            _VersionSection(),
          ],
        ),
      ),
    );
  }
}

class _AppLogoSection extends StatelessWidget {
  const _AppLogoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.restaurant_menu,
            size: 50,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '智能营养餐厅',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'AI驱动的个性化营养推荐平台',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _AppDescriptionSection extends StatelessWidget {
  const _AppDescriptionSection();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '我们的使命',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '致力于通过人工智能技术，为每个人提供个性化的营养健康解决方案，让健康饮食变得简单易行。我们相信，科技的力量能够让营养健康服务更加便民、专业、有效。',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '核心功能',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildFeatureCard(
          icon: Icons.psychology,
          title: 'AI智能推荐',
          description: '基于个人营养档案和饮食偏好，智能推荐最适合的餐食搭配',
        ),
        const SizedBox(height: 12),
        _buildFeatureCard(
          icon: Icons.person,
          title: '专业营养师',
          description: '认证营养师提供一对一专业咨询，解答营养健康问题',
        ),
        const SizedBox(height: 12),
        _buildFeatureCard(
          icon: Icons.group,
          title: '健康社区',
          description: '与志同道合的朋友分享健康生活经验，互相鼓励进步',
        ),
        const SizedBox(height: 12),
        _buildFeatureCard(
          icon: Icons.restaurant,
          title: '餐厅合作',
          description: '与优质餐厅合作，提供健康美味的营养餐食选择',
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamSection extends StatelessWidget {
  const _TeamSection();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '团队介绍',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '我们是一支由营养学专家、人工智能工程师和产品设计师组成的专业团队。团队成员来自知名院校和科技公司，拥有丰富的营养健康和技术开发经验。',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '联系我们',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              icon: Icons.email,
              label: '邮箱',
              value: 'contact@nutrition-app.com',
            ),
            _buildContactItem(
              icon: Icons.phone,
              label: '客服热线',
              value: '400-123-4567',
            ),
            _buildContactItem(
              icon: Icons.location_on,
              label: '地址',
              value: '北京市朝阳区xxx街道xxx号',
            ),
            _buildContactItem(
              icon: Icons.language,
              label: '官网',
              value: 'www.nutrition-app.com',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionSection extends StatelessWidget {
  const _VersionSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Divider(),
        SizedBox(height: 16),
        Text(
          '版本 1.0.0',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '© 2024 智能营养餐厅. 保留所有权利.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}