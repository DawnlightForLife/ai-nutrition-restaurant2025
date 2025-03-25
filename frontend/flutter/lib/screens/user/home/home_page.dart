import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/index.dart';
import '../profile/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  // 检查用户是否登录，如果未登录且需要登录的功能，则显示登录提示
  bool _handleLoginCheck(int index) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // 需要登录的功能索引（AI推荐、订单管理）
    final List<int> requireLoginIndexes = [1, 3];
    
    if (!userProvider.isLoggedIn && requireLoginIndexes.contains(index)) {
      _showLoginDialog();
      return false;
    }
    
    return true;
  }
  
  // 显示登录提示对话框
  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('需要登录'),
        content: const Text('您需要登录才能使用此功能'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
            child: const Text('去登录'),
          ),
        ],
      ),
    );
  }
  
  // 主页内容
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部横幅
          Container(
            width: double.infinity,
            height: 180,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Opacity(
                    opacity: 0.2,
                    child: Icon(
                      Icons.restaurant,
                      size: 150,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '智慧AI营养餐厅',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '探索个性化健康饮食方案',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // 检查登录状态
                          if (_handleLoginCheck(1)) {
                            setState(() {
                              _selectedIndex = 1; // 切换到AI推荐页面
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text('获取推荐方案'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 功能区
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '热门推荐',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(5, (index) {
                      return _buildFoodCard(
                        '套餐 ${index + 1}',
                        '${index * 10 + 30}元',
                        '营养均衡的健康套餐',
                        Icons.set_meal,
                      );
                    }),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                const Text(
                  '营养知识',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildArticleCard(
                  '科学饮食的5个关键原则',
                  '了解如何科学安排一日三餐，掌握健康饮食的关键要点...',
                  Icons.book,
                ),
                const SizedBox(height: 12),
                _buildArticleCard(
                  '季节性食材选购指南',
                  '夏季应该选择哪些应季蔬果？如何挑选最新鲜的食材...',
                  Icons.eco,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // 食物卡片
  Widget _buildFoodCard(String title, String price, String desc, IconData icon) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 50,
                color: Colors.green,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // 文章卡片
  Widget _buildArticleCard(String title, String desc, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 30,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
  
  // AI推荐页面
  Widget _buildAiRecommendationContent() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // 未登录状态
    if (!userProvider.isLoggedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant_menu,
              size: 70,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              'AI营养餐推荐',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '登录后可获取专属您的个性化餐饮方案',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              icon: const Icon(Icons.login),
              label: const Text('去登录'),
            ),
          ],
        ),
      );
    }
    
    // 已登录状态
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.restaurant_menu,
            size: 70,
            color: Colors.green,
          ),
          const SizedBox(height: 24),
          const Text(
            'AI营养餐推荐',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '欢迎，${userProvider.user?.nickname ?? '用户'}！\n根据您的健康数据，为您推荐个性化餐饮方案',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/nutrition/profiles');
            },
            icon: const Icon(Icons.add),
            label: const Text('创建营养档案'),
          ),
        ],
      ),
    );
  }
  
  // 社区页面
  Widget _buildCommunityContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.forum,
            size: 70,
            color: Colors.green,
          ),
          const SizedBox(height: 24),
          const Text(
            '社区论坛',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '与其他用户分享您的健康餐饮心得',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // 发帖需要登录
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              if (userProvider.isLoggedIn) {
                _showFeatureComingSoon('发帖功能');
              } else {
                _showLoginDialog();
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('发布帖子'),
          ),
        ],
      ),
    );
  }
  
  // 订单页面
  Widget _buildOrderContent() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // 未登录状态
    if (!userProvider.isLoggedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart,
              size: 70,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              '您的订单',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '登录后查看您的购物车和历史订单',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              icon: const Icon(Icons.login),
              label: const Text('去登录'),
            ),
          ],
        ),
      );
    }
    
    // 已登录状态
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart,
            size: 70,
            color: Colors.green,
          ),
          const SizedBox(height: 24),
          const Text(
            '您的订单',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '查看您的购物车和历史订单',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              _showFeatureComingSoon('订单功能');
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('立即订购'),
          ),
        ],
      ),
    );
  }
  
  // 显示功能即将上线提示
  void _showFeatureComingSoon(String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$featureName 即将上线'),
        content: const Text('此功能正在开发中，敬请期待！'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }
  
  static const List<String> _pageTitles = <String>[
    '首页',
    'AI营养推荐',
    '社区论坛',
    '订单管理',
    '个人中心',
  ];
  
  @override
  Widget build(BuildContext context) {
    final List<Widget> _pageWidgets = <Widget>[
      _buildHomeContent(),
      _buildAiRecommendationContent(),
      _buildCommunityContent(),
      _buildOrderContent(),
      const ProfilePage(),
    ];
    
    return Scaffold(
      appBar: _selectedIndex != 0 && _selectedIndex != 4 ? AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: 实现消息通知中心
            },
          ),
        ],
      ) : null,
      body: _pageWidgets[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'AI推荐',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: '社区',
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
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // 检查需要登录的页面
          if (_handleLoginCheck(index)) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
} 