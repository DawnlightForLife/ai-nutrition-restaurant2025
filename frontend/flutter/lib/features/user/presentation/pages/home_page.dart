import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// 用户主页 - 登录后的主界面
class MainHomePage extends ConsumerStatefulWidget {
  const MainHomePage({super.key});

  @override
  ConsumerState<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends ConsumerState<MainHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养立方'),
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: 跳转到通知页面
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBody() {
    final pages = [
      _buildHomePage(),
      _buildNutritionPage(),
      _buildForumPage(), 
      _buildOrderPage(),
      _buildProfilePage(),
    ];
    
    return pages[_selectedIndex];
  }

  Widget _buildHomePage() {
    final authState = ref.watch(authStateProvider);
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // 用户问候
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryOrange,
                  AppColors.primaryOrange.withOpacity(0.8),
                ],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '你好，${authState.user?.nickname ?? "用户"}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '开始您的智能营养之旅',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          
          // 功能入口
          const _FunctionEntriesWidget(),
          
          // 今日推荐
          const _RecommendationWidget(),
        ],
      ),
    );
  }

  Widget _buildNutritionPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('营养管理', style: TextStyle(fontSize: 18)),
          Text('功能开发中...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildForumPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('营养论坛', style: TextStyle(fontSize: 18)),
          Text('功能开发中...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildOrderPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('我的订单', style: TextStyle(fontSize: 18)),
          Text('功能开发中...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('个人中心', style: TextStyle(fontSize: 18)),
          Text('功能开发中...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      selectedItemColor: AppColors.primaryOrange,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '首页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
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

class _FunctionEntriesWidget extends StatelessWidget {
  const _FunctionEntriesWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '快捷功能',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _FunctionEntry(
                icon: Icons.restaurant_menu,
                label: '营养档案',
                color: AppColors.primaryOrange,
                onTap: () {
                  // TODO: 跳转到营养档案
                },
              ),
              _FunctionEntry(
                icon: Icons.psychology,
                label: 'AI推荐',
                color: AppColors.secondaryGreen,
                onTap: () {
                  // TODO: 跳转到AI推荐
                },
              ),
              _FunctionEntry(
                icon: Icons.forum,
                label: '营养论坛',
                color: Colors.blue,
                onTap: () {
                  // TODO: 跳转到论坛
                },
              ),
              _FunctionEntry(
                icon: Icons.chat,
                label: '专家咨询',
                color: Colors.purple,
                onTap: () {
                  // TODO: 跳转到咨询
                },
              ),
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
  final Color color;
  final VoidCallback onTap;

  const _FunctionEntry({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RecommendationWidget extends StatelessWidget {
  const _RecommendationWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: AppColors.primaryOrange),
              const SizedBox(width: 8),
              const Text(
                '今日推荐',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb, color: AppColors.primaryOrange, size: 32),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '智能营养建议',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '基于您的健康数据，为您推荐个性化营养方案',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

