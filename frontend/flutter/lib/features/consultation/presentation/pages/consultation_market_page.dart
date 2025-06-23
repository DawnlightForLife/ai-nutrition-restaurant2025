import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/consultation_entity.dart';

/// 咨询大厅页面 - 营养师接单页面
/// 显示用户发布的咨询需求，营养师可以抢单接入
class ConsultationMarketPage extends ConsumerStatefulWidget {
  const ConsultationMarketPage({super.key});

  @override
  ConsumerState<ConsultationMarketPage> createState() => _ConsultationMarketPageState();
}

class _ConsultationMarketPageState extends ConsumerState<ConsultationMarketPage>
    with AutomaticKeepAliveClientMixin {
  String _selectedFilter = 'all';
  final List<String> _filterOptions = ['all', 'urgent', 'nutrition', 'weight_loss', 'diabetes'];
  final List<String> _filterLabels = ['全部', '紧急', '营养咨询', '减肥指导', '糖尿病'];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      body: Column(
        children: [
          // 筛选栏
          _buildFilterBar(),
          
          // 咨询列表
          Expanded(
            child: _buildConsultationList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '可接咨询',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              TextButton.icon(
                onPressed: () => _refreshMarket(),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('刷新'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filterOptions.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedFilter == _filterOptions[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_filterLabels[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = _filterOptions[index];
                      });
                    },
                    selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected 
                          ? Theme.of(context).primaryColor 
                          : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationList() {
    // 获取模拟数据
    final consultations = _getMockConsultations();
    final filteredConsultations = _filterConsultations(consultations);

    if (filteredConsultations.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async => _refreshMarket(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredConsultations.length,
        itemBuilder: (context, index) {
          final consultation = filteredConsultations[index];
          return _buildConsultationCard(consultation);
        },
      ),
    );
  }

  Widget _buildConsultationCard(Map<String, dynamic> consultation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部信息
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getPriorityColor(consultation['priority']),
                  radius: 20,
                  child: Text(
                    consultation['userInitial'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            consultation['userName'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(consultation['priority']).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              consultation['priority'],
                              style: TextStyle(
                                fontSize: 10,
                                color: _getPriorityColor(consultation['priority']),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${consultation['age']}岁 · ${consultation['gender']} · ${consultation['location']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  consultation['timeAgo'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 咨询标题
            Text(
              consultation['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 咨询描述
            Text(
              consultation['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 12),
            
            // 标签
            Wrap(
              spacing: 8,
              children: (consultation['tags'] as List<String>).map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue[700],
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // 底部行动区域
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '预算：¥${consultation['budget']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '咨询时长：${consultation['duration']}分钟',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => _viewConsultationDetail(consultation),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      child: Text(
                        '查看详情',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _acceptConsultation(consultation),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        '接单',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            '暂无可接咨询',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '当前没有符合条件的咨询需求\n您可以刷新页面或稍后再试',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _refreshMarket(),
            icon: const Icon(Icons.refresh),
            label: const Text('刷新咨询大厅'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => _optimizeProfile(),
            child: const Text('优化我的资料提高接单率'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockConsultations() {
    return [
      {
        'id': '1',
        'userName': '张女士',
        'userInitial': '张',
        'age': 28,
        'gender': '女',
        'location': '北京',
        'title': '减肥期间的营养搭配咨询',
        'description': '我最近在减肥，想要科学的饮食搭配建议。目前身高165cm，体重65kg，目标是减到55kg。希望营养师能帮我制定一个合理的饮食计划，既能减肥又不影响健康。',
        'tags': ['减肥', '营养搭配', '饮食计划'],
        'priority': '普通',
        'budget': 80,
        'duration': 30,
        'timeAgo': '10分钟前',
      },
      {
        'id': '2',
        'userName': '李先生',
        'userInitial': '李',
        'age': 45,
        'gender': '男',
        'location': '上海',
        'title': '糖尿病患者饮食指导',
        'description': '我是二型糖尿病患者，最近血糖控制不太理想。希望营养师能给我专业的饮食指导，特别是关于碳水化合物的摄入控制和血糖管理。',
        'tags': ['糖尿病', '血糖控制', '慢病管理'],
        'priority': '紧急',
        'budget': 120,
        'duration': 45,
        'timeAgo': '25分钟前',
      },
      {
        'id': '3',
        'userName': '王女士',
        'userInitial': '王',
        'age': 32,
        'gender': '女',
        'location': '广州',
        'title': '孕期营养补充建议',
        'description': '我现在怀孕16周，想了解孕期营养需求和补充建议。特别关心叶酸、钙质、DHA等营养素的摄入，以及孕期饮食禁忌。',
        'tags': ['孕期营养', '营养补充', '胎儿发育'],
        'priority': '重要',
        'budget': 100,
        'duration': 40,
        'timeAgo': '1小时前',
      },
    ];
  }

  List<Map<String, dynamic>> _filterConsultations(List<Map<String, dynamic>> consultations) {
    if (_selectedFilter == 'all') return consultations;
    
    return consultations.where((consultation) {
      switch (_selectedFilter) {
        case 'urgent':
          return consultation['priority'] == '紧急';
        case 'nutrition':
          return consultation['tags'].contains('营养咨询') || 
                 consultation['tags'].contains('营养搭配');
        case 'weight_loss':
          return consultation['tags'].contains('减肥');
        case 'diabetes':
          return consultation['tags'].contains('糖尿病');
        default:
          return true;
      }
    }).toList();
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case '紧急':
        return Colors.red;
      case '重要':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  void _refreshMarket() {
    // TODO: 实现刷新逻辑
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已刷新咨询大厅')),
    );
  }

  void _viewConsultationDetail(Map<String, dynamic> consultation) {
    // TODO: 导航到咨询详情页面
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(consultation['title']),
        content: Text(consultation['description']),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _acceptConsultation(Map<String, dynamic> consultation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认接单'),
        content: Text('确定要接受来自${consultation['userName']}的咨询吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确认接单'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: 实现接单逻辑
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已接受来自${consultation['userName']}的咨询'),
            backgroundColor: Colors.green,
          ),
        );
        
        // 可以导航到咨询聊天页面
        Navigator.pushNamed(
          context,
          '/consultation-chat',
          arguments: {'consultationId': consultation['id']},
        );
      }
    }
  }

  void _optimizeProfile() {
    Navigator.pushNamed(context, '/nutritionist-profile');
  }
}