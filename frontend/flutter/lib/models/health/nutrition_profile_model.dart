import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class NutritionProfile {
  final String id;
  final String userId;
  final String profileName;
  final String gender;
  final String ageGroup;
  final double height;
  final double weight;
  final Map<String, String>? region;
  final String? occupation;
  final Map<String, dynamic> healthStatus;
  final Map<String, dynamic> dietaryPreferences;
  final Map<String, dynamic> lifestyle;
  final List<String> nutritionGoals;
  final bool isPrimary;
  final DateTime createdAt;
  final DateTime updatedAt;

  NutritionProfile({
    required this.id,
    required this.userId,
    required this.profileName,
    required this.gender,
    required this.ageGroup,
    required this.height,
    required this.weight,
    this.region,
    this.occupation,
    required this.healthStatus,
    required this.dietaryPreferences,
    required this.lifestyle,
    required this.nutritionGoals,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
  });

  // 从JSON创建健康档案
  factory NutritionProfile.fromJson(Map<String, dynamic> json) {
    debugPrint('开始转换JSON数据: $json');  // 添加调试日志
    
    // 确保profile名称字段存在
    String profileName = '';
    if (json['profileName'] != null && json['profileName'].toString().trim().isNotEmpty) {
      profileName = json['profileName'].toString();
    } else if (json['nickname'] != null && json['nickname'].toString().trim().isNotEmpty) {
      profileName = json['nickname'].toString();
    } else if (json['profilekname'] != null && json['profilekname'].toString().trim().isNotEmpty) {
      profileName = json['profilekname'].toString();
    } else if (json['name'] != null && json['name'].toString().trim().isNotEmpty) {
      profileName = json['name'].toString();
    }
    
    // 如果仍然没有名称，使用默认值
    if (profileName.isEmpty) {
      profileName = '档案 ${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
      debugPrint('未找到有效的档案名称，使用默认名称: $profileName');
    }
    
    final profile = NutritionProfile(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '',
      profileName: profileName,
      gender: json['gender'] ?? 'other',
      ageGroup: json['ageGroup'] ?? '18_30',
      height: json['height'] != null ? double.parse(json['height'].toString()) : 170.0,
      weight: json['weight'] != null ? double.parse(json['weight'].toString()) : 60.0,
      region: json['region'] != null ? Map<String, String>.from(json['region']) : null,
      occupation: json['occupation'],
      healthStatus: json['healthStatus'] ?? {
        'chronicDiseases': [],
        'specialConditions': [],
      },
      dietaryPreferences: json['dietaryPreferences'] ?? {
        'isVegetarian': false,
        'tastePreference': [],
        'taboos': [],
        'cuisine': 'chinese',
        'allergies': [],
      },
      lifestyle: json['lifestyle'] ?? {
        'smoking': false,
        'drinking': false,
        'sleepDuration': 8,
        'exerciseFrequency': 'occasional',
      },
      nutritionGoals: json['nutritionGoals'] != null 
          ? List<String>.from(json['nutritionGoals'])
          : ['general_health'],
      isPrimary: json['isPrimary'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
    
    debugPrint('转换后的档案对象: ${profile.toJson()}');  // 添加调试日志
    return profile;
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'userId': userId,
      'profileName': profileName.trim(),  // 确保去除空格并一定会传递此字段
      'gender': gender,
      'ageGroup': ageGroup,
      'height': height,
      'weight': weight,
      'region': region,
      'occupation': occupation,
      'healthStatus': healthStatus,
      'dietaryPreferences': dietaryPreferences,
      'lifestyle': lifestyle,
      'nutritionGoals': nutritionGoals,
      'isPrimary': isPrimary,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
    
    // 确保职业字段使用后端允许的枚举值
    if (data['occupation'] == 'labor' || data['occupation'] == 'physical_worker') {
      data['occupation'] = 'physical_worker'; // 将labor映射为physical_worker
    }
    
    // 确保profileName字段不为空
    if (data['profileName'] == null || data['profileName'].toString().trim().isEmpty) {
      data['profileName'] = 'Profile_${DateTime.now().millisecondsSinceEpoch}';
    }
    
    debugPrint('NutritionProfile.toJson数据: $data');
    debugPrint('确认profileName字段: ${data['profileName']}');
    return data;
  }

  // 复制健康档案并修改特定字段
  NutritionProfile copyWith({
    String? id,
    String? userId,
    String? profileName,
    String? gender,
    String? ageGroup,
    double? height,
    double? weight,
    Map<String, String>? region,
    String? occupation,
    Map<String, dynamic>? healthStatus,
    Map<String, dynamic>? dietaryPreferences,
    Map<String, dynamic>? lifestyle,
    List<String>? nutritionGoals,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NutritionProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      profileName: profileName ?? this.profileName,
      gender: gender ?? this.gender,
      ageGroup: ageGroup ?? this.ageGroup,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      region: region ?? this.region,
      occupation: occupation ?? this.occupation,
      healthStatus: healthStatus ?? this.healthStatus,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      lifestyle: lifestyle ?? this.lifestyle,
      nutritionGoals: nutritionGoals ?? this.nutritionGoals,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // 计算BMI
  double calculateBMI() {
    if (height <= 0) {
      return 0;
    }
    // BMI = 体重(kg) / (身高(m)^2)
    return weight / ((height / 100) * (height / 100));
  }

  // 获取BMI类别
  String getBMICategory() {
    final bmi = calculateBMI();
    if (bmi <= 0) return '未知';
    
    if (bmi < 18.5) {
      return '偏瘦';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return '正常';
    } else if (bmi >= 25 && bmi < 29.9) {
      return '超重';
    } else {
      return '肥胖';
    }
  }

  // 格式化创建日期
  String formattedCreationDate() {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
  }

  // 获取年龄段显示文本
  String get ageGroupText {
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

  // 获取性别显示文本
  String get genderText {
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

  // 获取职业显示文本
  String get occupationText {
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

  // 获取运动频率显示文本
  String get exerciseFrequencyText {
    switch (lifestyle['exerciseFrequency']) {
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

  // 获取营养目标显示文本
  List<String> get nutritionGoalsText {
    return nutritionGoals.map((goal) {
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
    }).toList();
  }

  // 获取慢性病显示文本
  List<String> get chronicDiseasesText {
    return (healthStatus['chronicDiseases'] as List<dynamic>).map((disease) {
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
          return disease.toString();
      }
    }).toList();
  }

  // 获取特殊状态显示文本
  List<String> get specialConditionsText {
    return (healthStatus['specialConditions'] as List<dynamic>).map((condition) {
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
          return condition.toString();
      }
    }).toList();
  }
}
