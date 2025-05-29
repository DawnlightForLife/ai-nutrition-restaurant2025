import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 营养档案编辑页
class NutritionProfileEditor extends ConsumerStatefulWidget {
  const NutritionProfileEditor({super.key});

  @override
  ConsumerState<NutritionProfileEditor> createState() => _NutritionProfileEditorState();
}

class _NutritionProfileEditorState extends ConsumerState<NutritionProfileEditor> {
  final _formKey = GlobalKey<FormState>();

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
      body: Form(
        key: _formKey,
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('基本信息', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              // TODO: 添加基本信息表单字段
              
              SizedBox(height: 24),
              Text('饮食偏好', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              // TODO: 添加饮食偏好表单字段
              
              SizedBox(height: 24),
              Text('健康状况', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              // TODO: 添加健康状况表单字段
              
              SizedBox(height: 24),
              Text('生活习惯', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              // TODO: 添加生活习惯表单字段
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // TODO: 保存营养档案
    }
  }
}