import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/index.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    // 如果用户未登录，显示未登录的个人中心
    if (!userProvider.isLoggedIn) {
      return _buildNotLoggedInProfile(context);
    }
    
    // 用户已登录，显示个人信息
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 顶部AppBar
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                userProvider.user?.nickname ?? '我的主页',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Text(
                          (userProvider.user?.nickname.isNotEmpty == true)
                              ? userProvider.user!.nickname[0].toUpperCase()
                              : '用',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // 个人信息卡片
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('基本信息'),
                  const SizedBox(height: 8),
                  _buildInfoCard(context, [
                    _buildInfoItem(Icons.phone, '手机号', userProvider.user?.phone ?? '未设置'),
                    _buildInfoItem(Icons.accessibility, '身高', 
                        userProvider.user?.height != null 
                            ? '${userProvider.user!.height}cm' 
                            : '未设置'),
                    _buildInfoItem(Icons.monitor_weight, '体重', 
                        userProvider.user?.weight != null 
                            ? '${userProvider.user!.weight}kg' 
                            : '未设置'),
                    _buildInfoItem(Icons.calendar_today, '年龄', 
                        userProvider.user?.age != null 
                            ? '${userProvider.user!.age}岁' 
                            : '未设置'),
                  ]),
                  
                  const SizedBox(height: 16),
                  
                  // 营养档案入口
                  _buildSectionTitle('营养服务'),
                  const SizedBox(height: 8),
                  _buildFeatureCard(
                    context,
                    Icons.folder_shared,
                    '我的营养档案',
                    '管理您的营养档案，为不同的人创建个性化方案',
                    () {
                      Navigator.pushNamed(context, '/nutrition/profiles');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    context,
                    Icons.medical_services,
                    '营养师咨询',
                    '在线咨询专业营养师，获取健康饮食指导',
                    () {
                      _showFeatureComingSoon(context, '营养师咨询');
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 身份切换模块
                  _buildSectionTitle('身份中心'),
                  const SizedBox(height: 8),
                  _buildIdentitySwitchCard(context, userProvider),
                  
                  const SizedBox(height: 16),
                  
                  // 订单与收藏
                  _buildSectionTitle('我的内容'),
                  const SizedBox(height: 8),
                  _buildFeatureCard(
                    context,
                    Icons.history,
                    '历史订单',
                    '查看您的历史订单及状态',
                    () {
                      _showFeatureComingSoon(context, '历史订单');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    context,
                    Icons.favorite,
                    '我的收藏',
                    '查看您收藏的餐品和文章',
                    () {
                      _showFeatureComingSoon(context, '我的收藏');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    context,
                    Icons.forum,
                    '我的帖子',
                    '管理您在社区发布的内容',
                    () {
                      _showFeatureComingSoon(context, '我的帖子');
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 设置与退出登录
                  _buildSectionTitle('账号设置'),
                  const SizedBox(height: 8),
                  _buildFeatureCard(
                    context,
                    Icons.settings,
                    '设置',
                    '修改个人信息、隐私设置等',
                    () {
                      _showFeatureComingSoon(context, '设置');
                    },
                    showArrow: true,
                  ),
                  const SizedBox(height: 12),
                  _buildLogoutButton(context, userProvider),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 未登录时的个人中心页面
  Widget _buildNotLoggedInProfile(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 顶部AppBar
          SliverAppBar(
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                '个人中心',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                  ),
                ),
              ),
            ),
          ),
          
          // 登录提示
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.account_circle,
                            size: 60,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '您尚未登录',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '登录后可以使用完整功能和个性化服务',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                ),
                                child: const Text('登录'),
                              ),
                              const SizedBox(width: 16),
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                ),
                                child: const Text('注册'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 可游客使用的功能
                  _buildSectionTitle('发现更多'),
                  const SizedBox(height: 8),
                  _buildFeatureCard(
                    context,
                    Icons.restaurant_menu,
                    '营养菜品',
                    '浏览健康营养的推荐菜品',
                    () {
                      _showFeatureComingSoon(context, '营养菜品');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    context,
                    Icons.article,
                    '营养知识',
                    '了解科学的饮食和健康知识',
                    () {
                      _showFeatureComingSoon(context, '营养知识');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    context,
                    Icons.forum,
                    '社区讨论',
                    '浏览用户分享的饮食心得',
                    () {
                      _showFeatureComingSoon(context, '社区讨论');
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 需要登录的功能提示
                  _buildSectionTitle('登录后可用'),
                  const SizedBox(height: 8),
                  _buildLoginRequiredFeatureCard(
                    context,
                    Icons.folder_shared,
                    '我的营养档案',
                    '创建和管理个性化营养档案',
                  ),
                  const SizedBox(height: 12),
                  _buildLoginRequiredFeatureCard(
                    context,
                    Icons.medical_services,
                    '营养师咨询',
                    '获取专业营养师的个性化指导',
                  ),
                  const SizedBox(height: 12),
                  _buildLoginRequiredFeatureCard(
                    context,
                    Icons.favorite,
                    '我的收藏',
                    '收藏喜欢的菜品和文章',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 小标题
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
  
  // 信息卡片
  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }
  
  // 单条信息项
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  // 功能卡片
  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool showArrow = true,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 24, color: Colors.green),
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
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              if (showArrow) const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
  
  // 需要登录的功能卡片
  Widget _buildLoginRequiredFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showLoginPrompt(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 24, color: Colors.grey),
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
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '登录可用',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // 退出登录按钮
  Widget _buildLogoutButton(BuildContext context, UserProvider userProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('退出登录'),
              content: const Text('确定要退出登录吗？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    userProvider.logout();
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text('确定'),
                ),
              ],
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.exit_to_app, size: 24, color: Colors.redAccent),
              SizedBox(width: 16),
              Text(
                '退出登录',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // 显示登录提示对话框
  void _showLoginPrompt(BuildContext context) {
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
  
  // 显示功能即将上线提示
  void _showFeatureComingSoon(BuildContext context, String featureName) {
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
  
  // 身份切换卡片
  Widget _buildIdentitySwitchCard(BuildContext context, UserProvider userProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 当前身份信息
            Row(
              children: [
                Icon(
                  _getIdentityIcon(userProvider),
                  size: 24,
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                Text(
                  '当前身份: ${_getIdentityName(userProvider)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            
            // 身份切换按钮
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.spaceAround,
              children: [
                // 用户身份
                _buildIdentitySwitchButton(
                  context,
                  '用户',
                  Icons.person,
                  userProvider.isUserActive,
                  () => _switchToUser(context, userProvider),
                ),
                
                // 营养师身份
                _buildIdentitySwitchButton(
                  context,
                  '营养师',
                  Icons.medical_services,
                  userProvider.isNutritionistActive,
                  () => _switchToNutritionist(context, userProvider),
                ),
                
                // 商家身份
                _buildIdentitySwitchButton(
                  context,
                  '商家',
                  Icons.store,
                  userProvider.isMerchantActive,
                  () => _switchToMerchant(context, userProvider),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // 身份切换按钮
  Widget _buildIdentitySwitchButton(
    BuildContext context,
    String title,
    IconData icon,
    bool isActive,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? Colors.green.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? Colors.green : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.green : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 获取当前身份图标
  IconData _getIdentityIcon(UserProvider userProvider) {
    if (userProvider.isNutritionistActive) {
      return Icons.medical_services;
    } else if (userProvider.isMerchantActive) {
      return Icons.store;
    } else {
      return Icons.person;
    }
  }
  
  // 获取当前身份名称
  String _getIdentityName(UserProvider userProvider) {
    if (userProvider.isNutritionistActive) {
      return '营养师';
    } else if (userProvider.isMerchantActive) {
      return '商家';
    } else {
      return '用户';
    }
  }
  
  // 切换到用户身份
  void _switchToUser(BuildContext context, UserProvider userProvider) {
    userProvider.switchToUserRole();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已切换到用户身份')),
    );
  }
  
  // 切换到营养师身份
  void _switchToNutritionist(BuildContext context, UserProvider userProvider) {
    // 检查用户是否有营养师认证
    if (userProvider.user?.isNutritionistVerified == true) {
      if (userProvider.switchToNutritionistRole(context: context)) {
        // 导航已经在provider中处理
      }
    } else {
      // 用户未认证，检查是否有认证申请
      if (userProvider.user?.nutritionistVerificationStatus == 'pending') {
        _showVerificationPendingDialog(context, '营养师');
      } else {
        _showVerificationNeededDialog(context, '营养师');
      }
    }
  }
  
  // 切换到商家身份
  void _switchToMerchant(BuildContext context, UserProvider userProvider) {
    // 检查用户是否有商家认证
    if (userProvider.user?.isMerchantVerified == true) {
      if (userProvider.switchToMerchantRole(context: context)) {
        // 导航已经在provider中处理
      }
    } else {
      // 用户未认证，检查是否有认证申请
      if (userProvider.user?.merchantVerificationStatus == 'pending') {
        _showVerificationPendingDialog(context, '商家');
      } else {
        _showVerificationNeededDialog(context, '商家');
      }
    }
  }
  
  // 显示认证申请等待中对话框
  void _showVerificationPendingDialog(BuildContext context, String role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$role认证审核中'),
        content: Text('您的$role认证申请正在审核中，请耐心等待。\n审核通过后即可切换身份。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }
  
  // 显示需要认证对话框
  void _showVerificationNeededDialog(BuildContext context, String role) {
    String routeName = role == '营养师' ? '/nutritionist/verification' : '/merchant/verification';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('需要$role认证'),
        content: Text('您需要完成$role认证后才能使用该身份。\n认证通过后可以享受更多专业功能。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeName);
            },
            child: const Text('去认证'),
          ),
        ],
      ),
    );
  }
} 