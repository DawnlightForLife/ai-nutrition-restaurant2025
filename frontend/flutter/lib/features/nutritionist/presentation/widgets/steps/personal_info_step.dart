import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../form_widgets/address_selector.dart';

/// 个人信息步骤 - 第一步
/// 包含基本个人信息和地址选择器
class PersonalInfoStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;
  final void Function(String section, Map<String, dynamic> data) onDataChanged;

  const PersonalInfoStep({
    Key? key,
    required this.formKey,
    required this.formData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep>
    with AutomaticKeepAliveClientMixin {
  
  late TextEditingController _fullNameController;
  late TextEditingController _idNumberController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late DateTime? _selectedBirthDate;
  late String _selectedGender;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _selectedBirthDate = widget.formData['birthDate'] != null && 
                        (widget.formData['birthDate'] as String).isNotEmpty
        ? DateTime.tryParse(widget.formData['birthDate'] as String)
        : null;
    _selectedGender = widget.formData['gender'] as String? ?? 'female';
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
    _emailController = TextEditingController(
      text: widget.formData['email'] as String? ?? '',
    );

    // 添加监听器
    _fullNameController.addListener(_onDataChanged);
    _idNumberController.addListener(_onDataChanged);
    _phoneController.addListener(_onDataChanged);
    _emailController.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _idNumberController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    final data = {
      'fullName': _fullNameController.text,
      'idNumber': _idNumberController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'gender': _selectedGender,
      'birthDate': _selectedBirthDate?.toIso8601String() ?? '',
      // 保持现有的地址数据不变
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

            // 基本信息卡片
            _buildBasicInfoCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 联系信息卡片
            _buildContactInfoCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 地址信息卡片
            _buildAddressInfoCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 隐私提示
            _buildPrivacyNotice(theme, colorScheme),
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
                Icons.person_outline,
                color: theme.colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '个人信息',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '请准确填写您的个人信息，这些信息将用于身份验证和认证审核',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withOpacity(0.3),
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
              '基本信息',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // 真实姓名
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: '真实姓名 *',
                hintText: '请输入您的真实姓名',
                prefixIcon: const Icon(Icons.badge_outlined),
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
                if (!RegExp(r'^[\u4e00-\u9fa5a-zA-Z\s]+$').hasMatch(value.trim())) {
                  return '姓名只能包含中文、英文和空格';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 身份证号
            TextFormField(
              controller: _idNumberController,
              decoration: InputDecoration(
                labelText: '身份证号码 *',
                hintText: '请输入18位身份证号码',
                prefixIcon: const Icon(Icons.credit_card_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9Xx]')),
                LengthLimitingTextInputFormatter(18),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入身份证号码';
                }
                if (!RegExp(r'^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$')
                    .hasMatch(value.trim())) {
                  return '请输入有效的身份证号码';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 性别和出生日期行
            Row(
              children: [
                // 性别选择
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '性别 *',
                        style: theme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedGender = 'female';
                                  });
                                  _onDataChanged();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<String>(
                                        value: 'female',
                                        groupValue: _selectedGender,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedGender = value!;
                                          });
                                          _onDataChanged();
                                        },
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text('女'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedGender = 'male';
                                  });
                                  _onDataChanged();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<String>(
                                        value: 'male',
                                        groupValue: _selectedGender,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedGender = value!;
                                          });
                                          _onDataChanged();
                                        },
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text('男'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // 出生日期
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '出生日期 *',
                        style: theme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectBirthDate,
                        child: Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colorScheme.outline.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedBirthDate != null
                                      ? '${_selectedBirthDate!.year}-${_selectedBirthDate!.month.toString().padLeft(2, '0')}-${_selectedBirthDate!.day.toString().padLeft(2, '0')}'
                                      : '请选择出生日期',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: _selectedBirthDate != null
                                        ? colorScheme.onSurface
                                        : colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withOpacity(0.3),
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
              '联系信息',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // 手机号码
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: '手机号码 *',
                hintText: '请输入11位手机号码',
                prefixIcon: const Icon(Icons.phone_android_outlined),
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
                if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value.trim())) {
                  return '请输入有效的手机号码';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 邮箱地址
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '邮箱地址',
                hintText: '请输入邮箱地址（可选）',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value.trim())) {
                    return '请输入有效的邮箱地址';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressInfoCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withOpacity(0.3),
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
              '地址信息',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // 地址选择器
            AddressSelector(
              initialAddress: widget.formData['address'] as Map<String, dynamic>? ?? {
                'province': null,
                'city': null,
                'district': null,
                'detailed': null,
              },
              onAddressChanged: (address) {
                // 创建包含所有当前数据的完整更新
                final data = {
                  'fullName': _fullNameController.text,
                  'idNumber': _idNumberController.text,
                  'phone': _phoneController.text,
                  'email': _emailController.text,
                  'gender': _selectedGender,
                  'birthDate': _selectedBirthDate?.toIso8601String() ?? '',
                  'address': address,
                };
                widget.onDataChanged('personalInfo', data);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyNotice(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.security_outlined,
            color: colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '隐私保护承诺',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '您的个人信息将被严格加密存储，仅用于营养师认证审核。我们承诺不会将您的个人信息用于其他用途或向第三方透露。',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(1990),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 6570)), // 18岁
      helpText: '选择出生日期',
      cancelText: '取消',
      confirmText: '确定',
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
      _onDataChanged();
    }
  }
}