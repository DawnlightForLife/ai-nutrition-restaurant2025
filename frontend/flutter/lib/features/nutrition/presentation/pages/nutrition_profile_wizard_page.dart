import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../domain/constants/nutrition_constants.dart';
import '../../../user/domain/value_objects/user_id.dart';
import '../widgets/profile_template_selector.dart';
import '../widgets/activity_level_detail_selector.dart';
import '../widgets/dynamic_health_goals_form.dart';
import '../widgets/conflict_detection_widget.dart';
import '../../data/models/nutrition_template_model.dart';
import '../../data/datasources/local/draft_storage_service.dart';
import '../providers/nutrition_profile_list_provider.dart';

class NutritionProfileWizardPage extends ConsumerStatefulWidget {
  const NutritionProfileWizardPage({super.key});

  @override
  ConsumerState<NutritionProfileWizardPage> createState() =>
      _NutritionProfileWizardPageState();
}

class _NutritionProfileWizardPageState
    extends ConsumerState<NutritionProfileWizardPage> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  int _currentStep = 0;
  final int _totalSteps = 6;
  
  // 档案数据
  String _profileName = '';
  String _gender = '';
  String _ageGroup = '';
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _healthGoal = '';
  final _targetCaloriesController = TextEditingController();
  final Set<String> _dietaryPreferences = {};
  final Set<String> _medicalConditions = {};
  String? _exerciseFrequency;
  final Set<String> _nutritionPreferences = {};
  final Set<String> _specialStatus = {};
  final Set<String> _forbiddenIngredients = {};
  final Set<String> _allergies = {};
  Map<String, dynamic> _activityDetails = {};
  Map<String, dynamic> _healthGoalDetails = {};
  
  bool _isLoading = false;
  Map<String, dynamic> _draftData = {};
  DraftStorageService? _draftService;
  String? _currentDraftId;

  @override
  void initState() {
    super.initState();
    _initializeDraftService();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetCaloriesController.dispose();
    super.dispose();
  }

  Future<void> _initializeDraftService() async {
    final prefs = await SharedPreferences.getInstance();
    _draftService = DraftStorageService(prefs);
    await _loadDraft();
  }

  Future<void> _loadDraft() async {
    if (_draftService == null) return;
    
    // 检查是否有可用的草稿
    final drafts = await _draftService!.getAllDrafts();
    if (drafts.isNotEmpty && mounted) {
      // 询问用户是否要恢复草稿
      final shouldRestore = await _showRestoreDraftDialog(drafts.first);
      if (shouldRestore) {
        _restoreDraftData(drafts.first);
      }
    }
  }

  Future<void> _saveDraft() async {
    if (_draftService == null) return;
    
    _draftData = {
      'profileName': _profileName,
      'gender': _gender,
      'ageGroup': _ageGroup,
      'height': _heightController.text,
      'weight': _weightController.text,
      'healthGoal': _healthGoal,
      'targetCalories': _targetCaloriesController.text,
      'dietaryPreferences': _dietaryPreferences.toList(),
      'medicalConditions': _medicalConditions.toList(),
      'exerciseFrequency': _exerciseFrequency,
      'nutritionPreferences': _nutritionPreferences.toList(),
      'specialStatus': _specialStatus.toList(),
      'forbiddenIngredients': _forbiddenIngredients.toList(),
      'allergies': _allergies.toList(),
      'activityDetails': _activityDetails,
      'healthGoalDetails': _healthGoalDetails,
      'currentStep': _currentStep,
    };
    
    try {
      _currentDraftId = await _draftService!.saveDraft(
        draftId: _currentDraftId,
        data: _draftData,
        profileName: _profileName.isEmpty ? '新建档案' : _profileName,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存草稿失败：$e')),
        );
      }
    }
  }

  Future<bool> _showRestoreDraftDialog(DraftInfo draft) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('发现未完成的档案'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('档案名称：${draft.profileName}'),
            Text('完成度：${(draft.completionPercentage * 100).toInt()}%'),
            Text('最后修改：${_formatDate(draft.updatedAt)}'),
            const SizedBox(height: 8),
            Text(draft.summary),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('重新开始'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('继续编辑'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _restoreDraftData(DraftInfo draft) {
    setState(() {
      _currentDraftId = draft.id;
      final data = draft.data;
      
      _profileName = data['profileName'] ?? '';
      _gender = data['gender'] ?? '';
      _ageGroup = data['ageGroup'] ?? '';
      _heightController.text = data['height'] ?? '';
      _weightController.text = data['weight'] ?? '';
      _healthGoal = data['healthGoal'] ?? '';
      _targetCaloriesController.text = data['targetCalories'] ?? '';
      
      _dietaryPreferences.clear();
      if (data['dietaryPreferences'] is List) {
        _dietaryPreferences.addAll((data['dietaryPreferences'] as List).cast<String>());
      }
      
      _medicalConditions.clear();
      if (data['medicalConditions'] is List) {
        _medicalConditions.addAll((data['medicalConditions'] as List).cast<String>());
      }
      
      _exerciseFrequency = data['exerciseFrequency'];
      
      _nutritionPreferences.clear();
      if (data['nutritionPreferences'] is List) {
        _nutritionPreferences.addAll((data['nutritionPreferences'] as List).cast<String>());
      }
      
      _specialStatus.clear();
      if (data['specialStatus'] is List) {
        _specialStatus.addAll((data['specialStatus'] as List).cast<String>());
      }
      
      _forbiddenIngredients.clear();
      if (data['forbiddenIngredients'] is List) {
        _forbiddenIngredients.addAll((data['forbiddenIngredients'] as List).cast<String>());
      }
      
      _allergies.clear();
      if (data['allergies'] is List) {
        _allergies.addAll((data['allergies'] as List).cast<String>());
      }
      
      if (data['activityDetails'] is Map) {
        _activityDetails = Map<String, dynamic>.from(data['activityDetails']);
      }
      
      if (data['healthGoalDetails'] is Map) {
        _healthGoalDetails = Map<String, dynamic>.from(data['healthGoalDetails']);
      }
      
      // 恢复到之前的步骤
      _currentStep = data['currentStep'] ?? 0;
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          '创建营养档案',
          style: TextStyle(
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
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: _saveDraft,
              icon: const Icon(
                Icons.save_outlined,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                '保存草稿',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 进度指示器
          _buildProgressIndicator(theme),
          
          // 步骤内容
          Expanded(
            child: Form(
              key: _formKey,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1Template(),
                  _buildStep2BasicInfo(),
                  _buildStep3HealthGoals(),
                  _buildStep4DietaryPreferences(),
                  _buildStep5HealthStatus(),
                  _buildStep6Review(),
                ],
              ),
            ),
          ),
          
          // 导航按钮
          _buildNavigationBar(theme),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 步骤标题
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '第 ${_currentStep + 1} 步 / $_totalSteps 步',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${((_currentStep + 1) / _totalSteps * 100).toInt()}% 完成',
                style: const TextStyle(
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 进度条
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_currentStep + 1) / _totalSteps,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // 步骤指示器
          Row(
            children: List.generate(_totalSteps, (index) {
              final isCompleted = index < _currentStep;
              final isCurrent = index == _currentStep;
              
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: index < _totalSteps - 1 ? 8 : 0,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: isCompleted || isCurrent
                              ? const LinearGradient(
                                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                )
                              : null,
                          color: isCompleted || isCurrent
                              ? null
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isCompleted || isCurrent
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF6366F1).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: Colors.white,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isCurrent
                                        ? Colors.white
                                        : const Color(0xFF94A3B8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      if (index < _totalSteps - 1)
                        Expanded(
                          child: Container(
                            height: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? const Color(0xFF6366F1)
                                  : const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(1.5),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            _getStepTitle(_currentStep),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0: return '选择模板';
      case 1: return '基本信息';
      case 2: return '健康目标';
      case 3: return '饮食偏好';
      case 4: return '健康状况';
      case 5: return '确认信息';
      default: return '';
    }
  }

  Widget _buildStep1Template() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '为了更好地为您服务，请选择一个营养档案模板',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Text(
            '您也可以跳过此步骤，从零开始创建',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ProfileTemplateSelector(
              onTemplateSelected: _applyTemplate,
              isEnabled: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2BasicInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: _profileName,
            decoration: const InputDecoration(
              labelText: '档案名称',
              hintText: '例如：日常饮食、减脂计划等',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => _profileName = value,
            validator: (value) {
              if (value == null || value.isEmpty) return '请输入档案名称';
              if (value.length > 20) return '档案名称不能超过20个字符';
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            value: _gender.isEmpty ? null : _gender,
            decoration: const InputDecoration(
              labelText: '性别',
              border: OutlineInputBorder(),
            ),
            items: NutritionConstants.genderOptions.entries
                .map((e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _gender = value ?? ''),
            validator: (value) => value == null || value.isEmpty ? '请选择性别' : null,
          ),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            value: _ageGroup.isEmpty ? null : _ageGroup,
            decoration: const InputDecoration(
              labelText: '年龄段',
              border: OutlineInputBorder(),
            ),
            items: NutritionConstants.ageGroupOptions.entries
                .map((e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _ageGroup = value ?? ''),
            validator: (value) => value == null || value.isEmpty ? '请选择年龄段' : null,
          ),
          const SizedBox(height: 16),
          
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
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return '请输入身高';
                    final height = double.tryParse(value);
                    if (height == null || height <= 0) return '请输入有效身高';
                    if (height < 100 || height > 250) return '身高范围应在100-250cm';
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
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return '请输入体重';
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0) return '请输入有效体重';
                    if (weight < 30 || weight > 300) return '体重范围应在30-300kg';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep3HealthGoals() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _healthGoal.isEmpty ? null : _healthGoal,
            decoration: const InputDecoration(
              labelText: '健康目标',
              border: OutlineInputBorder(),
            ),
            items: NutritionConstants.healthGoalOptions.entries
                .map((e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _healthGoal = value ?? '';
                _healthGoalDetails = {};
                _updateSuggestedCalories();
              });
            },
            validator: (value) => value == null || value.isEmpty ? '请选择健康目标' : null,
          ),
          
          if (_healthGoal.isNotEmpty) ...[
            const SizedBox(height: 16),
            DynamicHealthGoalsForm(
              healthGoal: _healthGoal,
              initialDetails: _healthGoalDetails,
              onDetailsChanged: (details) {
                setState(() => _healthGoalDetails = details);
              },
            ),
          ],
          
          const SizedBox(height: 16),
          TextFormField(
            controller: _targetCaloriesController,
            decoration: InputDecoration(
              labelText: '目标热量',
              suffixText: 'kcal/天',
              border: const OutlineInputBorder(),
              helperText: _getSuggestedCaloriesText(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return '请输入目标热量';
              final calories = int.tryParse(value);
              if (calories == null || calories <= 0) return '请输入有效热量值';
              if (calories < 800 || calories > 5000) return '热量范围应在800-5000kcal';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep4DietaryPreferences() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '请选择您的饮食偏好（可多选）',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: NutritionConstants.dietaryPreferenceOptions.entries
                .map((entry) => FilterChip(
                      label: Text(entry.value),
                      selected: _dietaryPreferences.contains(entry.key),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _dietaryPreferences.add(entry.key);
                          } else {
                            _dietaryPreferences.remove(entry.key);
                          }
                        });
                      },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep5HealthStatus() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '健康状况（可选）',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          
          // 疾病史
          Text('疾病史', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: NutritionConstants.medicalConditionOptions.entries
                .map((entry) => FilterChip(
                      label: Text(entry.value),
                      selected: _medicalConditions.contains(entry.key),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _medicalConditions.add(entry.key);
                          } else {
                            _medicalConditions.remove(entry.key);
                          }
                        });
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          
          // 运动频率
          DropdownButtonFormField<String>(
            value: _exerciseFrequency,
            decoration: const InputDecoration(
              labelText: '运动频率',
              border: OutlineInputBorder(),
            ),
            items: NutritionConstants.exerciseFrequencyOptions.entries
                .map((e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _exerciseFrequency = value),
          ),
          
          // 活动水平详情
          if (_exerciseFrequency != null && _exerciseFrequency!.isNotEmpty) ...[
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
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStep6Review() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '请确认您的营养档案信息',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          
          // 冲突检测
          ConflictDetectionWidget(
            profileData: {
              'gender': _gender,
              'ageGroup': _ageGroup,
              'height': _heightController.text.isNotEmpty ? double.tryParse(_heightController.text) : null,
              'weight': _weightController.text.isNotEmpty ? double.tryParse(_weightController.text) : null,
              'healthGoal': _healthGoal,
              'targetCalories': _targetCaloriesController.text.isNotEmpty ? double.tryParse(_targetCaloriesController.text) : null,
              'dietaryPreferences': _dietaryPreferences.toList(),
              'medicalConditions': _medicalConditions.toList(),
              'exerciseFrequency': _exerciseFrequency,
              'activityLevelDetail': _activityDetails['activityLevelDetail'],
              'healthGoalDetails': _healthGoalDetails,
            },
            enabled: true,
          ),
          const SizedBox(height: 16),
          
          _buildReviewCard('基本信息', [
            '档案名称：$_profileName',
            '性别：${NutritionConstants.genderOptions[_gender] ?? ''}',
            '年龄段：${NutritionConstants.ageGroupOptions[_ageGroup] ?? ''}',
            '身高：${_heightController.text}cm',
            '体重：${_weightController.text}kg',
          ]),
          const SizedBox(height: 12),
          
          _buildReviewCard('健康目标', [
            '目标：${NutritionConstants.healthGoalOptions[_healthGoal] ?? ''}',
            '目标热量：${_targetCaloriesController.text}kcal/天',
          ]),
          const SizedBox(height: 12),
          
          if (_dietaryPreferences.isNotEmpty)
            _buildReviewCard('饮食偏好', 
              _dietaryPreferences.map((key) => 
                NutritionConstants.dietaryPreferenceOptions[key] ?? key
              ).toList()
            ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String title, List<String> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(item),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF6366F1),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: OutlinedButton(
                    onPressed: _previousStep,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: const Text(
                      '上一步',
                      style: TextStyle(
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0 && _currentStep < _totalSteps - 1)
              const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentStep == _totalSteps - 1 ? '创建档案' : '下一步',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _currentStep == _totalSteps - 1
                                  ? Icons.check_circle_outline
                                  : Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _saveDraft();
    }
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < _totalSteps - 1) {
        setState(() => _currentStep++);
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _saveDraft();
      } else {
        _createProfile();
      }
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // 模板选择步骤（可跳过）
        return true;
      case 1: // 基本信息
        return _formKey.currentState?.validate() ?? false;
      case 2: // 健康目标
        return _healthGoal.isNotEmpty && _targetCaloriesController.text.isNotEmpty;
      case 3: // 饮食偏好
        return _dietaryPreferences.isNotEmpty;
      case 4: // 健康状况（可选）
        return true;
      case 5: // 确认信息
        return true;
      default:
        return false;
    }
  }

  void _applyTemplate(NutritionTemplateModel template) {
    setState(() {
      // 简化的模板应用逻辑
      _profileName = template.name;
      
      // 根据模板类型设置基本的预设值
      switch (template.key) {
        case 'weightLoss':
          _gender = 'female';
          _ageGroup = '26to35';
          _heightController.text = '165';
          _weightController.text = '70';
          _healthGoal = 'loseWeight';
          _targetCaloriesController.text = '1500';
          _dietaryPreferences.clear();
          _dietaryPreferences.add('lowCarb');
          _exerciseFrequency = 'daily';
          break;
          
        case 'fitness':
          _gender = 'male';
          _ageGroup = '18to25';
          _heightController.text = '175';
          _weightController.text = '70';
          _healthGoal = 'gainMuscle';
          _targetCaloriesController.text = '2800';
          _dietaryPreferences.clear();
          _dietaryPreferences.add('highProtein');
          _exerciseFrequency = 'daily';
          break;
          
        case 'diabetic':
          _gender = 'male';
          _ageGroup = '46to55';
          _heightController.text = '170';
          _weightController.text = '75';
          _healthGoal = 'manageDisease';
          _targetCaloriesController.text = '1800';
          _dietaryPreferences.clear();
          _dietaryPreferences.addAll(['lowSugar', 'lowCarb']);
          _medicalConditions.clear();
          _medicalConditions.add('diabetes');
          _exerciseFrequency = 'moderate';
          break;
          
        default:
          // 通用模板设置
          _profileName = template.name;
          break;
      }
    });
  }

  String _mapNutritionGoalToHealthGoal(String nutritionGoal) {
    switch (nutritionGoal.toLowerCase()) {
      case 'weight_loss':
      case 'lose_weight':
        return 'loseWeight';
      case 'muscle_gain':
      case 'gain_muscle':
        return 'gainMuscle';
      case 'maintain_weight':
        return 'maintainWeight';
      case 'improve_health':
        return 'improveHealth';
      default:
        return 'maintainWeight';
    }
  }

  void _updateSuggestedCalories() {
    if (_gender.isEmpty || _ageGroup.isEmpty || 
        _heightController.text.isEmpty || _weightController.text.isEmpty) {
      return;
    }
    
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    if (height == null || weight == null) return;
    
    // 简化的BMR计算
    double bmr;
    if (_gender == 'male') {
      bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * 25); // 假设25岁
    } else {
      bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * 25);
    }
    
    // 根据健康目标调整
    double targetCalories = bmr * 1.5; // 假设中等活动水平
    switch (_healthGoal) {
      case 'loseWeight':
        targetCalories *= 0.8;
        break;
      case 'gainMuscle':
        targetCalories *= 1.2;
        break;
    }
    
    _targetCaloriesController.text = targetCalories.round().toString();
  }

  String _getSuggestedCaloriesText() {
    if (_gender.isEmpty || _ageGroup.isEmpty || 
        _heightController.text.isEmpty || _weightController.text.isEmpty) {
      return '填写基本信息后将显示建议热量';
    }
    return '建议热量已自动计算，您可以调整';
  }

  Future<void> _createProfile() async {
    setState(() => _isLoading = true);
    
    try {
      final profile = NutritionProfileV2(
        userId: UserId('user1'), // TODO: 从用户状态获取
        profileName: _profileName,
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
        activityDetails: _activityDetails,
        healthGoalDetails: _healthGoalDetails,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await ref.read(nutritionProfileListProvider.notifier).createProfile(profile);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('营养档案创建成功！')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('创建失败：$e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}