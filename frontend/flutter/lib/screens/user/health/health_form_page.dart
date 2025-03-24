import 'package:flutter/material.dart';

class HealthFormPage extends StatefulWidget {
  const HealthFormPage({Key? key}) : super(key: key);

  @override
  _HealthFormPageState createState() => _HealthFormPageState();
}

class _HealthFormPageState extends State<HealthFormPage> {
  final _formKey = GlobalKey<FormState>();

  String gender = '男';
  int age = 25;
  double height = 170;
  double weight = 65;
  String activity = '中等';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("健康数据填写")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: '年龄（岁）'),
                keyboardType: TextInputType.number,
                onSaved: (value) => age = int.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '身高（cm）'),
                keyboardType: TextInputType.number,
                onSaved: (value) => height = double.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '体重（kg）'),
                keyboardType: TextInputType.number,
                onSaved: (value) => weight = double.parse(value!),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: '性别'),
                value: gender,
                items: ['男', '女'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) => setState(() => gender = value as String),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: '日常运动量'),
                value: activity,
                items: ['轻度', '中等', '剧烈'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) => setState(() => gender = value as String),

              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("提交"),
                onPressed: () {
                  _formKey.currentState!.save();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("健康数据已保存（待接入后端）")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
