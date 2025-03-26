import 'package:flutter/material.dart';

class NutritionistVerificationManagement extends StatefulWidget {
  const NutritionistVerificationManagement({Key? key}) : super(key: key);

  @override
  State<NutritionistVerificationManagement> createState() => _NutritionistVerificationManagementState();
}

class _NutritionistVerificationManagementState extends State<NutritionistVerificationManagement> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String? _errorMessage;
  
  // 模拟数据，实际应用中应从API获取
  final List<Map<String, dynamic>> _pendingVerifications = [
    {
      'id': '1',
      'userName': '张三',
      'userPhone': '13800138001',
      'certificateUrl': 'https://example.com/cert1.jpg',
      'description': '国家认证营养师，五年从业经验，专注于慢性病饮食干预和儿童营养指导。',
      'applyTime': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '2',
      'userName': '李四',
      'userPhone': '13800138002',
      'certificateUrl': 'https://example.com/cert2.jpg',
      'description': '营养学硕士，三年临床营养工作经验，擅长运动营养和减重指导。',
      'applyTime': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '3',
      'userName': '王五',
      'userPhone': '13800138003',
      'certificateUrl': 'https://example.com/cert3.jpg',
      'description': '持有美国营养师协会认证，专注于运动营养和体重管理，为多家健身房提供营养咨询。',
      'applyTime': DateTime.now().subtract(const Duration(hours: 12)),
    },
  ];

  final List<Map<String, dynamic>> _approvedVerifications = [
    {
      'id': '4',
      'userName': '赵六',
      'userPhone': '13800138004',
      'certificateUrl': 'https://example.com/cert4.jpg',
      'description': '从事营养咨询8年，专注于孕产妇营养和婴幼儿辅食添加指导。',
      'applyTime': DateTime.now().subtract(const Duration(days: 10)),
      'approveTime': DateTime.now().subtract(const Duration(days: 8)),
    },
    {
      'id': '5',
      'userName': '钱七',
      'userPhone': '13800138005',
      'certificateUrl': 'https://example.com/cert5.jpg',
      'description': '中医营养师，擅长中医体质辨识和食疗方案定制。',
      'applyTime': DateTime.now().subtract(const Duration(days: 15)),
      'approveTime': DateTime.now().subtract(const Duration(days: 14)),
    },
  ];

  final List<Map<String, dynamic>> _rejectedVerifications = [
    {
      'id': '6',
      'userName': '孙八',
      'userPhone': '13800138006',
      'certificateUrl': 'https://example.com/cert6.jpg',
      'description': '营养爱好者，经常参加各类营养课程和讲座。',
      'applyTime': DateTime.now().subtract(const Duration(days: 20)),
      'rejectTime': DateTime.now().subtract(const Duration(days: 19)),
      'rejectReason': '提供的证书不符合要求，请上传国家认证的营养师资格证书。',
    },
    {
      'id': '7',
      'userName': '周九',
      'userPhone': '13800138007',
      'certificateUrl': 'https://example.com/cert7.jpg',
      'description': '自学营养知识三年，有丰富的个人经验。',
      'applyTime': DateTime.now().subtract(const Duration(days: 25)),
      'rejectTime': DateTime.now().subtract(const Duration(days: 24)),
      'rejectReason': '缺乏专业资质，需要提供正规的营养师资格证书。',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // 实际应用中，这里应该加载认证申请数据
    // _loadVerificationData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 实际应用中的数据加载函数
  Future<void> _loadVerificationData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 这里应该调用API获取数据
      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      // final result = await userProvider.getVerificationList();
      
      // 模拟网络延迟
      await Future.delayed(const Duration(seconds: 1));
      
      // 数据已在构造函数中初始化，此处无需赋值
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '加载数据失败：$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养师认证管理'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '待审核'),
            Tab(text: '已通过'),
            Tab(text: '已拒绝'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadVerificationData,
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPendingVerifications(),
                    _buildApprovedVerifications(),
                    _buildRejectedVerifications(),
                  ],
                ),
    );
  }

  // 待审核列表
  Widget _buildPendingVerifications() {
    if (_pendingVerifications.isEmpty) {
      return _buildEmptyState('暂无待审核申请', '当前没有需要审核的营养师认证申请');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pendingVerifications.length,
      itemBuilder: (context, index) {
        final verification = _pendingVerifications[index];
        return _buildVerificationCard(
          verification,
          showActions: true,
          onApprove: () {
            _showApproveConfirmDialog(verification);
          },
          onReject: () {
            _showRejectDialog(verification);
          },
        );
      },
    );
  }

  // 已通过列表
  Widget _buildApprovedVerifications() {
    if (_approvedVerifications.isEmpty) {
      return _buildEmptyState('暂无已通过申请', '当前没有已通过的营养师认证申请');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _approvedVerifications.length,
      itemBuilder: (context, index) {
        final verification = _approvedVerifications[index];
        return _buildVerificationCard(
          verification,
          showApproveInfo: true,
        );
      },
    );
  }

  // 已拒绝列表
  Widget _buildRejectedVerifications() {
    if (_rejectedVerifications.isEmpty) {
      return _buildEmptyState('暂无已拒绝申请', '当前没有已拒绝的营养师认证申请');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _rejectedVerifications.length,
      itemBuilder: (context, index) {
        final verification = _rejectedVerifications[index];
        return _buildVerificationCard(
          verification,
          showRejectInfo: true,
        );
      },
    );
  }

  // 认证卡片
  Widget _buildVerificationCard(
    Map<String, dynamic> verification, {
    bool showActions = false,
    bool showApproveInfo = false,
    bool showRejectInfo = false,
    VoidCallback? onApprove,
    VoidCallback? onReject,
  }) {
    final applyTime = verification['applyTime'] as DateTime;
    final formattedApplyTime = '${applyTime.year}-${applyTime.month.toString().padLeft(2, '0')}-${applyTime.day.toString().padLeft(2, '0')} ${applyTime.hour.toString().padLeft(2, '0')}:${applyTime.minute.toString().padLeft(2, '0')}';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部信息
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧证书预览（实际应用中应显示图片）
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.insert_drive_file, size: 40, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                
                // 右侧基本信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            verification['userName'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (showApproveInfo)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.green.shade200),
                              ),
                              child: const Text(
                                '已通过',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          if (showRejectInfo)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: const Text(
                                '已拒绝',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '电话: ${verification['userPhone']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '申请时间: $formattedApplyTime',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      
                      // 显示审批信息
                      if (showApproveInfo && verification['approveTime'] != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '通过时间: ${_formatDateTime(verification['approveTime'])}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                      
                      // 显示拒绝信息
                      if (showRejectInfo && verification['rejectTime'] != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '拒绝时间: ${_formatDateTime(verification['rejectTime'])}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 专业描述
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '专业描述',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  verification['description'],
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          
          // 拒绝原因
          if (showRejectInfo && verification['rejectReason'] != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '拒绝原因',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    verification['rejectReason'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // 操作按钮
          if (showActions) ...[
            const Divider(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 查看证书按钮
                  OutlinedButton.icon(
                    onPressed: () {
                      _showCertificateDetail(verification);
                    },
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('查看证书'),
                  ),
                  const SizedBox(width: 12),
                  
                  // 拒绝按钮
                  OutlinedButton.icon(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('拒绝'),
                  ),
                  const SizedBox(width: 12),
                  
                  // 通过按钮
                  ElevatedButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('通过'),
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  // 空状态
  Widget _buildEmptyState(String title, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 查看证书详情
  void _showCertificateDetail(Map<String, dynamic> verification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('证书详情'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 实际应用中这里应该显示证书图片
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '申请人: ${verification['userName']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('证书URL: ${verification['certificateUrl']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  // 审批通过确认对话框
  void _showApproveConfirmDialog(Map<String, dynamic> verification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认通过'),
        content: Text('确定通过 ${verification['userName']} 的营养师认证申请吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _approveVerification(verification);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  // 拒绝对话框
  void _showRejectDialog(Map<String, dynamic> verification) {
    final TextEditingController reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('拒绝申请'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('您将拒绝 ${verification['userName']} 的营养师认证申请'),
            const SizedBox(height: 16),
            const Text('拒绝原因:'),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: '请输入拒绝原因',
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
          TextButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入拒绝原因')),
                );
                return;
              }
              Navigator.pop(context);
              _rejectVerification(verification, reasonController.text);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('拒绝'),
          ),
        ],
      ),
    );
  }

  // 通过认证
  Future<void> _approveVerification(Map<String, dynamic> verification) async {
    // 显示加载状态
    setState(() {
      _isLoading = true;
    });

    try {
      // 实际应用中这里应该调用API
      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      // await userProvider.approveNutritionistVerification(verification['id']);
      
      // 模拟网络延迟
      await Future.delayed(const Duration(seconds: 1));
      
      // 模拟数据处理
      setState(() {
        // 从待审核列表移除
        _pendingVerifications.removeWhere((item) => item['id'] == verification['id']);
        
        // 添加到已通过列表
        _approvedVerifications.insert(0, {
          ...verification,
          'approveTime': DateTime.now(),
        });
        
        _isLoading = false;
      });
      
      // 显示成功消息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已通过 ${verification['userName']} 的认证申请')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败: $e')),
        );
      }
    }
  }

  // 拒绝认证
  Future<void> _rejectVerification(Map<String, dynamic> verification, String reason) async {
    // 显示加载状态
    setState(() {
      _isLoading = true;
    });

    try {
      // 实际应用中这里应该调用API
      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      // await userProvider.rejectNutritionistVerification(verification['id'], reason);
      
      // 模拟网络延迟
      await Future.delayed(const Duration(seconds: 1));
      
      // 模拟数据处理
      setState(() {
        // 从待审核列表移除
        _pendingVerifications.removeWhere((item) => item['id'] == verification['id']);
        
        // 添加到已拒绝列表
        _rejectedVerifications.insert(0, {
          ...verification,
          'rejectTime': DateTime.now(),
          'rejectReason': reason,
        });
        
        _isLoading = false;
      });
      
      // 显示成功消息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已拒绝 ${verification['userName']} 的认证申请')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败: $e')),
        );
      }
    }
  }

  // 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
} 