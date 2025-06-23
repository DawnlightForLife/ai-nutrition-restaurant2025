import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/workbench_provider.dart';
import '../../domain/models/workbench_models.dart';

/// 增强版营养师工作台
class NutritionistDashboardPageEnhanced extends ConsumerWidget {
  const NutritionistDashboardPageEnhanced({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养师工作台'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/nutritionist/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardStatsProvider);
          ref.invalidate(workbenchTasksProvider);
          ref.invalidate(quickActionsProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _WelcomeSection(),
              const SizedBox(height: 24),
              _TodayStatsSection(),
              const SizedBox(height: 24),
              _QuickActionsSection(),
              const SizedBox(height: 24),
              _PendingTasksSection(),
              const SizedBox(height: 24),
              _RecentConsultationsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeSection extends ConsumerWidget {
  const _WelcomeSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get actual nutritionist info from auth provider
    return Card(
      color: Colors.green.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '欢迎回来，营养师',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '今天又是充满活力的一天！',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/nutritionist/profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayStatsSection extends ConsumerWidget {
  _TodayStatsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '今日工作概况',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        statsAsync.when(
          data: (stats) => _buildStatsGrid(stats),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('加载失败: $error'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(DashboardStats stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: '待处理咨询',
                value: stats.today.consultations.toString(),
                icon: Icons.chat,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: '已完成咨询',
                value: stats.today.completedConsultations.toString(),
                icon: Icons.check_circle,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: '用户评分',
                value: stats.overall.averageRating.toStringAsFixed(1),
                icon: Icons.star,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: '今日收入',
                value: '¥${stats.today.totalIncome.toStringAsFixed(2)}',
                icon: Icons.attach_money,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsSection extends ConsumerWidget {
  _QuickActionsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionsAsync = ref.watch(quickActionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '快捷操作',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        actionsAsync.when(
          data: (actions) => _buildActionsList(context, ref, actions),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('加载失败: $error'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsList(BuildContext context, WidgetRef ref, List<QuickAction> actions) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: actions.map((action) => 
        _buildActionButton(
          context: context,
          ref: ref,
          action: action,
        ),
      ).toList(),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required WidgetRef ref,
    required QuickAction action,
  }) {
    return GestureDetector(
      onTap: () => _handleAction(context, ref, action),
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(int.parse(action.color.replaceAll('#', '0xFF'))).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconData(action.icon),
                    size: 30,
                    color: Color(int.parse(action.color.replaceAll('#', '0xFF'))),
                  ),
                ),
                if (action.badge != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        action.badge.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              action.title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'offline_pin': Icons.offline_pin,
      'online_prediction': Icons.online_prediction,
      'restaurant_menu': Icons.restaurant_menu,
      'calendar_today': Icons.calendar_today,
      'message': Icons.message,
      'file_download': Icons.file_download,
      'notification_important': Icons.notification_important,
      'chat': Icons.chat,
      'person': Icons.person,
      'recommend': Icons.recommend,
      'star': Icons.star,
    };
    return iconMap[iconName] ?? Icons.help_outline;
  }

  void _handleAction(BuildContext context, WidgetRef ref, QuickAction action) {
    switch (action.action) {
      case 'toggle_online_status':
        _toggleOnlineStatus(context, ref);
        break;
      case 'create_nutrition_plan':
        context.push('/nutritionist/plans/create');
        break;
      case 'view_appointments':
        context.push('/nutritionist/appointments');
        break;
      case 'batch_message':
        context.push('/nutritionist/clients/message');
        break;
      case 'export_report':
        context.push('/nutritionist/statistics');
        break;
      case 'view_pending_consultations':
        context.push('/nutritionist/consultations?status=pending');
        break;
      case 'view_clients':
        context.push('/nutritionist/clients');
        break;
    }
  }

  void _toggleOnlineStatus(BuildContext context, WidgetRef ref) async {
    // Show confirmation dialog
    final shouldToggle = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('切换在线状态'),
        content: const Text('确定要切换您的在线状态吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (shouldToggle == true) {
      await ref.read(onlineStatusProvider.notifier).toggleOnlineStatus();
      
      // Listen for the result
      ref.listen<AsyncValue<OnlineStatusResult?>>(
        onlineStatusProvider,
        (previous, next) {
          next.when(
            data: (result) {
              if (result != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result.isOnline ? '已上线' : '已下线'),
                    backgroundColor: result.isOnline ? Colors.green : Colors.orange,
                  ),
                );
                // Refresh quick actions to update the button
                ref.invalidate(quickActionsProvider);
              }
            },
            loading: () {},
            error: (error, stack) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('切换状态失败: $error'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
      );
    }
  }
}

class _PendingTasksSection extends ConsumerWidget {
  _PendingTasksSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(workbenchTasksProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '待处理任务',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.push('/nutritionist/tasks'),
                  child: const Text('查看全部'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            tasksAsync.when(
              data: (tasks) => _buildTasksList(context, tasks),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('加载失败: $error'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(BuildContext context, List<WorkbenchTask> tasks) {
    if (tasks.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('暂无待处理任务'),
        ),
      );
    }

    return Column(
      children: tasks.take(3).map((task) => 
        _buildTaskItem(context, task),
      ).toList(),
    );
  }

  Widget _buildTaskItem(BuildContext context, WorkbenchTask task) {
    final colorMap = {
      'high': Colors.red,
      'medium': Colors.orange,
      'low': Colors.green,
    };
    
    final color = colorMap[task.priority] ?? Colors.grey;

    return GestureDetector(
      onTap: () => _handleTaskTap(context, task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.left(
            width: 4,
            color: color,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(task.createdAt),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getPriorityText(task.priority),
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else {
      return '${difference.inDays}天前';
    }
  }

  String _getPriorityText(String priority) {
    final map = {
      'high': '高',
      'medium': '中',
      'low': '低',
    };
    return map[priority] ?? priority;
  }

  void _handleTaskTap(BuildContext context, WorkbenchTask task) {
    switch (task.type) {
      case 'consultation_pending':
      case 'consultation_active':
        context.push('/nutritionist/consultations/${task.data?['_id']}');
        break;
      case 'client_plan_update':
        context.push('/nutritionist/clients/${task.data?['_id']}');
        break;
    }
  }
}

class _RecentConsultationsSection extends ConsumerWidget {
  _RecentConsultationsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consultationsAsync = ref.watch(workbenchConsultationsProvider(null));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '最近咨询',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.push('/nutritionist/consultations'),
                  child: const Text('查看全部'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            consultationsAsync.when(
              data: (consultations) => _buildConsultationsList(context, consultations),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('加载失败: $error'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationsList(BuildContext context, List<WorkbenchConsultation> consultations) {
    if (consultations.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('暂无咨询记录'),
        ),
      );
    }

    return Column(
      children: consultations.take(3).map((consultation) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            child: Text(
              (consultation.username ?? '用户').substring(0, 1),
            ),
          ),
          title: Text(consultation.username ?? '用户'),
          subtitle: Text(
            consultation.topic ?? '咨询内容...',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(consultation.createdAt ?? DateTime.now()),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              _buildStatusIndicator(consultation.status),
            ],
          ),
          onTap: () => context.push('/nutritionist/consultations/${consultation.id}'),
        );
      }).toList(),
    );
  }

  Widget _buildStatusIndicator(String? status) {
    Color color;
    switch (status) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'active':
        color = Colors.blue;
        break;
      case 'completed':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else {
      return '${difference.inDays}天前';
    }
  }
}