import 'package:flutter/material.dart';

/// 教育背景步骤 - 第二步  
/// 简化版：只收集最高学历、专业、院校
class EducationBackgroundStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;
  final void Function(String section, Map<String, dynamic> data) onDataChanged;

  const EducationBackgroundStep({
    Key? key,
    required this.formKey,
    required this.formData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<EducationBackgroundStep> createState() => _EducationBackgroundStepState();
}

class _EducationBackgroundStepState extends State<EducationBackgroundStep>
    with AutomaticKeepAliveClientMixin {
  
  late TextEditingController _schoolController;
  String? _selectedDegree;
  String? _selectedMajor;
  List<String> _selectedSpecializations = [];
  int _workYears = 0;

  // 学历选项
  static const List<Map<String, String>> _degreeOptions = [
    {'value': 'doctoral', 'label': '博士研究生'},
    {'value': 'master', 'label': '硕士研究生'},
    {'value': 'bachelor', 'label': '本科'},
    {'value': 'associate', 'label': '专科'},
    {'value': 'technical_secondary', 'label': '中专'},
  ];

  // 专业选项 - 营养相关专业
  static const List<Map<String, String>> _majorOptions = [
    {'value': 'nutrition_science', 'label': '营养学'},
    {'value': 'food_science', 'label': '食品科学与工程'},
    {'value': 'food_hygiene', 'label': '食品卫生与营养学'},
    {'value': 'clinical_medicine', 'label': '临床医学'},
    {'value': 'preventive_medicine', 'label': '预防医学'},
    {'value': 'nursing', 'label': '护理学'},
    {'value': 'biochemistry', 'label': '生物化学'},
    {'value': 'other_related', 'label': '其他相关专业'},
  ];

  // 专长领域选项 - 与后端API匹配
  static const List<Map<String, String>> _specializationOptions = [
    {'value': 'clinical_nutrition', 'label': '临床营养'},
    {'value': 'sports_nutrition', 'label': '运动营养'},
    {'value': 'child_nutrition', 'label': '儿童营养'},
    {'value': 'elderly_nutrition', 'label': '老年营养'},
    {'value': 'weight_management', 'label': '体重管理'},
    {'value': 'chronic_disease_nutrition', 'label': '慢病营养'},
    {'value': 'food_safety', 'label': '食品安全'},
    {'value': 'community_nutrition', 'label': '社区营养'},
    {'value': 'nutrition_education', 'label': '营养教育'},
    {'value': 'food_service_management', 'label': '餐饮管理'},
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeSelections();
  }

  void _initializeControllers() {
    _schoolController = TextEditingController(
      text: widget.formData['school'] as String? ?? '',
    );
    _schoolController.addListener(_onDataChanged);
  }

  void _initializeSelections() {
    final degree = widget.formData['degree'] as String?;
    final major = widget.formData['major'] as String?;
    
    _selectedDegree = (degree != null && degree.isNotEmpty && 
        _degreeOptions.any((option) => option['value'] == degree)) 
        ? degree : null;
    _selectedMajor = (major != null && major.isNotEmpty && 
        _majorOptions.any((option) => option['value'] == major)) 
        ? major : null;
  }

  @override
  void dispose() {
    _schoolController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    // 更新教育信息
    final educationData = {
      'degree': _selectedDegree,
      'major': _selectedMajor,
      'school': _schoolController.text.trim().isEmpty ? null : _schoolController.text.trim(),
    };
    widget.onDataChanged('education', educationData);
    
    // 更新认证信息
    final certificationData = {
      'specializationAreas': _selectedSpecializations,
      'workYearsInNutrition': _workYears,
    };
    widget.onDataChanged('certificationInfo', certificationData);
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

            // 教育背景卡片
            _buildEducationCard(theme, colorScheme),
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
                Icons.school_outlined,
                color: theme.colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '教育背景',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '请填写您的最高学历和专业背景信息',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationCard(ThemeData theme, ColorScheme colorScheme) {
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
              '学历信息',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // 最高学历选择
            _buildDropdownField(
              label: '最高学历 *',
              value: _selectedDegree,
              options: _degreeOptions,
              hint: '请选择最高学历',
              icon: Icons.school_outlined,
              onChanged: (value) {
                setState(() {
                  _selectedDegree = value;
                });
                _onDataChanged();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请选择最高学历';
                }
                return null;
              },
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),

            // 专业选择
            _buildDropdownField(
              label: '所学专业 *',
              value: _selectedMajor,
              options: _majorOptions,
              hint: '请选择所学专业',
              icon: Icons.biotech_outlined,
              onChanged: (value) {
                setState(() {
                  _selectedMajor = value;
                });
                _onDataChanged();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请选择所学专业';
                }
                return null;
              },
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),

            // 毕业院校
            TextFormField(
              controller: _schoolController,
              decoration: InputDecoration(
                labelText: '毕业院校 *',
                hintText: '请输入毕业院校名称',
                prefixIcon: const Icon(Icons.account_balance_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入毕业院校';
                }
                if (value.trim().length < 2) {
                  return '院校名称至少需要2个字符';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // 认证信息分隔线
            Text(
              '专业认证信息',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // 专长领域选择
            _buildSpecializationSection(theme, colorScheme),
            
            const SizedBox(height: 16),

            // 工作年限选择
            _buildWorkYearsSection(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<Map<String, String>> options,
    required String hint,
    required IconData icon,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.5),
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: (value != null && value.isNotEmpty && options.any((option) => option['value'] == value)) ? value : null,
            onChanged: onChanged,
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option['value'],
                child: Text(
                  option['label']!,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
            validator: validator,
            dropdownColor: colorScheme.surface,
            isExpanded: true,
          ),
        ),
      ],
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
            '• 营养相关专业背景有助于认证审核\n'
            '• 请确保填写的学历信息真实有效\n'
            '• 下一步需要上传学历证书进行验证',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.secondary.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建专长领域选择区域
  Widget _buildSpecializationSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '专长领域 *',
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '请选择1-2个专长领域（最多选择2个）',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _specializationOptions.map((option) {
            final isSelected = _selectedSpecializations.contains(option['value']);
            return FilterChip(
              label: Text(option['label']!),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    if (_selectedSpecializations.length < 2) {
                      _selectedSpecializations.add(option['value']!);
                    }
                  } else {
                    _selectedSpecializations.remove(option['value']);
                  }
                });
                _onDataChanged();
              },
              backgroundColor: colorScheme.surface,
              selectedColor: colorScheme.primaryContainer,
              checkmarkColor: colorScheme.onPrimaryContainer,
              labelStyle: TextStyle(
                color: isSelected 
                    ? colorScheme.onPrimaryContainer 
                    : colorScheme.onSurface,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 构建工作年限选择区域
  Widget _buildWorkYearsSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '营养相关工作年限 *',
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '包括实习、兼职等相关工作经验',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.5),
            ),
          ),
          child: DropdownButtonFormField<int>(
            value: _workYears,
            onChanged: (value) {
              setState(() {
                _workYears = value ?? 0;
              });
              _onDataChanged();
            },
            items: List.generate(51, (index) => index).map((years) {
              return DropdownMenuItem<int>(
                value: years,
                child: Text(years == 0 ? '无工作经验' : '$years年'),
              );
            }).toList(),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: const Icon(Icons.work_outline),
            ),
            validator: (value) {
              if (value == null) {
                return '请选择工作年限';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}