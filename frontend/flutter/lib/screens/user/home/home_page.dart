import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/core/auth_provider.dart';
import '../../../widgets/common/loading_indicator.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (authProvider.isLoading) {
      return const Scaffold(
        body: LoadingIndicator(message: '加载中...'),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI营养餐厅'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // 通知中心
              // TODO: 实现通知功能
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(context),
            _buildMainFeatures(context),
            _buildDailyRecommendation(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            activeIcon: Icon(Icons.restaurant_menu),
            label: '点餐',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            activeIcon: Icon(Icons.forum),
            label: '论坛',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // 已在首页
              break;
            case 1:
              Navigator.pushNamed(context, '/order');
              break;
            case 2:
              Navigator.pushNamed(context, '/forum');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade300, Colors.green.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/healthy_food_bg.jpg', // 请确保有这个资源文件
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '智能营养分析',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '个性化的餐饮推荐，让健康饮食更简单',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/nutrition-analysis');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('立即体验'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainFeatures(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '功能服务',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            childAspectRatio: 0.8,
            children: [
              _buildFeatureItem(
                context,
                icon: Icons.restaurant,
                label: '点餐',
                onTap: () => Navigator.pushNamed(context, '/order'),
              ),
              _buildFeatureItem(
                context,
                icon: Icons.forum,
                label: '健康论坛',
                onTap: () => Navigator.pushNamed(context, '/forum'),
              ),
              _buildFeatureItem(
                context,
                icon: Icons.assessment,
                label: '营养报告',
                onTap: () => Navigator.pushNamed(context, '/nutrition-reports'),
              ),
              _buildFeatureItem(
                context,
                icon: Icons.history,
                label: '历史记录',
                onTap: () => Navigator.pushNamed(context, '/history'),
              ),
              _buildFeatureItem(
                context,
                icon: Icons.person_outline,
                label: '健康档案',
                onTap: () => Navigator.pushNamed(context, '/health-profiles'),
              ),
              _buildFeatureItem(
                context,
                icon: Icons.medical_services_outlined,
                label: '营养师咨询',
                onTap: () => Navigator.pushNamed(context, '/nutritionist-consultation'),
              ),
              _buildFeatureItem(
                context,
                icon: Icons.receipt_outlined,
                label: '我的订单',
                onTap: () => Navigator.pushNamed(context, '/orders'),
              ),
              _buildFeatureItem(
                context,
                icon: Icons.more_horiz,
                label: '更多服务',
                onTap: () {
                  // 显示更多服务菜单
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _buildMoreServicesSheet(context),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.green.shade700,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMoreServicesSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '更多服务',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildServiceItem(
                context,
                icon: Icons.fitness_center,
                label: '运动建议',
                onTap: () => Navigator.pushNamed(context, '/fitness-advice'),
              ),
              _buildServiceItem(
                context,
                icon: Icons.volunteer_activism,
                label: '健康知识',
                onTap: () => Navigator.pushNamed(context, '/health-knowledge'),
              ),
              _buildServiceItem(
                context,
                icon: Icons.event_note,
                label: '饮食日记',
                onTap: () => Navigator.pushNamed(context, '/food-diary'),
              ),
              _buildServiceItem(
                context,
                icon: Icons.restaurant_menu,
                label: '食谱库',
                onTap: () => Navigator.pushNamed(context, '/recipes'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyRecommendation(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '今日推荐',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // 查看更多推荐
                    Navigator.pushNamed(context, '/recommendations');
                  },
                  child: const Text('查看更多'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildRecommendationCard(
                  context,
                  title: '夏日清爽沙拉',
                  description: '低热量高纤维，让你清凉一夏',
                  imagePath: 'assets/images/salad.jpg',
                  onTap: () {
                    // 查看详情
                    Navigator.pushNamed(context, '/dish-details');
                  },
                ),
                _buildRecommendationCard(
                  context,
                  title: '蛋白质能量餐',
                  description: '增肌减脂，营养均衡',
                  imagePath: 'assets/images/protein_meal.jpg',
                  onTap: () {
                    // 查看详情
                    Navigator.pushNamed(context, '/dish-details');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context, {
    required String title,
    required String description,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
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
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
