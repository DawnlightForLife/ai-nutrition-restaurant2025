import 'package:flutter/material.dart';

class HealthDataPage extends StatefulWidget {
  const HealthDataPage({Key? key}) : super(key: key);

  @override
  _HealthDataPageState createState() => _HealthDataPageState();
}

class _HealthDataPageState extends State<HealthDataPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedExercise = '中';

  void _submitData() {
    double? height = double.tryParse(_heightController.text);
    double? weight = double.tryParse(_weightController.text);
    int? age = int.tryParse(_ageController.text);
    if (height == null || weight == null || age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请确保所有数据均为有效数字')),
      );
      return;
    }
    // 模拟提交数据
    print('提交数据: 身高: $height, 体重: $weight, 年龄: $age, 运动量: $_selectedExercise');
    // 跳转到 AI 营养推荐页面
    Navigator.pushNamed(context, '/recommendation');
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('健康数据录入'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildTextField(controller: _heightController, label: '身高 (cm)', icon: Icons.height),
            const SizedBox(height: 16),
            _buildTextField(controller: _weightController, label: '体重 (kg)', icon: Icons.monitor_weight),
            const SizedBox(height: 16),
            _buildTextField(controller: _ageController, label: '年龄', icon: Icons.cake),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedExercise,
              decoration: InputDecoration(
                labelText: '运动量',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: ['低', '中', '高']
                  .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedExercise = value);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitData,
              child: const Text('提交健康数据', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
