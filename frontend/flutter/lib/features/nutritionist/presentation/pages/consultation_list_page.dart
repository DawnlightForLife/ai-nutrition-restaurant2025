import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/workbench_provider.dart';
import '../../domain/models/workbench_models.dart';

/// 营养师咨询列表页面
class ConsultationListPage extends ConsumerStatefulWidget {
  final String? initialStatus;

  const ConsultationListPage({
    super.key,
    this.initialStatus,
  });

  @override
  ConsumerState<ConsultationListPage> createState() => _ConsultationListPageState();
}

class _ConsultationListPageState extends ConsumerState<ConsultationListPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<String> _statusList = ['all', 'pending', 'active', 'completed', 'rejected'];
  final Map<String, String> _statusLabels = {
    'all': '全部',
    'pending': '待接受',
    'active': '进行中',
    'completed': '已完成',
    'rejected': '已拒绝',
  };

  @override
  void initState() {
    super.initState();
    int initialIndex = 0;
    if (widget.initialStatus != null) {
      final index = _statusList.indexOf(widget.initialStatus!);
      if (index != -1) initialIndex = index;
    }
    _tabController = TabController(
      length: _statusList.length,
      vsync: this,
      initialIndex: initialIndex,
    );
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
        title: const Text('咨询管理'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _statusList.map((status) => 
            Tab(text: _statusLabels[status])
          ).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _statusList.map((status) => 
          _ConsultationListView(
            status: status == 'all' ? null : status,
          )
        ).toList(),
      ),
    );
  }
}

class _ConsultationListView extends ConsumerWidget {
  final String? status;

  const _ConsultationListView({
    required this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consultationsAsync = ref.watch(workbenchConsultationsProvider(status));

    return consultationsAsync.when(
      data: (consultations) {
        if (consultations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  '暂无咨询记录',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(workbenchConsultationsProvider(status));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: consultations.length,
            itemBuilder: (context, index) {
              final consultation = consultations[index];
              return _ConsultationCard(consultation: consultation);
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              '加载失败',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(workbenchConsultationsProvider(status));
              },
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsultationCard extends ConsumerWidget {
  final WorkbenchConsultation consultation;

  const _ConsultationCard({
    required this.consultation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/nutritionist/consultations/${consultation.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: Text(
                      (consultation.username ?? '用户').substring(0, 1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          consultation.username ?? '用户',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(consultation.createdAt ?? DateTime.now()),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(consultation.status),
                ],
              ),
              const SizedBox(height: 12),
              if (consultation.topic != null) ...[
                Text(
                  consultation.topic!,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],
              if (consultation.appointmentTime != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '预约时间：${_formatDateTime(consultation.appointmentTime!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              if (consultation.status == 'pending')
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _showRejectDialog(context, ref),
                      child: const Text('拒绝'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _acceptConsultation(context, ref),
                      child: const Text('接受'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    final statusConfig = {
      'pending': ('待接受', Colors.orange),
      'active': ('进行中', Colors.blue),
      'completed': ('已完成', Colors.green),
      'rejected': ('已拒绝', Colors.red),
    };

    final config = statusConfig[status] ?? ('未知', Colors.grey);

    return Chip(
      label: Text(
        config.$1,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
      backgroundColor: config.$2,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${time.month}月${time.day}日';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}月${dateTime.day}日 ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _acceptConsultation(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(consultationActionsProvider.notifier);
    await notifier.acceptConsultation(consultation.id);
    
    ref.read(consultationActionsProvider).when(
      data: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已接受咨询')),
        );
        ref.invalidate(workbenchConsultationsProvider);
      },
      loading: () {},
      error: (error, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败: $error')),
        );
      },
    );
  }

  void _showRejectDialog(BuildContext context, WidgetRef ref) {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('拒绝咨询'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: '拒绝原因（可选）',
            hintText: '请输入拒绝的原因',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final notifier = ref.read(consultationActionsProvider.notifier);
              await notifier.rejectConsultation(
                consultation.id,
                reasonController.text.isEmpty ? null : reasonController.text,
              );
              
              ref.read(consultationActionsProvider).when(
                data: (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已拒绝咨询')),
                  );
                  ref.invalidate(workbenchConsultationsProvider);
                },
                loading: () {},
                error: (error, _) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('操作失败: $error')),
                  );
                },
              );
            },
            child: const Text('确认拒绝'),
          ),
        ],
      ),
    );
    
    reasonController.dispose();
  }
}