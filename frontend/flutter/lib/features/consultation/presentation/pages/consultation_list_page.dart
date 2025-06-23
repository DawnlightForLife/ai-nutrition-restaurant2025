import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/consultation_entity.dart';
import '../providers/consultation_provider.dart';
import '../widgets/consultation_card.dart';
import '../widgets/consultation_filter_bar.dart';

class ConsultationListPage extends ConsumerStatefulWidget {
  final String? userId;
  final String? nutritionistId;

  const ConsultationListPage({
    Key? key,
    this.userId,
    this.nutritionistId,
  }) : super(key: key);

  @override
  ConsumerState<ConsultationListPage> createState() => _ConsultationListPageState();
}

class _ConsultationListPageState extends ConsumerState<ConsultationListPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ConsultationStatus? _selectedStatus;
  
  final List<ConsultationStatus?> _statusTabs = [
    null, // 全部
    ConsultationStatus.pending,
    ConsultationStatus.scheduled,
    ConsultationStatus.inProgress,
    ConsultationStatus.completed,
    ConsultationStatus.cancelled,
  ];

  final List<String> _tabTitles = [
    '全部',
    '待确认',
    '已预约',
    '进行中',
    '已完成',
    '已取消',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
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
        _selectedStatus = _statusTabs[_tabController.index];
      });
    }
  }

  ConsultationListParams _getParams() {
    return ConsultationListParams(
      userId: widget.userId,
      nutritionistId: widget.nutritionistId,
      status: _selectedStatus,
      limit: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养咨询'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshConsultations(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: _tabTitles.map((title) {
            return Tab(text: title);
          }).toList(),
        ),
      ),
      body: Column(
        children: [
          // 筛选栏
          ConsultationFilterBar(
            onFilterChanged: () => _refreshConsultations(),
          ),
          
          // 咨询列表
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _statusTabs.map((status) {
                final params = _getParams();
                final consultationsAsync = ref.watch(consultationListProvider(params));
                
                return consultationsAsync.when(
                  data: (consultations) {
                    final filteredConsultations = _filterConsultations(consultations, status);
                    
                    if (filteredConsultations.isEmpty) {
                      return _buildEmptyState(status);
                    }

                    return RefreshIndicator(
                      onRefresh: () async => _refreshConsultations(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredConsultations.length,
                        itemBuilder: (context, index) {
                          final consultation = filteredConsultations[index];
                          return ConsultationCard(
                            consultation: consultation,
                            onTap: () => _navigateToConsultationDetail(consultation.id),
                            onStatusUpdate: (newStatus) => 
                                _updateConsultationStatus(consultation, newStatus),
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
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('加载失败: $error'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _refreshConsultations(),
                          child: const Text('重试'),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateConsultation(),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<ConsultationEntity> _filterConsultations(
    List<ConsultationEntity> consultations, 
    ConsultationStatus? status
  ) {
    var filtered = consultations;
    
    if (status != null) {
      filtered = filtered.where((c) => c.status == status).toList();
    }
    
    // 按时间排序（最新的在前）
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return filtered;
  }

  Widget _buildEmptyState(ConsultationStatus? status) {
    final statusName = status?.displayName ?? '咨询';
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '暂无$statusName',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          if (status == ConsultationStatus.pending)
            Text(
              '新的咨询预约将显示在这里',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
        ],
      ),
    );
  }

  void _refreshConsultations() {
    final params = _getParams();
    ref.refresh(consultationListProvider(params));
  }

  Future<void> _updateConsultationStatus(
    ConsultationEntity consultation, 
    ConsultationStatus newStatus
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认更新状态'),
        content: Text(
          '确定要将咨询状态更新为"${newStatus.displayName}"吗？'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确认'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final params = _getParams();
      final success = await ref
          .read(consultationListProvider(params).notifier)
          .updateConsultationStatus(consultation.id, newStatus);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('咨询状态已更新为"${newStatus.displayName}"'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _navigateToConsultationDetail(String consultationId) {
    context.push('/consultations/$consultationId');
  }

  void _navigateToCreateConsultation() {
    context.push('/consultations/create');
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('筛选条件'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('更多筛选选项即将推出'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}