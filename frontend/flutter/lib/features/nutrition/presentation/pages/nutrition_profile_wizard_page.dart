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
import '../widgets/wheel_number_picker.dart';
import '../widgets/custom_option_selector.dart';
import '../../data/models/nutrition_template_model.dart';
import '../../data/datasources/local/draft_storage_service.dart';
import '../providers/nutrition_profile_list_provider.dart';
import '../providers/ai_recommendation_provider.dart';
import '../providers/nutrition_progress_provider.dart';
import '../../domain/entities/ai_recommendation.dart';
import '../../../user/presentation/providers/user_provider.dart';

class NutritionProfileWizardPage extends ConsumerStatefulWidget {
  final NutritionProfileV2? cloneFromProfile;
  
  const NutritionProfileWizardPage({
    super.key,
    this.cloneFromProfile,
  });

  @override
  ConsumerState<NutritionProfileWizardPage> createState() =>
      _NutritionProfileWizardPageState();
}

class _NutritionProfileWizardPageState
    extends ConsumerState<NutritionProfileWizardPage> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  int _currentStep = 0;
  final int _totalSteps = 7;  // 增加AI推荐步骤
  
  // 档案数据
  String _profileName = '';
  String _gender = '';
  String _ageGroup = '';
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final Set<String> _healthGoals = {};  // 改为支持多选
  final Map<String, Map<String, dynamic>> _healthGoalDetailsMap = {};  // 每个目标的详情
  final _targetCaloriesController = TextEditingController();
  final Set<String> _dietaryPreferences = {};
  final Set<String> _cuisinePreferences = {};  // 菜系偏好
  final Map<String, int> _tastePreferences = {};  // 口味偏好
  final Set<String> _specialDietaryRequirements = {};  // 特殊饮食要求
  final Set<String> _medicalConditions = {};
  String? _exerciseFrequency;
  final Set<String> _nutritionPreferences = {};
  final Set<String> _specialStatus = {};
  final Set<String> _forbiddenIngredients = {};
  final Set<String> _allergies = {};
  Map<String, dynamic> _activityDetails = {};
  
  // AI推荐相关状态
  AIRecommendation? _aiRecommendation;
  bool _aiRecommendationAccepted = false;
  
  bool _isLoading = false;
  Map<String, dynamic> _draftData = {};
  DraftStorageService? _draftService;
  String? _currentDraftId;

  @override
  void initState() {
    super.initState();
    _initializeDraftService();
    
    // 如果是克隆模式，初始化数据
    if (widget.cloneFromProfile != null) {
      _initializeFromClonedProfile();
    }
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
    // 不再自动加载草稿，只有在用户明确选择时才加载
    // await _loadDraft();
  }

  void _initializeFromClonedProfile() {
    final clonedProfile = widget.cloneFromProfile!;
    
    // 复制基本信息
    _profileName = '${clonedProfile.profileName} 副本';
    _gender = clonedProfile.gender;
    _ageGroup = clonedProfile.ageGroup ?? '';
    _heightController.text = clonedProfile.height.toString();
    _weightController.text = clonedProfile.weight.toString();
    
    // 复制健康目标
    if (clonedProfile.healthGoalDetails != null) {
      final goalDetails = clonedProfile.healthGoalDetails!;
      if (goalDetails['goals'] != null) {
        _healthGoals.addAll(List<String>.from(goalDetails['goals']));
      }
      if (goalDetails['goalsDetails'] != null) {
        _healthGoalDetailsMap.addAll(
          Map<String, Map<String, dynamic>>.from(goalDetails['goalsDetails'])
        );
      }
      if (goalDetails['cuisinePreferences'] != null) {
        _cuisinePreferences.addAll(List<String>.from(goalDetails['cuisinePreferences']));
      }
      if (goalDetails['tastePreferences'] != null) {
        _tastePreferences.addAll(
          Map<String, int>.from(goalDetails['tastePreferences'])
        );
      }
      if (goalDetails['specialDietaryRequirements'] != null) {
        _specialDietaryRequirements.addAll(
          List<String>.from(goalDetails['specialDietaryRequirements'])
        );
      }
    }
    
    // 复制其他信息
    _targetCaloriesController.text = clonedProfile.targetCalories.toString();
    _dietaryPreferences.addAll(clonedProfile.dietaryPreferences);
    _medicalConditions.addAll(clonedProfile.medicalConditions);
    _exerciseFrequency = clonedProfile.exerciseFrequency;
    _nutritionPreferences.addAll(clonedProfile.nutritionPreferences);
    _specialStatus.addAll(clonedProfile.specialStatus);
    _forbiddenIngredients.addAll(clonedProfile.forbiddenIngredients);
    _allergies.addAll(clonedProfile.allergies);
    _activityDetails = clonedProfile.activityDetails != null 
        ? Map<String, dynamic>.from(clonedProfile.activityDetails!) 
        : {};
    
    print('🔄 克隆档案初始化完成: ${clonedProfile.profileName} -> $_profileName');
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
      'healthGoals': _healthGoals.toList(),  // 保存多选的健康目标
      'healthGoalDetailsMap': _healthGoalDetailsMap,  // 保存每个目标的详情
      'targetCalories': _targetCaloriesController.text,
      'dietaryPreferences': _dietaryPreferences.toList(),
      'cuisinePreferences': _cuisinePreferences.toList(),
      'tastePreferences': _tastePreferences,
      'specialDietaryRequirements': _specialDietaryRequirements.toList(),
      'medicalConditions': _medicalConditions.toList(),
      'exerciseFrequency': _exerciseFrequency,
      'nutritionPreferences': _nutritionPreferences.toList(),
      'specialStatus': _specialStatus.toList(),
      'forbiddenIngredients': _forbiddenIngredients.toList(),
      'allergies': _allergies.toList(),
      'activityDetails': _activityDetails,
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
      
      _profileName = (data['profileName'] as String?) ?? '';
      _gender = (data['gender'] as String?) ?? '';
      _ageGroup = (data['ageGroup'] as String?) ?? '';
      _heightController.text = (data['height'] as String?) ?? '';
      _weightController.text = (data['weight'] as String?) ?? '';
      // 恢复健康目标（支持多选）
      _healthGoals.clear();
      if (data['healthGoals'] is List) {
        _healthGoals.addAll((data['healthGoals'] as List).cast<String>());
      } else if (data['healthGoal'] is String && (data['healthGoal'] as String).isNotEmpty) {
        // 兼容旧版本单选数据
        _healthGoals.add(data['healthGoal'] as String);
      }
      
      // 恢复健康目标详情
      _healthGoalDetailsMap.clear();
      if (data['healthGoalDetailsMap'] is Map) {
        (data['healthGoalDetailsMap'] as Map).forEach((key, value) {
          if (value is Map) {
            _healthGoalDetailsMap[key.toString()] = Map<String, dynamic>.from(value as Map);
          }
        });
      } else if (data['healthGoalDetails'] is Map && _healthGoals.isNotEmpty) {
        // 兼容旧版本数据
        _healthGoalDetailsMap[_healthGoals.first] = Map<String, dynamic>.from(data['healthGoalDetails'] as Map);
      }
      
      _targetCaloriesController.text = (data['targetCalories'] as String?) ?? '';
      
      _dietaryPreferences.clear();
      if (data['dietaryPreferences'] is List) {
        _dietaryPreferences.addAll((data['dietaryPreferences'] as List).cast<String>());
      }
      
      _cuisinePreferences.clear();
      if (data['cuisinePreferences'] is List) {
        _cuisinePreferences.addAll((data['cuisinePreferences'] as List).cast<String>());
      }
      
      _tastePreferences.clear();
      if (data['tastePreferences'] is Map) {
        (data['tastePreferences'] as Map).forEach((key, value) {
          if (value is int) {
            _tastePreferences[key.toString()] = value;
          }
        });
      }
      
      _specialDietaryRequirements.clear();
      if (data['specialDietaryRequirements'] is List) {
        _specialDietaryRequirements.addAll((data['specialDietaryRequirements'] as List).cast<String>());
      }
      
      _medicalConditions.clear();
      if (data['medicalConditions'] is List) {
        _medicalConditions.addAll((data['medicalConditions'] as List).cast<String>());
      }
      
      _exerciseFrequency = data['exerciseFrequency'] as String?;
      
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
        _activityDetails = Map<String, dynamic>.from(data['activityDetails'] as Map);
      }
      
      // 恢复到之前的步骤
      _currentStep = (data['currentStep'] as int?) ?? 0;
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

  /// 档案创建成功后清除草稿
  Future<void> _clearDraftAfterSuccess() async {
    try {
      if (_draftService != null) {
        // 清除当前草稿
        if (_currentDraftId != null) {
          await _draftService!.deleteDraft(_currentDraftId!);
          print('✅ 草稿已清除: $_currentDraftId');
          _currentDraftId = null;
        }
        
        // 清除所有相关草稿（防止重复草稿）
        final allDrafts = await _draftService!.getAllDrafts();
        for (final draft in allDrafts) {
          // 如果草稿名称相同或数据相似，也一并清除
          if (draft.profileName == _profileName || draft.id == _currentDraftId) {
            await _draftService!.deleteDraft(draft.id);
            print('✅ 相关草稿已清除: ${draft.id}');
          }
        }
        
        _draftData.clear();
      }
    } catch (e) {
      print('清除草稿失败: $e');
      // 不影响主流程，静默处理
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          widget.cloneFromProfile != null ? '克隆营养档案' : '创建营养档案',
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
                  _buildStep6AIRecommendation(),  // 新增AI推荐步骤
                  _buildStep7Review(),  // 重命名确认步骤
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
      case 5: return 'AI营养推荐';  // 新增步骤
      case 6: return '确认信息';
      default: return '';
    }
  }

  Widget _buildStep1Template() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 如果是克隆模式，显示克隆信息
          if (widget.cloneFromProfile != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.copy, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '正在克隆档案',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '来源：${widget.cloneFromProfile!.profileName}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          
          Text(
            widget.cloneFromProfile != null 
                ? '档案信息已从源档案复制，您可以选择模板进一步调整' 
                : '为了更好地为您服务，请选择一个营养档案模板',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Text(
            widget.cloneFromProfile != null
                ? '如果当前信息已满足需求，也可以跳过模板选择直接进入下一步'
                : '您也可以跳过此步骤，从零开始创建',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ProfileTemplateSelector(
            onTemplateSelected: _applyTemplate,
            isEnabled: true,
          ),
          const SizedBox(height: 80), // 底部留白，避免被导航栏遮挡
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
          
          HeightWeightPickers(
            initialHeight: _heightController.text.isNotEmpty 
                ? double.tryParse(_heightController.text) 
                : null,
            initialWeight: _weightController.text.isNotEmpty 
                ? double.tryParse(_weightController.text) 
                : null,
            onHeightChanged: (value) {
              _heightController.text = value?.toStringAsFixed(0) ?? '';
              _updateSuggestedCalories();
            },
            onWeightChanged: (value) {
              _weightController.text = value?.toStringAsFixed(1) ?? '';
              _updateSuggestedCalories();
            },
            heightValidator: (value) {
              if (value == null || value.isEmpty) return '请选择身高';
              final height = double.tryParse(value);
              if (height == null || height <= 0) return '请选择有效身高';
              if (height < 100 || height > 250) return '身高范围应在100-250cm';
              return null;
            },
            weightValidator: (value) {
              if (value == null || value.isEmpty) return '请选择体重';
              final weight = double.tryParse(value);
              if (weight == null || weight <= 0) return '请选择有效体重';
              if (weight < 30 || weight > 300) return '体重范围应在30-300kg';
              return null;
            },
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
          Text(
            '请选择您的健康目标（可多选）',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          
          // 健康目标多选
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: NutritionConstants.healthGoalOptions.entries
                .map((entry) => FilterChip(
                      label: Text(entry.value),
                      selected: _healthGoals.contains(entry.key),
                      onSelected: (selected) {
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
                        });
                      },
                    ))
                .toList(),
          ),
          
          // 为每个选中的健康目标显示详细配置
          if (_healthGoals.isNotEmpty) ...[
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
                    });
                  },
                ),
                const Divider(),
              ],
            )).toList(),
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
          // 饮食类型
          Text(
            '饮食类型',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: NutritionConstants.dietaryTypes.entries
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
          const SizedBox(height: 24),
          
          // 菜系偏好
          Text(
            '菜系偏好',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...NutritionConstants.majorCuisines.entries
                  .map((entry) => FilterChip(
                        label: Text(entry.value),
                        selected: _cuisinePreferences.contains(entry.key),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _cuisinePreferences.add(entry.key);
                            } else {
                              _cuisinePreferences.remove(entry.key);
                            }
                          });
                        },
                      )),
              ...NutritionConstants.regionalCuisines.entries
                  .take(4) // 只显示部分地方菜系
                  .map((entry) => FilterChip(
                        label: Text(entry.value),
                        selected: _cuisinePreferences.contains(entry.key),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _cuisinePreferences.add(entry.key);
                            } else {
                              _cuisinePreferences.remove(entry.key);
                            }
                          });
                        },
                      )),
            ],
          ),
          const SizedBox(height: 24),
          
          // 口味偏好
          Text(
            '口味偏好',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ...NutritionConstants.tasteIntensity.entries.map((tasteEntry) {
            final taste = tasteEntry.key;
            final levels = tasteEntry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTasteLabel(taste),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: levels.asMap().entries.map((entry) {
                    final index = entry.key;
                    final level = entry.value;
                    final key = '${taste}_$index';
                    return ChoiceChip(
                      label: Text(level),
                      selected: _tastePreferences[taste] == index,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _tastePreferences[taste] = index;
                          } else {
                            _tastePreferences.remove(taste);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
          
          // 宗教/民族饮食要求
          Text(
            '特殊饮食要求',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...NutritionConstants.religiousDietary.entries
                  .map((entry) => FilterChip(
                        label: Text(entry.value),
                        selected: _specialDietaryRequirements.contains(entry.key),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _specialDietaryRequirements.add(entry.key);
                            } else {
                              _specialDietaryRequirements.remove(entry.key);
                            }
                          });
                        },
                      )),
            ],
          ),
        ],
      ),
    );
  }
  
  String _getTasteLabel(String taste) {
    switch (taste) {
      case 'spicy':
        return '辣度偏好';
      case 'salty':
        return '咸度偏好';
      case 'sweet':
        return '甜度偏好';
      case 'sour':
        return '酸度偏好';
      case 'oily':
        return '油腻程度';
      default:
        return taste;
    }
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
          
          // 疾病史（支持自定义）
          CustomOptionSelector(
            title: '疾病史',
            predefinedOptions: NutritionConstants.medicalConditionOptions,
            selectedValues: _medicalConditions,
            onChanged: (values) {
              setState(() {
                _medicalConditions.clear();
                _medicalConditions.addAll(values);
              });
            },
            hintText: '输入其他疾病史',
          ),
          const SizedBox(height: 24),
          
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
          
          const SizedBox(height: 24),
          
          // 过敏原（支持自定义）
          CustomOptionSelector(
            title: '过敏原',
            predefinedOptions: NutritionConstants.allergyOptions,
            selectedValues: _allergies,
            onChanged: (values) {
              setState(() {
                _allergies.clear();
                _allergies.addAll(values);
              });
            },
            hintText: '输入其他过敏原',
          ),
          
          const SizedBox(height: 24),
          
          // 禁忌食材（支持自定义）
          CustomOptionSelector(
            title: '禁忌食材',
            predefinedOptions: NutritionConstants.forbiddenIngredientOptions,
            selectedValues: _forbiddenIngredients,
            onChanged: (values) {
              setState(() {
                _forbiddenIngredients.clear();
                _forbiddenIngredients.addAll(values);
              });
            },
            hintText: '输入其他禁忌食材',
          ),
          
          const SizedBox(height: 24),
          
          // 营养偏好（支持自定义）
          CustomOptionSelector(
            title: '营养偏好',
            predefinedOptions: NutritionConstants.nutritionPreferenceOptions,
            selectedValues: _nutritionPreferences,
            onChanged: (values) {
              setState(() {
                _nutritionPreferences.clear();
                _nutritionPreferences.addAll(values);
              });
            },
            hintText: '输入其他营养偏好',
          ),
          
          const SizedBox(height: 24),
          
          // 特殊状态（支持自定义）
          CustomOptionSelector(
            title: '特殊状态',
            predefinedOptions: NutritionConstants.specialStatusOptions,
            selectedValues: _specialStatus,
            onChanged: (values) {
              setState(() {
                _specialStatus.clear();
                _specialStatus.addAll(values);
              });
            },
            hintText: '输入其他特殊状态',
          ),
        ],
      ),
    );
  }

  Widget _buildStep6AIRecommendation() {
    final tempProfileId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    
    return Consumer(
      builder: (context, ref, child) {
        final aiState = ref.watch(aiRecommendationProvider(tempProfileId));
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 说明文字
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.psychology, color: Colors.blue[700], size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI智能营养推荐',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '基于您的信息，AI将为您生成个性化的营养目标和建议',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // AI推荐内容
              if (aiState.isLoading)
                _buildAIAnalyzingWidget()
              else if (aiState.hasError)
                _buildAIErrorWidget(aiState.errorMessage!, tempProfileId, ref)
              else if (aiState.recommendation != null)
                _buildAIRecommendationResults(aiState.recommendation!, ref)
              else
                _buildAIStartWidget(tempProfileId, ref),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAIAnalyzingWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // AI分析动画
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 3),
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 4,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    const Icon(
                      Icons.psychology,
                      size: 32,
                      color: Colors.blue,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'AI正在分析您的营养需求',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              _getAnalysisStatusText(),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIErrorWidget(String errorMessage, String profileId, WidgetRef ref) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'AI推荐生成失败',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: TextStyle(fontSize: 14, color: Colors.red[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _aiRecommendationAccepted = true;
                      });
                    },
                    child: const Text('跳过AI推荐'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _triggerAIRecommendation(profileId, ref),
                    child: const Text('重试'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIStartWidget(String profileId, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.auto_awesome, size: 64, color: Colors.orange[400]),
            const SizedBox(height: 16),
            const Text(
              '准备获取AI营养推荐',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '点击下方按钮，让AI为您分析最适合的营养方案',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _triggerAIRecommendation(profileId, ref),
                icon: const Icon(Icons.psychology),
                label: const Text('获取AI推荐'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                setState(() {
                  _aiRecommendationAccepted = true;
                });
              },
              child: const Text('跳过此步骤'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIRecommendationResults(AIRecommendation recommendation, WidgetRef ref) {
    return Column(
      children: [
        // 推荐结果标题
        Card(
          color: Colors.green[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI推荐方案已生成',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '推荐置信度: ${(recommendation.confidence * 100).toInt()}%',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _triggerAIRecommendation('temp_${DateTime.now().millisecondsSinceEpoch}', ref),
                  icon: const Icon(Icons.refresh),
                  tooltip: '重新生成推荐',
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 营养目标卡片
        _buildNutritionTargetCard('每日热量', '${recommendation.nutritionTargets.dailyCalories.toInt()} kcal', 
            '基于您的身体指标和健康目标计算'),
        
        _buildNutritionTargetCard('饮水目标', '${recommendation.nutritionTargets.hydrationGoal.toInt()} ml', 
            '保持充足的水分摄入'),
        
        _buildNutritionTargetCard('用餐频次', '${recommendation.nutritionTargets.mealFrequency} 次/天', 
            '合理安排用餐时间'),
        
        // 宏量营养素比例
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('宏量营养素比例', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                _buildMacroRatioItem('蛋白质', recommendation.nutritionTargets.macroRatio.protein, Colors.red),
                _buildMacroRatioItem('脂肪', recommendation.nutritionTargets.macroRatio.fat, Colors.orange),
                _buildMacroRatioItem('碳水化合物', recommendation.nutritionTargets.macroRatio.carbs, Colors.blue),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // 接受推荐按钮
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _aiRecommendation = recommendation;
                _aiRecommendationAccepted = true;
              });
              
              // 提交反馈
              ref.read(aiRecommendationProvider(recommendation.profileId).notifier)
                  .submitFeedback(rating: 5, isAccepted: true);
                  
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('AI推荐已接受'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('接受此推荐'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionTargetCard(String title, String value, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroRatioItem(String name, double ratio, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(name)),
          Text('${(ratio * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _triggerAIRecommendation(String profileId, WidgetRef ref) {
    final profile = _buildCurrentProfile();
    ref.read(aiRecommendationProvider(profileId).notifier).generateRecommendation(profile);
  }

  String _getAnalysisStatusText() {
    final messages = [
      '正在评估您的基础代谢率...',
      '计算营养素需求量...',
      '分析饮食偏好匹配度...',
      '生成个性化推荐方案...',
    ];
    
    return messages[DateTime.now().millisecond % messages.length];
  }

  NutritionProfileV2 _buildCurrentProfile() {
    return NutritionProfileV2(
      userId: UserId('current_user'),
      profileName: _profileName.isNotEmpty ? _profileName : '临时档案',
      gender: _gender,
      ageGroup: _ageGroup,
      height: double.tryParse(_heightController.text) ?? 0,
      weight: double.tryParse(_weightController.text) ?? 0,
      healthGoal: _healthGoals.isNotEmpty ? _healthGoals.first : '',
      targetCalories: double.tryParse(_targetCaloriesController.text) ?? 0,
      dietaryPreferences: _dietaryPreferences.toList(),
      nutritionPreferences: _nutritionPreferences.toList(),
      medicalConditions: _medicalConditions.toList(),
      specialStatus: _specialStatus.toList(),
      forbiddenIngredients: _forbiddenIngredients.toList(),
      allergies: _allergies.toList(),
      exerciseFrequency: _exerciseFrequency,
      activityDetails: _activityDetails,
      healthGoalDetails: _healthGoalDetailsMap,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Widget _buildStep7Review() {
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
              'healthGoals': _healthGoals.toList(),  // 传递多个健康目标
              'targetCalories': _targetCaloriesController.text.isNotEmpty ? double.tryParse(_targetCaloriesController.text) : null,
              'dietaryPreferences': _dietaryPreferences.toList(),
              'medicalConditions': _medicalConditions.toList(),
              'exerciseFrequency': _exerciseFrequency,
              'activityLevelDetail': _activityDetails['activityLevelDetail'],
              'healthGoalDetailsMap': _healthGoalDetailsMap,  // 传递所有目标的详情
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
            if (_healthGoals.isNotEmpty)
              '目标：${_healthGoals.map((g) => NutritionConstants.healthGoalOptions[g] ?? g).join('、')}',
            '目标热量：${_targetCaloriesController.text}kcal/天',
          ]),
          const SizedBox(height: 12),
          
          if (_dietaryPreferences.isNotEmpty)
            _buildReviewCard('饮食偏好', 
              _dietaryPreferences.map((key) => 
                NutritionConstants.dietaryPreferenceOptions[key] ?? key
              ).toList()
            ),
          
          const SizedBox(height: 12),
          
          // 健康状况信息
          if (_medicalConditions.isNotEmpty || _allergies.isNotEmpty || 
              _forbiddenIngredients.isNotEmpty || _nutritionPreferences.isNotEmpty || 
              _specialStatus.isNotEmpty || _exerciseFrequency?.isNotEmpty == true) ...[
            _buildReviewCard('健康状况', [
              if (_medicalConditions.isNotEmpty)
                '疾病史：${_medicalConditions.map((key) => 
                  NutritionConstants.medicalConditionOptions[key] ?? key
                ).join('、')}',
              if (_exerciseFrequency?.isNotEmpty == true)
                '运动频率：${NutritionConstants.exerciseFrequencyOptions[_exerciseFrequency] ?? _exerciseFrequency}',
              if (_allergies.isNotEmpty)
                '过敏原：${_allergies.map((key) => 
                  NutritionConstants.allergyOptions[key] ?? key
                ).join('、')}',
              if (_forbiddenIngredients.isNotEmpty)
                '禁忌食材：${_forbiddenIngredients.map((key) => 
                  NutritionConstants.forbiddenIngredientOptions[key] ?? key
                ).join('、')}',
              if (_nutritionPreferences.isNotEmpty)
                '营养偏好：${_nutritionPreferences.map((key) => 
                  NutritionConstants.nutritionPreferenceOptions[key] ?? key
                ).join('、')}',
              if (_specialStatus.isNotEmpty)
                '特殊状态：${_specialStatus.map((key) => 
                  NutritionConstants.specialStatusOptions[key] ?? key
                ).join('、')}',
            ]),
          ],
          
          // AI推荐信息
          if (_aiRecommendation != null) ...[
            const SizedBox(height: 12),
            _buildReviewCard('AI营养推荐', [
              '每日热量：${_aiRecommendation!.nutritionTargets.dailyCalories.toInt()} kcal',
              '饮水目标：${_aiRecommendation!.nutritionTargets.hydrationGoal.toInt()} ml',
              '用餐频次：${_aiRecommendation!.nutritionTargets.mealFrequency} 次/天',
              '蛋白质比例：${(_aiRecommendation!.nutritionTargets.macroRatio.protein * 100).toInt()}%',
              '脂肪比例：${(_aiRecommendation!.nutritionTargets.macroRatio.fat * 100).toInt()}%',
              '碳水比例：${(_aiRecommendation!.nutritionTargets.macroRatio.carbs * 100).toInt()}%',
              '推荐置信度：${(_aiRecommendation!.confidence * 100).toInt()}%',
            ]),
          ],
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
        return _healthGoals.isNotEmpty && _targetCaloriesController.text.isNotEmpty;
      case 3: // 饮食偏好（改为可选）
        return true;
      case 4: // 健康状况（可选）
        return true;
      case 5: // AI推荐（新增步骤）
        return _aiRecommendationAccepted;
      case 6: // 确认信息
        return true;
      default:
        return false;
    }
  }

  void _applyTemplate(NutritionTemplateModel template) {
    setState(() {
      print('🎯 应用模板: ${template.key} - ${template.name}');
      
      // 清除之前的设置
      _healthGoals.clear();
      _dietaryPreferences.clear();
      _medicalConditions.clear();
      _specialStatus.clear();
      _nutritionPreferences.clear();
      _allergies.clear();
      _forbiddenIngredients.clear();
      
      // 设置档案名称
      _profileName = '${template.name}档案';
      
      // 根据模板类型设置预设值
      switch (template.key) {
        case 'weightLoss': // 减重塑形
          _ageGroup = '26to35';
          _healthGoals.addAll(['weight_loss', 'fat_loss']);
          _targetCaloriesController.text = '1500';
          _dietaryPreferences.add('lowCarb');
          _nutritionPreferences.addAll(['high_protein', 'low_fat']);
          _exerciseFrequency = 'frequent';
          break;
          
        case 'fitness': // 健身增肌
          _ageGroup = '18to25';
          _healthGoals.addAll(['muscle_gain', 'sports_performance']);
          _targetCaloriesController.text = '2800';
          _nutritionPreferences.addAll(['high_protein']);
          _exerciseFrequency = 'daily';
          break;
          
        case 'diabetic': // 血糖管理
          _ageGroup = '46to55';
          _healthGoals.addAll(['blood_sugar_control', 'weight_maintain']);
          _targetCaloriesController.text = '1800';
          _dietaryPreferences.addAll(['lowCarb']);
          _medicalConditions.add('diabetes');
          _nutritionPreferences.addAll(['low_fat', 'high_fiber']);
          _exerciseFrequency = 'moderate';
          break;
          
        case 'balanced': // 均衡营养
          _ageGroup = '26to35';
          _healthGoals.add('weight_maintain');
          _targetCaloriesController.text = '2000';
          _nutritionPreferences.add('balanced');
          _exerciseFrequency = 'moderate';
          break;
          
        case 'hypertension': // 血压管理
          _ageGroup = '46to55';
          _healthGoals.addAll(['blood_pressure_control', 'weight_maintain']);
          _targetCaloriesController.text = '1800';
          _medicalConditions.add('hypertension');
          _nutritionPreferences.addAll(['low_sodium', 'high_fiber']);
          _exerciseFrequency = 'moderate';
          break;
          
        case 'pregnancy': // 孕期营养
          _gender = 'female'; // 必须为女性
          _ageGroup = '26to35';
          _healthGoals.add('pregnancy');
          _specialStatus.add('pregnancy');
          _targetCaloriesController.text = '2200';
          _nutritionPreferences.addAll(['high_protein', 'high_fiber']);
          _exerciseFrequency = 'sometimes';
          // 避免高风险食材
          _forbiddenIngredients.addAll(['alcohol', 'caffeine']);
          print('✅ 孕期营养模板已应用 - 性别:$_gender, 特殊状态:$_specialStatus');
          break;
          
        case 'lactation': // 哺乳期营养
          _gender = 'female'; // 必须为女性
          _ageGroup = '26to35';
          _healthGoals.add('lactation');
          _specialStatus.add('lactation');
          _targetCaloriesController.text = '2500';
          _nutritionPreferences.addAll(['high_protein', 'balanced']);
          _exerciseFrequency = 'sometimes';
          _forbiddenIngredients.add('alcohol');
          break;
          
        case 'vegetarian': // 素食主义
          _healthGoals.add('weight_maintain');
          _dietaryPreferences.add('vegetarian');
          _targetCaloriesController.text = '2000';
          _nutritionPreferences.addAll(['plant_based', 'high_fiber']);
          _exerciseFrequency = 'moderate';
          // 素食者常见营养关注点
          break;
          
        case 'elderly': // 老年养生
          _ageGroup = 'above65';
          _healthGoals.addAll(['weight_maintain', 'immunity_boost']);
          _targetCaloriesController.text = '1600';
          _specialStatus.add('elderly');
          _nutritionPreferences.addAll(['high_protein', 'balanced']);
          _exerciseFrequency = 'sometimes';
          break;
          
        case 'teenager': // 青少年成长
          _ageGroup = 'under18';
          _healthGoals.addAll(['weight_maintain', 'energy_boost']);
          _targetCaloriesController.text = '2300';
          _nutritionPreferences.add('balanced');
          _exerciseFrequency = 'frequent';
          break;
          
        case 'allergic': // 过敏体质
          _healthGoals.add('weight_maintain');
          _targetCaloriesController.text = '2000';
          _nutritionPreferences.add('balanced');
          _exerciseFrequency = 'moderate';
          // 用户需要手动选择具体过敏原
          break;
          
        case 'gut_health': // 肠道健康
          _healthGoals.addAll(['gut_health', 'digestion_improvement']);
          _targetCaloriesController.text = '1900';
          _medicalConditions.add('gastric_issues');
          _nutritionPreferences.addAll(['high_fiber', 'balanced']);
          _exerciseFrequency = 'moderate';
          break;
          
        case 'immune_boost': // 免疫增强
          _healthGoals.addAll(['immunity_boost', 'energy_boost']);
          _targetCaloriesController.text = '2000';
          _nutritionPreferences.addAll(['balanced', 'high_fiber']);
          _exerciseFrequency = 'moderate';
          break;
          
        case 'heart_health': // 心脏健康
          _ageGroup = '46to55';
          _healthGoals.addAll(['cholesterol_management', 'weight_maintain']);
          _targetCaloriesController.text = '1800';
          _medicalConditions.add('heart_disease');
          _nutritionPreferences.addAll(['low_fat', 'low_sodium']);
          _exerciseFrequency = 'moderate';
          break;
          
        case 'brain_health': // 健脑益智
          _ageGroup = '18to25';
          _healthGoals.addAll(['mental_health', 'energy_boost']);
          _targetCaloriesController.text = '2100';
          _nutritionPreferences.addAll(['balanced', 'high_protein']);
          _exerciseFrequency = 'moderate';
          break;
          
        case 'menopause': // 更年期调理
          _gender = 'female'; // 必须为女性
          _ageGroup = '46to55';
          _healthGoals.addAll(['menopause', 'weight_maintain']);
          _specialStatus.add('none'); // 更年期不在特殊状态选项中，可能需要在健康目标中体现
          _targetCaloriesController.text = '1700';
          _nutritionPreferences.addAll(['balanced', 'high_fiber']);
          _exerciseFrequency = 'moderate';
          break;
          
        default:
          // 通用模板设置
          _profileName = template.name;
          _healthGoals.add('weight_maintain');
          _targetCaloriesController.text = '2000';
          _nutritionPreferences.add('balanced');
          _exerciseFrequency = 'moderate';
          break;
      }
      
      // 触发热量重新计算
      _updateSuggestedCalories();
      
      // 输出最终结果
      print('📋 模板应用完成:');
      print('  - 性别: $_gender');
      print('  - 年龄段: $_ageGroup');
      print('  - 健康目标: $_healthGoals');
      print('  - 特殊状态: $_specialStatus');
      print('  - 目标热量: ${_targetCaloriesController.text}');
      print('  - 运动频率: $_exerciseFrequency');
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
    
    // 如果有减重相关目标
    if (_healthGoals.contains('weight_loss') || _healthGoals.contains('fat_loss')) {
      targetCalories *= 0.8;
    }
    // 如果有增肌相关目标
    else if (_healthGoals.contains('muscle_gain') || _healthGoals.contains('weight_gain')) {
      targetCalories *= 1.2;
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
        userId: UserId(userId),
        profileName: _profileName,
        gender: _gender,
        ageGroup: _ageGroup,
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        healthGoal: _healthGoals.isNotEmpty ? _healthGoals.first : 'maintain_weight',  // 主要目标
        healthGoalDetails: healthGoalDetails,  // 所有目标和详情存储在这里
        targetCalories: double.parse(_targetCaloriesController.text),
        dietaryPreferences: _dietaryPreferences.toList(),
        medicalConditions: _medicalConditions.toList(),
        exerciseFrequency: _exerciseFrequency,
        nutritionPreferences: _nutritionPreferences.toList(),
        specialStatus: _specialStatus.toList(),
        forbiddenIngredients: _forbiddenIngredients.toList(),
        allergies: _allergies.toList(),
        activityDetails: _activityDetails,
        // AI推荐信息
        aiRecommendationId: _aiRecommendation?.id,
        aiNutritionTargets: _aiRecommendation != null 
            ? {
                'dailyCalories': _aiRecommendation!.nutritionTargets.dailyCalories,
                'hydrationGoal': _aiRecommendation!.nutritionTargets.hydrationGoal,
                'mealFrequency': _aiRecommendation!.nutritionTargets.mealFrequency.toDouble(),
                'proteinRatio': _aiRecommendation!.nutritionTargets.macroRatio.protein,
                'fatRatio': _aiRecommendation!.nutritionTargets.macroRatio.fat,
                'carbsRatio': _aiRecommendation!.nutritionTargets.macroRatio.carbs,
                'confidence': _aiRecommendation!.confidence,
              }
            : null,
        hasAIRecommendation: _aiRecommendation != null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final createdProfile = await ref.read(nutritionProfileListProvider.notifier).createProfile(profile);
      
      // 给用户奖励能量点数 - 创建档案
      int completionPercentage = 0;
      if (createdProfile?.id != null) {
        await ref.read(nutritionProgressProvider.notifier).recordProfileCreation(createdProfile!.id!);
        
        // 如果档案信息比较完整，额外给奖励
        completionPercentage = createdProfile.completionPercentage;
        if (completionPercentage >= 80) {
          await ref.read(nutritionProgressProvider.notifier).recordProfileCompletion(createdProfile.id!);
        }
      }
      
      // 创建成功后清除草稿
      await _clearDraftAfterSuccess();
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('营养档案创建成功！'),
                if (createdProfile?.id != null)
                  Text(
                    '🎉 获得 ${completionPercentage >= 80 ? '80' : '50'} 能量点奖励！',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
              ],
            ),
          ),
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