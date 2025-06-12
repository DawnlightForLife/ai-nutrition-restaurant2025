import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/nutritionist_certification.dart';
import '../../domain/enums/certification_status.dart';
import '../../data/services/nutritionist_certification_service.dart';
import '../widgets/simple_certification_status_card.dart';
import '../widgets/simple_certification_timeline.dart';
import 'nutritionist_certification_application_page.dart';

/// 营养师认证申请状态页面
/// 用户可以查看自己提交的认证申请状态和审核进度
class NutritionistCertificationStatusPage extends ConsumerStatefulWidget {
  final String applicationId;

  const NutritionistCertificationStatusPage({
    Key? key,
    required this.applicationId,
  }) : super(key: key);

  @override
  ConsumerState<NutritionistCertificationStatusPage> createState() =>
      _NutritionistCertificationStatusPageState();
}

class _NutritionistCertificationStatusPageState
    extends ConsumerState<NutritionistCertificationStatusPage> {
  late Future<NutritionistCertification?> _certificationFuture;

  @override
  void initState() {
    super.initState();
    _loadCertificationStatus();
  }

  void _loadCertificationStatus() {
    final service = ref.read(nutritionistCertificationServiceProvider);
    _certificationFuture = service.getApplicationDetail(widget.applicationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('认证申请状态'),
        elevation: 0,
      ),
      body: FutureBuilder<NutritionistCertification?>(
        future: _certificationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    '加载失败：${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loadCertificationStatus();
                      });
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          }

          final certification = snapshot.data;
          if (certification == null) {
            return const Center(
              child: Text('申请不存在'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _loadCertificationStatus();
              });
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 状态卡片
                  SimpleCertificationStatusCard(
                    certification: certification,
                  ),
                  const SizedBox(height: 24),

                  // 审核时间线
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '审核进度',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SimpleCertificationTimeline(
                            currentStatus: CertificationStatusUtils.fromString(certification.review.status),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 申请信息摘要
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '申请信息',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (certification.certificationInfo.targetLevel != null)
                            _buildInfoRow('认证级别', certification.certificationInfo.targetLevel!),
                          _buildInfoRow('专业领域', certification.certificationInfo.specializationAreas.join('、')),
                          _buildInfoRow('工作年限', '${certification.certificationInfo.workYearsInNutrition}年'),
                          _buildInfoRow('姓名', certification.personalInfo.fullName),
                          _buildInfoRow('联系电话', certification.personalInfo.phone),
                          if (certification.personalInfo.email != null)
                            _buildInfoRow('邮箱', certification.personalInfo.email!),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 操作按钮
                  if (certification.review.status == 'draft' ||
                      certification.review.status == 'rejected')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handleResubmit(certification),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          certification.review.status == 'draft'
                              ? '继续填写申请'
                              : '重新提交申请',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label：',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleResubmit(NutritionistCertification certification) {
    // 导航到编辑页面
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NutritionistCertificationApplicationPage(
          applicationId: certification.id,
          initialData: certification,
        ),
      ),
    );
  }
}