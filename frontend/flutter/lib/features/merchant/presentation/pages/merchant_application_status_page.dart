import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/merchant_application_provider.dart';
import 'merchant_application_edit_page.dart';

/// 商家申请状态页面
class MerchantApplicationStatusPage extends ConsumerStatefulWidget {
  const MerchantApplicationStatusPage({super.key});

  @override
  ConsumerState<MerchantApplicationStatusPage> createState() => _MerchantApplicationStatusPageState();
}

class _MerchantApplicationStatusPageState extends ConsumerState<MerchantApplicationStatusPage> {
  @override
  void initState() {
    super.initState();
    // 加载用户的申请记录
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(merchantApplicationProvider.notifier).loadUserApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(merchantApplicationProvider);
    
    // 判断是否有已通过的申请
    final hasApprovedApplication = state.userApplications.any(
      (app) => (app['verification']?['verificationStatus'] ?? 'pending') == 'approved'
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text(hasApprovedApplication ? '我的店铺' : '申请状态'),
        elevation: 0,
      ),
      body: state.isLoading 
          ? const Center(child: CircularProgressIndicator())
          : state.userApplications.isEmpty
              ? _buildEmptyState()
              : _buildApplicationList(state.userApplications),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80.r,
            color: Colors.grey[400],
          ),
          SizedBox(height: 24.h),
          Text(
            '暂无申请记录',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '您还没有提交过商家申请',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 32.h),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/merchant/application');
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            ),
            child: const Text('立即申请'),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationList(List<Map<String, dynamic>> applications) {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final application = applications[index];
        return _buildApplicationCard(application);
      },
    );
  }

  Widget _buildApplicationCard(Map<String, dynamic> application) {
    final verificationStatus = (application['verification']?['verificationStatus'] ?? 'pending') as String;
    final businessName = (application['businessName'] ?? '未知商家') as String;
    final businessType = (application['businessType'] ?? '未知类型') as String;
    final createdAt = (application['createdAt'] ?? '') as String;
    final rejectionReason = application['verification']?['rejectionReason'] as String?;
    final applicationId = application['id'] ?? application['_id'] ?? '';
    
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        businessName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _getBusinessTypeLabel(businessType),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(verificationStatus),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              '申请时间：${_formatDate(createdAt)}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[500],
              ),
            ),
            if (rejectionReason != null) ...[
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '拒绝原因：',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.red[700],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      rejectionReason,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.red[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 12.h),
            _buildActionButton(verificationStatus, rejectionReason, applicationId, application),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String verificationStatus, String? rejectionReason, String applicationId, Map<String, dynamic> application) {
    switch (verificationStatus) {
      case 'approved':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              _showMerchantManagementComingSoon();
            },
            icon: const Icon(Icons.store_mall_directory),
            label: const Text('进入店铺管理'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        );
      
      case 'rejected':
        return Column(
          children: [
            if (rejectionReason != null && rejectionReason.isNotEmpty) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showRejectionReasonDialog(rejectionReason);
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('查看拒绝原因'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _navigateToEditApplication(application);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('重新申请'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        );
      
      case 'pending':
      default:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _editApplication(applicationId, application);
                },
                icon: const Icon(Icons.edit),
                label: const Text('编辑申请'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _cancelApplication(applicationId);
                },
                icon: const Icon(Icons.cancel),
                label: const Text('取消申请'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    String text;
    
    switch (status) {
      case 'pending':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[700]!;
        text = '待审核';
        break;
      case 'approved':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        text = '已通过';
        break;
      case 'rejected':
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[700]!;
        text = '已拒绝';
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
        text = '未知';
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _getBusinessTypeLabel(String type) {
    const typeMap = {
      'maternityCenter': '月子中心',
      'gym': '健身房',
      'school': '学校',
      'company': '公司',
      'other': '其他',
    };
    return typeMap[type] ?? type;
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '未知';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  /// 显示商家管理功能即将上线提示
  void _showMerchantManagementComingSoon() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 8),
            Text('功能提示'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🎉 恭喜您的商家申请已通过审核！'),
            SizedBox(height: 12),
            Text('店铺管理功能正在紧急开发中，包括：'),
            SizedBox(height: 8),
            Text('• 店铺信息管理'),
            Text('• 菜品上架管理'),
            Text('• 订单处理'),
            Text('• 营养数据管理'),
            Text('• 营收统计'),
            SizedBox(height: 12),
            Text('预计将在下个版本上线，敬请期待！'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }

  /// 编辑待审核的申请
  void _editApplication(String applicationId, Map<String, dynamic> application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.edit, color: Colors.blue),
            SizedBox(width: 8),
            Text('编辑申请'),
          ],
        ),
        content: const Text(
          '编辑申请后需要重新提交审核，是否继续？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // 传递现有申请数据到编辑页面
              Navigator.of(context).pushNamed(
                '/merchant/application',
                arguments: {
                  'mode': 'edit',
                  'applicationId': applicationId,
                  'applicationData': application,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('继续编辑'),
          ),
        ],
      ),
    );
  }

  /// 取消待审核的申请
  void _cancelApplication(String applicationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('确认取消'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '确定要取消这个申请吗？',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              '取消后您可以随时重新提交申请。',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('我再想想'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // TODO: 调用API取消申请
              _performCancelApplication(applicationId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('确认取消'),
          ),
        ],
      ),
    );
  }

  /// 执行取消申请操作
  Future<void> _performCancelApplication(String applicationId) async {
    // TODO: 实现取消申请的API调用
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('申请已取消'),
        backgroundColor: Colors.green,
      ),
    );
    
    // 刷新申请列表
    ref.read(merchantApplicationProvider.notifier).refreshUserApplications();
  }

  /// 显示拒绝原因详情对话框
  void _showRejectionReasonDialog(String rejectionReason) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('申请被拒绝'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '很抱歉，您的商家申请未能通过审核。',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Text(
              '拒绝原因：',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Text(
                rejectionReason,
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '💡 建议：',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              '• 根据拒绝原因修正相关信息\n'
              '• 确保上传的资料清晰完整\n'
              '• 检查填写的信息是否准确\n'
              '• 如有疑问可联系客服咨询',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('我知道了'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/merchant/application');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('重新申请'),
          ),
        ],
      ),
    );
  }

  /// 导航到编辑申请页面（用于被拒绝的申请）
  void _navigateToEditApplication(Map<String, dynamic> application) {
    Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => MerchantApplicationEditPage(
          rejectedApplication: application,
        ),
      ),
    ).then((result) {
      if (result == true) {
        // 如果编辑成功，刷新申请列表
        ref.read(merchantApplicationProvider.notifier).refreshUserApplications();
      }
    });
  }
}