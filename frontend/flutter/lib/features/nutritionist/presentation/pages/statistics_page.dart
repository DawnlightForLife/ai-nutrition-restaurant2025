import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/statistics_dashboard.dart';
import '../providers/workbench_provider.dart';
import '../../domain/models/workbench_models.dart';

/// 营养师统计页面
class NutritionistStatisticsPage extends ConsumerStatefulWidget {
  const NutritionistStatisticsPage({super.key});

  @override
  ConsumerState<NutritionistStatisticsPage> createState() => _NutritionistStatisticsPageState();
}

class _NutritionistStatisticsPageState extends ConsumerState<NutritionistStatisticsPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange? _selectedDateRange;

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
        title: const Text('数据统计'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _selectDateRange,
            tooltip: '选择日期范围',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 20),
                    SizedBox(width: 8),
                    Text('导出报表'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 20),
                    SizedBox(width: 8),
                    Text('刷新数据'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '概览'),
            Tab(text: '收入'),
            Tab(text: '客户'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 概览标签
          const StatisticsDashboard(),
          
          // 收入标签
          _buildIncomeTab(),
          
          // 客户标签
          _buildClientTab(),
        ],
      ),
    );
  }

  Widget _buildIncomeTab() {
    final incomeParams = IncomeParams(
      startDate: _selectedDateRange?.start,
      endDate: _selectedDateRange?.end,
    );
    final incomeAsync = ref.watch(incomeDetailsProvider(incomeParams));

    return incomeAsync.when(
      data: (income) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 收入概览卡片
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '收入概览',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildIncomeStatItem(
                          label: '总收入',
                          value: '¥${income.totalAmount.toStringAsFixed(2)}',
                          icon: Icons.account_balance_wallet,
                          color: Colors.green,
                        ),
                        _buildIncomeStatItem(
                          label: '订单数',
                          value: income.totalCount.toString(),
                          icon: Icons.receipt,
                          color: Colors.blue,
                        ),
                        _buildIncomeStatItem(
                          label: '平均单价',
                          value: income.totalCount > 0 
                              ? '¥${(income.totalAmount / income.totalCount).toStringAsFixed(2)}'
                              : '¥0.00',
                          icon: Icons.trending_up,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 收入明细列表
            Text(
              '收入明细',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...income.items.map((item) => _buildIncomeItem(item)),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('加载失败: $error'),
      ),
    );
  }

  Widget _buildClientTab() {
    return const Center(
      child: Text('客户统计功能开发中...'),
    );
  }

  Widget _buildIncomeStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeItem(IncomeItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getIncomeTypeColor(item.type).withOpacity(0.1),
          child: Icon(
            _getIncomeTypeIcon(item.type),
            color: _getIncomeTypeColor(item.type),
          ),
        ),
        title: Text(item.description ?? _getIncomeTypeLabel(item.type)),
        subtitle: Text(_formatDate(item.date)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '¥${item.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _getIncomeTypeColor(item.type),
              ),
            ),
            if (item.status != null)
              Text(
                _getStatusLabel(item.status!),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        onTap: () {
          if (item.relatedId != null) {
            // Navigate to related consultation/order
            context.push('/consultations/${item.relatedId}');
          }
        },
      ),
    );
  }

  IconData _getIncomeTypeIcon(String type) {
    switch (type) {
      case 'consultation':
        return Icons.chat;
      case 'plan':
        return Icons.restaurant_menu;
      case 'subscription':
        return Icons.card_membership;
      default:
        return Icons.attach_money;
    }
  }

  Color _getIncomeTypeColor(String type) {
    switch (type) {
      case 'consultation':
        return Colors.blue;
      case 'plan':
        return Colors.green;
      case 'subscription':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getIncomeTypeLabel(String type) {
    switch (type) {
      case 'consultation':
        return '咨询服务';
      case 'plan':
        return '营养计划';
      case 'subscription':
        return '订阅服务';
      default:
        return '其他收入';
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'paid':
        return '已支付';
      case 'pending':
        return '待支付';
      case 'refunded':
        return '已退款';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
           '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      // Refresh data with new date range
      ref.invalidate(incomeDetailsProvider);
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'export':
        _exportReport();
        break;
      case 'refresh':
        ref.invalidate(dashboardStatsProvider);
        ref.invalidate(incomeDetailsProvider);
        break;
    }
  }

  void _exportReport() {
    // TODO: Implement report export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('报表导出功能开发中...')),
    );
  }
}