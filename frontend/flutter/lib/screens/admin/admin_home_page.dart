import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/index.dart';
import 'nutritionist_verification_management.dart';
import 'merchant_management.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    // 检查是否是管理员
    if (userProvider.user?.role != 'admin') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('管理中心'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                '无访问权限',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '您没有管理员权限，无法访问此页面',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: const Text('返回首页'),
              ),
            ],
          ),
        ),
      );
    }
    
    // 管理员界面
    return Scaffold(
      appBar: AppBar(
        title: const Text('后台管理系统'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmDialog();
            },
          ),
        ],
      ),
      drawer: _buildAdminDrawer(),
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
            icon: Icon(Icons.dashboard),
            label: '控制台',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: '认证管理',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: '商家管理',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '系统设置',
          ),
        ],
      ),
    );
  }
  
  // 侧边抽屉菜单
  Widget _buildAdminDrawer() {
    final userProvider = Provider.of<UserProvider>(context);
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Text(
                    (userProvider.user?.nickname.isNotEmpty == true)
                        ? userProvider.user!.nickname[0].toUpperCase()
                        : 'A',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  userProvider.user?.nickname ?? '管理员',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '超级管理员',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('控制台'),
            selected: _selectedIndex == 0,
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('营养师认证管理'),
            selected: _selectedIndex == 1,
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('商家管理'),
            selected: _selectedIndex == 2,
            onTap: () {
              setState(() {
                _selectedIndex = 2;
              });
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('用户管理'),
            onTap: () {
              Navigator.pop(context);
              _showFeatureComingSoon('用户管理');
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('菜品管理'),
            onTap: () {
              Navigator.pop(context);
              _showFeatureComingSoon('菜品管理');
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('内容管理'),
            onTap: () {
              Navigator.pop(context);
              _showFeatureComingSoon('内容管理');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('系统设置'),
            selected: _selectedIndex == 3,
            onTap: () {
              setState(() {
                _selectedIndex = 3;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('退出登录', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showLogoutConfirmDialog();
            },
          ),
        ],
      ),
    );
  }
  
  // 主体内容区域
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return const NutritionistVerificationManagement();
      case 2:
        return const MerchantManagement();
      case 3:
        return _buildSystemSettings();
      default:
        return _buildDashboard();
    }
  }
  
  // 控制台
  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreetingCard(),
          const SizedBox(height: 20),
          
          // 数据统计卡片
          _buildStatisticsCards(),
          const SizedBox(height: 20),
          
          // 待办事项
          _buildSectionTitle('待办事项'),
          const SizedBox(height: 8),
          _buildTasksList(),
          const SizedBox(height: 20),
          
          // 系统状态
          _buildSectionTitle('系统状态'),
          const SizedBox(height: 8),
          _buildSystemStatusCard(),
        ],
      ),
    );
  }
  
  // 问候卡片
  Widget _buildGreetingCard() {
    final now = DateTime.now();
    String greeting;
    
    if (now.hour < 12) {
      greeting = '早上好';
    } else if (now.hour < 18) {
      greeting = '下午好';
    } else {
      greeting = '晚上好';
    }
    
    final userProvider = Provider.of<UserProvider>(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green,
              radius: 25,
              child: Text(
                (userProvider.user?.nickname.isNotEmpty == true)
                    ? userProvider.user!.nickname[0].toUpperCase()
                    : 'A',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting，${userProvider.user?.nickname ?? '管理员'}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '今天是 ${now.year}年${now.month}月${now.day}日，欢迎回来！',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
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
  
  // 统计卡片
  Widget _buildStatisticsCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('用户数', '1,254', Icons.people, Colors.blue),
        _buildStatCard('商家数', '32', Icons.store, Colors.orange),
        _buildStatCard('营养师数', '48', Icons.medical_services, Colors.green),
        _buildStatCard('今日订单', '156', Icons.receipt_long, Colors.purple),
      ],
    );
  }
  
  // 单个统计卡片
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 待办任务列表
  Widget _buildTasksList() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildTaskItem(
            '审核营养师认证申请',
            '5个待审核',
            Icons.verified_user,
            Colors.amber,
            () {
              setState(() {
                _selectedIndex = 1; // 切换到认证管理标签
              });
            },
          ),
          const Divider(height: 1),
          _buildTaskItem(
            '审核商家入驻申请',
            '3个待审核',
            Icons.store,
            Colors.green,
            () {
              setState(() {
                _selectedIndex = 2; // 切换到商家管理标签
              });
            },
          ),
          const Divider(height: 1),
          _buildTaskItem(
            '内容审核',
            '12个待审核',
            Icons.article,
            Colors.blue,
            () {
              _showFeatureComingSoon('内容审核');
            },
          ),
        ],
      ),
    );
  }
  
  // 单个任务项
  Widget _buildTaskItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
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
    );
  }
  
  // 系统状态卡片
  Widget _buildSystemStatusCard() {
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
              '系统状态',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatusItem('API服务', '正常', Colors.green),
            const SizedBox(height: 8),
            _buildStatusItem('数据库', '正常', Colors.green),
            const SizedBox(height: 8),
            _buildStatusItem('文件存储', '正常', Colors.green),
            const SizedBox(height: 8),
            _buildStatusItem('AI推荐引擎', '正常', Colors.green),
            const SizedBox(height: 16),
            Text(
              '上次检查: ${DateTime.now().toString().substring(0, 19)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 单个状态项
  Widget _buildStatusItem(String name, String status, Color color) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
  
  // 系统设置
  Widget _buildSystemSettings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle('基本设置'),
        const SizedBox(height: 8),
        _buildSettingItem(
          '系统信息',
          Icons.info,
          '查看系统版本和许可证信息',
          () {
            _showFeatureComingSoon('系统信息');
          },
        ),
        const SizedBox(height: 8),
        _buildSettingItem(
          '通知设置',
          Icons.notifications,
          '管理系统通知和提醒',
          () {
            _showFeatureComingSoon('通知设置');
          },
        ),
        const SizedBox(height: 8),
        _buildSettingItem(
          '安全设置',
          Icons.security,
          '修改密码和安全选项',
          () {
            _showFeatureComingSoon('安全设置');
          },
        ),
        
        const SizedBox(height: 24),
        _buildSectionTitle('高级设置'),
        const SizedBox(height: 8),
        _buildSettingItem(
          '数据备份',
          Icons.backup,
          '备份和恢复系统数据',
          () {
            _showFeatureComingSoon('数据备份');
          },
        ),
        const SizedBox(height: 8),
        _buildSettingItem(
          'API设置',
          Icons.api,
          '管理API密钥和访问权限',
          () {
            _showFeatureComingSoon('API设置');
          },
        ),
        const SizedBox(height: 8),
        _buildSettingItem(
          '系统日志',
          Icons.list_alt,
          '查看系统操作日志',
          () {
            _showFeatureComingSoon('系统日志');
          },
        ),
      ],
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
  
  // 章节标题
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
  
  // 退出确认对话框
  void _showLogoutConfirmDialog() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
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
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
  
  // 功能即将上线提示
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