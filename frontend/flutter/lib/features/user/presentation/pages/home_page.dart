import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 用户主页
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养餐厅'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: 跳转到通知页面
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // TODO: 添加活动横幅
            _ActivityBannerWidget(),
            // TODO: 添加功能入口
            _FunctionEntriesWidget(),
            // TODO: 添加推荐内容
            _RecommendationWidget(),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNavigationWidget(),
    );
  }
}

class _ActivityBannerWidget extends StatelessWidget {
  const _ActivityBannerWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text('活动横幅'),
      ),
    );
  }
}

class _FunctionEntriesWidget extends StatelessWidget {
  const _FunctionEntriesWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '功能入口',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _FunctionEntry(icon: Icons.restaurant, label: '营养档案'),
              _FunctionEntry(icon: Icons.recommend, label: 'AI推荐'),
              _FunctionEntry(icon: Icons.forum, label: '论坛'),
              _FunctionEntry(icon: Icons.chat, label: '咨询'),
            ],
          ),
        ],
      ),
    );
  }
}

class _FunctionEntry extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FunctionEntry({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

class _RecommendationWidget extends StatelessWidget {
  const _RecommendationWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '今日推荐',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('推荐内容将在这里显示'),
        ],
      ),
    );
  }
}

class _BottomNavigationWidget extends StatelessWidget {
  const _BottomNavigationWidget();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '首页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          label: '营养',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum),
          label: '论坛',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: '订单',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '我的',
        ),
      ],
    );
  }
}