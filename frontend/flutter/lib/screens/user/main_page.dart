import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/core/auth_provider.dart';
import '../user/forum/forum_home_page.dart';
import '../user/profile/profile_page.dart';  // 添加个人中心页面导入

/// 用户主页面
///
/// 用户登录成功后的主页面，包含底部导航栏和各个功能板块
class MainPage extends StatefulWidget {
  static const String routeName = '/user/main';

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // 底部导航项配置
  final List<Map<String, dynamic>> _navigationItems = [
    {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': '首页'},
    {'icon': Icons.restaurant_menu_outlined, 'activeIcon': Icons.restaurant_menu, 'label': '点餐'},
    {'icon': Icons.forum_outlined, 'activeIcon': Icons.forum, 'label': '论坛'},
    {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': '我的'},
  ];

  // 页面内容列表
  final List<Widget> _pages = [
    const _HomePagePlaceholder(),
    const Center(child: Text('点餐页面')), // Placeholder for Ordering page
    const ForumHomePage(),
    const ProfilePage(), // 使用实际的个人中心页面
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 2 
          ? null // 论坛页面有自己的AppBar
          : AppBar(
              title: const Text('AI营养餐厅'),
              automaticallyImplyLeading: false, // 禁用自动返回按钮
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    Navigator.pushNamed(context, '/user/notifications');
                  },
                ),
              ],
            ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: _navigationItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item['icon']),
            activeIcon: Icon(item['activeIcon']),
            label: item['label'],
          );
        }).toList(),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// 首页占位组件
class _HomePagePlaceholder extends StatelessWidget {
  const _HomePagePlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 顶部横幅
          Container(
            width: double.infinity,
            height: 180,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade300,
                  Colors.green.shade600,
                ],
              ),
            ),
            child: Stack(
              children: [
                // 添加装饰图形
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),
                Positioned(
                  left: -30,
                  bottom: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        '智能营养分析',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '个性化的餐饮推荐，让健康饮食更简单',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/user/health/profiles');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('立即体验'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 功能模块
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '功能服务',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _showAllServices(context);
                      },
                      child: const Text('查看全部'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildFeatureItem(
                      context,
                      icon: Icons.restaurant,
                      label: '点餐',
                      onTap: () {
                        final mainState = context.findAncestorStateOfType<_MainPageState>();
                        if (mainState != null) {
                          mainState.setState(() {
                            mainState._currentIndex = 1;
                          });
                        }
                      },
                    ),
                    _buildFeatureItem(
                      context,
                      icon: Icons.person_outline,
                      label: '健康档案',
                      onTap: () {
                        Navigator.pushNamed(context, '/user/health/profiles');
                      },
                    ),
                    _buildFeatureItem(
                      context,
                      icon: Icons.medical_services_outlined,
                      label: '营养师咨询',
                      onTap: () {
                        Navigator.pushNamed(context, '/user/consult');
                      },
                    ),
                    _buildFeatureItem(
                      context,
                      icon: Icons.assessment,
                      label: '营养报告',
                      onTap: () {
                        Navigator.pushNamed(context, '/user/health/reports');
                      },
                    ),
                    _buildFeatureItem(
                      context,
                      icon: Icons.receipt_outlined,
                      label: '我的订单',
                      onTap: () {
                        Navigator.pushNamed(context, '/user/orders');
                      },
                    ),
                    _buildFeatureItem(
                      context,
                      icon: Icons.favorite_outline,
                      label: '我的收藏',
                      onTap: () {
                        Navigator.pushNamed(context, '/user/favorites');
                      },
                    ),
                    _buildFeatureItem(
                      context,
                      icon: Icons.event_note,
                      label: '饮食日记',
                      onTap: () {
                        Navigator.pushNamed(context, '/user/health/diary');
                      },
                    ),
                    _buildFeatureItem(
                      context,
                      icon: Icons.menu_book_outlined,
                      label: '食谱库',
                      onTap: () {
                        Navigator.pushNamed(context, '/user/recommendation/recipes');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 今日推荐
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                        _showFeatureInDevelopment(context, '更多推荐');
                      },
                      child: const Text('更多推荐'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildPlaceholderFoodCard(
                        context, 
                        title: '夏日清爽沙拉',
                        description: '低热量高纤维，让你清凉一夏',
                      ),
                      const SizedBox(width: 16),
                      _buildPlaceholderFoodCard(
                        context,
                        title: '蛋白质能量餐',
                        description: '增肌减脂，营养均衡',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 健康资讯
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '健康资讯',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final mainState = context.findAncestorStateOfType<_MainPageState>();
                        if (mainState != null) {
                          mainState.setState(() {
                            mainState._currentIndex = 2;  // 切换到论坛标签
                          });
                        }
                      },
                      child: const Text('查看更多'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildArticleItem(
                  context,
                  title: '夏季饮食指南：如何在炎热天气保持健康',
                  date: '2小时前',
                  onTap: () {
                    _showFeatureInDevelopment(context, '健康文章');
                  },
                ),
                const Divider(),
                _buildArticleItem(
                  context,
                  title: '每日蛋白质摄入：多少才是最佳？',
                  date: '昨天',
                  onTap: () {
                    _showFeatureInDevelopment(context, '健康文章');
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  // 构建功能项
  Widget _buildFeatureItem(BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: () {
        // 检查路由是否已实现
        final implementedRoutes = [
          '/user/health/profiles',  // 健康档案
          '/user/orders',           // 我的订单
        ];
        
        // 获取要导航到的路由
        String targetRoute = '';
        if (label == '点餐') {
          final mainState = context.findAncestorStateOfType<_MainPageState>();
          if (mainState != null) {
            mainState.setState(() {
              mainState._currentIndex = 1;
            });
            return;
          }
        } else if (label == '健康档案') {
          targetRoute = '/user/health/profiles';
        } else if (label == '营养师咨询') {
          targetRoute = '/user/consult';
        } else if (label == '营养报告') {
          targetRoute = '/user/health/reports';
        } else if (label == '我的订单') {
          targetRoute = '/user/orders';
        } else if (label == '我的收藏') {
          targetRoute = '/user/favorites';
        } else if (label == '饮食日记') {
          targetRoute = '/user/health/diary';
        } else if (label == '食谱库') {
          targetRoute = '/user/recommendation/recipes';
        } else if (label == '健康论坛') {
          final mainState = context.findAncestorStateOfType<_MainPageState>();
          if (mainState != null) {
            mainState.setState(() {
              mainState._currentIndex = 2;
            });
            return;
          }
        }
        
        // 如果是已实现的路由，直接导航
        if (implementedRoutes.contains(targetRoute)) {
          Navigator.pushNamed(context, targetRoute);
        } else {
          // 否则显示功能开发中的提示
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label功能正在开发中，敬请期待！'),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor ?? Colors.green.shade700,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
  
  // 构建食物卡片
  Widget _buildFoodCard(BuildContext context, {
    required String imageUrl,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                imageUrl,
                width: 200,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 200,
                  height: 120,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported, size: 30),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
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
          ],
        ),
      ),
    );
  }
  
  // 构建文章条目
  Widget _buildArticleItem(BuildContext context, {
    required String title,
    required String date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 80,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.article,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 显示所有服务
  void _showAllServices(BuildContext context) {
    final implementedRoutes = [
      '/user/health/profiles',  // 健康档案
      '/user/orders',           // 我的订单
    ];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.2,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '全部服务',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildAllServiceItem(context, '点餐', Icons.restaurant, () {
                      Navigator.pop(context);
                      final mainState = context.findAncestorStateOfType<_MainPageState>();
                      if (mainState != null) {
                        mainState.setState(() {
                          mainState._currentIndex = 1;
                        });
                      }
                    }),
                    _buildAllServiceItem(context, '健康档案', Icons.person_outline, () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/user/health/profiles');
                    }),
                    _buildAllServiceItem(context, '营养师咨询', Icons.medical_services_outlined, () {
                      Navigator.pop(context);
                      _showFeatureInDevelopment(context, '营养师咨询');
                    }),
                    _buildAllServiceItem(context, '营养报告', Icons.assessment, () {
                      Navigator.pop(context);
                      _showFeatureInDevelopment(context, '营养报告');
                    }),
                    _buildAllServiceItem(context, '我的订单', Icons.receipt_outlined, () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/user/orders');
                    }),
                    _buildAllServiceItem(context, '我的收藏', Icons.favorite_outline, () {
                      Navigator.pop(context);
                      _showFeatureInDevelopment(context, '我的收藏');
                    }),
                    _buildAllServiceItem(context, '饮食日记', Icons.event_note, () {
                      Navigator.pop(context);
                      _showFeatureInDevelopment(context, '饮食日记');
                    }),
                    _buildAllServiceItem(context, '食谱库', Icons.menu_book_outlined, () {
                      Navigator.pop(context);
                      _showFeatureInDevelopment(context, '食谱库');
                    }),
                    _buildAllServiceItem(context, '健康论坛', Icons.forum_outlined, () {
                      Navigator.pop(context);
                      final mainState = context.findAncestorStateOfType<_MainPageState>();
                      if (mainState != null) {
                        mainState.setState(() {
                          mainState._currentIndex = 2;
                        });
                      }
                    }),
                    _buildAllServiceItem(context, '运动建议', Icons.fitness_center, () {
                      Navigator.pop(context);
                      _showFeatureInDevelopment(context, '运动建议');
                    }),
                    _buildAllServiceItem(context, '历史记录', Icons.history, () {
                      Navigator.pop(context);
                      _showFeatureInDevelopment(context, '历史记录');
                    }),
                    _buildAllServiceItem(context, '客户服务', Icons.support_agent, () {
                      Navigator.pop(context);
                      _showFeatureInDevelopment(context, '客户服务');
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // 构建全部服务项目
  Widget _buildAllServiceItem(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return _buildFeatureItem(
      context,
      icon: icon,
      label: label,
      onTap: onTap,
    );
  }
  
  // 显示功能开发中提示
  void _showFeatureInDevelopment(BuildContext context, String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$featureName功能正在开发中，敬请期待！'),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildPlaceholderFoodCard(BuildContext context, {
    required String title,
    required String description,
  }) {
    return InkWell(
      onTap: () => _showFeatureInDevelopment(context, title),
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.restaurant,
                  size: 50,
                  color: Colors.green.shade700,
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

// 点餐页占位组件
class _OrderPagePlaceholder extends StatelessWidget {
  const _OrderPagePlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant,
            size: 100,
            color: Colors.orange,
          ),
          SizedBox(height: 24),
          Text(
            '点餐',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// 个人页占位组件
class _ProfilePagePlaceholder extends StatelessWidget {
  const _ProfilePagePlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户信息卡片
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.shade100,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.nickname ?? '用户',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authProvider.phone ?? '未绑定手机号',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // 编辑个人信息
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 我的营养档案
          const Text(
            '我的营养档案',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildProfileItem(
            icon: Icons.analytics_outlined,
            title: '营养报告',
            subtitle: '查看您的营养摄入报告',
            onTap: () {
              // 导航到营养报告页面
            },
          ),
          _buildProfileItem(
            icon: Icons.favorite_outline,
            title: '健康目标',
            subtitle: '设置和管理您的健康目标',
            onTap: () {
              // 导航到健康目标页面
            },
          ),
          _buildProfileItem(
            icon: Icons.history,
            title: '饮食记录',
            subtitle: '查看您的历史饮食记录',
            onTap: () {
              // 导航到饮食记录页面
            },
          ),
          
          const SizedBox(height: 24),
          
          // 系统设置
          const Text(
            '系统设置',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildProfileItem(
            icon: Icons.notifications_none,
            title: '通知设置',
            subtitle: '管理应用通知',
            onTap: () {
              // 导航到通知设置页面
            },
          ),
          _buildProfileItem(
            icon: Icons.security,
            title: '隐私设置',
            subtitle: '管理您的隐私和数据',
            onTap: () {
              // 导航到隐私设置页面
            },
          ),
          _buildProfileItem(
            icon: Icons.info_outline,
            title: '关于我们',
            subtitle: '了解应用信息和帮助',
            onTap: () {
              // 导航到关于页面
            },
          ),
        ],
      ),
    );
  }
  
  // 构建个人中心项目
  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.green,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
