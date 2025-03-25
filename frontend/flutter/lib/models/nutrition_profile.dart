import 'package:flutter/material.dart';

/// 营养推荐档案模型类
/// 与账号本身分开，一个账号可建立多个档案（自己、家人等）
class NutritionProfile {
  final String id;
  final String ownerId;
  final String name;
  final String? gender;
  final int? age;
  final double? height;
  final double? weight;
  final String? activityLevel;
  final List<String>? healthConditions;
  final DietaryPreferences? dietaryPreferences;
  final String? goals;
  final DateTime createdAt;
  final DateTime updatedAt;

  NutritionProfile({
    required this.id,
    required this.ownerId,
    required this.name,
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.activityLevel,
    this.healthConditions,
    this.dietaryPreferences,
    this.goals,
    required this.createdAt,
    required this.updatedAt,
  });

  // 计算BMI指数
  double? get bmi {
    if (height != null && weight != null && height! > 0) {
      return weight! / ((height! / 100) * (height! / 100));
    }
    return null;
  }

  /// 工厂构造函数：将 JSON 转换为 NutritionProfile 实例
  factory NutritionProfile.fromJson(Map<String, dynamic> json) {
    return NutritionProfile(
      id: json['_id'],
      ownerId: json['ownerId'],
      name: json['name'],
      gender: json['gender'],
      age: json['age'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      activityLevel: json['activityLevel'],
      healthConditions: json['healthConditions'] != null
          ? List<String>.from(json['healthConditions'])
          : null,
      dietaryPreferences: json['dietaryPreferences'] != null
          ? DietaryPreferences.fromJson(json['dietaryPreferences'])
          : null,
      goals: json['goals'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// 转换为 JSON，用于传输或存储
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'ownerId': ownerId,
      'name': name,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'activityLevel': activityLevel,
      'healthConditions': healthConditions,
      'dietaryPreferences': dietaryPreferences?.toJson(),
      'goals': goals,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class DietaryPreferences {
  final String? cuisinePreference;
  final String? spicyPreference;
  final List<String>? allergies;
  final List<String>? avoidedIngredients;

  DietaryPreferences({
    this.cuisinePreference,
    this.spicyPreference,
    this.allergies,
    this.avoidedIngredients,
  });

  factory DietaryPreferences.fromJson(Map<String, dynamic> json) {
    return DietaryPreferences(
      cuisinePreference: json['cuisinePreference'],
      spicyPreference: json['spicyPreference'],
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : null,
      avoidedIngredients: json['avoidedIngredients'] != null
          ? List<String>.from(json['avoidedIngredients'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cuisinePreference': cuisinePreference,
      'spicyPreference': spicyPreference,
      'allergies': allergies,
      'avoidedIngredients': avoidedIngredients,
    };
  }
}
