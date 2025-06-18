import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/permissions.dart';
import '../../../../core/widgets/permission_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'role_based_dashboard.dart';

/// 营养师仪表板
class NutritionistDashboard extends ConsumerWidget {
  const NutritionistDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养师工作台'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: 导航到通知页面
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 欢迎消息
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      child: const Icon(
                        Icons.health_and_safety,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '营养师 ${user.nickname ?? ''}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('今日有3个新的咨询等待回复'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 今日统计
            Text(
              '今日工作概览',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              children: const [
                StatCard(
                  title: '今日咨询',
                  value: '8',
                  icon: Icons.chat,
                  trend: '+2 比昨日',
                  color: Colors.blue,
                ),
                StatCard(
                  title: '待回复',
                  value: '3',
                  icon: Icons.pending_actions,
                  color: Colors.orange,
                ),
                StatCard(
                  title: '本月客户',
                  value: '42',
                  icon: Icons.people,
                  trend: '+15% 比上月',
                  color: Colors.green,
                ),
                StatCard(
                  title: '满意度',
                  value: '4.9',
                  icon: Icons.star,
                  color: Colors.amber,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 快速操作
            Text(
              '快速操作',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                PermissionWidget(
                  requiredPermissions: const [Permissions.consultationRead],
                  child: QuickActionCard(
                    title: '咨询管理',
                    subtitle: '查看和回复咨询',
                    icon: Icons.chat_bubble,
                    onTap: () {
                      Navigator.pushNamed(context, '/consultations');
                    },
                  ),
                ),
                PermissionWidget(
                  requiredPermissions: const [Permissions.nutritionistRead],
                  child: QuickActionCard(
                    title: '客户档案',
                    subtitle: '管理客户档案',
                    icon: Icons.folder_shared,
                    onTap: () {
                      Navigator.pushNamed(context, '/clients');
                    },
                  ),
                ),
                QuickActionCard(
                  title: '营养方案',
                  subtitle: '制定营养计划',
                  icon: Icons.assignment,
                  onTap: () {
                    Navigator.pushNamed(context, '/nutrition-plans');
                  },
                ),
                QuickActionCard(
                  title: '知识库',
                  subtitle: '营养知识资料',
                  icon: Icons.library_books,
                  onTap: () {
                    Navigator.pushNamed(context, '/knowledge-base');
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 待处理咨询
            PermissionWidget(
              requiredPermissions: const [Permissions.consultationRead],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '待处理咨询',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/consultations');
                        },
                        child: const Text('查看全部'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getConsultationPriorityColor(index),
                            child: Text(
                              _getClientInitial(index),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(_getClientName(index)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_getConsultationTitle(index)),
                              const SizedBox(height: 4),
                              Text(
                                _getConsultationTime(index),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: Chip(
                            label: Text(
                              _getConsultationPriority(index),
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: _getConsultationPriorityColor(index).withOpacity(0.2),
                          ),
                          onTap: () {
                            // TODO: 导航到咨询详情
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // 底部导航栏
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: '咨询',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '客户',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: '方案',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/consultations');
              break;
            case 2:
              Navigator.pushNamed(context, '/clients');
              break;
            case 3:
              Navigator.pushNamed(context, '/nutrition-plans');
              break;
          }
        },
      ),
      
      // 浮动操作按钮
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/consultations/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Color _getConsultationPriorityColor(int index) {
    switch (index % 3) {
      case 0:
        return Colors.red; // 紧急
      case 1:
        return Colors.orange; // 重要
      default:
        return Colors.blue; // 普通
    }
  }
  
  String _getClientInitial(int index) {
    const initials = ['张', '李', '王'];
    return initials[index % initials.length];
  }
  
  String _getClientName(int index) {
    const names = ['张女士', '李先生', '王女士'];
    return names[index % names.length];
  }
  
  String _getConsultationTitle(int index) {
    const titles = ['减肥期间的饮食搭配', '糖尿病患者营养指导', '孕期营养补充建议'];
    return titles[index % titles.length];
  }
  
  String _getConsultationTime(int index) {
    const times = ['30分钟前', '1小时前', '2小时前'];
    return times[index % times.length];
  }
  
  String _getConsultationPriority(int index) {
    const priorities = ['紧急', '重要', '普通'];
    return priorities[index % priorities.length];
  }
}