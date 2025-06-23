import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/client_provider.dart';
import '../../domain/models/client_models.dart';

/// 营养师客户列表页面
class ClientListPage extends ConsumerStatefulWidget {
  const ClientListPage({super.key});

  @override
  ConsumerState<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends ConsumerState<ClientListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedTag = 'all';
  String _sortBy = 'lastConsultation';

  final List<String> _tagOptions = [
    'all',
    'active',
    'inactive',
    'vip',
    'new',
    'followUp'
  ];

  final Map<String, String> _tagLabels = {
    'all': '全部',
    'active': '活跃',
    'inactive': '不活跃',
    'vip': 'VIP',
    'new': '新客户',
    'followUp': '需跟进'
  };

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
            icon: const Icon(Icons.person_add),
            onPressed: _showAddClientDialog,
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => context.push('/nutritionist/clients/analytics'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(child: _buildClientList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
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
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ..._tagOptions.map((tag) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_tagLabels[tag] ?? tag),
              selected: _selectedTag == tag,
              onSelected: (selected) {
                setState(() {
                  _selectedTag = selected ? tag : 'all';
                });
              },
            ),
          )),
          const SizedBox(width: 16),
          PopupMenuButton<String>(
            child: Chip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('排序'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, size: 18),
                ],
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'lastConsultation', child: Text('最近咨询')),
              const PopupMenuItem(value: 'name', child: Text('姓名')),
              const PopupMenuItem(value: 'createdAt', child: Text('添加时间')),
              const PopupMenuItem(value: 'consultationCount', child: Text('咨询次数')),
            ],
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClientList() {
    final clientsAsync = ref.watch(clientListProvider(
      ClientListParams(
        search: _searchQuery.isEmpty ? null : _searchQuery,
        tag: _selectedTag == 'all' ? null : _selectedTag,
        sortBy: _sortBy,
      ),
    ));

    return clientsAsync.when(
      data: (clients) {
        if (clients.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(clientListProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];
              return _ClientCard(
                client: client,
                onTap: () => context.push('/nutritionist/clients/${client.id}'),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            '暂无客户',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击右上角添加新客户',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddClientDialog,
            icon: const Icon(Icons.person_add),
            label: const Text('添加客户'),
          ),
        ],
      ),
    );
  }

  void _showAddClientDialog() {
    showDialog(
      context: context,
      builder: (context) => const _AddClientDialog(),
    );
  }
}

/// 客户卡片组件
class _ClientCard extends StatelessWidget {
  final NutritionistClient client;
  final VoidCallback onTap;

  const _ClientCard({
    required this.client,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green[100],
                child: Text(
                  client.nickname.substring(0, 1),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
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
                        const SizedBox(width: 8),
                        ..._buildTags(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${client.age ?? '-'}岁 | ${client.gender ?? '-'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '最近咨询: ${_formatDate(client.lastConsultation)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.chat, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${client.consultationCount ?? 0}次',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (client.healthOverview?.currentBMI != null)
                    Text(
                      'BMI ${client.healthOverview!.currentBMI!.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _getBMIColor(client.healthOverview!.currentBMI!),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTags() {
    final tags = <Widget>[];
    
    if (client.tags?.contains('vip') ?? false) {
      tags.add(_buildTag('VIP', Colors.orange));
    }
    
    if (client.tags?.contains('active') ?? false) {
      tags.add(_buildTag('活跃', Colors.green));
    }
    
    if (client.reminders?.isNotEmpty ?? false) {
      tags.add(_buildTag('有提醒', Colors.blue));
    }
    
    return tags;
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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

  String _formatDate(DateTime? date) {
    if (date == null) return '无';
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return '今天';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}周前';
    } else {
      return '${(difference.inDays / 30).floor()}月前';
    }
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 24) return Colors.green;
    if (bmi < 28) return Colors.orange;
    return Colors.red;
  }
}

/// 添加客户对话框
class _AddClientDialog extends ConsumerStatefulWidget {
  const _AddClientDialog();

  @override
  ConsumerState<_AddClientDialog> createState() => _AddClientDialogState();
}

class _AddClientDialogState extends ConsumerState<_AddClientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedGender;

  @override
  void dispose() {
    _nicknameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加新客户'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: '客户昵称',
                  hintText: '请输入客户昵称',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入客户昵称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: '年龄',
                  hintText: '请输入年龄',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final age = int.tryParse(value);
                    if (age == null || age < 1 || age > 150) {
                      return '请输入有效的年龄';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: '性别',
                ),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('男')),
                  DropdownMenuItem(value: 'female', child: Text('女')),
                  DropdownMenuItem(value: 'other', child: Text('其他')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('添加'),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(addClientProvider.notifier);
      
      await notifier.addClient(
        nickname: _nicknameController.text,
        age: int.tryParse(_ageController.text),
        gender: _selectedGender,
      );

      ref.read(addClientProvider).when(
        data: (_) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('客户添加成功')),
          );
          ref.invalidate(clientListProvider);
        },
        loading: () {},
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('添加失败: $error')),
          );
        },
      );
    }
  }
}