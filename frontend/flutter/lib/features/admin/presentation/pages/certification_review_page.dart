import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/certification_review_provider.dart';
import '../widgets/certification_review_card.dart';
import '../widgets/certification_filter_bar.dart';

/// 营养师认证审核页面
class CertificationReviewPage extends ConsumerStatefulWidget {
  const CertificationReviewPage({super.key});

  @override
  ConsumerState<CertificationReviewPage> createState() => _CertificationReviewPageState();
}

class _CertificationReviewPageState extends ConsumerState<CertificationReviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedStatus = 'pending';
  String? _selectedLevel;
  String? _selectedSpecialization;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedStatus = _getStatusFromTab(_tabController.index);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _getStatusFromTab(int index) {
    switch (index) {
      case 0:
        return 'pending';
      case 1:
        return 'approved';
      case 2:
        return 'rejected';
      case 3:
        return 'needsRevision';
      default:
        return 'pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养师认证审核'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => _showStatistics(context),
            tooltip: '审核统计',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(certificationApplicationsProvider),
            tooltip: '刷新',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '待审核'),
            Tab(text: '已通过'),
            Tab(text: '已拒绝'),
            Tab(text: '需修改'),
          ],
        ),
      ),
      body: Column(
        children: [
          // 搜索和筛选栏
          CertificationFilterBar(
            searchController: _searchController,
            selectedLevel: _selectedLevel,
            selectedSpecialization: _selectedSpecialization,
            onLevelChanged: (level) {
              setState(() {
                _selectedLevel = level;
              });
            },
            onSpecializationChanged: (spec) {
              setState(() {
                _selectedSpecialization = spec;
              });
            },
            onSearchChanged: (query) {
              // Trigger search
              ref.invalidate(certificationApplicationsProvider);
            },
          ),

          // 申请列表
          Expanded(
            child: _buildApplicationList(),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationList() {
    final applicationsAsync = ref.watch(
      certificationApplicationsProvider(
        CertificationFilterParams(
          status: _selectedStatus,
          certificationLevel: _selectedLevel,
          specialization: _selectedSpecialization,
          searchQuery: _searchController.text,
        ),
      ),
    );

    return applicationsAsync.when(
      data: (applications) {
        if (applications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open,
                  size: 80,
                  color: Colors.grey.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  '暂无${_getStatusLabel(_selectedStatus)}的申请',
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
            ref.invalidate(certificationApplicationsProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final application = applications[index];
              return CertificationReviewCard(
                application: application,
                onTap: () => _viewApplicationDetail(application.id),
                onQuickAction: (action) => _handleQuickAction(action, application.id),
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
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text('加载失败: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(certificationApplicationsProvider),
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return '待审核';
      case 'approved':
        return '已通过';
      case 'rejected':
        return '已拒绝';
      case 'needsRevision':
        return '需修改';
      default:
        return status;
    }
  }

  void _viewApplicationDetail(String applicationId) {
    context.push('/admin/certification-review/$applicationId');
  }

  void _handleQuickAction(String action, String applicationId) async {
    switch (action) {
      case 'approve':
        await _quickReview(applicationId, 'approved');
        break;
      case 'reject':
        await _quickReview(applicationId, 'rejected');
        break;
      case 'needsRevision':
        await _quickReview(applicationId, 'needsRevision');
        break;
      case 'priority':
        await _changePriority(applicationId);
        break;
    }
  }

  Future<void> _quickReview(String applicationId, String decision) async {
    final shouldProceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认${_getDecisionLabel(decision)}'),
        content: Text('确定要${_getDecisionLabel(decision)}这个申请吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getDecisionColor(decision),
            ),
            child: Text('确认${_getDecisionLabel(decision)}'),
          ),
        ],
      ),
    );

    if (shouldProceed == true) {
      final notifier = ref.read(reviewApplicationProvider.notifier);
      await notifier.reviewApplication(
        applicationId: applicationId,
        decision: decision,
        reviewNotes: '快速审核',
      );

      // Listen for result
      ref.listen<AsyncValue<void>>(
        reviewApplicationProvider,
        (previous, next) {
          next.when(
            data: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_getDecisionLabel(decision)}成功'),
                  backgroundColor: Colors.green,
                ),
              );
              ref.invalidate(certificationApplicationsProvider);
            },
            loading: () {},
            error: (error, stack) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('操作失败: $error'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
      );
    }
  }

  String _getDecisionLabel(String decision) {
    switch (decision) {
      case 'approved':
        return '通过';
      case 'rejected':
        return '拒绝';
      case 'needsRevision':
        return '要求修改';
      default:
        return decision;
    }
  }

  Color _getDecisionColor(String decision) {
    switch (decision) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'needsRevision':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Future<void> _changePriority(String applicationId) async {
    final priority = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('设置优先级'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'low'),
            child: const Row(
              children: [
                Icon(Icons.arrow_downward, color: Colors.grey),
                SizedBox(width: 8),
                Text('低'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'normal'),
            child: const Row(
              children: [
                Icon(Icons.remove, color: Colors.blue),
                SizedBox(width: 8),
                Text('普通'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'high'),
            child: const Row(
              children: [
                Icon(Icons.arrow_upward, color: Colors.orange),
                SizedBox(width: 8),
                Text('高'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'urgent'),
            child: const Row(
              children: [
                Icon(Icons.priority_high, color: Colors.red),
                SizedBox(width: 8),
                Text('紧急'),
              ],
            ),
          ),
        ],
      ),
    );

    if (priority != null) {
      // TODO: Implement priority update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('优先级已设置为: $priority')),
      );
    }
  }

  void _showStatistics(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const CertificationStatisticsSheet(),
    );
  }
}

/// 认证统计底部弹窗
class CertificationStatisticsSheet extends ConsumerWidget {
  const CertificationStatisticsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(certificationStatisticsProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics, size: 28),
              const SizedBox(width: 12),
              Text(
                '审核统计',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: 20),
          statsAsync.when(
            data: (stats) => Column(
              children: [
                _buildStatRow('待审核', stats['pending'] ?? 0, Colors.orange),
                _buildStatRow('已通过', stats['approved'] ?? 0, Colors.green),
                _buildStatRow('已拒绝', stats['rejected'] ?? 0, Colors.red),
                _buildStatRow('需修改', stats['needsRevision'] ?? 0, Colors.blue),
                const Divider(height: 32),
                _buildStatRow('今日审核', stats['todayReviewed'] ?? 0, Colors.purple),
                _buildStatRow('本周审核', stats['weekReviewed'] ?? 0, Colors.indigo),
              ],
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text('加载失败: $error'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            color: color,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}