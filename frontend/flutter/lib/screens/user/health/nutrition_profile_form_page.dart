import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/index.dart';
import '../../../models/nutrition_profile.dart';
import 'dart:convert';
import '../../../utils/logger.dart';

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
  final _descriptionController = TextEditingController();
  String? _selectedGender;
  String? _selectedActivityLevel;
  String? _selectedGoal;
  String? _selectedCuisine;
  String? _selectedSpicyLevel;
  final List<String> _healthConditions = [];
  final List<String> _allergies = [];
  final List<String> _avoidedIngredients = [];
  
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
  
  // 辣度偏好选项
  final List<String> _spicyLevels = [
    'not_spicy',
    'mild',
    'medium',
    'hot',
    'extra_hot'
  ];
  
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
  
  @override
  void initState() {
    super.initState();
    
    // 如果是编辑模式，填充现有数据
    if (widget.profile != null) {
      _nameController.text = widget.profile!.name;
      _descriptionController.text = widget.profile!.description ?? '';
      _heightController.text = widget.profile!.height?.toString() ?? '';
      _weightController.text = widget.profile!.weight?.toString() ?? '';
      _ageController.text = widget.profile!.age?.toString() ?? '';
      _selectedGender = widget.profile!.gender;
      _selectedActivityLevel = widget.profile!.activityLevel;
      _healthConditions.addAll(widget.profile!.healthConditions ?? []);
      _selectedGoal = widget.profile!.goals;
      
      // 填充饮食偏好
      if (widget.profile!.dietaryPreferences != null) {
        _selectedCuisine = widget.profile!.dietaryPreferences!.cuisinePreference;
        _selectedSpicyLevel = widget.profile!.dietaryPreferences!.spicyPreference;
        
        if (widget.profile!.dietaryPreferences!.allergies != null) {
          _allergies.addAll(widget.profile!.dietaryPreferences!.allergies!);
        }
        
        if (widget.profile!.dietaryPreferences!.avoidedIngredients != null) {
          _avoidedIngredients.addAll(widget.profile!.dietaryPreferences!.avoidedIngredients!);
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
    _descriptionController.dispose();
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
    
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final nutritionProvider = Provider.of<NutritionProvider>(context, listen: false);
      
      // 确保用户已登录
      if (userProvider.user == null || userProvider.token == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = '用户未登录';
        });
        return;
      }
      
      // 准备要提交的数据
      // 主要字段
      final Map<String, dynamic> simplifiedData = {
        'name': _nameController.text,
        'ownerId': userProvider.user!.id,  // 使用ownerId匹配后端控制器期望的参数名
        'description': _descriptionController.text.isEmpty ? null : _descriptionController.text,
      };
      
      // 可选字段
      if (_heightController.text.isNotEmpty) {
        simplifiedData['height'] = double.parse(_heightController.text);
      }
      
      if (_weightController.text.isNotEmpty) {
        simplifiedData['weight'] = double.parse(_weightController.text);
      }
      
      if (_ageController.text.isNotEmpty) {
        simplifiedData['age'] = int.parse(_ageController.text);
      }
      
      if (_selectedGender != null) {
        simplifiedData['gender'] = _selectedGender;
      }
      
      if (_selectedActivityLevel != null) {
        simplifiedData['activityLevel'] = _selectedActivityLevel;
      }
      
      if (_selectedGoal != null) {
        simplifiedData['goals'] = _selectedGoal;
      }
      
      // 健康状况
      if (_healthConditions.isNotEmpty) {
        simplifiedData['healthConditions'] = _healthConditions;
      }
      
      // 饮食偏好
      if (_selectedCuisine != null || _selectedSpicyLevel != null || _allergies.isNotEmpty || _avoidedIngredients.isNotEmpty) {
        Map<String, dynamic> dietaryPrefs = {};
        
        if (_selectedCuisine != null) {
          dietaryPrefs['cuisinePreference'] = _mapCuisineToBackendValue(_selectedCuisine!);
        }
        
        if (_selectedSpicyLevel != null) {
          dietaryPrefs['spicyPreference'] = _selectedSpicyLevel;
        }
        
        if (_allergies.isNotEmpty) {
          dietaryPrefs['allergies'] = _allergies.toList();
        }
        
        if (_avoidedIngredients.isNotEmpty) {
          dietaryPrefs['avoidedIngredients'] = _avoidedIngredients.toList();
        }
        
        simplifiedData['dietaryPreferences'] = dietaryPrefs;
      }
      
      print('[营养档案] 准备保存档案数据: ${json.encode(simplifiedData)}');
      print('[营养档案] 用户ID: ${userProvider.user!.id}, Token长度: ${userProvider.token?.length ?? 0}');
      
      // 保存档案
      bool success;
      try {
        if (widget.profile == null) {
          // 创建新档案
          print('[营养档案] 正在创建新档案...');
          success = await nutritionProvider.createProfile(userProvider.token!, simplifiedData);
          print('[营养档案] 创建结果: $success');
        } else {
          // 更新现有档案
          print('[营养档案] 正在更新档案 ID: ${widget.profile!.id}...');
          // 添加ID到数据中
          simplifiedData['_id'] = widget.profile!.id;
          success = await nutritionProvider.updateProfile(userProvider.token!, widget.profile!.id, simplifiedData);
          print('[营养档案] 更新结果: $success');
        }
      } catch (e) {
        print('[营养档案] API调用异常: $e');
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
        actions: [
          // 仅当编辑现有档案时显示删除按钮
          if (widget.profile != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _confirmDelete,
              tooltip: '删除档案',
            ),
        ],
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
                  
                  // 档案描述
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: '档案描述',
                      hintText: '可选：对该档案的简短描述',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
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
                          value: _selectedGender,
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
                                _selectedGender = value;
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
                    value: _selectedActivityLevel,
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
                          _selectedActivityLevel = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // 健康状况 - 使用Chips而不是文本框
                  const Text(
                    '健康状况（可多选）',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      '高血压',
                      '糖尿病',
                      '高血脂',
                      '心脏病',
                      '哮喘',
                      '关节炎',
                      '贫血',
                      '消化不良'
                    ].map((condition) {
                      final isSelected = _healthConditions.contains(condition);
                      return FilterChip(
                        label: Text(condition),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _healthConditions.add(condition);
                            } else {
                              _healthConditions.remove(condition);
                            }
                          });
                        },
                        selectedColor: Colors.amber.shade100,
                        checkmarkColor: Colors.amber.shade800,
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
                    value: _selectedGoal,
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
                          _selectedGoal = value;
                        });
                      }
                    },
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
                  const SizedBox(height: 16),
                  
                  // 喜好的菜系
                  const Text(
                    '喜好的菜系',
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
                      final isSelected = _selectedCuisine == _mapCuisineToBackendValue(cuisine);
                      return FilterChip(
                        label: Text(cuisine),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCuisine = selected ? _mapCuisineToBackendValue(cuisine) : null;
                          });
                        },
                        selectedColor: Colors.green.shade100,
                        checkmarkColor: Colors.green,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  
                  // 辣度偏好
                  const Text(
                    '辣度偏好',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      {'value': 'not_spicy', 'label': '不辣'},
                      {'value': 'mild', 'label': '微辣'},
                      {'value': 'medium', 'label': '中辣'},
                      {'value': 'hot', 'label': '辣'},
                      {'value': 'extra_hot', 'label': '特辣'},
                    ].map((spicy) {
                      final isSelected = _selectedSpicyLevel == spicy['value'];
                      return FilterChip(
                        label: Text(spicy['label'] as String),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedSpicyLevel = selected ? spicy['value'] as String : null;
                          });
                        },
                        selectedColor: Colors.red.shade100,
                        checkmarkColor: Colors.red,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  
                  // 食物过敏原
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
                  const SizedBox(height: 16),
                  
                  // 避免的食材
                  const Text(
                    '希望避免的食材（可多选）',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      '葱',
                      '蒜',
                      '姜',
                      '香菜',
                      '芹菜',
                      '胡椒',
                      '茄子',
                      '香菇'
                    ].map((ingredient) {
                      final isSelected = _avoidedIngredients.contains(ingredient);
                      return FilterChip(
                        label: Text(ingredient),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _avoidedIngredients.add(ingredient);
                            } else {
                              _avoidedIngredients.remove(ingredient);
                            }
                          });
                        },
                        selectedColor: Colors.orange.shade100,
                        checkmarkColor: Colors.orange,
                      );
                    }).toList(),
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

  // 确认删除档案
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('您确定要删除这个营养档案吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 关闭对话框
            },
            child: const Text('取消'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // 关闭对话框
              _deleteProfile(); // 执行删除
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
  
  // 执行删除档案操作
  Future<void> _deleteProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final nutritionProvider = Provider.of<NutritionProvider>(context, listen: false);
    
    // 确保用户已登录并且档案ID存在
    if (userProvider.user == null || userProvider.token == null || widget.profile == null) {
      setState(() {
        _errorMessage = '用户未登录或档案无效';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      Logger.i(Logger.NUTRITION, '尝试删除档案: ${widget.profile!.id}');
      
      final success = await nutritionProvider.deleteProfile(
        userProvider.token!, 
        widget.profile!.id,
        ownerId: userProvider.user!.id,
      );
      
      if (success) {
        Logger.i(Logger.NUTRITION, '档案删除成功');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('档案已删除')),
          );
          Navigator.pop(context, true); // 返回上一页并传递更新成功的信号
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = '删除失败: ${nutritionProvider.error ?? "未知错误"}';
        });
      }
    } catch (e) {
      Logger.e(Logger.NUTRITION, '删除档案时发生异常', e);
      setState(() {
        _isLoading = false;
        _errorMessage = '发生错误: $e';
      });
    }
  }
} 