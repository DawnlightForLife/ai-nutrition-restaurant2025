import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/nutrition_profile.dart';
import '../providers/nutrition_profile_provider.dart';

/// 营养档案编辑页
class NutritionProfileEditor extends ConsumerStatefulWidget {
  final NutritionProfile? profile;
  const NutritionProfileEditor({super.key, this.profile});

  @override
  ConsumerState<NutritionProfileEditor> createState() => _NutritionProfileEditorState();
}

class _NutritionProfileEditorState extends ConsumerState<NutritionProfileEditor> {
  final _formKey = GlobalKey<FormState>();
  
  // 基本信息控制器
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;
  
  // 表单数据
  String? _selectedGender;
  String? _selectedActivityLevel;
  String? _selectedHealthGoal;
  List<String> _selectedDietaryRestrictions = [];
  List<String> _selectedHealthConditions = [];
  List<String> _selectedAllergies = [];
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadProfileData();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _ageController = TextEditingController();
  }

  void _loadProfileData() {
    if (widget.profile != null) {
      final profile = widget.profile!;
      _heightController.text = profile.basicInfo.height.toString();
      _weightController.text = profile.basicInfo.weight.toString();
      _ageController.text = profile.basicInfo.age.toString();
      _selectedGender = profile.basicInfo.gender.name;
      _selectedActivityLevel = profile.basicInfo.activityLevel.name;
      _selectedHealthGoal = 'maintain'; // 默认值，因为原模型没有healthGoal
      _selectedDietaryRestrictions = profile.dietaryPreferences.map((e) => e.name).toList();
      _selectedHealthConditions = profile.healthConditions.map((e) => e.name).toList();
      _selectedAllergies = []; // 原模型没有allergies字段
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑营养档案'),
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: const Text('保存'),
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfoSection(),
                  const SizedBox(height: 24),
                  _buildHealthGoalSection(),
                  const SizedBox(height: 24),
                  _buildDietaryPreferencesSection(),
                  const SizedBox(height: 24),
                  _buildHealthConditionsSection(),
                  const SizedBox(height: 24),
                  _buildAllergiesSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('基本信息', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        
        // 性别选择
        DropdownButtonFormField<String>(
          value: _selectedGender,
          decoration: const InputDecoration(
            labelText: '性别',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'male', child: Text('男')),
            DropdownMenuItem(value: 'female', child: Text('女')),
          ],
          onChanged: (value) => setState(() => _selectedGender = value),
          validator: (value) => value == null ? '请选择性别' : null,
        ),
        const SizedBox(height: 16),
        
        // 年龄输入
        TextFormField(
          controller: _ageController,
          decoration: const InputDecoration(
            labelText: '年龄',
            border: OutlineInputBorder(),
            suffixText: '岁',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return '请输入年龄';
            final age = int.tryParse(value);
            if (age == null || age < 1 || age > 120) return '请输入有效年龄(1-120)';
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // 身高体重输入行
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 400) {
              return Row(
                children: [
                  Expanded(child: _buildHeightField()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildWeightField()),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildHeightField(),
                  const SizedBox(height: 16),
                  _buildWeightField(),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 16),
        
        // 活动水平
        DropdownButtonFormField<String>(
          value: _selectedActivityLevel,
          decoration: const InputDecoration(
            labelText: '活动水平',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'sedentary', child: Text('久坐不动')),
            DropdownMenuItem(value: 'light', child: Text('轻度活动')),
            DropdownMenuItem(value: 'moderate', child: Text('中度活动')),
            DropdownMenuItem(value: 'active', child: Text('活跃')),
            DropdownMenuItem(value: 'very_active', child: Text('非常活跃')),
          ],
          onChanged: (value) => setState(() => _selectedActivityLevel = value),
          validator: (value) => value == null ? '请选择活动水平' : null,
        ),
      ],
    );
  }

  Widget _buildHeightField() {
    return TextFormField(
      controller: _heightController,
      decoration: const InputDecoration(
        labelText: '身高',
        border: OutlineInputBorder(),
        suffixText: 'cm',
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return '请输入身高';
        final height = double.tryParse(value);
        if (height == null || height < 50 || height > 250) return '请输入有效身高(50-250cm)';
        return null;
      },
    );
  }

  Widget _buildWeightField() {
    return TextFormField(
      controller: _weightController,
      decoration: const InputDecoration(
        labelText: '体重',
        border: OutlineInputBorder(),
        suffixText: 'kg',
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return '请输入体重';
        final weight = double.tryParse(value);
        if (weight == null || weight < 20 || weight > 300) return '请输入有效体重(20-300kg)';
        return null;
      },
    );
  }

  Widget _buildHealthGoalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('健康目标', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedHealthGoal,
          decoration: const InputDecoration(
            labelText: '主要健康目标',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'weight_loss', child: Text('减重')),
            DropdownMenuItem(value: 'weight_gain', child: Text('增重')),
            DropdownMenuItem(value: 'muscle_gain', child: Text('增肌')),
            DropdownMenuItem(value: 'maintain', child: Text('保持体重')),
            DropdownMenuItem(value: 'health_improve', child: Text('改善健康')),
          ],
          onChanged: (value) => setState(() => _selectedHealthGoal = value),
          validator: (value) => value == null ? '请选择健康目标' : null,
        ),
      ],
    );
  }

  Widget _buildDietaryPreferencesSection() {
    const dietaryOptions = [
      '素食', '纯素食', '无麸质', '低钠', '低糖', '生酮', '地中海饮食', '清真', '犹太洁食'
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('饮食偏好', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: dietaryOptions.map((option) {
            final isSelected = _selectedDietaryRestrictions.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedDietaryRestrictions.add(option);
                  } else {
                    _selectedDietaryRestrictions.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHealthConditionsSection() {
    const healthOptions = [
      '糖尿病', '高血压', '高胆固醇', '心脏病', '肾病', '肝病', '甲状腺疾病', '贫血', '骨质疏松'
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('健康状况', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('如有以下健康状况，请选择', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: healthOptions.map((option) {
            final isSelected = _selectedHealthConditions.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedHealthConditions.add(option);
                  } else {
                    _selectedHealthConditions.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAllergiesSection() {
    const allergyOptions = [
      '花生', '坚果', '海鲜', '鸡蛋', '牛奶', '大豆', '小麦', '芝麻', '鱼类', '贝类'
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('过敏信息', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('如有以下食物过敏，请选择', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allergyOptions.map((option) {
            final isSelected = _selectedAllergies.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAllergies.add(option);
                  } else {
                    _selectedAllergies.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 构造基本信息
      final basicInfo = BasicInfo(
        age: int.parse(_ageController.text),
        gender: Gender.values.firstWhere((e) => e.name == _selectedGender),
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        activityLevel: ActivityLevel.values.firstWhere((e) => e.name == _selectedActivityLevel),
      );

      // 构造饮食偏好
      final dietaryPreferences = _selectedDietaryRestrictions.map((name) => 
        DietaryPreference(
          id: name.toLowerCase().replaceAll(' ', '_'),
          name: name,
          description: name,
        )
      ).toList();

      // 构造健康状况
      final healthConditions = _selectedHealthConditions.map((name) => 
        HealthCondition(
          id: name.toLowerCase().replaceAll(' ', '_'),
          name: name,
          description: name,
          severity: ConditionSeverity.mild,
        )
      ).toList();

      // 构造生活习惯（使用默认值）
      const lifestyleHabits = LifestyleHabits(
        sleepPattern: SleepPattern.regular,
        exerciseFrequency: ExerciseFrequency.sometimes,
        dailyWaterIntake: 2000,
        smokingStatus: false,
        alcoholConsumption: AlcoholConsumption.occasionally,
      );

      final profileData = NutritionProfile(
        id: widget.profile?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.profile?.userId ?? 'current_user', // 这应该从认证状态获取
        name: widget.profile?.name ?? '营养档案',
        basicInfo: basicInfo,
        dietaryPreferences: dietaryPreferences,
        healthConditions: healthConditions,
        lifestyleHabits: lifestyleHabits,
        createdAt: widget.profile?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.profile == null) {
        // 创建新档案
        await ref.read(nutritionProfileProvider.notifier).createProfile(profileData);
      } else {
        // 更新现有档案
        await ref.read(nutritionProfileProvider.notifier).updateProfile(profileData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('营养档案保存成功')),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}