import 'package:equatable/equatable.dart';

/// 营养档案实体
class NutritionProfile extends Equatable {
  final String id;
  final String userId;
  final String name;
  final BasicInfo basicInfo;
  final List<DietaryPreference> dietaryPreferences;
  final List<HealthCondition> healthConditions;
  final LifestyleHabits lifestyleHabits;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NutritionProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.basicInfo,
    required this.dietaryPreferences,
    required this.healthConditions,
    required this.lifestyleHabits,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        basicInfo,
        dietaryPreferences,
        healthConditions,
        lifestyleHabits,
        createdAt,
        updatedAt,
      ];
}

/// 基本信息
class BasicInfo extends Equatable {
  final int age;
  final Gender gender;
  final double height; // cm
  final double weight; // kg
  final double? targetWeight; // kg
  final ActivityLevel activityLevel;

  const BasicInfo({
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    this.targetWeight,
    required this.activityLevel,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  @override
  List<Object?> get props => [age, gender, height, weight, targetWeight, activityLevel];
}

/// 饮食偏好
class DietaryPreference extends Equatable {
  final String id;
  final String name;
  final String description;

  const DietaryPreference({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, description];
}

/// 健康状况
class HealthCondition extends Equatable {
  final String id;
  final String name;
  final String description;
  final ConditionSeverity severity;

  const HealthCondition({
    required this.id,
    required this.name,
    required this.description,
    required this.severity,
  });

  @override
  List<Object?> get props => [id, name, description, severity];
}

/// 生活习惯
class LifestyleHabits extends Equatable {
  final SleepPattern sleepPattern;
  final ExerciseFrequency exerciseFrequency;
  final int dailyWaterIntake; // ml
  final bool smokingStatus;
  final AlcoholConsumption alcoholConsumption;

  const LifestyleHabits({
    required this.sleepPattern,
    required this.exerciseFrequency,
    required this.dailyWaterIntake,
    required this.smokingStatus,
    required this.alcoholConsumption,
  });

  @override
  List<Object?> get props => [
        sleepPattern,
        exerciseFrequency,
        dailyWaterIntake,
        smokingStatus,
        alcoholConsumption,
      ];
}

// 枚举类型
enum Gender { male, female, other }

enum ActivityLevel { sedentary, light, moderate, active, veryActive }

enum ConditionSeverity { mild, moderate, severe }

enum SleepPattern { regular, irregular, insufficient }

enum ExerciseFrequency { never, rarely, sometimes, often, daily }

enum AlcoholConsumption { never, occasionally, moderate, frequent }