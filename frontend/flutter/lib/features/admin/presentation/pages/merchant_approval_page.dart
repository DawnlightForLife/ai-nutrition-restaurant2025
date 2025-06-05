import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/merchant_approval_item.dart';

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
    // TODO: 从后端获取真实数据
    final pendingMerchants = _getMockPendingMerchants();
    
    if (pendingMerchants.isEmpty) {
      return _buildEmptyState('暂无待审核商户');
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: 刷新数据
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pendingMerchants.length,
        itemBuilder: (context, index) {
          final merchant = pendingMerchants[index];
          return MerchantApprovalItem(
            merchant: merchant,
            onApprove: () => _handleApprove(merchant['id']),
            onReject: () => _handleReject(merchant['id']),
            onViewDetail: () => _viewMerchantDetail(merchant),
          );
        },
      ),
    );
  }
  
  /// 构建已通过列表
  Widget _buildApprovedList() {
    // TODO: 从后端获取真实数据
    final approvedMerchants = _getMockApprovedMerchants();
    
    if (approvedMerchants.isEmpty) {
      return _buildEmptyState('暂无已通过商户');
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: 刷新数据
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: approvedMerchants.length,
        itemBuilder: (context, index) {
          final merchant = approvedMerchants[index];
          return MerchantApprovalItem(
            merchant: merchant,
            status: 'approved',
            onViewDetail: () => _viewMerchantDetail(merchant),
          );
        },
      ),
    );
  }
  
  /// 构建已拒绝列表
  Widget _buildRejectedList() {
    // TODO: 从后端获取真实数据
    final rejectedMerchants = _getMockRejectedMerchants();
    
    if (rejectedMerchants.isEmpty) {
      return _buildEmptyState('暂无已拒绝商户');
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: 刷新数据
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rejectedMerchants.length,
        itemBuilder: (context, index) {
          final merchant = rejectedMerchants[index];
          return MerchantApprovalItem(
            merchant: merchant,
            status: 'rejected',
            onViewDetail: () => _viewMerchantDetail(merchant),
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
    
    if (confirmed == true) {
      // TODO: 调用API通过审核
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('审核已通过')),
      );
      
      // 刷新列表
      setState(() {});
    }
  }
  
  /// 处理拒绝审核
  Future<void> _handleReject(String merchantId) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => _RejectReasonDialog(),
    );
    
    if (reason != null && reason.isNotEmpty) {
      // TODO: 调用API拒绝审核
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('审核已拒绝')),
      );
      
      // 刷新列表
      setState(() {});
    }
  }
  
  /// 查看商户详情
  void _viewMerchantDetail(Map<String, dynamic> merchant) {
    Navigator.of(context).pushNamed(
      '/admin/merchant-detail',
      arguments: merchant,
    );
  }
  
  /// 获取模拟待审核商户数据
  List<Map<String, dynamic>> _getMockPendingMerchants() {
    return [
      {
        'id': '1',
        'name': '张三烧烤店',
        'contactPerson': '张三',
        'phone': '13800138001',
        'address': '北京市朝阳区某某街道123号',
        'businessLicense': '91110105MA01234567',
        'submittedAt': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'id': '2',
        'name': '李四快餐店',
        'contactPerson': '李四',
        'phone': '13800138002',
        'address': '上海市浦东新区某某路456号',
        'businessLicense': '91310115MA87654321',
        'submittedAt': DateTime.now().subtract(const Duration(days: 1)),
      },
    ];
  }
  
  /// 获取模拟已通过商户数据
  List<Map<String, dynamic>> _getMockApprovedMerchants() {
    return [
      {
        'id': '3',
        'name': '王五餐厅',
        'contactPerson': '王五',
        'phone': '13800138003',
        'address': '广州市天河区某某大道789号',
        'businessLicense': '91440106MA11111111',
        'submittedAt': DateTime.now().subtract(const Duration(days: 3)),
        'approvedAt': DateTime.now().subtract(const Duration(days: 2)),
      },
    ];
  }
  
  /// 获取模拟已拒绝商户数据
  List<Map<String, dynamic>> _getMockRejectedMerchants() {
    return [
      {
        'id': '4',
        'name': '赵六小吃店',
        'contactPerson': '赵六',
        'phone': '13800138004',
        'address': '深圳市南山区某某科技园',
        'businessLicense': '91440300MA22222222',
        'submittedAt': DateTime.now().subtract(const Duration(days: 5)),
        'rejectedAt': DateTime.now().subtract(const Duration(days: 4)),
        'rejectReason': '营业执照照片不清晰，请重新上传',
      },
    ];
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