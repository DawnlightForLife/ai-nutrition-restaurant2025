import 'package:flutter/foundation.dart';
import 'dart:convert';

/// 健康数据模型类
/// 存储用户的健康数据信息
class HealthData {
  final String? id;
  final String? userId;
  final Map<String, dynamic>? basicMetrics;
  final Map<String, dynamic>? bloodMetrics;
  final Map<String, dynamic>? profileInfo;
  final Map<String, dynamic>? healthStatus;
  final Map<String, dynamic>? dietaryPreferences;
  final Map<String, dynamic>? lifestyle;
  final List<String>? nutritionGoals;
  final String? nutritionProfileId;
  final bool? syncedToProfile;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// 构造函数
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

  /// 从JSON转换为对象
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

  /// 转换为JSON
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

  /// 创建副本
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

  /// 获取BMI值
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

  /// 获取BMI类别
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

  /// 获取完整度评分
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
  
  /// 从HealthData创建空对象
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
  
  @override
  String toString() {
    return jsonEncode(toJson());
  }
} 