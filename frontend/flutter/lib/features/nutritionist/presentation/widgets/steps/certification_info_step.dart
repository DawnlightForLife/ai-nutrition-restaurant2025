import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 认证信息步骤 - 第四步
/// 包含目标认证等级、专长领域选择和动机说明
class CertificationInfoStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;
  final void Function(String section, Map<String, dynamic> data) onDataChanged;

  const CertificationInfoStep({
    Key? key,
    required this.formKey,
    required this.formData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<CertificationInfoStep> createState() => _CertificationInfoStepState();
}

class _CertificationInfoStepState extends State<CertificationInfoStep>
    with AutomaticKeepAliveClientMixin {
  
  late TextEditingController _motivationController;
  late TextEditingController _workYearsController;
  
  String? _selectedTargetLevel;
  Set<String> _selectedAreas = <String>{};

  @override
  bool get wantKeepAlive => true;

  // 认证等级选项（与后端保持一致）
  static const List<Map<String, dynamic>> _targetLevelOptions = [
    {
      'value': 'public_nutritionist_l4',
      'label': '四级公共营养师',
      'description': '适合营养学相关专业人员或有相关工作经验者',
      'requirements': '营养相关专业或1年以上相关工作经验',
      'difficulty': '入门级',
    },
    {
      'value': 'public_nutritionist_l3',
      'label': '三级公共营养师',
      'description': '适合有一定营养工作基础的专业人员',
      'requirements': '营养相关专业+2年工作经验或非相关专业+3年工作经验',
      'difficulty': '中级',
    },
    {
      'value': 'clinical_nutritionist',
      'label': '临床营养师',
      'description': '适合医疗机构工作或有临床营养背景的人员',
      'requirements': '医学或营养学专业+临床工作经验',
      'difficulty': '专业级',
    },
    {
      'value': 'sports_nutritionist',
      'label': '运动营养师',
      'description': '适合体育、健身相关领域的营养专业人员',
      'requirements': '营养或运动科学专业+相关领域工作经验',
      'difficulty': '专业级',
    },
  ];

  // 专长领域选项（与后端保持一致）
  static const List<Map<String, dynamic>> _specializationOptions = [
    {
      'value': 'clinical_nutrition',
      'label': '临床营养',
      'description': '医院、诊所等医疗机构的营养治疗',
      'icon': Icons.local_hospital_outlined,
    },
    {
      'value': 'public_nutrition',
      'label': '公共营养',
      'description': '社区、学校等公共场所的营养服务',
      'icon': Icons.public_outlined,
    },
    {
      'value': 'food_nutrition',
      'label': '食品营养',
      'description': '食品营养成分分析与配方设计',
      'icon': Icons.restaurant_outlined,
    },
    {
      'value': 'sports_nutrition',
      'label': '运动营养',
      'description': '运动员、健身人群的营养指导',
      'icon': Icons.fitness_center_outlined,
    },
    {
      'value': 'maternal_child',
      'label': '妇幼营养',
      'description': '孕产妇、婴幼儿、儿童青少年营养健康',
      'icon': Icons.child_care_outlined,
    },
    {
      'value': 'elderly_nutrition',
      'label': '老年营养',
      'description': '老年人群的营养保健和疾病预防',
      'icon': Icons.elderly_outlined,
    },
    {
      'value': 'weight_management',
      'label': '体重管理',
      'description': '减重、增重等体重控制营养方案',
      'icon': Icons.monitor_weight_outlined,
    },
    {
      'value': 'food_safety',
      'label': '食品安全',
      'description': '食品安全检测、评估和管理',
      'icon': Icons.food_bank_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadInitialData();
  }

  void _initializeControllers() {
    _motivationController = TextEditingController(
      text: widget.formData['motivationStatement'] as String? ?? '',
    );
    _workYearsController = TextEditingController(
      text: widget.formData['workYearsInNutrition']?.toString() ?? '0',
    );

    // 添加监听器
    _motivationController.addListener(_onDataChanged);
    _workYearsController.addListener(_onDataChanged);
  }

  void _loadInitialData() {
    _selectedTargetLevel = widget.formData['targetLevel'] as String?;
    
    final areas = widget.formData['specializationAreas'] as List<dynamic>?;
    if (areas != null) {
      _selectedAreas = areas.cast<String>().toSet();
    }
  }

  @override
  void dispose() {
    _motivationController.dispose();
    _workYearsController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    final data = {
      'targetLevel': _selectedTargetLevel ?? '',
      'specializationAreas': _selectedAreas.toList(),
      'workYearsInNutrition': int.tryParse(_workYearsController.text) ?? 0,
      'motivationStatement': _motivationController.text,
    };
    widget.onDataChanged('certificationInfo', data);
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

            // 认证等级选择卡片
            _buildTargetLevelCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 营养工作经验卡片
            _buildNutritionExperienceCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 专长领域选择卡片
            _buildSpecializationCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 申请理由卡片
            _buildMotivationCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 认证说明
            _buildCertificationNotes(theme, colorScheme),
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
                Icons.verified_outlined,
                color: theme.colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '认证信息',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '请选择您要申请的认证等级和专长领域，并说明申请理由',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildTargetLevelCard(ThemeData theme, ColorScheme colorScheme) {
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
              '目标认证等级',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '请根据您的教育背景和工作经验选择合适的认证等级 *',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),

            ..._targetLevelOptions.map((option) {
              final isSelected = _selectedTargetLevel == option['value'];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedTargetLevel = option['value'] as String;
                    });
                    _onDataChanged();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? colorScheme.primaryContainer.withOpacity(0.5)
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outline.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: option['value'] as String,
                          groupValue: _selectedTargetLevel,
                          onChanged: (value) {
                            setState(() {
                              _selectedTargetLevel = value;
                            });
                            _onDataChanged();
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    option['label'] as String,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected 
                                          ? colorScheme.primary 
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getDifficultyColor(
                                        option['difficulty'] as String,
                                        colorScheme,
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      option['difficulty'] as String,
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: _getDifficultyColor(
                                          option['difficulty'] as String,
                                          colorScheme,
                                        ),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                option['description'] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '要求：${option['requirements']}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionExperienceCard(ThemeData theme, ColorScheme colorScheme) {
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
              '营养相关工作经验',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '请填写您从事营养相关工作的总年限',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _workYearsController,
              decoration: InputDecoration(
                labelText: '营养工作年限 *',
                hintText: '请输入年限（可填0）',
                prefixIcon: const Icon(Icons.timeline_outlined),
                suffixText: '年',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入营养工作年限（可填0）';
                }
                final years = int.tryParse(value.trim());
                if (years == null || years < 0 || years > 50) {
                  return '请输入0-50之间的有效年限';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecializationCard(ThemeData theme, ColorScheme colorScheme) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '专长领域选择',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '请选择1-2个您最擅长的专业领域 *',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedAreas.isNotEmpty
                        ? colorScheme.primaryContainer
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    '已选 ${_selectedAreas.length}/2',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _selectedAreas.isNotEmpty
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _specializationOptions.length,
              itemBuilder: (context, index) {
                final option = _specializationOptions[index];
                final isSelected = _selectedAreas.contains(option['value']);
                final canSelect = !isSelected && _selectedAreas.length < 2;

                return InkWell(
                  onTap: () {
                    if (isSelected) {
                      setState(() {
                        _selectedAreas.remove(option['value']);
                      });
                    } else if (canSelect) {
                      setState(() {
                        _selectedAreas.add(option['value'] as String);
                      });
                    }
                    _onDataChanged();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primaryContainer.withOpacity(0.5)
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outline.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              option['icon'] as IconData,
                              size: 20,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 8),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          option['label'] as String,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? colorScheme.primary : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          option['description'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            if (_selectedAreas.isEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.error.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_outlined,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '请至少选择一个专长领域',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.error,
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

  Widget _buildMotivationCard(ThemeData theme, ColorScheme colorScheme) {
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
              '申请理由与职业目标',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '请简要说明您申请营养师认证的理由和职业发展目标 *',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _motivationController,
              decoration: InputDecoration(
                labelText: '申请理由',
                hintText: '例如：希望通过专业认证提升营养学专业能力，为更多人提供科学的营养指导服务，未来在临床营养领域深入发展...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              maxLines: 4,
              minLines: 3,
              maxLength: 500,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请填写申请理由说明';
                }
                if (value.trim().length < 20) {
                  return '申请理由说明至少需要20个字符';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificationNotes(ThemeData theme, ColorScheme colorScheme) {
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
                '认证申请说明',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• 认证等级的选择应与您的教育背景和工作经验相匹配\n'
            '• 专长领域将影响您后续的认证考核内容和执业方向\n'
            '• 申请理由说明将作为专家评审的重要参考\n'
            '• 提交后可在下一步上传相关证明文档',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.secondary.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty, ColorScheme colorScheme) {
    switch (difficulty) {
      case '入门级':
        return Colors.green;
      case '中级':
        return Colors.orange;
      case '专业级':
        return Colors.red;
      default:
        return colorScheme.primary;
    }
  }
}