import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme/yuanqi_colors.dart';
import '../home/home_page.dart';

class ProfileCompletionPage extends ConsumerStatefulWidget {
  const ProfileCompletionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileCompletionPage> createState() => _ProfileCompletionPageState();
}

class _ProfileCompletionPageState extends ConsumerState<ProfileCompletionPage> {
  final _formKey = GlobalKey<FormState>();
  final _realNameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  
  String _selectedGender = 'male';
  DateTime _selectedBirthDate = DateTime.now().subtract(const Duration(days: 365 * 25));
  String _selectedHealthGoal = 'maintain';
  
  final List<Map<String, dynamic>> _healthGoals = [
    {'value': 'lose_weight', 'label': '减脂瘦身', 'icon': Icons.trending_down},
    {'value': 'gain_muscle', 'label': '增肌塑形', 'icon': Icons.fitness_center},
    {'value': 'maintain', 'label': '保持健康', 'icon': Icons.favorite},
    {'value': 'improve_health', 'label': '改善体质', 'icon': Icons.healing},
  ];
  
  @override
  void dispose() {
    _realNameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('完善个人资料'),
        actions: [
          TextButton(
            onPressed: () {
              // 跳过资料完善
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
            child: const Text(
              '跳过',
              style: TextStyle(color: YuanqiColors.textSecondary),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 提示文字
              const Text(
                '为了提供更精准的营养建议',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: YuanqiColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '请完善您的基本信息',
                style: TextStyle(
                  fontSize: 14,
                  color: YuanqiColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              
              // 真实姓名
              _buildTextField(
                controller: _realNameController,
                label: '真实姓名',
                hint: '请输入您的真实姓名',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入真实姓名';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // 性别选择
              _buildGenderSelection(),
              const SizedBox(height: 24),
              
              // 出生日期
              _buildBirthDatePicker(),
              const SizedBox(height: 24),
              
              // 身高体重
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _heightController,
                      label: '身高',
                      hint: '厘米',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入身高';
                        }
                        final height = double.tryParse(value);
                        if (height == null || height < 50 || height > 250) {
                          return '请输入有效身高';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _weightController,
                      label: '体重',
                      hint: '公斤',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入体重';
                        }
                        final weight = double.tryParse(value);
                        if (weight == null || weight < 20 || weight > 200) {
                          return '请输入有效体重';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // 健康目标
              const Text(
                '您的健康目标',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: YuanqiColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildHealthGoalSelection(),
              
              const SizedBox(height: 48),
              
              // 提交按钮
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: YuanqiColors.buttonGradient,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      '开始健康之旅',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: YuanqiColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: YuanqiColors.textHint),
            filled: true,
            fillColor: YuanqiColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: YuanqiColors.primaryOrange,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: YuanqiColors.error,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '性别',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: YuanqiColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption(
                value: 'male',
                label: '男',
                icon: Icons.male,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderOption(
                value: 'female',
                label: '女',
                icon: Icons.female,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildGenderOption({
    required String value,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedGender == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? YuanqiColors.primaryOrange.withOpacity(0.1) : YuanqiColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? YuanqiColors.primaryOrange : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? YuanqiColors.primaryOrange : YuanqiColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                color: isSelected ? YuanqiColors.primaryOrange : YuanqiColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBirthDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '出生日期',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: YuanqiColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showDatePicker,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: YuanqiColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selectedBirthDate.year}-${_selectedBirthDate.month.toString().padLeft(2, '0')}-${_selectedBirthDate.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: YuanqiColors.textPrimary,
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  color: YuanqiColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildHealthGoalSelection() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _healthGoals.length,
      itemBuilder: (context, index) {
        final goal = _healthGoals[index];
        final isSelected = _selectedHealthGoal == goal['value'];
        
        return InkWell(
          onTap: () {
            setState(() {
              _selectedHealthGoal = goal['value'] as String;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? YuanqiColors.primaryOrange.withOpacity(0.1) : YuanqiColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? YuanqiColors.primaryOrange : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  goal['icon'] as IconData,
                  color: isSelected ? YuanqiColors.primaryOrange : YuanqiColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  goal['label'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    color: isSelected ? YuanqiColors.primaryOrange : YuanqiColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedBirthDate,
            maximumDate: DateTime.now(),
            minimumDate: DateTime(1900),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _selectedBirthDate = newDate;
              });
            },
          ),
        ),
      ),
    );
  }
  
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // TODO(dev): 提交用户资料到后端
      
      // 跳转到主页
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }
}