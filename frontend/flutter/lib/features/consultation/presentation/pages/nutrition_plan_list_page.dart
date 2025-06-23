import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NutritionPlanListPage extends ConsumerStatefulWidget {
  final String? nutritionistId;

  const NutritionPlanListPage({
    Key? key,
    this.nutritionistId,
  }) : super(key: key);

  @override
  ConsumerState<NutritionPlanListPage> createState() => _NutritionPlanListPageState();
}

class _NutritionPlanListPageState extends ConsumerState<NutritionPlanListPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养方案'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '进行中'),
            Tab(text: '已完成'),
            Tab(text: '草稿'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPlanList('进行中'),
          _buildPlanList('已完成'),
          _buildPlanList('草稿'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewPlan(),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPlanList(String status) {
    // 示例数据
    final plans = _getMockPlans(status);
    
    if (plans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '暂无$status的方案',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: 刷新方案列表
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getPlanColor(plan['type']),
                child: Icon(
                  _getPlanIcon(plan['type']),
                  color: Colors.white,
                ),
              ),
              title: Text(
                plan['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('客户：${plan['client']}'),
                  Text(
                    '更新时间：${plan['updateTime']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(status),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () => _viewPlanDetail(plan),
            ),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getMockPlans(String status) {
    if (status == '进行中') {
      return [
        {
          'id': '1',
          'title': '21天减脂计划',
          'type': 'weight_loss',
          'client': '张女士',
          'updateTime': '2小时前',
        },
        {
          'id': '2',
          'title': '糖尿病饮食调理',
          'type': 'diabetes',
          'client': '李先生',
          'updateTime': '昨天',
        },
      ];
    } else if (status == '已完成') {
      return [
        {
          'id': '3',
          'title': '产后恢复营养方案',
          'type': 'postpartum',
          'client': '王女士',
          'updateTime': '3天前',
        },
      ];
    }
    return [];
  }

  Color _getPlanColor(String type) {
    switch (type) {
      case 'weight_loss':
        return Colors.orange;
      case 'diabetes':
        return Colors.blue;
      case 'postpartum':
        return Colors.pink;
      default:
        return Colors.green;
    }
  }

  IconData _getPlanIcon(String type) {
    switch (type) {
      case 'weight_loss':
        return Icons.fitness_center;
      case 'diabetes':
        return Icons.medical_services;
      case 'postpartum':
        return Icons.child_care;
      default:
        return Icons.restaurant;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '进行中':
        return Colors.blue;
      case '已完成':
        return Colors.green;
      case '草稿':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _createNewPlan() {
    // TODO: 导航到创建方案页面
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('创建新方案功能即将推出')),
    );
  }

  void _viewPlanDetail(Map<String, dynamic> plan) {
    // TODO: 导航到方案详情页面
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('查看方案：${plan['title']}')),
    );
  }
}