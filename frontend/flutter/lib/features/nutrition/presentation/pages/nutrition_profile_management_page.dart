import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/constants/nutrition_constants.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../../user/domain/value_objects/user_id.dart';
import '../providers/nutrition_profile_list_provider.dart';
import '../widgets/profile_template_selector.dart';
import '../../data/models/nutrition_template_model.dart';
import '../widgets/activity_level_detail_selector.dart';
import '../widgets/dynamic_health_goals_form.dart';
import '../widgets/conflict_detection_widget.dart';
import '../widgets/wheel_number_picker.dart';
import '../widgets/custom_option_selector.dart';
import '../../../user/presentation/providers/user_provider.dart';

class NutritionProfileManagementPage extends ConsumerStatefulWidget {
  final String? profileId;
  final bool isNewProfile;
  
  const NutritionProfileManagementPage({
    super.key,
    this.profileId,
    this.isNewProfile = false,
  });

  @override
  ConsumerState<NutritionProfileManagementPage> createState() =>
      _NutritionProfileManagementPageState();
}

class _NutritionProfileManagementPageState
    extends ConsumerState<NutritionProfileManagementPage> {
  final _formKey = GlobalKey<FormState>();
  
  // 档案信息
  String _profileName = '';
  NutritionProfileV2? _originalProfile;
  
  // 基本信息
  String _gender = '';
  String _ageGroup = '';
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  
  // 健康目标（支持多选）
  final Set<String> _healthGoals = {};
  final Map<String, Map<String, dynamic>> _healthGoalDetailsMap = {};
  final _targetCaloriesController = TextEditingController();
  
  // 饮食偏好（多选）
  final Set<String> _dietaryPreferences = {};
  final Set<String> _cuisinePreferences = {};
  final Map<String, int> _tastePreferences = {};
  final Set<String> _specialDietaryRequirements = {};
  
  // 可选字段
  final Set<String> _medicalConditions = {};
  String? _exerciseFrequency;
  final Set<String> _nutritionPreferences = {};
  final Set<String> _specialStatus = {};
  final Set<String> _forbiddenIngredients = {};
  final Set<String> _allergies = {};
  
  // 新增：详细配置
  Map<String, dynamic> _activityDetails = {};
  Map<String, dynamic> _healthGoalDetails = {};
  
  bool _isLoading = false;
  bool _isEditMode = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _targetCaloriesController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    if (widget.profileId == null || widget.isNewProfile) {
      setState(() {
        _isEditMode = true;
        _profileName = '新建档案';
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final profile = ref.read(nutritionProfileListProvider.notifier)
          .getProfileById(widget.profileId!);
      
      if (profile != null) {
        _originalProfile = profile;
        _profileName = profile.profileName;
        _gender = profile.gender;
        _ageGroup = profile.ageGroup;
        _heightController.text = profile.height.toStringAsFixed(0);
        _weightController.text = profile.weight.toStringAsFixed(1);
        
        // 从 healthGoalDetails 中恢复健康目标
        if (profile.healthGoalDetails != null && profile.healthGoalDetails!['goals'] is List) {
          _healthGoals.addAll((profile.healthGoalDetails!['goals'] as List).cast<String>());
          if (profile.healthGoalDetails!['goalsDetails'] is Map) {
            final goalsDetails = profile.healthGoalDetails!['goalsDetails'] as Map;
            goalsDetails.forEach((key, value) {
              if (key is String && value is Map) {
                _healthGoalDetailsMap[key] = Map<String, dynamic>.from(value);
              }
            });
          }
          if (profile.healthGoalDetails!['cuisinePreferences'] is List) {
            _cuisinePreferences.addAll((profile.healthGoalDetails!['cuisinePreferences'] as List).cast<String>());
          }
          if (profile.healthGoalDetails!['tastePreferences'] is Map) {
            final tastePrefs = profile.healthGoalDetails!['tastePreferences'] as Map;
            tastePrefs.forEach((key, value) {
              if (key is String && value is int) {
                _tastePreferences[key] = value;
              }
            });
          }
          if (profile.healthGoalDetails!['specialDietaryRequirements'] is List) {
            _specialDietaryRequirements.addAll(
              (profile.healthGoalDetails!['specialDietaryRequirements'] as List).cast<String>()
            );
          }
        } else {
          // 兼容旧数据
          _healthGoals.add(profile.healthGoal);
        }
        
        _targetCaloriesController.text = profile.targetCalories.toStringAsFixed(0);
        _dietaryPreferences.addAll(profile.dietaryPreferences);
        _medicalConditions.addAll(profile.medicalConditions);
        _exerciseFrequency = profile.exerciseFrequency;
        _nutritionPreferences.addAll(profile.nutritionPreferences);
        _specialStatus.addAll(profile.specialStatus);
        _forbiddenIngredients.addAll(profile.forbiddenIngredients);
        _allergies.addAll(profile.allergies);
        _activityDetails = profile.activityDetails ?? {};
        _healthGoalDetails = profile.healthGoalDetails ?? {};
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: Text(
            _isEditMode ? '编辑档案' : '档案详情',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                ],
              ),
            ),
          ),
          actions: [
            if (!_isEditMode && !widget.isNewProfile)
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: TextButton.icon(
                  onPressed: () => setState(() => _isEditMode = true),
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    '编辑',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            else if (_isEditMode)
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: TextButton.icon(
                  onPressed: _isLoading ? null : _handleSave,
                  icon: const Icon(
                    Icons.save_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    '保存',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                autovalidateMode: _isEditMode
                    ? AutovalidateMode.disabled
                    : AutovalidateMode.disabled,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // 档案名称
                    if (_isEditMode) ...[                     
                      TextFormField(
                        initialValue: _profileName,
                        decoration: const InputDecoration(
                          labelText: '档案名称',
                          hintText: '例如：日常饮食、减脂计划等',
                          border: OutlineInputBorder(),
                        ),
                        enabled: _isEditMode,
                        onChanged: (value) {
                          setState(() {
                            _profileName = value;
                            _checkForChanges();
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) return '请输入档案名称';
                          if (value.length > 20) return '档案名称不能超过20个字符';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                    
                    // 模板选择器（仅在创建新档案时显示）
                    if (widget.isNewProfile) ...[
                      ProfileTemplateSelector(
                        onTemplateSelected: _applyTemplate,
                        isEnabled: _isEditMode,
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // 档案完整度
                    _buildCompletionCard(context),
                    const SizedBox(height: 24),
                    
                    // 基本信息（必填）
                    _buildSectionTitle(context, '基本信息', required: true),
                    const SizedBox(height: 16),
                    _buildBasicInfoSection(context),
                    const SizedBox(height: 24),
                    
                    // 健康目标（必填）
                    _buildSectionTitle(context, '健康目标', required: true),
                    const SizedBox(height: 16),
                    _buildHealthGoalSectionWithDynamicForm(context),
                    const SizedBox(height: 24),
                    
                    // 饮食偏好（必填）
                    _buildSectionTitle(context, '饮食偏好', required: true),
                    const SizedBox(height: 16),
                    _buildDietaryPreferencesSection(context),
                    const SizedBox(height: 24),
                    
                    // 健康状况（可选）
                    _buildSectionTitle(context, '健康状况', required: false),
                    const SizedBox(height: 16),
                    _buildHealthStatusSection(context),
                    const SizedBox(height: 24),
                    
                    // 营养偏向（可选）
                    _buildSectionTitle(context, '营养偏向', required: false),
                    const SizedBox(height: 16),
                    _buildNutritionPreferencesSection(context),
                    const SizedBox(height: 24),
                    
                    // 禁忌与过敏（可选）
                    _buildSectionTitle(context, '禁忌与过敏', required: false),
                    const SizedBox(height: 16),
                    _buildAllergySection(context),
                    const SizedBox(height: 32),
                    
                    // 冲突检测
                    if (_isEditMode)
                      ConflictDetectionWidget(
                        profileData: {
                          'gender': _gender,
                          'ageGroup': _ageGroup,
                          'height': _heightController.text.isNotEmpty ? double.tryParse(_heightController.text) : null,
                          'weight': _weightController.text.isNotEmpty ? double.tryParse(_weightController.text) : null,
                          'healthGoal': _healthGoals.isNotEmpty ? _healthGoals.first : '',
                          'targetCalories': _targetCaloriesController.text.isNotEmpty ? double.tryParse(_targetCaloriesController.text) : null,
                          'dietaryPreferences': _dietaryPreferences.toList(),
                          'medicalConditions': _medicalConditions.toList(),
                          'exerciseFrequency': _exerciseFrequency,
                          'activityLevelDetail': _activityDetails['activityLevelDetail'],
                          'nutritionPreferences': _nutritionPreferences.toList(),
                          'specialStatus': _specialStatus.toList(),
                          'forbiddenIngredients': _forbiddenIngredients.toList(),
                          'allergies': _allergies.toList(),
                          'activityDetails': _activityDetails,
                          'healthGoalDetails': _healthGoalDetails,
                        },
                        enabled: _isEditMode,
                      ),
                    const SizedBox(height: 32),
                    
                    // 保存按钮
                    if (_isEditMode)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSave,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('保存档案'),
                        ),
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCompletionCard(BuildContext context) {
    final theme = Theme.of(context);
    final completionPercentage = _calculateCompletion();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '档案完整度',
                  style: theme.textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  '$completionPercentage%',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: completionPercentage / 100,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              _getCompletionHint(completionPercentage),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, {required bool required}) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: TextStyle(
              color: theme.colorScheme.error,
              fontSize: 16,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBasicInfoSection(BuildContext context) {
    return Column(
      children: [
        // 性别
        _buildDropdownField(
          context,
          label: '性别',
          value: _gender.isEmpty ? null : _gender,
          items: NutritionConstants.genderOptions.entries
              .map((e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value),
                  ))
              .toList(),
          onChanged: _isEditMode ? (value) {
            setState(() {
              _gender = value?.toString() ?? '';
              _checkForChanges();
            });
          } : null,
          validator: (value) => value == null || value.isEmpty ? '请选择性别' : null,
        ),
        const SizedBox(height: 16),
        
        // 年龄段
        _buildDropdownField(
          context,
          label: '年龄段',
          value: _ageGroup.isEmpty ? null : _ageGroup,
          items: NutritionConstants.ageGroupOptions.entries
              .map((e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value),
                  ))
              .toList(),
          onChanged: _isEditMode ? (value) {
            setState(() {
              _ageGroup = value?.toString() ?? '';
              _checkForChanges();
            });
          } : null,
          validator: (value) => value == null || value.isEmpty ? '请选择年龄段' : null,
        ),
        const SizedBox(height: 16),
        
        // 身高体重 - 编辑模式使用滚轮选择器，查看模式显示文本
        if (_isEditMode)
          Row(
            children: [
              Expanded(
                child: WheelNumberPicker(
                  label: '身高',
                  initialValue: double.tryParse(_heightController.text) ?? 170.0,
                  minValue: 50.0,
                  maxValue: 250.0,
                  unit: 'cm',
                  decimals: 0,
                  onChanged: (value) {
                    setState(() {
                      _heightController.text = value.toStringAsFixed(0);
                      _checkForChanges();
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: WheelNumberPicker(
                  label: '体重',
                  initialValue: double.tryParse(_weightController.text) ?? 60.0,
                  minValue: 20.0,
                  maxValue: 200.0,
                  unit: 'kg',
                  decimals: 1,
                  onChanged: (value) {
                    setState(() {
                      _weightController.text = value.toStringAsFixed(1);
                      _checkForChanges();
                    });
                  },
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: _buildInfoDisplay(
                  context,
                  label: '身高',
                  value: '${_heightController.text}cm',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoDisplay(
                  context,
                  label: '体重',
                  value: '${_weightController.text}kg',
                ),
              ),
            ],
          ),
        
        // BMI显示
        if (_heightController.text.isNotEmpty && _weightController.text.isNotEmpty)
          _buildBMIDisplay(context),
      ],
    );
  }

  Widget _buildBMIDisplay(BuildContext context) {
    final theme = Theme.of(context);
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    
    if (height == null || weight == null || height <= 0) return const SizedBox();
    
    final bmi = weight / ((height / 100) * (height / 100));
    final bmiStatus = _getBMIStatus(bmi);
    
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Card(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'BMI: ${bmi.toStringAsFixed(1)} - $bmiStatus',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthGoalSectionWithDynamicForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 健康目标多选
        Text(
          '请选择健康目标（可多选）',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: NutritionConstants.healthGoalOptions.entries
              .map((entry) => FilterChip(
                    label: Text(entry.value),
                    selected: _healthGoals.contains(entry.key),
                    onSelected: !_isEditMode ? null : (selected) {
                      if (selected) {
                        // 检查冲突
                        final conflicts = _checkHealthGoalConflicts(entry.key, _healthGoals, _gender);
                        if (conflicts.isNotEmpty) {
                          _showConflictDialog(context, entry.key, conflicts);
                          return;
                        }
                      }
                      
                      setState(() {
                        if (selected) {
                          _healthGoals.add(entry.key);
                          // 初始化该目标的详情
                          if (!_healthGoalDetailsMap.containsKey(entry.key)) {
                            _healthGoalDetailsMap[entry.key] = {};
                          }
                        } else {
                          _healthGoals.remove(entry.key);
                          _healthGoalDetailsMap.remove(entry.key);
                        }
                        _updateSuggestedCalories();
                        _checkForChanges();
                      });
                    },
                  ))
              .toList(),
        ),
        
        // 为每个选中的健康目标显示详细配置
        if (_healthGoals.isNotEmpty && _isEditMode) ...[
          const SizedBox(height: 24),
          const Divider(),
          ..._healthGoals.map((goal) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                '${NutritionConstants.healthGoalOptions[goal]} - 详细配置',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DynamicHealthGoalsForm(
                healthGoal: goal,
                initialDetails: _healthGoalDetailsMap[goal] ?? {},
                onDetailsChanged: (details) {
                  setState(() {
                    _healthGoalDetailsMap[goal] = details;
                    _checkForChanges();
                  });
                },
              ),
              const Divider(),
            ],
          )).toList(),
        ],
        
        const SizedBox(height: 16),
        
        // 目标热量
        TextFormField(
          controller: _targetCaloriesController,
          decoration: InputDecoration(
            labelText: '目标热量',
            suffixText: 'kcal/天',
            border: const OutlineInputBorder(),
            helperText: _getSuggestedCaloriesText(),
          ),
          enabled: _isEditMode,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          onChanged: (_) => _checkForChanges(),
          validator: (value) {
            if (value == null || value.isEmpty) return '请输入目标热量';
            final calories = int.tryParse(value);
            if (calories == null || calories <= 0) return '请输入有效热量值';
            if (calories < 800 || calories > 5000) return '热量范围应在800-5000kcal';
            return null;
          },
        ),
      ],
    );
  }


  Widget _buildDietaryPreferencesSection(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: NutritionConstants.dietaryPreferenceOptions.entries
          .map((entry) => FilterChip(
                label: Text(entry.value),
                selected: _dietaryPreferences.contains(entry.key),
                onSelected: _isEditMode ? (selected) {
                  setState(() {
                    if (selected) {
                      _dietaryPreferences.add(entry.key);
                    } else {
                      _dietaryPreferences.remove(entry.key);
                    }
                    _checkForChanges();
                  });
                } : null,
              ))
          .toList(),
    );
  }

  Widget _buildHealthStatusSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 疾病史
        _buildChipSection(
          context,
          title: '疾病史',
          options: NutritionConstants.medicalConditionOptions,
          selectedValues: _medicalConditions,
          onSelectionChanged: (values) => setState(() {
            _medicalConditions.clear();
            _medicalConditions.addAll(values);
          }),
        ),
        const SizedBox(height: 16),
        
        // 运动频率
        _buildDropdownField(
          context,
          label: '运动频率',
          value: _exerciseFrequency,
          items: NutritionConstants.exerciseFrequencyOptions.entries
              .map((e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value),
                  ))
              .toList(),
          onChanged: _isEditMode ? (value) {
            setState(() {
              _exerciseFrequency = value?.toString();
              _checkForChanges();
            });
          } : null,
          required: false,
        ),
        // 活动水平详情选择器
        if (_exerciseFrequency != null && _exerciseFrequency!.isNotEmpty && _isEditMode) ...[    
          const SizedBox(height: 16),
          ActivityLevelDetailSelector(
            selectedValue: _activityDetails['activityLevelDetail'] as String?,
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  _activityDetails['activityLevelDetail'] = value;
                } else {
                  _activityDetails.remove('activityLevelDetail');
                }
                _checkForChanges();
              });
            },
            enabled: _isEditMode,
          ),
        ],
        const SizedBox(height: 16),
        
        // 特殊状态
        _buildChipSection(
          context,
          title: '特殊状态',
          options: NutritionConstants.specialStatusOptions,
          selectedValues: _specialStatus,
          onSelectionChanged: (values) => setState(() {
            _specialStatus.clear();
            _specialStatus.addAll(values);
          }),
        ),
      ],
    );
  }

  Widget _buildNutritionPreferencesSection(BuildContext context) {
    return _buildChipSection(
      context,
      title: '',
      options: NutritionConstants.nutritionPreferenceOptions,
      selectedValues: _nutritionPreferences,
      onSelectionChanged: (values) => setState(() {
        _nutritionPreferences.clear();
        _nutritionPreferences.addAll(values);
      }),
    );
  }

  Widget _buildAllergySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 过敏原
        _buildChipSection(
          context,
          title: '过敏原',
          options: NutritionConstants.allergyOptions,
          selectedValues: _allergies,
          onSelectionChanged: (values) => setState(() {
            _allergies.clear();
            _allergies.addAll(values);
          }),
        ),
        const SizedBox(height: 16),
        
        // 禁忌食材
        _buildChipSection(
          context,
          title: '禁忌食材',
          options: NutritionConstants.forbiddenIngredientOptions,
          selectedValues: _forbiddenIngredients,
          onSelectionChanged: (values) => setState(() {
            _forbiddenIngredients.clear();
            _forbiddenIngredients.addAll(values);
          }),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>(
    BuildContext context, {
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?>? onChanged,
    String? Function(T?)? validator,
    bool required = true,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildChipSection(
    BuildContext context, {
    required String title,
    required Map<String, String> options,
    required Set<String> selectedValues,
    required ValueChanged<Set<String>> onSelectionChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.entries
              .map((entry) => FilterChip(
                    label: Text(entry.value),
                    selected: selectedValues.contains(entry.key),
                    onSelected: _isEditMode ? (selected) {
                      final newValues = Set<String>.from(selectedValues);
                      if (selected) {
                        newValues.add(entry.key);
                      } else {
                        newValues.remove(entry.key);
                      }
                      onSelectionChanged(newValues);
                      _checkForChanges();
                    } : null,
                  ))
              .toList(),
        ),
      ],
    );
  }

  int _calculateCompletion() {
    int filledRequiredFields = 0;
    const int totalRequiredFields = 6; // 只计算必填字段
    
    // 必填字段 - 只有这些字段影响完成度百分比
    if (_gender.isNotEmpty) filledRequiredFields++;
    if (_ageGroup.isNotEmpty) filledRequiredFields++;
    if (_heightController.text.isNotEmpty) filledRequiredFields++;
    if (_weightController.text.isNotEmpty) filledRequiredFields++;
    if (_healthGoals.isNotEmpty) filledRequiredFields++;
    if (_targetCaloriesController.text.isNotEmpty) filledRequiredFields++;
    
    // 可选字段不影响完成度计算，但仍然保存到档案中
    // 这样用户可以在只填写必填字段的情况下达到100%完成度
    
    return ((filledRequiredFields / totalRequiredFields) * 100).round();
  }

  String _getCompletionHint(int percentage) {
    if (percentage < 60) return '继续完善档案，获得更精准的推荐';
    if (percentage < 80) return '档案信息较完整，可以获得不错的推荐';
    if (percentage < 100) return '档案信息很完整，推荐效果会很好';
    return '档案信息完美！享受最精准的AI推荐';
  }

  String _getBMIStatus(double bmi) {
    if (bmi < 18.5) return '偏瘦';
    if (bmi < 24) return '正常';
    if (bmi < 28) return '偏胖';
    return '肥胖';
  }

  void _updateSuggestedCalories() {
    // 根据性别、年龄、体重、身高和健康目标计算建议热量
    if (_gender.isEmpty || _ageGroup.isEmpty || 
        _heightController.text.isEmpty || _weightController.text.isEmpty) {
      return;
    }

    final weight = double.tryParse(_weightController.text) ?? 0;
    final height = double.tryParse(_heightController.text) ?? 0;
    
    // 简化的基础代谢率计算
    double bmr = _gender == 'male' 
        ? (10 * weight + 6.25 * height - 5 * 25 + 5)
        : (10 * weight + 6.25 * height - 5 * 25 - 161);

    // 根据健康目标调整
    double targetCalories = bmr * 1.5; // 中等活动水平
    
    // 根据主要健康目标调整热量
    final primaryGoal = _healthGoals.isNotEmpty ? _healthGoals.first : '';
    switch (primaryGoal) {
      case 'weight_loss':
        targetCalories *= 0.85; // 减少15%
        break;
      case 'weight_gain':
      case 'muscle_gain':
        targetCalories *= 1.15; // 增加15%
        break;
      case 'weight_maintain':
      default:
        // 保持不变
        break;
    }

    _targetCaloriesController.text = targetCalories.round().toString();
  }

  String? _getSuggestedCaloriesText() {
    if (_gender.isEmpty || _ageGroup.isEmpty || 
        _heightController.text.isEmpty || _weightController.text.isEmpty ||
        _healthGoals.isEmpty) {
      return null;
    }
    return '基于您的信息，建议热量约为 ${_targetCaloriesController.text} kcal';
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      // 显示错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请填写所有必填项'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 移除饮食偏好必填验证 - 这些是可选项

    if (_healthGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请至少选择一个健康目标'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 获取当前用户ID
      final userState = ref.read(userProvider);
      final userId = userState.userId ?? 'guest_user';
      
      // 将多个健康目标和饮食偏好详情存储在 healthGoalDetails 中
      final healthGoalDetails = {
        'goals': _healthGoals.toList(),
        'goalsDetails': _healthGoalDetailsMap,
        'cuisinePreferences': _cuisinePreferences.toList(),
        'tastePreferences': _tastePreferences,
        'specialDietaryRequirements': _specialDietaryRequirements.toList(),
      };
      
      final profile = NutritionProfileV2(
        id: _originalProfile?.id,
        userId: UserId(userId),
        gender: _gender,
        ageGroup: _ageGroup,
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        healthGoal: _healthGoals.isNotEmpty ? _healthGoals.first : 'maintain_weight',  // 主要目标
        targetCalories: double.parse(_targetCaloriesController.text),
        healthGoalDetails: healthGoalDetails,  // 所有目标和详情存储在这里
        dietaryPreferences: _dietaryPreferences.toList(),
        medicalConditions: _medicalConditions.toList(),
        exerciseFrequency: _exerciseFrequency,
        activityDetails: _activityDetails.isNotEmpty ? _activityDetails : null,
        nutritionPreferences: _nutritionPreferences.toList(),
        specialStatus: _specialStatus.toList(),
        forbiddenIngredients: _forbiddenIngredients.toList(),
        allergies: _allergies.toList(),
        profileName: _profileName,
        isPrimary: _originalProfile?.isPrimary ?? false,
        createdAt: _originalProfile?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.isNewProfile) {
        await ref.read(nutritionProfileListProvider.notifier).createProfile(profile);
      } else {
        await ref.read(nutritionProfileListProvider.notifier).updateProfile(profile);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isNewProfile ? '营养档案创建成功' : '营养档案更新成功'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _checkForChanges() {
    if (_originalProfile == null) {
      setState(() => _hasChanges = true);
      return;
    }

    final hasChanges = 
        _profileName != _originalProfile!.profileName ||
        _gender != _originalProfile!.gender ||
        _ageGroup != _originalProfile!.ageGroup ||
        _heightController.text != _originalProfile!.height.toStringAsFixed(0) ||
        _weightController.text != _originalProfile!.weight.toStringAsFixed(1) ||
        !_setEquals(_healthGoals, {_originalProfile!.healthGoal}) ||
        _targetCaloriesController.text != _originalProfile!.targetCalories.toStringAsFixed(0) ||
        !_setEquals(_dietaryPreferences, _originalProfile!.dietaryPreferences.toSet()) ||
        !_setEquals(_medicalConditions, _originalProfile!.medicalConditions.toSet()) ||
        _exerciseFrequency != _originalProfile!.exerciseFrequency ||
        !_setEquals(_nutritionPreferences, _originalProfile!.nutritionPreferences.toSet()) ||
        !_setEquals(_specialStatus, _originalProfile!.specialStatus.toSet()) ||
        !_setEquals(_forbiddenIngredients, _originalProfile!.forbiddenIngredients.toSet()) ||
        !_setEquals(_allergies, _originalProfile!.allergies.toSet()) ||
        _mapEquals(_activityDetails, _originalProfile!.activityDetails ?? {}) == false ||
        _mapEquals(_healthGoalDetails, _originalProfile!.healthGoalDetails ?? {}) == false;

    setState(() => _hasChanges = hasChanges);
    
    // 自动切换到编辑模式
    if (hasChanges && !_isEditMode) {
      setState(() => _isEditMode = true);
    }
  }

  bool _setEquals<T>(Set<T> a, Set<T> b) {
    if (a.length != b.length) return false;
    return a.every((element) => b.contains(element));
  }
  
  bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('保存更改？'),
        content: const Text('您有未保存的更改，是否保存？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('放弃'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('保存'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _handleSave();
      return false;
    }

    return true;
  }

  // 应用模板到表单
  void _applyTemplate(NutritionTemplateModel template) {
    setState(() {
      final profileData = template.data;
      
      // 基本信息
      if (profileData.gender != null) _gender = profileData.gender!;
      if (profileData.ageGroup != null) _ageGroup = profileData.ageGroup!;
      if (profileData.height != null) _heightController.text = profileData.height!.toStringAsFixed(0);
      if (profileData.weight != null) _weightController.text = profileData.weight!.toStringAsFixed(1);
      
      // 健康目标
      if (profileData.nutritionGoals.isNotEmpty) {
        // 将nutritionGoals转换为healthGoals（映射所有目标）
        _healthGoals.clear();
        for (final goal in profileData.nutritionGoals) {
          final mappedGoal = _mapNutritionGoalToHealthGoal(goal);
          _healthGoals.add(mappedGoal);
        }
      }
      
      // 目标热量
      if (profileData.dailyCalorieTarget != null) {
        _targetCaloriesController.text = profileData.dailyCalorieTarget!.toStringAsFixed(0);
      }
      
      // 饮食偏好
      if (profileData.dietaryPreferences != null) {
        _dietaryPreferences.clear();
        if (profileData.dietaryPreferences!.vegetarian == true) _dietaryPreferences.add('vegetarian');
        if (profileData.dietaryPreferences!.vegan == true) _dietaryPreferences.add('vegan');
        if (profileData.dietaryPreferences!.lowCarb == true) _dietaryPreferences.add('lowCarb');
        if (profileData.dietaryPreferences!.glutenFree == true) _dietaryPreferences.add('glutenFree');
        if (profileData.dietaryPreferences!.dairyFree == true) _dietaryPreferences.add('dairyFree');
        if (profileData.dietaryPreferences!.keto == true) _dietaryPreferences.add('keto');
        if (profileData.dietaryPreferences!.paleo == true) _dietaryPreferences.add('paleo');
        if (profileData.dietaryPreferences!.halal == true) _dietaryPreferences.add('halal');
        if (profileData.dietaryPreferences!.kosher == true) _dietaryPreferences.add('kosher');
      }
      
      // 健康状况
      if (profileData.medicalConditions != null) {
        _medicalConditions.clear();
        _medicalConditions.addAll(profileData.medicalConditions!);
      }
      
      // 运动频率
      if (profileData.lifestyle?.exerciseFrequency != null) {
        _exerciseFrequency = profileData.lifestyle!.exerciseFrequency;
      }
      
      // 特殊状态
      if (profileData.lifestyle?.specialStatus != null) {
        _specialStatus.clear();
        _specialStatus.addAll(profileData.lifestyle!.specialStatus!);
      }
      
      // 过敏原
      if (profileData.dietaryPreferences?.allergies != null) {
        _allergies.clear();
        _allergies.addAll(profileData.dietaryPreferences!.allergies!);
      }
      
      // 禁忌食材
      if (profileData.dietaryPreferences?.forbiddenIngredients != null) {
        _forbiddenIngredients.clear();
        _forbiddenIngredients.addAll(profileData.dietaryPreferences!.forbiddenIngredients!);
      }
      
      // 营养偏好
      if (profileData.dietaryPreferences?.nutritionPreferences != null) {
        _nutritionPreferences.clear();
        _nutritionPreferences.addAll(profileData.dietaryPreferences!.nutritionPreferences!);
      }
      
      // 活动详情和健康目标详情
      if (profileData.activityDetails != null) {
        _activityDetails = Map<String, dynamic>.from(profileData.activityDetails!);
      }
      if (profileData.healthGoalDetails != null) {
        _healthGoalDetails = profileData.healthGoalDetails!.toJson();
      }
      
      // 更新档案名称
      if (template.name.isNotEmpty) {
        _profileName = '${template.name}档案';
      }
      
      // 标记为有更改
      _hasChanges = true;
    });
  }
  
  // 将营养目标映射到健康目标
  Widget _buildInfoDisplay(BuildContext context, {required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _mapNutritionGoalToHealthGoal(String nutritionGoal) {
    // 根据实际的映射关系进行转换
    switch (nutritionGoal.toLowerCase()) {
      case 'weight_loss':
      case 'lose_weight':
        return 'loseWeight';
      case 'muscle_gain':
      case 'gain_muscle':
        return 'gainMuscle';
      case 'maintain_weight':
      case 'maintain':
        return 'maintainWeight';
      case 'improve_health':
        return 'improveHealth';
      default:
        return 'maintainWeight'; // 默认值
    }
  }

  /// 检查健康目标冲突
  List<String> _checkHealthGoalConflicts(String newGoal, Set<String> currentGoals, String? gender) {
    final conflicts = <String>[];
    
    // 定义冲突组
    final conflictGroups = [
      ['weight_loss', 'weight_gain'],  // 减重和增重冲突
      ['pregnancy', 'menopause'],      // 孕期和更年期冲突
      ['lactation', 'menopause'],      // 哺乳期和更年期冲突
    ];
    
    // 定义性别限制
    final maleRestrictedGoals = ['pregnancy', 'lactation', 'menopause'];
    
    // 检查性别限制
    if (gender == 'male' && maleRestrictedGoals.contains(newGoal)) {
      conflicts.add('男性不能选择该健康目标');
      return conflicts;
    }
    
    // 检查冲突组
    for (final group in conflictGroups) {
      if (group.contains(newGoal)) {
        for (final goal in group) {
          if (goal != newGoal && currentGoals.contains(goal)) {
            final goalName = NutritionConstants.healthGoalOptions[goal] ?? goal;
            final newGoalName = NutritionConstants.healthGoalOptions[newGoal] ?? newGoal;
            conflicts.add('$newGoalName 与已选择的 $goalName 冲突');
          }
        }
      }
    }
    
    return conflicts;
  }

  /// 显示冲突对话框
  void _showConflictDialog(BuildContext context, String newGoal, List<String> conflicts) {
    final goalName = NutritionConstants.healthGoalOptions[newGoal] ?? newGoal;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('健康目标冲突'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('无法选择 "$goalName"：'),
            const SizedBox(height: 8),
            ...conflicts.map((conflict) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• '),
                  Expanded(child: Text(conflict)),
                ],
              ),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }
}