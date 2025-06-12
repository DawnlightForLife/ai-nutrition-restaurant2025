import 'package:flutter/material.dart';

/// 商户详情页面
class MerchantDetailPage extends StatelessWidget {
  final Map<String, dynamic> merchant;

  const MerchantDetailPage({
    super.key,
    required this.merchant,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(merchant['businessName'] ?? '商户详情'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基本信息
            _buildSectionCard(
              title: '基本信息',
              children: [
                _buildInfoRow('商户名称', merchant['businessName']),
                _buildInfoRow('业务类型', _getBusinessTypeText(merchant['businessType'])),
                _buildInfoRow('注册号码', merchant['registrationNumber']),
                _buildInfoRow('税务号码', merchant['taxId']),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 联系信息
            _buildSectionCard(
              title: '联系信息',
              children: [
                _buildInfoRow('邮箱', merchant['contact']?['email']),
                _buildInfoRow('电话', merchant['contact']?['phone']),
                _buildInfoRow('备用电话', merchant['contact']?['alternativePhone']),
                _buildInfoRow('网站', merchant['contact']?['website']),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 地址信息
            _buildSectionCard(
              title: '地址信息',
              children: [
                _buildInfoRow('地址', merchant['address']?['line1']),
                _buildInfoRow('详细地址', merchant['address']?['line2']),
                _buildInfoRow('城市', merchant['address']?['city']),
                _buildInfoRow('省份', merchant['address']?['state']),
                _buildInfoRow('邮编', merchant['address']?['postalCode']),
                _buildInfoRow('国家', merchant['address']?['country']),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 业务简介
            if (merchant['businessProfile'] != null) ...[
              _buildSectionCard(
                title: '业务简介',
                children: [
                  _buildInfoRow('描述', merchant['businessProfile']?['description']),
                  _buildInfoRow('成立年份', merchant['businessProfile']?['establishmentYear']?.toString()),
                  _buildInfoRow('是否加盟', merchant['businessProfile']?['isFranchise'] == true ? '是' : '否'),
                  if (merchant['businessProfile']?['franchiseInfo'] != null)
                    _buildInfoRow('加盟等级', merchant['businessProfile']?['franchiseInfo']?['franchiseLevel']),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            // 营养特色
            if (merchant['nutritionFeatures'] != null) ...[
              _buildSectionCard(
                title: '营养特色',
                children: [
                  _buildInfoRow('是否有营养师', merchant['nutritionFeatures']?['hasNutritionist'] == true ? '是' : '否'),
                  _buildInfoRow('营养认证', merchant['nutritionFeatures']?['nutritionCertified'] == true ? '是' : '否'),
                  _buildInfoRow('认证详情', merchant['nutritionFeatures']?['certificationDetails']),
                  if (merchant['nutritionFeatures']?['specialtyDiets'] != null)
                    _buildInfoRow('特色饮食', (merchant['nutritionFeatures']?['specialtyDiets'] as List?)?.join(', ')),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            // 审核信息
            if (merchant['verification'] != null) ...[
              _buildSectionCard(
                title: '审核信息',
                children: [
                  _buildInfoRow('审核状态', _getVerificationStatusText(merchant['verification']?['verificationStatus'])),
                  _buildInfoRow('是否已验证', merchant['verification']?['isVerified'] == true ? '是' : '否'),
                  _buildInfoRow('审核人', merchant['verification']?['verifiedBy']),
                  _buildInfoRow('审核备注', merchant['verification']?['verificationNotes']),
                  _buildInfoRow('拒绝原因', merchant['verification']?['rejectionReason']),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            // 账户状态
            if (merchant['accountStatus'] != null) ...[
              _buildSectionCard(
                title: '账户状态',
                children: [
                  _buildInfoRow('是否激活', merchant['accountStatus']?['isActive'] == true ? '是' : '否'),
                  _buildInfoRow('暂停原因', merchant['accountStatus']?['suspensionReason']),
                  _buildInfoRow('暂停人', merchant['accountStatus']?['suspendedBy']),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建信息区块卡片
  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(String label, String? value) {
    if (value == null || value.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label：',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  /// 获取业务类型文本
  String _getBusinessTypeText(String? businessType) {
    if (businessType == null) return '未知';
    
    switch (businessType) {
      case 'restaurant':
        return '餐厅';
      case 'gym':
        return '健身房';
      case 'maternityCenter':
        return '月子中心';
      case 'schoolCompany':
        return '学校/企业';
      default:
        return businessType;
    }
  }

  /// 获取审核状态文本
  String _getVerificationStatusText(String? status) {
    if (status == null) return '未知';
    
    switch (status) {
      case 'pending':
        return '待审核';
      case 'approved':
        return '已通过';
      case 'rejected':
        return '已拒绝';
      default:
        return status;
    }
  }
}