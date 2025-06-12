import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 工作经验步骤 - 第三步
/// 支持添加多段工作经历和当前工作信息
class WorkExperienceStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;
  final void Function(String section, Map<String, dynamic> data) onDataChanged;

  const WorkExperienceStep({
    Key? key,
    required this.formKey,
    required this.formData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<WorkExperienceStep> createState() => _WorkExperienceStepState();
}

class _WorkExperienceStepState extends State<WorkExperienceStep>
    with AutomaticKeepAliveClientMixin {
  
  late TextEditingController _totalYearsController;
  late TextEditingController _currentPositionController;
  late TextEditingController _currentEmployerController;
  late TextEditingController _workDescriptionController;
  
  List<Map<String, dynamic>> _previousExperiences = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadPreviousExperiences();
  }

  void _initializeControllers() {
    _totalYearsController = TextEditingController(
      text: widget.formData['totalYears']?.toString() ?? '0',
    );
    _currentPositionController = TextEditingController(
      text: widget.formData['currentPosition'] as String? ?? '',
    );
    _currentEmployerController = TextEditingController(
      text: widget.formData['currentEmployer'] as String? ?? '',
    );
    _workDescriptionController = TextEditingController(
      text: widget.formData['workDescription'] as String? ?? '',
    );

    // 添加监听器
    _totalYearsController.addListener(_onDataChanged);
    _currentPositionController.addListener(_onDataChanged);
    _currentEmployerController.addListener(_onDataChanged);
    _workDescriptionController.addListener(_onDataChanged);
  }

  void _loadPreviousExperiences() {
    final experiences = widget.formData['previousExperiences'] as List<dynamic>?;
    if (experiences != null) {
      _previousExperiences = experiences
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
  }

  @override
  void dispose() {
    _totalYearsController.dispose();
    _currentPositionController.dispose();
    _currentEmployerController.dispose();
    _workDescriptionController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    final data = {
      'totalYears': int.tryParse(_totalYearsController.text) ?? 0,
      'currentPosition': _currentPositionController.text,
      'currentEmployer': _currentEmployerController.text,
      'workDescription': _workDescriptionController.text,
      'previousExperiences': _previousExperiences,
    };
    widget.onDataChanged('workExperience', data);
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

            // 工作概况卡片
            _buildWorkSummaryCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 当前工作卡片
            _buildCurrentWorkCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 历史工作经验卡片
            _buildPreviousExperiencesCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 工作经验提示
            _buildWorkExperienceTips(theme, colorScheme),
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
                Icons.work_outline,
                color: theme.colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '工作经验',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '请详细填写您的工作经验，特别是与营养相关的工作背景',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkSummaryCard(ThemeData theme, ColorScheme colorScheme) {
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
              '工作概况',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // 总工作年限
            TextFormField(
              controller: _totalYearsController,
              decoration: InputDecoration(
                labelText: '总工作年限 *',
                hintText: '请输入总工作年限（年）',
                prefixIcon: const Icon(Icons.timer_outlined),
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
                  return '请输入总工作年限';
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

  Widget _buildCurrentWorkCard(ThemeData theme, ColorScheme colorScheme) {
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
              '当前工作',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '如果您目前有工作，请填写以下信息',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),

            // 当前职位
            TextFormField(
              controller: _currentPositionController,
              decoration: InputDecoration(
                labelText: '当前职位',
                hintText: '如：营养师、医生、健康顾问等',
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
            ),
            const SizedBox(height: 16),

            // 当前雇主
            TextFormField(
              controller: _currentEmployerController,
              decoration: InputDecoration(
                labelText: '当前雇主/公司',
                hintText: '如：XXX医院、XXX健康管理公司等',
                prefixIcon: const Icon(Icons.business_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
            ),
            const SizedBox(height: 16),

            // 工作描述
            TextFormField(
              controller: _workDescriptionController,
              decoration: InputDecoration(
                labelText: '工作描述',
                hintText: '请简要描述您的主要工作内容和职责',
                prefixIcon: const Icon(Icons.description_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              maxLines: 3,
              minLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviousExperiencesCard(ThemeData theme, ColorScheme colorScheme) {
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
                      '历史工作经验',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '可以添加多段工作经历（可选）',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                IconButton.filled(
                  onPressed: _addPreviousExperience,
                  icon: const Icon(Icons.add),
                  tooltip: '添加工作经历',
                ),
              ],
            ),
            
            if (_previousExperiences.isEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.work_history_outlined,
                      size: 48,
                      color: colorScheme.onSurface.withOpacity(0.4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '暂无历史工作经验',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '点击上方 + 按钮添加工作经历',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),
              ..._previousExperiences.asMap().entries.map((entry) {
                final index = entry.key;
                final experience = entry.value;
                return _buildExperienceItem(theme, colorScheme, experience, index);
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceItem(
    ThemeData theme,
    ColorScheme colorScheme,
    Map<String, dynamic> experience,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  experience['position'] as String? ?? '职位名称',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _editPreviousExperience(index),
                icon: const Icon(Icons.edit_outlined),
                iconSize: 20,
                tooltip: '编辑',
              ),
              IconButton(
                onPressed: () => _removePreviousExperience(index),
                icon: const Icon(Icons.delete_outline),
                iconSize: 20,
                tooltip: '删除',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            experience['company'] as String? ?? '公司名称',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${experience['startYear'] ?? ''} - ${experience['endYear'] ?? ''}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          if (experience['description'] != null && 
              (experience['description'] as String).isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              experience['description'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWorkExperienceTips(ThemeData theme, ColorScheme colorScheme) {
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
                Icons.tips_and_updates_outlined,
                color: colorScheme.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '工作经验填写建议',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• 营养相关工作经验（如临床营养师、健康管理师等）有助于提高认证通过率\n'
            '• 医疗、健康、餐饮等相关行业经验也有一定帮助\n'
            '• 详细的工作描述能让审核专家更好地了解您的专业背景\n'
            '• 如果是应届生或转行者，可以重点描述相关实习或培训经历',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.secondary.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _addPreviousExperience() {
    _showExperienceDialog();
  }

  void _editPreviousExperience(int index) {
    _showExperienceDialog(experience: _previousExperiences[index], index: index);
  }

  void _removePreviousExperience(int index) {
    setState(() {
      _previousExperiences.removeAt(index);
    });
    _onDataChanged();
  }

  Future<void> _showExperienceDialog({
    Map<String, dynamic>? experience,
    int? index,
  }) async {
    final isEditing = experience != null;
    final positionController = TextEditingController(
      text: experience?['position'] as String? ?? '',
    );
    final companyController = TextEditingController(
      text: experience?['company'] as String? ?? '',
    );
    final descriptionController = TextEditingController(
      text: experience?['description'] as String? ?? '',
    );
    final startYearController = TextEditingController(
      text: experience?['startYear']?.toString() ?? '',
    );
    final endYearController = TextEditingController(
      text: experience?['endYear']?.toString() ?? '',
    );

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? '编辑工作经历' : '添加工作经历'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: positionController,
                decoration: const InputDecoration(
                  labelText: '职位名称 *',
                  hintText: '如：营养师、健康顾问',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: companyController,
                decoration: const InputDecoration(
                  labelText: '公司名称 *',
                  hintText: '如：XXX医院、XXX公司',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: startYearController,
                      decoration: const InputDecoration(
                        labelText: '开始年份 *',
                        hintText: '如：2020',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: endYearController,
                      decoration: const InputDecoration(
                        labelText: '结束年份 *',
                        hintText: '如：2023',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: '工作描述',
                  hintText: '简要描述主要工作内容和职责',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              if (positionController.text.trim().isEmpty ||
                  companyController.text.trim().isEmpty ||
                  startYearController.text.trim().isEmpty ||
                  endYearController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请填写必填项')),
                );
                return;
              }

              final data = {
                'position': positionController.text.trim(),
                'company': companyController.text.trim(),
                'startYear': int.tryParse(startYearController.text.trim()),
                'endYear': int.tryParse(endYearController.text.trim()),
                'description': descriptionController.text.trim(),
              };

              Navigator.pop(context, data);
            },
            child: Text(isEditing ? '保存' : '添加'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        if (isEditing && index != null) {
          _previousExperiences[index] = result;
        } else {
          _previousExperiences.add(result);
        }
      });
      _onDataChanged();
    }

    // 清理控制器
    positionController.dispose();
    companyController.dispose();
    descriptionController.dispose();
    startYearController.dispose();
    endYearController.dispose();
  }
}