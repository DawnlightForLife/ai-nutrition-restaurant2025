import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/client_provider.dart';
import '../../domain/models/client_models.dart';

/// 营养师客户管理页面
class ClientManagementPage extends ConsumerStatefulWidget {
  const ClientManagementPage({super.key});

  @override
  ConsumerState<ClientManagementPage> createState() => _ClientManagementPageState();
}

class _ClientManagementPageState extends ConsumerState<ClientManagementPage> {
  String _selectedTab = 'all';
  String _searchQuery = '';
  final _searchController = TextEditingController();

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
            icon: const Icon(Icons.message),
            onPressed: () => _showBatchMessageDialog(context),
            tooltip: '群发消息',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/nutritionist/clients/add'),
            tooltip: '添加客户',
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索栏
          _buildSearchBar(),
          
          // 标签栏
          _buildTabBar(),
          
          // 客户列表
          Expanded(
            child: _buildClientList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索客户姓名、电话或标签',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = [
      {'id': 'all', 'label': '全部', 'icon': Icons.group},
      {'id': 'active', 'label': '活跃', 'icon': Icons.star},
      {'id': 'new', 'label': '新客户', 'icon': Icons.fiber_new},
      {'id': 'vip', 'label': 'VIP', 'icon': Icons.diamond},
      {'id': 'inactive', 'label': '不活跃', 'icon': Icons.warning},
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = _selectedTab == tab['id'];
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                children: [
                  Icon(
                    tab['icon'] as IconData,
                    size: 16,
                    color: isSelected ? Colors.white : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(tab['label'] as String),
                ],
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedTab = tab['id'] as String;
                  });
                }
              },
              selectedColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey.withOpacity(0.1),
            ),
          );
        },
      ),
    );
  }

  Widget _buildClientList() {
    // Use clientListProvider with default params
    final params = ClientListParams();
    final clientsAsync = ref.watch(clientListProvider(params));

    return clientsAsync.when(
      data: (clients) {
        // Filter clients based on tab and search
        final filteredClients = _filterClients(clients);
        
        if (filteredClients.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off,
                  size: 80,
                  color: Colors.grey.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isNotEmpty ? '没有找到匹配的客户' : '暂无客户',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(clientListProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredClients.length,
            itemBuilder: (context, index) {
              final client = filteredClients[index];
              return _buildClientCard(client);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text('加载失败: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(clientListProvider),
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  List<NutritionistClient> _filterClients(List<NutritionistClient> clients) {
    // First filter by tab
    var filtered = clients.where((client) {
      switch (_selectedTab) {
        case 'active':
          return client.isActive == true;
        case 'new':
          // Clients created within last 7 days
          final createdAt = client.createdAt ?? DateTime.now();
          final daysSinceCreated = DateTime.now().difference(createdAt).inDays;
          return daysSinceCreated <= 7;
        case 'vip':
          // Check if client has VIP tag
          return client.tags?.contains('VIP') == true;
        case 'inactive':
          return client.isActive == false;
        default:
          return true;
      }
    }).toList();

    // Then filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((client) {
        return client.nickname.toLowerCase().contains(query) ||
               (client.tags?.any((tag) => tag.toLowerCase().contains(query)) ?? false);
      }).toList();
    }

    // Sort by last consultation time
    filtered.sort((a, b) {
      final aTime = a.lastConsultation ?? a.createdAt ?? DateTime(2000);
      final bTime = b.lastConsultation ?? b.createdAt ?? DateTime(2000);
      return bTime.compareTo(aTime);
    });

    return filtered;
  }

  Widget _buildClientCard(NutritionistClient client) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/nutritionist/clients/${client.id}'),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green.withOpacity(0.1),
                    child: Text(
                      client.nickname.substring(0, 1),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              client.nickname,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (client.tags?.contains('VIP') == true) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'VIP',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '最后联系: ${_formatLastContact(client.lastConsultation ?? client.createdAt ?? DateTime.now())}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildStatusIndicator(client.isActive ?? true),
                      const SizedBox(height: 4),
                      Text(
                        '${client.consultationCount ?? 0}次咨询',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (client.notes?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.note,
                        size: 16,
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          client.notes!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (client.tags?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: client.tags!.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.blue,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _startConsultation(client),
                      icon: const Icon(Icons.chat, size: 16),
                      label: const Text('发起咨询'),
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _viewNutritionPlan(client),
                      icon: const Icon(Icons.restaurant_menu, size: 16),
                      label: const Text('营养计划'),
                      style: ElevatedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(bool isActive) {
    final color = isActive ? Colors.green : Colors.orange;
    final label = isActive ? '活跃' : '不活跃';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatLastContact(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${dateTime.month}月${dateTime.day}日';
    }
  }

  void _startConsultation(NutritionistClient client) {
    context.push('/nutritionist/consultations/new?clientId=${client.userId}');
  }

  void _viewNutritionPlan(NutritionistClient client) {
    context.push('/nutritionist/clients/${client.id}/plans');
  }

  void _showBatchMessageDialog(BuildContext context) {
    final selectedClients = <String>[];
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('群发消息'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('选择要发送消息的客户:'),
              const SizedBox(height: 8),
              // TODO: Add client selection list
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: '消息内容',
                  hintText: '输入要发送的消息...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement batch message sending
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('消息已发送')),
              );
            },
            child: const Text('发送'),
          ),
        ],
      ),
    );
  }
}