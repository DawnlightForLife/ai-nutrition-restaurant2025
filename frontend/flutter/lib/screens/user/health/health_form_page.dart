import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../models/health/nutrition_profile_model.dart';
import '../../../widgets/common/loading_overlay.dart';
import '../../../widgets/form/form_section_card.dart';
import '../../../widgets/form/custom_dropdown.dart';
import '../../../widgets/form/custom_text_field.dart';
import '../../../widgets/form/custom_chip_input.dart';
import '../../../providers/health/health_profile_provider.dart';
import '../../../providers/core/auth_provider.dart';

class HealthFormPage extends StatefulWidget {
  final NutritionProfile? profile;
  final bool viewOnly;

  const HealthFormPage({
    Key? key,
    this.profile,
    this.viewOnly = false,
  }) : super(key: key);

  @override
  State<HealthFormPage> createState() => _HealthFormPageState();
}

class _HealthFormPageState extends State<HealthFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEditing = false;  // 是否处于编辑状态

  // 表单数据
  late String _profileName;
  late String _gender;
  late String _ageGroup;
  late double _height;
  late double _weight;
  Map<String, String> _region = {};
  String? _occupation;
  late Map<String, dynamic> _healthStatus;
  late Map<String, dynamic> _dietaryPreferences;
  late Map<String, dynamic> _lifestyle;
  late List<String> _nutritionGoals;
  late bool _isPrimary;

  // 选项列表
  final List<String> _genderOptions = ['male', 'female', 'other'];
  final List<String> _ageGroupOptions = [
    'under_18',
    '18_30',
    '31_45',
    '46_60',
    'above_60'
  ];
  final List<String> _occupationOptions = [
    'student',
    'office_worker',
    'physical_worker',
    'retired',
    'other'
  ];
  final List<String> _chronicDiseaseOptions = [
    'hypertension',
    'diabetes',
    'gout',
    'heart_disease',
    'none'
  ];
  final List<String> _specialConditionOptions = [
    'pregnancy',
    'lactation',
    'menopause',
    'none'
  ];
  final List<String> _tastePreferenceOptions = [
    'light',
    'spicy',
    'sour',
    'sweet',
    'salty'
  ];
  final List<String> _exerciseFrequencyOptions = [
    'none',
    'occasional',
    'regular',
    'frequent',
    'daily'
  ];
  final List<String> _nutritionGoalOptions = [
    'weight_loss',
    'weight_gain',
    'muscle_gain',
    'blood_sugar_control',
    'blood_pressure_control',
    'immunity_boost',
    'energy_boost',
    'general_health'
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    // 如果是编辑现有档案，则填充表单
    if (widget.profile != null) {
      _profileName = widget.profile!.profileName;
      _gender = widget.profile!.gender;
      _ageGroup = widget.profile!.ageGroup;
      _height = widget.profile!.height;
      _weight = widget.profile!.weight;
      _region = widget.profile!.region ?? {};
      _occupation = widget.profile!.occupation;
      _healthStatus = Map<String, dynamic>.from(widget.profile!.healthStatus);
      _dietaryPreferences = Map<String, dynamic>.from(widget.profile!.dietaryPreferences);
      _lifestyle = Map<String, dynamic>.from(widget.profile!.lifestyle);
      _nutritionGoals = List<String>.from(widget.profile!.nutritionGoals);
      _isPrimary = widget.profile!.isPrimary;
      
      // 初始状态设置
      _isEditing = !widget.viewOnly;  // 仅当不是查看模式时才默认为编辑状态
    } else {
      // 新建档案，直接设为编辑状态
      _isEditing = true;
      _profileName = '';
      _gender = 'male';
      _ageGroup = '18_30';
      _height = 170.0;
      _weight = 60.0;
      _occupation = 'student';
      _healthStatus = {
        'chronicDiseases': [],
        'specialConditions': [],
      };
      _dietaryPreferences = {
        'isVegetarian': false,
        'tastePreference': [],
        'taboos': [],
        'cuisine': 'chinese',
        'allergies': [],
      };
      _lifestyle = {
        'smoking': false,
        'drinking': false,
        'sleepDuration': 8,
        'exerciseFrequency': 'occasional',
      };
      _nutritionGoals = ['general_health'];
      _isPrimary = false;
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // 调试输出检查profileName字段值
      debugPrint('检查profileName字段的值: $_profileName');
      
      // 确保名称不为空
      if (_profileName.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('档案名称不能为空')),
        );
        return;
      }
      
      setState(() {
        _isLoading = true;
      });
      
      try {
        final profile = NutritionProfile(
          id: widget.profile?.id ?? '',
          userId: widget.profile?.userId ?? '',
          profileName: _profileName.trim(),  // 确保移除空格
          gender: _gender,
          ageGroup: _ageGroup,
          height: _height,
          weight: _weight,
          region: _region,
          occupation: _occupation,
          healthStatus: _healthStatus,
          dietaryPreferences: _dietaryPreferences,
          lifestyle: _lifestyle,
          nutritionGoals: _nutritionGoals,
          isPrimary: _isPrimary,
          createdAt: widget.profile?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        debugPrint('开始保存营养档案...');
        debugPrint('档案名称: ${profile.profileName}');  // 添加调试日志验证名称是否正确
        
        bool success = false;
        
        final provider = Provider.of<HealthProfileProvider>(context, listen: false);
        
        if (widget.profile != null) {
          // 更新现有档案
          debugPrint('更新现有档案: ${widget.profile!.id}');
          success = await provider.updateProfile(widget.profile!.id, profile);
        } else {
          // 创建新档案
          debugPrint('创建新档案');
          success = await provider.createProfile(profile);
        }
        
        debugPrint('保存档案结果: $success');
        
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          if (success) {
            // 操作成功，显示成功消息并返回
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.profile != null ? '档案更新成功' : '档案创建成功'),
                backgroundColor: Colors.green,
              ),
            );
            
            // 短暂延迟后返回，让用户看到成功提示
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.pop(context, true);
              }
            });
          } else {
            // 操作失败，显示错误消息
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(provider.errorMessage ?? '操作失败，请重试'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        debugPrint('保存档案时出错: $e');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('发生错误: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile == null ? '创建营养档案' : 
              _isEditing ? '编辑营养档案' : '营养档案详情'),
        actions: [
          if (widget.profile != null && !_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: '编辑档案',
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBasicInfoSection(),
                const SizedBox(height: 16),
                _buildHealthStatusSection(),
                const SizedBox(height: 16),
                _buildDietaryPreferencesSection(),
                const SizedBox(height: 16),
                _buildLifestyleSection(),
                const SizedBox(height: 16),
                _buildGoalsSection(),
                const SizedBox(height: 32),
                if (_isEditing)
                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('保存营养档案'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return FormSectionCard(
      title: '基本信息',
      children: [
        _buildTextField(
          label: '档案名称',
          initialValue: _profileName,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '请输入档案名称';
            }
            return null;
          },
          onSaved: (value) {
            _profileName = value ?? '';
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '性别',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('男')),
                      DropdownMenuItem(value: 'female', child: Text('女')),
                      DropdownMenuItem(value: 'other', child: Text('其他')),
                    ],
                    onChanged: _isEditing 
                      ? (value) {
                          setState(() {
                            _gender = value ?? 'male';
                          });
                        } 
                      : null,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '年龄段',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _ageGroup,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: '0_12', child: Text('0-12岁')),
                      DropdownMenuItem(value: '13_17', child: Text('13-17岁')),
                      DropdownMenuItem(value: '18_30', child: Text('18-30岁')),
                      DropdownMenuItem(value: '31_45', child: Text('31-45岁')),
                      DropdownMenuItem(value: '46_60', child: Text('46-60岁')),
                      DropdownMenuItem(value: '60_plus', child: Text('60岁以上')),
                    ],
                    onChanged: _isEditing 
                      ? (value) {
                          setState(() {
                            _ageGroup = value ?? '18_30';
                          });
                        } 
                      : null,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '身高 (cm)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _isEditing ? () => _showHeightPicker(context) : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: _isEditing ? null : Colors.grey.shade100,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_height.toInt()} cm',
                            style: TextStyle(
                              fontSize: 16,
                              color: _isEditing ? null : Colors.grey.shade600,
                            ),
                          ),
                          _isEditing ? const Icon(Icons.arrow_drop_down) : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '体重 (kg)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _isEditing ? () => _showWeightPicker(context) : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: _isEditing ? null : Colors.grey.shade100,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_weight.toInt()} kg',
                            style: TextStyle(
                              fontSize: 16,
                              color: _isEditing ? null : Colors.grey.shade600,
                            ),
                          ),
                          _isEditing ? const Icon(Icons.arrow_drop_down) : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '职业',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _occupation,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'student', child: Text('学生')),
                DropdownMenuItem(value: 'office_worker', child: Text('办公室职员')),
                DropdownMenuItem(value: 'labor', child: Text('体力劳动者')),
                DropdownMenuItem(value: 'self_employed', child: Text('自由职业')),
                DropdownMenuItem(value: 'retired', child: Text('退休人员')),
                DropdownMenuItem(value: 'other', child: Text('其他')),
              ],
              onChanged: _isEditing 
                ? (value) {
                    setState(() {
                      _occupation = value ?? 'other';
                    });
                  } 
                : null,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              '是否设为主要档案',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const Spacer(),
            Switch(
              value: _isPrimary,
              onChanged: _isEditing
                ? (value) {
                    setState(() {
                      _isPrimary = value;
                    });
                  }
                : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthStatusSection() {
    return FormSectionCard(
      title: '健康状况',
      children: [
        _buildMutuallyExclusiveChips(
          '慢性疾病',
          _chronicDiseaseOptions,
          _healthStatus['chronicDiseases'] as List<dynamic>? ?? <String>[],
          _getChronicDiseaseText,
          (values) {
            setState(() {
              _healthStatus['chronicDiseases'] = values;
            });
          },
          'none',
        ),
        const SizedBox(height: 16),
        _buildMutuallyExclusiveChips(
          '特殊状态',
          _specialConditionOptions,
          _healthStatus['specialConditions'] as List<dynamic>? ?? <String>[],
          _getSpecialConditionText,
          (values) {
            setState(() {
              _healthStatus['specialConditions'] = values;
            });
          },
          'none',
        ),
      ],
    );
  }
  
  Widget _buildMutuallyExclusiveChips(
    String label,
    List<String> options,
    List<dynamic> selectedValues,
    String Function(String) getDisplayText,
    Function(List<String>) onChanged,
    String noneValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValues.contains(option);
            return FilterChip(
              label: Text(getDisplayText(option)),
              selected: isSelected,
              onSelected: (selected) {
                final List<String> values = selectedValues.map((e) => e.toString()).toList();
                
                if (option == noneValue) {
                  // 如果选择了"无"选项，清除其他所有选项
                  if (selected) {
                    values.clear();
                    values.add(noneValue);
                  } else {
                    values.remove(noneValue);
                  }
                } else {
                  // 如果选择了其他选项，移除"无"选项
                  if (selected) {
                    values.remove(noneValue);
                    if (!values.contains(option)) {
                      values.add(option);
                    }
                  } else {
                    values.remove(option);
                    // 如果没有选择任何选项，自动选择"无"
                    if (values.isEmpty) {
                      values.add(noneValue);
                    }
                  }
                }
                
                onChanged(values);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDietaryPreferencesSection() {
    return FormSectionCard(
      title: '饮食偏好',
      children: [
        ListTile(
          title: const Text('是否素食'),
          trailing: Switch(
            value: _dietaryPreferences['isVegetarian'] as bool,
            onChanged: (value) {
              setState(() {
                _dietaryPreferences['isVegetarian'] = value;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        CustomChipInput(
          label: '口味偏好',
          options: _tastePreferenceOptions,
          selectedValues: (_dietaryPreferences['tastePreference'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? <String>[],
          getDisplayText: _getTastePreferenceText,
          onChanged: (values) {
            setState(() {
              _dietaryPreferences['tastePreference'] = values;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildFoodItemsSection(
          '忌口食材',
          _dietaryPreferences['taboos'] as List<dynamic>? ?? <String>[],
          (List<String> values) {
            setState(() {
              _dietaryPreferences['taboos'] = values;
            });
          },
          ['虾', '蟹', '牛肉', '猪肉', '海鲜', '花生', '豆制品', '麸质', '奶制品'],
        ),
        const SizedBox(height: 16),
        _buildFoodItemsSection(
          '过敏食材',
          _dietaryPreferences['allergies'] as List<dynamic>? ?? <String>[],
          (List<String> values) {
            setState(() {
              _dietaryPreferences['allergies'] = values;
            });
          },
          ['花生', '乳制品', '鸡蛋', '贝类', '坚果', '大豆', '小麦', '芝麻', '鱼'],
        ),
      ],
    );
  }

  Widget _buildFoodItemsSection(
    String title,
    List<dynamic> initialItems,
    Function(List<String>) onChanged,
    List<String> suggestions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ...suggestions.map((item) {
              final isSelected = initialItems.contains(item);
              return FilterChip(
                label: Text(item),
                selected: isSelected,
                onSelected: (selected) {
                  final List<String> newList = initialItems.map((e) => e.toString()).toList();
                  if (selected) {
                    if (!newList.contains(item)) {
                      newList.add(item);
                    }
                  } else {
                    newList.remove(item);
                  }
                  onChanged(newList);
                },
              );
            }),
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: const Text('添加'),
              onPressed: () => _showAddItemDialog(context, title, initialItems, onChanged),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (initialItems.isNotEmpty)
          Wrap(
            spacing: 8,
            children: initialItems.map<Widget>((item) {
              return Chip(
                label: Text(item.toString()),
                onDeleted: () {
                  final List<String> newList = initialItems.map((e) => e.toString()).toList();
                  newList.remove(item.toString());
                  onChanged(newList);
                },
              );
            }).toList(),
          ),
      ],
    );
  }
  
  void _showAddItemDialog(
    BuildContext context,
    String title,
    List<dynamic> currentItems,
    Function(List<String>) onChanged,
  ) {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('添加$title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: '请输入$title',
              border: const OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  final List<String> newList = currentItems.map((e) => e.toString()).toList();
                  if (!newList.contains(controller.text.trim())) {
                    newList.add(controller.text.trim());
                    onChanged(newList);
                  }
                }
                Navigator.pop(context);
              },
              child: const Text('添加'),
            ),
          ],
        );
      },
    );
  }
  
  void _showHeightPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: const Text(
                  '选择身高',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _height = (index + 140).toDouble();
                    });
                  },
                  children: List<Widget>.generate(81, (index) {
                    return Center(
                      child: Text(
                        '${index + 140} cm',
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }),
                  scrollController: FixedExtentScrollController(
                    initialItem: (_height.toInt() - 140).clamp(0, 80),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('确定'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showWeightPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: const Text(
                  '选择体重',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _weight = (index + 30).toDouble();
                    });
                  },
                  children: List<Widget>.generate(171, (index) {
                    return Center(
                      child: Text(
                        '${index + 30} kg',
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }),
                  scrollController: FixedExtentScrollController(
                    initialItem: (_weight.toInt() - 30).clamp(0, 170),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('确定'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLifestyleSection() {
    return FormSectionCard(
      title: '生活方式',
      children: [
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text('是否吸烟'),
                trailing: Switch(
                  value: _lifestyle['smoking'] as bool,
                  onChanged: (value) {
                    setState(() {
                      _lifestyle['smoking'] = value;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                title: const Text('是否饮酒'),
                trailing: Switch(
                  value: _lifestyle['drinking'] as bool,
                  onChanged: (value) {
                    setState(() {
                      _lifestyle['drinking'] = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: '平均睡眠时间 (小时)',
          initialValue: _lifestyle['sleepDuration'].toString(),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入睡眠时间';
            }
            final hours = double.tryParse(value);
            if (hours == null || hours < 0 || hours > 24) {
              return '请输入有效的睡眠时间';
            }
            return null;
          },
          onSaved: (value) {
            _lifestyle['sleepDuration'] = double.parse(value ?? '8.0');
          },
        ),
        const SizedBox(height: 16),
        CustomDropdown<String>(
          label: '运动频率',
          value: _lifestyle['exerciseFrequency'] as String,
          items: _exerciseFrequencyOptions.map((frequency) {
            return DropdownMenuItem(
              value: frequency,
              child: Text(_getExerciseFrequencyText(frequency)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _lifestyle['exerciseFrequency'] = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildGoalsSection() {
    return FormSectionCard(
      title: '营养目标',
      children: [
        CustomChipInput(
          label: '选择目标',
          options: _nutritionGoalOptions,
          selectedValues: _nutritionGoals,
          getDisplayText: _getNutritionGoalText,
          onChanged: (values) {
            setState(() {
              _nutritionGoals = values;
            });
          },
        ),
        const SizedBox(height: 16),
        ListTile(
          title: const Text('设为主要档案'),
          trailing: Switch(
            value: _isPrimary,
            onChanged: (value) {
              setState(() {
                _isPrimary = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      initialValue: initialValue,
      enabled: _isEditing,
      keyboardType: keyboardType,
      validator: _isEditing ? validator : null,
      onSaved: _isEditing ? onSaved : null,
    );
  }

  String _getGenderText(String gender) {
    switch (gender) {
      case 'male':
        return '男';
      case 'female':
        return '女';
      case 'other':
        return '其他';
      default:
        return '未知';
    }
  }

  String _getAgeGroupText(String ageGroup) {
    switch (ageGroup) {
      case 'under_18':
        return '18岁以下';
      case '18_30':
        return '18-30岁';
      case '31_45':
        return '31-45岁';
      case '46_60':
        return '46-60岁';
      case 'above_60':
        return '60岁以上';
      default:
        return '未知';
    }
  }

  String _getOccupationText(String occupation) {
    switch (occupation) {
      case 'student':
        return '学生';
      case 'office_worker':
        return '办公室职员';
      case 'physical_worker':
        return '体力劳动者';
      case 'retired':
        return '退休人员';
      case 'other':
        return '其他';
      default:
        return '未设置';
    }
  }

  String _getChronicDiseaseText(String disease) {
    switch (disease) {
      case 'hypertension':
        return '高血压';
      case 'diabetes':
        return '糖尿病';
      case 'gout':
        return '痛风';
      case 'heart_disease':
        return '心脏病';
      case 'none':
        return '无';
      default:
        return disease;
    }
  }

  String _getSpecialConditionText(String condition) {
    switch (condition) {
      case 'pregnancy':
        return '备孕/怀孕';
      case 'lactation':
        return '哺乳期';
      case 'menopause':
        return '更年期';
      case 'none':
        return '无';
      default:
        return condition;
    }
  }

  String _getTastePreferenceText(String taste) {
    switch (taste) {
      case 'light':
        return '清淡';
      case 'spicy':
        return '辛辣';
      case 'sour':
        return '酸';
      case 'sweet':
        return '甜';
      case 'salty':
        return '咸';
      default:
        return taste;
    }
  }

  String _getExerciseFrequencyText(String frequency) {
    switch (frequency) {
      case 'none':
        return '不运动';
      case 'occasional':
        return '偶尔运动';
      case 'regular':
        return '每周3-5次';
      case 'frequent':
        return '每周5次以上';
      case 'daily':
        return '每天运动';
      default:
        return '未设置';
    }
  }

  String _getNutritionGoalText(String goal) {
    switch (goal) {
      case 'weight_loss':
        return '减重';
      case 'weight_gain':
        return '增重';
      case 'muscle_gain':
        return '增肌';
      case 'blood_sugar_control':
        return '控制血糖';
      case 'blood_pressure_control':
        return '控制血压';
      case 'immunity_boost':
        return '增强免疫力';
      case 'energy_boost':
        return '提高能量';
      case 'general_health':
        return '保持健康';
      default:
        return goal;
    }
  }
}
