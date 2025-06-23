import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../nutritionist/domain/entities/nutritionist_certification.dart';
import '../../../nutritionist/presentation/providers/nutritionist_provider.dart';

class CertificationReviewPage extends ConsumerStatefulWidget {
  const CertificationReviewPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CertificationReviewPage> createState() => _CertificationReviewPageState();
}

class _CertificationReviewPageState extends ConsumerState<CertificationReviewPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<CertificationStatus?> _statusTabs = [
    null, // 全部
    CertificationStatus.pending,
    CertificationStatus.underReview,
    CertificationStatus.approved,
    CertificationStatus.rejected,
  ];

  final List<String> _tabTitles = [
    '全部',
    '待审核',
    '审核中',
    '已通过',
    '已拒绝',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
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
        title: const Text('营养师认证审核'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _statusTabs.map((status) {
          return _buildCertificationList(status);
        }).toList(),
      ),
    );
  }

  Widget _buildCertificationList(CertificationStatus? status) {
    // 这里应该连接到实际的认证审核provider
    // 目前显示演示内容
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // 演示数据
      itemBuilder: (context, index) {
        return _buildCertificationCard(index);
      },
    );
  }

  Widget _buildCertificationCard(int index) {
    // 演示数据
    final certificationData = {
      'id': 'cert_$index',
      'applicantName': '申请人${index + 1}',
      'education': '营养学硕士',
      'experience': '${index + 3}年',
      'specialties': ['临床营养', '运动营养'],
      'status': _statusTabs[(index % 4) + 1],
      'submitDate': DateTime.now().subtract(Duration(days: index)),
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    certificationData['applicantName'].toString()[2],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        certificationData['applicantName'].toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        certificationData['education'].toString(),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(certificationData['status'] as CertificationStatus),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Icon(Icons.work, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${certificationData['experience']} 工作经验',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${certificationData['submitDate'].toString().split(' ')[0]}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Wrap(
              spacing: 6,
              children: (certificationData['specialties'] as List).map((specialty) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    specialty.toString(),
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => _viewCertificationDetail(certificationData['id'].toString()),
                  child: const Text('查看详情'),
                ),
                const SizedBox(width: 8),
                if (certificationData['status'] == CertificationStatus.pending)
                  ElevatedButton(
                    onPressed: () => _reviewCertification(certificationData['id'].toString()),
                    child: const Text('开始审核'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(CertificationStatus status) {
    Color backgroundColor;
    String statusText;
    
    switch (status) {
      case CertificationStatus.pending:
        backgroundColor = Colors.orange;
        statusText = '待审核';
        break;
      case CertificationStatus.underReview:
        backgroundColor = Colors.blue;
        statusText = '审核中';
        break;
      case CertificationStatus.approved:
        backgroundColor = Colors.green;
        statusText = '已通过';
        break;
      case CertificationStatus.rejected:
        backgroundColor = Colors.red;
        statusText = '已拒绝';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _viewCertificationDetail(String certificationId) {
    // 导航到认证详情页面
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _CertificationDetailPage(certificationId: certificationId),
      ),
    );
  }

  void _reviewCertification(String certificationId) {
    // 开始审核流程
    showDialog(
      context: context,
      builder: (context) => _ReviewDialog(certificationId: certificationId),
    );
  }
}

class _CertificationDetailPage extends StatelessWidget {
  final String certificationId;

  const _CertificationDetailPage({required this.certificationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('认证详情'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '基本信息',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoCard('姓名', '张营养师'),
            _buildInfoCard('学历', '营养学硕士'),
            _buildInfoCard('工作经验', '5年'),
            _buildInfoCard('专业领域', '临床营养、运动营养'),
            
            const SizedBox(height: 24),
            
            const Text(
              '资质证明',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // 证书图片展示区域
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('营养师资格证书'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      ),
    );
  }
}

class _ReviewDialog extends StatefulWidget {
  final String certificationId;

  const _ReviewDialog({required this.certificationId});

  @override
  State<_ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<_ReviewDialog> {
  CertificationStatus? _selectedStatus;
  final TextEditingController _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('审核认证申请'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<CertificationStatus>(
            decoration: const InputDecoration(
              labelText: '审核结果',
              border: OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(
                value: CertificationStatus.approved,
                child: Text('通过'),
              ),
              DropdownMenuItem(
                value: CertificationStatus.rejected,
                child: Text('拒绝'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          TextField(
            controller: _reasonController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '审核意见',
              hintText: '请填写审核意见...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _selectedStatus != null ? _submitReview : null,
          child: const Text('提交'),
        ),
      ],
    );
  }

  void _submitReview() {
    // 提交审核结果
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('审核结果已提交：${_selectedStatus == CertificationStatus.approved ? "通过" : "拒绝"}'),
        backgroundColor: _selectedStatus == CertificationStatus.approved ? Colors.green : Colors.red,
      ),
    );
  }
}