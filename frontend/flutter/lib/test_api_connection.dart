import 'package:flutter/material.dart';
import 'repositories/nutrition_profile_repository_impl.dart';
import 'models/nutrition_profile_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 创建Repository实例
  final repository = NutritionProfileRepositoryImpl();
  
  // 测试获取档案列表
  print('测试获取营养档案列表...');
  try {
    final profiles = await repository.getAllProfiles();
    print('成功获取 ${profiles.length} 个档案');
    for (var profile in profiles) {
      print('- ${profile.profileName} (ID: ${profile.id})');
    }
  } catch (e) {
    print('获取档案列表失败: $e');
  }
  
  // 测试创建新档案
  print('\n测试创建新档案...');
  try {
    final newProfile = NutritionProfile(
      userId: 'test_user_123',
      profileName: '测试档案',
      gender: 'male',
      ageGroup: '18to30',
      height: 175,
      weight: 70,
      activityLevel: 'moderate',
      nutritionGoals: ['balancedNutrition'],
      dailyCalorieTarget: 2200,
      hydrationGoal: 2000,
    );
    
    final created = await repository.createProfile(newProfile);
    print('成功创建档案: ${created.profileName} (ID: ${created.id})');
  } catch (e) {
    print('创建档案失败: $e');
  }
  
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('API联调测试')),
        body: const Center(
          child: Text('查看控制台输出以了解API测试结果'),
        ),
      ),
    );
  }
}