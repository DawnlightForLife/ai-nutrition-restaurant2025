import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

/**
 * 营养健康档案模型
 * 
 * 用于存储用户的健康状况、饮食偏好和生活方式等信息
 * 作为个性化营养推荐和健康管理的基础数据模型
 */
class NutritionProfile {
  /// 档案唯一标识符
  final String id;

  /// 关联的用户ID
  final String userId;

  /// 档案名称，用于区分同一用户的多个健康档案
  final String profileName;

  /// 性别：male（男）、female（女）、other（其他）
  final String gender;

  /// 年龄段：0_18、18_30、30_45、45_60、60_plus等
  final String ageGroup;

  /// 身高，单位：厘米
  final double height;

  /// 体重，单位：千克
  final double weight;

  /// 地区信息，包含省份和城市
  final Map<String, String>? region;

  /// 职业类型，如office_worker（办公室工作者）、physical_worker（体力工作者）等
  final String? occupation;

  /// 健康状况信息，包括慢性疾病、特殊健康状况等
  final Map<String, dynamic> healthStatus;

  /// 饮食偏好信息，包括素食主义、口味偏好、忌口、喜好的菜系和过敏原等
  final Map<String, dynamic> dietaryPreferences;

  /// 生活方式信息，包括吸烟、饮酒、睡眠时长和运动频率等
  final Map<String, dynamic> lifestyle;

  /// 营养目标列表，如减肥、增肌、控制血糖等
  final List<String> nutritionGoals;

  /// 是否为主要档案（用户可能有多个档案，但只有一个主要档案）
  final bool isPrimary;

  /// 档案创建时间
  final DateTime createdAt;

  /// 档案最后更新时间
  final DateTime updatedAt;

  /**
   * 营养档案构造函数
   * 
   * @param id 档案ID，必须提供
   * @param userId 用户ID，必须提供
   * @param profileName 档案名称，必须提供
   * @param gender 性别，必须提供
   * @param ageGroup 年龄段，必须提供
   * @param height 身高，必须提供
   * @param weight 体重，必须提供
   * @param region 地区信息，可选
   * @param occupation 职业，可选
   * @param healthStatus 健康状况，必须提供
   * @param dietaryPreferences 饮食偏好，必须提供
   * @param lifestyle 生活方式，必须提供
   * @param nutritionGoals 营养目标，必须提供
   * @param isPrimary 是否为主要档案，必须提供
   * @param createdAt 创建时间，必须提供
   * @param updatedAt 更新时间，必须提供
   */
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

  /**
   * 从JSON创建健康档案
   * 
   * 将从服务器或本地存储获取的JSON数据转换为NutritionProfile对象
   * 包含参数检验和默认值设置，确保即使数据不完整也能创建有效对象
   * 
   * @param json 包含档案数据的Map
   * @return 根据JSON数据创建的NutritionProfile对象
   */
  factory NutritionProfile.fromJson(Map<String, dynamic> json) {
    debugPrint('开始转换JSON数据: $json'); // 添加调试日志

    // 确保profile名称字段存在
    String profileName = '';
    if (json['profileName'] != null &&
        json['profileName'].toString().trim().isNotEmpty) {
      profileName = json['profileName'].toString();
    } else if (json['nickname'] != null &&
        json['nickname'].toString().trim().isNotEmpty) {
      profileName = json['nickname'].toString();
    } else if (json['profilekname'] != null &&
        json['profilekname'].toString().trim().isNotEmpty) {
      profileName = json['profilekname'].toString();
    } else if (json['name'] != null &&
        json['name'].toString().trim().isNotEmpty) {
      profileName = json['name'].toString();
    }

    // 如果仍然没有名称，使用默认值
    if (profileName.isEmpty) {
      profileName =
          '档案 ${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
      debugPrint('未找到有效的档案名称，使用默认名称: $profileName');
    }

    final profile = NutritionProfile(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      profileName: profileName,
      gender: json['gender'] ?? 'other',
      ageGroup: json['ageGroup'] ?? '18_30',
      height: json['height'] != null
          ? double.parse(json['height'].toString())
          : 170.0,
      weight: json['weight'] != null
          ? double.parse(json['weight'].toString())
          : 60.0,
      region: json['region'] != null
          ? Map<String, String>.from(json['region'])
          : null,
      occupation: json['occupation'],
      healthStatus: json['healthStatus'] ??
          {
            'chronicDiseases': [],
            'specialConditions': [],
          },
      dietaryPreferences: json['dietaryPreferences'] ??
          {
            'isVegetarian': false,
            'tastePreference': [],
            'taboos': [],
            'cuisine': 'chinese',
            'allergies': [],
          },
      lifestyle: json['lifestyle'] ??
          {
            'smoking': false,
            'drinking': false,
            'sleepDuration': 8,
            'exerciseFrequency': 'occasional',
          },
      nutritionGoals: json['nutritionGoals'] != null
          ? List<String>.from(json['nutritionGoals']).map((goal) {
              // 映射不兼容的目标值
              if (goal == 'blood_sugar_control') {
                return 'disease_management';
              }
              return goal;
            }).toList()
          : ['general_health'],
      isPrimary: json['isPrimary'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );

    debugPrint('转换后的档案对象: ${profile.toJson()}'); // 添加调试日志
    return profile;
  }

  /**
   * 转换为JSON
   * 
   * 将NutritionProfile对象序列化为JSON格式
   * 用于向服务器发送数据或进行本地存储
   * 
   * @return 表示当前档案的Map对象
   */
  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'userId': userId,
      'profileName': profileName.trim(), // 确保去除空格并一定会传递此字段
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
    if (data['occupation'] == 'labor' ||
        data['occupation'] == 'physical_worker') {
      data['occupation'] = 'physical_worker';
    } else if (data['occupation'] == 'office' ||
        data['occupation'] == 'office_worker') {
      data['occupation'] = 'office_worker';
    }

    // 移除空值字段
    data.removeWhere((key, value) => value == null);

    return data;
  }

  /**
   * 复制健康档案并修改特定字段
   * 
   * 创建当前档案的副本，同时允许更新指定的字段
   * 遵循不可变设计模式，返回一个新对象而不是修改原对象
   * 
   * @param id 新的档案ID（可选）
   * @param userId 新的用户ID（可选）
   * @param profileName 新的档案名称（可选）
   * @param gender 新的性别（可选）
   * @param ageGroup 新的年龄段（可选）
   * @param height 新的身高（可选）
   * @param weight 新的体重（可选）
   * @param region 新的地区信息（可选）
   * @param occupation 新的职业（可选）
   * @param healthStatus 新的健康状况（可选）
   * @param dietaryPreferences 新的饮食偏好（可选）
   * @param lifestyle 新的生活方式（可选）
   * @param nutritionGoals 新的营养目标（可选）
   * @param isPrimary 新的主要档案标识（可选）
   * @param createdAt 新的创建时间（可选）
   * @param updatedAt 新的更新时间（可选）
   * @return 更新后的新NutritionProfile对象
   */
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

  /**
   * 计算BMI（身体质量指数）
   * 
   * 根据用户的身高和体重计算BMI值
   * BMI = 体重(kg) / (身高(m)^2)
   * 
   * @return 计算得到的BMI值，如果身高无效则返回0
   */
  double calculateBMI() {
    if (height <= 0) {
      return 0;
    }
    // BMI = 体重(kg) / (身高(m)^2)
    return weight / ((height / 100) * (height / 100));
  }

  /**
   * 获取BMI类别
   * 
   * 根据计算得到的BMI值确定体重状态类别：
   * - 低于18.5：偏瘦
   * - 18.5-24.9：正常
   * - 25-29.9：超重
   * - 30及以上：肥胖
   * 
   * @return BMI分类的中文描述
   */
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
    return (healthStatus['specialConditions'] as List<dynamic>)
        .map((condition) {
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
