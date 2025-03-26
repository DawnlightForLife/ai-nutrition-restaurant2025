import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/index.dart';

class NutritionistHomePage extends StatefulWidget {
  const NutritionistHomePage({Key? key}) : super(key: key);

  @override
  State<NutritionistHomePage> createState() => _NutritionistHomePageState();
}

class _NutritionistHomePageState extends State<NutritionistHomePage> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    // 检查是否是营养师身份
    if (!userProvider.isNutritionistActive) {
      // 如果不是营养师身份，显示提示并允许切换回用户身份
      return Scaffold(
        appBar: AppBar(
          title: const Text('营养师中心'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.amber,
              ),
              const SizedBox(height: 24),
              const Text(
                '您当前不是营养师身份',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '请先切换到营养师身份后访问此页面',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('返回'),
              ),
            ],
          ),
        ),
      );
    }
    
    // 营养师身份页面内容
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养师工作台'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              _showFeatureComingSoon('消息通知');
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '工作台',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '我的客户',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: '方案库',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
  
  // 构建主体内容
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildClientsPage();
      case 2:
        return _buildPlansPage();
      case 3:
        return _buildNutritionistProfile();
      default:
        return _buildDashboard();
    }
  }
  
  // 营养师工作台页面
  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 统计卡片
          _buildStatsCard(),
          const SizedBox(height: 24),
          
          // 待处理咨询
          _buildSectionTitle('待处理咨询'),
          const SizedBox(height: 8),
          _buildEmptyState('暂无待处理的咨询', '您当前没有需要处理的咨询请求', Icons.chat),
          const SizedBox(height: 24),
          
          // 待回复消息
          _buildSectionTitle('待回复消息'),
          const SizedBox(height: 8),
          _buildEmptyState('暂无待回复的消息', '您当前没有需要回复的消息', Icons.email),
          const SizedBox(height: 24),
          
          // 快速工具
          _buildSectionTitle('快速工具'),
          const SizedBox(height: 8),
          _buildQuickTools(),
        ],
      ),
    );
  }
  
  // 统计卡片
  Widget _buildStatsCard() {
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
            const Text(
              '数据概览',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('今日咨询', '0'),
                _buildStatItem('待处理', '0'),
                _buildStatItem('本月收入', '¥0'),
                _buildStatItem('满意度', '0%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // 单个统计项
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
  
  // 快速工具
  Widget _buildQuickTools() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildQuickToolItem('新增客户', Icons.person_add, () {
          _showFeatureComingSoon('新增客户');
        }),
        _buildQuickToolItem('创建方案', Icons.note_add, () {
          _showFeatureComingSoon('创建方案');
        }),
        _buildQuickToolItem('收入明细', Icons.account_balance_wallet, () {
          _showFeatureComingSoon('收入明细');
        }),
        _buildQuickToolItem('更多工具', Icons.more_horiz, () {
          _showFeatureComingSoon('更多工具');
        }),
      ],
    );
  }
  
  // 单个快速工具项
  Widget _buildQuickToolItem(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.green, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  // 客户页面
  Widget _buildClientsPage() {
    return Center(
      child: _buildEmptyState(
        '暂无客户',
        '您目前还没有客户，可以通过平台接单获取客户',
        Icons.people,
      ),
    );
  }
  
  // 方案库页面
  Widget _buildPlansPage() {
    return Center(
      child: _buildEmptyState(
        '暂无方案',
        '您目前还没有创建任何营养方案',
        Icons.menu_book,
      ),
    );
  }
  
  // 营养师个人主页
  Widget _buildNutritionistProfile() {
    final userProvider = Provider.of<UserProvider>(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 营养师信息卡片
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 头像
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green,
                    child: Text(
                      (userProvider.user?.nickname.isNotEmpty == true)
                          ? userProvider.user!.nickname[0].toUpperCase()
                          : '营',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 用户名
                  Text(
                    userProvider.user?.nickname ?? '营养师',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // 认证信息
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified, color: Colors.green, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '已认证营养师',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // 切换身份按钮
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        userProvider.switchToUserRole();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('已切换到普通用户身份')),
                        );
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text('切换到用户身份'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // 营养师设置
          _buildSectionTitle('营养师设置'),
          const SizedBox(height: 8),
          _buildSettingItem(
            '个人资料',
            Icons.edit,
            '编辑您的专业信息和介绍',
            () {
              _showFeatureComingSoon('个人资料编辑');
            },
          ),
          const SizedBox(height: 8),
          _buildSettingItem(
            '服务设置',
            Icons.work,
            '设置您提供的服务和价格',
            () {
              _showFeatureComingSoon('服务设置');
            },
          ),
          const SizedBox(height: 8),
          _buildSettingItem(
            '收款账户',
            Icons.account_balance_wallet,
            '设置您的收款方式和账户',
            () {
              _showFeatureComingSoon('收款账户');
            },
          ),
          const SizedBox(height: 24),
          
          // 营养师工具
          _buildSectionTitle('专业工具'),
          const SizedBox(height: 8),
          _buildSettingItem(
            '营养计算器',
            Icons.calculate,
            '计算食物营养素和能量',
            () {
              _showFeatureComingSoon('营养计算器');
            },
          ),
          const SizedBox(height: 8),
          _buildSettingItem(
            '专业资料库',
            Icons.menu_book,
            '食物成分表和营养参考资料',
            () {
              _showFeatureComingSoon('专业资料库');
            },
          ),
        ],
      ),
    );
  }
  
  // 设置项
  Widget _buildSettingItem(
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 1,
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
              Icon(icon, color: Colors.green),
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
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
  
  // 空状态
  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  // 标题
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
} 