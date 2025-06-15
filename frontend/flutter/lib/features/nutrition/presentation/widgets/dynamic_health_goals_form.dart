import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/constants/nutrition_constants.dart';

/// 动态健康目标表单
class DynamicHealthGoalsForm extends StatefulWidget {
  final String healthGoal;
  final Map<String, dynamic> initialDetails;
  final ValueChanged<Map<String, dynamic>> onDetailsChanged;
  final bool enabled;

  const DynamicHealthGoalsForm({
    Key? key,
    required this.healthGoal,
    required this.initialDetails,
    required this.onDetailsChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<DynamicHealthGoalsForm> createState() => _DynamicHealthGoalsFormState();
}

class _DynamicHealthGoalsFormState extends State<DynamicHealthGoalsForm> {
  late Map<String, dynamic> _details;

  @override
  void initState() {
    super.initState();
    _details = Map<String, dynamic>.from(widget.initialDetails);
  }

  @override
  void didUpdateWidget(DynamicHealthGoalsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDetails != widget.initialDetails) {
      _details = Map<String, dynamic>.from(widget.initialDetails);
    }
  }

  void _updateDetails(String key, dynamic value) {
    setState(() {
      if (_details[key] == null) {
        _details[key] = <String, dynamic>{};
      }
      _details[key] = value;
    });
    widget.onDetailsChanged(_details);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.healthGoal.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '健康目标详细配置',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '根据您选择的健康目标，请填写相关详细信息',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        _buildGoalForm(widget.healthGoal),
      ],
    );
  }

  Widget _buildGoalForm(String goal) {
    // 定义需要详细配置的健康目标
    const goalsNeedingDetails = {
      'blood_sugar_control',
      'blood_pressure_control', 
      'cholesterol_management',
      'weight_loss',
      'weight_gain',
      'weight_maintain',
      'muscle_gain',
      'sports_performance',
      'pregnancy',
      'lactation',
      'gut_health',
      'immunity_boost',
    };
    
    // 如果不需要详细配置，返回空
    if (!goalsNeedingDetails.contains(goal)) {
      return const SizedBox.shrink();
    }
    
    switch (goal) {
      case 'blood_sugar_control':
        return _buildBloodSugarForm();
      case 'blood_pressure_control':
        return _buildBloodPressureForm();
      case 'cholesterol_management':
        return _buildCholesterolForm();
      case 'weight_loss':
      case 'weight_gain':
      case 'weight_maintain':
        return _buildWeightManagementForm();
      case 'muscle_gain':
      case 'sports_performance':
        return _buildSportsNutritionForm();
      case 'pregnancy':
      case 'lactation':
        return _buildSpecialPhysiologicalForm();
      case 'gut_health':
        return _buildDigestiveHealthForm();
      case 'immunity_boost':
        return _buildImmunityForm();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBloodSugarForm() {
    final details = _details['bloodSugarControl'] as Map<String, dynamic>? ?? {};
    
    return _GoalFormSection(
      title: '血糖控制',
      icon: Icons.medical_services,
      color: Colors.red,
      enabled: widget.enabled,
      children: [
        _NumberFormField(
          label: '空腹血糖 (mmol/L)',
          value: details['fastingGlucose']?.toString(),
          onChanged: (value) => _updateDetails('bloodSugarControl', {
            ...details,
            'fastingGlucose': double.tryParse(value ?? ''),
          }),
          enabled: widget.enabled,
          suffix: 'mmol/L',
        ),
        _NumberFormField(
          label: '餐后2小时血糖 (mmol/L)',
          value: details['postprandialGlucose']?.toString(),
          onChanged: (value) => _updateDetails('bloodSugarControl', {
            ...details,
            'postprandialGlucose': double.tryParse(value ?? ''),
          }),
          enabled: widget.enabled,
          suffix: 'mmol/L',
        ),
        _NumberFormField(
          label: '糖化血红蛋白 (%)',
          value: details['hba1c']?.toString(),
          onChanged: (value) => _updateDetails('bloodSugarControl', {
            ...details,
            'hba1c': double.tryParse(value ?? ''),
          }),
          enabled: widget.enabled,
          suffix: '%',
        ),
        _DropdownFormField(
          label: '糖尿病类型',
          value: details['diabetesType'],
          items: const {
            'none': '无糖尿病',
            'type1': '1型糖尿病',
            'type2': '2型糖尿病',
            'gestational': '妊娠期糖尿病',
          },
          onChanged: (value) => _updateDetails('bloodSugarControl', {
            ...details,
            'diabetesType': value,
          }),
          enabled: widget.enabled,
        ),
      ],
    );
  }

  Widget _buildBloodPressureForm() {
    final details = _details['bloodPressureControl'] as Map<String, dynamic>? ?? {};
    
    return _GoalFormSection(
      title: '血压管理',
      icon: Icons.favorite,
      color: Colors.pink,
      enabled: widget.enabled,
      children: [
        Row(
          children: [
            Expanded(
              child: _NumberFormField(
                label: '收缩压 (mmHg)',
                value: details['systolic']?.toString(),
                onChanged: (value) => _updateDetails('bloodPressureControl', {
                  ...details,
                  'systolic': int.tryParse(value ?? ''),
                }),
                enabled: widget.enabled,
                suffix: 'mmHg',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _NumberFormField(
                label: '舒张压 (mmHg)',
                value: details['diastolic']?.toString(),
                onChanged: (value) => _updateDetails('bloodPressureControl', {
                  ...details,
                  'diastolic': int.tryParse(value ?? ''),
                }),
                enabled: widget.enabled,
                suffix: 'mmHg',
              ),
            ),
          ],
        ),
        _DropdownFormField(
          label: '高血压分级',
          value: details['hypertensionGrade'],
          items: const {
            'normal': '正常',
            'elevated': '偏高',
            'stage1': '1级高血压',
            'stage2': '2级高血压',
            'stage3': '3级高血压',
          },
          onChanged: (value) => _updateDetails('bloodPressureControl', {
            ...details,
            'hypertensionGrade': value,
          }),
          enabled: widget.enabled,
        ),
      ],
    );
  }

  Widget _buildCholesterolForm() {
    final details = _details['cholesterolManagement'] as Map<String, dynamic>? ?? {};
    
    return _GoalFormSection(
      title: '血脂管理',
      icon: Icons.water_drop,
      color: Colors.blue,
      enabled: widget.enabled,
      children: [
        _NumberFormField(
          label: '总胆固醇 (mmol/L)',
          value: details['totalCholesterol']?.toString(),
          onChanged: (value) => _updateDetails('cholesterolManagement', {
            ...details,
            'totalCholesterol': double.tryParse(value ?? ''),
          }),
          enabled: widget.enabled,
          suffix: 'mmol/L',
        ),
        _NumberFormField(
          label: '甘油三酯 (mmol/L)',
          value: details['triglycerides']?.toString(),
          onChanged: (value) => _updateDetails('cholesterolManagement', {
            ...details,
            'triglycerides': double.tryParse(value ?? ''),
          }),
          enabled: widget.enabled,
          suffix: 'mmol/L',
        ),
      ],
    );
  }

  Widget _buildWeightManagementForm() {
    final details = _details['weightManagement'] as Map<String, dynamic>? ?? {};
    
    return _GoalFormSection(
      title: '体重管理',
      icon: Icons.monitor_weight,
      color: Colors.green,
      enabled: widget.enabled,
      children: [
        _NumberFormField(
          label: '目标体重 (kg)',
          value: details['targetWeight']?.toString(),
          onChanged: (value) => _updateDetails('weightManagement', {
            ...details,
            'targetWeight': double.tryParse(value ?? ''),
          }),
          enabled: widget.enabled,
          suffix: 'kg',
        ),
        _DropdownFormField(
          label: '目标速度',
          value: details['targetSpeed'],
          items: const {
            'conservative': '保守 (0.5kg/周)',
            'moderate': '标准 (1kg/周)',
            'aggressive': '激进 (1.5kg/周)',
          },
          onChanged: (value) => _updateDetails('weightManagement', {
            ...details,
            'targetSpeed': value,
          }),
          enabled: widget.enabled,
        ),
      ],
    );
  }

  Widget _buildSportsNutritionForm() {
    final details = _details['sportsNutrition'] as Map<String, dynamic>? ?? {};
    
    return _GoalFormSection(
      title: '运动营养',
      icon: Icons.fitness_center,
      color: Colors.orange,
      enabled: widget.enabled,
      children: [
        _DropdownFormField(
          label: '训练阶段',
          value: details['trainingPhase'],
          items: const {
            'off_season': '休赛期',
            'pre_season': '备赛期',
            'competition': '比赛期',
            'recovery': '恢复期',
          },
          onChanged: (value) => _updateDetails('sportsNutrition', {
            ...details,
            'trainingPhase': value,
          }),
          enabled: widget.enabled,
        ),
      ],
    );
  }

  Widget _buildSpecialPhysiologicalForm() {
    final details = _details['specialPhysiological'] as Map<String, dynamic>? ?? {};
    
    return _GoalFormSection(
      title: '特殊生理期',
      icon: Icons.pregnant_woman,
      color: Colors.purple,
      enabled: widget.enabled,
      children: [
        if (widget.healthGoal == 'pregnancy')
          _NumberFormField(
            label: '孕周',
            value: details['pregnancyWeek']?.toString(),
            onChanged: (value) => _updateDetails('specialPhysiological', {
              ...details,
              'pregnancyWeek': int.tryParse(value ?? ''),
            }),
            enabled: widget.enabled,
            suffix: '周',
          ),
        if (widget.healthGoal == 'lactation')
          _NumberFormField(
            label: '哺乳月数',
            value: details['lactationMonth']?.toString(),
            onChanged: (value) => _updateDetails('specialPhysiological', {
              ...details,
              'lactationMonth': int.tryParse(value ?? ''),
            }),
            enabled: widget.enabled,
            suffix: '月',
          ),
      ],
    );
  }

  Widget _buildDigestiveHealthForm() {
    final details = _details['digestiveHealth'] as Map<String, dynamic>? ?? {};
    
    return _GoalFormSection(
      title: '消化健康',
      icon: Icons.restaurant,
      color: Colors.brown,
      enabled: widget.enabled,
      children: [
        _DropdownFormField(
          label: '幽门螺杆菌状态',
          value: details['hPyloriStatus'],
          items: const {
            'unknown': '未检测',
            'positive': '阳性',
            'negative': '阴性',
          },
          onChanged: (value) => _updateDetails('digestiveHealth', {
            ...details,
            'hPyloriStatus': value,
          }),
          enabled: widget.enabled,
        ),
      ],
    );
  }

  Widget _buildImmunityForm() {
    final details = _details['immunityBoost'] as Map<String, dynamic>? ?? {};
    
    return _GoalFormSection(
      title: '免疫与抗炎',
      icon: Icons.shield,
      color: Colors.teal,
      enabled: widget.enabled,
      children: [
        _DropdownFormField(
          label: '感染频率',
          value: details['infectionFrequency'],
          items: const {
            'rare': '很少',
            'occasional': '偶尔',
            'frequent': '频繁',
          },
          onChanged: (value) => _updateDetails('immunityBoost', {
            ...details,
            'infectionFrequency': value,
          }),
          enabled: widget.enabled,
        ),
      ],
    );
  }
}

/// 目标表单部分
class _GoalFormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;
  final bool enabled;

  const _GoalFormSection({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: enabled ? Colors.black87 : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// 数字输入字段
class _NumberFormField extends StatelessWidget {
  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool enabled;
  final String? suffix;

  const _NumberFormField({
    Key? key,
    required this.label,
    this.value,
    required this.onChanged,
    this.enabled = true,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        onChanged: onChanged,
        enabled: enabled,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
      ),
    );
  }
}

/// 下拉选择字段
class _DropdownFormField extends StatelessWidget {
  final String label;
  final String? value;
  final Map<String, String> items;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const _DropdownFormField({
    Key? key,
    required this.label,
    this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: enabled ? onChanged : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        items: items.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
      ),
    );
  }
}