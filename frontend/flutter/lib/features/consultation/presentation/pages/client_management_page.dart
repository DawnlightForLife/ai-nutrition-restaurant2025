import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientManagementPage extends ConsumerStatefulWidget {
  final String? nutritionistId;

  const ClientManagementPage({
    Key? key,
    this.nutritionistId,
  }) : super(key: key);

  @override
  ConsumerState<ClientManagementPage> createState() => _ClientManagementPageState();
}

class _ClientManagementPageState extends ConsumerState<ClientManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('客户管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortOptions(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索栏
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索客户姓名、手机号',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                // TODO: 实现搜索功能
              },
            ),
          ),
          
          // 筛选标签
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('全部客户', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('活跃客户', 'active'),
                const SizedBox(width: 8),
                _buildFilterChip('新客户', 'new'),
                const SizedBox(width: 8),
                _buildFilterChip('VIP客户', 'vip'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 客户统计
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('总客户', '156'),
                _buildStatItem('本月新增', '12'),
                _buildStatItem('活跃率', '78%'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 客户列表
          Expanded(
            child: _buildClientList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? value : 'all';
        });
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildClientList() {
    // 示例数据
    final clients = _getMockClients();
    
    if (clients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '暂无客户数据',
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
        // TODO: 刷新客户列表
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final client = clients[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getAvatarColor(client['name']),
                child: Text(
                  client['name'][0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                client['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('手机：${client['phone']}'),
                  Text(
                    '最近咨询：${client['lastConsult']}',
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
                  if (client['isVip'])
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'VIP',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              onTap: () => _viewClientDetail(client),
            ),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getMockClients() {
    return [
      {
        'id': '1',
        'name': '张女士',
        'phone': '138****1234',
        'lastConsult': '2天前',
        'isVip': true,
      },
      {
        'id': '2',
        'name': '李先生',
        'phone': '139****5678',
        'lastConsult': '1周前',
        'isVip': false,
      },
      {
        'id': '3',
        'name': '王女士',
        'phone': '137****9012',
        'lastConsult': '3天前',
        'isVip': true,
      },
      {
        'id': '4',
        'name': '赵先生',
        'phone': '136****3456',
        'lastConsult': '今天',
        'isVip': false,
      },
    ];
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
    ];
    return colors[name.hashCode % colors.length];
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '排序方式',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('最近咨询时间'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 实现排序
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('客户姓名'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 实现排序
              },
            ),
            ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('咨询频率'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 实现排序
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewClientDetail(Map<String, dynamic> client) {
    // TODO: 导航到客户详情页面
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('查看客户：${client['name']}')),
    );
  }
}