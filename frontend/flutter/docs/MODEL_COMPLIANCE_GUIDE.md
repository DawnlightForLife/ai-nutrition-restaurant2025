# Flutter前端数据模型适配指南

## 概述

本指南旨在确保Flutter前端开发严格遵守后端已冻结的MongoDB数据模型结构，避免数据不一致和接口调用错误。所有前端模型、表单和数据处理必须与后端模型保持一致。

## 目录

1. [Model类实现规范](#model类实现规范)
2. [表单字段映射](#表单字段映射)
3. [API请求处理](#api请求处理)
4. [枚举值处理](#枚举值处理)
5. [必填字段验证](#必填字段验证)
6. [关系引用处理](#关系引用处理)
7. [敏感数据处理](#敏感数据处理)
8. [常见问题](#常见问题)

## Model类实现规范

所有前端模型类必须严格映射后端模型结构。一个标准的Model类应包含：

1. 字段定义
2. 构造函数
3. fromJson方法
4. toJson方法
5. 复制方法（可选）

### 示例：用户模型

```dart
class User {
  final String? id;
  final String phone;  // 必填，唯一
  final String? nickname;
  final String? email;
  final String? avatarUrl;
  final double? height;
  final double? weight;
  final int? age;
  final String? gender;  // 枚举: male, female, other
  final String role;  // 枚举: user, admin, nutritionist, merchant
  final String activeRole;  // 枚举: user, nutritionist, merchant
  final Region? region;
  final DietaryPreferences? dietaryPreferences;
  final HealthData? healthData;
  final String? accountStatus;  // 枚举: active, suspended, deactivated, pending_deletion

  // 构造函数
  User({
    this.id,
    required this.phone,
    this.nickname,
    this.email,
    this.avatarUrl,
    this.height,
    this.weight,
    this.age,
    this.gender = 'other',
    required this.role,
    required this.activeRole,
    this.region,
    this.dietaryPreferences,
    this.healthData,
    this.accountStatus = 'active',
  });

  // 从JSON构造
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      phone: json['phone'],
      nickname: json['nickname'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      age: json['age'],
      gender: json['gender'] ?? 'other',
      role: json['role'] ?? 'user',
      activeRole: json['active_role'] ?? 'user',
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
      dietaryPreferences: json['dietary_preferences'] != null 
          ? DietaryPreferences.fromJson(json['dietary_preferences']) 
          : null,
      healthData: json['health_data'] != null 
          ? HealthData.fromJson(json['health_data']) 
          : null,
      accountStatus: json['account_status'] ?? 'active',
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'nickname': nickname,
      'email': email,
      'avatar_url': avatarUrl,
      'height': height,
      'weight': weight,
      'age': age,
      'gender': gender,
      'role': role,
      'active_role': activeRole,
      'region': region?.toJson(),
      'dietary_preferences': dietaryPreferences?.toJson(),
      'health_data': healthData?.toJson(),
      'account_status': accountStatus,
    };
  }
  
  // 复制方法
  User copyWith({
    String? id,
    String? phone,
    String? nickname,
    String? email,
    String? avatarUrl,
    double? height,
    double? weight,
    int? age,
    String? gender,
    String? role,
    String? activeRole,
    Region? region,
    DietaryPreferences? dietaryPreferences,
    HealthData? healthData,
    String? accountStatus,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      activeRole: activeRole ?? this.activeRole,
      region: region ?? this.region,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      healthData: healthData ?? this.healthData,
      accountStatus: accountStatus ?? this.accountStatus,
    );
  }
}
```

### 嵌套对象示例

```dart
class Region {
  final String? province;
  final String? city;
  
  Region({this.province, this.city});
  
  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      province: json['province'],
      city: json['city'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'province': province,
      'city': city,
    };
  }
}
```

## 表单字段映射

表单字段必须与模型字段严格对应：

### 示例：用户基本信息表单

```dart
class UserProfileForm extends StatefulWidget {
  final User? user;
  final Function(User) onSubmit;
  
  UserProfileForm({this.user, required this.onSubmit});
  
  @override
  _UserProfileFormState createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nicknameController;
  late TextEditingController _emailController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;
  String _gender = 'other';
  
  @override
  void initState() {
    super.initState();
    // 初始化控制器并填充现有数据
    _nicknameController = TextEditingController(text: widget.user?.nickname ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _heightController = TextEditingController(text: widget.user?.height?.toString() ?? '');
    _weightController = TextEditingController(text: widget.user?.weight?.toString() ?? '');
    _ageController = TextEditingController(text: widget.user?.age?.toString() ?? '');
    _gender = widget.user?.gender ?? 'other';
  }
  
  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // 创建更新后的用户对象，保持其他字段不变
      final updatedUser = (widget.user ?? User(
        phone: '',
        role: 'user',
        activeRole: 'user',
      )).copyWith(
        nickname: _nicknameController.text,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        height: _heightController.text.isNotEmpty 
            ? double.tryParse(_heightController.text) 
            : null,
        weight: _weightController.text.isNotEmpty 
            ? double.tryParse(_weightController.text) 
            : null,
        age: _ageController.text.isNotEmpty 
            ? int.tryParse(_ageController.text) 
            : null,
        gender: _gender,
      );
      
      widget.onSubmit(updatedUser);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nicknameController,
            decoration: InputDecoration(labelText: '昵称'),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: '邮箱'),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                // 验证邮箱格式，匹配后端模型的验证规则
                final emailRegex = RegExp(r'^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$');
                if (!emailRegex.hasMatch(value)) {
                  return '请输入有效的邮箱地址';
                }
              }
              return null;
            },
          ),
          TextFormField(
            controller: _heightController,
            decoration: InputDecoration(labelText: '身高 (cm)'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: _weightController,
            decoration: InputDecoration(labelText: '体重 (kg)'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: _ageController,
            decoration: InputDecoration(labelText: '年龄'),
            keyboardType: TextInputType.number,
          ),
          DropdownButtonFormField<String>(
            value: _gender,
            items: [
              DropdownMenuItem(value: 'male', child: Text('男')),
              DropdownMenuItem(value: 'female', child: Text('女')),
              DropdownMenuItem(value: 'other', child: Text('其他')),
            ],
            onChanged: (value) {
              setState(() {
                _gender = value!;
              });
            },
            decoration: InputDecoration(labelText: '性别'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('保存'),
          ),
        ],
      ),
    );
  }
}
```

## API请求处理

API请求必须严格使用模型的toJson()和fromJson()方法。

### 示例：用户API服务

```dart
class UserApiService {
  final ApiService _apiService = ApiService();
  
  // 获取当前用户信息
  Future<User> getCurrentUser() async {
    final response = await _apiService.get('/users/me');
    return User.fromJson(response['data']);
  }
  
  // 更新用户信息
  Future<User> updateUserProfile(User user) async {
    final response = await _apiService.put(
      '/users/profile', 
      body: user.toJson(),
    );
    return User.fromJson(response['data']);
  }
  
  // 用户注册
  Future<User> registerUser({
    required String phone, 
    required String password, 
    String? nickname,
  }) async {
    final response = await _apiService.post(
      '/users/register', 
      body: {
        'phone': phone,
        'password': password,
        'nickname': nickname,
      },
    );
    return User.fromJson(response['data']);
  }
}
```

## 枚举值处理

枚举值必须严格匹配后端模型定义。

### 示例：定义枚举常量

```dart
// 用户性别枚举
class GenderOptions {
  static const String male = 'male';
  static const String female = 'female';
  static const String other = 'other';
  
  static const List<String> values = [male, female, other];
  
  static const Map<String, String> displayNames = {
    male: '男',
    female: '女',
    other: '其他'
  };
  
  static String getDisplayName(String value) {
    return displayNames[value] ?? '其他';
  }
}

// 用户角色枚举
class UserRoles {
  static const String user = 'user';
  static const String admin = 'admin';
  static const String nutritionist = 'nutritionist';
  static const String merchant = 'merchant';
  
  static const List<String> values = [user, admin, nutritionist, merchant];
  
  static const Map<String, String> displayNames = {
    user: '用户',
    admin: '管理员',
    nutritionist: '营养师',
    merchant: '商家'
  };
  
  static String getDisplayName(String value) {
    return displayNames[value] ?? '用户';
  }
}
```

## 必填字段验证

前端表单必须验证所有后端必填字段。

### 示例：必填字段验证工具类

```dart
class FormValidator {
  // 手机号验证
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入手机号';
    }
    // 验证格式：1开头的11位数字
    final RegExp phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    if (!phoneRegex.hasMatch(value)) {
      return '请输入有效的手机号';
    }
    return null;
  }
  
  // 邮箱验证（可选字段）
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // 邮箱是可选的
    }
    final RegExp emailRegex = RegExp(r'^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$');
    if (!emailRegex.hasMatch(value)) {
      return '请输入有效的邮箱地址';
    }
    return null;
  }
  
  // 密码验证
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    if (value.length < 6) {
      return '密码长度不能少于6位';
    }
    return null;
  }
}
```

## 关系引用处理

处理模型关系引用时，应使用ID引用而非嵌入完整对象。

### 示例：处理引用关系

```dart
// 营养档案模型示例 - 处理引用关系
class NutritionProfile {
  final String? id;
  final String userId;  // 引用User模型的ID
  final String name;
  final String? gender;
  final int? age;
  final double? height;
  final double? weight;
  
  // 关联的健康数据ID列表
  final List<String> relatedHealthDataIds;
  
  // 关联的AI推荐历史ID列表
  final List<String> recommendationHistoryIds;
  
  NutritionProfile({
    this.id,
    required this.userId,
    required this.name,
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.relatedHealthDataIds = const [],
    this.recommendationHistoryIds = const [],
  });
  
  factory NutritionProfile.fromJson(Map<String, dynamic> json) {
    return NutritionProfile(
      id: json['_id'],
      userId: json['user_id'],
      name: json['name'],
      gender: json['gender'],
      age: json['age'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      relatedHealthDataIds: json['related_health_data'] != null 
          ? List<String>.from(json['related_health_data']) 
          : [],
      recommendationHistoryIds: json['recommendation_history'] != null 
          ? List<String>.from(json['recommendation_history']) 
          : [],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'related_health_data': relatedHealthDataIds,
      'recommendation_history': recommendationHistoryIds,
    };
  }
}
```

## 敏感数据处理

前端应根据后端模型的敏感度级别处理数据显示。

### 示例：敏感数据处理

```dart
// 根据敏感度处理数据显示的工具类
class SensitiveDataHelper {
  // 敏感度级别
  static const int HIGH_SENSITIVITY = 1;
  static const int MEDIUM_SENSITIVITY = 2;
  static const int LOW_SENSITIVITY = 3;
  
  // 根据敏感度返回处理后的数据
  static String processSensitiveString(String? value, int sensitivityLevel, bool isAuthorized) {
    if (value == null || value.isEmpty) return '';
    
    // 未授权用户无法查看高度敏感数据
    if (sensitivityLevel == HIGH_SENSITIVITY && !isAuthorized) {
      return '***';
    }
    
    // 中度敏感数据部分模糊处理
    if (sensitivityLevel == MEDIUM_SENSITIVITY && !isAuthorized) {
      if (value.length <= 2) return '**';
      return value.substring(0, 1) + '*' * (value.length - 2) + value.substring(value.length - 1);
    }
    
    // 低敏感度或授权用户可以完整查看
    return value;
  }
  
  // 处理手机号显示
  static String formatPhone(String phone, bool isAuthorized) {
    if (!isAuthorized) {
      if (phone.length == 11) {
        return phone.substring(0, 3) + '****' + phone.substring(7);
      }
    }
    return phone;
  }
}
```

## 常见问题

### 1. API返回字段与模型不一致怎么办？

API返回字段应当与模型一致。若确实存在不一致，应通过适配层处理：

```dart
// API适配层示例
class ApiResponseAdapter {
  // 将API响应适配为前端模型
  static User adaptUserResponse(Map<String, dynamic> apiResponse) {
    // 处理字段名差异
    return User(
      id: apiResponse['_id'] ?? apiResponse['id'],
      phone: apiResponse['phone'],
      nickname: apiResponse['nickname'] ?? apiResponse['name'],
      email: apiResponse['email'],
      // 其他字段适配...
    );
  }
}
```

### 2. 模型结构更新了如何处理？

当数据模型需要更新时，需要按照项目冻结规范流程进行，更新后同步修改前端模型类。务必保持版本一致性。

### 3. 如何处理后端验证错误？

后端验证错误应在UI中显示给用户：

```dart
try {
  await userApiService.updateUserProfile(user);
  // 成功处理
} catch (e) {
  if (e is ApiException) {
    // 显示后端验证错误
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message)),
    );
  } else {
    // 其他错误处理
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('发生未知错误')),
    );
  }
}
``` 