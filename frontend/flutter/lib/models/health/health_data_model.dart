import 'package:flutter/foundation.dart';
import 'dart:convert';

/**
 * 健康数据模型类
 * 
 * 用于存储和管理用户的健康相关数据，包括基础健康指标、血液指标、健康状态等
 * 作为健康监测和营养建议的数据基础，支持与营养档案的同步
 */
class HealthData {
  /// 健康数据唯一标识符
  final String? id;
  
  /// 关联的用户ID
  final String? userId;
  
  /// 基础健康指标，包括身高、体重、BMI等
  final Map<String, dynamic>? basicMetrics;
  
  /// 血液健康指标，包括血糖、胆固醇等
  final Map<String, dynamic>? bloodMetrics;
  
  /// 个人基本信息，包括昵称、性别、年龄段等
  final Map<String, dynamic>? profileInfo;
  
  /// 健康状况信息，包括疾病史、过敏史等
  final Map<String, dynamic>? healthStatus;
  
  /// 饮食偏好信息，包括饮食习惯、口味偏好等
  final Map<String, dynamic>? dietaryPreferences;
  
  /// 生活方式信息，包括运动习惯、睡眠情况等
  final Map<String, dynamic>? lifestyle;
  
  /// 营养目标列表，如减肥、增肌、控制血糖等
  final List<String>? nutritionGoals;
  
  /// 关联的营养档案ID
  final String? nutritionProfileId;
  
  /// 是否已同步到营养档案
  final bool? syncedToProfile;
  
  /// 数据创建时间
  final DateTime? createdAt;
  
  /// 数据最后更新时间
  final DateTime? updatedAt;

  /**
   * 健康数据构造函数
   * 
   * 所有参数均为可选，支持部分数据的创建和更新
   * 
   * @param id 数据ID
   * @param userId 用户ID
   * @param basicMetrics 基础健康指标
   * @param bloodMetrics 血液健康指标
   * @param profileInfo 个人基本信息
   * @param healthStatus 健康状况信息
   * @param dietaryPreferences 饮食偏好信息
   * @param lifestyle 生活方式信息
   * @param nutritionGoals 营养目标列表
   * @param nutritionProfileId 关联的营养档案ID
   * @param syncedToProfile 是否已同步到营养档案
   * @param createdAt 创建时间
   * @param updatedAt 更新时间
   */
  HealthData({
    this.id,
    this.userId,
    this.basicMetrics,
    this.bloodMetrics,
    this.profileInfo,
    this.healthStatus,
    this.dietaryPreferences,
    this.lifestyle,
    this.nutritionGoals,
    this.nutritionProfileId,
    this.syncedToProfile,
    this.createdAt,
    this.updatedAt,
  });

  /**
   * 从JSON转换为健康数据对象
   * 
   * 将从服务器或本地存储获取的JSON数据转换为HealthData对象
   * 支持对可能缺失的字段进行处理，确保安全转换
   * 
   * @param json 包含健康数据的Map
   * @return 根据JSON数据创建的HealthData对象
   */
  factory HealthData.fromJson(Map<String, dynamic> json) {
    debugPrint('解析健康数据: $json');
    
    return HealthData(
      id: json['_id'] ?? json['id'],
      userId: json['user_id'],
      basicMetrics: json['basic_metrics'] != null
          ? Map<String, dynamic>.from(json['basic_metrics'])
          : null,
      bloodMetrics: json['blood_metrics'] != null
          ? Map<String, dynamic>.from(json['blood_metrics'])
          : null,
      profileInfo: json['profile_info'] != null
          ? Map<String, dynamic>.from(json['profile_info'])
          : null,
      healthStatus: json['health_status'] != null
          ? Map<String, dynamic>.from(json['health_status'])
          : null,
      dietaryPreferences: json['dietary_preferences'] != null
          ? Map<String, dynamic>.from(json['dietary_preferences'])
          : null,
      lifestyle: json['lifestyle'] != null
          ? Map<String, dynamic>.from(json['lifestyle'])
          : null,
      nutritionGoals: json['nutrition_goals'] != null
          ? List<String>.from(json['nutrition_goals'])
          : null,
      nutritionProfileId: json['nutrition_profile_id'],
      syncedToProfile: json['synced_to_profile'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /**
   * 转换为JSON
   * 
   * 将HealthData对象序列化为JSON格式
   * 仅包含非空字段，减少数据传输量
   * 用于向服务器发送数据或进行本地存储
   * 
   * @return 表示当前健康数据的Map对象，不包含空值
   */
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (id != null) data['id'] = id;
    if (userId != null) data['user_id'] = userId;
    if (basicMetrics != null) data['basic_metrics'] = basicMetrics;
    if (bloodMetrics != null) data['blood_metrics'] = bloodMetrics;
    if (profileInfo != null) data['profile_info'] = profileInfo;
    if (healthStatus != null) data['health_status'] = healthStatus;
    if (dietaryPreferences != null) data['dietary_preferences'] = dietaryPreferences;
    if (lifestyle != null) data['lifestyle'] = lifestyle;
    if (nutritionGoals != null) data['nutrition_goals'] = nutritionGoals;
    if (nutritionProfileId != null) data['nutrition_profile_id'] = nutritionProfileId;
    if (syncedToProfile != null) data['synced_to_profile'] = syncedToProfile;
    
    return data;
  }

  /**
   * 创建健康数据的修改副本
   * 
   * 创建当前健康数据的副本，同时允许更新指定的字段
   * 遵循不可变设计模式，返回一个新对象而不是修改原对象
   * 
   * @param id 新的数据ID（可选）
   * @param userId 新的用户ID（可选）
   * @param basicMetrics 新的基础健康指标（可选）
   * @param bloodMetrics 新的血液健康指标（可选）
   * @param profileInfo 新的个人基本信息（可选）
   * @param healthStatus 新的健康状况信息（可选）
   * @param dietaryPreferences 新的饮食偏好信息（可选）
   * @param lifestyle 新的生活方式信息（可选）
   * @param nutritionGoals 新的营养目标（可选）
   * @param nutritionProfileId 新的营养档案ID（可选）
   * @param syncedToProfile 新的同步状态（可选）
   * @param createdAt 新的创建时间（可选）
   * @param updatedAt 新的更新时间（可选）
   * @return 更新后的新HealthData对象
   */
  HealthData copyWith({
    String? id,
    String? userId,
    Map<String, dynamic>? basicMetrics,
    Map<String, dynamic>? bloodMetrics,
    Map<String, dynamic>? profileInfo,
    Map<String, dynamic>? healthStatus,
    Map<String, dynamic>? dietaryPreferences,
    Map<String, dynamic>? lifestyle,
    List<String>? nutritionGoals,
    String? nutritionProfileId,
    bool? syncedToProfile,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      basicMetrics: basicMetrics ?? this.basicMetrics,
      bloodMetrics: bloodMetrics ?? this.bloodMetrics,
      profileInfo: profileInfo ?? this.profileInfo,
      healthStatus: healthStatus ?? this.healthStatus,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      lifestyle: lifestyle ?? this.lifestyle,
      nutritionGoals: nutritionGoals ?? this.nutritionGoals,
      nutritionProfileId: nutritionProfileId ?? this.nutritionProfileId,
      syncedToProfile: syncedToProfile ?? this.syncedToProfile,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /**
   * 获取BMI值
   * 
   * 计算或获取用户的身体质量指数(BMI)
   * 优先使用已有的BMI值，如果不存在则基于身高和体重计算
   * BMI = 体重(kg) / (身高(m)^2)
   * 
   * @return 用户的BMI值，如果数据不足则返回null
   */
  double? get bmi {
    if (basicMetrics == null) return null;
    
    if (basicMetrics!.containsKey('bmi') && basicMetrics!['bmi'] != null) {
      return double.tryParse(basicMetrics!['bmi'].toString());
    }
    
    if (basicMetrics!.containsKey('height') && 
        basicMetrics!.containsKey('weight') && 
        basicMetrics!['height'] != null && 
        basicMetrics!['weight'] != null) {
      
      final height = double.tryParse(basicMetrics!['height'].toString());
      final weight = double.tryParse(basicMetrics!['weight'].toString());
      
      if (height != null && weight != null && height > 0) {
        // 将身高从厘米转换为米
        final heightInMeters = height / 100;
        // 计算BMI: 体重(kg) / 身高^2(m)
        return weight / (heightInMeters * heightInMeters);
      }
    }
    
    return null;
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
   * @return BMI分类的中文描述，如果无法计算则返回"未知"
   */
  String get bmiCategory {
    final bmiValue = bmi;
    
    if (bmiValue == null) return '未知';
    
    if (bmiValue < 18.5) {
      return '偏瘦';
    } else if (bmiValue < 24.9) {
      return '正常';
    } else if (bmiValue < 29.9) {
      return '超重';
    } else {
      return '肥胖';
    }
  }

  /**
   * 获取健康数据完整度评分
   * 
   * 计算当前健康数据的完整度，基于关键字段的填写情况
   * 评分范围为0-100，分数越高表示数据越完整
   * 
   * @return 数据完整度分数（0-100）
   */
  int get completenessScore {
    int score = 0;
    int totalFields = 0;
    
    // 检查基本指标
    if (basicMetrics != null) {
      totalFields += 3;
      if (basicMetrics!.containsKey('height') && basicMetrics!['height'] != null) score++;
      if (basicMetrics!.containsKey('weight') && basicMetrics!['weight'] != null) score++;
      if (basicMetrics!.containsKey('bmi') && basicMetrics!['bmi'] != null) score++;
    }
    
    // 检查血液指标
    if (bloodMetrics != null) {
      totalFields += 2;
      if (bloodMetrics!.containsKey('glucose') && bloodMetrics!['glucose'] != null) score++;
      if (bloodMetrics!.containsKey('cholesterol') && bloodMetrics!['cholesterol'] != null) score++;
    }
    
    // 检查个人信息
    if (profileInfo != null) {
      totalFields += 3;
      if (profileInfo!.containsKey('nickname') && profileInfo!['nickname'] != null) score++;
      if (profileInfo!.containsKey('gender') && profileInfo!['gender'] != null) score++;
      if (profileInfo!.containsKey('age_group') && profileInfo!['age_group'] != null) score++;
    }
    
    // 检查健康状况
    if (healthStatus != null) {
      totalFields += 2;
      if (healthStatus!.containsKey('chronic_diseases') && healthStatus!['chronic_diseases'] != null) score++;
      if (healthStatus!.containsKey('special_conditions') && healthStatus!['special_conditions'] != null) score++;
    }
    
    // 检查饮食偏好
    if (dietaryPreferences != null) {
      totalFields += 3;
      if (dietaryPreferences!.containsKey('is_vegetarian') && dietaryPreferences!['is_vegetarian'] != null) score++;
      if (dietaryPreferences!.containsKey('taste_preference') && dietaryPreferences!['taste_preference'] != null) score++;
      if (dietaryPreferences!.containsKey('taboos') && dietaryPreferences!['taboos'] != null) score++;
    }
    
    // 检查生活方式
    if (lifestyle != null) {
      totalFields += 4;
      if (lifestyle!.containsKey('smoking') && lifestyle!['smoking'] != null) score++;
      if (lifestyle!.containsKey('drinking') && lifestyle!['drinking'] != null) score++;
      if (lifestyle!.containsKey('sleep_duration') && lifestyle!['sleep_duration'] != null) score++;
      if (lifestyle!.containsKey('exercise_frequency') && lifestyle!['exercise_frequency'] != null) score++;
    }
    
    // 检查营养目标
    if (nutritionGoals != null && nutritionGoals!.isNotEmpty) {
      totalFields += 1;
      score += 1;
    }
    
    // 计算百分比
    return totalFields > 0 ? ((score / totalFields) * 100).round() : 0;
  }
  
  /**
   * 创建空的健康数据对象
   * 
   * 创建一个所有集合类型字段为空而非null的HealthData对象
   * 用于初始化表单或创建新用户的默认健康数据
   * 
   * @return 包含空集合的HealthData对象
   */
  factory HealthData.empty() {
    return HealthData(
      basicMetrics: {},
      bloodMetrics: {},
      profileInfo: {},
      healthStatus: {},
      dietaryPreferences: {},
      lifestyle: {},
      nutritionGoals: [],
      syncedToProfile: false,
    );
  }
  
  /**
   * 将HealthData对象转换为字符串表示
   * 
   * 通过JSON序列化转换为字符串，便于日志记录和调试
   * 
   * @return HealthData对象的JSON字符串表示
   */
  @override
  String toString() {
    return jsonEncode(toJson());
  }
} 