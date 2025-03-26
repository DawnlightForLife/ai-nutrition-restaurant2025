import 'package:flutter/material.dart';
import '../../../models/index.dart';

class NutritionistVerificationManagement extends StatefulWidget {
  const NutritionistVerificationManagement({super.key});

  @override
  State<NutritionistVerificationManagement> createState() => _NutritionistVerificationManagementState();
}

class _NutritionistVerificationManagementState extends State<NutritionistVerificationManagement> {
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
      // TODO: 从后端获取待审核的营养师认证申请
      // 这里使用模拟数据
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _pendingVerifications = [
          User(
            id: '1',
            nickname: '张医生',
            phone: '13800138001',
            email: 'doctor1@example.com',
            role: 'user',
            nutritionistVerificationStatus: 'pending',
            nutritionistVerificationData: {
              'qualification': '营养师资格证书',
              'experience': '5年营养咨询经验',
              'specialty': '儿童营养、运动营养',
            },
          ),
          User(
            id: '2',
            nickname: '李营养师',
            phone: '13800138002',
            email: 'nutritionist1@example.com',
            role: 'user',
            nutritionistVerificationStatus: 'pending',
            nutritionistVerificationData: {
              'qualification': '注册营养师证书',
              'experience': '3年临床营养经验',
              'specialty': '疾病营养、体重管理',
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
        title: const Text('营养师认证管理'),
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
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pendingVerifications.length,
                  itemBuilder: (context, index) {
                    final user = _pendingVerifications[index];
                    return Card(
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
                              '资格证书',
                              user.nutritionistVerificationData?['qualification'] ?? '未提供',
                            ),
                            const SizedBox(height: 8),
                            _buildVerificationInfo(
                              '从业经验',
                              user.nutritionistVerificationData?['experience'] ?? '未提供',
                            ),
                            const SizedBox(height: 8),
                            _buildVerificationInfo(
                              '专长领域',
                              user.nutritionistVerificationData?['specialty'] ?? '未提供',
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
                    );
                  },
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