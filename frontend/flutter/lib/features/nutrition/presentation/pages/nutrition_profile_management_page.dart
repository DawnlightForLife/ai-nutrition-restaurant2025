import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/constants/nutrition_constants.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../../domain/user/value_objects/user_id.dart';
import '../providers/nutrition_profile_list_provider.dart';

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
  
  // 健康目标
  String _healthGoal = '';
  final _targetCaloriesController = TextEditingController();
  
  // 饮食偏好（多选）
  final Set<String> _dietaryPreferences = {};
  
  // 可选字段
  final Set<String> _medicalConditions = {};
  String? _exerciseFrequency;
  final Set<String> _nutritionPreferences = {};
  final Set<String> _specialStatus = {};
  final Set<String> _forbiddenIngredients = {};
  final Set<String> _allergies = {};
  
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
        _healthGoal = profile.healthGoal;
        _targetCaloriesController.text = profile.targetCalories.toStringAsFixed(0);
        _dietaryPreferences.addAll(profile.dietaryPreferences);
        _medicalConditions.addAll(profile.medicalConditions);
        _exerciseFrequency = profile.exerciseFrequency;
        _nutritionPreferences.addAll(profile.nutritionPreferences);
        _specialStatus.addAll(profile.specialStatus);
        _forbiddenIngredients.addAll(profile.forbiddenIngredients);
        _allergies.addAll(profile.allergies);
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
        appBar: AppBar(
          title: Text(_isEditMode ? '编辑档案' : '档案详情'),
          centerTitle: true,
          actions: [
            if (!_isEditMode && !widget.isNewProfile)
              TextButton(
                onPressed: () => setState(() => _isEditMode = true),
                child: const Text('编辑'),
              )
            else if (_isEditMode)
              TextButton(
                onPressed: _isLoading ? null : _handleSave,
                child: const Text('保存'),
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
                    _buildHealthGoalSection(context),
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
        
        // 身高体重
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: '身高',
                  suffixText: 'cm',
                  border: OutlineInputBorder(),
                ),
                enabled: _isEditMode,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                onChanged: (_) => _checkForChanges(),
                validator: (value) {
                  if (value == null || value.isEmpty) return '请输入身高';
                  final height = double.tryParse(value);
                  if (height == null || height <= 0) return '请输入有效身高';
                  if (height < 50 || height > 250) return '身高范围应在50-250cm';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: '体重',
                  suffixText: 'kg',
                  border: OutlineInputBorder(),
                ),
                enabled: _isEditMode,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  LengthLimitingTextInputFormatter(5),
                ],
                onChanged: (_) => _checkForChanges(),
                validator: (value) {
                  if (value == null || value.isEmpty) return '请输入体重';
                  final weight = double.tryParse(value);
                  if (weight == null || weight <= 0) return '请输入有效体重';
                  if (weight < 20 || weight > 200) return '体重范围应在20-200kg';
                  return null;
                },
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

  Widget _buildHealthGoalSection(BuildContext context) {
    return Column(
      children: [
        // 健康目标
        _buildDropdownField(
          context,
          label: '健康目标',
          value: _healthGoal.isEmpty ? null : _healthGoal,
          items: NutritionConstants.healthGoalOptions.entries
              .map((e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value),
                  ))
              .toList(),
          onChanged: _isEditMode ? (value) {
            setState(() {
              _healthGoal = value?.toString() ?? '';
              // 根据健康目标自动设置建议热量
              _updateSuggestedCalories();
              _checkForChanges();
            });
          } : null,
          validator: (value) => value == null || value.isEmpty ? '请选择健康目标' : null,
        ),
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
    int filledFields = 0;
    const int totalFields = 12;

    // 必填字段
    if (_gender.isNotEmpty) filledFields++;
    if (_ageGroup.isNotEmpty) filledFields++;
    if (_heightController.text.isNotEmpty) filledFields++;
    if (_weightController.text.isNotEmpty) filledFields++;
    if (_healthGoal.isNotEmpty) filledFields++;
    if (_targetCaloriesController.text.isNotEmpty) filledFields++;
    if (_dietaryPreferences.isNotEmpty) filledFields++;

    // 可选字段
    if (_medicalConditions.isNotEmpty) filledFields++;
    if (_exerciseFrequency != null && _exerciseFrequency!.isNotEmpty) filledFields++;
    if (_nutritionPreferences.isNotEmpty) filledFields++;
    if (_specialStatus.isNotEmpty) filledFields++;
    if (_forbiddenIngredients.isNotEmpty || _allergies.isNotEmpty) filledFields++;

    return ((filledFields / totalFields) * 100).round();
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
    
    switch (_healthGoal) {
      case 'loseWeight':
        targetCalories *= 0.85; // 减少15%
        break;
      case 'gainMuscle':
        targetCalories *= 1.15; // 增加15%
        break;
      case 'maintainWeight':
      default:
        // 保持不变
        break;
    }

    _targetCaloriesController.text = targetCalories.round().toString();
  }

  String? _getSuggestedCaloriesText() {
    if (_gender.isEmpty || _ageGroup.isEmpty || 
        _heightController.text.isEmpty || _weightController.text.isEmpty ||
        _healthGoal.isEmpty) {
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

    if (_dietaryPreferences.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请至少选择一个饮食偏好'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final profile = NutritionProfileV2(
        id: _originalProfile?.id,
        userId: UserId('user1'), // TODO: 从用户状态获取
        gender: _gender,
        ageGroup: _ageGroup,
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        healthGoal: _healthGoal,
        targetCalories: double.parse(_targetCaloriesController.text),
        dietaryPreferences: _dietaryPreferences.toList(),
        medicalConditions: _medicalConditions.toList(),
        exerciseFrequency: _exerciseFrequency,
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
        context.router.pop(true);
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
        _healthGoal != _originalProfile!.healthGoal ||
        _targetCaloriesController.text != _originalProfile!.targetCalories.toStringAsFixed(0) ||
        !_setEquals(_dietaryPreferences, _originalProfile!.dietaryPreferences.toSet()) ||
        !_setEquals(_medicalConditions, _originalProfile!.medicalConditions.toSet()) ||
        _exerciseFrequency != _originalProfile!.exerciseFrequency ||
        !_setEquals(_nutritionPreferences, _originalProfile!.nutritionPreferences.toSet()) ||
        !_setEquals(_specialStatus, _originalProfile!.specialStatus.toSet()) ||
        !_setEquals(_forbiddenIngredients, _originalProfile!.forbiddenIngredients.toSet()) ||
        !_setEquals(_allergies, _originalProfile!.allergies.toSet());

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
}