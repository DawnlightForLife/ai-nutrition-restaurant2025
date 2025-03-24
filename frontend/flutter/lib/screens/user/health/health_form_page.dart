import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';

// 假设你放在这个路径
import '../../../models/nutrition_profile.dart';

class HealthFormPage extends StatefulWidget {
  const HealthFormPage({super.key});

  @override
  State<HealthFormPage> createState() => _HealthFormPageState();
}

class _HealthFormPageState extends State<HealthFormPage> {
  final _formKey = GlobalKey<FormState>();

  // 文本输入控件
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // 下拉选择
  String? _selectedGender;
  String? _selectedAgeGroup;
  String? _selectedRegion;
  String? _selectedOccupation;
  String? _selectedActivityLevel;

  // 示例数据（将来替换为官方标准字典）
  final List<String> genders = ['男', '女'];
  final List<String> ageGroups = ['0-6岁', '7-12岁', '13-18岁', '19-29岁', '30-44岁', '45-59岁', '60岁以上'];
  final List<String> regions = ['北京', '上海', '广东', '江苏', '其他'];
  final List<String> occupations = ['学生', '教师', '医生', '程序员', '自由职业', '其他'];
  final List<String> activityLevels = ['低', '中', '高'];

  // 你当前登录用户的ID，实际项目中可能来自 Provider 或登录接口
  // 这里只是举例
  final String currentUserId = 'mockUser123';

  void _onSubmit() {
    // 验证表单
    if (_formKey.currentState!.validate()) {
      // 保存所有 TextFormField 的 onSaved 回调
      _formKey.currentState!.save();

      // 取文本框的值
      final name = _nameController.text.trim();
      final heightVal = double.tryParse(_heightController.text.trim()) ?? 0;
      final weightVal = double.tryParse(_weightController.text.trim()) ?? 0;

      // 构建 NutritionProfile 对象
      final profile = NutritionProfile(
        id: _generateRandomId(),        // 生成唯一ID
        ownerId: currentUserId,         // 关联当前用户
        name: name,                     // 档案名称
        gender: _selectedGender ?? '',  // 性别
        height: heightVal,
        weight: weightVal,
        activityLevel: _selectedActivityLevel ?? '',
        region: _selectedRegion ?? '',
        occupation: _selectedOccupation ?? '',
        ageGroup: _selectedAgeGroup ?? '',
        healthData: {}, // 你可以放其他额外健康字段
      );

      // 这里你可以把 profile 发送到后端接口
      // 先打印在控制台
      print('构建的 NutritionProfile: ${jsonEncode(profile.toJson())}');

      // 弹窗提示
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('提交成功'),
          content: Text('档案已保存：${profile.name}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            )
          ],
        ),
      );
    }
  }

  // 示例：生成随机 ID
  String _generateRandomId() {
    final random = Random();
    return 'profile_${random.nextInt(999999)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('营养档案填写')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 档案名称
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '档案名称（如：自己、孩子）'),
                validator: (val) => val!.isEmpty ? '请输入名称' : null,
              ),
              const SizedBox(height: 16),

              // 性别
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '性别'),
                items: genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (val) => setState(() => _selectedGender = val),
                validator: (val) => val == null ? '请选择性别' : null,
              ),
              const SizedBox(height: 16),

              // 年龄段
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '年龄段'),
                items: ageGroups.map((age) => DropdownMenuItem(value: age, child: Text(age))).toList(),
                onChanged: (val) => setState(() => _selectedAgeGroup = val),
                validator: (val) => val == null ? '请选择年龄段' : null,
              ),
              const SizedBox(height: 16),

              // 地区
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '地区'),
                items: regions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (val) => setState(() => _selectedRegion = val),
                validator: (val) => val == null ? '请选择地区' : null,
              ),
              const SizedBox(height: 16),

              // 职业
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '职业'),
                items: occupations.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                onChanged: (val) => setState(() => _selectedOccupation = val),
                validator: (val) => val == null ? '请选择职业' : null,
              ),
              const SizedBox(height: 16),

              // 身高
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '身高（cm）'),
                validator: (val) => val!.isEmpty ? '请输入身高' : null,
              ),
              const SizedBox(height: 16),

              // 体重
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '体重（kg）'),
                validator: (val) => val!.isEmpty ? '请输入体重' : null,
              ),
              const SizedBox(height: 16),

              // 运动量
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '运动量'),
                items: activityLevels.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                onChanged: (val) => setState(() => _selectedActivityLevel = val),
                validator: (val) => val == null ? '请选择运动量' : null,
              ),
              const SizedBox(height: 32),

              // 提交按钮
              ElevatedButton(
                onPressed: _onSubmit,
                child: const Text('保存档案'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
