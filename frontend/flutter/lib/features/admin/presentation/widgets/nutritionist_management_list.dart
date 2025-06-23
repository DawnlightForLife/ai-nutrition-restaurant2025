import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/nutritionist_management_provider.dart';
import '../../domain/entities/nutritionist_management_entity.dart';
import '../../../../shared/presentation/widgets/loading_widget.dart';
import '../../../../shared/presentation/widgets/error_widget.dart';
import '../../../nutritionist/presentation/providers/nutritionist_status_provider.dart';
import '../../../../core/services/websocket/nutritionist_status_websocket_service.dart';

class NutritionistManagementList extends ConsumerStatefulWidget {
  final Set<String> selectedNutritionists;
  final bool isAllSelected;
  final Function(String id, bool selected) onNutritionistSelected;
  final Function(bool selected) onSelectAll;
  final String? status;
  final String? verificationStatus;
  final String? specialization;
  final String search;
  final String sortBy;
  final String sortOrder;

  const NutritionistManagementList({
    Key? key,
    required this.selectedNutritionists,
    required this.isAllSelected,
    required this.onNutritionistSelected,
    required this.onSelectAll,
    this.status,
    this.verificationStatus,
    this.specialization,
    required this.search,
    required this.sortBy,
    required this.sortOrder,
  }) : super(key: key);

  @override
  ConsumerState<NutritionistManagementList> createState() => _NutritionistManagementListState();
}

class _NutritionistManagementListState extends ConsumerState<NutritionistManagementList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNutritionists();
    });
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribeToNutritionistStatuses();
  }

  @override
  void didUpdateWidget(NutritionistManagementList oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 如果筛选条件发生变化，重新加载数据
    if (oldWidget.status != widget.status ||
        oldWidget.verificationStatus != widget.verificationStatus ||
        oldWidget.specialization != widget.specialization ||
        oldWidget.search != widget.search ||
        oldWidget.sortBy != widget.sortBy ||
        oldWidget.sortOrder != widget.sortOrder) {
      _loadNutritionists();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = ref.read(nutritionistManagementProvider);
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!state.isLoadingMore && state.currentPage < state.totalPages) {
        ref.read(nutritionistManagementProvider.notifier).loadMore();
      }
    }
  }

  void _loadNutritionists() {
    final notifier = ref.read(nutritionistManagementProvider.notifier);
    notifier.loadNutritionists(refresh: true);
  }
  
  void _subscribeToNutritionistStatuses() {
    final state = ref.read(nutritionistManagementProvider);
    if (state.nutritionists.isNotEmpty) {
      final nutritionistIds = state.nutritionists.map((n) => n.id).toList();
      ref.read(nutritionistStatusProvider.notifier).subscribeToNutritionistStatus(nutritionistIds);
    }
  }

  void _showNutritionistDetail(NutritionistManagementEntity nutritionist) {
    Navigator.pushNamed(
      context,
      '/admin/nutritionist-detail',
      arguments: nutritionist.id,
    );
  }

  void _showStatusChangeDialog(NutritionistManagementEntity nutritionist) {
    showDialog(
      context: context,
      builder: (context) => _StatusChangeDialog(
        nutritionist: nutritionist,
        onStatusChanged: (status, reason) {
          _updateNutritionistStatus(nutritionist.id, status, reason);
        },
      ),
    );
  }

  Future<void> _updateNutritionistStatus(String id, String status, String reason) async {
    final notifier = ref.read(nutritionistManagementProvider.notifier);
    final success = await notifier.updateNutritionistStatus(id, status, reason: reason);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '营养师状态更新成功' : '更新失败，请重试'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nutritionistManagementProvider);

    if (state.isLoading && state.nutritionists.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.nutritionists.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('加载失败: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadNutritionists,
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (state.nutritionists.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('暂无营养师数据', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      children: [
        // 列表头部 - 全选/排序
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              Checkbox(
                value: widget.isAllSelected,
                onChanged: (value) => widget.onSelectAll(value ?? false),
              ),
              const Text('全选'),
              const Spacer(),
              Text('共 ${state.totalRecords} 条记录，已显示 ${state.nutritionists.length} 条'),
            ],
          ),
        ),
        
        // 营养师列表
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.nutritionists.length + (state.currentPage < state.totalPages ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.nutritionists.length) {
                return state.isLoadingMore
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox.shrink();
              }

              final nutritionist = state.nutritionists[index];
              final isSelected = widget.selectedNutritionists.contains(nutritionist.id);

              return Consumer(
                builder: (context, ref, child) {
                  // 监听实时状态更新
                  final realtimeStatus = ref.watch(nutritionistStatusByIdProvider(nutritionist.id));
                  
                  return NutritionistListItem(
                    nutritionist: nutritionist,
                    isSelected: isSelected,
                    realtimeStatus: realtimeStatus,
                    onSelected: (selected) => widget.onNutritionistSelected(
                      nutritionist.id,
                      selected,
                    ),
                    onTap: () => _showNutritionistDetail(nutritionist),
                    onStatusChange: () => _showStatusChangeDialog(nutritionist),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class NutritionistListItem extends StatelessWidget {
  final NutritionistManagementEntity nutritionist;
  final bool isSelected;
  final NutritionistOnlineStatus? realtimeStatus;
  final Function(bool) onSelected;
  final VoidCallback onTap;
  final VoidCallback onStatusChange;

  const NutritionistListItem({
    Key? key,
    required this.nutritionist,
    required this.isSelected,
    this.realtimeStatus,
    required this.onSelected,
    required this.onTap,
    required this.onStatusChange,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.orange;
      case 'suspended':
        return Colors.red;
      case 'pendingVerification':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return '活跃';
      case 'inactive':
        return '不活跃';
      case 'suspended':
        return '已暂停';
      case 'pendingVerification':
        return '待审核';
      default:
        return '未知';
    }
  }

  Widget _buildSpecializationChips(List<String> specializations) {
    final Map<String, String> specializationNames = {
      'clinical': '临床营养',
      'sports': '运动营养', 
      'pediatric': '儿童营养',
      'geriatric': '老年营养',
      'chronic': '慢病营养',
      'weight': '减重营养',
      'maternal': '孕产妇营养',
      'functional': '功能性营养',
      'traditional': '中医营养',
      'safety': '食品安全',
    };

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: specializations.take(3).map((spec) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Text(
            specializationNames[spec] ?? spec,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[700],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 选择框
              Checkbox(
                value: isSelected,
                onChanged: onSelected,
              ),
              
              const SizedBox(width: 12),
              
              // 头像
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[300],
                backgroundImage: nutritionist.avatar != null
                    ? NetworkImage(nutritionist.avatar!)
                    : null,
                child: nutritionist.avatar == null
                    ? Text(
                        nutritionist.realName.substring(0, 1),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
              
              const SizedBox(width: 16),
              
              // 主要信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 姓名和在线状态
                    Row(
                      children: [
                        Text(
                          nutritionist.realName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildOnlineStatusIndicator(),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // 联系方式
                    Text(
                      '${nutritionist.phone ?? '未提供'} | ${nutritionist.licenseNumber}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // 专业领域
                    _buildSpecializationChips(nutritionist.specializations),
                    
                    const SizedBox(height: 8),
                    
                    // 统计信息
                    Row(
                      children: [
                        _buildStatItem('咨询', '${nutritionist.stats?.totalConsultations ?? 0}'),
                        _buildStatItem('评分', '${nutritionist.averageRating.toStringAsFixed(1)}'),
                        _buildStatItem('收入', '¥${nutritionist.stats?.totalIncome ?? 0}'),
                      ],
                    ),
                  ],
                ),
              ),
              
              // 状态和操作
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 状态标签
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(nutritionist.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _getStatusColor(nutritionist.status)),
                    ),
                    child: Text(
                      _getStatusText(nutritionist.status),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(nutritionist.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 操作按钮
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: onStatusChange,
                        tooltip: '修改状态',
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline, size: 20),
                        onPressed: onTap,
                        tooltip: '查看详情',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineStatusIndicator() {
    // 优先使用实时状态，否则使用基础状态
    final isOnline = realtimeStatus?.isOnline ?? nutritionist.isOnline;
    final isAvailable = realtimeStatus?.isAvailable ?? nutritionist.isAvailable;
    
    if (!isOnline) {
      return Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
      );
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isAvailable ? Colors.green : Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
        if (realtimeStatus?.statusMessage != null) ...[
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              realtimeStatus!.statusMessage!,
              style: const TextStyle(fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChangeDialog extends StatefulWidget {
  final NutritionistManagementEntity nutritionist;
  final Function(String status, String reason) onStatusChanged;

  const _StatusChangeDialog({
    Key? key,
    required this.nutritionist,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  State<_StatusChangeDialog> createState() => _StatusChangeDialogState();
}

class _StatusChangeDialogState extends State<_StatusChangeDialog> {
  late String _selectedStatus;
  final _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.nutritionist.status;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('修改营养师状态 - ${widget.nutritionist.realName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedStatus,
            decoration: const InputDecoration(
              labelText: '状态',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'active', child: Text('活跃')),
              DropdownMenuItem(value: 'inactive', child: Text('不活跃')),
              DropdownMenuItem(value: 'suspended', child: Text('暂停')),
              DropdownMenuItem(value: 'pendingVerification', child: Text('待审核')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedStatus = value!;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              labelText: '变更原因（可选）',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onStatusChanged(_selectedStatus, _reasonController.text);
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}