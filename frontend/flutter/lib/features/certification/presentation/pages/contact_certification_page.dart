import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../system/presentation/providers/system_config_provider.dart';
import '../../../permission/presentation/pages/permission_application_page.dart';
import '../../../permission/data/models/user_permission_model.dart';
import '../../../permission/presentation/providers/user_permission_provider.dart';
import '../../../system/domain/entities/system_config.dart';

enum CertificationType {
  merchant,
  nutritionist,
}

class ContactCertificationPage extends ConsumerWidget {
  final CertificationType certificationType;

  const ContactCertificationPage({
    super.key,
    required this.certificationType,
  });

  static const String routeName = '/contact-certification';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactInfoAsync = ref.watch(contactInfoProvider);
    final theme = Theme.of(context);
    final isNutritionist = certificationType == CertificationType.nutritionist;
    // 获取当前认证模式
    final certificationMode = isNutritionist
        ? ref.watch(nutritionistCertificationModeProvider)
        : ref.watch(merchantCertificationModeProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isNutritionist ? '营养师认证' : '商家认证'),
      ),
      body: contactInfoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('加载失败: $error'),
              ElevatedButton(
                onPressed: () => ref.invalidate(contactInfoProvider),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
        data: (contactInfo) => SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 标题
            Text(
              isNutritionist ? '申请营养师认证' : '申请商家认证',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // 说明文字
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isNutritionist 
                        ? '营养师认证需要人工审核，请联系客服提交相关资质证明。'
                        : '商家认证需要人工审核，请联系客服提交营业执照等相关证明。',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // 客服二维码
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      '扫码添加客服微信',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: QrImageView(
                        data: _getContactInfo(contactInfo['wechat'] ?? 'AIHealth2025'),
                        version: QrVersions.auto,
                        size: 200,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '客服微信：${contactInfo['wechat'] ?? 'AIHealth2025'}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // 其他联系方式
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '其他联系方式',
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      context,
                      icon: Icons.phone,
                      label: '客服电话',
                      value: contactInfo['phone'] ?? '400-123-4567',
                      onTap: () => _launchPhone(
                        (contactInfo['phone'] ?? '400-123-4567').replaceAll('-', ''),
                      ),
                    ),
                    const Divider(),
                    _buildContactItem(
                      context,
                      icon: Icons.email,
                      label: '客服邮箱',
                      value: contactInfo['email'] ?? 'cert@aihealth.com',
                      onTap: () => _launchEmail(contactInfo['email'] ?? 'cert@aihealth.com'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // 认证流程说明
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '认证流程',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildProcessStep(context, '1', '联系客服提交申请'),
                    _buildProcessStep(context, '2', '提供相关资质证明'),
                    _buildProcessStep(context, '3', '等待审核（1-3个工作日）'),
                    _buildProcessStep(context, '4', '审核通过后获得认证权限'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // 只有自动认证模式才显示快速申请区域
            if (certificationMode == CertificationMode.auto)
              _buildApplicationSection(context, ref, contactInfo),
          ],
        ),
      ),
    ),
    );
  }
  
  Widget _buildApplicationSection(BuildContext context, WidgetRef ref, Map<String, String> contactInfo) {
    final theme = Theme.of(context);
    final isNutritionist = certificationType == CertificationType.nutritionist;
    final pendingApplications = ref.watch(currentUserHasPendingApplicationProvider);
    final hasPending = isNutritionist 
        ? pendingApplications['nutritionist'] == true
        : pendingApplications['merchant'] == true;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '快速申请',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (hasPending) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.pending, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '您已有待审核的申请，请耐心等待',
                        style: TextStyle(color: Colors.orange[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Text(
                '除了联系客服，您也可以直接在线提交申请：',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _navigateToApplication(context),
                icon: const Icon(Icons.description),
                label: Text('在线申请${isNutritionist ? '营养师' : '商家'}权限'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  void _navigateToApplication(BuildContext context) {
    final permissionType = certificationType == CertificationType.nutritionist
        ? PermissionType.nutritionist
        : PermissionType.merchant;
        
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PermissionApplicationPage(
          permissionType: permissionType,
        ),
      ),
    );
  }
  
  String _getContactInfo(String wechatId) {
    // 这里可以根据认证类型返回不同的联系信息
    // 暂时返回统一的客服微信
    return 'weixin://dl/chat?$wechatId';
  }
  
  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    value,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProcessStep(BuildContext context, String number, String text) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.onPrimaryContainer,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: theme.colorScheme.primaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
  
  Future<void> _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email?subject=认证申请');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}