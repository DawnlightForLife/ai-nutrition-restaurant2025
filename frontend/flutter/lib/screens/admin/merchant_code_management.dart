import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/index.dart';
import 'dart:math';

class MerchantCodeManagement extends StatefulWidget {
  const MerchantCodeManagement({Key? key}) : super(key: key);

  @override
  State<MerchantCodeManagement> createState() => _MerchantCodeManagementState();
}

class _MerchantCodeManagementState extends State<MerchantCodeManagement> {
  bool _isLoading = false;
  String? _errorMessage;
  
  // 模拟数据，实际应用中应从API获取
  final List<Map<String, dynamic>> _merchantCodes = [
    {
      'id': '1',
      'code': 'MERCHANT2023A001',
      'isUsed': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 30)),
      'expiresAt': DateTime.now().add(const Duration(days: 335)),
      'usedById': '101',
      'usedByName': '健康食客餐厅',
      'usedAt': DateTime.now().subtract(const Duration(days: 25)),
    },
    {
      'id': '2',
      'code': 'MERCHANT2023A002',
      'isUsed': false,
      'createdAt': DateTime.now().subtract(const Duration(days: 20)),
      'expiresAt': DateTime.now().add(const Duration(days: 345)),
      'usedById': null,
      'usedByName': null,
      'usedAt': null,
    },
    {
      'id': '3',
      'code': 'MERCHANT2023A003',
      'isUsed': false,
      'createdAt': DateTime.now().subtract(const Duration(days: 15)),
      'expiresAt': DateTime.now().add(const Duration(days: 350)),
      'usedById': null,
      'usedByName': null,
      'usedAt': null,
    },
    {
      'id': '4',
      'code': 'MERCHANT2023B001',
      'isUsed': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 60)),
      'expiresAt': DateTime.now().add(const Duration(days: 305)),
      'usedById': '102',
      'usedByName': '绿叶营养餐厅',
      'usedAt': DateTime.now().subtract(const Duration(days: 45)),
    },
    {
      'id': '5',
      'code': 'MERCHANT2023B002',
      'isUsed': false,
      'createdAt': DateTime.now().subtract(const Duration(days: 10)),
      'expiresAt': DateTime.now().subtract(const Duration(days: 5)),
      'usedById': null,
      'usedByName': null,
      'usedAt': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    // 实际应用中，这里应该加载注册码数据
    // _loadMerchantCodes();
  }

  // 实际应用中的数据加载函数
  Future<void> _loadMerchantCodes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 这里应该调用API获取数据
      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      // final codes = await userProvider.getMerchantCodes();
      
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
        title: const Text('商家注册码管理'),
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
                        onPressed: _loadMerchantCodes,
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                )
              : _buildCodeList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showGenerateCodeDialog,
        tooltip: '生成新注册码',
        child: const Icon(Icons.add),
      ),
    );
  }

  // 构建注册码列表
  Widget _buildCodeList() {
    if (_merchantCodes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.vpn_key,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            const Text(
              '暂无注册码',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '点击下方的"+"按钮生成新的商家注册码',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _merchantCodes.length,
      itemBuilder: (context, index) {
        final code = _merchantCodes[index];
        return _buildCodeCard(code);
      },
    );
  }

  // 构建注册码卡片
  Widget _buildCodeCard(Map<String, dynamic> code) {
    final bool isUsed = code['isUsed'] as bool;
    final DateTime expiresAt = code['expiresAt'] as DateTime;
    final bool isExpired = expiresAt.isBefore(DateTime.now());
    
    // 确定状态和颜色
    String status;
    Color statusColor;
    
    if (isUsed) {
      status = '已使用';
      statusColor = Colors.blue;
    } else if (isExpired) {
      status = '已过期';
      statusColor = Colors.red;
    } else {
      status = '可用';
      statusColor = Colors.green;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 注册码和状态
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '商家注册码',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.vpn_key, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            code['code'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              // 复制到剪贴板
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('已复制注册码: ${code['code']}')),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: statusColor.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 创建和过期时间
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '创建时间',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(_formatDate(code['createdAt'])),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '过期时间',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(code['expiresAt']),
                        style: TextStyle(
                          color: isExpired ? Colors.red : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // 如果已使用，显示使用信息
            if (isUsed) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                '使用信息',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '使用者',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(code['usedByName']),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '使用时间',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(_formatDate(code['usedAt'])),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            
            // 操作按钮
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 仅对未使用的注册码显示删除按钮
                if (!isUsed)
                  OutlinedButton.icon(
                    onPressed: () {
                      _showDeleteConfirmDialog(code);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('删除'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 显示生成注册码对话框
  void _showGenerateCodeDialog() {
    final TextEditingController countController = TextEditingController(text: '1');
    final TextEditingController validityController = TextEditingController(text: '365');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('生成商家注册码'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: countController,
              decoration: const InputDecoration(
                labelText: '数量',
                hintText: '输入需要生成的注册码数量',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: validityController,
              decoration: const InputDecoration(
                labelText: '有效期(天)',
                hintText: '输入注册码的有效期天数',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
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
              // 验证输入
              int? count = int.tryParse(countController.text);
              int? validity = int.tryParse(validityController.text);
              
              if (count == null || count <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入有效的数量')),
                );
                return;
              }
              
              if (validity == null || validity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入有效的有效期天数')),
                );
                return;
              }
              
              Navigator.pop(context);
              _generateMerchantCodes(count, validity);
            },
            child: const Text('生成'),
          ),
        ],
      ),
    );
  }

  // 显示删除确认对话框
  void _showDeleteConfirmDialog(Map<String, dynamic> code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除注册码 ${code['code']} 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteMerchantCode(code);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  // 生成商家注册码
  Future<void> _generateMerchantCodes(int count, int validity) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 实际应用中这里应该调用API
      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      // final newCodes = await userProvider.generateMerchantCodes(count, validity);
      
      // 模拟网络延迟
      await Future.delayed(const Duration(seconds: 1));
      
      // 模拟生成新注册码
      final List<Map<String, dynamic>> newCodes = [];
      final now = DateTime.now();
      final expiry = now.add(Duration(days: validity));
      
      for (var i = 0; i < count; i++) {
        final codeNumber = _merchantCodes.length + i + 1;
        newCodes.add({
          'id': (int.parse(_merchantCodes.last['id']) + i + 1).toString(),
          'code': 'MERCHANT${now.year}C${codeNumber.toString().padLeft(3, '0')}',
          'isUsed': false,
          'createdAt': now,
          'expiresAt': expiry,
          'usedById': null,
          'usedByName': null,
          'usedAt': null,
        });
      }
      
      setState(() {
        _merchantCodes.addAll(newCodes);
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('成功生成 $count 个商家注册码')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('生成失败: $e')),
      );
    }
  }

  // 删除商家注册码
  Future<void> _deleteMerchantCode(Map<String, dynamic> code) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 实际应用中这里应该调用API
      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      // await userProvider.deleteMerchantCode(code['id']);
      
      // 模拟网络延迟
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _merchantCodes.removeWhere((item) => item['id'] == code['id']);
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已删除注册码 ${code['code']}')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('删除失败: $e')),
      );
    }
  }

  // 格式化日期
  String _formatDate(DateTime? date) {
    if (date == null) return '无';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
} 