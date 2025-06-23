import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/permissions.dart';
import '../../../../core/widgets/permission_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../consultation/presentation/pages/consultation_list_page.dart';
import '../../../consultation/presentation/pages/consultation_market_page.dart';
import '../../../consultation/presentation/pages/client_management_page.dart';
import '../pages/ai_assistant_page.dart';
import '../pages/nutritionist_profile_page.dart';

/// 营养师工作台主页面 - Tab结构
/// 包含5个Tab：我的咨询、咨询大厅、我的客户、AI助手、我的资料
class NutritionistMainPage extends ConsumerStatefulWidget {
  const NutritionistMainPage({super.key});

  @override
  ConsumerState<NutritionistMainPage> createState() => _NutritionistMainPageState();
}

class _NutritionistMainPageState extends ConsumerState<NutritionistMainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTabTitle(_currentIndex)),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // 通知按钮
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => _navigateToNotifications(),
              ),
              // 红点提示
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          // 设置按钮
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _navigateToSettings(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          tabs: const [
            Tab(
              icon: Icon(Icons.chat_bubble_outline, size: 20),
              text: '我的咨询',
            ),
            Tab(
              icon: Icon(Icons.store_outlined, size: 20),
              text: '咨询大厅',
            ),
            Tab(
              icon: Icon(Icons.people_outline, size: 20),
              text: '我的客户',
            ),
            Tab(
              icon: Icon(Icons.psychology_outlined, size: 20),
              text: 'AI助手',
            ),
            Tab(
              icon: Icon(Icons.person_outline, size: 20),
              text: '我的资料',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: 我的咨询
          PermissionWidget(
            requiredPermissions: const [Permissions.consultationRead],
            child: ConsultationListPage(
              nutritionistId: user.id,
            ),
            fallback: _buildPermissionDeniedPage('咨询管理'),
          ),
          
          // Tab 2: 咨询大厅
          PermissionWidget(
            requiredPermissions: const [Permissions.consultationRead],
            child: const ConsultationMarketPage(),
            fallback: _buildPermissionDeniedPage('接单大厅'),
          ),
          
          // Tab 3: 我的客户
          PermissionWidget(
            requiredPermissions: const [Permissions.nutritionistRead],
            child: ClientManagementPage(
              nutritionistId: user.id,
            ),
            fallback: _buildPermissionDeniedPage('客户管理'),
          ),
          
          // Tab 4: AI助手
          const AiAssistantPage(),
          
          // Tab 5: 我的资料
          NutritionistProfilePage(
            nutritionistId: user.id,
          ),
        ],
      ),
      
      // 浮动操作按钮 - 根据当前Tab显示不同功能
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  String _getTabTitle(int index) {
    switch (index) {
      case 0:
        return '我的咨询';
      case 1:
        return '咨询大厅';
      case 2:
        return '我的客户';
      case 3:
        return 'AI助手';
      case 4:
        return '我的资料';
      default:
        return '营养师工作台';
    }
  }

  Widget? _buildFloatingActionButton() {
    switch (_currentIndex) {
      case 0: // 我的咨询
        return FloatingActionButton(
          onPressed: () => _navigateToCreateConsultation(),
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add_comment),
        );
      case 1: // 咨询大厅
        return FloatingActionButton(
          onPressed: () => _refreshMarket(),
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.refresh),
        );
      case 2: // 我的客户
        return FloatingActionButton(
          onPressed: () => _navigateToAddClient(),
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.person_add),
        );
      case 3: // AI助手
        return FloatingActionButton(
          onPressed: () => _startAIChat(),
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.chat),
        );
      default:
        return null; // 我的资料页面不需要FAB
    }
  }

  Widget _buildPermissionDeniedPage(String feature) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '权限不足',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '您没有访问$feature的权限',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _contactSupport(),
              child: const Text('联系客服'),
            ),
          ],
        ),
      ),
    );
  }

  // 导航方法
  void _navigateToNotifications() {
    Navigator.pushNamed(context, '/notifications');
  }

  void _navigateToSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  void _navigateToCreateConsultation() {
    Navigator.pushNamed(context, '/consultations/create');
  }

  void _navigateToAddClient() {
    // TODO: 实现添加客户功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('添加客户功能即将推出')),
    );
  }

  void _refreshMarket() {
    // 刷新咨询大厅
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('正在刷新咨询大厅...')),
    );
    // 这里可以添加刷新咨询大厅的逻辑
  }

  void _startAIChat() {
    // 启动AI助手页面
    Navigator.pushNamed(context, '/nutritionist/ai-assistant');
  }

  void _contactSupport() {
    Navigator.pushNamed(context, '/help-center');
  }
}