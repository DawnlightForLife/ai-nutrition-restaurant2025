import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/merchant_approval_item.dart';
import '../providers/merchant_approval_provider.dart';
import '../../../../shared/widgets/common/toast.dart';

/// 商户审核列表页面
class MerchantApprovalPage extends ConsumerStatefulWidget {
  const MerchantApprovalPage({super.key});

  @override
  ConsumerState<MerchantApprovalPage> createState() => _MerchantApprovalPageState();
}

class _MerchantApprovalPageState extends ConsumerState<MerchantApprovalPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
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
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('商户审核'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '待审核'),
            Tab(text: '已通过'),
            Tab(text: '已拒绝'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingList(),
          _buildApprovedList(),
          _buildRejectedList(),
        ],
      ),
    );
  }
  
  /// 构建待审核列表
  Widget _buildPendingList() {
    final approvalState = ref.watch(merchantApprovalProvider);
    
    if (approvalState.isLoading && approvalState.pendingMerchants.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (approvalState.error != null && approvalState.pendingMerchants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('加载失败: ${approvalState.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(merchantApprovalProvider.notifier).refresh(),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }
    
    if (approvalState.pendingMerchants.isEmpty) {
      return _buildEmptyState('暂无待审核商户');
    }
    
    return RefreshIndicator(
      onRefresh: () => ref.read(merchantApprovalProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: approvalState.pendingMerchants.length + 
            (approvalState.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == approvalState.pendingMerchants.length) {
            // 加载更多
            ref.read(merchantApprovalProvider.notifier).loadMore();
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          final merchant = approvalState.pendingMerchants[index];
          return MerchantApprovalItem(
            merchant: merchant.toJson(),
            onApprove: () => _handleApprove(merchant.id),
            onReject: () => _handleReject(merchant.id),
            onViewDetail: () => _viewMerchantDetail(merchant.toJson()),
          );
        },
      ),
    );
  }
  
  /// 构建已通过列表
  Widget _buildApprovedList() {
    final approvalState = ref.watch(merchantApprovalProvider);
    
    if (approvalState.isLoading && approvalState.approvedMerchants.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (approvalState.approvedMerchants.isEmpty) {
      return _buildEmptyState('暂无已通过商户');
    }
    
    return RefreshIndicator(
      onRefresh: () => ref.read(merchantApprovalProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: approvalState.approvedMerchants.length,
        itemBuilder: (context, index) {
          final merchant = approvalState.approvedMerchants[index];
          return MerchantApprovalItem(
            merchant: merchant.toJson(),
            status: 'approved',
            onViewDetail: () => _viewMerchantDetail(merchant.toJson()),
          );
        },
      ),
    );
  }
  
  /// 构建已拒绝列表
  Widget _buildRejectedList() {
    final approvalState = ref.watch(merchantApprovalProvider);
    
    if (approvalState.isLoading && approvalState.rejectedMerchants.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (approvalState.rejectedMerchants.isEmpty) {
      return _buildEmptyState('暂无已拒绝商户');
    }
    
    return RefreshIndicator(
      onRefresh: () => ref.read(merchantApprovalProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: approvalState.rejectedMerchants.length,
        itemBuilder: (context, index) {
          final merchant = approvalState.rejectedMerchants[index];
          return MerchantApprovalItem(
            merchant: merchant.toJson(),
            status: 'rejected',
            onViewDetail: () => _viewMerchantDetail(merchant.toJson()),
          );
        },
      ),
    );
  }
  
  /// 构建空状态
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
  
  /// 处理通过审核
  Future<void> _handleApprove(String merchantId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认通过审核'),
        content: const Text('确定要通过该商户的入驻申请吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    
    if (confirmed == true && mounted) {
      final success = await ref.read(merchantApprovalProvider.notifier).verifyMerchant(
        merchantId,
        status: 'approved',
      );
      
      if (mounted) {
        if (success) {
          Toast.success(context, '审核已通过');
        } else {
          Toast.error(context, '操作失败，请重试');
        }
      }
    }
  }
  
  /// 处理拒绝审核
  Future<void> _handleReject(String merchantId) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => _RejectReasonDialog(),
    );
    
    if (reason != null && reason.isNotEmpty && mounted) {
      final success = await ref.read(merchantApprovalProvider.notifier).verifyMerchant(
        merchantId,
        status: 'rejected',
        rejectionReason: reason,
      );
      
      if (mounted) {
        if (success) {
          Toast.success(context, '审核已拒绝');
        } else {
          Toast.error(context, '操作失败，请重试');
        }
      }
    }
  }
  
  /// 查看商户详情
  void _viewMerchantDetail(Map<String, dynamic> merchant) {
    Navigator.of(context).pushNamed(
      '/admin/merchant-detail',
      arguments: merchant,
    );
  }
}

/// 拒绝原因对话框
class _RejectReasonDialog extends StatefulWidget {
  @override
  State<_RejectReasonDialog> createState() => _RejectReasonDialogState();
}

class _RejectReasonDialogState extends State<_RejectReasonDialog> {
  final _controller = TextEditingController();
  final _reasons = [
    '营业执照不清晰',
    '资质证明不完整',
    '信息填写有误',
    '不符合平台要求',
    '其他原因',
  ];
  String? _selectedReason;
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('拒绝原因'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('请选择或填写拒绝原因：'),
            const SizedBox(height: 16),
            ..._reasons.map((reason) => RadioListTile<String>(
              title: Text(reason),
              value: reason,
              groupValue: _selectedReason,
              onChanged: (value) {
                setState(() {
                  _selectedReason = value;
                  if (value != '其他原因') {
                    _controller.text = value!;
                  } else {
                    _controller.clear();
                  }
                });
              },
            )),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '请输入详细原因',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.of(context).pop(_controller.text);
            }
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}