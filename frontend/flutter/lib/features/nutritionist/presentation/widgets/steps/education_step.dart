import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 教育背景步骤 - 第二步
/// 包含学历信息和专业背景
class EducationStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;
  final void Function(String section, Map<String, dynamic> data) onDataChanged;

  const EducationStep({
    Key? key,
    required this.formKey,
    required this.formData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<EducationStep> createState() => _EducationStepState();
}

class _EducationStepState extends State<EducationStep>
    with AutomaticKeepAliveClientMixin {
  
  late TextEditingController _schoolController;
  late TextEditingController _graduationYearController;
  String? _selectedDegree;
  String? _selectedMajor;

  @override
  bool get wantKeepAlive => true;

  // 学历选项
  static const List<Map<String, String>> _degreeOptions = [
    {'value': 'high_school', 'label': '高中/中专'},
    {'value': 'associate', 'label': '大专'},
    {'value': 'bachelor', 'label': '本科'},
    {'value': 'master', 'label': '硕士'},
    {'value': 'doctor', 'label': '博士'},
    {'value': 'other', 'label': '其他'},
  ];

  // 专业选项（营养相关）
  static const List<Map<String, String>> _majorOptions = [
    {'value': 'nutrition', 'label': '营养学'},
    {'value': 'food_science', 'label': '食品科学与工程'},
    {'value': 'clinical_nutrition', 'label': '临床营养学'},
    {'value': 'public_health', 'label': '公共卫生'},
    {'value': 'food_hygiene', 'label': '食品卫生与营养学'},
    {'value': 'biochemistry', 'label': '生物化学'},
    {'value': 'medicine', 'label': '医学'},
    {'value': 'nursing', 'label': '护理学'},
    {'value': 'sports_science', 'label': '运动科学'},
    {'value': 'home_economics', 'label': '家政学'},
    {'value': 'other', 'label': '其他相关专业'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    final degree = widget.formData['degree'] as String?;
    final major = widget.formData['major'] as String?;
    
    // 只有在值非空且存在于选项中时才设置
    _selectedDegree = (degree != null && degree.isNotEmpty && 
        _degreeOptions.any((option) => option['value'] == degree)) 
        ? degree : null;
    _selectedMajor = (major != null && major.isNotEmpty && 
        _majorOptions.any((option) => option['value'] == major)) 
        ? major : null;
  }

  void _initializeControllers() {
    _schoolController = TextEditingController(
      text: widget.formData['school'] as String? ?? '',
    );
    _graduationYearController = TextEditingController(
      text: widget.formData['graduationYear']?.toString() ?? '',
    );

    // 添加监听器
    _schoolController.addListener(_onDataChanged);
    _graduationYearController.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _graduationYearController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    final data = {
      'degree': _selectedDegree,
      'major': _selectedMajor,
      'school': _schoolController.text.trim().isEmpty ? null : _schoolController.text.trim(),
      'graduationYear': _graduationYearController.text.trim().isEmpty ? null : int.tryParse(_graduationYearController.text),
    };
    widget.onDataChanged('education', data);
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

            // 学历信息卡片
            _buildEducationInfoCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 专业背景卡片
            _buildMajorInfoCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 毕业信息卡片
            _buildGraduationInfoCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 提示信息
            _buildEducationTips(theme, colorScheme),
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
          '请填写您的教育背景信息，包括最高学历和专业情况',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationInfoCard(ThemeData theme, ColorScheme colorScheme) {
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
              '学历信息',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // 最高学历选择
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '最高学历 *',
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
                    value: _selectedDegree,
                    onChanged: (value) {
                      setState(() {
                        _selectedDegree = value;
                      });
                      _onDataChanged();
                    },
                    items: _degreeOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option['value'],
                        child: Text(option['label']!),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      hintText: '请选择最高学历',
                      prefixIcon: Icon(Icons.school_outlined),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请选择最高学历';
                      }
                      return null;
                    },
                    dropdownColor: colorScheme.surface,
                    isExpanded: true,
                  ),
                ),
              ],
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
          ],
        ),
      ),
    );
  }

  Widget _buildMajorInfoCard(ThemeData theme, ColorScheme colorScheme) {
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
              '专业背景',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '营养相关专业背景有助于认证审核',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),

            // 专业选择
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '所学专业 *',
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
                    value: _selectedMajor,
                    onChanged: (value) {
                      setState(() {
                        _selectedMajor = value;
                      });
                      _onDataChanged();
                    },
                    items: _majorOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option['value'],
                        child: Text(
                          option['label']!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      hintText: '请选择所学专业',
                      prefixIcon: Icon(Icons.biotech_outlined),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请选择所学专业';
                      }
                      return null;
                    },
                    dropdownColor: colorScheme.surface,
                    isExpanded: true,
                  ),
                ),
              ],
            ),

            // 专业匹配度提示
            if (_selectedMajor != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isNutritionRelatedMajor()
                      ? colorScheme.primaryContainer.withOpacity(0.3)
                      : colorScheme.secondaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isNutritionRelatedMajor()
                        ? colorScheme.primary.withOpacity(0.3)
                        : colorScheme.secondary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isNutritionRelatedMajor() 
                          ? Icons.check_circle_outline
                          : Icons.info_outline,
                      color: _isNutritionRelatedMajor()
                          ? colorScheme.primary
                          : colorScheme.secondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isNutritionRelatedMajor()
                            ? '您的专业与营养学高度相关，有助于认证申请'
                            : '非营养相关专业也可以申请，建议补充相关培训经历',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _isNutritionRelatedMajor()
                              ? colorScheme.primary
                              : colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGraduationInfoCard(ThemeData theme, ColorScheme colorScheme) {
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
              '毕业信息',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // 毕业年份
            TextFormField(
              controller: _graduationYearController,
              decoration: InputDecoration(
                labelText: '毕业年份 *',
                hintText: '请输入毕业年份（如：2020）',
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入毕业年份';
                }
                final year = int.tryParse(value.trim());
                if (year == null) {
                  return '请输入有效的年份';
                }
                final currentYear = DateTime.now().year;
                if (year < 1950 || year > currentYear + 1) {
                  return '请输入1950年到${currentYear + 1}年之间的年份';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationTips(ThemeData theme, ColorScheme colorScheme) {
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
                Icons.lightbulb_outline,
                color: colorScheme.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '教育背景说明',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• 营养相关专业背景（如营养学、食品科学等）有助于提高认证通过率\n'
            '• 非相关专业也可以申请，建议在后续步骤中补充相关培训和工作经验\n'
            '• 学历证书将在文档上传步骤中提交审核',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.secondary.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  bool _isNutritionRelatedMajor() {
    if (_selectedMajor == null) return false;
    const nutritionRelated = [
      'nutrition',
      'food_science',
      'clinical_nutrition',
      'public_health',
      'food_hygiene',
      'biochemistry',
      'medicine',
      'nursing',
    ];
    return nutritionRelated.contains(_selectedMajor);
  }
}