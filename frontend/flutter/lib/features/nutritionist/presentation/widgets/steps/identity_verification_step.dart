import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 身份验证步骤 - 第一步
/// 实名认证：姓名 + 身份证号码（自动解析生日、性别等信息）
class IdentityVerificationStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;
  final void Function(String section, Map<String, dynamic> data) onDataChanged;

  const IdentityVerificationStep({
    Key? key,
    required this.formKey,
    required this.formData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<IdentityVerificationStep> createState() => _IdentityVerificationStepState();
}

class _IdentityVerificationStepState extends State<IdentityVerificationStep>
    with AutomaticKeepAliveClientMixin {
  
  late TextEditingController _fullNameController;
  late TextEditingController _idNumberController;
  late TextEditingController _phoneController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _fullNameController = TextEditingController(
      text: widget.formData['fullName'] as String? ?? '',
    );
    _idNumberController = TextEditingController(
      text: widget.formData['idNumber'] as String? ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.formData['phone'] as String? ?? '',
    );

    // 添加监听器
    _fullNameController.addListener(_onDataChanged);
    _idNumberController.addListener(_onDataChanged);
    _phoneController.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _idNumberController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    final data = {
      'fullName': _fullNameController.text.trim(),
      'idNumber': _idNumberController.text.trim(),
      'phone': _phoneController.text.trim(),
    };
    widget.onDataChanged('personalInfo', data);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 步骤标题和描述
            _buildStepHeader(theme),
            const SizedBox(height: 32),

            // 实名认证卡片
            _buildIdentityCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 说明提示
            _buildInfoTips(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.verified_user_outlined,
                color: theme.colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '身份验证',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '请填写真实姓名和身份证号码进行实名认证',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildIdentityCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '实名认证',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // 姓名输入
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: '真实姓名 *',
                hintText: '请输入身份证上的真实姓名',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入真实姓名';
                }
                if (value.trim().length < 2) {
                  return '姓名至少需要2个字符';
                }
                // 验证中文姓名格式
                if (!RegExp(r'^[\u4e00-\u9fa5·]{2,10}$').hasMatch(value.trim())) {
                  return '请输入有效的中文姓名';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 身份证号码输入
            TextFormField(
              controller: _idNumberController,
              decoration: InputDecoration(
                labelText: '身份证号码 *',
                hintText: '请输入18位身份证号码',
                prefixIcon: const Icon(Icons.credit_card),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9Xx]')),
                LengthLimitingTextInputFormatter(18),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入身份证号码';
                }
                if (value.trim().length != 18) {
                  return '身份证号码必须为18位';
                }
                // 简单的身份证格式验证
                if (!RegExp(r'^\d{17}[\dXx]$').hasMatch(value.trim())) {
                  return '请输入有效的身份证号码';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // 手机号码输入
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: '手机号码 *',
                hintText: '请输入11位手机号码',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入手机号码';
                }
                if (value.trim().length != 11) {
                  return '手机号码必须为11位';
                }
                // 中国手机号格式验证
                if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value.trim())) {
                  return '请输入有效的手机号码';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTips(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.secondary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: colorScheme.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '温馨提示',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• 请确保姓名与身份证信息完全一致\n'
            '• 身份证信息将用于认证资质验证\n'
            '• 我们会严格保护您的个人信息安全\n'
            '• 通过身份证可自动获取生日、性别等信息',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.secondary.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}