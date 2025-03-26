import 'package:flutter/material.dart';
import 'merchant_code_management.dart';

class MerchantManagement extends StatefulWidget {
  const MerchantManagement({Key? key}) : super(key: key);

  @override
  State<MerchantManagement> createState() => _MerchantManagementState();
}

class _MerchantManagementState extends State<MerchantManagement> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String? _errorMessage;
  
  // 模拟数据，实际应用中应从API获取
  final List<Map<String, dynamic>> _merchantList = [
    {
      'id': '1',
      'name': '健康食客餐厅',
      'ownerName': '张三',
      'phone': '13800138001',
      'address': '北京市朝阳区健康路123号',
      'business': '健康餐饮',
      'createdAt': DateTime.now().subtract(const Duration(days: 30)),
      'status': 'active',
    },
    {
      'id': '2',
      'name': '绿叶营养餐厅',
      'ownerName': '李四',
      'phone': '13800138002',
      'address': '上海市浦东新区营养路456号',
      'business': '轻食沙拉',
      'createdAt': DateTime.now().subtract(const Duration(days: 60)),
      'status': 'active',
    },
    {
      'id': '3',
      'name': '膳食平衡馆',
      'ownerName': '王五',
      'phone': '13800138003',
      'address': '广州市天河区平衡路789号',
      'business': '中式营养套餐',
      'createdAt': DateTime.now().subtract(const Duration(days: 45)),
      'status': 'active',
    },
    {
      'id': '4',
      'name': '暂停营业餐厅',
      'ownerName': '赵六',
      'phone': '13800138004',
      'address': '深圳市南山区科技路101号',
      'business': '营养快餐',
      'createdAt': DateTime.now().subtract(const Duration(days: 90)),
      'status': 'suspended',
    },
  ];

  final List<Map<String, dynamic>> _merchantVerifications = [
    {
      'id': '5',
      'name': '新鲜水果店',
      'ownerName': '钱七',
      'phone': '13800138005',
      'address': '成都市锦江区水果路202号',
      'business': '水果零售与果汁制作',
      'licenseUrl': 'https://example.com/license1.jpg',
      'applyTime': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'id': '6',
      'name': '有机蔬菜坊',
      'ownerName': '孙八',
      'phone': '13800138006',
      'address': '杭州市西湖区蔬菜路303号',
      'business': '有机蔬菜配送',
      'licenseUrl': 'https://example.com/license2.jpg',
      'applyTime': DateTime.now().subtract(const Duration(days: 5)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // 实际应用中，这里应该加载商家数据
    // _loadMerchantData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 实际应用中的数据加载函数
  Future<void> _loadMerchantData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 这里应该调用API获取数据
      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      // final merchants = await userProvider.getMerchantList();
      // final verifications = await userProvider.getMerchantVerifications();
      
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
        title: const Text('商家管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.vpn_key),
            tooltip: '注册码管理',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MerchantCodeManagement(),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '商家列表'),
            Tab(text: '入驻申请'),
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
                        onPressed: _loadMerchantData,
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMerchantList(),
                    _buildMerchantVerifications(),
                  ],
                ),
    );
  }

  // 商家列表
  Widget _buildMerchantList() {
    if (_merchantList.isEmpty) {
      return _buildEmptyState('暂无商家', '还没有入驻的商家');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _merchantList.length,
      itemBuilder: (context, index) {
        final merchant = _merchantList[index];
        return _buildMerchantCard(merchant);
      },
    );
  }

  // 入驻申请列表
  Widget _buildMerchantVerifications() {
    if (_merchantVerifications.isEmpty) {
      return _buildEmptyState('暂无入驻申请', '当前没有待审核的商家入驻申请');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _merchantVerifications.length,
      itemBuilder: (context, index) {
        final verification = _merchantVerifications[index];
        return _buildVerificationCard(verification);
      },
    );
  }

  // 商家卡片
  Widget _buildMerchantCard(Map<String, dynamic> merchant) {
    final String status = merchant['status'] as String;
    final bool isActive = status == 'active';

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
                // 左侧图标
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      merchant['name'][0],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // 右侧基本信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              merchant['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.green.shade50 : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isActive ? Colors.green.shade200 : Colors.red.shade200,
                              ),
                            ),
                            child: Text(
                              isActive ? '正常营业' : '已暂停',
                              style: TextStyle(
                                fontSize: 12,
                                color: isActive ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '负责人: ${merchant['ownerName']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '电话: ${merchant['phone']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '业务: ${merchant['business']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 地址
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '地址: ${merchant['address']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 入驻时间
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  '入驻时间: ${_formatDate(merchant['createdAt'])}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // 操作按钮
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 查看详情按钮
                OutlinedButton.icon(
                  onPressed: () {
                    _showMerchantDetailsDialog(merchant);
                  },
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('查看详情'),
                ),
                const SizedBox(width: 12),
                
                // 状态切换按钮
                ElevatedButton.icon(
                  onPressed: () {
                    _toggleMerchantStatus(merchant);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActive ? Colors.red : Colors.green,
                  ),
                  icon: Icon(isActive ? Icons.pause : Icons.play_arrow, size: 16),
                  label: Text(isActive ? '暂停' : '启用'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 入驻申请卡片
  Widget _buildVerificationCard(Map<String, dynamic> verification) {
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
                // 左侧执照预览（实际应显示图片）
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
                      Text(
                        verification['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '负责人: ${verification['ownerName']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '电话: ${verification['phone']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '业务: ${verification['business']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 地址
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '地址: ${verification['address']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 申请时间
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  '申请时间: ${_formatDate(verification['applyTime'])}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // 操作按钮
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 查看执照按钮
                OutlinedButton.icon(
                  onPressed: () {
                    _showLicenseDetail(verification);
                  },
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('查看执照'),
                ),
                const SizedBox(width: 12),
                
                // 拒绝按钮
                OutlinedButton.icon(
                  onPressed: () {
                    _showRejectDialog(verification);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('拒绝'),
                ),
                const SizedBox(width: 12),
                
                // 通过按钮
                ElevatedButton.icon(
                  onPressed: () {
                    _showApproveConfirmDialog(verification);
                  },
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('通过'),
                ),
              ],
            ),
          ),
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
            Icons.store_mall_directory,
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

  // 查看商家详情
  void _showMerchantDetailsDialog(Map<String, dynamic> merchant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${merchant['name']} 详情'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('商家名称', merchant['name']),
              _buildDetailItem('负责人', merchant['ownerName']),
              _buildDetailItem('联系电话', merchant['phone']),
              _buildDetailItem('地址', merchant['address']),
              _buildDetailItem('业务范围', merchant['business']),
              _buildDetailItem('入驻时间', _formatDate(merchant['createdAt'])),
              _buildDetailItem('状态', merchant['status'] == 'active' ? '正常营业' : '已暂停'),
            ],
          ),
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

  // 详情项
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // 查看执照详情
  void _showLicenseDetail(Map<String, dynamic> verification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('营业执照'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 实际应用中这里应该显示执照图片
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
              '商家名称: ${verification['name']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('执照URL: ${verification['licenseUrl']}'),
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
        content: Text('确定通过 ${verification['name']} 的商家入驻申请吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _approveMerchant(verification);
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
            Text('您将拒绝 ${verification['name']} 的商家入驻申请'),
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
              _rejectMerchant(verification, reasonController.text);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('拒绝'),
          ),
        ],
      ),
    );
  }

  // 切换商家状态
  Future<void> _toggleMerchantStatus(Map<String, dynamic> merchant) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 实际应用中这里应该调用API
      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      // await userProvider.toggleMerchantStatus(merchant['id']);
      
      // 模拟网络延迟
      await Future.delayed(const Duration(seconds: 1));
      
      final bool isCurrentlyActive = merchant['status'] == 'active';
      final String newStatus = isCurrentlyActive ? 'suspended' : 'active';
      
      setState(() {
        // 更新商家状态
        for (var i = 0; i < _merchantList.length; i++) {
          if (_merchantList[i]['id'] == merchant['id']) {
            _merchantList[i]['status'] = newStatus;
            break;
          }
        }
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCurrentlyActive
                ? '已暂停 ${merchant['name']} 的营业状态'
                : '已恢复 ${merchant['name']} 的营业状态',
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('操作失败: $e')),
      );
    }
  }

  // 通过商家申请
  Future<void> _approveMerchant(Map<String, dynamic> verification) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 实际应用中这里应该调用API
      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      // await userProvider.approveMerchant(verification['id']);
      
      // 模拟网络延迟
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        // 从申请列表移除
        _merchantVerifications.removeWhere((item) => item['id'] == verification['id']);
        
        // 添加到商家列表
        _merchantList.add({
          'id': verification['id'],
          'name': verification['name'],
          'ownerName': verification['ownerName'],
          'phone': verification['phone'],
          'address': verification['address'],
          'business': verification['business'],
          'createdAt': DateTime.now(),
          'status': 'active',
        });
        
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已通过 ${verification['name']} 的商家入驻申请')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('操作失败: $e')),
      );
    }
  }

  // 拒绝商家申请
  Future<void> _rejectMerchant(Map<String, dynamic> verification, String reason) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 实际应用中这里应该调用API
      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      // await userProvider.rejectMerchant(verification['id'], reason);
      
      // 模拟网络延迟
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        // 从申请列表移除
        _merchantVerifications.removeWhere((item) => item['id'] == verification['id']);
        
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已拒绝 ${verification['name']} 的商家入驻申请')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('操作失败: $e')),
      );
    }
  }

  // 格式化日期
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
} 