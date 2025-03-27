import 'package:flutter/material.dart';
import '../../../models/index.dart';

class MerchantVerificationManagement extends StatefulWidget {
  const MerchantVerificationManagement({super.key});

  @override
  State<MerchantVerificationManagement> createState() => _MerchantVerificationManagementState();
}

class _MerchantVerificationManagementState extends State<MerchantVerificationManagement> {
  List<User> _pendingVerifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingVerifications();
  }

  Future<void> _loadPendingVerifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: 从后端获取待审核的商家认证申请
      // 这里使用模拟数据
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _pendingVerifications = [
          User(
            id: '3',
            nickname: '老王餐厅',
            phone: '13800138003',
            email: 'restaurant1@example.com',
            role: 'user',
            merchantVerificationStatus: 'pending',
            merchantVerificationData: {
              'businessLicense': '营业执照号：123456789',
              'address': '北京市朝阳区xxx街道xxx号',
              'businessType': '中餐厅',
              'description': '专注于健康营养的中式餐饮',
            },
          ),
          User(
            id: '4',
            nickname: '健康轻食',
            phone: '13800138004',
            email: 'healthfood@example.com',
            role: 'user',
            merchantVerificationStatus: 'pending',
            merchantVerificationData: {
              'businessLicense': '营业执照号：987654321',
              'address': '上海市浦东新区xxx路xxx号',
              'businessType': '轻食餐厅',
              'description': '提供健康美味的轻食料理',
            },
          ),
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败：$e')),
        );
      }
    }
  }

  Future<void> _handleVerification(User user, bool approved) async {
    try {
      // TODO: 调用后端API处理认证申请
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(approved ? '已通过认证' : '已拒绝认证'),
            backgroundColor: approved ? Colors.green : Colors.red,
          ),
        );
        
        // 刷新列表
        _loadPendingVerifications();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败：$e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商家认证管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPendingVerifications,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingVerifications.isEmpty
              ? const Center(
                  child: Text(
                    '暂无待审核的认证申请',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: _pendingVerifications.map((user) => Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    child: Text(user.nickname[0]),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.nickname,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          user.phone,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      '待审核',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                              _buildVerificationInfo(
                                '营业执照',
                                user.merchantVerificationData?['businessLicense'] ?? '未提供',
                              ),
                              const SizedBox(height: 8),
                              _buildVerificationInfo(
                                '经营地址',
                                user.merchantVerificationData?['address'] ?? '未提供',
                              ),
                              const SizedBox(height: 8),
                              _buildVerificationInfo(
                                '经营类型',
                                user.merchantVerificationData?['businessType'] ?? '未提供',
                              ),
                              const SizedBox(height: 8),
                              _buildVerificationInfo(
                                '商家简介',
                                user.merchantVerificationData?['description'] ?? '未提供',
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => _handleVerification(user, false),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('拒绝'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => _handleVerification(user, true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('通过'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                ),
    );
  }

  Widget _buildVerificationInfo(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
} 