import 'package:flutter/material.dart';

/// 营养推荐档案模型类
/// 与账号本身分开，一个账号可建立多个档案（自己、家人等）
class NutritionProfile {
  final String id; // 档案唯一ID（可由后端生成）
  final String ownerId; // 所属用户账号ID（外键）
  final String name; // 档案名称（如：妈妈、小明）
  final String ageGroup; // 年龄段（如 18-25岁、60岁以上）
  final String gender; // 性别
  final String region; // 地区（省市/简化版）
  final String occupation; // 职业（来自官方分类）
  final double height; // 身高（厘米）
  final double weight; // 体重（公斤）
  final String activityLevel; // 活动水平（轻度、中度、重度）
  final Map<String, dynamic> healthData; // 健康数据，如：血糖、血脂等

  NutritionProfile({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.ageGroup,
    required this.gender,
    required this.region,
    required this.occupation,
    required this.height,
    required this.weight,
    required this.activityLevel,
    required this.healthData,
  });

  /// 工厂构造函数：将 JSON 转换为 NutritionProfile 实例
  factory NutritionProfile.fromJson(Map<String, dynamic> json) {
    return NutritionProfile(
      id: json['_id'] ?? '',
      ownerId: json['ownerId'] ?? '',
      name: json['nickname'] ?? '',
      ageGroup: json['ageGroup'] ?? '',
      gender: json['gender'] ?? '',
      region: json['region'] ?? '',
      occupation: json['occupation'] ?? '',
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      activityLevel: json['activityLevel'] ?? '',
      healthData: json['healthData'] ?? {},
    );
  }

  /// 转换为 JSON，用于传输或存储
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'ageGroup': ageGroup,
      'gender': gender,
      'region': region,
      'occupation': occupation,
      'height': height,
      'weight': weight,
      'activityLevel': activityLevel,
      'healthData': healthData,
    };
  }
}
