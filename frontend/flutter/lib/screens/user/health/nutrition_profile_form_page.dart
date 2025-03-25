import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/index.dart';
import '../../../models/nutrition_profile.dart';
import 'dart:convert';

class NutritionProfileFormPage extends StatefulWidget {
  final NutritionProfile? profile;
  
  const NutritionProfileFormPage({Key? key, this.profile}) : super(key: key);

  @override
  State<NutritionProfileFormPage> createState() => _NutritionProfileFormPageState();
}

class _NutritionProfileFormPageState extends State<NutritionProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;
  
  // 表单字段
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'male';
  String _activityLevel = 'moderate';
  final _healthConditionsController = TextEditingController();
  String _goals = 'health_improvement';
  final List<String> _cuisinePreferences = [];
  final List<String> _allergies = [];
  
  // 活动水平选项
  final List<String> _activityLevels = [
    'sedentary',
    'light',
    'moderate',
    'active',
    'very_active'
  ];
  
  // 目标选项
  final List<String> _goalsList = [
    'weight_loss',
    'weight_gain',
    'maintenance',
    'muscle_gain',
    'health_improvement'
  ];
  
  // 活动水平显示名称
  String getActivityLevelName(String level) {
    switch(level) {
      case 'sedentary': return '几乎不活动';
      case 'light': return '轻度活跃';
      case 'moderate': return '中等活跃';
      case 'active': return '非常活跃';
      case 'very_active': return '极度活跃';
      default: return '中等活跃';
    }
  }
  
  // 目标显示名称
  String getGoalsName(String goals) {
    switch(goals) {
      case 'weight_loss': return '减重';
      case 'weight_gain': return '增重';
      case 'maintenance': return '保持体重';
      case 'muscle_gain': return '增肌';
      case 'health_improvement': return '改善健康';
      default: return '改善健康';
    }
  }
  
  // 饮食偏好选项
  final List<String> _availableCuisinePreferences = [
    '中餐',
    '西餐',
    '日料',
    '韩餐',
    '泰餐',
    '意餐',
    '墨西哥餐',
    '印度餐'
  ];

  // 过敏原选项
  final List<String> _availableAllergies = [
    '花生',
    '海鲜',
    '乳制品',
    '鸡蛋',
    '麸质',
    '坚果',
    '大豆',
    '芒果'
  ];

  @override
  void initState() {
    super.initState();
    
    // 如果是编辑模式，填充现有数据
    if (widget.profile != null) {
      _nameController.text = widget.profile!.name;
      _heightController.text = widget.profile!.height?.toString() ?? '';
      _weightController.text = widget.profile!.weight?.toString() ?? '';
      _ageController.text = widget.profile!.age?.toString() ?? '';
      _gender = widget.profile!.gender ?? 'male';
      _activityLevel = widget.profile!.activityLevel ?? 'moderate';
      _healthConditionsController.text = widget.profile!.healthConditions?.join(', ') ?? '';
      _goals = widget.profile!.goals ?? 'health_improvement';
      
      // 填充饮食偏好
      if (widget.profile!.dietaryPreferences != null) {
        if (widget.profile!.dietaryPreferences!.cuisinePreference != null) {
          _cuisinePreferences.add(widget.profile!.dietaryPreferences!.cuisinePreference!);
        }
        if (widget.profile!.dietaryPreferences!.allergies != null) {
          _allergies.addAll(widget.profile!.dietaryPreferences!.allergies!);
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _healthConditionsController.dispose();
    super.dispose();
  }

  // 保存档案
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final nutritionProvider = Provider.of<NutritionProvider>(context, listen: false);
    
    if (!userProvider.isLoggedIn || userProvider.user == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = '请先登录';
      });
      return;
    }
    
    try {
      // 构建档案数据
      final Map<String, dynamic> simplifiedData = {
        'ownerId': userProvider.user!.id,
        'name': _nameController.text,
        'gender': _gender,
        'activityLevel': _activityLevel,
        'goals': _goals
      };
      
      if (_heightController.text.isNotEmpty) {
        simplifiedData['height'] = double.parse(_heightController.text);
      }
      
      if (_weightController.text.isNotEmpty) {
        simplifiedData['weight'] = double.parse(_weightController.text);
      }
      
      if (_ageController.text.isNotEmpty) {
        simplifiedData['age'] = int.parse(_ageController.text);
      }
      
      if (_healthConditionsController.text.isNotEmpty) {
        simplifiedData['healthConditions'] = _healthConditionsController.text
            .split(',')
            .map((e) => e.trim())
            .toList();
      }
      
      if (_cuisinePreferences.isNotEmpty || _allergies.isNotEmpty) {
        final Map<String, dynamic> dietaryPrefs = {};
        
        if (_cuisinePreferences.isNotEmpty) {
          // 将中文菜系名称转换为后端期望的枚举值
          final String cuisineValue = _mapCuisineToBackendValue(_cuisinePreferences.first);
          dietaryPrefs['cuisinePreference'] = cuisineValue;
        }
        
        if (_allergies.isNotEmpty) {
          dietaryPrefs['allergies'] = _allergies;
        }
        
        simplifiedData['dietaryPreferences'] = dietaryPrefs;
      }
      
      print('准备保存简化档案: ${json.encode(simplifiedData)}');
      print('用户Token: ${userProvider.token}');
      
      // 保存档案
      bool success;
      try {
        if (widget.profile == null) {
          // 创建新档案
          print('正在创建新档案...');
          success = await nutritionProvider.createProfile(userProvider.token!, simplifiedData);
          print('创建结果: $success');
        } else {
          // 更新现有档案
          print('正在更新档案 ID: ${widget.profile!.id}...');
          // 添加ID到数据中
          simplifiedData['_id'] = widget.profile!.id;
          success = await nutritionProvider.updateProfile(userProvider.token!, widget.profile!.id, simplifiedData);
          print('更新结果: $success');
        }
      } catch (e) {
        print('API调用异常: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = '调用API异常: $e';
        });
        return;
      }
      
      if (success) {
        if (mounted) {
          print('保存成功，返回上一页');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('档案保存成功')),
          );
          Navigator.pop(context, true); // 返回上一页并传递更新成功的信号
        }
      } else {
        print('Provider报告保存失败: ${nutritionProvider.error}');
        setState(() {
          _isLoading = false;
          _errorMessage = '保存失败: ${nutritionProvider.error ?? '未知错误'}';
        });
      }
    } catch (e) {
      print('保存档案时发生异常: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = '发生错误: $e';
      });
    }
  }

  // 将菜系名称映射为后端期望的值
  String _mapCuisineToBackendValue(String cuisine) {
    switch (cuisine) {
      case '中餐': return 'north'; // 默认北方菜
      case '西餐': return 'other';
      case '日料': return 'other';
      case '韩餐': return 'other';
      case '泰餐': return 'other';
      case '意餐': return 'other';
      case '墨西哥餐': return 'other';
      case '印度餐': return 'other';
      case '川菜': return 'sichuan';
      case '粤菜': return 'cantonese';
      case '湘菜': return 'hunan';
      default: return 'other';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile == null ? '创建营养档案' : '编辑营养档案'),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade800),
                      ),
                    ),
                  
                  // 基本信息
                  const Text(
                    '基本信息',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 档案名称
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: '档案名称',
                      hintText: '例如：日常饮食档案',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入档案名称';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // 身高和体重（一行两列）
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _heightController,
                          decoration: const InputDecoration(
                            labelText: '身高 (cm)',
                            border: OutlineInputBorder(),
                            suffixText: 'cm',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final height = double.tryParse(value);
                              if (height == null || height <= 0) {
                                return '请输入有效的身高';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _weightController,
                          decoration: const InputDecoration(
                            labelText: '体重 (kg)',
                            border: OutlineInputBorder(),
                            suffixText: 'kg',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final weight = double.tryParse(value);
                              if (weight == null || weight <= 0) {
                                return '请输入有效的体重';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // 年龄和性别（一行两列）
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _ageController,
                          decoration: const InputDecoration(
                            labelText: '年龄',
                            border: OutlineInputBorder(),
                            suffixText: '岁',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final age = int.tryParse(value);
                              if (age == null || age <= 0) {
                                return '请输入有效的年龄';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _gender,
                          decoration: const InputDecoration(
                            labelText: '性别',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'male', child: Text('男')),
                            DropdownMenuItem(value: 'female', child: Text('女')),
                            DropdownMenuItem(value: 'other', child: Text('其他')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _gender = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // 活动水平
                  const Text(
                    '生活习惯',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    value: _activityLevel,
                    decoration: const InputDecoration(
                      labelText: '活动水平',
                      border: OutlineInputBorder(),
                    ),
                    items: _activityLevels.map((level) => 
                      DropdownMenuItem(value: level, child: Text(getActivityLevelName(level)))
                    ).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _activityLevel = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // 健康状况
                  TextFormField(
                    controller: _healthConditionsController,
                    decoration: const InputDecoration(
                      labelText: '健康状况（用逗号分隔）',
                      hintText: '例如：高血压, 糖尿病, 高血脂',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  
                  // 饮食偏好
                  const Text(
                    '饮食偏好',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  const Text(
                    '喜欢的菜系（选择一项）',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableCuisinePreferences.map((cuisine) {
                      final isSelected = _cuisinePreferences.contains(cuisine);
                      return FilterChip(
                        label: Text(cuisine),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            // 单选模式
                            _cuisinePreferences.clear();
                            if (selected) {
                              _cuisinePreferences.add(cuisine);
                            }
                          });
                        },
                        selectedColor: Colors.green.shade100,
                        checkmarkColor: Colors.green,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  
                  const Text(
                    '食物过敏原（可多选）',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableAllergies.map((allergy) {
                      final isSelected = _allergies.contains(allergy);
                      return FilterChip(
                        label: Text(allergy),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _allergies.add(allergy);
                            } else {
                              _allergies.remove(allergy);
                            }
                          });
                        },
                        selectedColor: Colors.red.shade100,
                        checkmarkColor: Colors.red,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  
                  // 健康目标
                  const Text(
                    '健康目标',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    value: _goals,
                    decoration: const InputDecoration(
                      labelText: '健康目标',
                      border: OutlineInputBorder(),
                    ),
                    items: _goalsList.map((goal) => 
                      DropdownMenuItem(value: goal, child: Text(getGoalsName(goal)))
                    ).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _goals = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // 保存按钮
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      child: Text(
                        widget.profile == null ? '创建档案' : '保存修改',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
    );
  }
} 