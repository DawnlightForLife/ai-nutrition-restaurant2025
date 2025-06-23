import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/presentation/widgets/app_bar.dart';
import '../../../shared/presentation/widgets/loading_widget.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../widgets/nutritionist_management_filters.dart';
import '../widgets/nutritionist_management_list.dart';
import '../widgets/nutritionist_management_stats.dart';
import '../widgets/batch_operations_bar.dart';
import '../providers/nutritionist_management_provider.dart';
import '../../data/services/nutritionist_management_service.dart';

class NutritionistManagementPage extends ConsumerStatefulWidget {
  const NutritionistManagementPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NutritionistManagementPage> createState() => _NutritionistManagementPageState();
}

class _NutritionistManagementPageState extends ConsumerState<NutritionistManagementPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // 初始化加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nutritionistManagementProvider.notifier).loadNutritionists(refresh: true);
      ref.read(nutritionistManagementProvider.notifier).loadOverview();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    ref.read(nutritionistManagementProvider.notifier).searchNutritionists(query);
  }

  void _onNutritionistSelected(String id, bool selected) {
    ref.read(nutritionistManagementProvider.notifier).toggleNutritionistSelection(id);
  }

  void _onSelectAll(bool selected) {
    ref.read(nutritionistManagementProvider.notifier).toggleSelectAll();
  }

  void _onBatchOperation(String operation) {
    final state = ref.read(nutritionistManagementProvider);
    
    if (operation == 'cancel') {
      ref.read(nutritionistManagementProvider.notifier).clearSelection();
      return;
    }
    
    if (state.selectedNutritionists.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择要操作的营养师')),
      );
      return;
    }

    switch (operation) {
      case 'activate':
        _showBatchOperationDialog('activate');
        break;
      case 'suspend':
        _showBatchOperationDialog('suspend');
        break;
      case 'offline':
        _showBatchOperationDialog('offline');
        break;
      case 'export':
        _exportSelected();
        break;
    }
  }

  void _showBatchOperationDialog(String operationType) {
    final state = ref.read(nutritionistManagementProvider);
    
    showDialog(
      context: context,
      builder: (context) => BatchOperationDialog(
        operationType: operationType,
        selectedCount: state.selectedNutritionists.length,
        onConfirm: (status, reason) => _performBatchOperation(operationType, status, reason),
      ),
    );
  }

  Future<void> _performBatchOperation(String operationType, String status, String reason) async {
    final state = ref.read(nutritionistManagementProvider);
    final notifier = ref.read(nutritionistManagementProvider.notifier);
    final selectedIds = state.selectedNutritionists.toList();
    
    bool success = false;
    
    try {
      switch (operationType) {
        case 'offline':
          success = await notifier.batchSetOffline(selectedIds);
          break;
        default:
          success = await notifier.batchUpdateStatus(selectedIds, status, reason: reason);
          break;
      }
      
      if (mounted) {
        BatchOperationResultSnackBar.show(
          context,
          success: success,
          operation: _getOperationName(operationType),
          total: selectedIds.length,
          affected: success ? selectedIds.length : 0,
          error: success ? null : state.error,
        );
      }
    } catch (e) {
      if (mounted) {
        BatchOperationResultSnackBar.show(
          context,
          success: false,
          operation: _getOperationName(operationType),
          total: selectedIds.length,
          affected: 0,
          error: e.toString(),
        );
      }
    }
  }
  
  String _getOperationName(String operationType) {
    switch (operationType) {
      case 'activate':
        return '激活营养师';
      case 'suspend':
        return '暂停营养师';
      case 'offline':
        return '下线营养师';
      default:
        return '批量操作';
    }
  }

  void _exportSelected() {
    _showExportDialog(selectedOnly: true);
  }

  void _exportAll() {
    _showExportDialog(selectedOnly: false);
  }
  
  void _showExportDialog({required bool selectedOnly}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(selectedOnly ? '导出选中营养师数据' : '导出营养师数据'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selectedOnly 
              ? '选择导出格式（将导出已选中的营养师）：'
              : '选择导出格式：'
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _performExport('csv');
                    },
                    child: const Text('CSV'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _performExport('json');
                    },
                    child: const Text('JSON'),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  Future<void> _performExport(String format) async {
    final notifier = ref.read(nutritionistManagementProvider.notifier);
    final success = await notifier.exportNutritionists(format: format);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success 
            ? '导出 $format 格式数据成功' 
            : '导出失败，请重试'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }
  
  void _refreshData() {
    ref.read(nutritionistManagementProvider.notifier).loadNutritionists(refresh: true);
    ref.read(nutritionistManagementProvider.notifier).loadOverview();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nutritionistManagementProvider);
    final isAllCurrentPageSelected = state.nutritionists.isNotEmpty && 
        state.nutritionists.every((n) => state.selectedNutritionists.contains(n.id));

    return Scaffold(
      appBar: CustomAppBar(
        title: '营养师管理',
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportAll,
            tooltip: '导出数据',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: '刷新',
          ),
        ],
      ),
      body: Column(
        children: [
          // 选中营养师的批量操作栏
          if (state.selectedNutritionists.isNotEmpty)
            BatchOperationsBar(
              selectedCount: state.selectedNutritionists.length,
              onBatchOperation: _onBatchOperation,
            ),
          
          // Tab栏
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.list), text: '营养师列表'),
                Tab(icon: Icon(Icons.analytics), text: '数据统计'),
                Tab(icon: Icon(Icons.filter_list), text: '高级筛选'),
              ],
            ),
          ),
          
          // Tab内容
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 营养师列表
                Column(
                  children: [
                    // 搜索和基础筛选
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Theme.of(context).cardColor,
                      child: Column(
                        children: [
                          // 搜索框
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: '搜索营养师姓名、手机号、证书编号...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        _onSearch('');
                                      },
                                    )
                                  : null,
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: _onSearch,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // 快速筛选按钮
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildQuickFilter('全部', null, state.statusFilter),
                                _buildQuickFilter('活跃', 'active', state.statusFilter),
                                _buildQuickFilter('待审核', 'pendingVerification', state.statusFilter),
                                _buildQuickFilter('已暂停', 'suspended', state.statusFilter),
                                _buildQuickFilter('不活跃', 'inactive', state.statusFilter),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 列表内容
                    Expanded(
                      child: NutritionistManagementList(
                        selectedNutritionists: state.selectedNutritionists,
                        isAllSelected: isAllCurrentPageSelected,
                        onNutritionistSelected: _onNutritionistSelected,
                        onSelectAll: _onSelectAll,
                        status: state.statusFilter,
                        verificationStatus: state.verificationStatusFilter,
                        specialization: state.specializationFilter,
                        search: state.searchQuery ?? '',
                        sortBy: state.sortBy,
                        sortOrder: state.sortOrder,
                      ),
                    ),
                  ],
                ),
                
                // 数据统计
                const NutritionistManagementStats(),
                
                // 高级筛选
                NutritionistManagementFilters(
                  selectedStatus: state.statusFilter,
                  selectedVerificationStatus: state.verificationStatusFilter,
                  selectedSpecialization: state.specializationFilter,
                  sortBy: state.sortBy,
                  sortOrder: state.sortOrder,
                  onStatusChanged: (value) {
                    ref.read(nutritionistManagementProvider.notifier).setStatusFilter(value);
                  },
                  onVerificationStatusChanged: (value) {
                    ref.read(nutritionistManagementProvider.notifier).setVerificationStatusFilter(value);
                  },
                  onSpecializationChanged: (value) {
                    ref.read(nutritionistManagementProvider.notifier).setSpecializationFilter(value);
                  },
                  onSortChanged: (sortBy, sortOrder) {
                    ref.read(nutritionistManagementProvider.notifier).setSorting(sortBy, sortOrder);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilter(String label, String? value, String? current) {
    final isSelected = current == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          ref.read(nutritionistManagementProvider.notifier).setStatusFilter(selected ? value : null);
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        checkmarkColor: Theme.of(context).primaryColor,
      ),
    );
  }
}